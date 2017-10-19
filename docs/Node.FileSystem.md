# Node.FileSystem

FileSystem

- [copy](#copy)
- [defaultEncoding](#defaultencoding)
- [defaultMode](#defaultmode)
- [exists](#exists)
- [mkdirp](#mkdirp)
- [readFile](#readfile)
- [readFileAsString](#readfileasstring)
- [remove](#remove)
- [rename](#rename)
- [writeFile](#writefile)
- [writeFileFromString](#writefilefromstring)
- [writeFileFromBuffer](#writefilefrombuffer)
- [isSymlink](#issymlink)
- [makeSymlink](#makesymlink)

### **copy**
```elm
copy : Bool -> String -> String -> Task Node.Error.Error (Dict String (Result Node.Error.Error ()))
```

Copy a file or directory recursively.

---

### **defaultEncoding**
```elm
defaultEncoding : Node.Encoding.Encoding
```

Default encoding.

---

### **defaultMode**
```elm
defaultMode : String
```

Default mode.

---

### **exists**
```elm
exists : String -> Task Node.Error.Error Bool
```

Check whether a file exists.

---

### **mkdirp**
```elm
mkdirp : String -> Task Node.Error.Error ()
```

Make a directory.

Non-existent directories in the path will be created.

---

### **readFile**
```elm
readFile : String -> Task Node.Error.Error Node.Buffer.Buffer
```

Read a file as a Buffer.

---

### **readFileAsString**
```elm
readFileAsString : String -> Node.Encoding.Encoding -> Task Node.Error.Error String
```

Read a file as a string.

---

### **remove**
```elm
remove : String -> Task Node.Error.Error ()
```

Remove a file or directory recursively.

---

### **rename**
```elm
rename : String -> String -> Task Node.Error.Error ()
```

Rename a file.

---

### **writeFile**
```elm
writeFile : String -> Node.Buffer.Buffer -> Task Node.Error.Error ()
```

Write a file from a Buffer with the default file mode.

Non-existent directories in the filename path will be created.

---

### **writeFileFromString**
```elm
writeFileFromString : String -> Node.FileSystem.Mode -> Node.Encoding.Encoding -> String -> Task Node.Error.Error ()
```

Write a file from a String.

Non-existent directories in the filename path will be created.

---

### **writeFileFromBuffer**
```elm
writeFileFromBuffer : String -> Node.FileSystem.Mode -> Node.Buffer.Buffer -> Task Node.Error.Error ()
```

Write a file from a Buffer.

Non-existent directories in the filename path will be created.

---

### **isSymlink**
```elm
isSymlink : String -> Task Node.Error.Error Bool
```

Check whether a file is a symbolic link.

---

### **makeSymlink**
```elm
makeSymlink : String -> String -> String -> Task Node.Error.Error ()
```

Make a symbolic link.

