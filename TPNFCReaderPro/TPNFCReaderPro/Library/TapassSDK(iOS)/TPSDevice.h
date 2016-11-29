//
//  TPSDevice.h
//  TapassSDK
//
//  Created by Max on 15/12/4.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

// 设备信息KEY值
#define KEY_PROD_MODEL      @"PROD_MODEL"    //  产品型号        ==>NSData
#define KEY_PROD_HW_VER     @"PROD_HW_VER"   //  产品硬件版本     ==>Byte
#define KEY_PROD_PN         @"PROD_PN"       //  产品批号        ==>NSData
#define KEY_PROD_SN         @"PROD_SN"       //  产品编号        ==>NSData
#define KEY_PROD_SW_VER     @"PROD_SW_VER"   //  软件版本        ==>Byte
#define KEY_SYS_FLAG        @"SYS_FLAG"      //  系统标志        ==>Byte
#define KEY_CHIP_UID        @"CHIP_UID"      //  芯片唯一ID号     ==>Byte
#define KEY_BT_AUTH         @"BT_AUTH"       //  蓝牙鉴权        ==>NSData
#define KEY_BT_NAME         @"BT_NAME"       //  蓝牙模块名称     ==>NSData
#define KEY_BT_PIN          @"BT_PIN"        //  蓝牙模块密码     ==>NSData
#define KEY_BT_ADDR         @"BT_ADDR"       //  蓝牙模块地址     ==>NSData
#define KEY_VOLT_PERCENT    @"VOLT_PERCENT"  //  电量            ==>Byte
#define KEY_CHG_STATE       @"CHG_STATE"     //  充电状态         ==>Byte
#define KEY_TDK_VER         @"TDK_VER"       //  数据加密密钥版本   ==>Byte
#define KEY_TDK             @"TDK"
#define KEY_AMK_VER         @"AMK_VER"       //  机具维护密钥版本   ==>Byte
#define KEY_AMK             @"AMK"
#define KEY_UIM_CONFIG      @"UIM_CONFIG"
#define KEY_UIC_CSN         @"UIC_CSN"
#define KEY_UIC_ATS         @"UIC_ATS"
#define KEY_ICC_TYPE        @"ICC_TYPE"
#define KEY_ICC_TAG_TYPE    @"ICC_TAG_TYPE"
#define KEY_ICC_SAK         @"ICC_SAK"

#define TPS_DEBUG  1        // 默认打开调试模式

typedef enum
{
    RSP_OK = 0x00,
    RSP_CMD_ERR,
    RSP_DATA_LEN_ERR,
    RSP_DATA_FMT_ERR,
    RSP_BCC_ERR,
    RSP_BUSY,
    RSP_STAGE_ERR,
    RSP_CONDITION_ERR,
    RSP_HARDWARE_ERR,
    RSP_UNDEFINED_ERR,
    RSP_NO_SUPPORT,
    RSP_FILE_ERR,
    RSP_TRANS_WAIT,
    RSP_TRANS_CANCEL,
    RSP_TRANS_TIMEOUT,
    RSP_NUM
}RSP_TYPE;

#ifndef apdu_cmd_h
#define apdu_cmd_h
typedef enum{
    SELECT_PPSE = 1,
    SELECT_FILE_BY_AID,
    SELECT_FILE_BY_FID,
    READ_BINARY,
    UPDATE_BINARY,
    READ_RECORD,
    UPDATE_RECORD,
    GET_CHALLENGE,
    CREDIT_FOR_LOAD,
    DEBIT_FOR_PURCHASE_CASH,
    GET_BALANCE,
    INIT_FOR_LOAD,
    INIT_FOR_PURCHASE,
    INTI_FOR_CAPP_PURCHASE,
    UPDATE_CAPP_DATA,
    DEBIT_FOR_CAPP_PURCHASE,
    GENERAT_AC,
    GET_DATA,
    GET_PROCESSING_OPTION,
    PUT_DATA,
    READ_CAPP_DATA,
    PBOC_UPDATE_CAPP,
    PBOC_EXTERNAL_AUTH,
    PBOC_INTERNAL_AUTH,
    APPEND_RECORD,
    GET_TRANS_PROVE,
    SEND_APDU_CMD
}APDU_COMMAND;
#endif


#ifndef TRANS_MODE
#define TRANS_MODE
typedef enum{
    PLAIN,
    DES3_ECB
}TransferMode;
#endif

#ifndef TPS_CARD_TYPE
#define TPS_CARD_TYPE
const static Byte TPS_CARD_TYPE_UNKNOWN = 0x00;
const static Byte TPS_CARD_TYPE_A = 0x01;
const static Byte TPS_CARD_TYPE_B = 0x02;
const static Byte TPS_CARD_TYPE_M1 = 0x03;
const static Byte TPS_CARD_TYPE_F = 0x04;
#endif

