//
//  mBluetoothUtil.h
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 8/19/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef mBluetoothUtil_h
#define mBluetoothUtil_h


@interface mBluetoothUtil : NSObject

+(void)connect:(NSString*) macAddress;
+(void)disconnect;
+(void)unlock;

@end

#endif /* mBluetoothUtil_h */
