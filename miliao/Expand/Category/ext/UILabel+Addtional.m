//
//  UILabel+Addtional.m
//  JinYiYuShi
//
//  Created by 李东阳 on 2019/1/18.
//  Copyright © 2019年 锤子科技. All rights reserved.
//

#import "UILabel+Addtional.h"

@implementation UILabel (Addtional)
+ (UILabel *)LabelWithFrame:(CGRect)frame fontSize:(int)size textColor:(UIColor *)textColor  textAlient:(NSTextAlignment)alient  numberLines:(int)numLine
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    if (size) {
        label.font =  PingFangFONT(size);
    }
    if (textColor) {
        label.textColor =  textColor;
    }
    if (alient) {
        label.textAlignment =  alient;
    }
    if (numLine) {
        label.numberOfLines =  numLine;
    }
    //手势操作
    [label addLongPressGesture];
    return label;
}

//添加长按手势

- (void)addLongPressGesture {
    
    self.userInteractionEnabled = YES;
    
    UILongPressGestureRecognizer * longGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longAction:)];
    
    [self addGestureRecognizer:longGesture];
    
}

//长按触发的事件

- (void)longAction:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        DLog(@"长按手势已经触发");
        
        //一定要调用这个方法
        
        [self becomeFirstResponder];
        
        //创建菜单控制器
        
        UIMenuController * menuvc = [UIMenuController sharedMenuController];
        
        UIMenuItem * menuItem1 = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(firstItemAction:)];
        
        menuvc.menuItems = @[menuItem1];
        
        [menuvc setTargetRect:CGRectMake(self.bounds.size.width/2, self.bounds.origin.y-5, 0, 0) inView:self];
        
        [menuvc setMenuVisible:YES animated:YES];
        
    }
    
}

#pragma mark--设置每一个item的点击事件

- (void)firstItemAction:(UIMenuItem *)item

{
    
    //通过系统的粘贴板，记录下需要传递的数据
    if (self.text) {
        if (self.text.length>0) {
            [SVProgressHUD showTextHUDWithMessage:@"复制成功"];
            
            UIPasteboard *pboard = [UIPasteboard generalPasteboard];
            pboard.string = self.text;
        }
    }
    
    
}

#pragma mark--必须实现的关键方法

//自己能否成为第一响应者

- (BOOL)canBecomeFirstResponder

{
    return YES;
}

//能否处理Action事件

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(firstItemAction:)) {
        
        return YES;
        
    }
    
    return [super canPerformAction:action withSender:sender];
}

//}
//-(BOOL)canBecomeFirstResponder {
//
//    return YES;
//}
//
//// 可以响应的方法
//-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
//
//    return (action == @selector(copy:));
//}
//
////针对于响应方法的实现
//-(void)copy:(id)sender {
//
//    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
//    pboard.string = self.text;
//}
//
////UILabel默认是不接收事件的，我们需要自己添加touch事件
//-(void)attachTapHandler {
//
//    self.userInteractionEnabled = YES;
//
//    UILongPressGestureRecognizer *touch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//    [self addGestureRecognizer:touch];
//}
//
////绑定事件
//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//
//        [self attachTapHandler];
//    }
//    return self;
//}
//
//-(void)awakeFromNib {
//
//    [super awakeFromNib];
//    [self attachTapHandler];
//}
//
//-(void)handleTap:(UIGestureRecognizer*) recognizer {
//
//    [self becomeFirstResponder];
//    UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:@"复制"
//                                                      action:@selector(copy:)];
//    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyLink, nil]];
//    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
//    [[UIMenuController sharedMenuController] setMenuVisible:YES animated: YES];
//    [UIMenuController sharedMenuController].menuItems=nil;
//}

/** 验证码倒计时*/
- (void)smsCodeCountingDownIntervall:(int)interval
{
    interval = (!interval || interval < 0) ? 60 : interval ;
    __block int timeout = interval; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.text = @"验证码";
                [self isCountingState:NO];
            });
        }else{
            int seconds = timeout % 60 == 0 ? 60 : timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.1d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.text = [NSString stringWithFormat:@"%@s",strTime];
                [self isCountingState:YES];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
/** 倒计时展示状态*/
- (void)isCountingState:(BOOL)is
{
    if (is) {
        self.backgroundColor = HexColorDy(@"F7F7F7");
        self.textColor = BaseMainColor ;
        self.userInteractionEnabled = NO ;
        self.multipleTouchEnabled = NO ;
    }else{
        self.backgroundColor = BaseMainColor;
        self.textColor = UIColor.whiteColor ;
        self.userInteractionEnabled = YES ;
        self.multipleTouchEnabled = YES ;
    }
}

/**  设置lable宽度 高度*/
- (void)fetchLableWidth
{
    self.width = [NSString widthForContent:self.text font:self.font] + 5 ;
}
- (void)fetchLableHeight
{
    self.height = [NSString heightForContent:self.text font:self.font contentWidth:self.width] + 15 ;
}
@end
