const _elm_node$core$Native_Crypto = function () {
    const Ok = _elm_lang$core$Result$Ok
    const Err = _elm_lang$core$Result$Err
    const crypto = require("crypto")
    const { Buffer } = require("buffer")


    // encrypt : String -> String -> Buffer -> Result Decode.Value Buffer
    const encrypt = F3((algorithm, password, data) => {
        try {
            const cipher = crypto.createCipher(algorithm, password)
            const encrypted = Buffer.concat([ cipher.update(data), cipher.final() ])
            return Ok(encrypted)
        } catch (error) { return Err(error.message) }
    })


    // decrypt : String -> String -> Buffer -> Result Decode.Value Buffer
    const decrypt = F3((algorithm, password, data) => {
        try {
            const decipher = crypto.createDecipher(algorithm, password)
            const decrypted = Buffer.concat([ decipher.update(data), decipher.final() ])
            return Ok(decrypted)
        } catch (error) { return Err(error.message) }
    })


    const exports =
        { encrypt
        , decrypt
        }
    return exports
}()
