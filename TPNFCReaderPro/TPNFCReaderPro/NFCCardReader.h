//
//  Card.h
//  TPNFCReaderPro
//
//  Created by 金玉衡 on 16/11/30.
//  Copyright © 2016年 金玉衡. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompletionBlock)(BOOL blSuccess, NSData *responseData);
typedef void(^finishedSearchCardBlock)(BOOL blnIsSuc, NSData *cardSn, NSData *cardATS, Byte cardType);

@interface NFCCardReader : NSObject

@property (nonatomic, strong) TPSDevice *tpsDevice;

- (instancetype)initWithPeripheral:(CBPeripheral *)currentPeripheral;

- (void)SearchCardType:(Byte)cardType completion:(finishedSearchCardBlock) finishblock;

- (void)SendAPDU:(NSData *)apduData  completion:(CompletionBlock) completion;

- (void)closeCard;

@end
