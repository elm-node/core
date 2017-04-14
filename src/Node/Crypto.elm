module Node.Crypto
    exposing
        ( Cipher(..)
        , decrypt
        , encrypt
        )

{-| Native bindings for node's Crypto module.

@docs Cipher , decrypt , encrypt

-}

import List.Extra as List
import Node.Buffer as Buffer exposing (Buffer)
import Tuple
import Native.Crypto


{- Notes:

   Modes
   - CBC: Cipher Block Chaining
   - CFB: Cipher Feedback
   - CNT: Counter
   - ECB: Electronic Cookbook
   - OFB: Output Feedback

   aes-128 = cipher
   cbc = mode
   not all ciphers support modes
-}


{-| Cipher types supported by [Openssl](https://www.openssl.org/docs/man1.0.2/apps/enc.html).
-}
type Cipher
    = Aes128
    | Aes128CipherBlockChaining
    | Aes128CipherFeedback
    | Aes128CipherFeedback1
    | Aes128CipherFeedback8
    | Aes128ElectronicCookbook
    | Aes128OutputFeedback
    | Aes192
    | Aes192CipherBlockChaining
    | Aes192CipherFeedback
    | Aes192CipherFeedback1
    | Aes192CipherFeedback8
    | Aes192ElectronicCookbook
    | Aes192OutputFeedback
    | Aes256
    | Aes256CipherBlockChaining
    | Aes256CipherFeedback
    | Aes256CipherFeedback1
    | Aes256CipherFeedback8
    | Aes256ElectronicCookbook
    | Aes256OutputFeedback
    | Base64
    | Bf
    | BfCipherBlockChaining
    | BfCipherFeedback
    | BfElectronicCookbook
    | BfOutputFeedback
    | Cast
    | CastCipherBlockChaining
    | Cast5CipherBlockChaining
    | Cast5CipherFeedback
    | Cast5ElectronicCookbook
    | Cast5OutputFeedback
    | Des
    | DesCipherBlockChaining
    | DesCipherFeedback
    | DesElectronicCookbook
    | DesOutputFeedback
    | DesEde
    | DesEdeCipherBlockChaining
    | DesEdeCipherFeedback
    | DesEdeOutputFeedback
    | Des3
    | DesEde3
    | DesEde3CipherBlockChaining
    | DesEde3CipherFeedback
    | DesEde3OutputFeedback
    | Desx
    | Gost89
    | Gost89CNT
    | Idea
    | IdeaCipherBlockChaining
    | IdeaCipherFeedback
    | IdeaElectronicCookbook
    | IdeaOutputFeedback
    | Rc2
    | Rc2CipherBlockChaining
    | Rc2CipherFeedback
    | Rc2ElectronicCookbook
    | Rc2OutputFeedback
    | Rc240CipherBlockChaining
    | Rc264CipherBlockChaining
    | Rc4
    | Rc440
    | Rc464
    | Rc5
    | Rc5CipherBlockChaining
    | Rc5CipherFeedback
    | Rc5ElectronicCookbook
    | Rc5OutputFeedback
    | None


cipherMap : List ( Cipher, String )
cipherMap =
    [ ( Aes128, "aes128" ) -- = aes-128-cbc
    , ( Aes128CipherBlockChaining, "aes-128-cbc" )
    , ( Aes128CipherFeedback, "aes-128-cfb" )
    , ( Aes128CipherFeedback1, "aes-128-cfb1" )
    , ( Aes128CipherFeedback8, "aes-128-cfb8" )
    , ( Aes128ElectronicCookbook, "aes-128-ecb" )
    , ( Aes128OutputFeedback, "aes-128-ofb" )
    , ( Aes192, "aes192" ) -- = aes-192-cbc
    , ( Aes192CipherBlockChaining, "aes-192-cbc" )
    , ( Aes192CipherFeedback, "aes-192-cfb" )
    , ( Aes192CipherFeedback1, "aes-192-cfb1" )
    , ( Aes192CipherFeedback8, "aes-192-cfb8" )
    , ( Aes192ElectronicCookbook, "aes-192-ecb" )
    , ( Aes192OutputFeedback, "aes-192-ofb" )
    , ( Aes256, "aes256" ) -- = aes-256-cbc
    , ( Aes256CipherBlockChaining, "aes-256-cbc" )
    , ( Aes256CipherFeedback, "aes-256-cfb" )
    , ( Aes256CipherFeedback1, "aes-256-cfb1" )
    , ( Aes256CipherFeedback8, "aes-256-cfb8" )
    , ( Aes256ElectronicCookbook, "aes-256-ecb" )
    , ( Aes256OutputFeedback, "aes-256-ofb" )
    , ( Base64, "base64" ) -- no mode ...
    , ( Bf, "bf" ) -- = bf-cbc
    , ( BfCipherBlockChaining, "bf-cbc" )
    , ( BfCipherFeedback, "bf-cfb" )
    , ( BfElectronicCookbook, "bf-ecb" )
    , ( BfOutputFeedback, "bf-ofb" )
    , ( Cast, "cast" ) -- = cast-cbc
    , ( CastCipherBlockChaining, "cast-cbc" )
    , ( Cast5CipherBlockChaining, "cast5-cbc" )
    , ( Cast5CipherFeedback, "cast5-cfb" )
    , ( Cast5ElectronicCookbook, "cast5-ecb" )
    , ( Cast5OutputFeedback, "cast5-ofb" )
    , ( Des, "des" ) -- = des-cbc
    , ( DesCipherBlockChaining, "des-cbc" )
    , ( DesCipherFeedback, "des-cfb" )
    , ( DesElectronicCookbook, "des-ecb" )
    , ( DesOutputFeedback, "des-ofb" )
    , ( DesEde, "des-ede" ) -- = des-ede-ecb
    , ( DesEdeCipherBlockChaining, "des-ede-cbc" )
    , ( DesEdeCipherFeedback, "des-ede-cfb" )
    , ( DesEdeOutputFeedback, "des-ede-ofb" )
    , ( Des3, "des3" ) -- = des-ede3-cbc
    , ( DesEde3, "des-ede3" ) -- = des-ede3-ecb
    , ( DesEde3CipherBlockChaining, "des-ede3-cbc" )
    , ( DesEde3CipherFeedback, "des-ede3-cfb" )
    , ( DesEde3OutputFeedback, "des-ede3-ofb" )
    , ( Desx, "desx" ) -- no mode ...
    , ( Gost89, "gost89" ) -- = Gost89 in CFB mode, mode but no `-mode` in name
    , ( Gost89CNT, "gost89-cnt" )
    , ( Idea, "idea" ) -- = idea-cbc
    , ( IdeaCipherBlockChaining, "idea-cbc" )
    , ( IdeaCipherFeedback, "idea-cfc" )
    , ( IdeaElectronicCookbook, "idea-ecb" )
    , ( IdeaOutputFeedback, "idea-ofb" )
    , ( Rc2, "rc2" ) -- = rc2-cbc, 128 bit Rc2
    , ( Rc2CipherBlockChaining, "rc2-cbc" ) -- 128 bit Rc2
    , ( Rc2CipherFeedback, "rc2-cfb" ) -- 128 bit Rc2
    , ( Rc2ElectronicCookbook, "rc2-ecb" ) -- 128 bit Rc2
    , ( Rc2OutputFeedback, "rc2-ofb" ) -- 128 bit Rc2
    , ( Rc240CipherBlockChaining, "rc2-40-cbc" ) -- 40 bit Rc2
    , ( Rc264CipherBlockChaining, "rc2-64-cbc" ) -- 64 bit Rc2
    , ( Rc4, "rc4" ) -- 128 bit Rc4, no mode ...
    , ( Rc440, "rc4-40" ) -- 40 bit Rc4, no mode ...
    , ( Rc464, "rc4-64" ) -- 64 bit Rc4, no mode ...
    , ( Rc5, "rc5" ) -- = rc5-cbc
    , ( Rc5CipherBlockChaining, "rc5-cbc" )
    , ( Rc5CipherFeedback, "rc5-cfb" )
    , ( Rc5ElectronicCookbook, "rc5-ecb" )
    , ( Rc5OutputFeedback, "rc5-ofb" )
    , ( None, "none" ) -- no mode ...
    ]


cipherToString : Cipher -> Result String String
cipherToString cipher =
    cipherMap
        |> List.find (Tuple.first >> (==) cipher)
        |> Maybe.map (Tuple.second >> Ok)
        |> Maybe.withDefault (Err "Cipher could not be found.")


{-| -}
encrypt : Cipher -> String -> Buffer -> Result String Buffer
encrypt cipher password buffer =
    cipherToString cipher
        |> Result.andThen (\algorithm -> Native.Crypto.encrypt algorithm password buffer)


{-| -}
decrypt : Cipher -> String -> Buffer -> Result String Buffer
decrypt cipher password buffer =
    cipherToString cipher
        |> Result.andThen (\algorithm -> Native.Crypto.decrypt algorithm password buffer)
