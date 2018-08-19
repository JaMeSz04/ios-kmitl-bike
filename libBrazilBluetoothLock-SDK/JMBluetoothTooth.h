//
//  JMBluetoothTooth.h
//  MengGouSharedLocksDemo
//
//  Created by Smile on 2017/11/14.
//  Copyright © 2017年 Smile. All rights reserved.
//

#import <Foundation/Foundation.h>

///核心蓝牙
#import <CoreBluetooth/CoreBluetooth.h>

#import <CommonCrypto/CommonCryptor.h>

///数据转换工具 Data conversion tool
#import "JMDataConversionTool.h"

///蓝牙连接管理类 Bluetooth connection management class
#import "JMBluetoothManager.h"

///蓝牙具体连接实现 Bluetooth specific connection implementation
#import "JMBluetoothModel.h"

//关锁通知名称 Lock notification name
static const NSNotificationName kCloseLockNotificationName = @"kCloseLockNotificationName";


//Log output, debugging time output information for easy debugging, formal environment will not output
//log输出, 调试时候输出信息用于方便调试, 正式环境将不会输出
#ifdef DEBUG

#define JMLog(...) NSLog(@"%s 第%d行 \n %@\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])

#else

#define JMLog(...)

#endif
