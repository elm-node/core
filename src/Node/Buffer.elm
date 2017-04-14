module Node.Buffer
    exposing
        ( Buffer
        , toString
        )

{-| Native bindings for Buffer module.

@docs Buffer , toString

-}

import Node.Common as Common exposing (Encoding)
import Native.Buffer


{-| Buffer

buffer is an instance of Uint8Array
buffers are not copied automatically, they create a view above the root buffer

-}
type Buffer
    = Buffer


{-| Convert a Buffer to a String.
-}
toString : Encoding -> Buffer -> Result String String
toString encoding =
    Native.Buffer.toString (Common.encodingToString encoding)
