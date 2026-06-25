//
//  EMO_AdolescentVC.m
//  miliao
//
//  Created by jkkj on 2023/11/1.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_AdolescentVC.h"
#import "EMO_YouthPassWordVC.h"
@interface EMO_AdolescentVC ()

@end

@implementation EMO_AdolescentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBar:YES needBack:YES needBackground:NO];
    self.view.backgroundColor=[UIColor colorWithHexString:@"#FFFFF8"];
    self.titleLabel.text=getLanguage(@"青少年模式");
    self.titleLabel.font=KFont(18);
    [self createUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:self.senderType?YES:NO animated:animated];
}
-(void)createUI{
    UIImageView *topImg = [[UIImageView alloc] init];
    topImg.image = KGetImage(@"UY_YouthTopImg");
    [self.view addSubview:topImg];
    [topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(108);
        make.height.mas_offset(128);
        make.top.mas_offset(ZJTopNavH+34);
        make.centerX.equalTo(self.view);
    }];
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.textColor = [UIColor colorWithHexString:@"333333"];
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.font = BOLDSYSTEMFONT(18);
    topLabel.numberOfLines = 0;
    topLabel.text = self.isON?@"青少年模式·已开启":@"青少年模式·未开启";
    [self.view addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(17);
        make.right.mas_offset(-17);
        make.top.equalTo(topImg.mas_bottom).offset(20);
    }];
    
    UILabel *centerLabel = [[UILabel alloc] init];
    centerLabel.textColor = [UIColor colorWithHexString:@"333333"];
    centerLabel.backgroundColor = [UIColor clearColor];
    centerLabel.textAlignment = NSTextAlignmentLeft;
    centerLabel.font = KFont(14);
    centerLabel.numberOfLines = 0;
    centerLabel.text =  @"为呵护未成年健康成长，推出青少年模式。该模式下无法使用聊天室功能、无法下单无法充值和打赏。请监护人主动选择，并设置监护密码。\n·时间锁:40分钟，单日使用时长超过上述时间，需要输入密码才能继续使用。\n·禁用时间22:00-6:00该时间段内青少年模式的用户无法使用，需要输入该密码才能继续使用。";
    [self.view addSubview:centerLabel];
    [centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(17);
        make.right.mas_offset(-17);
        make.top.equalTo(topLabel.mas_bottom).offset(20);
    }];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setTitle:self.isON?@"关闭青少年模式":@"开启青少年模式" forState:0];
    [doneBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:0];
    doneBtn.titleLabel.font = BOLDSYSTEMFONT(15);
    [doneBtn addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
    [doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.right.mas_offset(-15);
        make.height.mas_offset(50);
        make.bottom.mas_offset(-([UIDevice vg_safeDistanceBottom]+15));
    }];
    [doneBtn layoutIfNeeded];
    [doneBtn gradientButtonWithSize:CGSizeMake(doneBtn.width, doneBtn.height) colorArray:@[[UIColor colorWithHexString:@"#F7D45B"],[UIColor colorWithHexString:@"#FFEE01"]] percentageArray:@[@0,@1.0] gradientType:GradientFromLeftToRight];
    setViewCorner(doneBtn, doneBtn.height/2);
}

-(void)doneClick{
    EMO_YouthPassWordVC *vc = [[EMO_YouthPassWordVC alloc] init];
    vc.isON = self.isON;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
