const _elm_node$core$Native_Crypto = function () {
    const Ok = _elm_lang$core$Result$Ok
    const Err = _elm_lang$core$Result$Err
    const { nativeBinding, fail, succeed } = _elm_lang$core$Native_Scheduler
    const crypto = require("crypto")
    const { Buffer } = require("buffer")


    // encrypt : String -> String -> Buffer -> Result Decode.Value Buffer
    const encrypt = F3((algorithm, password, data) => {
        try {
            const cipher = crypto.createCipher(algorithm, password)
            const encrypted = Buffer.concat([ cipher.update(data), cipher.final() ])
            return Ok(encrypted)
        } catch (error) { return Err(error) }
    })


    // decrypt : String -> String -> Buffer -> Result Decode.Value Buffer
    const decrypt = F3((algorithm, password, data) => {
        try {
            const decipher = crypto.createDecipher(algorithm, password)
            const decrypted = Buffer.concat([ decipher.update(data), decipher.final() ])
            return Ok(decrypted)
        } catch (error) { return Err(error) }
    })


    // randomBytes : Int -> Task Decode.Value Buffer
    const randomBytes = size => nativeBinding(callback => {
        try {
            crypto.randomBytes(size, (error, buffer) => {
                if (error) return callback(fail(error))
                return callback(succeed(buffer))
            })
        } catch (error) { return callback(fail(error)) }
    })


    const exports =
        { encrypt
        , decrypt
        , randomBytes
        }
    return exports
}()
