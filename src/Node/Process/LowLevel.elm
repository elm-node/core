module Node.Process.LowLevel
    exposing
        ( cwd
        , env
        )

import Native.Process
import Json.Decode as Decode
import Task exposing (Task)


env : Decode.Value
env =
    Native.Process.env


cwd : () -> Task Decode.Value String
cwd =
    Native.Process.cwd
