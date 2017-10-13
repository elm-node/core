module Node.Encoding
    exposing
        ( Encoding(..)
        , toString
        )

{-| String encodings supported by Node.js.

@docs Encoding , toString

-}

import String


{-| Encoding union type.
-}
type Encoding
    = Ascii
    | Utf8
    | Utf16le
    | Base64
    | Latin1
    | Hex


{-| Convert encoding to string.
-}
toString : Encoding -> String
toString =
    Basics.toString >> String.toLower
