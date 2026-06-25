#import "WTBottomInputView.h"
#import "UIView+Ext.h"
#define WTWidth [UIScreen mainScreen].bounds.size.width
#define WTHeight [UIScreen mainScreen].bounds.size.height
//#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define HOME_INDICATOR_HEIGHT (iPhoneX ? 34.f : 0.f)


@interface WTBottomInputView ()<UITextViewDelegate>
@property (nonatomic, strong) UIView * bottomBgView;

@end
@implementation WTBottomInputView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, WTHeight-TabBar_H, WTWidth, TabBar_H);
        self.backgroundColor = [UIColor clearColor];
        [self addNotification];
        [self setUI];
    }
    return self;
}
#pragma mark--添加通知---
-(void)addNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillhide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = keyboardF.origin.y;
    self.Y = 0;
    self.height = WTHeight;
    self.bottomBgView.Y = WTHeight-TabBar_H;
    [UIView animateWithDuration:duration animations:^{
        self.bottomBgView.Y = keyboardY-49;
    }];
}
- (void)keyboardWillhide:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = keyboardF.origin.y;
    self.Y = WTHeight-TabBar_H;
    self.height = TabBar_H;
    self.bottomBgView.Y = 0;
    [UIView animateWithDuration:duration animations:^{
        self.bottomBgView.Y = 0;
    }];
}
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
}
- (void)keyboardDidChangeFrame:(NSNotification *)notification
{
}
- (void)setUI
{
    [self addSubview:self.bottomBgView];
    [self.bottomBgView addSubview:self.senderBtn];
    [self.bottomBgView addSubview:self.textView];
   
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapPress:)];
    tapGesture.numberOfTapsRequired=1;
    [self addGestureRecognizer:tapGesture];
    
    //如果没有实名认证、不可以发送评论
    if([[UserManager userInfo].real_name_status intValue] != 2){
        //未实名
        self.textView.userInteractionEnabled = NO;
        self.textView.text = getLanguage(@"实名认证后，才能评论");
    }else{
        self.textView.userInteractionEnabled = YES;
        _textView.text=getLanguage(@"轻轻敲醒沉睡的心灵，让我看看你的点评~");
    }
}
- (void)handleTapPress:(UITapGestureRecognizer *)gestureRecognizer
{
    [self endEditing:YES];
}
- (UIView *)bottomBgView
{
    if (!_bottomBgView) {
        _bottomBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WTWidth, TabBar_H)];
        _bottomBgView.backgroundColor = [UIColor whiteColor];
        UIView * bLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _bottomBgView.width, 0.5f)];
        bLine.backgroundColor = RGBA(0, 0, 0, 0.11);
        
        [_bottomBgView addSubview:bLine];
    }
    return _bottomBgView;
}
- (UITextView *)textView
{
    if (!_textView) {
//        _textView = [[UITextView alloc]initWithFrame:CGRectMake(15, 10, WTWidth-15-91, 25)];
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(15, 10, WTWidth-15-15-65, 30)];
        _textView.text=getLanguage(@"轻轻敲醒沉睡的心灵，让我看看你的点评~");
        _textView.font = KFont(13);
        _textView.textColor=RGBA(102, 102, 102, 0.5);
        _textView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        _textView.layer.cornerRadius = KAdaptedHeight(12);
        _textView.layer.masksToBounds = YES;
//        _textView.layer.borderWidth = 0.5f;
//        _textView.layer.borderColor= [UIColor blackColor].CGColor;
//        _textView.scrollsToTop = NO;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.delegate = self;
    }
    return _textView;
}
- (UIButton *)senderBtn
{
    if (!_senderBtn) {
        _senderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _senderBtn.frame = CGRectMake(WTWidth-65, 13, 55, 25);
//        CAGradientLayer *gl = [CAGradientLayer layer];
//        gl.frame = CGRectMake(0,0,55,30);
//        gl.startPoint = CGPointMake(0, 0);
//        gl.endPoint = CGPointMake(1, 1);
//        gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:58/255.0 blue:92/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:115/255.0 blue:142/255.0 alpha:1.0].CGColor];
//        gl.locations = @[@(0.0),@(1.0f)];
//
//        [_senderBtn.layer addSublayer:gl];
//        _senderBtn.layer.cornerRadius = 25/2;

        [_senderBtn setTitle:getLanguage(@"发送") forState:UIControlStateNormal];
        _senderBtn.titleLabel.font = KFont(13);
        [_senderBtn setTitleColor:RGBA(255, 238, 1, 1) forState:UIControlStateNormal];
        _senderBtn.layer.masksToBounds = YES;
        [_senderBtn addTarget:self action:@selector(senderBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _senderBtn;
}
- (void)senderBtnClick
{
    if([[UserManager userInfo].real_name_status intValue] != 2){
        //未实名
        [SVProgressHUD showWithStatus:getLanguage(@"未进行实名认证")];
        return;
    }
    if (self.textView.text.length<=0) {
        return;
    }
    [self endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(WTBottomInputViewSendTextMessage:)]) {
        [self.delegate WTBottomInputViewSendTextMessage:self.textView.text];
        self.textView.textColor=RGBA(102, 102, 102, 0.5);
        self.textView.text =@"轻轻敲醒沉睡的心灵，让我看看你的点评~";
    }
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _textView.frame =CGRectMake(15, 10, WTWidth-15-91, 25);
    textView.text=@"";
    _textView.textColor=kBlackColor;
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"===>>");
}
- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"===>>");
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    _textView.frame =CGRectMake(15, 10, WTWidth-15-15-65, 25);
    if (textView.text.length<1) {
        _textView.text=getLanguage(@"轻轻敲醒沉睡的心灵，让我看看你的点评~");
        _textView.textColor=RGBA(102, 102, 102, 0.5);
    }
}
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    NSLog(@"===>>");
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){
        [self senderBtnClick];
        return NO;
    }
    return YES;
}
- (void)showView
{
    [self setHidden:NO];
}
- (void)hideView
{
    [self setHidden:YES];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
