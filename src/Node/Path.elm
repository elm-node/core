module Node.Path
    exposing
        ( basename
        , delimiter
        , dirname
        , extname
        , join
        , separator
        )

{-| Path

@docs basename , delimiter , dirname , extname , join , separator

-}

import Native.Path


{-| Extract the basename from a filename.
-}
basename : String -> String
basename =
    Native.Path.basename


{-| The platform-specific path delimiter.
-}
delimiter : String
delimiter =
    Native.Path.delimiter


{-| Extract the directory name from a filename.
-}
dirname : String -> String
dirname =
    Native.Path.dirname


{-| Extract the extension name from a filename.
-}
extname : String -> String
extname =
    Native.Path.extname


{-| Build a path from the list of supplied strings
-}
join : List String -> String
join =
    Native.Path.join


{-| The platform-specific path segment separator.
-}
separator : String
separator =
    Native.Path.sep
