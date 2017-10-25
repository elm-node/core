module Node.Global.LowLevel
    exposing
        ( parseInt
        , toString
        )

import Json.Decode as Decode
import Native.Global


parseInt : Int -> String -> Result Decode.Value Int
parseInt =
    Native.Global.parseInt


toString : Int -> Int -> Result Decode.Value String
toString =
    Native.Global.toString
