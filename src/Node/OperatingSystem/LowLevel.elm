module Node.OperatingSystem.LowLevel
    exposing
        ( homedir
        , platform
        , tmpdir
        )

import Json.Decode as Decode
import Native.OperatingSystem


homedir : String
homedir =
    Native.OperatingSystem.homedir


platform : String
platform =
    Native.OperatingSystem.platform


tmpdir : String
tmpdir =
    Native.OperatingSystem.tmpdir
