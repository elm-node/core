module Node.Buffer.LowLevel
    exposing
        ( Buffer
        , fromString
        , toString
        )

import Json.Decode as Decode


type Buffer
    = Buffer


fromString : String -> String -> Result Decode.Value Buffer
fromString encoding =
    Native.Buffer.fromString


toString : String -> Buffer -> Result Decode.Value String
toString encoding =
    Native.Buffer.toString
