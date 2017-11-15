# Node.OperatingSystem

Operating system information.

- [Platform](#platform)
- [homeDirectory](#homedirectory)
- [platform](#platform-1)
- [tempDirectory](#tempdirectory)

### **type Platform**
```elm
type Platform   
    = Aix   
    | Android   
    | Darwin   
    | FreeBsd   
    | Linux   
    | OpenBsd   
    | SunOs   
    | Windows 
```

Platforms supported by Node.js.

---

### **homeDirectory**
```elm
homeDirectory : String
```

Current user's home directory.

---

### **platform**
```elm
platform : Result Node.Error.Error Node.OperatingSystem.Platform
```

Platform set at compile time of current running version of Node.js.

---

### **tempDirectory**
```elm
tempDirectory : String
```

Current user's temporary directory.

