module Node.Global
    exposing
        ( stringToInt
        )

{-| Global functions

@docs stringToInt

-}

import Node.Global.LowLevel as LowLevel
import Node.Error as Error exposing (Error)


{-| Convert a string into an integer using the specified radix.
-}
stringToInt : Int -> String -> Result Error Int
stringToInt radix string =
    LowLevel.parseInt radix string
        |> Result.mapError Error.fromValue
