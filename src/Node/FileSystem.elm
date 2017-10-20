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
import Node.Buffer as Buffer exposing (Buffer)
import Node.Encoding as Encoding exposing (Encoding(..))
import Node.Error as Error exposing (Error(..))
import Node.FileSystem.LowLevel as LowLevel
import Node.Global exposing (parseInt)
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
    LowLevel.readFile filename
        |> Task.mapError Error.fromValue


{-| Read a file as a string.
-}
readFileAsString : String -> Encoding -> Task Error String
readFileAsString filename encoding =
    LowLevel.readFile filename
        |> Task.mapError Error.fromValue
        |> Task.andThen (Buffer.toString encoding >> Result.unpack Task.fail Task.succeed)



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


writeFileInternal : String -> Mode -> Buffer -> Task Error ()
writeFileInternal filename mode buffer =
    --TODO move mkdirp here instead of native code
    --(need to alter mkdirp first to take dirname instead of filename)
    --(also need a path.dirname equivalent in elm)
    case parseInt 8 mode of
        Ok mode ->
            LowLevel.writeFile filename mode buffer
                |> Task.mapError Error.fromValue

        Err error ->
            Task.fail error


{-| Write a file from a Buffer with the default file mode.

Non-existent directories in the filename path will be created.

-}
writeFile : String -> Buffer -> Task Error ()
writeFile filename buffer =
    writeFileInternal filename defaultMode buffer


{-| Write a file from a String.

Non-existent directories in the filename path will be created.

-}
writeFileFromString : String -> Mode -> Encoding -> String -> Task Error ()
writeFileFromString filename mode encoding data =
    (Buffer.fromString encoding data |> Result.unpack Task.fail Task.succeed)
        |> Task.andThen (writeFileInternal filename mode)


{-| Write a file from a Buffer.

Non-existent directories in the filename path will be created.

-}
writeFileFromBuffer : String -> Mode -> Buffer -> Task Error ()
writeFileFromBuffer filename mode buffer =
    writeFileInternal filename mode buffer


{-| Check whether a file exists.
-}
exists : String -> Task Error Bool
exists filename =
    --TODO consider removing, see how used, introduces race condition if used to check before read/write
    LowLevel.exists filename
        |> Task.mapError Error.fromValue


{-| Make a directory.

Non-existent directories in the path will be created.

-}
mkdirp : String -> Task Error ()
mkdirp filename =
    --TODO check usage, should be dirname instead of filename here.
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
    --TODO replace with `statLink: String -> Task Error Stats` where Stats is a decoded value
    --TODO add `stat: String -> Task Error Stats`
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
