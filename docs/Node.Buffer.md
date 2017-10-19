# Node.Buffer

Native bindings for Buffer module.

- [Buffer](#buffer)
- [fromString](#fromstring)
- [toString](#tostring)

### **type alias Buffer**
```elm
type alias Buffer  =  
    Node.Buffer.LowLevel.Buffer
```

Buffer type.

---

### **fromString**
```elm
fromString : Node.Encoding.Encoding -> String -> Result Node.Error.Error Node.Buffer.Buffer
```

Convert a String to a Buffer.

---

### **toString**
```elm
toString : Node.Encoding.Encoding -> Node.Buffer.Buffer -> Result Node.Error.Error String
```

Convert a Buffer to a String.

