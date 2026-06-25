//
//  EFMineInfoList.m
//  enjoyfun
//
//  Created by 李东阳 on 2019/10/6.
//  Copyright © 2019 锤子科技. All rights reserved.
//

#import "EFMineInfoList.h"
@interface EFMineInfoList ()
/** View */
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;

@end

@implementation EFMineInfoList

#pragma mark -
#pragma mark --- init
-(instancetype)init
{
    self = [super init];
    if (self) {
        /** 初始化*/
        [self initContentview];
        /** RAC*/
        [self initRacChain];
    }
    return self ;
}

#pragma mark -
#pragma mark --- init frame
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /** 初始化*/
        [self initContentview];
        /** RAC*/
        [self initRacChain];
    }
    return self ;
}

#pragma mark -
#pragma mark --- 初始化view
- (void)initContentview
{
    [self.lab2 setWidth:(SCREEN_WIDTH - 124)];
    /** 默认隐藏*/
    self.leftIcon.hidden = YES ;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    /** 初始化*/
    [self initContentview];
    /** RAC*/
    [self initRacChain];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -
#pragma mark --- Rac
- (void)initRacChain {
    
}

#pragma mark -
#pragma mark --- Getter

#pragma mark --
#pragma mark --- Setter
-(void)setLab1Str:(NSString *)lab1Str
{
    self.lab1.text = lab1Str ;
}
-(void)setLab2Str:(NSString *)lab2Str
{
    /** 个人资料里 手机号加个 修改*/
    if ([lab2Str rangeOfString:@"****"].location != NSNotFound) {
        NSString *tempStr = [NSString stringWithFormat:@"%@  修改",lab2Str];
        self.lab2.attributedText = [NSString attributedString:tempStr font:nil color:BaseMainColor range:NSMakeRange(tempStr.length - 2, 2)];
        return;
    }
    
    self.lab2.text = lab2Str ;
    CGFloat height = [NSString heightForContent:lab2Str font:self.lab2.font contentWidth:self.lab2.width];
    [self.lab2 setHeight:height] ;
    [self.contentView setHeight:(self.lab2.bottom + 16)];
}
-(void)setLab2TextColor:(UIColor *)lab2TextColor
{
    self.lab2.textColor = lab2TextColor ;
}
-(void)setLab2TextAlign:(NSTextAlignment)lab2TextAlign
{
    self.lab2.textAlignment = lab2TextAlign ;
}
-(void)setIsArrowShow:(BOOL)isArrowShow
{
    self.arrow.hidden = !isArrowShow ;
}
#pragma mark --
#pragma mark --- ibaction

#pragma mark --
#pragma mark --- Method
@end
