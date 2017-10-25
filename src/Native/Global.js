const _elm_node$core$Native_Global = function () {
    const Err = _elm_lang$core$Result$Err
    const Ok = _elm_lang$core$Result$Ok


    // parseInt : Int -> String -> Result Decode.Value Int
    const parseInt = F2((radix, string) => {
        try {
            // NOTE radix can be any integer from 2-36
            const value = global.parseInt(string, radix)
            if (isNaN(value)) return Err(new Error(`String cannot be converted to an integer: ${string}`))
            return Ok(value)
        } catch (error) { return Err(error) }
    })


    const exports =
        { parseInt
        }
    return exports
}()
