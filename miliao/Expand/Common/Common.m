//
//  Common.m
//  miliao
//
//  Created by jkkj on 2021/6/29.
//  Copyright © 2021 miliao. All rights reserved.
//

#import "Common.h"
#import "FileManager.h"
@implementation Common

NSString * const Attribute_Lock1 = @"Attribute_Lock";
NSString * const Attribute_Own1  = @"Attribute_Own";
NSString * const Attribute_Say1 = @"Attribute_Say";
NSString * const Attribute_BgImg1 = @"Attribute_BgImg";
NSString * const Attribute_Publish1  = @"Attribute_Publish";
NSString * const Attribute_CoverImg1 = @"Attribute_CoverImg";
NSString * const Attribute_Name1 = @"Attribute_Name";


+ (instancetype)sharedSingleton {
    static Common *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
          // 要使用self来调用
        _sharedSingleton = [[self alloc] init];
    });
    return _sharedSingleton;
}

+ (void)ChannelAttributeType:(ChannelAttributeType)channelAttributeType{
    NSLog(@"字符串枚举值为-->%@",channelAttributeType);
}


+(NSArray *)getCurrentTimeAndWeekDay {
    
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSDate *date = [NSDate date];
    //ios 8.0 之后 不想看见警告用下面这个
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    /*
     NSInteger unitFlags = NSYearCalendarUnit |
     NSMonthCalendarUnit |
     NSDayCalendarUnit |
     NSWeekdayCalendarUnit |
     NSHourCalendarUnit |
     NSMinuteCalendarUnit |
     NSSecondCalendarUnit;
     */
    //ios 8.0 之后 不想看见警告用下面这个
    NSInteger unitFlags = NSCalendarUnitYear |NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitWeekday | NSCalendarUnitHour |NSCalendarUnitMinute |NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger week = [comps weekday];
    NSInteger year=[comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    return @[@(year),@(month),@(day),@(week),[arrWeek objectAtIndex:week-1]];
    
//    return   [NSString stringWithFormat:@"%ld-%ld-%ld  %@",(long)year,(long)month,(long)day,[arrWeek objectAtIndex:week]];
}




//字符串为空检查
+ (BOOL)isEmptyString:(NSString *)sourceStr {
    if ((NSNull *)sourceStr == [NSNull null]) {
        return YES;
    }
    if (sourceStr == NULL) {
        return YES;
    }
    if (sourceStr == nil) {
        return YES;
    }
    if ([sourceStr isEqualToString:@""]) {
        return YES;
    }
    if (sourceStr.length == 0) {
        return YES;
    }
    if ([sourceStr isEqualToString:@"null"]) {
        return YES;
    }
    if ([sourceStr isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([sourceStr isEqualToString:@"<null>"]) {
        return YES;
    }
    return NO;
}
//判断空值，如果为空，就返回字符串 @""
+ (id)isNull:(id)object_1
{
    NSString *str = [NSString stringWithFormat:@"%@",object_1];
    if ([Common isEmptyString:str]) {
        return @"";
    }
    else
    {
        return str;
    }
}

//判断是否为空,为空,就返回字符串@"0"
+ (id)isNullNumber:(id)object_1
{
    NSString *str = [NSString stringWithFormat:@"%@",object_1];
    if ([Common isEmptyString:str]) {
        return @"0";
    }
    else
    {
        return object_1;
    }
}

//判断数组是否为空
+ (BOOL)isBlankArr:(NSArray*)arr {
    if(!arr) {
        return YES;
    }
    if([arr isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if(!arr.count) {
        return YES;
    }
    if(arr ==nil) {
        return YES;
    }
    if(arr ==NULL) {
        return YES;
    }
    if(![arr isKindOfClass:[NSArray class]]) {
        return YES;
    }
    return NO;
}

//判断字典是否为空
+ (BOOL)isBlankDictionary:(NSDictionary*)dic {
    if(!dic) {
        return YES;
    }
    if([dic isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if(!dic.count) {
        return YES;
    }
    if(dic ==nil) {
        return YES;
    }
    if(dic ==NULL) {
        return YES;
    }
    if(![dic isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    return NO;

}



+ (NSString *)deleteUnicodeStr:(NSString *)unicodeString{
    
    return [unicodeString stringByReplacingOccurrencesOfString:@"\\p{Cf}" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, unicodeString.length)];
}



///View转image
+(UIImage*)createImageFromView:(UIView*)view
{
    CGSize s = view.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

///获取当前显示的视图
+ (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    // 获取默认的window
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    // app默认windowLevel是UIWindowLevelNormal，如果不是，找到它。
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    // 获取window的rootViewController
    result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result visibleViewController];
    }
    return result;
}

///切角
/**
 type:
 0-上左上右
 1-下左下右
 2-全部
 3-上左下左
 */
+ (void)setCornerFor:(NSInteger )type andView:(UIView *)aView andConer:(CGFloat)corner{
    UIBezierPath *maskPath = nil;
   
    if (type == 0) {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:aView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(corner, corner)];
    }else if(type==1){
        maskPath = [UIBezierPath bezierPathWithRoundedRect:aView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(corner, corner)];
    }else if(type==2){
        maskPath = [UIBezierPath bezierPathWithRoundedRect:aView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(corner, corner)];
    }else if(type==3){
        maskPath = [UIBezierPath bezierPathWithRoundedRect:aView.bounds byRoundingCorners:UIRectCornerTopLeft |UIRectCornerBottomLeft cornerRadii:CGSizeMake(corner, corner)];
    }
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = aView.bounds;
    maskLayer.path = maskPath.CGPath;
    aView.layer.mask = maskLayer;
}

#pragma mark ------- 文字渐变色
/*
 view 是要设置渐变字体的控件   bgVIew是view的父视图  colors是渐变的组成颜色  startPoint是渐变开始点 endPoint结束点
 */
+(void)TextGradientview:(UIView *)view bgVIew:(UIView *)bgVIew gradientColors:(NSArray *)colors gradientStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    
    CAGradientLayer* gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = view.frame;
    gradientLayer1.colors = colors;
    gradientLayer1.locations = @[@(0), @(1)];
    gradientLayer1.startPoint =startPoint;
    gradientLayer1.endPoint = endPoint;
    [bgVIew.layer addSublayer:gradientLayer1];
    gradientLayer1.mask = view.layer;
    view.frame = gradientLayer1.bounds;
}

/*
 control 是要设置渐变字体的控件   bgVIew是view的父视图  colors是渐变的组成颜色  startPoint是渐变开始点 endPoint结束点
 */
+(void)TextGradientControl:(UIControl *)control bgVIew:(UIView *)bgVIew gradientColors:(NSArray *)colors gradientStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{

    CAGradientLayer* gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = control.frame;
    gradientLayer1.colors = colors;
    gradientLayer1.locations = @[@(0), @(0.5), @(1)];
    gradientLayer1.startPoint =startPoint;
    gradientLayer1.endPoint = endPoint;
    [bgVIew.layer addSublayer:gradientLayer1];
    gradientLayer1.mask = control.layer;
    control.frame = gradientLayer1.bounds;
}

///获取window
+ (UIWindow *)AppWindow{
    UIWindow * window = nil;
    if (@available(iOS 13.0, *)) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }else{
        window = [UIApplication sharedApplication].keyWindow;
    }
    return window;
}

//获取设备标识
+ (NSString *)getUUID{
    NSString  *openUUID = [[NSUserDefaults standardUserDefaults] objectForKey:kOpenSessionID];
    if (openUUID == nil) {
        CFUUIDRef puuid = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef uuidString = CFUUIDCreateString(kCFAllocatorDefault,puuid);
        NSString *udidStr = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
        CFRelease(puuid);
        CFRelease(uuidString);
        openUUID =  udidStr;
        UserDefaultsSave(openUUID, kOpenSessionID);
    }
    return openUUID;
}

//用于存储iap内购返回的购买凭证
+ (NSString *)iapReceiptPath {
    
    NSString *path = [[FileManager libPrefPath] stringByAppendingFormat:@"/EACEF35FE363A75A"];
    [self hasLive:path];
    return path;
}
+ (BOOL)hasLive:(NSString *)path
{
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:path] )
    {
        return [[NSFileManager defaultManager] createDirectoryAtPath:path
                                         withIntermediateDirectories:YES
                                                          attributes:nil
                                                               error:NULL];
    }
    
    return YES;
}

//获取字符串的宽度
+ (CGFloat)getStringWidthWithText:(NSString *)text font:(UIFont *)font viewHeight:(CGFloat)height {
// 设置文字属性 要和label的一致
NSDictionary *attrs = @{NSFontAttributeName :font};
CGSize maxSize = CGSizeMake(MAXFLOAT, height);

NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;

// 计算文字占据的宽高
CGSize size = [text boundingRectWithSize:maxSize options:options attributes:attrs context:nil].size;
    return size.width;
}
/// 添加四边阴影效果
+ (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    // 阴影颜色
    theView.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = CGSizeMake(0,0);
    // 阴影透明度，默认0
    theView.layer.shadowOpacity = 0.5;
    // 阴影半径，默认3
    theView.layer.shadowRadius = 5;
}


//设置语言
+ (NSString *)getStringWithKey:(NSString *)key{
//    return NSLocalizedStringFromTable(key, @"Localizable",nil);
    
    return key;
}

///左右渐变色
/// 渐变色
/// @param view 当前view
/// @param colorArray @[(__bridge id)[UIColor colorWithHexString:@"ff0000"].CGColor,(__bridge id)[UIColor colorWithHexString:@"ff0b00"].CGColor]
/// @param locations 分割比例 @[@0.2,@0.4,@1.0,@1.0]
+(void)setLeftCAGradientLayerForView:(UIView *)view colorArray:(NSArray *)colorArray
    locations:(NSArray *)locations{
    CAGradientLayer* gradinentlayer=[CAGradientLayer layer];
    gradinentlayer.colors = colorArray;
    gradinentlayer.locations = locations;
    gradinentlayer.startPoint=CGPointMake(0, 0);
    gradinentlayer.endPoint=CGPointMake(1.0, 0);
    gradinentlayer.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    [view.layer addSublayer:gradinentlayer];
}



//json格式字符串转字典：

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {

    if (jsonString == nil) {

        return nil;

    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];

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

//字典转json格式字符串：

+ (NSString*)dictionaryToJson:(NSDictionary *)dic{

    NSError *parseError = nil;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];

    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

}



#pragma mark 时间戳转时间
//+ (NSString *)time:(NSString *)time{
+ (NSString *)time:(NSString *)time andShowHoursMinutes:(BOOL)show{
    
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式
    if (show) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }else{
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    
    if ([time isKindOfClass:[NSNull class]]) {
        return [NSString stringWithFormat:@"无"];
    }else{
        if (time.length==10) {
            NSDate *stampDate2 = [NSDate dateWithTimeIntervalSince1970:[time integerValue]];
            return  [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:stampDate2]];
        }else{
            NSDate *stampDate2 = [NSDate dateWithTimeIntervalSince1970:[time integerValue]/1000];
            return  [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:stampDate2]];
        }
        
    }
    
    
}

+(NSString *)getTime{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[date timeIntervalSince1970]; // *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a]; //转为字符型
    return timeString;
}



//获取视频封面，本地视频，网络视频都可以用

+ (UIImage*)getThumbnailImage:(NSString*)videoURL{
    
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:videoURL] options:nil];

    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc]initWithAsset:asset];

    gen.appliesPreferredTrackTransform = YES;

    CMTime time = CMTimeMakeWithSeconds(2.0, 600);

    NSError *error = nil;

    CMTime actualTime;

    CGImageRef image=[gen copyCGImageAtTime:time actualTime:&actualTime error:&error];

    UIImage *thumbImg = [[UIImage alloc] initWithCGImage:image];

    return thumbImg;
  
}










@end
