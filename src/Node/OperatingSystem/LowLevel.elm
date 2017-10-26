module Node.OperatingSystem.LowLevel
    exposing
        ( homedir
        , tmpdir
        )

import Json.Decode as Decode
import Native.OperatingSystem


homedir : Result Decode.Value String
homedir =
    Native.OperatingSystem.homedir


tmpdir : Result Decode.Value String
tmpdir =
    Native.OperatingSystem.tmpdir
