module Node.Crypto.LowLevel
    exposing
        ( encrypt
        , decrypt
        )

import Node.Buffer exposing (Buffer)
import Json.Decode as Decode
import Native.Crypto


encrypt : String -> String -> Buffer -> Result Decode.Value Buffer
encrypt =
    Native.Crypto.encrypt


decrypt : String -> String -> Buffer -> Result Decode.Value Buffer
decrypt =
    Native.Crypto.decrypt
