//
//  SZTCard.h
//  ble_nfc_sdk
//
//  Created by sahmoL on 16/6/23.
//  Copyright © 2016年 Lochy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommandAPDU : NSObject

+(instancetype)shareInstance;

-(NSData *)getSelectMainFileCmdByte;

-(NSData *)readCmdByte;

-(NSData *)writeCmdByteWithString:(NSString *)strData;

-(unsigned char)LRC_Check:(unsigned char [])data dataLen:(unsigned long)length;

@end
