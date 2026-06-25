//
//  EMO_OnLineChatViewController.m
//  miliao
//
//  Created by ZhangShiHao on 2023/8/2.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_OnLineChatViewController.h"

@interface EMO_OnLineChatViewController ()
@property(nonatomic,strong) UIView * navView;
@property(nonatomic,strong) UILabel * titleLabel;
@property(nonatomic,strong) UIButton * backBtn;


@end



@implementation EMO_OnLineChatViewController

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO];
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navView];
    [self titleLabel];
    [self backBtn];
    
    
}


- (UIView *)navView{
    if (!_navView) {
        _navView = [[UIView alloc] init];
        _navView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_navView];
        [_navView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(0);
            make.height.mas_equalTo(ZJTopNavH+ZJStatusBarH);
            
        }];
    }
    return _navView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"在线客服";
        _titleLabel.textAlignment=NSTextAlignmentCenter;
        _titleLabel.textColor = kBlackColor;
        [self.navView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(KAdaptedHeight(0));
            make.top.mas_equalTo(KAdaptedHeight(10));
            make.width.mas_equalTo(kWidth/2);
            make.centerX.mas_equalTo(0);
            
        }];
    }
    return _titleLabel;
}


- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        [self.navView addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(30), KAdaptedHeight(50)));
        }];
    }
    return _backBtn;
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
