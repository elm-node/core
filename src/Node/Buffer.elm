module Node.Buffer
    exposing
        ( Buffer
        , fromString
        , toString
        )

{-| Native bindings for Buffer module.

@docs Buffer , fromString , toString

-}

import Node.Buffer.LowLevel as LowLevel exposing (Buffer)
import Node.Encoding as Encoding exposing (Encoding)
import Node.Error as Error exposing (Error)


{-| Buffer type.
-}
type alias Buffer =
    LowLevel.Buffer


{-| Convert a String to a Buffer.
-}
fromString : Encoding -> String -> Result Error Buffer
fromString encoding data =
    LowLevel.fromString (Encoding.toString encoding) data
        |> Result.mapError Error.fromValue


{-| Convert a Buffer to a String.
-}
toString : Encoding -> Buffer -> Result Error String
toString encoding data =
    LowLevel.toString (Encoding.toString encoding) data
        |> Result.mapError Error.fromValue
