//
//  EMO_LoginView.m
//  miliao
//
//  Created by 张世浩 on 2022/10/10.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_LoginView.h"
#import "ZBLabel.h"
@interface EMO_LoginView()<YBAttributeTapActionDelegate>
Strong UIButton *backBtn;

Strong UILabel *titleLabel;
Strong UILabel *tipLabel;

Strong UIView *codeBgView;
Strong UIView *bgView;
Strong UITextField *phoneTextField;
Strong UILabel *phoneTipLabel;

Strong UIView *phoneBgView;
Strong UIView *phoneView;
Strong UITextField *phoneField;
Strong UIView *codeView;
Strong UITextField *codeTextField;
Strong UIView *passwordView;
Strong UITextField *passwordTextField;
Strong UIButton *codeBtn;

Strong UIButton *registBtn;
Strong UIButton *forgetBtn;

Strong UIButton *sendBtn;

Strong UIStackView *stackView;
//@property(nonatomic,strong) UIButton * readBtn;
@property(nonatomic,strong) ZBLabel * noticeLabel;

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger count;

Assign NSInteger type;

Strong NSString *selectType;

Assign BOOL changeView;

/** 默认的提示*/
@property (nonatomic,strong) UILabel *loginTip;
/** 同意按钮*/
@property (nonatomic,strong) UIButton *gouBtn;
/** 同意扩大按钮*/
@property (nonatomic,strong) UIButton *gouExpandBtn;
/** 强制隐私政策按钮*/
@property (nonatomic,strong) UIButton *praBtn;
@end


@implementation EMO_LoginView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor=RGBA(255, 255, 248, 1);
        [self backBtn];
        [self titleLabel];
        [self tipLabel];
        [self codeBgView];
        [self bgView];
        [self phoneTextField];
        [self phoneTipLabel];
        
        [self phoneBgView];
        [self phoneView];
        [self phoneField];
        [self codeView];
        [self codeTextField];
        [self codeBtn];
        [self passwordView];
        [self passwordTextField];
        
        [self registBtn];
        [self forgetBtn];
        
        [self sendBtn];
        [self stackView];
        [self noticeLabel];
        [self praBtn];
        
        self.isAgree = YES ;
        [self addSubview:self.gouBtn];
        [self addSubview:self.gouExpandBtn];
        self.gouExpandBtn.center = self.gouBtn.center ;
        
//        NSArray *threeLoginArr=@[@"phoneImg",@"qqImg",@"wechatImg",@"login_apple"];
        NSArray *threeLoginArr=@[@"phoneImg",@"qqImg",@"wechatImg"];
        NSInteger A=0;
        for (NSString *iconName in threeLoginArr) {
            UIButton *iconBtn=[[UIButton alloc] init];
            [iconBtn setImage:KGetImage(iconName) forState:0];
            iconBtn.tag=1000+A;
            [iconBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.stackView addArrangedSubview:iconBtn];
            A++;
        }
        self.changeView=NO;
        self.selectType=@"codeLogin";
        self.type=1;
        [self upDataView:self.type];
        
        
    }
    return self;
}

-(void)freshView:(NSInteger)type{
    self.type=2;
    self.selectType=@"mobileLogin";
    [self upDataView:2];
    
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
        _titleLabel.text = getLanguage(@"您好,");
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
        _tipLabel.text = getLanguage(@"欢迎来到旅遇");
        _tipLabel.textAlignment=NSTextAlignmentLeft;
        _tipLabel.font=PingFangFONT(14);
        _tipLabel.textColor = HexColorDy(@"999999");
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

- (UIView *)codeBgView{
    if (!_codeBgView) {
        _codeBgView = [[UIView alloc] init];
        _codeBgView.backgroundColor = kClearColor;
        [self addSubview:_codeBgView];
        [_codeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(KAdaptedHeight(55));
            make.leading.trailing.mas_equalTo(0);
            make.height.mas_equalTo(KAdaptedHeight(100));
        }];
    }
    return _codeBgView;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
//        _bgView.backgroundColor = kWhiteColor;
        _bgView.layer.cornerRadius = 50;
        _bgView.layer.shadowColor = RGBA(183, 171, 65, 0.16).CGColor;
        _bgView.layer.shadowOffset = CGSizeMake(0,1);
        _bgView.layer.shadowOpacity = 1;
        _bgView.layer.shadowRadius = 2;
        [self.codeBgView addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedHeight(50));
            make.top.mas_equalTo(5);
        }];
