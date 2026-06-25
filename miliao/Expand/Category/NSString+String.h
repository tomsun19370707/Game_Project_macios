

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (String)

-(CGSize)sizeWithFont:(UIFont *)font With:(CGFloat)with;

-(CGSize)sizeWithFont:(UIFont *)font hiegth:(CGFloat)hiegth;

/**
 *  返回字符串所占用的尺寸
 *
 *  @param font    字体
 *  @param maxSize 最大尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
/**
 *  根据文件名，返回文件在Documents下的路径
 *
 *  @param filename 文件名字
 *
 *  @return 文件路径
 */
+(NSString *)filePathInDocumentsWithFileName:(NSString *)filename;


+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonStr;


- (CGSize)contentSizeWithWidth:(CGFloat)width font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing;
@end
