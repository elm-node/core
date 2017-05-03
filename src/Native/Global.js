const _elm_node$core$Native_Global = function () {
    const Err = _elm_lang$core$Result$Err
    const Ok = _elm_lang$core$Result$Ok


    // parseInt
    const parseInt = F2((radix, string) => {
        try {
            const value = global.parseInt(string, radix)
            return Ok(value)
        } catch (error) { return Err(error) }
    })


    const exports =
        { parseInt
        }
    return exports
}()
