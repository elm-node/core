const _elm_node$core$Native_Buffer = function () {
    const Ok = _elm_lang$core$Result$Ok
    const Err = _elm_lang$core$Result$Err
    const { Buffer } = require("buffer")
    const { StringDecoder } = require("string_decoder")


    // fromString : String -> String -> Result Error Buffer
    const fromString = F2((encoding, string) => {
        try {
            const buffer = Buffer.from(string, encoding)
            return Ok(buffer)
        } catch (error) { return Err(error) }
    })


    // toString : String -> Buffer -> Result Error String
    const toString = F2((encoding, buffer) => {
        try {
            const decoder = new StringDecoder(encoding)
            const string = decoder.end(buffer)
            return Ok(string)
        } catch (error) { return Err(error) }
    })


    const exports =
        { fromString
        , toString
        }
    return exports
}()
