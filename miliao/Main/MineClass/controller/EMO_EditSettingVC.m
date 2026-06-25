//
//  EMO_EditSettingVC.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/5.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_EditSettingVC.h"

@interface EMO_EditSettingVC ()
Strong UIView *whiteBgView;
@property(nonatomic, strong) UILabel *phoneLab;
@property(nonatomic, strong) UILabel *codeLab;
@property(nonatomic, strong) UITextField *myPhoneText;
Strong UIView *firstLine;
@property(nonatomic, strong) UITextField *myVcodeText;
Strong UIView *secLine;
@property(nonatomic, strong) UIButton *codeBTN;
@property (nonatomic, strong) NSTimer   *timer;
@property (nonatomic, assign) int        waiTime;

@property(nonatomic, strong) UIButton *jiebangBtn;

@end

@implementation EMO_EditSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(248, 248, 248, 1);
    [self loadBar:YES needBack:YES needBackground:YES];
    self.leftButtonView.image = ImageNamed(@"xiaoxi_back");
    
    [self whiteBgView];
    [self phoneLab];
    [self myPhoneText];
    [self firstLine];
    
    [self codeLab];
    [self myVcodeText];
    [self codeBTN];
    [self secLine];
  
    [self jiebangBtn];

    self.codeBTN.hidden=YES;

    if(self.index==1||self.index==2){
        self.titleLabel.text = getLanguage(@"提现设置");
        if(self.index==1){
            self.phoneLab.text =getLanguage(@"支付宝账户");
            self.codeLab.text = getLanguage(@"收款姓名");
            self.myPhoneText.text=[Common isNull:[UserManager userInfo].withdrawal_alipay_account];
            self.myVcodeText.text=[Common isNull:[UserManager userInfo].withdrawal_alipay_name];
        }else if (self.index==2){
            self.phoneLab.text =getLanguage(@"微信号");
            self.codeLab.text = getLanguage(@"微信昵称");
            self.myPhoneText.text=[Common isNull:[UserManager userInfo].withdrawal_wechat_account];
            self.myVcodeText.text=[Common isNull:[UserManager userInfo].withdrawal_wechat_name];
        }
        self.myPhoneText.placeholder = getLanguage(@"请输入");
        self.myVcodeText.placeholder = getLanguage(@"请输入");
    }else if (self.index==3){
        self.titleLabel.text = getLanguage(@"绑定邀请码");
        self.phoneLab.text=@"";
        self.myPhoneText.placeholder = getLanguage(@"请输入邀请码");
        self.myPhoneText.textAlignment=NSTextAlignmentLeft;
        [self.whiteBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(KAdaptedHeight(60));
        }];
        [self.myPhoneText mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedHeight(-15));
            make.top.mas_equalTo(self.phoneLab.mas_top);
            make.height.mas_equalTo(self.phoneLab.mas_height);
            
        }];
        self.firstLine.hidden=YES;
        self.codeLab.hidden=YES;
        self.myVcodeText.hidden=YES;
        self.codeBTN.hidden=YES;
        self.secLine.hidden=YES;
        
    }else{
        if (self.index==4||self.index==7){
            self.titleLabel.text = getLanguage(@"设置密码");
        }else if (self.index==5||self.index==6||self.index==8){
            self.titleLabel.text = getLanguage(@"绑定手机号");
        }
        self.codeLab.text = getLanguage(@"获取验证码");
        self.myVcodeText.placeholder=getLanguage(@"请输入验证码");

        if(self.index==4||self.index==5){
//            if(self.index==4){
//                self.myPhoneText.text=[UserManager userInfo].mobile;
//            }            
            self.myVcodeText.textAlignment=NSTextAlignmentLeft;
            self.codeBTN.hidden=NO;
            self.firstLine.hidden=YES;
            self.secLine.hidden=YES;
            [self.whiteBgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(KAdaptedHeight(60));
            }];
            [self.phoneLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(KAdaptedHeight(0));
            }];
            [self.codeLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.phoneLab.mas_bottom).offset(KAdaptedHeight(10));
            }];
        }else{
            if(self.index==6||self.index==8){
                self.myVcodeText.textAlignment=NSTextAlignmentLeft;
                self.codeBTN.hidden=NO;
                self.phoneLab.text = getLanguage(@"绑定手机号");
                self.codeLab.text = getLanguage(@"获取验证码");
                self.myPhoneText.placeholder = getLanguage(@"请输入新的手机号");
                self.myVcodeText.placeholder = getLanguage(@"请输入验证码");
            }else if (self.index==7){
                self.phoneLab.text = getLanguage(@"新密码");
                self.codeLab.text = getLanguage(@"确认密码");
                self.myPhoneText.placeholder = getLanguage(@"请输入新密码");
                self.myVcodeText.placeholder = getLanguage(@"请确认密码");
            }
           
        }
       
    }


    
    
    
    
    
    
    


   
  
    
}

