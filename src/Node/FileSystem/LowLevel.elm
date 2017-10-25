module Node.FileSystem.LowLevel
    exposing
        ( copy
        , readFile
        , remove
        , writeFile
        , exists
        , mkdirp
        , rename
        , isSymlink
        , symlink
        )

import Node.Buffer exposing (Buffer)
import Json.Decode as Decode
import Task exposing (Task)
import Native.FileSystem


{-| Returns with

Fail:
Error

Succeed:
{ errors: List Error, files : List String }
errors = array of errors for files that failed
"File <filename> <error>"
files = list of destination directories and files that copy was attempted on
"<filename>"

Error is standard Error with list of errors for each error incurred
{ message, stack, list (Error {message, stack })}

in single file mode we have different behavior ...
Error is just the problem for a single file
filename is undefined

in cofirm case, error = list of stat errors

-}
copy : Bool -> String -> String -> Task Decode.Value Decode.Value
copy =
    Native.FileSystem.copy


readFile : String -> Task Decode.Value Buffer
readFile =
    Native.FileSystem.readFile


remove : String -> Task Decode.Value ()
remove =
    Native.FileSystem.remove


writeFile : String -> Int -> Buffer -> Task Decode.Value ()
writeFile =
    Native.FileSystem.writeFile


exists : String -> Task Decode.Value Bool
exists =
    Native.FileSystem.exists


mkdirp : String -> Task Decode.Value ()
mkdirp =
    Native.FileSystem.mkdirp


rename : String -> String -> Task Decode.Value ()
rename =
    Native.FileSystem.rename


isSymlink : String -> Task Decode.Value Bool
isSymlink =
    Native.FileSystem.isSymlink


symlink : String -> String -> Task Decode.Value ()
symlink =
    Native.FileSystem.symlink
