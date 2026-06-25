//
//  DTAutoFitCollectionFlowView.m
//  ChatDemo-UI3.0
//
//  Created by 锤子科技 on 2017/9/21.
//  Copyright © 2017年 锤子科技. All rights reserved.
//

#import "DTAutoFitCollectionFlowView.h"
#define kbtnTag  2984

@implementation DTAutoFitCollectionFlowView
{
    /** 字体高度，只有单行*/
    CGFloat _flowHeight;
    /** 上一次选中的index*/
    int _lastSelectIndex;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)setDataArr:(NSArray<__kindof NSString *> *)dataArr
{
    if (dataArr.count == 0) {
        return ;
    }
    
    self.multipleTouchEnabled = YES;
    self.userInteractionEnabled = YES ;
    self.backgroundColor = [UIColor clearColor];
    
    /** 初始化*/
    if (!self.fontCusSize) {
        self.fontCusSize = 12 ;
    }
    if (!self.textColor) {
        self.textColor = UIColorFromRGB(0x666666);
    }
    if (!self.WHMarginTemp) {
        self.WHMarginTemp = 0;
    }
    if (!self.WHMarginNeighborTemp) {
        self.WHMarginNeighborTemp = 0;
    }
    if (!self.Radius) {
        self.Radius = 0;
    }
    if (!self.borderColor) {
        self.borderColor = LineColor ;
    }
    
    /** 初始化*/
    _lastSelectIndex = 0 ;
    
    NSString *tempStr = @"文字高度";
    _flowHeight = [NSString heightForContent:tempStr font:[UIFont boldSystemFontOfSize:self.fontCusSize] contentWidth:200];
    _flowHeight += self.WHMarginTemp ;
    
    
    
    
    //两端没有空白，需要父类视图保留空隙
    
    __block CGFloat margin = 5 ;
    __block CGFloat  nextOriginX = 0 ;
    __block CGFloat row = 0 ;
    
    
    
    
    
    if (dataArr.count == 0) {
        [self setHeight:10];
    }else{
        
        [dataArr enumerateObjectsUsingBlock:^(__kindof NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            /** 文字宽度*/
            CGFloat flowWidth = [NSString widthForContent:obj font:[UIFont boldSystemFontOfSize:self.fontCusSize]] + 10 ;
            flowWidth += self.WHMarginTemp ;
            /** 初始化 点击事件*/
            UIButton *btn = [self viewWithTag:kbtnTag + idx];
            if (btn) {
                /** 直接设置frame即可*/
                [btn setFrame:CGRectMake(0, 0, flowWidth, _flowHeight)];
                [btn setTitle:obj forState:UIControlStateNormal];
            }else{
                /** 需要初始化 并设置frame*/
                btn = [UIButton buttonWithTitle:obj target:self action:@selector(press:) frame:CGRectMake(0, 0, flowWidth, _flowHeight) isWhite:NO];
                [self addSubview:btn];
            }
            /** 字体大小*/
            btn.titleLabel.font = [UIFont systemFontOfSize:self.fontCusSize];
            /** 字体颜色*/
            [btn setTitleColor:self.textColor forState:UIControlStateNormal];
            /** 控件tag*/
            btn.tag = kbtnTag + idx ;
            
            /** 圆角*/
            btn.layer.masksToBounds = YES;
            if (self.Radius <= 0) {
                btn.layer.cornerRadius = btn.height/2.0 ;
            } else {
                btn.layer.cornerRadius = self.Radius ;
            }
            
            /** 是否有边框 */
            if (self.isBorder) {
                btn.layer.borderColor = self.borderColor.CGColor;
                btn.layer.borderWidth = 1.0 ;
            }
            
            /** 背景颜色 */
            if (self.flowBGColor) {
                /** 如果有背景颜色，就不再有layer的颜色*/
                btn.backgroundColor = self.flowBGColor;
            }else{
                btn.backgroundColor = [UIColor whiteColor];
            }

            /** 坐标位置判断*/
            if ((nextOriginX + flowWidth > self.width) && nextOriginX != 0) {
                nextOriginX = 0 ;
                row += 1 ;
            }
            
            //如果当前单个内容宽度大于所给view宽度，直接省略号
            if (flowWidth > self.width) {
                flowWidth = self.width ;
                [btn setWidth:flowWidth];
            }
            
            [btn setLeft:nextOriginX];
            [btn setTop:(_flowHeight + margin + self.WHMarginNeighborTemp) * row];
            
            nextOriginX += (flowWidth + margin + self.WHMarginNeighborTemp) ;
            
            
            if (stop) {
                [self setHeight:((row + 1) * (_flowHeight + margin)) + 20];
            }
        }];
        
        
    }
}

- (void)press:(UIButton *)btn
{
    if (self.type == DTAutoFitCollectionFlowViewTypeFocusShow) {
        /** 需要突出显示*/
        UIButton *btn1 = [self viewWithTag:kbtnTag + _lastSelectIndex];
        btn1.backgroundColor = self.flowBGColor ;
        btn1.layer.masksToBounds = YES ;
        btn1.layer.borderColor = self.borderColor.CGColor ;
        [btn1 setTitleColor:self.textColor forState:UIControlStateNormal];
        
        /** 选中的*/
        btn.backgroundColor = UIColor.whiteColor ;
        btn.layer.masksToBounds = YES ;
        btn.layer.borderColor = self.selectColor.CGColor ;
        [btn setTitleColor:self.selectColor forState:UIControlStateNormal];
    }
    
    if (self.itemClickIndex) {
        self.itemClickIndex(btn.tag - kbtnTag);
    }
    
    /** 记录*/
    _lastSelectIndex = btn.tag - kbtnTag ;
}

-(void)setSetIndex:(NSUInteger)setIndex
{
    if (self.type == DTAutoFitCollectionFlowViewTypeFocusShow) {
        /** 需要突出显示*/
        UIButton *btn1 = [self viewWithTag:kbtnTag + _lastSelectIndex];
        btn1.backgroundColor = self.flowBGColor ;
        btn1.layer.masksToBounds = YES ;
        btn1.layer.borderColor = self.borderColor.CGColor ;
        [btn1 setTitleColor:self.textColor forState:UIControlStateNormal];
        
        /** 选中的*/
        UIButton *btn = [self viewWithTag:kbtnTag + setIndex];
        btn.backgroundColor = UIColor.whiteColor ;
        btn.layer.masksToBounds = YES ;
        btn.layer.borderColor = self.selectColor.CGColor ;
        [btn setTitleColor:self.selectColor forState:UIControlStateNormal];
    }

    
    /** 记录*/
    _lastSelectIndex = setIndex ;
}

@end