//        setViewCorner(_bgView, KAdaptedHeight(50))
    }
    return _bgView;
}

-(UITextField*)phoneTextField{
    if (!_phoneTextField) {
        _phoneTextField =[[UITextField alloc] init];
        _phoneTextField.backgroundColor =RGB(255, 255, 255);
        _phoneTextField.keyboardType =UIKeyboardTypeNumberPad;
        _phoneTextField.placeholder=getLanguage(@"请输入手机号");
        _phoneTextField.textColor=kBlackColor;
        _phoneTextField.font=KFont(14);
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KAdaptedWidth(15), KAdaptedHeight(15))];
        _phoneTextField.leftView=view;
        _phoneTextField.leftViewMode=UITextFieldViewModeAlways;
        [self.bgView addSubview:_phoneTextField];
        [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.bottom.mas_equalTo(KAdaptedWidth(0));
        }];
        setViewCorner(_phoneTextField, KAdaptedHeight(25));
    }
    return _phoneTextField;
}


- (UILabel *)phoneTipLabel{
    if (!_phoneTipLabel) {
        _phoneTipLabel = [[UILabel alloc] init];
//        _phoneTipLabel.text = getLanguage(@"未注册的手机号验证后自动创建账户");
        _phoneTipLabel.textColor = RGBA(153, 153, 153, 1);
        _phoneTipLabel.font=KFontA(12);
        [self.codeBgView addSubview:_phoneTipLabel];
        [_phoneTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bgView.mas_bottom).offset(KAdaptedHeight(10));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedHeight(25));

        }];
    }
    return _phoneTipLabel;
}


- (UIView *)phoneBgView{
    if (!_phoneBgView) {
        _phoneBgView = [[UIView alloc] init];
        _phoneBgView.backgroundColor = kClearColor;
        [self addSubview:_phoneBgView];
        [_phoneBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(KAdaptedHeight(55));
            make.leading.trailing.mas_equalTo(0);
            make.height.mas_equalTo(KAdaptedHeight(190));
        }];
    }
    return _phoneBgView;
}

- (UIView *)phoneView{
    if (!_phoneView) {
        _phoneView = [[UIView alloc] init];
        _phoneView.layer.cornerRadius = 50;
        _phoneView.layer.shadowColor = RGBA(183, 171, 65, 0.16).CGColor;
        _phoneView.layer.shadowOffset = CGSizeMake(0,1);
        _phoneView.layer.shadowOpacity = 1;
        _phoneView.layer.shadowRadius = 2;
        [self.phoneBgView addSubview:_phoneView];
        [_phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedHeight(50));
            make.top.mas_equalTo(5);
        }];
    }
    return _phoneView;
}

-(UITextField*)phoneField{
    if (!_phoneField) {
        _phoneField =[[UITextField alloc] init];
        _phoneField.backgroundColor =RGB(255, 255, 255);
        _phoneField.keyboardType =UIKeyboardTypeNumberPad;
        _phoneField.placeholder=getLanguage(@"请输入手机号");
        _phoneField.textColor=kBlackColor;
        _phoneField.font=KFont(14);
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KAdaptedWidth(45), KAdaptedHeight(20))];
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(KAdaptedWidth(15), 0, KAdaptedWidth(20), KAdaptedHeight(20))];
        imageView.image=KGetImage(@"phoneIconImg");
        [view addSubview:imageView];
        _phoneField.leftView=view;
        _phoneField.leftViewMode=UITextFieldViewModeAlways;
        [self.phoneView addSubview:_phoneField];
        [_phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.bottom.mas_equalTo(KAdaptedWidth(0));
        }];
        setViewCorner(_phoneField, KAdaptedHeight(25));
    }
    return _phoneField;
}

