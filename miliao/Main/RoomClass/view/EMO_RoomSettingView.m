//
//  EMO_RoomSettingView.m
//  miliao
//
//  Created by 张世浩 on 2022/10/21.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_RoomSettingView.h"
#import "EMO_BtnView.h"
#import "EMO_RoomSetViewController.h"
#import "EMO_RewardListViewController.h"//打赏清单
#import "EMO_OperationlogViewController.h"//操作日志
#import "EMO_RoomManagerView.h"//房间管理
@interface EMO_RoomSettingView()
Strong NSMutableArray *btnArray;
Strong UIView  *bgView;

Strong UIImageView *bgImgView;

Strong UIImageView *settingImgView;
Strong UILabel *settimgLabel;
Strong UIButton *settingBtn;

Strong UIImageView *administratorsImgView;
Strong UILabel *administratorsLabel;
Strong UIButton *administratorsBtn;

Strong UIImageView *cleanMsgImgView;
Strong UILabel *cleanMsgLabel;
Strong UIButton *cleanMsgBtn;

Strong UIImageView *cleanMeiLiImgView;
Strong UILabel *cleanMeiLiLabel;
Strong UIButton *cleanMeiLiBtn;

Strong EMO_RoomManagerView *roomManagerView;

Strong NSMutableArray *dataArr;

@end


@implementation EMO_RoomSettingView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.btnArray = [[NSMutableArray alloc] init];
        self.isPlay = YES;
        [self initView];
        self.backgroundColor=[UIColor clearColor];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

- (void)singleTapGesture:(UITapGestureRecognizer *)tap{
    [self removeFromSuperview];
}

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
-(void)initView{
    
    [self bgView];
    [self bgImgView];
    
//    [self settingImgView];
//    [self settimgLabel];
//    [self settingBtn];
//
//    [self administratorsImgView];
//    [self administratorsLabel];
//    [self administratorsBtn];
//
//    [self cleanMsgImgView];
//    [self cleanMsgLabel];
//    [self cleanMsgBtn];
//
//    [self cleanMeiLiImgView];
//    [self cleanMeiLiLabel];
//    [self cleanMeiLiBtn];
    

    [self showSetting];
    
}

-(void)setType:(NSString *)type{
    _type=type;
    
}

-(void)setAllCloseMicrophone:(BOOL)allCloseMicrophone{
    _allCloseMicrophone=allCloseMicrophone;
    for (EMO_BtnView *view in self.subviews) {
        if([view isKindOfClass:[EMO_BtnView class]]){
            if(view.ClickBtn.tag==107){
                if(allCloseMicrophone){
                    view.iconImgView.image=KGetImage(@"U_openMaikImg");
                    view.nameLabel.text=@"全员开麦";
                }else{
                    view.iconImgView.image=KGetImage(@"RSCloseMaiImg");
                    view.nameLabel.text=@"全员禁麦";
                }
            }
        }
    }
}



