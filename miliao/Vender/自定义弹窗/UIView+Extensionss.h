#import <UIKit/UIKit.h>
#define edge   10.f
#define Screen_Width    [UIScreen mainScreen].bounds.size.width
#define Screen_Height   [UIScreen mainScreen].bounds.size.height
#define IS_IPHONE_X (Screen_Height == 812.0f) ? YES : NO
#define Height_StatusBar (((IS_IPHONE_X ) == (YES))?(44.0): (20.0))
#define Height_NavBar (((IS_IPHONE_X ) == (YES))?(88.0): (64.0))
#define Height_TabBar (((IS_IPHONE_X ) == (YES))?(83.0): (49.0))
#define RGBCOLOR16(rgbValue) \
[UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:1.0]
#define RGBACOLOR16(rgbValue, alphaValue) \
[UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]
#define backColor RGBCOLOR16(0x151c21)
#define backBlackColor RGBCOLOR16(0x080d0e)
#define mainColor  RGBCOLOR16(0xd55900)
#define textColor3 RGBCOLOR16(0x333333)
#define textColor6 RGBCOLOR16(0x666666)
#define textColor9 RGBCOLOR16(0x999999)
@interface UIView (Extensionss)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat maxX;
@property (nonatomic, assign) CGFloat maxY;
@property (nonatomic, assign ,readonly) CGRect oneRightNextRect;
@property (nonatomic, assign ,readonly) CGRect oneBottomNextRect;
@property CGFloat top;
@property CGFloat left;
@property CGFloat bottom;
@property CGFloat right;
-(CGRect)rightNextRectWithWidth:(CGFloat)width andHeight:(CGFloat)height;
-(CGRect)bottomNextRectWithWidth:(CGFloat)width andHeight:(CGFloat)height;
@property (nonatomic, assign) CGFloat cornerRadius;
-(void)setBorderWithWidth:(CGFloat)width andColor:(UIColor *)color;
-(void)label:(UILabel *)lable font:(float)font textColor:(UIColor *)color text:(NSString *)text;
-(void)btn:(UIButton *)btn font:(float)font textColor:(UIColor *)color text:(NSString *)text image:(UIImage*)imge;
-(void)btn:(UIButton *)btn font:(float)font textColor:(UIColor *)color text:(NSString *)text image:(UIImage*)imge backImg:(NSString *)backImg;
-(void)textField:(UITextField *)textField textFont:(CGFloat)textFont placeHolderFont:(CGFloat)placeHolderFont text:(NSString *)text placeText:(NSString *)placeText textColor:(UIColor *)textColor placeHolderTextColor:(UIColor *)placeHolderTextColor;
-(CGFloat)returnHeight:(NSString *)str font:(float)font width:(float)width;
-(void)widthToFit;
-(void)heightToFit;
-(CGFloat)returnWidth:(NSString *)str font:(float)font;
-(UILabel *)labelFrame:(CGRect)frame;


-(void)byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;
@end
