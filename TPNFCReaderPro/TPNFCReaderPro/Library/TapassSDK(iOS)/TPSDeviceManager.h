//
//  TPSDeviceManager.h
//  TapassSDK
//
//  Created by Max on 15/12/2.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#ifndef TPSDeviceMangerStatusEnum
#define TPSDeviceMangerStatusEnum
typedef enum{
    STATE_UNKNOWN = 0,
    STATE_IDLE,
    STATE_SCANNING
}TPSDeviceManagerScanStatus;
#endif

@class TPSDevice;
@class TPSDeviceManager;


/* 设备扫描代理 */
@protocol TPSDeviceManagerDelegate <NSObject>
@optional
-(void) onManagerStateReady:(BOOL)isReady;  // 设备就绪
-(void) onReceiveScanPeripheral:(CBPeripheral *)peripheral;
-(void) onReceiveScanPeripheral:(CBPeripheral *)peripheral withMac:(NSString *)mac;
-(void) onScanPeripheralStopped;
-(void) onReceiveConnectDevice:(TPSDeviceManager*)manager peripheral:(CBPeripheral*)peripheral;
-(void) onReceiveDisconnectDevice:(TPSDeviceManager*)manager peripheral:(CBPeripheral*)peripheral;
-(void) onReceiveConnectDeviceFailed:(NSError*)error;

@end


/* 设备管理类，负责扫描外设，连接扫描到的指定设备，断开连接 */
@interface TPSDeviceManager : NSObject<CBCentralManagerDelegate>

@property (weak, nonatomic) id<TPSDeviceManagerDelegate> delegate;

-(instancetype)initWithDelegate:(id<TPSDeviceManagerDelegate>)delegate;

-(void)scanDevice;  // 持续扫描，需手动停止扫描
-(void)scanDevice:(NSTimeInterval)scanPeriod; // 周期扫描，自动停止
-(void)connectPeripheral:(CBPeripheral*)peripheral;
-(void)disConnectPeripheral:(CBPeripheral*)peripheral;
-(void)stopScanDevice; // 手动停止扫描
-(void)connectTPSDevice:(TPSDevice *)tpsDevice; // 重连已连接过的设备

@end
