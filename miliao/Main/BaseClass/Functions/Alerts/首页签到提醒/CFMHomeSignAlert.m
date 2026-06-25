//
//  CFMHomeSignAlert.m
//  miliao
//
//  Created by Dylan Lee on 2025/12/10.
//  Copyright © 2025 EMO. All rights reserved.
//

#import "CFMHomeSignAlert.h"
#import "EMO_RenZhengViewController.h"
@interface CFMHomeSignAlert ()
/** View */
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UIButton *btn;
/** maskview*/
@property (nonatomic,strong) UIView *maskView;
@end

@implementation CFMHomeSignAlert

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
    [self setFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height)];
    [self setCenter:CGPointMake(SCREEN_WIDTH / 2.0, SCREEN_HEIGHT_dy / 2.0)];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 12 ;
    [self.btn makeRoundCorner];
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
-(UIView *)maskView
{
    if (!_maskView) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        /** 遮罩视图*/
        UIView *backgroundView = [[UIView alloc] initWithFrame:window.bounds];
        //        backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        backgroundView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.7];
        backgroundView.userInteractionEnabled = YES;
        backgroundView.multipleTouchEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        [backgroundView addGestureRecognizer:tap];
        @weakify(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            @strongify(self);
            [self hideView];
        }];
        _maskView = backgroundView;
    }
    return _maskView ;
}
#pragma mark --
#pragma mark --- Setter

#pragma mark --
#pragma mark --- ibaction
- (IBAction)ac:(id)sender {
    //如果没有实名认证、不可以发送评论
    if([[UserManager userInfo].real_name_status intValue] != 2){
        /** 是否实名认证 0.待提交,1.审核中,2.审核通过,3.审核拒绝*/
        if ([UserManager userInfo].real_name_status.intValue==1) {
            [SVProgressHUD showTextHUDWithMessage:@"实名认证审核中！"];
            return;
        }
        
        [self hideView];

        //未实名
        DYAlertView *alert = [[DYAlertView alloc] initWithTitle:@"温馨提示" content:@"请先完成实名认证！" construct:@"确定" completion:^{
            
            EMO_RenZhengViewController *vc=[EMO_RenZhengViewController new];
            [Dn_NAVPUSH pushViewController:vc animated:YES];
        }];
        [alert addButtonTitle:@"取消" completion:^{
            
        }];
        [alert show];
        return;
    }

    /** 去签到*/
    NSString *url = [NSString stringWithFormat:@"%@?token=%@&type=sign",lottery_lottery_h5,UserDefaultsGet(kToken)];
    
    WebJSVc *load = [[WebJSVc alloc]init];
    load.webUrl = url;
    [Dn_NAVPUSH pushViewController:load animated:YES];
    
    [self hideView];
}
#pragma mark --
#pragma mark --- Method
- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    /** 全部加载到window上，不会出现点击异常事件*/
    [window addSubview:self];
    [window addSubview:self.maskView];
    [window bringSubviewToFront:self];
    
    /** 弹框动画*/
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.1;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:1.0];
    pulse.toValue= [NSNumber numberWithFloat:1.1];
    [self.layer addAnimation:pulse forKey:nil];
}
- (void)hideView{
    [UIView animateWithDuration:0.15 animations:^{
        self.transform = CGAffineTransformMakeScale(.3f, .3f);
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self deallocSubview];
    }];
}
/** 销毁view*/
- (void)deallocSubview
{
    [_maskView removeFromSuperview];
    [self removeFromSuperview];
    _maskView.hidden = YES ;
}
@end
