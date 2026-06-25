//
//  EMO_WithdrawalViewController.m
//  miliao
//
//  Created by ZhangShiHao on 2023/6/28.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_WithdrawalViewController.h"
#import "EMO_PaymentView.h"
#import "EMO_RechargeRecordVC.h"//充值记录


@interface EMO_WithdrawalViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) UIView * headViewB;
@property (nonatomic,strong) UILabel * tipLabel;
@property (nonatomic,strong) UITextField * textField;
@property (nonatomic,strong) UIView * topView;
@property (nonatomic,strong) UILabel * moneyLabel;
@property (nonatomic,strong) EMO_PaymentView * payTypeView;
@property (nonatomic,strong) UIButton * payBtn;

Strong NSString *payType;
Strong NSString *money;
@end

@implementation EMO_WithdrawalViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(255, 255, 255, 1);
    [self loadBar:YES needBack:YES needBackground:YES];
    self.barView.backgroundColor=kClearColor;
    self.titleLabel.text=getLanguage(@"提现");
    self.titleLabel.font=KFont(18);
    self.rightTitleLabel.text=getLanguage(@"明细");
    self.rightTitleLabel.textColor=RGBA(0, 0, 0, 1);
    self.rightTitleLabel.font=KFont(14);
    
    [self topView];
    [self moneyLabel];
    
    [self headViewB];
    [self tipLabel];
    [self textField];
    [self payTypeView];
    
    [self payBtn];
  
    [self.view sendSubviewToBack:self.topView];
    
    self.money=[Common isNull:[UserManager userInfo].diamond];
    
}

-(void)rightButtonClick:(UIButton *)sender{
    EMO_RechargeRecordVC *vc=[EMO_RechargeRecordVC new];
    vc.type=2;
    [self.navigationController pushViewController:vc animated:YES];
    
}




-(UIView *)headViewB{
    if (!_headViewB) {
        _headViewB=[[UIView alloc] init];
        _headViewB.backgroundColor=RGBA(255, 255, 255, 1);
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(KAdaptedWidth(15), KAdaptedHeight(20), kWidth/2, KAdaptedHeight(25))];
        label.font=KFontBold(14);
        label.text=getLanguage(@"提现数量");
        label.textColor=RGBA(0,0,0,1);
        label.textAlignment=NSTextAlignmentLeft;
        [_headViewB addSubview:label];
        [self.view addSubview:_headViewB];
        [_headViewB mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.mas_equalTo(self.topView.mas_bottom).offset(KAdaptedHeight(-20));
             make.trailing.leading.mas_equalTo(0);
            make.height.mas_equalTo(KAdaptedHeight(130));

         }];
        setViewCorner(_headViewB, KAdaptedHeight(10));
    }
    return _headViewB;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = [NSString stringWithFormat:@"(%@钻石=1RMB)",[UserManager userInfo].price_to_diamond];
        _tipLabel.textColor = RGBA(51, 51, 51, 1);
        _tipLabel.font=KFontA(12);
        _tipLabel.textAlignment=NSTextAlignmentRight;
        [self.headViewB addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(200), KAdaptedHeight(25)));
            make.top.mas_equalTo(KAdaptedHeight(20));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
        }];
    }
    return _tipLabel;
}

-(UITextField*)textField{
    if (!_textField) {
        _textField =[[UITextField alloc] init];
        _textField.backgroundColor =RGB(255, 255, 255);
        _textField.keyboardType =UIKeyboardTypeNumberPad;
        _textField.layer.cornerRadius=KAdaptedHeight(10);
        _textField.layer.borderColor=RGBA(248, 248, 248, 1).CGColor;
        _textField.layer.borderWidth=1;
        _textField.layer.masksToBounds=YES;
        _textField.delegate=self;
        _textField.placeholder=getLanguage(@"请输入提现数量");
        [self.headViewB addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedHeight(50));
            make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(KAdaptedHeight(10));
        }];
    }
    return _textField;
}




- (EMO_PaymentView *)payTypeView{
    if (!_payTypeView) {
        _payTypeView = [[EMO_PaymentView alloc] init];
        WeakSelf;
        _payTypeView.type=1;
        _payTypeView.payTypeBlock = ^(NSInteger type) {
            if (type==1000) {
//                wself.payType=@"wechat";
                wself.payType=@"0";
            }else if (type==2000){
//                wself.payType=@"alipay";
                wself.payType=@"1";
            }else{
                wself.payType=@"otherPay";
            }
        };
        [self.view addSubview:_payTypeView];
      [_payTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(self.headViewB.mas_bottom).offset(KAdaptedHeight(-20));
          make.trailing.leading.mas_equalTo(0);
         make.height.mas_equalTo(KAdaptedHeight(200));

       }];
    }
    return _payTypeView;
}



- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = RGBA(202, 199, 248, 1);
        [self.view addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.leading.trailing.mas_equalTo(0);
            make.height.mas_equalTo(220);
        }];
        
       UIImageView *_bgImageView = [[UIImageView alloc] init];
        _bgImageView.image=KGetImage(@"zuanIconImg");
        [self.topView addSubview:_bgImageView];
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(120), KAdaptedHeight(120)));
            make.trailing.mas_equalTo(KAdaptedWidth(10));
            make.bottom.mas_equalTo(KAdaptedHeight(-10));
            
        }];
        
        UILabel *label=[[UILabel alloc] init];
        label.font=KFont(13);
        label.text=getLanguage(@"钻石余额");
        label.textColor=RGBA(34,34,4,1);
        label.textAlignment=NSTextAlignmentLeft;
        [_topView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(_topView.mas_top);
            make.bottom.mas_equalTo(_topView.mas_bottom).offset(KAdaptedHeight(-100));
            make.leading.mas_equalTo(KAdaptedWidth(38));
            make.width.mas_equalTo(KAdaptedWidth(120));
            make.height.mas_equalTo(KAdaptedHeight(25));
        }];
        
        
    }
    return _topView;
}


- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.text = [NSString stringWithFormat:@"%@",[UserManager userInfo].diamond];;
        _moneyLabel.textColor = RGBA(91, 61, 32, 1);
        _moneyLabel.font=KFontBold(22);
        [self.topView addSubview:_moneyLabel];
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_topView.mas_bottom).offset(KAdaptedHeight(-50));
            make.leading.mas_equalTo(KAdaptedWidth(38));
            make.width.mas_equalTo(KAdaptedWidth(200));
            make.height.mas_equalTo(KAdaptedHeight(40));
        }];
    }
    return _moneyLabel;
}




- (UIButton *)payBtn{
    if (!_payBtn) {
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       
        _payBtn.frame=CGRectMake(KAdaptedWidth(27.5), kHeight-KAdaptedHeight(36+50)-KSAFEAREA_BOTTOM_HEIHGHT, kWidth-KAdaptedWidth(55), KAdaptedHeight(45));
        
        _payBtn.backgroundColor = BaseMainColor ;
        [_payBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_payBtn makeRoundCorner];
        
            [_payBtn setTitle:getLanguage(@"提现") forState:UIControlStateNormal];

        _payBtn.titleLabel.font=KFont(15);
        _payBtn.tag=500;
        [_payBtn addTarget:self action:@selector(PayBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_payBtn];
    }
    return _payBtn;
}

-(void)PayBtnClick{

    if ([self.textField.text floatValue]<1) {
        return [SVProgressHUD showImage:[UIImage imageNamed:@""] status:getLanguage(@"提现金额必须大于0")];
    }
    if(self.payType.length<1){
        return [SVProgressHUD showImage:[UIImage imageNamed:@""] status:getLanguage(@"请选择提现方式")];
    }
 
    [NetworkRequest POST:Request_ApplyWithdrawal parmeters:@{@"type":self.payType,@"price":self.textField.text} success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:basemodel.msg]];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } failture:^(NSError *error) {
        
    }];
    
    
    
    
    
    
    
}







-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.money floatValue]<=0) {
        [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"暂无提现金额!")];
        return NO;
    }else{
        textField.text=@"";
        return YES;
    }
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *str1=[NSString stringWithFormat:@"%@%@",textField.text,string];
    if ([str1 floatValue] >[self.money floatValue]||str1.length >self.money.length) {
        textField.text=self.money;
        return NO;
    }else{
        BOOL isHaveDian = YES;
        if ([textField.text rangeOfString:@"."].location==NSNotFound) {
            isHaveDian=NO;
        }
        if ([string length]>0){
            unichar single=[string characterAtIndex:0];//当前输入的字符
            if ((single >='0' && single<='9') || single=='.')//数据格式正确
            {//首字母不能为小数点
                if([textField.text length]==0){
                    if(single == '.'){
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                if([textField.text length]==1 && [textField.text isEqualToString:@"0"]){
                    if(single != '.'){
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                if (single=='.'){
                    if(!isHaveDian)//text中还没有小数点
                    {
                        isHaveDian=YES;
                        return YES;
                    }else{
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }else{
                    if (isHaveDian)//存在小数点
                    {                       //判断小数点的位数
                        NSRange ran=[textField.text rangeOfString:@"."];
                        NSInteger tt=range.location-ran.location;
                        if (tt <= 2){
                            return YES;
                        }else{
                            return NO;
                        }
                    }else{
                        return YES;
                    }
                }
                
            }else{//输入的数据格式不正确
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }else{
            return YES;
        }
    }
    
}






@end