-(void)showSetting{
    NSInteger height=300;
    if([[MLRoomInformationModel currentAccount].user_type integerValue]==1){
        self.dataArr=[NSMutableArray arrayWithArray:@[
                      @{@"name":getLanguage(@"房间设置"),@"img":@"RSSetImg"},
                      @{@"name":getLanguage(@"房间管理"),@"img":@"RSGuanLiImg"},
                      @{@"name":getLanguage(@"静音"),@"img":@"UY_RoomPlay"},
                      @{@"name":getLanguage(@"清空消息"),@"img":@"RSDelMsgImg"},
                      @{@"name":getLanguage(@"清空魅力值"),@"img":@"RSDelMeiLiImg"},
                      @{@"name":getLanguage(@"打赏清单"),@"img":@"RSDaShangImg"},
                      @{@"name":getLanguage(@"操作日志"),@"img":@"RSLogImg"},
                      @{@"name":getLanguage(@"全员禁麦"),@"img":@"RSCloseMaiImg"},
                      @{@"name":getLanguage(@"倒计时"),@"img":@"RSCountdownImg"},]];
        
    }else{
        height=120;
        self.dataArr=[NSMutableArray arrayWithArray:@[@{@"name":getLanguage(@"清空消息"),@"img":@"RSDelMsgImg"},@{@"name":getLanguage(@"清空魅力值"),@"img":@"RSDelMeiLiImg"},@{@"name":getLanguage(@"打赏清单"),@"img":@"RSDaShangImg"},@{@"name":getLanguage(@"操作日志"),@"img":@"RSLogImg"}]];
    }
    
    //每个Item宽高
    CGFloat W = KAdaptedWidth(70);
    CGFloat H = KAdaptedHeight(75);
    //每行列数
    NSInteger rank = 4;
    //每列间距
    CGFloat rankMargin = 30;
    //每行间距
    CGFloat rowMargin = 15;
    //Item索引 ->根据需求改变索引
    NSUInteger index = self.dataArr.count;
    
    for (int i = 0 ; i< index; i++) {
        //Item X轴
        CGFloat X = (i % rank) * (W + rankMargin);
        //Item Y轴
        NSUInteger Y = (i / rank) * (H +rowMargin);
        //Item top
        CGFloat top =kHeight-height;
        EMO_BtnView *  gamrBtn = [[EMO_BtnView alloc] init];
        gamrBtn.frame = CGRectMake(X, Y+top, W, H);
        gamrBtn.iconImgView.image=KGetImage(self.dataArr[i][@"img"]);
        gamrBtn.nameLabel.text=self.dataArr[i][@"name"];
        if ([[MLRoomInformationModel currentAccount].user_type integerValue] == 1) {
            gamrBtn.ClickBtn.tag=100+i;
        }else{
            gamrBtn.ClickBtn.tag=103+i;
        }
        WeakSelf;
        gamrBtn.BtnBlock = ^(NSInteger tag) {
            [wself SettingBtnClick:tag];
        };
        [self addSubview:gamrBtn];
        [self.btnArray addObject:gamrBtn];
    }
//    if ([[MLRoomInformationModel currentAccount].user_type integerValue] == 2) {
//        self.settingImgView.hidden=YES;
//        self.settimgLabel.hidden=YES;
//        self.settingBtn.hidden=YES;
//        self.administratorsImgView.hidden=YES;
//        self.administratorsLabel.hidden=YES;
//        self.administratorsBtn.hidden=YES;
//
//        [_cleanMsgImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.leading.mas_equalTo(KAdaptedWidth(23));
//            make.width.height.mas_equalTo(KAdaptedWidth(55));
//            make.top.mas_equalTo(self.bgImgView.mas_top).offset(KAdaptedHeight(50));
//        }];
//        [_cleanMsgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(self.cleanMsgImgView.mas_centerX);
//            make.width.mas_equalTo(kWidth/4);
//            make.height.mas_equalTo(30);
//            make.top.mas_equalTo(self.cleanMsgImgView.mas_bottom).offset(KAdaptedHeight(15));
//        }];
//    }
}


-(void)SettingBtnClick:(NSInteger)sender{

//    if(sender==100){
//        EMO_RoomSetViewController *vc=[EMO_RoomSetViewController new];
//        [[Common getCurrentVC].navigationController pushViewController:vc animated:YES];
//    }else if (sender==101){
//
//        [[Common getCurrentVC].view addSubview:self.roomManagerView];
//        [self.roomManagerView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.bottom.mas_equalTo(0);
//                make.leading.trailing.mas_equalTo(0);
//                make.top.mas_equalTo(0);
//        }];
//        [self removeFromSuperview];
//    }else if (sender==102){
//        [SVProgressHUD showImage:KGetImage(@"") status:@"清空消息"];
//
//    }else if (sender==103){
//        [SVProgressHUD showImage:KGetImage(@"") status:@"清空魅力值"];
//    }else if (sender==104){
//        EMO_RewardListViewController *vc=[EMO_RewardListViewController new];
//        [[Common getCurrentVC].navigationController pushViewController:vc animated:YES];
//    }else if (sender==105){
//        EMO_OperationlogViewController *vc=[EMO_OperationlogViewController new];
//        [[Common getCurrentVC].navigationController pushViewController:vc animated:YES];
//    }else if (sender==106){
//        [SVProgressHUD showImage:KGetImage(@"") status:@"全员禁麦"];
//    }else if (sender==107){
//        [SVProgressHUD showImage:KGetImage(@"") status:@"倒计时"];
//    }
//
    if(sender == 102){
        //静音
        self.isPlay = !self.isPlay;
        if ([[MLRoomInformationModel currentAccount].user_type integerValue] == 1) {
            //房主
            EMO_BtnView *gamrBtn = self.btnArray[sender-100];
            if(self.isPlay){
                gamrBtn.iconImgView.image = KGetImage(@"UY_RoomPlay");
            }else{
                gamrBtn.iconImgView.image = KGetImage(@"UY_RoomPlayS");
            }
        }
    }
    
    if(sender==100||sender==101||sender==104||sender==105||sender==107){
        [self removeFromSuperview];
    }
    
    if(self.BtnClick){
        self.BtnClick(sender);
    }
}


- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor clearColor];
        _bgView.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
        [self addGestureRecognizer:singleTap];
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(0);
        }];
    }
    return _bgView;
}


