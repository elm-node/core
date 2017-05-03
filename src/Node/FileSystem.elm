module Node.FileSystem
    exposing
        ( copy
        , readFile
        , readFileAsString
        , writeFile
        , writeFileFromString
        , writeFileFromBuffer
        )

{-| FileSystem

@docs copy , readFile , readFileAsString , writeFile , writeFileFromString , writeFileFromBuffer

-}

import Node.Buffer exposing (Buffer)
import Node.Error as Error exposing (Error(..))
import Node.Encoding as Encoding exposing (Encoding(..))
import Node.FileSystem.LowLevel as LowLevel
import Dict exposing (Dict)
import Json.Decode as Decode
import List.Extra as List
import Result.Extra as Result
import Task exposing (Task)


{-| Default encoding.
-}
defaultEncoding : Encoding
defaultEncoding =
    Utf8



-- COPY
{-

   if no error -> Task.succeed <| Dict String (Result Error ())
   if error.list -> Task.succeed <| Dict String (Result Error ())
   if no error list -> Task.fail Error

   decode error
   decode object, files array, error array
   intersect files array and error array to create Dict of results
-}


{-| -}
copy : Bool -> String -> String -> Task Error (Dict String (Result Error ()))
copy overwrite to from =
    let
        decode =
            Decode.decodeValue <|
                Decode.map2
                    (\errors files ->
                        List.foldl
                            (\filename results ->
                                let
                                    error =
                                        List.find (Error.message >> String.contains filename) errors

                                    result =
                                        error
                                            |> Maybe.map Err
                                            |> Maybe.withDefault (Ok ())
                                in
                                    Dict.insert filename result results
                            )
                            Dict.empty
                            files
                    )
                    (Decode.field "errors" <| Decode.list Error.decoder)
                    (Decode.field "files" <| Decode.list Decode.string)
    in
        LowLevel.copy overwrite to from
            |> Task.mapError Error.fromValue
            |> Task.andThen (decode >> Result.unpack (Error "FileSystem" >> Task.fail) Task.succeed)



-- READ


{-| -}
readFile : String -> Task Error Buffer
readFile filename =
    LowLevel.readFileAsBuffer filename
        |> Task.mapError Error.fromValue


{-| -}
readFileAsString : String -> Encoding -> Task Error String
readFileAsString filename encoding =
    LowLevel.readFileAsString filename (Encoding.toString encoding)
        |> Task.mapError Error.fromValue



-- WRITE


type alias Mode =
    String


{-| Default mode.

Read and write permissions for user, group, and others.

-}
defaultMode : String
defaultMode =
    "666"


{-| Write a file.
-}
writeFile : String -> Buffer -> Task Error ()
writeFile filename data =
    LowLevel.writeFileFromBuffer filename defaultMode data
        |> Task.mapError Error.fromValue


{-| -}
writeFileFromString : String -> Mode -> Encoding -> String -> Task Error ()
writeFileFromString filename mode encoding data =
    LowLevel.writeFileFromString filename mode (Encoding.toString encoding) data
        |> Task.mapError Error.fromValue


{-| -}
writeFileFromBuffer : String -> Mode -> Buffer -> Task Error ()
writeFileFromBuffer filename mode data =
    LowLevel.writeFileFromBuffer filename mode data
        |> Task.mapError Error.fromValue
