module Node.Global
    exposing
        ( parseInt
        )

{-| Global functions

@docs parseInt

-}

import Node.Global.LowLevel as LowLevel
import Node.Error as Error exposing (Error)


{-| -}
parseInt : Int -> String -> Result Error Int
parseInt radix string =
    LowLevel.parseInt radix string
        |> Result.mapError Error.fromValue
