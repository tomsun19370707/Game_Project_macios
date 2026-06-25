


#import "NSString+String.h"

@implementation NSString (String)

-(CGSize)sizeWithFont:(UIFont *)font With:(CGFloat)with{
    CGSize size = CGSizeMake(with, MAXFLOAT);//限制文字显识的一个区域
    NSDictionary *att = @{NSFontAttributeName : font};//文字显示的属性
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:nil];//计算出文字显示需要的大小
    return rect.size;
}
-(CGSize)sizeWithFont:(UIFont *)font hiegth:(CGFloat)hiegth{
    CGSize size = CGSizeMake(MAXFLOAT, hiegth);//限制文字显识的一个区域
    NSDictionary *att = @{NSFontAttributeName : font};//文字显示的属性
    
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:nil];
    return rect.size;
    
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
//    if (self.length <= 0) {
//        CGSize sizee = CGSizeMake(0.01f, 0.01f);
//        return sizee;
//    }else{
        NSDictionary *attrs = @{NSFontAttributeName : font};
        return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
//    }
}


+(NSString *)filePathInDocumentsWithFileName:(NSString *)filename{
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [documentsPath stringByAppendingPathComponent:filename];
    return filePath;
}


+ (NSString *)dictionaryToJson:(NSDictionary *)dic
{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonStr{
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    return tempDic;
}




- (CGSize)contentSizeWithWidth:(CGFloat)width font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing{
    if (self == nil || [self length] <= 0) {
        return CGSizeMake(0, 0);
    }
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpacing;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, self.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attributeString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:options context:nil];
    
    //文本的高度减去字体高度小于等于行间距，判断为当前只有1行
    if ((rect.size.height - font.lineHeight) <= style.lineSpacing) {
        if ([self containChinese:self]) {
            rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-style.lineSpacing);
        }
    }
    //return ceil(rect.size.height);
    return rect.size;
}

//判断是否包含中文
- (BOOL)containChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}



@end
