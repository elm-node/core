module Node.FileSystem
    exposing
        ( readFile
        , readFileAsString
        , writeFile
        , writeFileFromString
        , writeFileFromBuffer
        )

{-| FileSystem

@docs readFile , readFileAsString , writeFile , writeFileFromString , writeFileFromBuffer

-}

import Node.Buffer exposing (Buffer)
import Node.Error as Error exposing (Error(..))
import Node.Encoding as Encoding exposing (Encoding(..))
import Node.FileSystem.LowLevel as LowLevel
import Task exposing (Task)


{-| Default encoding.
-}
defaultEncoding : Encoding
defaultEncoding =
    Utf8


type alias Mode =
    String


{-| Default mode.

Read and write permissions for user, group, and others.

-}
defaultMode : String
defaultMode =
    "666"



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
