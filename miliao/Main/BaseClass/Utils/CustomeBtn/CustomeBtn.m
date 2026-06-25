//
//  CustomeBtn.m
//  GroupPurchaseProject
//
//  Created by 锤子科技 on 2017/8/12.
//  Copyright © 2017年 锤子科技. All rights reserved.
//

#import "CustomeBtn.h"

@implementation CustomeBtn
{
    UILabel *_lab ;
    UIImageView *_icon;
    
    CustomeBtnType _cusType;
    
    UIFont *_cusFont;
    CGFloat _cusIconWidth;
    CGFloat _cusLableHeight;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)init
{
    self =[super init];
    if (self) {
        
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        [self addSubview:_icon];
        _icon.userInteractionEnabled = YES;
        _icon.multipleTouchEnabled = YES ;
        
        
        _lab = [[UILabel alloc]init];
        _lab.textColor = [UIColor whiteColor];
        _lab.font = [UIFont systemFontOfSize:14];
        [self addSubview:_lab];
        _lab.userInteractionEnabled = YES;
        _lab.multipleTouchEnabled = YES ;
        
        
        
        _topLab = [[UILabel alloc]init];
        _topLab.textColor = [UIColor blackColor];
        _topLab.font = [UIFont systemFontOfSize:16];
        [self addSubview:_topLab];
        _topLab.userInteractionEnabled = YES;
        _topLab.multipleTouchEnabled = YES ;
        
        
        
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = YES ;
    }
    return self ;
}

- (void)setImage:(UIImage *)image
{
    _icon.image = image ;
}

- (void)setTitle:(NSString *)title
{
    _lab.text = title ;
}
- (void)setTopTitle:(NSString *)topTitle
{
    _topLab.text = topTitle ;
}
-(void)setType:(CustomeBtnType)type
{
    _cusType = type ;
}
- (void)setTextColor:(UIColor *)textColor
{
    _lab.textColor = textColor ;
}
- (void)setFont:(UIFont *)font
{
    _cusFont = font ;
}
- (void)setIconWidth:(CGFloat)iconWidth
{
    _cusIconWidth = iconWidth ;
}
- (void)setLableHeight:(CGFloat)lableHeight
{
    _cusLableHeight = lableHeight ;
}
#pragma mark - 自适应宽高
- (void)sizeToFitForCurrentSetting
{
    _cusFont = !_cusFont ?  [UIFont systemFontOfSize:14] : _cusFont ;
    _cusIconWidth = !_cusIconWidth ? 10.0 : _cusIconWidth ;
    
    //    CustomeBtnTypeDefault,     // 左字右图
    //    CustomeBtnTypeLeftImageAndRightTitle,  // 左图右字
    //    CustomeBtnTypeTopImageAndBottomTitle,  // 上图下字
    //    CustomeBtnTypeTopTitleAndBottomImage,  // 上字下图
    
    [_lab setFont:_cusFont];
    [_icon setWidth:_cusIconWidth];
    [_icon setHeight:_cusIconWidth];
    [_lab sizeToFit];
    if (_cusLableHeight) {
        [_lab setHeight:_cusLableHeight];
    }
    
    
    [_lab setLeft:0];
    [_icon setLeft:_lab.width];
    
    CGFloat tempHeight = (_lab.height > _icon.height) ? _lab.height : _icon.height ;
    [_lab setCenterY:tempHeight / 2];
    [_icon setCenterY:tempHeight / 2 ];
    
    [self setWidth:(_lab.width + _icon.width)];
    [self setHeight:tempHeight];
    
    
    if (_cusType == CustomeBtnTypeLeftImageAndRightTitle) {
        [_icon setLeft:0];
        [_lab setLeft:_icon.right];
    }
    
    
    if (_cusType == CustomeBtnTypeTopImageAndBottomTitle) {
        [_icon setTop:0];
        [_lab setTop:_icon.bottom];
        
        CGFloat tempWidth = (_icon.width > _lab.width) ? _icon.width : _lab.width ;
        [_icon setCenterX:tempWidth / 2 ];
        [_lab setCenterX:tempWidth / 2];
        
        [self setWidth:tempWidth];
        [self setHeight:(_icon.height + _lab.height)];
    }
    
    
    if (_cusType == CustomeBtnTypeTopTitleAndBottomImage) {
        [_lab setTop:0];
        [_icon setTop:_lab.bottom];
        
        CGFloat tempWidth = (_icon.width > _lab.width) ? _icon.width : _lab.width ;
        [_icon setCenterX:tempWidth / 2 ];
        [_lab setCenterX:tempWidth / 2];
        
        [self setWidth:tempWidth];
        [self setHeight:(_icon.height + _lab.height)];
    }
    
    
    if (_cusType == CustomeBtnTypeTopTitleAndBottomTitle) {
        [_topLab sizeToFit];
        [_topLab setTop:0];
        
        [_lab setTop:_topLab.bottom + 2];
        
        CGFloat tempWidth = (_topLab.width > _lab.width) ? _topLab.width : _lab.width ;
        [_topLab setCenterX:tempWidth / 2 ];
        [_lab setCenterX:tempWidth / 2];
        
        [self setWidth:tempWidth];
        [self setHeight:(_topLab.height + _lab.height)];
    }
}

/** 点击事件*/
- (void)actionHandle:(void(^)(void))actionHandle
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        if (actionHandle) {
            actionHandle();
        }
    }];
    [self addGestureRecognizer:tap];
}

@end




