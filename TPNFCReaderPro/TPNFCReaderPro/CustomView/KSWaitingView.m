//
//  KSWaitingView.m
//  ManagerTool
//
//  Created by KingYH on 16/4/15.
//  Copyright © 2016年 FT EnterSafe. All rights reserved.
//

#import "KSWaitingView.h"
#import "NSData+Hex.h"
#import "Command.h"

#define KSMessageBoxFrame CGRectMake(0.0f, 0.0f, 280.0f, 180.0f)

@interface KSWaitingView()
{
    UIView *_mask;
    UIImageView *_messageBg;
    UIActivityIndicatorView *_indicator;
    UILabel *_messageLabel;
    NSLock *locker;
}

@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) NSTimer *timer;


@end



@implementation KSWaitingView




-(id)init
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self = [super initWithFrame:window.bounds];
    if(self)
    {
        self.windowLevel = UIWindowLevelNormal;
        self.backgroundColor = [UIColor clearColor];
        
        self.backgroundColor = [UIColor clearColor];
        
        UIView *mask = [[UIView alloc] initWithFrame:self.bounds];
        mask.backgroundColor =  [UIColor blackColor];
        mask.alpha = 0;
        _mask = mask;
        [self addSubview:mask];
        
        
        UIImageView *messageBoxBg = [[UIImageView alloc] initWithFrame:KSMessageBoxFrame];
        messageBoxBg.center = CGPointMake(CGRectGetWidth(self.frame)/2.0f, CGRectGetHeight(self.frame)/2.0f);        messageBoxBg.image = [[UIImage imageNamed:@"alert_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        messageBoxBg.layer.shadowColor = [UIColor blackColor].CGColor;
        messageBoxBg.layer.shadowOffset = CGSizeMake(0, 0);
        messageBoxBg.layer.shadowRadius = 5.0f;
        messageBoxBg.layer.shadowOpacity = 0.2;
        messageBoxBg.layer.shouldRasterize = YES;
        
        //messageBoxBg.backgroundColor = [UIColor whiteColor];
        
        _messageBg = messageBoxBg;
        [self addSubview:messageBoxBg];
        
        _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
        _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        CGRect frame = _indicator.frame;
        frame.origin.x = (CGRectGetWidth(_messageBg.frame) - CGRectGetWidth(frame))/2.0f;
        frame.origin.y = 30.0f;
        _indicator.frame = frame;
        [_messageBg addSubview:_indicator];
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, CGRectGetMaxY(_indicator.frame) + 10.0f, 240.0f, 36.0f)];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.font = [UIFont systemFontOfSize:18.0f];
        messageLabel.numberOfLines = 2;
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;//UILineBreakModeWordWrap;
        _messageLabel = messageLabel;
        [_messageBg addSubview:messageLabel];
        
    }
    
    
    return self;
}



-(void)show
{
    self.hidden = NO;
    
    self.messageLabel.text = @"等待读卡操作......";
    self.messageLabel.textColor = [UIColor blackColor];
    
    _mask.alpha = 0;
    [UIView animateWithDuration:0.1 animations:^{
       
        _mask.alpha = 0.4f;
        
        [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    }];
    _messageBg.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.5],
                              [NSNumber numberWithFloat:1.2],
                              [NSNumber numberWithFloat:0.9],
                              [NSNumber numberWithFloat:1.0], nil];
    bounceAnimation.duration = 0.4f;
    bounceAnimation.removedOnCompletion = NO;
    [_messageBg.layer addAnimation:bounceAnimation forKey:@"bounce"];
    
    [_indicator startAnimating];

     self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(refresh:) userInfo:nil repeats:YES];
}

-(void)hide
{
    _mask.alpha = 0.2;
    [_timer invalidate];
    [UIView animateWithDuration:0.1 animations:^{
        _mask.alpha = 0.0f;
    }];
    
    
    _messageBg.layer.transform = CATransform3DMakeScale(0.0, 0.0, 1.0);
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:1.0],
                              [NSNumber numberWithFloat:1.1],
                              [NSNumber numberWithFloat:0.5],
                              [NSNumber numberWithFloat:0.0], nil];
    bounceAnimation.duration = 0.3f;
    bounceAnimation.removedOnCompletion = NO;
    bounceAnimation.delegate = self;
    [_messageBg.layer addAnimation:bounceAnimation forKey:@"hidebounce"];
    
    //_messageBg.layer.transform = CATransform3DIdentity;
    
    [_indicator stopAnimating];
    
    self.hidden = YES;
    
}

- (void)refresh:(NSTimer *)timer
{
    WEAK_SELF(weakself)
    [self.CardReader SearchCardType:TPS_CARD_TYPE_UNKNOWN completion:^(BOOL blnIsSuc, NSData *cardSn, NSData *cardATS, Byte cardType) {
    
        if(blnIsSuc)
        {
            NSLog(@"read card OK..card type is %d", cardType);
            
            if (cardType == TPS_CARD_TYPE_A)
            {
                [self.CardReader SendAPDU:[[Command shareInstance] getSelectMainFileCmdByte] completion:^(BOOL blSuccess, NSData *responseData){
                    
                        if(blSuccess)
                        {
                            [self.CardReader SendAPDU:[[Command shareInstance] readCmdByte] completion:^(BOOL isCmdRunSuc, NSData *apduRtnData){
                                
                                if(isCmdRunSuc)
                                {
                                    
                                    NSString *strOut = [apduRtnData hexadecimalString];
                                    
                                    NSLog(@" read out data is %@", strOut);
                                    
                                    NSData *dataSend = [[Command shareInstance] writeCmdByteWithString:self.strInputData];
                                    
                                    [self.CardReader SendAPDU:dataSend completion:^(BOOL isCmdRunSuc, NSData *apduRtnData){
                                        
                                        if(isCmdRunSuc)
                                        {
                                            
                                            [self.CardReader SendAPDU:[[Command shareInstance] readCmdByte] completion:^(BOOL isCmdRunSuc, NSData *apduRtnData){
                                                
                                                
                                                NSString *strOut = [apduRtnData hexadecimalString];
                                                
                                                NSLog(@" TPS_CARD_TYPE_A read out data is %@", strOut);
                                                
                                                int len = strOut.length - 4;
                                                
                                                NSString *stroutData = [strOut substringToIndex:len];
                                                
                                                NSLog(@" TPS_CARD_TYPE_A read out data is %@", stroutData);
                                                
                                                NSData *dataout = [NSData dataWithHexString:stroutData];
                                                
                                                __block NSString *strurl = [[NSString alloc] initWithData:dataout encoding:NSUTF8StringEncoding];
                                                
                                                NSLog(@"strurl = %@", strurl);
                                                
                                                
                                                
                                                [self.CardReader closeCard];
                                                
                                                [_indicator stopAnimating];
                                                [_timer invalidate];
                                                weakself.messageLabel.text = @"读卡成功,即将跳转到相关页面";
                                                weakself.messageLabel.textColor = [UIColor redColor];
                                                
                                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                
                                                    [weakself hide];
                                                    
                                                    if(weakself.CardReaderCompletionBlock)
                                                    {
                                                        weakself.CardReaderCompletionBlock(strurl);
                                                    }
                                                });
                                            }];
                                        }
                                        
                                    }];
                                }
                            }];
                        }
                }];
                
            }
            else if (cardType == TPS_CARD_TYPE_B)
            {
                
            }
            else if (cardType == TPS_CARD_TYPE_M1)
            {
                
            }
            else if (cardType == TPS_CARD_TYPE_F)
            {
            }
            else
            {
                
            }
            
        }
    }];
    
}


@end
