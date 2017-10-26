module Node.Process
    exposing
        ( cwd
        , environment
        )

{-| Process

@docs cwd , environment

-}

import Dict exposing (Dict)
import Json.Decode as Decode
import Node.Error as Error exposing (Error(..))
import Node.Process.LowLevel as LowLevel
import Task exposing (Task)


{-| Current working directory.
-}
cwd : () -> Task Error String
cwd t0 =
    LowLevel.cwd t0
        |> Task.mapError Error.fromValue


{-| Environment variables.
-}
environment : Result String (Dict String String)
environment =
    Decode.decodeValue (Decode.dict Decode.string) LowLevel.env
