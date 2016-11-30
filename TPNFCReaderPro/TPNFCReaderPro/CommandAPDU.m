//
//  NFCCard.m
//  ble_nfc_sdk
//
//  Created by sahmoL on 16/6/23.
//  Copyright © 2016年 Lochy. All rights reserved.
//

#import "CommandAPDU.h"
#import "NSData+Hex.h"


static unsigned char ucData[1024];  //发送数据
static unsigned long ucDataLenth;  //发送数据的长度

@interface CommandAPDU()

@end

@implementation CommandAPDU

+(instancetype)shareInstance
{
    static CommandAPDU *commandInstance;
    
    static dispatch_once_t once_t;
    
    dispatch_once(&once_t, ^{
    
        if(commandInstance == nil)
        {
            commandInstance = [[CommandAPDU alloc] init];
            
        }
    
    });
    
    return commandInstance;
}


//清空数据
-(void)clear
{
    memset(ucData,'\0', 1024);
    ucDataLenth = 0;
}

//插入数据
-(void)insert:(unsigned long)value
{
    ucData[ucDataLenth] = value;
    ucDataLenth++;
}


// select file
-(NSData *)getSelectMainFileCmdByte{
    
    Byte bytes[] = {0x00, (Byte)0xa4, 0x04, 0x00, 0x07, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07};
    int len = 12;
    
    [self clear];
    [self insert:0x20];
    
    [self insert:len/0x100];
    [self insert:len%0x100];

    for (int i = 0; i < 12; i++) {
        
        [self insert:bytes[i]];
    }
    
    unsigned char lrc = [self LRC_Check:ucData dataLen:ucDataLenth];
    
    [self insert:lrc];
    
    return [NSData dataWithBytes:ucData length:ucDataLenth];
}

// read data

-(NSData *)readCmdByte
{
    Byte bytes[] = {0x00, (Byte)0x02, 0x00, 0x00, 0x00};
    int len = 5;
    
    [self clear];
    [self insert:0x20];
    
    [self insert:len/0x100];
    [self insert:len%0x100];
    
    for(int i = 0; i < len; i++)
    {
        [self insert:bytes[i]];
    }
    
    unsigned char lrc = [self LRC_Check:ucData dataLen:ucDataLenth];
    
    [self insert:lrc];
    
    return [NSData dataWithBytes:ucData length:ucDataLenth];
}


//write data
-(NSData *)writeCmdByteWithString:(NSString *)strData
{
    Byte byte[128] = {0x00};
    unsigned long len = 0;
    const char *szInputData = [strData UTF8String];
    
    byte[1] = 0x01;
    byte[4] = (Byte)strlen(szInputData);
    
    memcpy(&byte[5], szInputData, strData.length);
  
    len = strData.length + 5;
    
    
    [self clear];
    [self insert:0x20];
    
    [self insert:len/0x100];
    [self insert:len%0x100];
    
    for(int i = 0; i < len; i++)
    {
        [self insert:byte[i]];
    }
    
    unsigned char lrc = [self LRC_Check:ucData dataLen:ucDataLenth];
    
    [self insert:lrc];

    
    return [NSData dataWithBytes:ucData length:ucDataLenth];
}


-(unsigned char)LRC_Check:(unsigned char[])data dataLen:(unsigned long)length
{
    uint16_t i;
    uint32_t k=0;
    uint8_t result;
    
    for(i=1;i<length;i++)
    {
        k=k^data[i];
    }
    
    result=k;
    return result;
}
@end
