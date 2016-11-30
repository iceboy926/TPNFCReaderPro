//
//  Card.m
//  TPNFCReaderPro
//
//  Created by 金玉衡 on 16/11/30.
//  Copyright © 2016年 金玉衡. All rights reserved.
//

#import "NFCCardReader.h"

@interface NFCCardReader() <TPSDeviceDelegate>

@property (nonatomic, copy)finishedSearchCardBlock searchCardblock;
@property (nonatomic, copy)CompletionBlock completionblock;

@end

@implementation NFCCardReader


- (instancetype)initWithPeripheral:(CBPeripheral *)currentPeripheral
{
    self = [super init];
    if(self)
    {
        self.tpsDevice = [[TPSDevice alloc] initWithPeripheral:currentPeripheral delegate:self];
    }
    
    return self;
}

- (void)SearchCardType:(Byte)cardType completion:(finishedSearchCardBlock) finishblock
{
    self.searchCardblock = finishblock;
    
    [self.tpsDevice requestRfmSearchCard:cardType];
}

- (void)SendAPDU:(NSData *)apduData  completion:(CompletionBlock) completion
{
    self.completionblock = completion;
    
    NSLog(@"requestRfmSendApduCmd is %@", apduData);
    
    [self.tpsDevice requestRfmSendApduCmd:apduData];
    
}

- (void)closeCard
{
    [self.tpsDevice requestRfmClose];
}


#pragma mark tpsdevicedelegate

-(void) onReceiveStatusReady:(Boolean)blnIsReady  // 初始化完成后，需要监听此方法
{
    if(blnIsReady)
    {
        NSLog(@"RfmCard Ready");
    }
}

-(void) onReceiveRfmSearchCard:(Boolean)blnIsSuc csn:(NSData *)cardSn ats:(NSData *)cardATS cardType:(Byte)cardType
{
    NSLog(@" onReceiveRfmSearchCard cardsn is %@", cardSn);
    if(self.searchCardblock)
    {
        self.searchCardblock(blnIsSuc, cardSn, cardATS, cardType);
    }
}

-(void) onReceiveRfmSendApduCmd:(NSData *)apduRtnData
{
    NSLog(@"onReceiveRfmSendApduCmd : %@", apduRtnData);
    if(self.completionblock)
    {
        self.completionblock(YES, apduRtnData);
    }
}

-(void) onReceiveRfmClose:(Boolean)blnIsCloseSuc
{
    if(blnIsCloseSuc)
    {
        NSLog(@" Rfm Close Success");
    }
 
}

@end