- (UIView *)codeView{
    if (!_codeView) {
        _codeView = [[UIView alloc] init];
        _codeView.layer.cornerRadius = 50;
        _codeView.layer.shadowColor = RGBA(183, 171, 65, 0.16).CGColor;
        _codeView.layer.shadowOffset = CGSizeMake(0,1);
        _codeView.layer.shadowOpacity = 1;
        _codeView.layer.shadowRadius = 2;
        [self.phoneBgView addSubview:_codeView];
        [_codeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedHeight(50));
            make.top.mas_equalTo(self.phoneView.mas_bottom).offset(KAdaptedHeight(20));
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





- (UIView *)passwordView{
    if (!_passwordView) {
        _passwordView = [[UIView alloc] init];
        _passwordView.layer.cornerRadius = 50;
        _passwordView.layer.shadowColor = RGBA(183, 171, 65, 0.16).CGColor;
        _passwordView.layer.shadowOffset = CGSizeMake(0,1);
        _passwordView.layer.shadowOpacity = 1;
        _passwordView.layer.shadowRadius = 2;
        [self.phoneBgView addSubview:_passwordView];
        [_passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedHeight(50));
            make.top.mas_equalTo(self.codeView.mas_bottom).offset(KAdaptedHeight(20));
        }];
    }
    return _passwordView;
}

-(UITextField*)passwordTextField{
    if (!_passwordTextField) {
        _passwordTextField =[[UITextField alloc] init];
        _passwordTextField.backgroundColor =RGB(255, 255, 255);
        _passwordTextField.keyboardType =UIKeyboardTypeDefault;
        _passwordTextField.placeholder=getLanguage(@"请输入密码");
        _passwordTextField.textColor=kBlackColor;
        _passwordTextField.font=KFont(14);
        _passwordTextField.secureTextEntry = YES;
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KAdaptedWidth(45), KAdaptedHeight(20))];
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(KAdaptedWidth(15), 0, KAdaptedWidth(20), KAdaptedHeight(20))];
        imageView.image=KGetImage(@"psdIconImg");
        [view addSubview:imageView];
        _passwordTextField.leftView=view;
        _passwordTextField.leftViewMode=UITextFieldViewModeAlways;
        [self.passwordView addSubview:_passwordTextField];
        [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.bottom.mas_equalTo(KAdaptedWidth(0));
        }];
        setViewCorner(_passwordTextField, KAdaptedHeight(25));
    }
    return _passwordTextField;
}


- (UIButton *)registBtn{
    if (!_registBtn) {
        _registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registBtn setTitle:getLanguage(@"注册账号") forState:UIControlStateNormal];
        [_registBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        _registBtn.titleLabel.font=KFont(12);
        [_registBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _registBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        _registBtn.tag=555;
        [self.phoneBgView addSubview:_registBtn];
        [_registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.width.mas_equalTo(KAdaptedWidth(100));
            make.top.mas_equalTo(self.passwordView.mas_bottom).offset(KAdaptedHeight(20));
            make.height.mas_equalTo(KAdaptedHeight(30));
        }];
    }
    return  _registBtn;
}

- (UIButton *)forgetBtn{
    if (!_forgetBtn) {
        _forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetBtn setTitle:getLanguage(@"忘记密码?") forState:UIControlStateNormal];
        [_forgetBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        _forgetBtn.titleLabel.font=KFont(12);
        [_forgetBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _forgetBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        _forgetBtn.tag=888;
        [self.phoneBgView addSubview:_forgetBtn];
        [_forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.width.mas_equalTo(KAdaptedWidth(100));
            make.top.mas_equalTo(self.passwordView.mas_bottom).offset(KAdaptedHeight(20));
            make.height.mas_equalTo(KAdaptedHeight(30));
        }];
    }
    return  _forgetBtn;
}



- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _sendBtn.layer.contents=(id)KGetImage(@"loginBgImg").CGImage;
        _sendBtn.backgroundColor = BaseMainColor ;
        _sendBtn.frame = CGRectMake(0, 0, ScreenWidth - 15 * 2, 50);
        [_sendBtn makeRoundCorner];
        [_sendBtn setTitle:getLanguage(@"获取验证码") forState:UIControlStateNormal];
        [_sendBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _sendBtn.titleLabel.font=KFont(16);
        [_sendBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _sendBtn.tag=100;
        [self addSubview:_sendBtn];
        [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.top.mas_equalTo(self.codeBgView.mas_bottom).offset(KAdaptedHeight(45));
            make.height.mas_equalTo( KAdaptedHeight(50));
        }];
    }
    return _sendBtn;
}

-(UIButton *)praBtn
{
    if (!_praBtn) {
        _praBtn = [UIButton racButtonWithTitle:nil BGImage:nil frame:CGRectMake(0, 0, 66, 30) fontSize:1 titleColor:nil];
        _praBtn.backgroundColor = UIColor.clearColor ;
        _praBtn.bottom = SCREEN_HEIGHT_dy - 30 ;
        _praBtn.centerX = SCREENWIDTH / 2.0 + 86 ;

        [[_praBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
   
            [NetworkRequest POST:Request_AppText parmeters:nil success:^(id responObject) {
                BaseModel *baseModel = (BaseModel *)responObject;
                EMO_WebViewController *vc=[EMO_WebViewController new];
                NSDictionary *dic =baseModel.data[1];
                vc.titleType=dic[@"title"];
                vc.strUrl=dic[@"content"];
                [[Common getCurrentVC].navigationController pushViewController:vc animated:YES];
                
            } failture:^(NSError *error) {
                
                
            }];
        }];
        
        [self addSubview:_praBtn];
    }
    return _praBtn;
}





-(UIStackView *)stackView{
    if (!_stackView) {
        _stackView= [[UIStackView alloc] init];
//        _stackView.backgroundColor = [UIColor yellowColor];
        _stackView.spacing=KAdaptedWidth(20);
        _stackView.axis  =  UILayoutConstraintAxisHorizontal;
        _stackView.alignment=UIStackViewAlignmentCenter;
        _stackView.distribution=UIStackViewDistributionEqualSpacing;
        [self addSubview:_stackView];
        [_stackView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.mas_equalTo(KAdaptedWidth(30));
//            make.trailing.mas_equalTo(KAdaptedWidth(-30));
            make.centerX.mas_equalTo(KAdaptedWidth(0));
            make.width.mas_equalTo(KAdaptedWidth(200));
            make.bottom.mas_equalTo(-KAdaptedHeight(80)-KSAFEAREA_BOTTOM_HEIHGHT);
            make.height.mas_equalTo(KAdaptedHeight(55));
            
        }];
        
    }
    return _stackView;
}



//- (UIButton *)readBtn {
//    if (!_readBtn) {
//        _readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _readBtn.frame = CGRectZero;
//        [_readBtn addTarget:self action:@selector(readBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [_readBtn setImage:[UIImage imageNamed:@"gouxuanImg"] forState:UIControlStateNormal];
//        [_readBtn setImage:[UIImage imageNamed:@"noticSelectImg"] forState:UIControlStateSelected];
//        [self addSubview:_readBtn];
//        [_readBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(35, 45));
//            make.centerY.mas_equalTo(self.noticeLabel).mas_offset(0);
//            make.trailing.mas_equalTo(self.noticeLabel.mas_leading).mas_offset(0);
//        }];
//    }
//    return _readBtn;
//}

