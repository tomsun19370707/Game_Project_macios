//
//  EMO_MyWalletViewController.m
//  miliao
//
//  Created by ZhangShiHao on 2023/6/27.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_MyWalletViewController.h"
#import "EMO_SubgiftViewController.h"//转赠
#import "EMO_RechargeViewController.h"//充值
#import "EMO_WithdrawalViewController.h"//提现
#import "EMO_ZuanRechargeRecordVC.h"//钻石明细
#import "EMO_MyMoneyHeadView.h"


@interface EMO_MyWalletViewController ()

Strong UIImageView *bgImageView;
Strong EMO_MyMoneyHeadView *coinView;
Strong EMO_MyMoneyHeadView *zuanView;

@end

@implementation EMO_MyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(255, 255, 255, 1);
    
    [self loadBar:YES needBack:YES needBackground:YES];
    self.titleLabel.font=KFont(18);
    self.titleLabel.text=getLanguage(@"我的钱包");
    self.barView.backgroundColor=kClearColor;
    [self bgImageView];
    [self coinView];
    [self zuanView];
    [self.view sendSubviewToBack:self.bgImageView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getUserInfoMessage];
}

- (UIImageView*)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image=KGetImage(@"mineHeadBgImg");
        [self.view addSubview:_bgImageView];
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.height.mas_equalTo(ZJTopNavH+ZJStatusBarH+KAdaptedHeight(50));
            
        }];
    }
    return _bgImageView;
}

- (EMO_MyMoneyHeadView *)coinView{
    if (!_coinView) {
        _coinView = [[EMO_MyMoneyHeadView alloc] init];
        _coinView.backgroundColor = [UIColor whiteColor];
        WeakSelf;
        _coinView.type=1;
        _coinView.BtnBlick = ^(NSInteger tag) {
            if (tag==100) {
                EMO_SubgiftViewController *vc = [[EMO_SubgiftViewController alloc] init];
                [wself.navigationController pushViewController:vc animated:NO];
            }else{
                EMO_RechargeViewController *vc=[EMO_RechargeViewController new];
                [wself.navigationController pushViewController:vc animated:YES];
            }
        };
        [self.view addSubview:_coinView];
        [_coinView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ZJTopNavH+ZJStatusBarH+KAdaptedHeight(15));
            make.leading.trailing.mas_equalTo(0);
            make.height.mas_equalTo(KAdaptedHeight(140));
        }];
    }
    return _coinView;
}


- (EMO_MyMoneyHeadView *)zuanView{
    if (!_zuanView) {
        _zuanView = [[EMO_MyMoneyHeadView alloc] init];
        _zuanView.backgroundColor = [UIColor whiteColor];
        WeakSelf;
        _zuanView.type=2;
        _zuanView.BtnBlick = ^(NSInteger tag) {
            if (tag==100) {
                EMO_ZuanRechargeRecordVC *vc = [[EMO_ZuanRechargeRecordVC alloc] init];
                [wself.navigationController pushViewController:vc animated:NO];
            }else{
                EMO_WithdrawalViewController * vc = [EMO_WithdrawalViewController new];
                [wself.navigationController pushViewController:vc animated:YES];
            }
            
        };
        [self.view addSubview:_zuanView];
        [_zuanView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.coinView.mas_bottom).offset(KAdaptedHeight(15));
            make.trailing.mas_equalTo(self.coinView.mas_trailing);
            make.leading.mas_equalTo(self.coinView.mas_leading);
            make.height.mas_equalTo(self.coinView.mas_height);
        }];
    }
    return _zuanView;
}

#pragma mark 获取用户数据
- (void)getUserInfoMessage{
    WeakSelf;
    [NetworkRequest POST:Request_UserInfo parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:baseModel.data];
        if([dic.allKeys containsObject:@"avatar_frame_image"]){
            [dic setObject:@(YES) forKey:@"is_zb"];
        }else{
            [dic setObject:@(NO) forKey:@"is_zb"];
        }
        [UserManager saveUserInfo:dic];
        wself.coinView.type =1;
        wself.zuanView.type =2;
    } failture:^(NSError *error) {
        
    }];
}

@end
