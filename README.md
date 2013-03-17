NSData+AES
==========

NSData+AES is a category for NSData that adds AES encryption and decryption.

# Requirements #

* Link ```Security.framework``` to your project.

* Add NSData+AES category to your project.

* ```#import "NSData+AES.h"``` where you want to use this category.

*  Use class or instance methods to encrypt or decrypt your data.

* Enjoy! :)

# Usage #

* Generate an initialization vector

```objective-c
NSData *iv = [NSData createRandomInitializationVector];
```

* Generate a salt vector

```objective-c
NSData *salt = [NSData createRandomSalt];
```

* Encrypt your message

```ojective-c
NSData *originalMessage = [aMessage dataUsingEncoding:NSUTF8StringEncoding];
NSData *encryptedMessage = [originalMessage AESEncryptWithPassword:password iv:iv salt:salt error:&error];
```

* Decrypt your message

```objective-c
NSData *decryptedMessage = [encryptedMessage AESDecryptWithPassword:password iv:iv salt:salt error:&error];
NSString stringWithMessage = [[NSString alloc] initWithData:decryptedMessage encoding:NSUTF8StringEncoding];
```

# Some considerations #

* Always, yes, ALWAYS, use an initialization vector and salted keys. If you don't use those, you'll have an important security issue (i.e. someone with multiple encrypted messages can guess the content without the password).

* To generate initialization vector and salt, there are two class methods in the category, don't use custom methods to do this.

* IV and salt can be kept with the ciphered messasge and doesn't need to be secret values, in fact, you will need those values to decrypt your message.

* IV and salt adds some random to your key (with password and salt) and to the cipher (IV and AES algorithm).