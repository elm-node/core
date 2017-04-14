module Node.Common
    exposing
        ( Encoding(..)
        , encodingToString
        )

{-| Common types across node packages

@docs Encoding , encodingToString

-}

import String


{-| -}
type Encoding
    = Ascii
    | Utf8
    | Utf16le
    | Base64
    | Latin1
    | Hex


{-| -}
encodingToString : Encoding -> String
encodingToString =
    toString >> String.toLower
