module Node.FileSystem
    exposing
        ( FileType(..)
        , Stats
        , copy
        , defaultEncoding
        , defaultMode
        , exists
        , mkdirp
        , readFile
        , readFileAsString
        , remove
        , rename
        , statistics
        , symbolicLink
        , writeFile
        , writeFileFromString
        )

{-| FileSystem

@docs defaultEncoding , defaultMode


## Query

@docs Stats , FileType , exists , statistics


## Manage

@docs copy , mkdirp , remove , rename , symbolicLink


## Read

@docs readFile , readFileAsString


## Write

@docs writeFile , writeFileFromString

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
import Node.OperatingSystem as OperatingSystem
import Node.Path as Path
import Result.Extra as Result
import Task exposing (Task)
import Time exposing (Time)


{-| Default encoding (Utf8).
-}
defaultEncoding : Encoding
defaultEncoding =
    Utf8


type alias Mode =
    String


{-| Default mode (Read and Write access for Owner, Group, and Others).
-}
defaultMode : Mode
defaultMode =
    "666"



-- QUERY


{-| Path types.
-}
type FileType
    = File
    | Directory
    | Socket
    | SymbolicLink


fileTypeFromString : String -> Result String FileType
fileTypeFromString string =
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
            Err <| "Value not recognized: " ++ string


{-| Path statistics.
-}
type alias Stats =
    { type_ : FileType
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
                                        fileTypeFromString type_ |> Result.unpack Decode.fail Decode.succeed
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


{-| Check whether a path exists.
-}
exists : String -> Task Error Bool
exists path =
    LowLevel.exists path
        |> Task.mapError Error.fromValue


{-| Get statistics for a given path.
-}
statistics : String -> Task Error Stats
statistics path =
    LowLevel.stat path
        |> Task.mapError Error.fromValue
        |> Task.andThen
            (statsFromValue >> Result.unpack (Error "" >> Task.fail) Task.succeed)



-- MANAGEMENT


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


{-| Remove a file or directory recursively.
-}
remove : String -> Task Error ()
remove filename =
    LowLevel.remove filename
        |> Task.mapError Error.fromValue


{-| Rename a file.
-}
rename : String -> String -> Task Error ()
rename from to =
    LowLevel.rename from to
        |> Task.mapError Error.fromValue


type SymbolicLinkType
    = SymbolicLinkFile
    | SymbolicLinkDirectory


symbolicLinkTypetoString : SymbolicLinkType -> String
symbolicLinkTypetoString symbolicLinkType =
    case symbolicLinkType of
        SymbolicLinkFile ->
            "file"

        SymbolicLinkDirectory ->
            "dir"


{-| Make a symbolic link.
-}
symbolicLink : String -> String -> Task Error ()
symbolicLink from to =
    let
        resolveWindowsSymbolicLinkType path =
            statistics path
                |> Task.andThen
                    (\{ type_ } ->
                        case type_ of
                            Directory ->
                                Task.succeed SymbolicLinkDirectory

                            File ->
                                Task.succeed SymbolicLinkFile

                            _ ->
                                Task.fail <|
                                    Error
                                        ("Symbolic link type could not be resolved: Unsupported file type: " ++ toString type_)
                                        ""
                    )
    in
        OperatingSystem.platform
            |> Result.unpack
                Task.fail
                (\platform ->
                    case platform of
                        OperatingSystem.Windows ->
                            resolveWindowsSymbolicLinkType from

                        _ ->
                            Task.succeed SymbolicLinkFile
                )
            |> Task.andThen
                (\symbolicLinkType ->
                    LowLevel.symlink from to (symbolicLinkTypetoString symbolicLinkType)
                        |> Task.mapError Error.fromValue
                )



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



-- WRITE


{-| Make a directory using the given directory name.

Non-existent directories in the path will be created.

-}
mkdirp : String -> Task Error ()
mkdirp dirname =
    LowLevel.mkdirp dirname
        |> Task.mapError Error.fromValue


{-| Write a file from a Buffer.

Non-existent directories in the filename path will be created.

-}
writeFile : String -> Mode -> Buffer -> Task Error ()
writeFile path mode buffer =
    stringToInt 8 mode
        |> Result.unpack Task.fail Task.succeed
        |> Task.andThen
            (\mode ->
                let
                    dirname =
                        Path.dirname path

                    writeFile =
                        LowLevel.writeFile path mode buffer
                            |> Task.mapError Error.fromValue
                in
                    Task.sequence
                        [ mkdirp dirname
                        , writeFile
                        ]
                        |> Task.map (always ())
            )


{-| Write a file from a String.

Non-existent directories in the file's path will be created.

-}
writeFileFromString : String -> Mode -> Encoding -> String -> Task Error ()
writeFileFromString path mode encoding data =
    Buffer.fromString encoding data
        |> Result.unpack Task.fail Task.succeed
        |> Task.andThen (writeFile path mode)
