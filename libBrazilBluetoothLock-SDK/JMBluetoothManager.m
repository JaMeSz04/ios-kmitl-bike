//
//  JMBluetoothManager.m
//  MengGouSharedLocksDemo
//
//  Created by Smile on 2017/11/14.
//  Copyright © 2017年 Smile. All rights reserved.
//

#import "JMBluetoothManager.h"
#import "JMAES128.h"
#import "JMBluetoothLockOption.h"

@interface JMBluetoothManager()

/** token */
@property (nonatomic, copy) NSString *token;

/** 指令操作回调  Instruction operation callback */
@property (nonatomic, copy) void(^instructionsCallback)(JMOperationResult result,NSArray *message, NSError * _Nullable error);

/** 连接蓝牙回调  Connecting Bluetooth callback */
@property(nonatomic, copy) void(^connectBlock)(JMOperationResult result, CBPeripheral * peripheral, NSError * _Nullable error);

@end


@implementation JMBluetoothManager

#pragma mark - A.执行指令方法 Execution instruction method
#pragma mark -1.Get Token
- (void)JMGetTokenWidthCallback:(void(^)(JMOperationResult result, NSArray *message, NSError * _Nullable error))callback{
    self.instructionsCallback = callback;
    [self executeOperationWidthData:kGetToken isReadData:YES];
}

#pragma mark -2.Unlock
- (void)JMOpenLockWidthCallback:(void(^)(JMOperationResult result, NSArray *message, NSError * _Nullable error))callback{
    self.instructionsCallback = callback;
    
    //拼接开锁密码  Stitching unlocking cipher
    NSString *str = [NSString stringWithFormat:@"%@%@", kOpenLock, self.jmOpenLockPWD];
    
    [self executeOperationWidthData:str isReadData:NO];
}


#pragma mark - B.设置从外设读取的数据后的回调 Setting the callback after the data read from the peripherals
-(void)readValueForCharacteristic{
    
    __weak typeof(self) weakSelf = self;
    //4. 设置从外设读取的数据后的回调
    self.jmBluetoothModel.jmReadValueForCharacteristic = ^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        
        if (error != nil){
            NSString *msg = @"Failure to read data from peripherals";
            JMLog(@"%@", msg);
            NSError *err = [[NSError alloc] initWithDomain:msg code:-1 userInfo:@{@"info":@[msg]}];
            
            weakSelf.instructionsCallback(Get_TOKEN, @[msg], err);
            return;
        }
        
        NSData * dataValue = characteristic.value;
        
        JMLog(@"Peripherals return data:%@", dataValue);
        
        //1.数据转换, 解密 Data conversion, decryption
        NSString *dataHexStr = [JMDataConversionTool JMConvertDataToHexStr:dataValue];
        NSString *dataStr = [JMAES128 AES128DecryptString:dataHexStr];
        
        if (dataStr == nil || dataStr.length == 0){
            
            JMLog(@"Return data to null");
            NSError *err = [[NSError alloc] initWithDomain:@"Return data to null" code:-1 userInfo:@{@"info":@[@"Failure of instruction execution"]}];
            
            weakSelf.instructionsCallback(RESERVE, @[@"Failure of instruction execution"], err);
            return;
        }
        
        dataStr = [dataStr uppercaseString];
        JMLog(@"Decrypted information%@", dataStr);
        
        NSString *message = @"";
        JMOperationResult result = RESERVE;
        NSError *callBackError = nil;
        
        
        //1.获取令牌 Get Token
        if ([dataStr hasPrefix:kGetTokenPrefix]){
            result = Get_TOKEN;
            NSString *str = [dataStr substringWithRange:NSMakeRange(6, 8)];
            if (str != nil && ![str isEqualToString:@""]){
                message = str;
            }else{
                callBackError = [[NSError alloc] initWithDomain:@"Failure of instruction execution" code:-1 userInfo:@{@"info":@[@"The execution of the instruction failed and the data format was incorrect"]}];
            }
        }else if ([dataStr hasPrefix:kOpenLockPrefix]){
            result = Open_Lock;
            NSString *str = [dataStr substringWithRange:NSMakeRange(6, 2)];
            if (str == nil || [str isEqualToString:@""] || [str isEqualToString:@"01"]){
                callBackError = [[NSError alloc] initWithDomain:@"Failure of instruction execution" code:-1 userInfo:@{@"info":@[@"Failure of instruction execution,Unlock failure"]}];
            }else{
                message = @"Unlocking success";
            }
        }
        //关锁设备返回的数据
        else if ([dataStr hasPrefix:kCloseLockPrefix]){
            result = Close_Lock;
            NSString *str = [dataStr substringWithRange:NSMakeRange(6, 2)];
            
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
            if (str == nil || [str isEqualToString:@""] || [str isEqualToString:@"01"]){
                
                callBackError = [[NSError alloc] initWithDomain:@"Failure of instruction execution" code:-1 userInfo:@{@"info":@[@"Failure of instruction execution,Lock failure"]}];
                [userInfo setObject:@1 forKey:@"info"];
                [userInfo setObject:callBackError forKey:@"error"];
                
            }else{
                [userInfo setObject:@0 forKey:@"info"];
                message = @"Lock success";
            }
            
            [NSNotificationCenter.defaultCenter postNotificationName:kCloseLockNotificationName object:nil userInfo:userInfo];
            
            return;
        }
        
        //050801
        else{
            callBackError = [[NSError alloc] initWithDomain:@"Failure of instruction execution" code:-1 userInfo:@{@"info":@[@"The execution of the instruction failed and the data format was incorrect"]}];
        }
        
        NSArray *arr = [[NSArray alloc] initWithObjects:message, nil];
        weakSelf.instructionsCallback(result, arr, callBackError);
    };
}