@protocol TPSDeviceDelegate <NSObject>
@required
-(void) onReceiveStatusReady:(Boolean)blnIsReady;  // 初始化完成后，需要监听此方法
@optional
-(void) onReceiveInitCiphy:(Boolean)blnIsInitSuc;
-(void) onReceiveSetDeviceInitInfo:(NSDictionary *)bleDevInitInfo;
-(void) onReceiveGetDeviceVisualInfo:(NSDictionary *)bleDevVisualInfo;
-(void) onReceiveRfmSearchCard:(Boolean)blnIsSuc csn:(NSData *)cardSn ats:(NSData *)cardATS cardType:(Byte)cardType;
-(void) onReceiveRfmSendApduCmd:(NSData *)apduRtnData;
-(void) onReceiveRfmClose:(Boolean)blnIsCloseSuc;
-(void) onReceiveUpdateDeviceName:(NSString*)updatedName;
-(void) onReceiveDeviceAuth:(NSData*)authData;
//- (void) didReceiveData:(NSData *) data;
//- (void) didUpdateStatus:(Byte)status;
//@optional
//- (void) didReadHardwareRevisionString:(NSString *) data;
@end


// 设备类
@interface TPSDevice : NSObject  <CBPeripheralDelegate>
@property(weak,nonatomic) id<TPSDeviceDelegate> delegate;
@property(strong,readonly,nonatomic) CBPeripheral *peripheral;
@property(readonly, nonatomic) CBPeripheralState state;
@property(readonly, nonatomic) NSString* name;
// 服务UUID
+(CBUUID*)serviceUUID;
+(CBUUID *)deviceInformationServiceUUID;

// 初始方法
-(instancetype)initWithPeripheral:(CBPeripheral*)peripheral delegate:(id<TPSDeviceDelegate>)delegate;

-(void)requestInitCiphy:(Byte)keyType :(Byte)keyVer :(NSData*)keyValue;
-(void)requestSetDeviceInitInfo:(NSDictionary *)bleDevInitInfo;
-(void)requestGetDeviceVisualInfo:(NSArray *)bleDevVisualInfoIndex;
-(void)requestRfmSearchCard:(Byte)cardType;
-(void)requestRfmSendApduCmd:(NSData *)apduData;
-(void)requestRfmClose;
-(void)requestDeviceAuth;

// === APDU operation methods ===
-(void)sendApduCmd:(NSData *)cmd;
-(void)selectFileByPPSE;
-(void)selectFileByAid:(NSData *) aid;
-(void)selectFileByFid:(NSData *) fid;
-(void)readBinary:(Byte)sfi offSet:(short)offset length:(Byte)len;
-(void)updateBinary:(Byte)sfi offSet:(short)offset data:(NSData *)data;
-(void)readRecord:(Byte)sfi recordNum:(Byte)recNo length:(Byte)len;
-(void)updateRecord:(Byte)sfi recordNum:(Byte)recNo data:(NSData *) data;
-(void)getChallenge:(Byte)len;

-(void)creditForLoad:(NSData *) macdata
     transactionDate:(NSData *)date
     transactionTime:(NSData *)time;

-(void)debitForPurchaseCashWithdraw:(NSData *)macdata
                         terminalSN:(NSData *)terSn
                    transactionDate:(NSData *)date
                    transactionTime:(NSData *)time;

-(void)getBalance:(Byte)edepType;

-(void)initializeForLoadWithKeyIndex:(Byte)keyIndex
                            edepType:(Byte)type
                         transAmount:(NSData*)amount
                         terminalNum:(NSData*)terNum;

-(void)initializeForPurchaseWithKeyIndex:(Byte)keyIndex
                                edepType:(Byte)type
                             transAmount:(NSData*)amount
                             terminalNum:(NSData*)terNum;

-(void)initializeForCappPurchaseWithKeyIndex:(Byte)keyIndex
                                 transAmount:(NSData*)amount
                                 terminalNum:(NSData*)terNum;

-(void)updateCappDataCache:(NSData*)data
                    param1:(Byte)p1
                    param2:(Byte)p2;

-(void)debitForCappPurchase:(NSData*)macdata
                 terminalSN:(NSData*)terSn
            transactionDate:(NSData*)date
            transactionTime:(NSData*)time;

-(void)generateAC:(Byte)p1
             cdol:(NSData*)cdol;

-(void)getData:(short)tagData;
-(void)getProcessingOption:(NSData*)pdol;
-(void)putData:(NSData*)data withTag:(short)tag;
-(void)readCappData:(NSData*)data param:(Byte)p;
-(void)pboc_updateCappDataCache:(NSData*)data param:(Byte)p;
-(void)pboc_externalAuth:(NSData*)data;
-(void)pboc_internalAuth:(NSData*)data;
-(void)appendRecord:(NSData*)data param:(Byte)p;
-(void)getTransProve:(int)atc;

// APDU 加密接口
-(void)requestApduTransferMode:(TransferMode)transformode withPubKey:(NSData *)key;
-(NSData *)deaMac:(NSData *)init macData:(NSData *)msg
              key:(NSData *)key macType:(Byte)mactype;

@end

