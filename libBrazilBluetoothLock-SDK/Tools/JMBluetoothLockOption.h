//
//  JMBluetoothLockOption.h
//  MengGouSharedLocksDemo
//
//  Created by Smile on 2017/11/14.
//  Copyright © 2017年 Smile. All rights reserved.
//

#import <Foundation/Foundation.h>

//1.特征
#define kJMProtocolWrite @"000036F5-0000-1000-8000-00805F9B34FB"
#define kJMProtocolRead @"000036F6-0000-1000-8000-00805F9B34FB"

//2.1获取令牌
#define kGetToken @"06010101"               //返回0602开头数据
#define kGetTokenPrefix @"060207"

//2.2开锁
#define kOpenLock @"050106"                 //返回050201开头数据
#define kOpenLockPrefix @"050201"

//2.3关锁
#define kCloseLockPrefix @"050F01"



typedef NS_ENUM(NSInteger, JMOperationResult) {
    
    NOTIFY_DATA,                //这个状态代表是接受蓝牙返回的数据,在jmFortification 这个回调中,将会返回设备数据
    
    Get_TOKEN,                  //获取token
    
    Open_Lock,                  //开锁
    
    Close_Lock,                 //关锁
    
    RESERVE                     //预留值, 在连接蓝牙时候, 存在超时,没有搜索到设备等等, 连接成功这样情况, 所以单独流出一个状态枚举
};











