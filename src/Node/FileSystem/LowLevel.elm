module Node.FileSystem.LowLevel
    exposing
        ( copy
        , readFileAsString
        , readFileAsBuffer
        , remove
        , writeFileFromString
        , writeFileFromBuffer
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


readFileAsString : String -> String -> Task Decode.Value String
readFileAsString =
    Native.FileSystem.readFileAsString


readFileAsBuffer : String -> Task Decode.Value Buffer
readFileAsBuffer =
    Native.FileSystem.readFileAsBuffer


remove : String -> Task Decode.Value ()
remove =
    Native.FileSystem.remove


writeFileFromString : String -> String -> String -> String -> Task Decode.Value ()
writeFileFromString =
    Native.FileSystem.writeFileFromString


writeFileFromBuffer : String -> String -> Buffer -> Task Decode.Value ()
writeFileFromBuffer =
    Native.FileSystem.writeFileFromBuffer
