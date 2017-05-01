module Node.Crypto.LowLevel
    exposing
        ( encrypt
        , decrypt
        , randomBytes
        )

import Node.Buffer exposing (Buffer)
import Json.Decode as Decode
import Task exposing (Task)
import Native.Crypto


encrypt : String -> String -> Buffer -> Result Decode.Value Buffer
encrypt =
    Native.Crypto.encrypt


decrypt : String -> String -> Buffer -> Result Decode.Value Buffer
decrypt =
    Native.Crypto.decrypt


randomBytes : Int -> Task Decode.Value Buffer
randomBytes =
    Native.Crypto.randomBytes
