module Node.FileSystem
    exposing
        ( Error(..)
        , readFile
        , readFileAsString
        , readFileAsBuffer
        , writeFile
        , writeFileFromString
        , writeFileFromBuffer
        )

{-| FileSystem

@docs Error , readFile , readFileAsString , readFileAsBuffer , writeFile , writeFileFromString , writeFileFromBuffer

-}

import Node.Buffer exposing (Buffer)
import Node.Common as Common exposing (Encoding(..))
import Task exposing (Task)
import Native.FileSystem


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


{-| -}
type Error
    = PermissionDenied -- EACCES
    | OperationNotPermitted -- EPERM
    | NoSuchFileOrDirectory -- ENOENT
    | NotADirectory -- ENOTDIR
    | IsADirectory -- EISDIR
    | DirectoryNotEmpty -- ENOTEMPTY
    | FileExists -- EEEXIST
    | FileTooLarge -- EFBIG
    | FilenameTooLong -- ENAMETOOLONG
    | TooManyOpenFiles -- EMFILE, ENFILE
    | NotEnoughSpace -- ENOMEM, ENOSPC
    | DiskQuotaExceeded -- EDQUOT
    | ReadOnlyFileSystem -- EROFS
    | Error String -- anything else



-- READ


{-| -}
readFile : String -> Task Error String
readFile filename =
    Native.FileSystem.readFileAsString filename (Common.encodingToString defaultEncoding)


{-| -}
readFileAsString : String -> Encoding -> Task Error String
readFileAsString filename encoding =
    Native.FileSystem.readFileAsString filename (Common.encodingToString encoding)


{-| -}
readFileAsBuffer : String -> Task Error Buffer
readFileAsBuffer =
    Native.FileSystem.readFileAsBuffer



-- WRITE


{-| Write a file.
-}
writeFile : String -> String -> Task Error ()
writeFile filename =
    Native.FileSystem.writeFileFromString filename defaultMode (Common.encodingToString defaultEncoding)


{-| -}
writeFileFromString : String -> Mode -> Encoding -> String -> Task Error ()
writeFileFromString filename mode encoding =
    Native.FileSystem.writeFileFromString filename mode (Common.encodingToString encoding)


{-| -}
writeFileFromBuffer : String -> Mode -> Buffer -> Task Error ()
writeFileFromBuffer =
    Native.FileSystem.writeFileFromBuffer
