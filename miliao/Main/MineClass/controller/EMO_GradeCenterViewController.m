//
//  GradeViewController.m
//  miliao
//
//  Created by aa on 2019/8/5.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "EMO_GradeCenterViewController.h"
#import "EMO_GradeView.h"

@interface EMO_GradeCenterViewController ()

@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UILabel *title1Label;
@property (nonatomic,strong) EMO_GradeView *glodView;
@property (nonatomic,strong) EMO_GradeView *starView;



@end

@implementation EMO_GradeCenterViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    /** 设置statusBar颜色*/
    [DeviceOpinion setBarStyle:Dark];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(248, 248, 248, 1);
    [self loadBar:YES needBack:YES needBackground:YES];
    self.titleLabel.text=getLanguage(@"我的等级");
    self.titleLabel.font=KFont(18);
    
    [self getGradeData];
    [self setupViews];
    
//    [self backBtn];
//    [self title1Label];
    
}
- (void)getGradeData{
    
    
    NSDictionary *glodDic = @{@"current_level":[Common isNull:[UserManager userInfo].contribute_level],@"currnet_num":[Common isNull:[UserManager userInfo].contribute],@"next_num":[Common isNull:[UserManager userInfo].max_contribute_exp],@"title":getLanguage(@"贡献等级"),@"type":@(1)};
    NSDictionary *starDic = @{@"current_level":[Common isNull:[UserManager userInfo].charm_level],@"currnet_num":[Common isNull:[UserManager userInfo].charm],@"next_num":[Common isNull:[UserManager userInfo].max_charm_exp],@"title":getLanguage(@"魅力等级"),@"type":@(2)};
    [self.glodView loadViewWithDic:glodDic];
    [self.starView loadViewWithDic:starDic];
    
    
    
}
-(void)rightButtonClick:(UIButton *)sender{
   
    
    
}

- (void)setupViews
{
    [self.view addSubview:self.glodView];
    [self.view addSubview:self.starView];

    [self.glodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ZJTopNavH+ZJStatusBarH+KAdaptedHeight(15));
        make.left.and.right.equalTo(self.view);
        make.height.mas_offset(142);
    }];
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.glodView.mas_bottom).offset(5);
        make.left.and.right.equalTo(self.view);
        make.height.mas_offset(142);
    }];
}



- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(BackBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(8));
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(40), KAdaptedHeight(40)));
            make.bottom.mas_equalTo(self.view.mas_top).offset(ZJTopNavH+ZJStatusBarH-KAdaptedHeight(0));
            
        }];
    }
    return _backBtn;
}


-(void)BackBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}


- (UILabel *)title1Label{
    if (!_title1Label) {
        _title1Label = [[UILabel alloc] init];
        _title1Label.textColor = RGBA(34, 34, 34, 1);
        _title1Label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
        _title1Label.text=getLanguage(@"我的等级");
        _title1Label.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:_title1Label];
        [_title1Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.backBtn.mas_centerY);
            make.width.mas_equalTo(kWidth/2);
            make.height.mas_equalTo(KAdaptedHeight(40));
            make.centerX.mas_equalTo(0);
        }];
    }
    return _title1Label;
}


-(EMO_GradeView *)glodView
{
    if (!_glodView) {
        _glodView = [[EMO_GradeView alloc] init];
    }
    return _glodView;
}
-(EMO_GradeView *)starView
{
    if (!_starView) {
        _starView = [[EMO_GradeView alloc] init];
    }
    return _starView;
}
@end
