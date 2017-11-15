# Node.FileSystem

FileSystem

- [defaultEncoding](#defaultencoding)
- [defaultMode](#defaultmode)

### **defaultEncoding**
```elm
defaultEncoding : Node.Encoding.Encoding
```

Default encoding (Utf8).

---

### **defaultMode**
```elm
defaultMode : Node.FileSystem.Mode
```

Default mode (Read and Write access for Owner, Group, and Others).


## Query

- [Stats](#stats)
- [FileType](#filetype)
- [exists](#exists)
- [statistics](#statistics)

### **type alias Stats**
```elm
type alias Stats  =  
    { type_ : Node.FileSystem.FileType , size : Int , mode : Node.FileSystem.Mode , accessed : Time , modified : Time , changed : Time , created : Time }
```

Path statistics.

---

### **type FileType**
```elm
type FileType   
    = File   
    | Directory   
    | Socket   
    | SymbolicLink 
```

Path types.

---

### **exists**
```elm
exists : String -> Task Node.Error.Error Bool
```

Check whether a path exists.

---

### **statistics**
```elm
statistics : String -> Task Node.Error.Error Node.FileSystem.Stats
```

Get statistics for a given path.


## Manage

- [copy](#copy)
- [mkdirp](#mkdirp)
- [remove](#remove)
- [rename](#rename)
- [symbolicLink](#symboliclink)

### **copy**
```elm
copy : Bool -> String -> String -> Task Node.Error.Error (Dict String (Result Node.Error.Error ()))
```

Copy a file or directory recursively.

---

### **mkdirp**
```elm
mkdirp : String -> Task Node.Error.Error ()
```

Make a directory using the given directory name.

Non-existent directories in the path will be created.

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

### **symbolicLink**
```elm
symbolicLink : String -> String -> Task Node.Error.Error ()
```

Make a symbolic link.


## Read

- [readFile](#readfile)
- [readFileAsString](#readfileasstring)

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


## Write

- [writeFile](#writefile)
- [writeFileFromString](#writefilefromstring)

### **writeFile**
```elm
writeFile : String -> Node.FileSystem.Mode -> Node.Buffer.Buffer -> Task Node.Error.Error ()
```

Write a file from a Buffer.

Non-existent directories in the filename path will be created.

---

### **writeFileFromString**
```elm
writeFileFromString : String -> Node.FileSystem.Mode -> Node.Encoding.Encoding -> String -> Task Node.Error.Error ()
```

Write a file from a String.

Non-existent directories in the file's path will be created.