- (ZBLabel *)noticeLabel {
    if (!_noticeLabel) {
        WeakSelf;
        _noticeLabel = [[ZBLabel alloc] initWithFrame:CGRectZero];
        _noticeLabel.textColor = RGBA(153, 153, 153,1);
        _noticeLabel.numberOfLines = 0;
        _noticeLabel.backgroundColor = [UIColor clearColor];
        _noticeLabel.font = [UIFont systemFontOfSize:12];
        _noticeLabel.textAlignment=NSTextAlignmentCenter;
        _noticeLabel.userInteractionEnabled = YES;
//        NSString *str = getLanguage(@"已阅读并同意《用户协议》和《隐私政策》");
        _noticeLabel.text = @"登录即表明同意《用户协议》和《隐私政策》";
        _noticeLabel.attributedText=[[NSAttributedString alloc] initWithString:_noticeLabel.text];
        [_noticeLabel setFontColor:RGBA(104, 165, 225, 1) string:@"《用户协议》"];
        [_noticeLabel setFontColor:RGBA(104, 165, 225, 1) string:@"《隐私政策》"];
        _noticeLabel.tapHighlightedColor=[UIColor clearColor];
        [_noticeLabel yb_addAttributeTapActionWithStrings:@[@"《用户协议》",@"《隐私政策》"] delegate:self];
        [_noticeLabel yb_addAttributeTapActionWithStrings:@[@"《用户协议》",@"《隐私政策》"] tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {


            [wself xieyiData:index];
            
        }];
        
        [self addSubview:_noticeLabel];
        [_noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.mas_offset(50);
            make.leading.mas_equalTo(self.sendBtn.mas_leading).offset(0);
            make.trailing.mas_equalTo(self.sendBtn.mas_trailing).offset(0);
            make.centerX.mas_equalTo(self.mas_centerX).mas_offset(10);
            make.height.greaterThanOrEqualTo(@40);
            make.bottom.mas_equalTo(-KSAFEAREA_BOTTOM_HEIHGHT-KAdaptedHeight(20));
        }];
    }
    return _noticeLabel;
}




/**协议按钮选中方法*/
//- (void)readBtnClick{
//    self.readBtn.selected = !self.readBtn.selected;
//}


-(void)xieyiData:(NSInteger )index{
    
    
    [NetworkRequest POST:Request_AppText parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        EMO_WebViewController *vc=[EMO_WebViewController new];
        NSDictionary *dic =baseModel.data[0];
        vc.titleType=dic[@"title"];
        vc.strUrl=dic[@"content"];
        [[Common getCurrentVC].navigationController pushViewController:vc animated:YES];
        
    } failture:^(NSError *error) {
        
        
    }];
    
    
}








-(void)BtnClick:(UIButton *)sender{
//    100登录  1000-1003三方登录 200获取验证码  666返回  888 忘记密码
    NSMutableDictionary *dicData=[NSMutableDictionary dictionary];
   
    if (!self.isAgree) {
        [SVProgressHUD showTextHUDWithMessage:@"请勾选并同意协议！"];
        return;
    }
    
    switch (sender.tag) {
        case 100:{
            NSString *codeStr =NSUserTake(@"inviteCode");
            
            if(self.type==1){
                if(self.phoneTextField.text.length<1){
                    return[SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"电话号不能为空")];
                }
                [dicData addEntriesFromDictionary:@{@"phone":self.phoneTextField.text}];
            }else{
                if(self.phoneField.text.length<1){
                    return[SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"电话号不能为空")];
                }
                if(self.passwordTextField.text.length<1){
                    return[SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"密码不能为空")];
                }
                if(self.type==2){
                    [dicData addEntriesFromDictionary:@{@"mobile":self.phoneField.text,@"password":self.passwordTextField.text}];
                
                }else if(self.type==3||self.type==5){
                    if(self.codeTextField.text.length<1){
                        return[SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"验证码不能为空")];
                    }
                    if(self.type==5){
                        [dicData addEntriesFromDictionary:@{@"mobile":self.phoneField.text,@"password":self.passwordTextField.text,@"code":self.codeTextField.text}];
                        if(codeStr.length>0){
                            [dicData setObject:codeStr forKey:@"invite_code"];
                        }
                    }else{
                        [dicData addEntriesFromDictionary:@{@"mobile":self.phoneField.text,@"newpassword":self.passwordTextField.text,@"captcha":self.codeTextField.text}];
                    }
            
                }
             
 
            }

        }break;
        case 200:{
            [self requestSmsCode];
        }break;
        case 555:{
            self.type=5;
            self.selectType=@"register";
            [self upDataView:5];
        }break;
        case 666:{
            self.type=2;
            self.selectType=@"mobileLogin";
            [self upDataView:2];
        }break;
        case 888:{
            self.type=3;
            self.selectType=@"resetpwd";
            [self upDataView:3];
        }break;
        case 1000:{
            self.changeView=!self.changeView;
            if(self.changeView){
                self.type=2;
                self.selectType=@"mobilelogin";
            }else{
                self.type=1;
                self.selectType=@"codeLogin";
            }
            [self upDataView:self.type];
        }break;
        default:
            break;
    }
    
    if(self.BtnBlick){
        self.BtnBlick(sender.tag, self.type,dicData);
    }
    
}


