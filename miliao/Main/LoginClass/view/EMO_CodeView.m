//
//  EMO_CodeView.m
//  miliao
//
//  Created by 张世浩 on 2023/6/16.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_CodeView.h"

@interface EMO_CodeView()
Strong UIButton *backBtn;

Strong UILabel *titleLabel;
Strong UILabel *tipLabel;

Strong UIView *codeView;
Strong UITextField *codeTextField;
Strong UIButton *codeBtn;

Strong UIButton *sendBtn;

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger count;


@end

@implementation EMO_CodeView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor=RGBA(255, 255, 248, 1);
        [self backBtn];
        [self titleLabel];
        [self tipLabel];
        [self codeView];
        [self codeTextField];
        [self codeBtn];
        [self sendBtn];
    }
    return self;
}

-(void)setPhoneStr:(NSString *)phoneStr{
    _phoneStr=phoneStr;
    [self.codeBtn setTitle:getLanguage(@"获取验证码") forState:UIControlStateNormal];
    self.tipLabel.text = [NSString stringWithFormat:@"%@%@",getLanguage(@"验证码发送至+86"),phoneStr];
    [self requestSmsCode];
}




- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:0];
        [_backBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.tag=666;
        [self addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_offset(KAdaptedWidth(0));
            make.height.mas_offset(44);
            make.width.mas_equalTo(KAdaptedWidth(50));
            make.top.mas_offset(kSafeArea_Top+KAdaptedHeight(15));
        }];
    }
    return _backBtn;
}




- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = getLanguage(@"请输入验证码");
        _titleLabel.textAlignment=NSTextAlignmentLeft;
        _titleLabel.font=KFontBold(22);
        _titleLabel.textColor = RGBA(0, 0, 0, 1);
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(10));
            make.trailing.mas_equalTo(KAdaptedWidth(-10));
            make.height.mas_equalTo(KAdaptedHeight(30));
            make.top.mas_equalTo(kSafeArea_Top+KAdaptedHeight(60));
        }];
        
    }
    return _titleLabel;
}


- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = getLanguage(@"验证码发送至+86");
        _tipLabel.textAlignment=NSTextAlignmentLeft;
        _tipLabel.font=KFont(14);
        _tipLabel.textColor = RGBA(153, 153, 153, 1);
        [self addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.titleLabel.mas_leading);
            make.trailing.mas_equalTo(self.titleLabel.mas_trailing);
            make.height.mas_equalTo(self.titleLabel.mas_height);
            make.top.mas_equalTo(self.titleLabel.mas_bottom);
        }];
        
    }
    return _tipLabel;
}

- (UIView *)codeView{
    if (!_codeView) {
        _codeView = [[UIView alloc] init];
        _codeView.layer.cornerRadius = 50;
        _codeView.layer.shadowColor = RGBA(183, 171, 65, 0.16).CGColor;
        _codeView.layer.shadowOffset = CGSizeMake(0,1);
        _codeView.layer.shadowOpacity = 1;
        _codeView.layer.shadowRadius = 2;
        [self addSubview:_codeView];
        [_codeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedHeight(50));
            make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(KAdaptedHeight(40));
        }];
        
    }
    return _codeView;
}

-(UITextField*)codeTextField{
    if (!_codeTextField) {
        _codeTextField =[[UITextField alloc] init];
        _codeTextField.backgroundColor =RGB(255, 255, 255);
        _codeTextField.keyboardType =UIKeyboardTypeNumberPad;
        _codeTextField.placeholder=getLanguage(@"请输入验证码");
        _codeTextField.textColor=kBlackColor;
        _codeTextField.font=KFont(14);
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KAdaptedWidth(45), KAdaptedHeight(20))];
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(KAdaptedWidth(15), 0, KAdaptedWidth(20), KAdaptedHeight(20))];
        imageView.image=KGetImage(@"codeIconImg");
        [view addSubview:imageView];
        _codeTextField.leftView=view;
        _codeTextField.leftViewMode=UITextFieldViewModeAlways;
        [self.codeView addSubview:_codeTextField];
        [_codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.bottom.mas_equalTo(KAdaptedWidth(0));
        }];
        setViewCorner(_codeTextField, KAdaptedHeight(25));
    }
    return _codeTextField;
}


