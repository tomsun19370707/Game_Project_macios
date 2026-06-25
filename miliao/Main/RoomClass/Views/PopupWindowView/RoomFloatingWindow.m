//
//  RoomFloatingWindow.m
//  miliao
//
//  Created by aa on 2019/7/2.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "RoomFloatingWindow.h"

@interface RoomFloatingWindow ()
@property (nonatomic, assign)CGPoint originalPoint;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@end

@implementation RoomFloatingWindow

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:[MLRoomInformationModel currentAccount].image] placeholderImage:[UIImage imageNamed:@"未加载头像"]];
    self.bgView.layer.shadowOffset = CGSizeMake(0,1);
    self.bgView.layer.masksToBounds = NO;
    self.bgView.layer.shadowColor = mainQianColor.CGColor;
    self.bgView.layer.shadowOpacity = 0.5f;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
    [self.bgView addGestureRecognizer:singleTap];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue = [NSNumber numberWithFloat: M_PI *2];
    animation.duration = 3;
    animation.autoreverses = NO;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [self.icon.layer addAnimation:animation forKey:nil];
}

- (IBAction)shutDownButton:(UIButton *)sender {
    !self.shutDownButtonBlock ?: self.shutDownButtonBlock();
}
- (IBAction)muteSwitchButton:(UIButton *)sender {
    !self.muteSwitchButtonBlock ?: self.muteSwitchButtonBlock();
}
- (void)singleTapGesture:(UITapGestureRecognizer *)tap{
    ! self.enterTheRoomBlock ?: self.enterTheRoomBlock();
}
//滑动事件
- (void)pan:(UIPanGestureRecognizer *)pan{
    //获取当前位置
    CGPoint currentPosition = [pan locationInView:self];
    if (pan.state == UIGestureRecognizerStateBegan) {
        _originalPoint = currentPosition;
    }else if(pan.state == UIGestureRecognizerStateChanged){
        //偏移量(当前坐标 - 起始坐标 = 偏移量)
        CGFloat offsetX = currentPosition.x - _originalPoint.x;
        CGFloat offsetY = currentPosition.y - _originalPoint.y;
        
        //移动后的按钮中心坐标
        CGFloat centerX = self.center.x + offsetX;
        CGFloat centerY = self.center.y + offsetY;
        self.center = CGPointMake(centerX, centerY);
        
        //父试图的宽高
        CGFloat superViewWidth = self.superview.frame.size.width;
        CGFloat superViewHeight = self.superview.frame.size.height - TabBar_H;
        CGFloat btnX = self.frame.origin.x;
        CGFloat btnY = self.frame.origin.y;
        CGFloat btnW = self.frame.size.width;
        CGFloat btnH = self.frame.size.height;
        
        //x轴左右极限坐标
        if (btnX > superViewWidth){
            //按钮右侧越界
            CGFloat centerX = superViewWidth - btnW/2;
            self.center = CGPointMake(centerX, centerY);
        }else if (btnX < 0){
            //按钮左侧越界
            CGFloat centerX = btnW * 0.5;
            self.center = CGPointMake(centerX, centerY);
        }
        
        //默认都是有导航条的，有导航条的，父试图高度就要被导航条占据，固高度不够
        CGFloat defaultNaviHeight = ZJTopNavH;
        CGFloat judgeSuperViewHeight = superViewHeight - defaultNaviHeight;
        
        //y轴上下极限坐标
        if (btnY <= TabBar_H + btnH * 0.5){
            //按钮顶部越界
            centerY = TabBar_H + btnH * 0.5;
            self.center = CGPointMake(centerX, centerY);
        }
        else if (btnY > judgeSuperViewHeight){
            //按钮底部越界
            CGFloat y = superViewHeight - btnH * 0.5;
            self.center = CGPointMake(btnX, y);
        }
    }else if (pan.state == UIGestureRecognizerStateEnded){
        CGFloat btnWidth = self.frame.size.width;
        CGFloat btnHeight = self.frame.size.height;
        CGFloat btnY = self.frame.origin.y;
        //        CGFloat btnX = self.frame.origin.x;

                //自动识别贴边
        if (self.center.x >= self.superview.frame.size.width/2) {
                    
            [UIView animateWithDuration:0.5 animations:^{
                        //按钮靠右自动吸边
                CGFloat btnX = self.superview.frame.size.width - btnWidth;
                self.frame = CGRectMake(btnX, btnY, btnWidth, btnHeight);
            }];
        }else{
            [UIView animateWithDuration:0.5 animations:^{
                        //按钮靠左吸边
                CGFloat btnX = 0;
                self.frame = CGRectMake(btnX, btnY, btnWidth, btnHeight);
            }];
        }
    }
}
@end
