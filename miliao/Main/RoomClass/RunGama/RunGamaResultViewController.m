//
//  RunGamaResultViewController.m
//  miliao
//
//  Created by wzd on 2026-04-19.
//  Copyright © 2026 EMO. All rights reserved.
//

#import "RunGamaResultViewController.h"

@interface RunGamaResultViewController ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *balanceLabel;
@end

@implementation RunGamaResultViewController
-(void)sureClick{
    [self.view endEditing:YES];
    
}
- (instancetype)initWithInfoDic:(NSArray *)infoDic{
    if (self = [super init]) {
        _infoDic=infoDic;
        self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self addSubView];
    }
    return self;
}
-(void)addSubView{
    UIControl *control =[[UIControl alloc]initWithFrame:self.view.bounds];
    [control addTarget:self action:@selector(closeVc) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:control];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    UIImageView *contentImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"恭喜获得"]];
    contentImageView.userInteractionEnabled=YES;
    [self.contentView addSubview:contentImageView];
    [contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(-10);
        make.height.mas_equalTo(contentImageView.mas_width).multipliedBy(690.0/712.0);
    }];
    UIImageView *leftBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.infoDic.count>0?@"礼物框框":@"元宝"]];
    leftBgImageView.contentMode=UIViewContentModeScaleAspectFill;
    [contentImageView addSubview:leftBgImageView];
    [leftBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(contentImageView.mas_centerY).offset(5);
        make.width.height.mas_equalTo(80);
        make.centerX.mas_equalTo(contentImageView.mas_centerX).offset(-50);
    }];
    
    UIImageView *rightBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.infoDic.count>1?@"礼物框框":@"元宝"]];
    rightBgImageView.contentMode=UIViewContentModeScaleAspectFill;
    [contentImageView addSubview:rightBgImageView];
    [rightBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(contentImageView.mas_centerY).offset(5);
        make.width.height.mas_equalTo(80);
        make.centerX.mas_equalTo(contentImageView.mas_centerX).offset(50);
    }];
    
    if (self.infoDic.count>0) {
        UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self getInconName:[NSString stringWithFormat:@"%@",[self.infoDic[0] valueForKey:@"winner_name"]]]]];
        leftImageView.contentMode=UIViewContentModeScaleAspectFit;
        [leftBgImageView addSubview:leftImageView];
        [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(leftBgImageView);
            make.width.height.mas_equalTo(50);
        }];
    }
    if (self.infoDic.count>1) {
        UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self getInconName:[NSString stringWithFormat:@"%@",[self.infoDic[1] valueForKey:@"winner_name"]]]]];
        rightImageView.contentMode=UIViewContentModeScaleAspectFit;
        [rightBgImageView addSubview:rightImageView];
        [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(rightBgImageView);
            make.width.height.mas_equalTo(50);
        }];
    }
    
  
    UIButton *closeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton addTarget:self action:@selector(closeVc) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"开心收下"] forState:UIControlStateNormal];
    [contentImageView addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-40);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(160);
        make.centerX.mas_equalTo(0);
    }];
  
}
-(void)closeVc{
    [self dismissViewControllerAnimated:NO completion:^{
        if(self.cancel){
            self.cancel();
        }
    }];
}
-(UIView *)contentView{
    if(!_contentView){
        _contentView=[[UIView alloc] initWithFrame:CGRectZero];
    }
    return _contentView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.fd_prefersNavigationBarHidden=YES;
    
}
-(NSString *)getInconName:(NSString *)name{
    if ([name containsString:@"猪"]) {
        return @"猪";
    }else if ([name containsString:@"狗"]) {
        return @"狗狗";
    }else if ([name containsString:@"虎"]) {
        return @"老虎";
    }else if ([name containsString:@"龟"]) {
        return @"乌龟";
    }else if ([name containsString:@"兔"]) {
        return @"兔子";
    }else{
        return @"兔子";
    }
}
@end