- (UIButton *)codeBtn{
    if (!_codeBtn) {
        _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_codeBtn setTitle:getLanguage(@"获取验证码") forState:UIControlStateNormal];
        [_codeBtn setTitleColor:BaseMainColor forState:UIControlStateNormal];
        _codeBtn.titleLabel.font=KFont(12);
        [_codeBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _codeBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        _codeBtn.tag=200;
        [self.codeView addSubview:_codeBtn];
        [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.codeView.mas_trailing).offset(KAdaptedWidth(-20));
            make.width.mas_equalTo(KAdaptedWidth(100));
            make.top.bottom.mas_equalTo(0);
        }];
    }
    return  _codeBtn;
}

- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _sendBtn.layer.contents=(id)KGetImage(@"loginBgImg").CGImage;
        // 如果需要背景透明加上下面这句
//        _sendBtn.layer.backgroundColor = [UIColor clearColor].CGColor;
        [_sendBtn setTitle:getLanguage(@"登录") forState:UIControlStateNormal];
        [_sendBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_sendBtn setBackgroundColor:BaseMainColor forState:UIControlStateNormal];
        _sendBtn.height = 50 ;
        [_sendBtn makeRoundCorner];
        _sendBtn.titleLabel.font=KFont(16);
        [_sendBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _sendBtn.tag=100;
        [self addSubview:_sendBtn];
        [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.top.mas_equalTo(self.codeView.mas_bottom).offset(KAdaptedHeight(65));
            make.height.mas_equalTo( KAdaptedHeight(50));
        }];
    }
    return _sendBtn;
}





-(void)BtnClick:(UIButton *)sender{
    if (sender.tag==200){
        [self requestSmsCode];
    }else{
        if(sender.tag==100){
            if(self.codeTextField.text.length<1){
                return [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"请输入验证码")];
            }
        }
        [self.timer invalidate];
        self.timer = nil;
        if(self.BtnBlick){
            NSString *string =NSUserTake(@"inviteCode");
            if(string.length>0){
                self.BtnBlick(sender.tag, @{@"mobile":self.phoneStr,@"captcha":self.codeTextField.text,@"invite_code":string,@"type":@"0"});
            }else{
                self.BtnBlick(sender.tag, @{@"mobile":self.phoneStr,@"captcha":self.codeTextField.text,@"type":@"0"});
            }
            
        }
    }
    
    
    
}


//获取短信
- (void)requestSmsCode{
    [NetworkRequest POST:Request_SendSms parmeters:@{@"mobile":self.phoneStr,
                     @"event":@"mobilelogin",
                               } success:^(id responObject) {
        NSLog(@"--- 验证码接口返回数据 (SMS Response): %@", responObject);
        BaseModel *baseModel = (BaseModel *)responObject;
        self.count = 60;
        self.codeBtn.enabled = NO;
        self.timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
        [self.codeBtn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:[Common isNull:baseModel.msg]];
    } failture:^(NSError *errors) {

    }];
    
    
}

-(void)timerEvent{
    
    [_codeBtn setTitle:[NSString stringWithFormat:@"%ld%@",(long)_count,getLanguage(@"秒")] forState:0];
    _count--;
    if (_count == 0) {
        [self.timer invalidate];
        self.timer = nil;
        _count = 60;
        _codeBtn.enabled = YES;
        [_codeBtn setTitle:getLanguage(@"重新发送") forState:0];
        [_codeBtn setTitleColor:BaseMainColor forState:UIControlStateNormal];
        
    }
    
}





@end