- (UIView *)whiteBgView{
    if (!_whiteBgView) {
        _whiteBgView = [[UIView alloc] init];
        _whiteBgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_whiteBgView];
        [_whiteBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(0);
            make.top.mas_equalTo(ZJTopNavH+ZJStatusBarH+KAdaptedHeight(10));
            make.height.mas_equalTo(KAdaptedHeight(120));
            
        }];
    }
    return _whiteBgView;
}

- (UILabel *)phoneLab{
    if (!_phoneLab) {
        _phoneLab = [UILabel new];
        _phoneLab.text = @"真实姓名:";
        _phoneLab.textColor = COLOR_333333;
        _phoneLab.font = KFont(15);
        [self.whiteBgView addSubview:_phoneLab];
        [_phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(20));
            make.top.mas_equalTo(KAdaptedHeight(10));
            make.width.mas_equalTo(KAdaptedWidth(90));
            make.height.mas_equalTo(KAdaptedHeight(30));
        }];
    }
    return _phoneLab;
}

-(UITextField*)myPhoneText{
    if (!_myPhoneText) {
        _myPhoneText = [[UITextField alloc] init];
        _myPhoneText.placeholder = getLanguage(@"请输入");
        _myPhoneText.font = KFont(15);
        _myPhoneText.textColor = COLOR_666666;
        _myPhoneText.textAlignment=NSTextAlignmentRight;
        [self.whiteBgView addSubview:_myPhoneText];
        [_myPhoneText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.phoneLab.mas_trailing).offset(KAdaptedWidth(5));
            make.trailing.mas_equalTo(KAdaptedHeight(-15));
            make.top.mas_equalTo(self.phoneLab.mas_top);
            make.height.mas_equalTo(self.phoneLab.mas_height);
            
        }];
    }
    return _myPhoneText;
}

- (UIView *)firstLine{
    if (!_firstLine) {
        _firstLine = [UIView new];
        _firstLine.backgroundColor = MHColorFromHexString(@"#EEEEEE");
        [self.whiteBgView addSubview:_firstLine];
        [_firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(self.phoneLab.mas_leading);
            make.top.mas_equalTo(self.myPhoneText.mas_bottom).offset(KAdaptedHeight(10));
            make.trailing.mas_equalTo(self.myPhoneText.mas_trailing);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _firstLine;
}


- (UILabel *)codeLab{
    if (!_codeLab) {
        _codeLab = [UILabel new];
        _codeLab.text = @"身份证号:";
        _codeLab.textColor = COLOR_333333;
        _codeLab.font = KFont(15);
        [self.whiteBgView addSubview:_codeLab];
        [_codeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(20));
            make.width.mas_equalTo(KAdaptedWidth(90));
            make.height.mas_equalTo(KAdaptedHeight(30));
            make.top.mas_equalTo(self.phoneLab.mas_bottom).offset(KAdaptedHeight(40));
        }];
    }
    return _codeLab;
}

-(UITextField*)myVcodeText{
    if (!_myVcodeText) {
        _myVcodeText = [[UITextField alloc] init];
        _myVcodeText.placeholder = getLanguage(@"请输入");
        _myVcodeText.font = KFont(15);
        _myVcodeText.textColor = COLOR_666666;
        _myVcodeText.textAlignment=NSTextAlignmentRight;
        [self.whiteBgView addSubview:_myVcodeText];
        [_myVcodeText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.codeLab.mas_trailing).offset(KAdaptedWidth(0));
            make.trailing.mas_equalTo(KAdaptedHeight(-15));
            make.top.mas_equalTo(self.codeLab.mas_top);
            make.height.mas_equalTo(KAdaptedHeight(30));
            
        }];
    }
    return _myVcodeText;
}


