module Node.Global
    exposing
        ( intToString
        , stringToInt
        )

{-| Global functions

@docs intToString , stringToInt

-}

import Node.Global.LowLevel as LowLevel
import Node.Error as Error exposing (Error)


{-| Convert a string into an integer using the specified radix.
-}
stringToInt : Int -> String -> Result Error Int
stringToInt radix string =
    LowLevel.parseInt radix string
        |> Result.mapError Error.fromValue


{-| Convert an integer into a string using the specified radix.
-}
intToString : Int -> Int -> Result Error String
intToString radix integer =
    LowLevel.toString radix integer
        |> Result.mapError Error.fromValue