-(void)upDataView:(NSInteger)type{
    self.loginTip.hidden = YES ;
    self.stackView.hidden=NO;
    self.noticeLabel.hidden=NO;
    self.praBtn.hidden = NO;
    self.gouBtn.hidden = NO ;
    if(type==1){
        self.titleLabel.text=getLanguage(@"您好,");
        self.tipLabel.text=getLanguage(@"欢迎来到旅遇");
        [self.sendBtn setTitle:getLanguage(@"获取短信验证码") forState:UIControlStateNormal];
        [self.sendBtn setBackgroundColor:BaseMainColor forState:UIControlStateNormal];
        self.sendBtn.width = SCREENWIDTH - 15 * 2 ;
        self.sendBtn.height = 50 ;
        [self.sendBtn makeRoundCorner];
        
        self.loginTip.hidden = NO ;
        [self.loginTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(200);
            make.left.mas_equalTo(18);
            make.top.mas_equalTo(self.bgView.mas_bottom).offset(8);
        }];
        
        self.backBtn.hidden=YES;
        self.codeBgView.hidden=NO;
        self.phoneBgView.hidden=YES;
        self.forgetBtn.hidden=YES;
        self.registBtn.hidden=YES;
        
        [self.sendBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.top.mas_equalTo(self.codeBgView.mas_bottom).offset(KAdaptedHeight(45));
            make.height.mas_equalTo( KAdaptedHeight(50));
            
        }];
        
        
    }
    if (type==2){
        self.titleLabel.text=getLanguage(@"您好,");
        self.tipLabel.text=getLanguage(@"欢迎来到旅遇");
        [self.sendBtn setTitle:getLanguage(@"登录") forState:UIControlStateNormal];
        self.backBtn.hidden=YES;
        self.codeBgView.hidden=YES;
        self.phoneBgView.hidden=NO;
        self.forgetBtn.hidden=NO;
        self.registBtn.hidden=NO;
        self.codeView.hidden=YES;
        
        [self.phoneBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(KAdaptedHeight(190));
        }];
        
        [_codeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(KAdaptedHeight(0));
        }];
        [_passwordView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.codeView.mas_bottom).offset(KAdaptedHeight(0));
        }];
        
        
        [self.sendBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.top.mas_equalTo(self.phoneBgView.mas_bottom).offset(KAdaptedHeight(45));
            make.height.mas_equalTo( KAdaptedHeight(50));
            
        }];
        
    }
    
    if (type==3||type==5){
        if(type==3){
            self.titleLabel.text=getLanguage(@"忘记密码");
            self.tipLabel.text=getLanguage(@"请使用手机号验证码找回密码");
            [self.sendBtn setTitle:getLanguage(@"重置密码") forState:UIControlStateNormal];
        }else{
            self.stackView.hidden=YES;
            self.noticeLabel.hidden=YES;
            self.praBtn.hidden=YES;
            self.gouBtn.hidden = YES ;
            self.titleLabel.text=getLanguage(@"注册账号");
            self.tipLabel.text=getLanguage(@"请使用手机号注册");
            [self.sendBtn setTitle:getLanguage(@"立即注册") forState:UIControlStateNormal];
            
        }
        
        self.backBtn.hidden=NO;
        self.codeBgView.hidden=YES;
        self.phoneBgView.hidden=NO;
        self.registBtn.hidden=YES;
        self.forgetBtn.hidden=YES;
        self.codeView.hidden=NO;
        [self.phoneBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(KAdaptedHeight(200));
        }];
        [_codeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(KAdaptedHeight(50));
        }];
        [_passwordView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.codeView.mas_bottom).offset(KAdaptedHeight(20));
        }];
        [self.sendBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.top.mas_equalTo(self.phoneBgView.mas_bottom).offset(KAdaptedHeight(45));
            make.height.mas_equalTo( KAdaptedHeight(50));
            
        }];
    }
    
    
    
    
}

