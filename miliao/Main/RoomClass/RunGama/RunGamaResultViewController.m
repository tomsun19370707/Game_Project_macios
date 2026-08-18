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

    // 统计总中奖金额
    NSInteger winSum = 0;
    if (self.infoDic && [self.infoDic isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dict in self.infoDic) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                if ([dict valueForKey:@"win_amount"] != nil) {
                    winSum += [[dict valueForKey:@"win_amount"] integerValue];
                } else if ([dict valueForKey:@"amount"] != nil) {
                    winSum += [[dict valueForKey:@"amount"] integerValue];
                }
            }
        }
    }

    BOOL hasWinningBet = (self.infoDic.count > 0);
    BOOL hasWinAmount = (winSum > 0);

    // 1. 第一个容器（获胜动物框）
    UIImageView *leftBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:hasWinningBet ? @"礼物框框" : @"元宝"]];
    leftBgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [contentImageView addSubview:leftBgImageView];
    [leftBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(contentImageView.mas_centerY).offset(5);
        make.width.mas_equalTo(72);
        make.height.mas_equalTo(71);
        if (hasWinAmount) {
            make.centerX.mas_equalTo(contentImageView.mas_centerX).offset(-50);
        } else {
            make.centerX.mas_equalTo(contentImageView.mas_centerX);
        }
    }];

    if (hasWinningBet) {
        UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self getInconName:[NSString stringWithFormat:@"%@", [self.infoDic[0] valueForKey:@"winner_name"]]]]];
        leftImageView.contentMode = UIViewContentModeScaleAspectFit;
        [leftBgImageView addSubview:leftImageView];
        [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(leftBgImageView);
            make.width.height.mas_equalTo(40);
        }];
    }

    // 2. 第二个容器（元宝中奖框 + 内部 img_syyb 40x40 + 左上角 "数量" 角标）
    UIImageView *rightBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"元宝"]];
    rightBgImageView.contentMode = UIViewContentModeScaleAspectFill;
    rightBgImageView.hidden = !hasWinAmount;
    [contentImageView addSubview:rightBgImageView];
    [rightBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(contentImageView.mas_centerY).offset(5);
        make.width.mas_equalTo(71);
        make.height.mas_equalTo(71);
        make.centerX.mas_equalTo(contentImageView.mas_centerX).offset(50);
    }];

    // 2.1 容器内部中央嵌套 img_syyb 元宝图标 (40x40 pt)
    UIImageView *ingotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_syyb"]];
    ingotImageView.contentMode = UIViewContentModeScaleAspectFit;
    [rightBgImageView addSubview:ingotImageView];
    [ingotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(rightBgImageView);
        make.width.height.mas_equalTo(40);
    }];

    // 2.2 右上角悬浮挂载自适应胶囊角标 (#B96022 棕底, 18pt高度, 9pt圆角, 10pt加粗字体)
    UILabel *numberBadgeLabel = [[UILabel alloc] init];
    numberBadgeLabel.backgroundColor = mHexRGB(0xB96022);
    numberBadgeLabel.textColor = [UIColor whiteColor];
    numberBadgeLabel.font = [UIFont boldSystemFontOfSize:10];
    numberBadgeLabel.textAlignment = NSTextAlignmentCenter;
    numberBadgeLabel.layer.cornerRadius = 9;
    numberBadgeLabel.layer.masksToBounds = YES;
    numberBadgeLabel.adjustsFontSizeToFitWidth = YES;
    numberBadgeLabel.minimumScaleFactor = 0.8;
    numberBadgeLabel.text = [RunGamaResultViewController formatBadgeNumber:winSum];
    [rightBgImageView addSubview:numberBadgeLabel];
    [numberBadgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(rightBgImageView.mas_top).offset(-2);
        make.trailing.mas_equalTo(rightBgImageView.mas_trailing).offset(2);
        make.height.mas_equalTo(18);
        make.width.mas_greaterThanOrEqualTo(18);
    }];

    // 3. 底部关闭按钮（根据中奖金额动态切换 "开心收下" 与 "再接再厉"）
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton addTarget:self action:@selector(closeVc) forControlEvents:UIControlEventTouchUpInside];
    NSString *buttonImgName = hasWinAmount ? @"开心收下" : @"再接再厉";
    [closeButton setBackgroundImage:[UIImage imageNamed:buttonImgName] forState:UIControlStateNormal];
    [contentImageView addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-40);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(160);
        make.centerX.mas_equalTo(0);
    }];
}

+ (NSString *)formatBadgeNumber:(NSInteger)num {
    if (num < 10000) {
        return [NSString stringWithFormat:@"%ld", (long)num];
    }
    double w = num / 10000.0;
    if (num % 10000 == 0) {
        return [NSString stringWithFormat:@"%ldw", (long)w];
    }
    return [NSString stringWithFormat:@"%.1fw", w];
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
