# Node.Encoding

String encodings supported by Node.js.

- [Encoding](#encoding)
- [toString](#tostring)

### **type Encoding**
```elm
type Encoding   
    = Ascii   
    | Utf8   
    | Utf16le   
    | Base64   
    | Latin1   
    | Hex 
```

Encoding union type.

---

### **toString**
```elm
toString : Node.Encoding.Encoding -> String
```

Convert encoding to string.