#pragma mark - Scan, connect Bluetooth
-(void)JMBluetoothStartConnectionWithWidthDeviceMacAddress:(NSString *)deviceName ConnectBlock:(void(^)(JMOperationResult result, CBPeripheral *peripheral, NSError * _Nullable error))connectBlock{
    
    self.connectBlock = connectBlock;
    
    __weak typeof(self) weakSelf = self;
    
    NSArray<CBUUID *> * uuids = @[[CBUUID UUIDWithString:@"FEE7"]];
    //1.开始扫描
    [self.jmBluetoothModel benginScanPeripharelWithServices:uuids ScanBlcok:^BOOL(CBPeripheral * _Nonnull peripheral, NSDictionary<NSString *,id> * _Nonnull advertisementData) {

        //Take out the MAC address of the device and judge whether it can be connected according to the MAC address
        NSData * data = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
        NSString * macStr = [JMDataConversionTool JMConvertDataToHexStr:data];
        
        JMLog(@"mac:%@", [macStr uppercaseString]);
        if (macStr != nil && ![macStr isEqualToString:@""]) {
            if ([self.jmDeviceMacAddress isEqualToString:[macStr uppercaseString]]){
                return YES;
            }
        }
        
        return NO;
    }];
    
    
    //2.Connect to the callback of the successful execution Then the token request is sent.
    self.jmBluetoothModel.jmConnectBlock = ^(CBPeripheral *peripheral, NSError *error) {
        
        //The Bluetooth connection successfully executes the callback of the configuration read device information
        [weakSelf readValueForCharacteristic];
        
        //Get Token
        [weakSelf JMGetTokenWidthCallback:^(JMOperationResult result, NSArray *message, NSError * _Nullable error) {
            
            weakSelf.token = message[0];
            if (error == nil) {
                
                if (weakSelf.jmBluetoothGetTokenWithBlock) {
                    weakSelf.jmBluetoothGetTokenWithBlock(weakSelf.token, nil);
                }
            }else{
                JMLog(@"Getting token failure:%@", error);
                if (weakSelf.jmBluetoothGetTokenWithBlock) {
                    weakSelf.jmBluetoothGetTokenWithBlock(weakSelf.token, error);
                }
            }
        }];
        
        //Whether the connection is successful or failed to tell the outside world
        connectBlock(RESERVE, peripheral, error);
    };
}



