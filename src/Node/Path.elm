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


{-| -}
basename : String -> String
basename =
    Native.Path.basename


{-| -}
dirname : String -> String
dirname =
    Native.Path.dirname


{-| -}
extname : String -> String
extname =
    Native.Path.extname


{-| -}
join : List String -> String
join =
    Native.Path.join
