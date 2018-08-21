//
//  mBluetoothUtil.m
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 8/19/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JMBluetoothTooth.h"
#import "mBluetoothUtil.h"
#import "brandNewBIke-Swift.h"


@implementation mBluetoothUtil

+ (void)connect:(NSString*) macAddress{
    
    //1.赋值设备名称
    //kJMBluetoothManager.jmDeviceMacAddress = @"0102C4A82808285E";
    kJMBluetoothManager.jmDeviceMacAddress = macAddress;
    //2.开始扫描外设, 执行连接
   
    [kJMBluetoothManager JMBluetoothStartConnectionWithWidthDeviceMacAddress:@"" ConnectBlock:^(JMOperationResult result, CBPeripheral * _Nonnull peripheral, NSError * _Nullable error) {
        
        if (error == nil){
            
        }else{
            [mBikeUtil.shared onErrorWithWhereError:@"connection"];
            [kJMBluetoothManager JMDisconnect];
        }
    }];
    
    kJMBluetoothManager.jmBluetoothGetTokenWithBlock = ^(NSString * _Nonnull token, NSError * _Nonnull error) {
        
        if (error == nil){
            printf("mai error duay na ");
            [mBikeUtil.shared onConnected];
        }else{
           [kJMBluetoothManager JMDisconnect];
           [mBikeUtil.shared onErrorWithWhereError:@"token"];
        }
    };
}


//开锁按钮点击事件
+ (void)unlock {
    
    [kJMBluetoothManager JMOpenLockWidthCallback:^(JMOperationResult result, NSArray * _Nonnull message, NSError * _Nullable error) {
        if (error == nil){
            [mBikeUtil.shared onUnlocked];
        }else{
            [kJMBluetoothManager JMDisconnect];
            [mBikeUtil.shared onErrorWithWhereError:@"unlock"];
        }
        
    }];
}

//断开连接
+ (void)disconnect {
    [kJMBluetoothManager JMDisconnect];
}

@end

















