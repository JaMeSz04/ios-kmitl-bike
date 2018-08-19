//
//  JMBluetoothModel.h
//  MengGouSharedLocksDemo
//
//  Created by Smile on 2017/11/14.
//  Copyright © 2017年 Smile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JMBluetoothTooth.h"

/**
 This class encapsulates the specific logical implementation code of the Bluetooth connection
 
 Including: Bluetooth connection, sending data, receiving message callbacks, and so on
 */
@interface JMBluetoothModel : NSObject

/** 单例类 */
+(instancetype _Nullable )sharedManager;

/** 蓝牙中心 */
@property(nonatomic,strong,)CBCentralManager * _Nullable jm_CenterManager;

//作用:抑制警告
NS_ASSUME_NONNULL_BEGIN

/** 当前连接蓝牙的外设 */
@property(nonatomic,strong)CBPeripheral *jm_Peripheral;

/** The callback of the connection success, the connection failure execution */
@property(nonatomic, copy) void(^jmConnectBlock)(CBPeripheral * peripheral, NSError * _Nullable error);


/** The callback of the eigenvalues is found, because the Bluetooth transmission protocol for each hardware is different, so the user needs to be defined by the user. */
@property(nonatomic,copy) void(^jmDiscoverCharacteristics)(CBPeripheral *peripheral, CBService *service, NSError *error);


/** 读取characteristics 外设特征发送的数据的回调 */
@property(nonatomic, copy) void(^jmReadValueForCharacteristic)(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error);

/**
 开始扫描, 第一个执行的方法, 里面将会初始化蓝牙中心管理对象
 
 @param serviceUUIDs 需要扫描那些设备的UUID数组
 @param scanBlcok 扫描到外设执行的回调
 */
- (void)benginScanPeripharelWithServices:(NSArray<CBUUID *> *)serviceUUIDs ScanBlcok:(BOOL(^)(CBPeripheral * peripheral,NSDictionary<NSString *,id> * advertisementData))scanBlcok;

NS_ASSUME_NONNULL_END

@end
