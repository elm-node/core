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
parseInt : String -> Int -> Result Error Int
parseInt string radix =
    LowLevel.parseInt string radix
        |> Result.mapError Error.fromValue
