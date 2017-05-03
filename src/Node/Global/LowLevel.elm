module Node.Global.LowLevel
    exposing
        ( parseInt
        )

import Json.Decode as Decode
import Native.Global


parseInt : Int -> String -> Result Decode.Value Int
parseInt =
    Native.Global.parseInt
