# Node.Process

Process

- [cwd](#cwd)
- [environment](#environment)

### **cwd**
```elm
cwd : () -> Task Node.Error.Error String
```

Current working directory.

---

### **environment**
```elm
environment : Result String (Dict String String)
```

Environment variables.

