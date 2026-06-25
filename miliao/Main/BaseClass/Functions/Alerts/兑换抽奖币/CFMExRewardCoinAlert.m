//
//  CFMExRewardCoinAlert.m
//  miliao
//
//  Created by Dylan Lee on 2026/1/4.
//  Copyright © 2026 EMO. All rights reserved.
//

#import "CFMExRewardCoinAlert.h"
@interface CFMExRewardCoinAlert ()
/** View */
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet UILabel *tip;
@property (weak, nonatomic) IBOutlet UIButton *btn;
/** maskview*/
@property (nonatomic,strong) UIView *maskView;
/** 异形屏，底部tab不可控区域*/
@property (nonatomic,strong)UIView *specia_screen_view;
/** 记录键盘高度*/
@property (nonatomic,assign) CGFloat keyboardHeight;
@end

@implementation CFMExRewardCoinAlert

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
    [self setFrame:CGRectMake(0, SCREEN_HEIGHT_FULL + 60, SCREEN_WIDTH, self.contentView.height)];
    [self makeCornerAt:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:15];
    [self.btn makeRoundCorner];
    
    
    NSString *str2 = @"99.00";
    NSString *str3 = [NSString stringWithFormat:@"当前钻石余额：%@",str2];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:str3];
    [str addAttribute:NSForegroundColorAttributeName value:HexColorDy(@"#FF6F00") range:NSMakeRange(7,str2.length)];
    self.balance.attributedText = str;
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
    @weakify(self);
    /** 键盘的弹出*/
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        //获取键盘的高度
        NSDictionary *userInfo = [x userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        CGFloat height = keyboardRect.size.height;
        if (self.keyboardHeight != height) {
            [self setBottom:(SCREEN_HEIGHT_FULL - height)];
            self.keyboardHeight = height ;
            DLog(@"\n+++++++++%f",height);
        }
    }];
    
    /** 键盘消失*/
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        self.keyboardHeight = 0.0 ;
        [self setBottom:SCREEN_HEIGHT_FULL];
    }];
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
        backgroundView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
//        backgroundView.userInteractionEnabled = YES;
//        backgroundView.multipleTouchEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
//        [backgroundView addGestureRecognizer:tap];
//        @weakify(self);
//        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
//            @strongify(self);
//            [self hideView];
//        }];
        _maskView = backgroundView;
    }
    return _maskView ;
}
-(UIView *)specia_screen_view
{
    if (!_specia_screen_view) {
        _specia_screen_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH, 60)];
        _specia_screen_view.backgroundColor = [UIColor whiteColor];
        _specia_screen_view.bottom = SCREEN_HEIGHT_FULL ;
    }
    return _specia_screen_view ;
}
#pragma mark --
#pragma mark --- Setter

#pragma mark --
#pragma mark --- ibaction
- (IBAction)closeAc:(id)sender {
    [self hideView];
}
- (IBAction)sureAc:(id)sender {
    [self hideView];
}

#pragma mark --
#pragma mark --- Method
- (void)show
{
    UIView *window = [ObjectTool SharedSettings].currentVC.view;
    /** 全部加载到window上*/
    [window addSubview:self];
    [window addSubview:self.maskView];
    [window bringSubviewToFront:self];
    
    if (IS_iPhoneX) {
        [window addSubview:self.specia_screen_view];
        [window insertSubview:self.specia_screen_view belowSubview:self];
    }
    
    /** 弹框动画*/
    [UIView animateWithDuration:0.3 animations:^{
        [self setBottom:SCREEN_HEIGHT];
    }completion:^(BOOL finished) {

    }];
}
- (void)hideView{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    [UIView animateWithDuration:0.15 animations:^{
        [self setTop:SCREEN_HEIGHT + 60];
    }completion:^(BOOL finished) {
        [self->_maskView removeFromSuperview];
        self->_maskView.hidden = YES ;
        self->_specia_screen_view.hidden = YES ;
        [self->_specia_screen_view removeFromSuperview];
        [self removeAllSubviews];
        [self removeFromSuperview];
    }];
}
@end
