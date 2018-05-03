//
//  NSString+Estend.m
//  HotChat
//
//  Created by wangjun on 15/8/21.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "NSString+Estend.h"
#import <sys/utsname.h>
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

#include <sys/types.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>


@implementation NSString (Estend)

- (NSString *)HMACWithSecret:(NSString *) secret
{
    CCHmacContext    ctx;
    const char       *key = [secret UTF8String];
    const char       *str = [self UTF8String];
    unsigned char    mac[CC_MD5_DIGEST_LENGTH];
    char             hexmac[2 * CC_MD5_DIGEST_LENGTH + 1];
    char             *p;
    
    CCHmacInit( &ctx, kCCHmacAlgMD5, key, strlen( key ));
    CCHmacUpdate( &ctx, str, strlen(str) );
    CCHmacFinal( &ctx, mac );
    
    p = hexmac;
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++ ) {
        snprintf( p, 3, "%02x", mac[ i ] );
        p += 2;
    }
    
    return [NSString stringWithUTF8String:hexmac];
}

+ (NSString *)getDeviceName
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];
    NSDictionary *deviceNamesByCode = @{
                                        @"i386"      :@"Simulator",
                                        @"iPod1,1"   :@"iPodTouch",      // (Original)
                                        @"iPod2,1"   :@"iPodTouch",      // (Second Generation)
                                        @"iPod3,1"   :@"iPodTouch",      // (Third Generation)
                                        @"iPod4,1"   :@"iPodTouch",      // (Fourth Generation)
                                        @"iPhone1,1" :@"iPhone",          // (Original)
                                        @"iPhone1,2" :@"iPhone",          // (3G)
                                        @"iPhone2,1" :@"iPhone",          // (3GS)
                                        @"iPad1,1"   :@"iPad",            // (Original)
                                        @"iPad2,1"   :@"iPad2",          //
                                        @"iPad3,1"   :@"iPad",            // (3rd Generation)
                                        @"iPhone3,1" :@"iPhone4",        // (GSM)
                                        @"iPhone3,3" :@"iPhone4",        // (CDMA/Verizon/Sprint)
                                        @"iPhone4,1" :@"iPhone4S",       //
                                        @"iPhone5,1" :@"iPhone5",        // (model A1428, AT&T/Canada)
                                        @"iPhone5,2" :@"iPhone5",        // (model A1429, everything else)
                                        @"iPad3,4"   :@"iPad",            // (4th Generation)
                                        @"iPad2,5"   :@"iPadMini",       // (Original)
                                        @"iPhone5,3" :@"iPhone5c",       // (model A1456, A1532 | GSM)
                                        @"iPhone5,4" :@"iPhone5c",       // (model A1507, A1516, A1526 (China), A1529 | Global)
                                        @"iPhone6,1" :@"iPhone5s",       // (model A1433, A1533 | GSM)
                                        @"iPhone6,2" :@"iPhone5s",       // (model A1457, A1518, A1528 (China), A1530 | Global)
                                        @"iPhone7,1" :@"iPhone6Plus",   //
                                        @"iPhone7,2" :@"iPhone6",        //
                                        @"iPad4,1"   :@"iPadAir",        // 5th Generation iPad (iPad Air) - Wifi
                                        @"iPad4,2"   :@"iPadAir",        // 5th Generation iPad (iPad Air) - Cellular
                                        @"iPad4,4"   :@"iPadMini",       // (2nd Generation iPad Mini - Wifi)
                                        @"iPad4,5"   :@"iPadMini"        // (2nd Generation iPad Mini - Cellular)
                                        };
    
    NSString *deviceName = [deviceNamesByCode objectForKey:code];
    
    if (!deviceName) {
        if ([code rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        }
        else if([code rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([code rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
        else
        {
            deviceName = @"unknow";
        }
    }
    
    return deviceName;
}




- (NSString *)fileIdFromUrl {
    NSRange fileIdRange=[self rangeOfString:@"fileid="];
    if (fileIdRange.location==NSNotFound) {
        fileIdRange = [self rangeOfString:@"/"];
        if (fileIdRange.location == NSNotFound) {
            return self;
        }else{
            return [[self componentsSeparatedByString:@"/"] lastObject];
        }
    }
    NSString *fileId=[self substringFromIndex:fileIdRange.location+fileIdRange.length];
    fileIdRange=[fileId rangeOfString:@"&"];
    if (fileIdRange.location==NSNotFound) {
        return fileId;
    }
    return [fileId substringToIndex:fileIdRange.location];
}

+ (NSString *)phoneNumFormat:(NSString *)phoneString {
    BOOL flag;//是否是以“1”开头
    {
        NSString *firstStr = [phoneString substringToIndex:1];
        if ([firstStr isEqualToString:@"1"] && [phoneString rangeOfString:@"@"].location == NSNotFound) {
            flag = YES;
        }else{
            flag = NO;
        }
    }
    
    if (flag) {
        phoneString = [phoneString stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (phoneString.length > 3) {
            NSString *a = [[phoneString substringToIndex:3] stringByAppendingString:@" "];
            NSString *b = [phoneString substringFromIndex:3];
            for (NSUInteger i = 0; i + 4 < b.length; i += 4) {
                NSString *c = [[b substringWithRange:NSMakeRange(i, 4)] stringByAppendingString:@" "];
                a = [a stringByAppendingString:c];
            }
            NSUInteger spareLen = (b.length%4 == 0?4:b.length%4);
            NSString *spare = [b substringFromIndex:b.length - spareLen];
            a = [a stringByAppendingString:spare];
            return a;
        }
    }
    
    return phoneString;

}

- (NSString *)trimAll {
    NSMutableString *result=[[NSMutableString alloc] init];
    for (int i=0;i<self.length;i++) {
        NSString* chr = [self substringWithRange:NSMakeRange(i, 1)];
        if (![chr isEqualToString:@" "]) {
            [result appendString:chr];
        }
    }
    return result;
}

- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

- (NSString *)sha1
{
    const char *ptr = [self UTF8String];
    
    int i =0;
    size_t len = strlen(ptr);
    Byte byteArray[len];
    while (i!=len)
    {
        unsigned eachChar = *(ptr + i);
        unsigned low8Bits = eachChar & 0xFF;
        
        byteArray[i] = low8Bits;
        i++;
    }
    
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(byteArray, len, digest);
    
    NSMutableString *hex = [NSMutableString string];
    for (int i=0; i<20; i++)
        [hex appendFormat:@"%02x", digest[i]];
    
    NSString *immutableHex = [NSString stringWithString:hex];
    
    return immutableHex;
}

+ (NSString *)phone:(NSString *)phone num:(NSString *)num {
    if ([num rangeOfString:@"+"].location != NSNotFound) {
        num = [num substringFromIndex:1];
    }
    phone = [num stringByAppendingString:phone];
    return phone;
}

+ (NSString *)stringFormatWithVoiceTime:(NSInteger)time
{
//    NSInteger timeM = time/60;
//    NSInteger timeS = time%60;
//    
//    NSString *str = nil;
//    if (timeM > 0) {
//        if (timeS > 0) {
//            str = [NSString stringWithFormat:@"%zd\'%2zd\"",timeM,timeS];
//        }else{
//            str = [NSString stringWithFormat:@"%zd\'",timeM];
//        }
//    }else{
//        str = [NSString stringWithFormat:@"%2zd\"",timeS];
//    }
    
    NSDateFormatter *dfm = [[NSDateFormatter alloc] init];
    [dfm setDateFormat:@"mm:ss"];
    
    NSString *str = [dfm stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
    
    NSArray *arr = [str componentsSeparatedByString:@":"];
    str = [NSString stringWithFormat:@"%@'%@\"",arr[0],arr[1]];
    
    return str;
}

+ (NSString *)stringFormatWithVoiceTime1:(NSInteger)time
{
    NSDateFormatter *dfm = [[NSDateFormatter alloc] init];
    [dfm setDateFormat:@"mm:ss"];
    
    return [dfm stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
}

+ (NSString *)stringWithAudioUrl:(NSString *)url
{
    NSString *filedId = [NSString stringWithFormat:@"%@",[[url componentsSeparatedByString:@"fileid/"] lastObject]];
    return filedId;
}

+ (NSString *)dateStringWithTime:(NSString *)time;
{
    NSDate *fromDate = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                          fromDate:fromDate];
    NSDateComponents *compsNow = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                             fromDate:[NSDate date]];
    
    NSDateFormatter* dfm = [[NSDateFormatter alloc] init];
    [dfm setAMSymbol:NSLocalizedString(@"AM",nil)];
    [dfm setPMSymbol:NSLocalizedString(@"PM",nil)];
    [dfm setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh"]];
    [dfm setDateFormat:@"yyyy:MM:dd:hh:mm:a"];
    NSString* dateStrr = [dfm stringFromDate:fromDate];
    NSArray *dateArr = [dateStrr componentsSeparatedByString:@":"];
    
    NSString *yyyy = [dateArr objectAtIndex:0];
    NSString *MM = [dateArr objectAtIndex:1];
    NSString *dd = [dateArr objectAtIndex:2];
    NSString *hh = [dateArr objectAtIndex:3];
    NSString *mm = [dateArr objectAtIndex:4];
    NSString *ampm = [dateArr objectAtIndex:5];
    
    if (compsNow.year - comps.year > 0) {
        dateStrr = [NSString stringWithFormat:@"%@,%@ %@,%@:%@ %@",yyyy,MM,dd,hh,mm,ampm];
    }else if (compsNow.month - comps.month > 0){
        dateStrr = [NSString stringWithFormat:@"%@ %@,%@:%@ %@",MM,dd,hh,mm,ampm];
    }else if (compsNow.day - comps.day > 1){
        dateStrr = [NSString stringWithFormat:@"%@ %@,%@:%@ %@",MM,dd,hh,mm,ampm];
    }else if (compsNow.day - comps.day <= 1){
        dateStrr = [NSString stringWithFormat:@"%@:%@ %@",hh,mm,ampm];
        if (compsNow.day - comps.day == 1) {
            dateStrr = [@"昨天 " stringByAppendingString:dateStrr];
        }
    }else{
        dateStrr = [NSString stringWithFormat:@"%@ %@,%@:%@ %@",MM,dd,hh,mm,ampm];
    }
    
    return dateStrr;
}

+ (NSString *)stringWithDistance:(NSInteger)distance
{
    NSString *distanceStr = nil;
    if (distance >= 0) {
        if (distance >= 1000) {
            distanceStr = [NSString stringWithFormat:@"%.2fkm",distance/1000.f];
        }else{
            distanceStr = [NSString stringWithFormat:@"%.2fm",distance/1.f];
        }
    }
    return distanceStr;
}

+ (NSString *)fileIDPlistPath {
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [doc stringByAppendingPathComponent:@"fileID.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
        NSDictionary *dic = [[NSDictionary alloc]init];
        [dic writeToFile:path atomically:YES];
    }
    return path;
}

+ (NSString *)nowDate
{
    NSString *date = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    return date;
}

+ (NSDictionary *)dictionaryFromQuery:(NSString*)query usingEncoding:(NSStringEncoding)encoding {
    NSCharacterSet *delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary *pairs = [NSMutableDictionary dictionary];
    NSScanner *scanner = [[NSScanner alloc] initWithString:query];
    while (![scanner isAtEnd]) {
        NSString *pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray *kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSString* value = [[kvPair objectAtIndex:1]
                               stringByReplacingPercentEscapesUsingEncoding:encoding];
            [pairs setObject:value forKey:key];
        }
    }
    return [NSDictionary dictionaryWithDictionary:pairs];
}

+ (NSString *)getNowTimeStr{
    NSDate *datea=[NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[datea timeIntervalSince1970];
    NSString *timeStampString=[NSString stringWithFormat:@"%.0f",time];
    NSTimeInterval _interval=[timeStampString doubleValue] ;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd"];
    NSString * timeStr = [objDateformat stringFromDate:date];
    return timeStr;
}

+ (NSString *)textSelectFromHerfString:(NSString *)string {
    NSString *regexString = @"[\u4E00-\u9FA5]+";
    NSError *error;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                             options:NSRegularExpressionCaseInsensitive
                                                                               error:&error];
    // 对str字符串进行匹配
    NSArray *matches = [regular matchesInString:string
                                        options:0
                                          range:NSMakeRange(0, string.length)];
    // 遍历匹配后的每一条记录
    NSString *textString = @"";
    for (NSTextCheckingResult *match in matches) {
        NSRange range = [match range];
        NSString *mStr = [string substringWithRange:range];
        
        textString = [textString stringByAppendingString:mStr];
    }
    return textString;
}



//处理国家码
+ (NSString *)getAreaCodeWithString:(NSString *)areaCode
{
    if ([areaCode rangeOfString:@"+"].location != NSNotFound) {
        NSString *str = [[areaCode componentsSeparatedByString:@"+"] lastObject];
        return str;
    }else {
        return areaCode;
    }
}

//输入金额小数点控制
+ (BOOL)checkNumberStr:(NSString *)string orRange:(NSRange)range orTextFiled:(UITextField *)textField {
    
    NSScanner      *scanner    = [NSScanner scannerWithString:string];
    NSCharacterSet *numbers;
    NSRange         pointRange = [textField.text rangeOfString:@"."];
    
    if ( (pointRange.length > 0) && (pointRange.location < range.location  || pointRange.location > range.location + range.length) )
    {
        numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    }
    else
    {
        numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    }
    
    if ( [textField.text isEqualToString:@""] && [string isEqualToString:@"."] )
    {
        return NO;
    }
    
    short remain = 2; //默认保留2位小数
    
    NSString *tempStr = [textField.text stringByAppendingString:string];
    NSUInteger strlen = [tempStr length];
    if(pointRange.length > 0 && pointRange.location > 0){ //判断输入框内是否含有“.”。
        if([string isEqualToString:@"."]){ //当输入框内已经含有“.”时，如果再输入“.”则被视为无效。
            return NO;
        }
        if(strlen > 0 && (strlen - pointRange.location) > remain+1){ //当输入框内已经含有“.”，当字符串长度减去小数点前面的字符串长度大于需要要保留的小数点位数，则视当次输入无效。
            //[XDHub showLongText:@"输入金额小数点后最多2位" hideDelay:1.0];
            return NO;
        }
    }
    
    NSRange zeroRange = [textField.text rangeOfString:@"0"];
    if(zeroRange.length == 1 && zeroRange.location == 0){ //判断输入框第一个字符是否为“0”
        if(![string isEqualToString:@"0"] && ![string isEqualToString:@"."] && [textField.text length] == 1){ //当输入框只有一个字符并且字符为“0”时，再输入不为“0”或者“.”的字符时，则将此输入替换输入框的这唯一字符。
            textField.text = string;
            return NO;
        }else{
            if(pointRange.length == 0 && pointRange.location > 0){ //当输入框第一个字符为“0”时，并且没有“.”字符时，如果当此输入的字符为“0”，则视当此输入无效。
                if([string isEqualToString:@"0"]){
                    return NO;
                }
            }
        }
    }
    
    NSString *buffer;
    //NSLog(@"****%@",buffer);
    if ( ![scanner scanCharactersFromSet:numbers intoString:&buffer] && ([string length] != 0) )
    {
        
        return NO;
    }

    return YES;
}

//密码设置正则
+ (BOOL)isValidPassword:(NSString *)passWord; {
    
    //以字母开头，只能包含“字母”，“数字”，“下划线”，长度6~16
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,16}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:passWord];
    
    return isMatch;
}



//手机号码正则
+ (BOOL)isValidateHomePhoneNum:(NSString *)phoneNum {
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:phoneNum];
}

//中文正则
- (BOOL)isValidateChinese{
    
    NSString *MOBILE = @"[\u4e00-\u9fa5]";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];

    NSRange range;
    for(int i=0; i<self.length; i+=range.length){
        range = [self rangeOfComposedCharacterSequenceAtIndex:i];
        NSString *s = [self substringWithRange:range];
        
        if (![regextestmobile evaluateWithObject:s]) {
            
            return NO;
        }
    }
    
    return YES;
}

// 去掉空格符
+ (NSString *)deteleTheBlankWithString:(NSString *)str
{
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *newStr = [[NSString alloc]initWithString:[str stringByTrimmingCharactersInSet:whiteSpace]];
    return newStr;
}


+ (BOOL)isValidateURLString:(NSString *)urlString {
    NSString *pattern = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:urlString];
    return isMatch;
}

