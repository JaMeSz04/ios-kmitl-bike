//
//  JMBluetoothManager.h
//  MengGouSharedLocksDemo
//
//  Created by Smile on 2017/11/14.
//  Copyright © 2017年 Smile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JMBluetoothTooth.h"
#import "JMBluetoothLockOption.h"

//单例类声明
#define kJMBluetoothManager JMBluetoothManager.sharedManager

@class JMBluetoothModel;
@interface JMBluetoothManager : NSObject


NS_ASSUME_NONNULL_BEGIN

/** Bluetooth specific connection implementation, which encapsulates the native Bluetooth connection code */
@property(nonatomic, strong)JMBluetoothModel *jmBluetoothModel;

/** 单例对象实现方法, 会有一个宏,用于方便书写 */
+(instancetype)sharedManager;

/** The name of the device, which is connected by the name, must be assigned */
@property(nonatomic, copy) NSString *jmDeviceMacAddress;

/** Unlocked password, factory default: 30303030 */
@property(nonatomic, copy) NSString *jmOpenLockPWD;

/**
 连接蓝牙
 
 @param deviceName 连接蓝牙的名称
 @param connectBlock 连接蓝牙的回调, 如果成功error返回的是nil,peripheral返回连接的外设对象, 可以用error来判断是否连接成功
 */
-(void)JMBluetoothStartConnectionWithWidthDeviceMacAddress:(NSString *)deviceName ConnectBlock:(void(^)(JMOperationResult result, CBPeripheral *peripheral, NSError * _Nullable error))connectBlock;

/** 连接成功后, 获取token的回调, 如果token获取失败,开锁操作会失败 */
@property(nonatomic, copy) void(^jmBluetoothGetTokenWithBlock)(NSString *token, NSError * _Nullable error);

#pragma mark - 相关蓝牙操作
/** 开锁 */
- (void)JMOpenLockWidthCallback:(void(^)(JMOperationResult result, NSArray *message, NSError * _Nullable error))callback;

/** 断开连接 */
- (void)JMDisconnect;


NS_ASSUME_NONNULL_END

@end
















