module Node.FileSystem.LowLevel
    exposing
        ( readFileAsString
        , readFileAsBuffer
        , writeFileFromString
        , writeFileFromBuffer
        )

import Node.Buffer exposing (Buffer)
import Json.Decode as Decode
import Task exposing (Task)
import Native.FileSystem


readFileAsString : String -> String -> Task Decode.Value String
readFileAsString =
    Native.FileSystem.readFileAsString


readFileAsBuffer : String -> Task Decode.Value Buffer
readFileAsBuffer =
    Native.FileSystem.readFileAsBuffer


writeFileFromString : String -> String -> String -> String -> Task Decode.Value ()
writeFileFromString =
    Native.FileSystem.writeFileFromString


writeFileFromBuffer : String -> String -> Buffer -> Task Decode.Value ()
writeFileFromBuffer =
    Native.FileSystem.writeFileFromBuffer
