//
//  JMAES128.m
//  MengGouSharedLocksDemo
//
//  Created by Smile on 2017/11/14.
//  Copyright © 2017年 Smile. All rights reserved.
//

#import "JMAES128.h"
#import "aes.h"

@implementation JMAES128

//加密
+(NSString *)AES128EncryptStrig:(NSString *)string{
    
    return [self AES128_Encrypt_or_DecryptString:string andIsEncrypt:YES];
}

//解密
+(NSString *)AES128DecryptString:(NSString *)string{
    
    return [self AES128_Encrypt_or_DecryptString:string andIsEncrypt:NO];
}

+(NSString *)AES128_Encrypt_or_DecryptString:(NSString *)string andIsEncrypt:(BOOL)isEncrypt{
    
    NSData *data = [self hexToBytes:string];
    
    uint8_t key[16] = {32, 87, 47, 82, 54, 75, 63, 71, 48, 80, 65, 88, 17, 99, 45, 43};
    uint8_t output[32];
    
    if (isEncrypt) {
        AES128_ECB_encrypt([data bytes], key, output);
    }else{
        AES128_ECB_decrypt([data bytes], key, output);
    }
    NSMutableString *decryptStr = [[NSMutableString alloc] init];
    for(int i = 0; i < 16; ++i){
        [decryptStr appendFormat:@"%.2x", output[i]];
    }
    return decryptStr.copy;
}

//将十六进制字符串转换成NSData类型的数据
+(NSData*) hexToBytes:(NSString *)str{
    
    NSMutableData* data = [NSMutableData data];
    
    int idx;
    
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        
        NSRange range = NSMakeRange(idx, 2);
        
        NSString* hexStr = [str substringWithRange:range];
        
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        
        unsigned int intValue;
        
        [scanner scanHexInt:&intValue];
        
        [data appendBytes:&intValue length:1];
        
    }
    return data;
}



@end
