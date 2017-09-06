# Node core

> Native bindings for Node.js's core api's.


## install

You'll need [Grove](https://github.com/panosoft/elm-grove.git).

```
grove install elm-node/core
```


## api

This is still a work in progress. Please refer to the documentation in the code or test code for usage.

## todo


Buffer
- [x] toString
- [x] fromString
- [-] concat
- [-] slice

Crypto
- [x] encrypt
- [x] decrypt
- [x] randomBytes
- [?] randomBytesSlow (synchronous and blocking and not pure ... so would a Result be acceptable?)

FileSystem
- [x] write
- [x] read
- [x] copy
- [x] remove
- [-] move

Global
- [x] parseInt
