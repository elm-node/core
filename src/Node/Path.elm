module Node.Path
    exposing
        ( basename
        , dirname
        , extname
        , join
        )

{-| Path

@docs basename , dirname , extname , join

-}

import Native.Path


{-| Extract the basename from a filename.
-}
basename : String -> String
basename =
    Native.Path.basename


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
