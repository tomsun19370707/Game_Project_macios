//
//  EMO_AdolescentModelView.m
//  miliao
//
//  Created by jkkj on 2023/10/30.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_AdolescentModelView.h"
#import "EMO_AdolescentVC.h"
@interface EMO_AdolescentModelView ()
Strong UIView *rootView;
@end

@implementation EMO_AdolescentModelView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.rootView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
        self.rootView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [[Common AppWindow] addSubview:self.rootView];
        
        UIButton *backGroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backGroundBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        backGroundBtn.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self.rootView addSubview:backGroundBtn];
        
        self.width = kScreenWidth - 35*2;
        self.left = 35;
        self.height = 450;
        self.top = self.rootView.height/2 - self.height/2;
        self.backgroundColor = [UIColor whiteColor];
        [self.rootView addSubview:self];
        setViewCorner(self, 10);
        [self createUI];
    }
    return self;
}

- (void)createUI{
    UIImageView *topImg = [[UIImageView alloc] init];
    topImg.image = KGetImage(@"UY_YouthTopImg");
    [self addSubview:topImg];
    [topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(108);
        make.height.mas_offset(128);
        make.top.mas_offset(34);
        make.centerX.equalTo(self);
    }];
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.textAlignment = NSTextAlignmentLeft;
    topLabel.font = KFont(14);
    topLabel.textColor = UIColor.blackColor;
    topLabel.numberOfLines = 0;
    topLabel.text = @"为呵护未成年人健康成长，本平台特别推出青少年模式，该模式下部分功能无法正常使用，请监护人主动选择并设置监护密码。";
    [self addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
        make.top.equalTo(topImg.mas_bottom).offset(20);
    }];
    
    UIButton *senderYouthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [senderYouthBtn setTitle:@"   进入青少年模式>   " forState:0];
    [senderYouthBtn setTitleColor:[UIColor colorWithHexString:@"#177CFF"] forState:0];
    senderYouthBtn.titleLabel.font = KFont(14);
    [senderYouthBtn addTarget:self action:@selector(senderYouthClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:senderYouthBtn];
    [senderYouthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLabel.mas_bottom).offset(32);
        make.centerX.equalTo(self);
        make.height.mas_offset(44);
    }];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setTitle:getLanguage(@"确定") forState:0];
    [doneBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:0];
    doneBtn.titleLabel.font = BOLDSYSTEMFONT(15);
    [doneBtn addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:doneBtn];
    [doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(senderYouthBtn.mas_bottom).offset(15);
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
        make.height.mas_offset(50);
    }];
    [doneBtn layoutIfNeeded];
    [doneBtn gradientButtonWithSize:CGSizeMake(doneBtn.width, doneBtn.height) colorArray:@[[UIColor colorWithHexString:@"#F7D45B"],[UIColor colorWithHexString:@"#FFEE01"]] percentageArray:@[@0,@1.0] gradientType:GradientFromLeftToRight];
    setViewCorner(doneBtn, doneBtn.height/2);
}

- (void)btnClick{
    [self viewHide];
}

//进入青少年
- (void)senderYouthClick{
    [self viewHide];
    EMO_AdolescentVC *vc = [[EMO_AdolescentVC alloc] init];
    if([Common isEmptyString:UserDefaultsGet(@"APPPassWord")]){
        vc.isON = NO;
    }else{
        vc.isON = YES;
    }
    [[Common getCurrentVC].navigationController pushViewController:vc animated:YES];
}

- (void)doneClick{
    [self viewHide];
}

- (void)viewHide{
    WeakSelf;
    [UIView animateWithDuration:0.25 animations:^{
        wself.rootView.top = kScreenHeight;
    } completion:^(BOOL finished) {
        wself.rootView.backgroundColor = [UIColor clearColor];
    }];
    
    if(self.adolescentBlock){
        self.adolescentBlock();
    }
}

- (void)viewShow{
    WeakSelf;
    [UIView animateWithDuration:0.25 animations:^{
        wself.rootView.top = 0;
    } completion:^(BOOL finished) {
        wself.rootView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    }];
}
@end
