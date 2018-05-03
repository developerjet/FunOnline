//
//  NSString+Estend.h
//  HotChat
//
//  Created by wangjun on 15/8/21.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NSString (Estend)

- (NSString *)HMACWithSecret:(NSString *)secret;
+ (NSString *)getDeviceName;
- (NSString *)fileIdFromUrl;
/// 手机号码格式化 例如:136 5422 5352
+ (NSString *)phoneNumFormat:(NSString *)phoneString;
///去掉手机号格式化之后的空格
- (NSString *)trimAll;
- (NSString *)md5;
- (NSString *)sha1;	
+ (NSString *)phone:(NSString *)phone num:(NSString *)num;
///格式化语音时长  return: mm'ss"
+ (NSString *)stringFormatWithVoiceTime:(NSInteger)time;
///格式化语音时长  return: mm:ss
+ (NSString *)stringFormatWithVoiceTime1:(NSInteger)time;
///截取语音的filedId
+ (NSString *)stringWithAudioUrl:(NSString *)url;
/// 传入的时间搓与当前时间比较 return: hh:mm/昨天hh:mm/MM-dd hh:mm/yyyy-MM-dd hh:mm
+ (NSString *)dateStringWithTime:(NSString *)time;
///格式化距离
+ (NSString *)stringWithDistance:(NSInteger)distance;
+ (NSString *)fileIDPlistPath;
+ (NSString *)nowDate;
+ (NSDictionary *)dictionaryFromQuery:(NSString*)query usingEncoding:(NSStringEncoding)encoding;
//获取当前时间戳格式XXXX-XX-XX
+ (NSString *)getNowTimeStr;
//正则表达式取链接URL里的汉字
+ (NSString *)textSelectFromHerfString:(NSString *)string;
//处理国家码
+ (NSString *)getAreaCodeWithString:(NSString *)areaCode;

//输入金额小数点控制
+ (BOOL)checkNumberStr:(NSString *)string orRange:(NSRange)range orTextFiled:(UITextField *)textField;

/** 中文正则 */
- (BOOL)isValidateChinese;
/** 密码设置正则处理 */
+ (BOOL)isValidPassword:(NSString *)passWord;
/** 匹配所有url处理 */
+ (BOOL)isValidateURLString:(NSString *)urlString;
/** 手机号码正则处理 */
+ (BOOL)isValidateHomePhoneNum:(NSString *)phoneNum;
/** 去除空格符 */
+ (NSString *)deteleTheBlankWithString:(NSString *)str;
/** 身份证号 */
+ (BOOL)validateIdentityCard:(NSString *)identityCard;
/** 时间戳转成时间(年月日) */
+ (NSString *)conversionDate:(NSString *)time;
/** 时间戳处理 */
+ (NSString *)compareCurrentTime:(NSString *)str;
/** 时间戳转成时间 */
+ (NSString *)conversionTimeStamp:(NSString *)timeStamp;
/** 请求完整Url打印处理 */
+ (NSString *)getUrlWithBaseUrl:(NSString *)baseUrl parameters:(NSDictionary *)parameters;

@end
