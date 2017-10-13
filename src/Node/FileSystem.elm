module Node.FileSystem
    exposing
        ( copy
        , defaultEncoding
        , defaultMode
        , readFile
        , readFileAsString
        , remove
        , writeFile
        , writeFileFromBuffer
        , writeFileFromString
        , exists
        , mkdirp
        , rename
        , isSymlink
        , makeSymlink
        )

{-| FileSystem

@docs copy , defaultEncoding , defaultMode , exists , mkdirp , readFile , readFileAsString , remove , rename , writeFile , writeFileFromString , writeFileFromBuffer , isSymlink , makeSymlink

-}

import Dict exposing (Dict)
import Json.Decode as Decode
import List.Extra as List
import Node.Buffer exposing (Buffer)
import Node.Encoding as Encoding exposing (Encoding(..))
import Node.Error as Error exposing (Error(..))
import Node.FileSystem.LowLevel as LowLevel
import Result.Extra as Result
import Task exposing (Task)


{-| Default encoding.
-}
defaultEncoding : Encoding
defaultEncoding =
    Utf8



-- COPY


{-| Copy a file or directory recursively.
-}
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


{-| Read a file as a Buffer.
-}
readFile : String -> Task Error Buffer
readFile filename =
    LowLevel.readFileAsBuffer filename
        |> Task.mapError Error.fromValue


{-| Read a file as a string.
-}
readFileAsString : String -> Encoding -> Task Error String
readFileAsString filename encoding =
    LowLevel.readFileAsString filename (Encoding.toString encoding)
        |> Task.mapError Error.fromValue



-- REMOVE


{-| Remove a file or directory recursively.
-}
remove : String -> Task Error ()
remove filename =
    LowLevel.remove filename
        |> Task.mapError Error.fromValue



-- WRITE


type alias Mode =
    String


{-| Default mode.
-}
defaultMode : String
defaultMode =
    "666"


{-| Write a file from a Buffer with the default file mode.

Non-existent directories in the filename path will be created.

-}
writeFile : String -> Buffer -> Task Error ()
writeFile filename data =
    LowLevel.writeFileFromBuffer filename defaultMode data
        |> Task.mapError Error.fromValue


{-| Write a file from a String.

Non-existent directories in the filename path will be created.

-}
writeFileFromString : String -> Mode -> Encoding -> String -> Task Error ()
writeFileFromString filename mode encoding data =
    LowLevel.writeFileFromString filename mode (Encoding.toString encoding) data
        |> Task.mapError Error.fromValue


{-| Write a file from a Buffer.

Non-existent directories in the filename path will be created.

-}
writeFileFromBuffer : String -> Mode -> Buffer -> Task Error ()
writeFileFromBuffer filename mode data =
    LowLevel.writeFileFromBuffer filename mode data
        |> Task.mapError Error.fromValue


{-| Check whether a file exists.
-}
exists : String -> Task Error Bool
exists filename =
    LowLevel.exists filename
        |> Task.mapError Error.fromValue


{-| Make a directory.

Non-existent directories in the path will be created.

-}
mkdirp : String -> Task Error ()
mkdirp filename =
    LowLevel.mkdirp filename
        |> Task.mapError Error.fromValue


{-| Rename a file.
-}
rename : String -> String -> Task Error ()
rename from to =
    LowLevel.rename from to
        |> Task.mapError Error.fromValue


{-| Check whether a file is a symbolic link.
-}
isSymlink : String -> Task Error Bool
isSymlink filename =
    LowLevel.isSymlink filename
        |> Task.mapError Error.fromValue


{-| Make a symbolic link.
-}
makeSymlink : String -> String -> String -> Task Error ()
makeSymlink target filename type_ =
    --TODO rename to symlink
    --TODO remove type support
    LowLevel.makeSymlink target filename type_
        |> Task.mapError Error.fromValue
