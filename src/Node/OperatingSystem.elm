module Node.OperatingSystem
    exposing
        ( home
        , temp
        )

{-| Operating system information.

@docs home , temp

-}

import Node.Error as Error exposing (Error(..))
import Node.OperatingSystem.LowLevel as LowLevel


{-| Current user's home directory.
-}
home : Result Error String
home =
    LowLevel.homedir
        |> Result.mapError Error.fromValue


{-| Current user's temporary directory.
-}
temp : Result Error String
temp =
    LowLevel.tmpdir
        |> Result.mapError Error.fromValue
