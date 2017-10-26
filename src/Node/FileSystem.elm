module Node.FileSystem
    exposing
        ( PathType(..)
        , Stats
        , copy
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
        , stat
        , symlink
        )

{-| FileSystem

@docs PathType , Stats, copy , defaultEncoding , defaultMode , exists , mkdirp , readFile , readFileAsString , remove , rename , writeFile , writeFileFromString , writeFileFromBuffer , stat , symlink

-}

import Dict exposing (Dict)
import Json.Decode as Decode
import Json.Decode.Extra as Decode
import List.Extra as List
import Node.Buffer as Buffer exposing (Buffer)
import Node.Encoding as Encoding exposing (Encoding(..))
import Node.Error as Error exposing (Error(..))
import Node.FileSystem.LowLevel as LowLevel
import Node.Global exposing (intToString, stringToInt)
import Node.Path as Path
import Result.Extra as Result
import Task exposing (Task)
import Time exposing (Time)


{-| Default encoding.
-}
defaultEncoding : Encoding
defaultEncoding =
    Utf8


{-| Path types.
-}
type PathType
    = File
    | Directory
    | Socket
    | SymbolicLink


pathTypeFromString : String -> Result String PathType
pathTypeFromString string =
    case string of
        "isDirectory" ->
            Ok Directory

        "isFile" ->
            Ok File

        "isSocket" ->
            Ok Socket

        "isSymbolicLink" ->
            Ok SymbolicLink

        _ ->
            Err "Value not recognized."


{-| Statistics.
-}
type alias Stats =
    { type_ : PathType
    , size : Int
    , mode : Mode
    , accessed : Time
    , modified : Time
    , changed : Time
    , created : Time
    }


statsFromValue : Decode.Value -> Result String Stats
statsFromValue =
    Decode.decodeValue <|
        (Decode.succeed Stats
            |> Decode.andMap
                (Decode.map4
                    (\isDirectory isFile isSocket isSymbolicLink ->
                        Dict.fromList
                            [ ( "isDirectory", isDirectory )
                            , ( "isFile", isFile )
                            , ( "isSocket", isSocket )
                            , ( "isSymbolicLink", isSymbolicLink )
                            ]
                            |> Dict.filter (\key value -> value)
                            |> Dict.keys
                    )
                    (Decode.field "isDirectory" Decode.bool)
                    (Decode.field "isFile" Decode.bool)
                    (Decode.field "isSocket" Decode.bool)
                    (Decode.field "isSymbolicLink" Decode.bool)
                    |> Decode.andThen
                        (\types ->
                            if List.length types > 1 then
                                Decode.fail "More than one type was specified."
                            else
                                case List.head types of
                                    Nothing ->
                                        Decode.fail "No types were specified."

                                    Just type_ ->
                                        pathTypeFromString type_ |> Result.unpack Decode.fail Decode.succeed
                        )
                )
            |> Decode.andMap (Decode.field "size" Decode.int)
            |> Decode.andMap
                (Decode.field "mode" <|
                    Decode.andThen
                        (intToString 8 >> Result.mapError Error.message >> Decode.fromResult)
                        Decode.int
                )
            |> Decode.andMap (Decode.field "atimeMs" Decode.float)
            |> Decode.andMap (Decode.field "mtimeMs" Decode.float)
            |> Decode.andMap (Decode.field "ctimeMs" Decode.float)
            |> Decode.andMap (Decode.field "birthtimeMs" Decode.float)
        )



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


{-| Check whether a file is a symbolic link.
-}
stat : String -> Task Error Stats
stat filename =
    LowLevel.stat filename
        |> Task.mapError Error.fromValue
        |> Task.andThen
            (statsFromValue >> Result.unpack (Error "" >> Task.fail) Task.succeed)



--TODO add `realpath: String -> Task Error String`


{-| Make a symbolic link.
-}
symlink : String -> String -> Task Error ()
symlink from to =
    LowLevel.symlink from to
        |> Task.mapError Error.fromValue