- (UIImageView*)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
//        _bgImgView.image=KGetImage(@"roomSettingBgimg");
        _bgImgView.backgroundColor=RGBA(255, 255, 255, 0.95);
        [self addSubview:_bgImgView];
        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            if([[MLRoomInformationModel currentAccount].user_type integerValue]==1){
                make.height.mas_equalTo(KAdaptedHeight(300));
            }else{
                make.height.mas_equalTo(KAdaptedHeight(120));
            }
            make.bottom.mas_equalTo(KAdaptedHeight(15));
        }];
        setViewCorner(_bgImgView, KAdaptedHeight(15));
    }
    return _bgImgView;
}


- (UIImageView*)settingImgView{
    if (!_settingImgView) {
        _settingImgView = [[UIImageView alloc] init];
        _settingImgView.image=KGetImage(@"roomSettingImg");
        [self addSubview:_settingImgView];
        [_settingImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(23));
//            make.centerX.mas_equalTo(self.mas_leading).offset(KAdaptedWidth(kWidth/8-KAdaptedWidth(13)));
            make.width.height.mas_equalTo(KAdaptedWidth(55));
//            make.top.mas_equalTo(KAdaptedHeight(50));
            make.top.mas_equalTo(self.bgImgView.mas_top).offset(KAdaptedHeight(50));
        }];
    }
    return _settingImgView;
}

- (UILabel *)settimgLabel{
    if (!_settimgLabel) {
        _settimgLabel = [[UILabel alloc] init];
        _settimgLabel.text = getLanguage(@"房间设置");
        _settimgLabel.textColor = RGBA(204, 204, 204, 1);
        _settimgLabel.font=KFont(13);
        _settimgLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_settimgLabel];
        [_settimgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.settingImgView.mas_centerX);
            make.width.mas_equalTo(kWidth/4);
            make.height.mas_equalTo(30);
            make.top.mas_equalTo(self.settingImgView.mas_bottom).offset(KAdaptedHeight(15));
            
            
        }];
    }
    return _settimgLabel;
}


- (UIButton *)settingBtn{
    if (!_settingBtn) {
        _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _settingBtn.tag=100;
        [self addSubview:_settingBtn];
        [_settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.settingImgView.mas_top);
            make.leading.mas_equalTo(self.settimgLabel.mas_leading);
            make.trailing.mas_equalTo(self.settimgLabel.mas_trailing);
            make.bottom.mas_equalTo(self.settimgLabel.mas_bottom);;
            
        }];
    }
    return _settingBtn;
}







- (UIImageView*)administratorsImgView{
    if (!_administratorsImgView) {
        _administratorsImgView = [[UIImageView alloc] init];
        _administratorsImgView.image=KGetImage(@"administratorsImg");
        [self addSubview:_administratorsImgView];
        [_administratorsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.settingImgView.mas_width);
            make.height.mas_equalTo(self.settingImgView.mas_height);
            make.centerY.mas_equalTo(self.settingImgView.mas_centerY);
//            make.centerX.mas_equalTo(self.mas_leading).offset(KAdaptedWidth(kWidth/8*3-KAdaptedWidth(13)));
            make.leading.mas_equalTo(self.settingImgView.mas_trailing).offset(KAdaptedWidth(35));
            
        }];
    }
    return _administratorsImgView;
}

- (UILabel *)administratorsLabel{
    if (!_administratorsLabel) {
        _administratorsLabel = [[UILabel alloc] init];
        _administratorsLabel.text = getLanguage(@"管理员");
        _administratorsLabel.textColor = RGBA(204, 204, 204, 1);
        _administratorsLabel.font=KFont(13);
        _administratorsLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_administratorsLabel];
        [_administratorsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.settimgLabel.mas_width);
            make.height.mas_equalTo(self.settimgLabel.mas_height);
            make.centerY.mas_equalTo(self.settimgLabel.mas_centerY);
            make.centerX.mas_equalTo(self.administratorsImgView.mas_centerX);
            
        }];
    }
    return _administratorsLabel;
}

- (UIButton *)administratorsBtn{
    if (!_administratorsBtn) {
        _administratorsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_administratorsBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _administratorsBtn.tag=200;
        [self addSubview:_administratorsBtn];
        [_administratorsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.administratorsImgView.mas_top);
            make.leading.mas_equalTo(self.administratorsLabel.mas_leading);
            make.trailing.mas_equalTo(self.administratorsLabel.mas_trailing);
            make.bottom.mas_equalTo(self.administratorsLabel.mas_bottom);;
            
        }];
    }
    return _administratorsBtn;
}