- (UIButton *)codeBTN{
    if (!_codeBTN) {
        _codeBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_codeBTN setTitle:getLanguage(@"获取验证码") forState:UIControlStateNormal];
        [_codeBTN setTitleColor:BaseMainColor forState:UIControlStateNormal];
        _codeBTN.titleLabel.font=KFontA(16);
        [_codeBTN addTarget:self action:@selector(requestSmsCode) forControlEvents:UIControlEventTouchUpInside];
        [self.whiteBgView addSubview:_codeBTN];
        [_codeBTN mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(100);
            make.trailing.mas_equalTo(KAdaptedHeight(-15));
            make.top.mas_equalTo(self.codeLab.mas_top);
            make.height.mas_equalTo(KAdaptedHeight(30));
            
        }];
    }
    return _codeBTN;
}




- (UIView *)secLine{
    if (!_secLine) {
        _secLine = [UIView new];
        _secLine.backgroundColor = MHColorFromHexString(@"#EEEEEE");
        [self.whiteBgView addSubview:_secLine];
        [_secLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.codeLab.mas_leading);
            make.top.mas_equalTo(self.codeLab.mas_bottom).offset(KAdaptedHeight(10));
            make.trailing.mas_equalTo(self.myVcodeText.mas_trailing);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _secLine;
}







- (UIButton *)jiebangBtn{
    if (!_jiebangBtn) {
        _jiebangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0,0,kWidth-KAdaptedWidth(30),KAdaptedHeight(45));
        gl.startPoint = CGPointMake(0.5, 0);
        gl.endPoint = CGPointMake(0.5, 1);
        gl.colors = @[(__bridge id)BaseMainColor.CGColor,(__bridge id)RGBA(255, 238, 1, 1).CGColor];
        gl.locations = @[@(0.0),@(1.0f)];

        [_jiebangBtn.layer addSublayer:gl];
        _jiebangBtn.layer.cornerRadius = 22.5;
        _jiebangBtn.layer.masksToBounds=YES;
        [_jiebangBtn setTitle:getLanguage(@"确认") forState:UIControlStateNormal];
        [_jiebangBtn setTitleColor:RGBA(34, 34, 34, 1) forState:UIControlStateNormal];
        _jiebangBtn.titleLabel.font=KFont(15);
        [self.view addSubview:_jiebangBtn];
        [_jiebangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedWidth(45));
            make.bottom.mas_equalTo(-KAdaptedHeight(35)-KSAFEAREA_BOTTOM_HEIHGHT);
            
            
        }];
        __weak __typeof(self)weakSelf = self;
        [_jiebangBtn buttonAddTaget:^(UIButton *btn) {
            [weakSelf jieBangMethod];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _jiebangBtn;
}



//获取短信
- (void)requestSmsCode{
    if ([Common isEmptyString:self.myPhoneText.text]) {
        return [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"请输入电话号码")];
    }
    NSDictionary *dic=[NSDictionary dictionary];
    if(self.index==6){//注册时绑定手机号
        dic=@{@"mobile":self.myPhoneText.text,@"event":@"bindmobile"};
    }else if(self.index==5){//修改绑定的手机号时,旧手机获取验证码
        dic=@{@"mobile":self.myPhoneText.text,@"event":@"old_changemobile"};
    }else if(self.index==8){//修改绑定的手机号
        dic=@{@"mobile":self.myPhoneText.text,@"event":@"changemobile"};
    }else if(self.index==4){//修改密码
        dic=@{@"mobile":self.myPhoneText.text,@"event":@"resetpwd"};
    }
    
    WeakSelf;
    [NetworkRequest POST:Request_SendSms parmeters:dic success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        wself.waiTime = 60;
        wself.codeBTN.enabled = NO;
        wself.timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
        [wself.codeBTN setTitleColor:BaseMainColor forState:UIControlStateNormal];
        [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:baseModel.msg]];
    } failture:^(NSError *errors) {

    }];

    
}

