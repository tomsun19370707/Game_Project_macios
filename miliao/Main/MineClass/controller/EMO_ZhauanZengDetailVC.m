//
//  EMO_ZhauanZengDetailVC.m
//  miliao
//
//  Created by apple on 2020/3/23.
//  Copyright © 2020 miliao. All rights reserved.
//

#import "EMO_ZhauanZengDetailVC.h"

@interface EMO_ZhauanZengDetailVC ()
@property(nonatomic, strong) UITextField *moneyText;//输入的米币
@property(nonatomic, strong) UIImageView *userICon;//头像
@property(nonatomic, strong) UILabel *nickName;//名字
@property(nonatomic, strong) UILabel *mbYuElabel;//米币余额
@property(nonatomic, strong) UIButton *iDButton;//id


@end

@implementation EMO_ZhauanZengDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadBar:YES needBack:YES needBackground:YES];
    self.leftButtonView.image = ImageNamed(@"xiaoxi_back");
    self.titleLabel.text = getLanguage(@"转赠");
    [self topView];
}


- (void)buttonClickMethod {
    if (self.moneyText.text.length==0) {
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:getLanguage(@"金币数量不能为空！")];
        return;
    }
    if ([self.dicdata[@"id"] integerValue]==[[UserManager userInfo].user_id integerValue]) {
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:getLanguage(@"不能赠送给自己！")];
        return;
    }
    __weak __typeof(self)weakSelf = self;
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:getLanguage(@"温馨提示") message:getLanguage(@"是否确认转赠？") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:getLanguage(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf queRenZhuanZengMethod];
    }];
    [alert addAction:action];
    UIAlertAction *cance = [UIAlertAction actionWithTitle:getLanguage(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:cance];
    [self presentViewController:alert animated:YES completion:nil];
    

}

//确认转赠
- (void)queRenZhuanZengMethod {
    

    
    [NetworkRequest POST:Request_GiveUser parmeters:@{@"to_uid":self.dicdata[@"id"],@"price":self.moneyText.text} success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:[Common isNull:basemodel.msg]];
        [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
    } failture:^(NSError *error) {
        
    }];
    
    
    
 
}
- (void)topView {
    //头像
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2.0-30, ZJTopNavH+80, 60, 60)];
    icon.clipsToBounds = YES;
    [icon sd_setImageWithURL:[NSURL URLWithString:self.dicdata[@"avatar"]]];
    icon.layer.cornerRadius = 30;
    [self.view addSubview:icon];
    
    //名字
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, icon.bottom+5, ScreenWidth, 20)];
    name.text = self.dicdata[@"nickname"];
    name.font = FONT_14;
    name.textColor = COLOR_333333;
    name.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:name];
    self.nickName = name;
    
    //ID
    UIButton *IDBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    IDBtn.frame = CGRectMake(0, name.bottom+5, ScreenWidth, 25);
    if ([NSString stringWithFormat:@"%@",self.dicdata[@"uuid"]].length>0) {
        [IDBtn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
        [IDBtn setTitle:[NSString stringWithFormat:@"ID:%@",self.dicdata[@"uuid"]] forState:UIControlStateNormal];
//        [IDBtn setImage:ImageNamed(@"方我的靓号") forState:UIControlStateNormal];
    }else{
        [IDBtn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
        [IDBtn setTitle:[NSString stringWithFormat:@"ID:%@",self.dicdata[@"id"]] forState:UIControlStateNormal];
        [IDBtn setImage:ImageNamed(@"") forState:UIControlStateNormal];
    }
    IDBtn.ba_buttonLayoutType = BAKit_ButtonLayoutTypeNormal;
    IDBtn.ba_padding = 5;
    [self.view addSubview:IDBtn];
    self.iDButton = IDBtn;
    
    //label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, IDBtn.bottom+25, ScreenWidth-30, 20)];
    label.text = getLanguage(@"转赠金币数量");
    label.font = KFontBold(14);
    label.textColor = RGBA(0, 0, 0, 1);
    [self.view addSubview:label];
    
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, label.bottom+20, ScreenWidth-30, 30)];
    textField.backgroundColor = kClearColor;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.font = FONT_16;
    textField.placeholder = getLanguage(@"请输入转赠金额");
    textField.textColor = COLOR_333333;
    textField.layer.borderColor=RGBA(248, 248, 248, 1).CGColor;
    textField.layer.borderWidth=1;
    textField.layer.cornerRadius=KAdaptedHeight(10);
    textField.layer.masksToBounds=YES;
    
    [self.view addSubview:textField];
    self.moneyText = textField;
    
    UIView  *lineView = [UIView new];
    lineView.backgroundColor = MHColorFromHexString(@"#EEEEEE");
    lineView.frame = CGRectMake(10, textField.bottom, ScreenWidth-20, 0.5);
    [self.view addSubview:lineView];
    
    UILabel *yueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, lineView.bottom+5, ScreenWidth-20, 20)];
    yueLabel.font = FONT_12;
    yueLabel.textColor = COLOR_333333;
    [self.view addSubview:yueLabel];
    self.mbYuElabel = yueLabel;
//    self.mbYuElabel.text=[NSString stringWithFormat:@"金币余额:%@",[Common isNull:[UserManager userInfo].money]];
    //确认按钮
    UIButton *quedingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    quedingBtn.frame = CGRectMake(10, yueLabel.bottom+40, ScreenWidth-20, 44);
    quedingBtn.frame = CGRectMake(10, kHeight-KSAFEAREA_BOTTOM_HEIHGHT-KAdaptedHeight(50+35), ScreenWidth-20, 50);
    // gradient
//    CAGradientLayer *gl = [CAGradientLayer layer];
//    gl.frame = CGRectMake(0,0,ScreenWidth-20,50);
//    gl.startPoint = CGPointMake(0.5, 0);
//    gl.endPoint = CGPointMake(0.5, 1);
//    gl.colors = @[(__bridge id)BaseMainColor.CGColor, (__bridge id)RGBA(255, 238, 1, 1).CGColor];
//    gl.locations = @[@(0), @(1.0f)];
//    [quedingBtn.layer addSublayer:gl];
//    quedingBtn.layer.shadowColor = RGBA(183, 171, 65, 0.16).CGColor;
//    quedingBtn.layer.shadowOffset = CGSizeMake(0,1);
//    quedingBtn.layer.shadowOpacity = 1;
//    quedingBtn.layer.shadowRadius = 2;
    
    quedingBtn.layer.cornerRadius = 25;
    quedingBtn.clipsToBounds = YES;
    [quedingBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    [quedingBtn setTitle:getLanguage(@"确认转赠") forState:UIControlStateNormal];
    quedingBtn.titleLabel.font = FONT_14;
//    quedingBtn.backgroundColor = COLOR_FF3F24;
    [self.view addSubview:quedingBtn];
    [quedingBtn addTarget:self action:@selector(buttonClickMethod) forControlEvents:UIControlEventTouchUpInside];
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = quedingBtn.bounds;
    gradientLayer.colors = @[(__bridge id)BaseMainColor.CGColor, (__bridge id)RGBA(255, 238, 1, 1).CGColor];
//    gradientLayer.startPoint = CGPointMake(0, 0);
//    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    gradientLayer.locations = @[@0,@1];
    [quedingBtn.layer addSublayer:gradientLayer];
    [quedingBtn.layer insertSublayer:gradientLayer atIndex:0];
    
}

@end