-(void)timerEvent{
    
    [_codeBtn setTitle:[NSString stringWithFormat:@"%ld%@",(long)_count,getLanguage(@"秒")] forState:0];
    _count--;
    if (_count == 0) {
        [_timer invalidate];
        _count = 60;
        _codeBtn.enabled = YES;
        [_codeBtn setTitle:getLanguage(@"重新发送") forState:0];
        [_codeBtn setTitleColor:BaseMainColor forState:UIControlStateNormal];
        
    }
    
}

//获取短信
- (void)requestSmsCode{
    if ([Common isEmptyString:self.phoneField.text]) {
        return [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"请输入电话号码")];
    }
    WeakSelf;
    [NetworkRequest POST:Request_SendSms parmeters:@{@"mobile":[Common isNull:self.phoneField.text],
                     @"event":self.selectType,
                               } success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        wself.count = 60;
        wself.codeBtn.enabled = NO;
        wself.timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
        [wself.codeBtn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:[Common isNull:baseModel.msg]];
    } failture:^(NSError *errors) {
        
    }];
    
    
}

-(UILabel *)loginTip
{
    if (!_loginTip) {
        _loginTip = [UILabel LabelWithFrame:CGRectMake(18, 0, 200, 20) fontSize:12 textColor:HexColorDy(@"999999") textAlient:NSTextAlignmentLeft numberLines:1];
        _loginTip.text = @"未注册的手机号验证后自动创建账户";
        _loginTip.hidden = YES ;
        [self addSubview:_loginTip];
    }
    return _loginTip;
}
-(UIButton *)gouBtn
{
    if (!_gouBtn) {
        _gouBtn = [UIButton racButtonWithTitle:nil BGImage:IMAGE(@"pay_select_ed") frame:CGRectMake(45, 0, 16, 16) fontSize:1 titleColor:nil];
        _gouBtn.bottom = SCREEN_HEIGHT_dy - 32;
    }
    return _gouBtn;
}
-(UIButton *)gouExpandBtn
{
    if (!_gouExpandBtn) {
        _gouExpandBtn = [UIButton racButtonWithTitle:nil BGImage:nil frame:CGRectMake(45, 0, 35, 35) fontSize:1 titleColor:nil];
        @weakify(self);
        [[_gouExpandBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            self.isAgree = !self.isAgree;
            if (self.isAgree) {
                [self->_gouBtn setBackgroundImage:IMAGE(@"pay_select_ed") forState:UIControlStateNormal];
            }else{
                [self->_gouBtn setBackgroundImage:IMAGE(@"pay_select_un") forState:UIControlStateNormal];
            }
        }];
    }
    return _gouExpandBtn;
}
@end
