//
//  JMDataConversionTool.h
//  MengGouSharedLocksDemo
//
//  Created by Smile on 2017/11/14.
//  Copyright © 2017年 Smile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMDataConversionTool : NSObject

/** 将16进制字符串, 转换为十进制字符串 */
+ (NSString *)JMConvertHexByDecimal:(NSString *)hexadecimal;

/** 十六进制转换为二进制 */
+ (NSString *)JMConvertBinaryByHex:(NSString *)hex;

/** 二进制NSData转换为16进制 */
+ (NSString *)JMConvertDataToHexStr:(NSData *)data;

/** 将16进制的字符串转换成NSData */
+ (NSData *)JMConvertHexStrToData:(NSString *)str;

@end





















