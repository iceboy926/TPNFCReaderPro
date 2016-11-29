//
//  ZqsCommonUtil.h
//  ISO8583
//
//  Created by apple on 13-9-16.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZqsCommonUtil : NSObject

/**
 *	@brief	byte数组转化为HEX形式NSString 方便查看和输出
 *
 *	@param 	bytes 	byte数组
 *	@param 	bytesLen 	byte数组长度
 *
 *	@return	字符串
 */
+(NSString *)Byte2HexNSString:(Byte *)bytes withLen:(int)bytesLen;
/**
 *	@brief	HEX形式NSString 转化为byte数组
 *
 *	@param 	strHexString 	Hex字符串
 *
 *	@return	Byte *
 */
+(Byte *)HexNSString2Byte:(NSString *)strHexString;
/**
 *	@brief	NSData数组转化为HEX形式NSString 方便查看和输出
 *
 *	@param 	 data	NSData
 *
 *	@return	字符串
 */
+(NSString *)NSData2HexNSString:(NSData *)data;

/**
 *	@brief	将HEX形式NSString对象转换为NSData 方便转化为byte数组
 *
 *	@param 	strHexStr  Hex形式对象
 *
 *	@return	NSData对象
 */
+(NSData *)HexNSString2NSData:(NSString *)strHexStr;

@end