#pragma mark -Performing specific operation command operations
- (void)executeOperationWidthData:(NSString *)dataStr isReadData:(BOOL)isRead{
    
    
    if (dataStr == nil || [dataStr length] == 0) {
        return;
    }
    
    dataStr = [dataStr stringByAppendingString:self.token];
    
    if (dataStr.length < 32) {
        //The length is less than 32 to fill 0
        dataStr = [self CharacterStringMainAddDigit:32 andStr:dataStr AddString:@"0"];
    }
    //The data is encrypted first, and then the string is converted to the Data type to send to the car lock
    NSString *str = [JMAES128 AES128EncryptStrig:dataStr];
    NSData *data = [JMDataConversionTool JMConvertHexStrToData:str];
    
    //3.send data
    [self JMBluetoothDeviceWritesDataWithCharacterisServices:nil andCharacteris:kJMProtocolWrite andWithData:data];
}

-(NSString *)CharacterStringMainAddDigit:(int)AddDigit andStr:(NSString *)str AddString:(NSString*)AddString{
    NSString*ret = [[NSString alloc]init];
    
    ret = str;
    for(int y =0;y < (AddDigit - str.length) ;y++ ){
        
        ret = [NSString stringWithFormat:@"%@%@",ret,AddString];
        
    }
    return ret;
}

/**
 
 
 Characteristic    36F5      写
 Characteristic    36F6      通知
 */
#pragma mark -读写数据
-(void)JMBluetoothDeviceWritesDataWithCharacterisServices:(NSArray<CBUUID *> *)serviceUUIDs andCharacteris:(NSString *)characteris andWithData:(NSData *)data{
    
    __weak typeof(self) weakSelf = self;
    
    NSMutableArray<CBUUID *> *ss = [NSMutableArray array];
    [ss addObject:[CBUUID UUIDWithString:kJMProtocolRead]];
    [ss addObject:[CBUUID UUIDWithString:kJMProtocolWrite]];
    
    [self.jmBluetoothModel.jm_Peripheral discoverServices:serviceUUIDs];
    //3. Setting the callback of the selected feature value
    self.jmBluetoothModel.jmDiscoverCharacteristics = ^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        
        for (CBCharacteristic * characteristic in service.characteristics) {
            
            if ([characteristic.UUID.UUIDString isEqualToString:characteris]) {
                
                //36F5写入数据
                [weakSelf.jmBluetoothModel.jm_Peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
            }else if ([characteristic.UUID.UUIDString isEqualToString:kJMProtocolRead]){
                
                //FD02接收通知
                [weakSelf.jmBluetoothModel.jm_Peripheral setNotifyValue:YES forCharacteristic:characteristic];
            }
        }
    };
}


//#pragma mark - get方法
-(JMBluetoothModel *)jmBluetoothModel{
    
    if (_jmBluetoothModel == nil) {
        _jmBluetoothModel = [JMBluetoothModel sharedManager];
    }
    return _jmBluetoothModel;
}

-(NSString *)token{
    if (_token == nil) {
        return @"";
    }else{
        return _token;
    }
}

-(NSString *)jmOpenLockPWD{
    if (_jmOpenLockPWD == nil) {
        return @"303030303030";
    }else{
        return _jmOpenLockPWD;
    }
}

//单例类
+(instancetype)sharedManager{
    
    static JMBluetoothManager *sharedMyManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    
    return sharedMyManager;
}

#pragma mark - Disconnect
- (void)JMDisconnect{
    [self.jmBluetoothModel.jm_CenterManager cancelPeripheralConnection: self.jmBluetoothModel.jm_Peripheral];
    self.jmBluetoothModel.jm_CenterManager.delegate = nil;
    self.jmBluetoothModel.jm_CenterManager = nil;
}




@end
