//
//  main.m
//  TPNFCReaderPro
//
//  Created by 金玉衡 on 16/11/29.
//  Copyright © 2016年 金玉衡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        LoggerStart(LoggerGetDefaultLogger());
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
