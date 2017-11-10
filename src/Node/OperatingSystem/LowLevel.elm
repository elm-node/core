module Node.OperatingSystem.LowLevel
    exposing
        ( homedir
        , platform
        , tmpdir
        )

import Json.Decode as Decode
import Native.OperatingSystem


homedir : Result Decode.Value String
homedir =
    Native.OperatingSystem.homedir


platform : Result Decode.Value String
platform =
    Native.OperatingSystem.platform


tmpdir : Result Decode.Value String
tmpdir =
    Native.OperatingSystem.tmpdir
