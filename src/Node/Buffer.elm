module Node.Buffer
    exposing
        ( Buffer
        , fromString
        , toString
        )

{-| Native bindings for Buffer module.

@docs Buffer , fromString , toString

-}

import Node.Common as Common exposing (Encoding)
import Native.Buffer


{-| Buffer

buffer is an instance of Uint8Array
buffers are not copied automatically, they create a view above the root buffer

-}
type Buffer
    = Buffer


{-| Convert a String to a Buffer.
-}
fromString : Encoding -> String -> Result String Buffer
fromString encoding =
    Native.Buffer.fromString (Common.encodingToString encoding)


{-| Convert a Buffer to a String.
-}
toString : Encoding -> Buffer -> Result String String
toString encoding =
    Native.Buffer.toString (Common.encodingToString encoding)
