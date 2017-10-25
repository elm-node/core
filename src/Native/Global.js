const _elm_node$core$Native_Global = function () {
    const Err = _elm_lang$core$Result$Err
    const Ok = _elm_lang$core$Result$Ok


    // parseInt : Int -> String -> Result Decode.Value Int
    const parseInt = F2((radix, string) => {
        try {
            // radix values integer from 2-36
            const value = global.parseInt(string, radix)
            // TODO check for value === NaN and Err in that case
            return Ok(value)
        } catch (error) { return Err(error) }
    })


    const exports =
        { parseInt
        }
    return exports
}()
