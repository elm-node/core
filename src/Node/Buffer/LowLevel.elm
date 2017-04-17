module Node.Buffer.LowLevel
    exposing
        ( Buffer
        , fromString
        , toString
        )

import Json.Decode as Decode
import Native.Buffer


type Buffer
    = Buffer


fromString : String -> String -> Result Decode.Value Buffer
fromString =
    Native.Buffer.fromString


toString : String -> Buffer -> Result Decode.Value String
toString =
    Native.Buffer.toString
