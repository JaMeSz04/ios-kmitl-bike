//
//  JMBluetoothModel.m
//  MengGouSharedLocksDemo
//
//  Created by Smile on 2017/11/14.
//  Copyright © 2017年 Smile. All rights reserved.
//

#import "JMBluetoothModel.h"

@interface JMBluetoothModel()<CBCentralManagerDelegate,CBPeripheralDelegate>
//扫描指定UIID的蓝牙
@property(nonatomic, strong) NSArray<CBUUID *> *serviceUUIDs;

//扫描到外设的回调
@property(nonatomic,copy)BOOL(^scanBlock)(CBPeripheral *peripharel, NSDictionary<NSString *,id> *advertisementData);

@end



@implementation JMBluetoothModel

//单例类
+(instancetype)sharedManager{
    
    static JMBluetoothModel *sharedModel = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedModel = [[self alloc] init];
    });
    
    return sharedModel;
    
}

-(void)benginScanPeripharelWithServices:(NSArray<CBUUID *> *)serviceUUIDs ScanBlcok:(BOOL (^)(CBPeripheral * _Nonnull, NSDictionary<NSString *,id> * _Nonnull))scanBlcok
{
    //1.创建蓝牙中心
    if (self.jm_CenterManager == nil) {
        
        //初始化, 设置代理
        self.jm_CenterManager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];
    }
    
    //3.保存block 保存服务UUID数组
    self.scanBlock = scanBlcok;
    self.serviceUUIDs = serviceUUIDs;
}


#pragma mark - CBCentralManagerDelegate 蓝牙中心代理方法
// 在连接蓝牙前先检查中心的蓝牙是否打开
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    
    switch (central.state){

        case CBCentralManagerStateUnsupported:
            JMLog(@">>>CBCentralManagerStateUnsupported 该平台不支持蓝牙。");
            break;
        case CBCentralManagerStateUnauthorized:
            JMLog(@">>>CBCentralManagerStateUnauthorized 该应用程序没有授权使用蓝牙。");
            break;
        case CBCentralManagerStatePoweredOff:
            JMLog(@">>>CBCentralManagerStatePoweredOff 蓝牙未打开");
            break;
        case CBCentralManagerStatePoweredOn:
            JMLog(@">>>CBCentralManagerStatePoweredOn");
            [self.jm_CenterManager scanForPeripheralsWithServices:self.serviceUUIDs options:nil];
            break;
        default:
            break;
    }
    
    //ISO10之后需要使用 CBManagerStatePoweredOn
}

/// 发现到了蓝牙
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
    
    //2.执行block回调
    if (self.scanBlock) {
        
        if (self.scanBlock(peripheral, advertisementData)) {
            
            self.jm_Peripheral = peripheral;
            [self.jm_CenterManager connectPeripheral:peripheral options:nil];
            [self.jm_CenterManager stopScan];
            return;
        }
    }
}

#pragma 成功连接到外设
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    
    //1. 记录连接到的外设,设置外设代理
    self.jm_Peripheral = peripheral;
    self.jm_Peripheral.delegate = self;
    
    //4. 执行连接成功的block回调
    if (self.jmConnectBlock) {
        self.jmConnectBlock(peripheral,nil);
    }
}



#pragma 连接外设失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error
{
    
    //5. 连接失败, 执行block回调告诉外界连接失败
    if (self.jmConnectBlock) {
        self.jmConnectBlock(peripheral,error);
    }
}

#pragma 外设断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error
{
    
    if (error == NULL){
        //停止扫描
        [self.jm_CenterManager stopScan];
        //断开连接
        [self.jm_CenterManager cancelPeripheralConnection:peripheral];
        
        [self.jm_CenterManager cancelPeripheralConnection: self.jm_Peripheral];
        self.jm_CenterManager.delegate = nil;
        self.jm_CenterManager = nil;
        return;
    }
}

#pragma mark - CBPeripheralDelegate Bluetooth peripherals proxy method
// Discovery of peripherals
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error
{
    for (CBService *service in peripheral.services) {
        [self.jm_Peripheral discoverCharacteristics:nil forService:service];
    }
}

/// 5.Access to the services of peripherals & the features of access to services
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (self.jmDiscoverCharacteristics) {
        self.jmDiscoverCharacteristics(peripheral, service, error);
    }
}

// 6.Reading data from peripherals
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (self.jmReadValueForCharacteristic) {
        self.jmReadValueForCharacteristic(peripheral, characteristic, error);
    }
}


@end





