//身份证号正则
+ (BOOL)validateIdentityCard: (NSString *)identityCard
{
// 粗略验证身份证号
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:identityCard];
    return isMatch;
}

//时间戳处理
+ (NSString *)compareCurrentTime:(NSString *)str {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *timeDate = [formatter dateFromString:str];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:timeDate];
    long temp = 0;
    NSString *result;
    if (timeInterval/60 < 1) {
        result = @"刚刚";
    }else if ((temp = timeInterval/60)<60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }else if ((temp = temp/60)<24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }else if ((temp = temp/24)<30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }else if ((temp = temp/30)<12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return result;
}


+ (NSString *)conversionTimeStamp:(NSString *)timeStamp {
    // 把时间戳转换为wNSString型的时间
    NSDateFormatter*formatter = [[NSDateFormatter alloc] init];
    NSTimeInterval interval = [timeStamp doubleValue];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:interval];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:confromTimesp];
    
    return dateString;
}

+ (NSString *)conversionDate:(NSString *)time {
    // 把时间戳转换为wNSString型的时间
    NSDateFormatter*formatter = [[NSDateFormatter alloc] init];
    NSTimeInterval interval = [time doubleValue];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:interval];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [formatter stringFromDate:confromTimesp];
    
    return dateString;
}

/** 传入请求地址和请求参数(字典) 返回请求的URL */
+ (NSString *)getUrlWithBaseUrl:(NSString *)baseUrl parameters:(NSDictionary *)parameters {
    
    //创建一个数组用来存储每组keyValue
    NSMutableArray *allParametersArr = [NSMutableArray array];
    [allParametersArr removeAllObjects];
    
    //获得字典所有key
    NSArray *keysArray = [parameters allKeys];
    for (int i = 0; i < keysArray.count; i++)
    {
        //根据每个key获得对应value -> 拼接放进可变数组
        NSString *key   = keysArray[i];
        NSString *value = parameters[key];
        NSString *keyValueStr = [NSString stringWithFormat:@"%@=%@", key, value];
        [allParametersArr addObject:keyValueStr];
    }
    
    //数组转为字符串以&分割每个元素
    NSString *paraStr = [allParametersArr componentsJoinedByString:@"&"];
    NSString *UrlStr  = [NSString stringWithFormat:@"%@?%@", baseUrl, paraStr];
    //NSLog(@"%@", UrlStr);
    
    return UrlStr;
}


@end
