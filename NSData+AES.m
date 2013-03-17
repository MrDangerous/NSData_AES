//
//  NSData+AES.m
//  Safebox
//
//  Created by Juan Ignacio Laube on 16/03/13.
//  Copyright (c) 2013 Juan Ignacio Laube. All rights reserved.
//

#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>

#import "NSData+AES.h"

@implementation NSData (AES)

#pragma mark Methods needed in CBC crypto.

+ (NSData *)createRandomInitializationVector
{
    NSData *data = [NSData createRandomDataWithLengh:kCCBlockSizeAES128];
    return data;
}

+ (NSData *)createRandomSalt
{
    NSData *data = [NSData createRandomDataWithLengh:8];
    return data;
}

+ (NSData *)AESEncryptedDataForData:(NSData *)data withPassword:(NSString *)password iv:(NSData *)iv salt:(NSData *)salt error:(NSError **)error
{
    return [data AESEncryptWithPassword:password iv:iv salt:salt error:error];
}

+ (NSData *)dataForAESEncryptedData:(NSData *)data withPassword:(NSString *)password iv:(NSData *)iv salt:(NSData *)salt error:(NSError **)error
{
    return [data AESDecryptWithPassword:password iv:iv salt:salt error:error];
}


- (NSData *)AESEncryptWithPassword:(NSString *)password iv:(NSData *)iv salt:(NSData *)salt error:(NSError **)error
{
    NSData *key = [NSData keyForPassword:password salt:salt];
    size_t outLength;
    NSMutableData *cipherData = [NSMutableData dataWithLength:self.length + kCCBlockSizeAES128];
    
    CCCryptorStatus result = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, key.bytes, key.length, iv.bytes, self.bytes, self.length, cipherData.mutableBytes, cipherData.length, &outLength);
    
    if(result == kCCSuccess)
    {
        cipherData.length = outLength;
    }
    else if(error)
    {
        *error = [NSError errorWithDomain:@"com.jlaube.crypto" code:result userInfo:nil];
        return nil;
    }
    return cipherData;
}

- (NSData *)AESDecryptWithPassword:(NSString *)password iv:(NSData *)iv salt:(NSData *)salt error:(NSError **)error
{
    NSData *key = [NSData keyForPassword:password salt:salt];
    size_t outLength;
    NSMutableData *clearData = [NSMutableData dataWithLength:self.length + kCCBlockSizeAES128];
    
    CCCryptorStatus result = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, key.bytes, key.length, iv.bytes, self.bytes, self.length, clearData.mutableBytes, clearData.length, &outLength);
    
    if(result == kCCSuccess)
    {
        clearData.length = outLength;
    }
    else if(error)
    {
        *error = [NSError errorWithDomain:@"com.jlaube.crypto" code:result userInfo:nil];
        return nil;
    }
    return clearData;
}

+ (NSData *)createRandomDataWithLengh:(NSUInteger)length
{
    NSMutableData *data = [[NSMutableData alloc] initWithLength:length];
    SecRandomCopyBytes(kSecRandomDefault, length, data.mutableBytes);
    return data;
}

+ (NSData *)keyForPassword:(NSString *)password salt:(NSData *)salt
{
    NSMutableData *key = [NSMutableData dataWithLength:kCCKeySizeAES128];
    CCKeyDerivationPBKDF(kCCPBKDF2, password.UTF8String, password.length, salt.bytes, salt.length, kCCPRFHmacAlgSHA1, 10000, key.mutableBytes, key.length);
    
    return key;
}


@end
