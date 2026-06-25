//
//  NSString+Mobile.m
//  RecruitmentProduct
//
//  Created by zy on 16/4/16.
//  Copyright © 2016年 RunShengInformation. All rights reserved.
//

#import "NSString+Mobile.h"

@implementation NSString (Mobile)


+ (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

+ (NSString *)valiMobile:(NSString *)mobile{
    if (mobile.length < 11)
    {
        return @"手机号长度只能是11位";
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return nil;
        }else{
            return @"请输入正确的手机号码";
        }
    }
    return nil;
}

#pragma mark -- 编码与反编码
+(NSString *)argumentParse:(NSString *)Value positive:(BOOL)isPositive type:(NSString *)typeStr{
    
    NSString *dicKey;
    NSString *dicValue;
    if (isPositive) {
        dicKey = @"dicKey";
        dicValue = @"dicValue";
    }else {
        dicKey = @"dicValue";
        dicValue = @"dicKey";
    }
    
    NSString *path  = [[NSBundle mainBundle]pathForResource:typeStr ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSArray * array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    for (NSDictionary *dic in array) {
        if ([Value isEqualToString:[NSString stringWithFormat:@"%@",dic[dicKey]]]) {
            return dic[dicValue];
        }
    }
    return nil;
}

+ (BOOL)isValidateEmail:(NSString *)Email
{
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:Email];
}


@end
