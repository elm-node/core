const _elm_node$core$Native_Path = function () {
    const { fromList, toJSArray } = _elm_lang$core$Native_Array
    const path = require("path")


    // basename : String -> String
    const basename = path.basename


    // dirname : String -> String
    const dirname = path.dirname


    // extname : String -> String
    const extname = path.extname


    // join : List String -> String
    const join = list => path.join.apply(path, toJSArray(fromList(list)))


    const exports =
        { basename
        , dirname
        , extname
        , join
        }
    return exports
}()
