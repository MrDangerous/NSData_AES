//
//  NSData+AES.h
//  Safebox
//
//  Created by Juan Ignacio Laube on 16/03/13.
//  Copyright (c) 2013 Juan Ignacio Laube. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES)

+ (NSData *)createRandomInitializationVector;
+ (NSData *)createRandomSalt;

+ (NSData *)AESEncryptedDataForData:(NSData *)data withPassword:(NSString *)password iv:(NSData *)iv salt:(NSData *)salt error:(NSError **)error;
+ (NSData *)dataForAESEncryptedData:(NSData *)data withPassword:(NSString *)password iv:(NSData *)iv salt:(NSData *)salt error:(NSError **)error;

- (NSData *)AESEncryptWithPassword:(NSString *)password iv:(NSData *)iv salt:(NSData *)salt error:(NSError **)error;
- (NSData *)AESDecryptWithPassword:(NSString *)password iv:(NSData *)iv salt:(NSData *)salt error:(NSError **)error;

@end
