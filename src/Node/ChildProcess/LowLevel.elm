module Node.ChildProcess.LowLevel
    exposing
        ( spawn
        )

import Native.ChildProcess
import Json.Decode as Decode
import Task exposing (Task)


spawn : String -> List String -> Bool -> Task Decode.Value ( Maybe Int, Maybe String )
spawn =
    Native.ChildProcess.spawn
