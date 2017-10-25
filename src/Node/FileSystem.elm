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
        , symlink
        )

{-| FileSystem

@docs copy , defaultEncoding , defaultMode , exists , mkdirp , readFile , readFileAsString , remove , rename , writeFile , writeFileFromString , writeFileFromBuffer , isSymlink , symlink

-}

import Dict exposing (Dict)
import Json.Decode as Decode
import List.Extra as List
import Node.Buffer as Buffer exposing (Buffer)
import Node.Encoding as Encoding exposing (Encoding(..))
import Node.Error as Error exposing (Error(..))
import Node.FileSystem.LowLevel as LowLevel
import Node.Global exposing (stringToInt)
import Node.Path as Path
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


{-| Write a file from a Buffer with the default file mode.

Non-existent directories in the filename path will be created.

-}
writeFile : String -> Mode -> Buffer -> Task Error ()
writeFile filename mode buffer =
    stringToInt 8 mode
        |> Result.unpack Task.fail Task.succeed
        |> Task.andThen
            (\mode ->
                let
                    dirname =
                        Path.dirname filename

                    writeFile =
                        LowLevel.writeFile filename mode buffer
                            |> Task.mapError Error.fromValue
                in
                    Task.sequence
                        [ mkdirp dirname
                        , writeFile
                        ]
                        |> Task.map (always ())
            )


{-| Write a file from a String.

Non-existent directories in the filename path will be created.

-}
writeFileFromString : String -> Mode -> Encoding -> String -> Task Error ()
writeFileFromString filename mode encoding data =
    Buffer.fromString encoding data
        |> Result.unpack Task.fail Task.succeed
        |> Task.andThen (writeFile filename mode)


{-| Write a file from a Buffer.

Non-existent directories in the filename path will be created.

-}
writeFileFromBuffer : String -> Mode -> Buffer -> Task Error ()
writeFileFromBuffer filename mode buffer =
    writeFile filename mode buffer


{-| Check whether a file exists.
-}
exists : String -> Task Error Bool
exists filename =
    --TODO consider removing, see how used, introduces race condition if used to check before read/write
    LowLevel.exists filename
        |> Task.mapError Error.fromValue


{-| Make a directory using the given directory name.

Non-existent directories in the path will be created.

-}
mkdirp : String -> Task Error ()
mkdirp dirname =
    LowLevel.mkdirp dirname
        |> Task.mapError Error.fromValue


{-| Rename a file.
-}
rename : String -> String -> Task Error ()
rename from to =
    LowLevel.rename from to
        |> Task.mapError Error.fromValue



--TODO add `stat: String -> Task Error Stats`


{-| Check whether a file is a symbolic link.
-}
isSymlink : String -> Task Error Bool
isSymlink filename =
    --TODO replace with `statLink: String -> Task Error Stats` where Stats is a decoded value
    LowLevel.isSymlink filename
        |> Task.mapError Error.fromValue


{-| Make a symbolic link.
-}
symlink : String -> String -> Task Error ()
symlink target filename =
    LowLevel.symlink target filename
        |> Task.mapError Error.fromValue
