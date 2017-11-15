# Node.Crypto

Native bindings for Node's Crypto module.

- [Cipher](#cipher)
- [decrypt](#decrypt)
- [encrypt](#encrypt)
- [randomBytes](#randombytes)

### **type Cipher**
```elm
type Cipher   
    = Aes128   
    | Aes128CipherBlockChaining   
    | Aes128CipherFeedback   
    | Aes128CipherFeedback1   
    | Aes128CipherFeedback8   
    | Aes128ElectronicCookbook   
    | Aes128OutputFeedback   
    | Aes192   
    | Aes192CipherBlockChaining   
    | Aes192CipherFeedback   
    | Aes192CipherFeedback1   
    | Aes192CipherFeedback8   
    | Aes192ElectronicCookbook   
    | Aes192OutputFeedback   
    | Aes256   
    | Aes256CipherBlockChaining   
    | Aes256CipherFeedback   
    | Aes256CipherFeedback1   
    | Aes256CipherFeedback8   
    | Aes256ElectronicCookbook   
    | Aes256OutputFeedback   
    | Base64   
    | Bf   
    | BfCipherBlockChaining   
    | BfCipherFeedback   
    | BfElectronicCookbook   
    | BfOutputFeedback   
    | Cast   
    | CastCipherBlockChaining   
    | Cast5CipherBlockChaining   
    | Cast5CipherFeedback   
    | Cast5ElectronicCookbook   
    | Cast5OutputFeedback   
    | Des   
    | DesCipherBlockChaining   
    | DesCipherFeedback   
    | DesElectronicCookbook   
    | DesOutputFeedback   
    | DesEde   
    | DesEdeCipherBlockChaining   
    | DesEdeCipherFeedback   
    | DesEdeOutputFeedback   
    | Des3   
    | DesEde3   
    | DesEde3CipherBlockChaining   
    | DesEde3CipherFeedback   
    | DesEde3OutputFeedback   
    | Desx   
    | Gost89   
    | Gost89CNT   
    | Idea   
    | IdeaCipherBlockChaining   
    | IdeaCipherFeedback   
    | IdeaElectronicCookbook   
    | IdeaOutputFeedback   
    | Rc2   
    | Rc2CipherBlockChaining   
    | Rc2CipherFeedback   
    | Rc2ElectronicCookbook   
    | Rc2OutputFeedback   
    | Rc240CipherBlockChaining   
    | Rc264CipherBlockChaining   
    | Rc4   
    | Rc440   
    | Rc464   
    | Rc5   
    | Rc5CipherBlockChaining   
    | Rc5CipherFeedback   
    | Rc5ElectronicCookbook   
    | Rc5OutputFeedback   
    | None 
```

Cipher types supported by [Openssl](https://www.openssl.org/docs/man1.0.2/apps/enc.html).

---

### **decrypt**
```elm
decrypt : Node.Crypto.Cipher -> String -> Node.Buffer.Buffer -> Result Node.Error.Error Node.Buffer.Buffer
```

Decrypt a Buffer.

---

### **encrypt**
```elm
encrypt : Node.Crypto.Cipher -> String -> Node.Buffer.Buffer -> Result Node.Error.Error Node.Buffer.Buffer
```

Encrypt a Buffer.

---

### **randomBytes**
```elm
randomBytes : Int -> Task Node.Error.Error Node.Buffer.Buffer
```

Generate cryptographically strong pseudo-random data.

