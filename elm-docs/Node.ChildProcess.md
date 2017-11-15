# Node.ChildProcess

Child Process

- [Output](#output)
- [Exit](#exit)
- [spawn](#spawn)

### **type Output**
```elm
type Output   
    = Silent   
    | Verbose 
```

Output type.

---

### **type Exit**
```elm
type Exit   
    = Code Int  
    | Signal String
```

Exit type.

---

### **spawn**
```elm
spawn : String -> Node.ChildProcess.Output -> Task Node.Error.Error Node.ChildProcess.Exit
```

Spawn a child process by running the given command.

