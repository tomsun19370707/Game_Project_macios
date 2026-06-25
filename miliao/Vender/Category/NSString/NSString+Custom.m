//
//  NSString+Custom.m
//  FaceShow
//
//  Created by skyz on 2018/1/9.
//  Copyright © 2018年 GChao. All rights reserved.
//

#import "NSString+Custom.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (Custom)

#pragma mark --获取文字的固定宽高
-(CGSize)getSizeWithStrFloat:(float)strFont{
   CGSize jobSize =[self sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:strFont]}];
   CGSize jobSize1 = CGSizeMake(ceil(jobSize.width), ceil(jobSize.height));
   return jobSize1;
}

- (CGFloat)getHeightWithWidth:(CGFloat)width font:(CGFloat)font {
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size.height+16;
}
#pragma mark -- 添加下划线
- (NSMutableAttributedString *)addBottomlineWithcolor:(UIColor *)color{
   NSMutableAttributedString * titleStr = [[NSMutableAttributedString alloc ]initWithString:self];
   [titleStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt: NSUnderlinePatternDash] range:NSMakeRange(0, self.length)];
   [titleStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, self.length)];
   //[titleStr addAttribute:NSBaselineOffsetAttributeName value:@(5) range:NSMakeRange(0, self.length)];
   return titleStr;
}
#pragma mark -- 字符串是否为空
- (BOOL)isEmpty{
   return self == nil || self.length == 0 || [self isKindOfClass:[NSNull class]];

}
#pragma mark -- 字符串转json
- (NSDictionary *)dictionaryWithJsonString{
   if (self.length == 0) {
      return nil;

   }
   NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];

   NSError *err;

   NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData

                                                       options:NSJSONReadingMutableContainers

                                                         error:&err];
   if(err) {

      NSLog(@"json解析失败：%@",err);

      return nil;

   }
   return dic;

}
#pragma mark -- 字符串转任意类型
- (id)toJson{
   if (self.length == 0) {
      return nil;

   }
   NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];

   NSError *err;

   id responObject = [NSJSONSerialization JSONObjectWithData:jsonData

                                                       options:NSJSONReadingMutableContainers

                                                         error:&err];
   if(err) {

      NSLog(@"json解析失败：%@",err);

      return nil;

   }
   return responObject;

}
#pragma mark -- 判断邮箱格式是否正确
- (BOOL)isValidateEmail{
   NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
   NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
   return [emailTest evaluateWithObject:self];
}
#pragma mark -- 判断是电话
- (BOOL)isPhoneNumber{
   NSString *regex =@"^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}$";
   NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];

   return [pred evaluateWithObject:self];


}
#pragma mark -- 判断是数字加字母
- (BOOL) isLetterAndNumber

{

   NSString *regex =@"[a-zA-Z0-9]*";

   NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];

   return [pred evaluateWithObject:self];

}
#pragma mark --判断身份证是否合法
- (BOOL)judgeIdentityStringValid {
    NSString *identityString = self;
    //首先第一步判断传入身份证号码长度是否为18位，如果不是直接返回NO
    if (identityString.length != 18) return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:identityString]) return NO;
    //** 开始进行校验 *////将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;for(int i = 0;i < 17;i++) {NSInteger subStrIndex = [[identityString substringWithRange:NSMakeRange(i, 1)] integerValue];NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];idCardWiSum+= subStrIndex * idCardWiIndex;}
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [identityString substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
        return NO;
        
    }
        
    }else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
            
        }
        
    }
    return YES;
    
}
#pragma mark -- 时间戳转时间
- (NSString *)toTimeStr:(NSString *)typeStr{
   // 格式化时间
   NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
   formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
   [formatter setDateStyle:NSDateFormatterMediumStyle];
   [formatter setTimeStyle:NSDateFormatterShortStyle];
   [formatter setDateFormat:typeStr];
   // 毫秒值转化为秒
   NSDate* date = [NSDate dateWithTimeIntervalSince1970:[self doubleValue]/ 1000.0];
   NSString* dateString = [formatter stringFromDate:date];
   return dateString;
}
#pragma mark -- 时间戳转为日期
- (NSDate *)toDateStr:(NSString *)typeStr{
   NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

   [formatter setDateStyle:NSDateFormatterMediumStyle];

   [formatter setTimeStyle:NSDateFormatterShortStyle];

   [formatter setDateFormat:typeStr]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

//   NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
//
//   [formatter setTimeZone:timeZone];

   NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[self doubleValue] /1000];
   
   return confromTimesp;

}
#pragma mark --得到两个字符之间的字符串
- (NSString *)betweenToString:(NSString *)message beginStr:(NSString *)beginStr endStr:(NSString *)endStr{
//    NSString *string = message;
//    NSRange startRange = [string rangeOfString:beginStr];
//    NSRange endRange = [string rangeOfString:endStr];
//    // 异常处理
//    if (startRange.location != NSNotFound && endRange.location != NSNotFound && endRange.location > startRange.location + startRange.length) {
//        NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
//        NSString *result = [string substringWithRange:range];
//        return result;
//    } else {
//        return @"";
//    }
    if ([message containsString:beginStr] ==YES & [message containsString:endStr]==YES) {
        NSString *string = message;
        NSRange startRange = [string rangeOfString:beginStr];
        NSRange endRange = [string rangeOfString:endStr];
        NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
        NSString *result = [string substringWithRange:range];
        return result;
    }else{
        return @"";
    }
    
}

#pragma mark -- @好友功能
- (NSString *)transformFriendStrWithSuccessBlock:(void(^)(NSArray *userNameArr))successBlock{
   NSMutableArray * friendNameArr = [NSMutableArray array];
   NSArray * friendArr = [self componentsSeparatedByString:@","];
   for (NSString * tmpStr in friendArr) {
      NSArray * userArr = [tmpStr componentsSeparatedByString:@"#"];
      if (successBlock) {
         successBlock(userArr);
      }
      [friendNameArr addObject:[NSString stringWithFormat:@"%@",userArr[0]]];
   }
   NSString * friendNameStr = [friendNameArr componentsJoinedByString:@" "];
   return friendNameStr;
}


#pragma mark -- 时间转MD5加密
- (NSString *)getMD5AddValidation{
   NSString * timeStr = [NSString stringWithFormat:@"%@%@",@"gaoshanxi@8859-1!#$",self];
   //转MD5 32位
   //要进行UTF8的转码
    const char* input = [timeStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    return digest;
    
}
- (NSString *)getMD5{
    NSString * timeStr =self;
    //转MD5 32位
    //要进行UTF8的转码
    const char* input = [timeStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    return digest;
    
}
@end
