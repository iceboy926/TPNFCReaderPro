//
//  KSWaitingView.h
//  ManagerTool
//
//  Created by KingYH on 16/4/15.
//  Copyright © 2016年 FT EnterSafe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFCCardReader.h"

@interface KSWaitingView : UIWindow

@property (nonatomic, strong) void (^CardReaderCompletionBlock)(NSString *strURL);

@property (nonatomic, strong) NSString *strInputData;

@property (nonatomic, strong) NFCCardReader *CardReader;


-(void)show;

-(void)hide;


@end