- (UIImageView*)cleanMsgImgView{
    if (!_cleanMsgImgView) {
        _cleanMsgImgView = [[UIImageView alloc] init];
        _cleanMsgImgView.image=KGetImage(@"cleanMsgImg");
        [self addSubview:_cleanMsgImgView];
        [_cleanMsgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.settingImgView.mas_width);
            make.height.mas_equalTo(self.settingImgView.mas_height);
            make.centerY.mas_equalTo(self.settingImgView.mas_centerY);
//            make.centerX.mas_equalTo(self.mas_leading).offset(KAdaptedWidth(kWidth/8*5-KAdaptedWidth(13)));
            make.leading.mas_equalTo(self.administratorsImgView.mas_trailing).offset(KAdaptedWidth(35));
        }];
    }
    return _cleanMsgImgView;
}

- (UILabel *)cleanMsgLabel{
    if (!_cleanMsgLabel) {
        _cleanMsgLabel = [[UILabel alloc] init];
        _cleanMsgLabel.text = getLanguage(@"清空消息");
        _cleanMsgLabel.textColor = RGBA(204, 204, 204, 1);
        _cleanMsgLabel.font=KFont(13);
        _cleanMsgLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_cleanMsgLabel];
        
        [_cleanMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.settimgLabel.mas_width);
            make.height.mas_equalTo(self.settimgLabel.mas_height);
            make.centerY.mas_equalTo(self.settimgLabel.mas_centerY);
            make.centerX.mas_equalTo(self.cleanMsgImgView.mas_centerX);
        }];
    }
    return _cleanMsgLabel;
}

- (UIButton *)cleanMsgBtn{
    if (!_cleanMsgBtn) {
        _cleanMsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cleanMsgBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _cleanMsgBtn.tag=300;
        [self addSubview:_cleanMsgBtn];
        [_cleanMsgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.cleanMsgImgView.mas_top);
            make.leading.mas_equalTo(self.cleanMsgLabel.mas_leading);
            make.trailing.mas_equalTo(self.cleanMsgLabel.mas_trailing);
            make.bottom.mas_equalTo(self.cleanMsgLabel.mas_bottom);;
            
        }];
    }
    return _cleanMsgBtn;
}




- (UIImageView*)cleanMeiLiImgView{
    if (!_cleanMeiLiImgView) {
        _cleanMeiLiImgView = [[UIImageView alloc] init];
        _cleanMeiLiImgView.image=KGetImage(@"CleanMeiLiImg");
        [self addSubview:_cleanMeiLiImgView];
        [_cleanMeiLiImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.cleanMsgImgView.mas_width);
            make.height.mas_equalTo(self.cleanMsgImgView.mas_height);
            make.centerY.mas_equalTo(self.cleanMsgImgView.mas_centerY);
//            make.centerX.mas_equalTo(self.mas_leading).offset(KAdaptedWidth(kWidth/8*7-KAdaptedWidth(13)));
            make.leading.mas_equalTo(self.cleanMsgImgView.mas_trailing).offset(KAdaptedWidth(35));
        }];
    }
    return _cleanMeiLiImgView;
}

- (UILabel *)cleanMeiLiLabel{
    if (!_cleanMeiLiLabel) {
        _cleanMeiLiLabel = [[UILabel alloc] init];
        _cleanMeiLiLabel.text = getLanguage(@"清空魅力值");
        _cleanMeiLiLabel.textColor = RGBA(204, 204, 204, 1);
        _cleanMeiLiLabel.font=KFont(13);
        _cleanMeiLiLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_cleanMeiLiLabel];
        [_cleanMeiLiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.cleanMsgLabel.mas_width);
            make.height.mas_equalTo(self.cleanMsgLabel.mas_height);
            make.centerY.mas_equalTo(self.cleanMsgLabel.mas_centerY);
            make.centerX.mas_equalTo(self.cleanMeiLiImgView.mas_centerX);
        }];
    }
    return _cleanMeiLiLabel;
}

- (UIButton *)cleanMeiLiBtn{
    if (!_cleanMeiLiBtn) {
        _cleanMeiLiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cleanMeiLiBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _cleanMeiLiBtn.tag=400;
        [self addSubview:_cleanMeiLiBtn];
        [_cleanMeiLiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.cleanMeiLiImgView.mas_top);
            make.leading.mas_equalTo(self.cleanMeiLiLabel.mas_leading);
            make.trailing.mas_equalTo(self.cleanMeiLiLabel.mas_trailing);
            make.bottom.mas_equalTo(self.cleanMeiLiLabel.mas_bottom);;
            
        }];
    }
    return _cleanMeiLiBtn;
}


//排行榜
- (EMO_RoomManagerView *)roomManagerView{
    if (!_roomManagerView) {
        _roomManagerView = [[EMO_RoomManagerView alloc] init];
       
    }
    return _roomManagerView;
}




-(void)BtnClick:(UIButton *)sender{
    [self removeFromSuperview];
    if(self.BtnClick){
        self.BtnClick(sender.tag);
    }
}


@end