-(void)timerEvent{
    
    [self.codeBTN setTitle:[NSString stringWithFormat:@"%ld%@",(long)self.waiTime,getLanguage(@"秒")] forState:0];
    self.waiTime--;
    if (self.waiTime == 0) {
        [self.timer invalidate];
        self.waiTime = 60;
        self.codeBTN.enabled = YES;
        [self.codeBTN setTitle:getLanguage(@"重新发送") forState:0];
        [self.codeBTN setTitleColor:BaseMainColor forState:UIControlStateNormal];
        
    }
    
}

//认证
- (void)jieBangMethod {
//    [SVProgressHUD showImage:KGetImage(@"") status:[NSString stringWithFormat:@"%ld",self.index]];

    NSString *urlStr=[NSString string];
    NSDictionary *dic=[NSDictionary dictionary];
    if(self.index==1){ //提现-支付宝
        if(self.myPhoneText.text.length<1){
            [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"支付宝账户不能为空")];
            return;
        }
        if(self.myVcodeText.text.length<1){
            [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"收款姓名不能为空")];
            return;
        }
        urlStr=Request_ChangeUserInfo;
        dic=@{@"withdrawal_alipay_account":self.myPhoneText.text,@"withdrawal_alipay_name":self.myVcodeText.text};
    }else if (self.index==2){//提现-微信
        if(self.myPhoneText.text.length<1){
            [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"微信号不能为空")];
            return;
        }
        if(self.myVcodeText.text.length<1){
            [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"微信昵称不能为空")];
            return;
        }
        urlStr=Request_ChangeUserInfo;
        dic=@{@"withdrawal_wechat_account":self.myPhoneText.text,@"withdrawal_wechat_name":self.myVcodeText.text};
    }else if (self.index==3){//邀请码
        if(self.myPhoneText.text.length<1){
            [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"邀请码不能为空")];
            return;
        }
        urlStr=Request_BindingInviteCode;
        dic=@{@"invite_code":self.myPhoneText.text};
    }else if (self.index==4||self.index==5){
    //4.设置密码-获取验证码;;5.修改绑定手机号-获取验证码
        if(self.myVcodeText.text.length<1){
            [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"验证码不能为空")];
            return;
        }
        EMO_EditSettingVC *vc=[EMO_EditSettingVC new];
        if(self.index==4){
            vc.index=7;//设置密码
        }else{
            vc.index=8;//绑定手机号
        }
        vc.codeStr=self.myVcodeText.text;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }else if (self.index==6||self.index==8){//绑定手机号
        if(self.myPhoneText.text.length<1){
            [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"手机号不能为空")];
            return;
        }
        if(self.myVcodeText.text.length<1){
            [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"验证码不能为空")];
            return;
        }
        if (self.index==6){
            urlStr=Request_BimgPhone;
            dic=@{@"mobile":self.myPhoneText.text,@"captcha":self.myVcodeText.text};
        }else{
            urlStr=Request_changePhone;
            dic=@{@"mobile":self.myPhoneText.text,@"captcha":self.myVcodeText.text,@"old_mobile":[UserManager userInfo].mobile,@"old_captcha":self.codeStr};
        }
    }else if (self.index==7){//设置密码
        if(self.myPhoneText.text.length<1){
            [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"密码不能为空")];
            return;
        }
        if(![self.myVcodeText.text isEqualToString:self.myPhoneText.text]){
            [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"两次密码输入不一致")];
            return;
        }
        urlStr=Request_changePassword;
        dic=@{@"mobile":[UserManager userInfo].mobile,@"newpassword":self.myPhoneText.text,@"captcha":self.codeStr};
    }
  
        
    [NetworkRequest POST:urlStr parmeters:dic success:^(id responObject) {
        
        if (self.index==6){//绑定手机号
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSucessNotification object:nil];
        }
        if (self.index==8||self.index==1||self.index==2){
            //修改绑定手机号 
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failture:^(NSError *error) {
        
    }];
        
    
    
    
    
    
    
    
    
}






@end
