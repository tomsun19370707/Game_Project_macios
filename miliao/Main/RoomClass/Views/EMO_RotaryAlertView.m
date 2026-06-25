//
//  EMO_RotaryAlertView.m
//  miliao
//
//  Created by jkkj on 2023/12/8.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_RotaryAlertView.h"
#import "RouletteView.h"
#import "EMO_SelectPrizeNumView.h"
#import "EMO_PrizeResultsView.h"
#import "CustomAlertViewA.h"
@interface EMO_RotaryAlertView ()<CAAnimationDelegate>

Strong UIView *rootView;
Strong UIView *topView;//幸运抽奖、超级抽奖
Strong UIImageView *topBackView;
Strong UIButton *luckBtn;
Strong UIButton *superBtn;
Strong UIImageView *bgImgView;
Assign NSInteger type;
Strong UIButton *recordBtn;
Strong UIButton *tipBtn;
Strong RouletteView*roulette;//转盘
Strong EMO_SelectPrizeNumView *oneBtn;
Strong EMO_SelectPrizeNumView *fiveBtn;
Strong EMO_SelectPrizeNumView *tenBtn;
Assign NSInteger num;
@property (copy,   nonatomic) NSString *prize;
@property (nonatomic) BOOL isAnimation;
Strong NSArray *giftArray;
Strong NSString *five_price;
Strong NSString *ten_price;
Strong NSString *price;
Strong NSArray *winningGiftArray;
Strong NSString *allPrice;
Assign  NSInteger stopRunCount;
Strong NSString *Description;
Strong EMO_PrizeResultsView *prizeResultView;
Strong NSMutableDictionary *dataServerDic;
Strong NSDictionary *cjServerDic;
@end

@implementation EMO_RotaryAlertView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.dataServerDic = [[NSMutableDictionary alloc] init];
        self.cjServerDic = [[NSDictionary alloc] init];
        self.rootView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
        self.rootView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [[Common AppWindow] addSubview:self.rootView];
        
        UIButton *backGroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backGroundBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        backGroundBtn.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self.rootView addSubview:backGroundBtn];
        
        self.width = kScreenWidth;
        self.left = 0;
        self.height = self.rootView.height*0.8;
        self.top = self.rootView.height*0.2;
        self.backgroundColor = UIColor.clearColor;
        [self.rootView addSubview:self];
        [self roundTopCornersRadius:20];
        [self createUI];
    }
    return self;
}

-(void)createUI{
    self.bgImgView = [[UIImageView alloc] init];
    self.bgImgView.image = KGetImage(@"UY_RotaryBackImg");
    [self addSubview:self.bgImgView];
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_offset(0);
    }];
    [self tipBtn];
    [self recordBtn];
    [self createTopView];
    self.roulette = [[RouletteView alloc]initWithFrame:CGRectMake(0,110, kScreenWidth - 50, kScreenWidth - 50)];
    self.roulette.centerX = self.centerX;
    [self.roulette.playButton addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.roulette];

    [self fiveBtn];
    [self oneBtn];
    [self tenBtn];
    
    [self prizeResultView];
    self.prizeResultView.hidden=YES;
}

-(void)createTopView{
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [self addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(20);
        make.top.mas_offset(65);
        make.right.mas_offset(-20);
        make.height.mas_offset(44);
    }];
    setViewCorner(self.topView, 22);
    
    CGFloat width = (kScreenWidth - 40)/2;
    self.topBackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
    self.topBackView.image = KGetImage(@"UY_TopViewBackImg");
    [self.topView addSubview:self.topBackView];
    
    _luckBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_luckBtn setTitle:getLanguage(@"幸运抽奖") forState:UIControlStateNormal];
    [_luckBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_luckBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _luckBtn.titleLabel.font=KFontA(14);
    _luckBtn.tag=300;
    [_luckBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:_luckBtn];
    [_luckBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.leading.mas_equalTo(0);
        make.bottom.mas_equalTo(KAdaptedHeight(0));
        make.width.equalTo(self.topView.mas_width).multipliedBy(0.5);
    }];
    
    _superBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_superBtn setTitle:getLanguage(@"超级抽奖") forState:UIControlStateNormal];
    [_superBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_superBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _superBtn.titleLabel.font=KFontA(14);
    _superBtn.tag=400;
    [_superBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:_superBtn];
    [_superBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.luckBtn.mas_top);
        make.trailing.mas_equalTo(KAdaptedWidth(0));
        make.height.mas_equalTo(self.luckBtn.mas_height);
        make.leading.equalTo(self.topView.mas_centerX).offset(KAdaptedWidth(0));
    }];
    [_superBtn layoutIfNeeded];
}

- (UIButton *)tipBtn{
    if (!_tipBtn) {
        _tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tipBtn setTitle:getLanguage(@"抽奖说明") forState:UIControlStateNormal];
        [_tipBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        [_tipBtn setBackgroundImage:KGetImage(@"UY_TipBackImg") forState:0];
        _tipBtn.titleLabel.font=KFontA(14);
        _tipBtn.tag=500;
        _tipBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        [_tipBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_tipBtn];
        [_tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(20));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.height.mas_equalTo(KAdaptedHeight(30));
            make.width.mas_equalTo(KAdaptedWidth(75));
        }];
    }
    return _tipBtn;
}

- (UIButton *)recordBtn{
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordBtn setTitle:getLanguage(@"中奖记录") forState:UIControlStateNormal];
        [_recordBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        [_recordBtn setBackgroundImage:KGetImage(@"UY_TipBackImg") forState:0];
        _recordBtn.titleLabel.font=KFontA(14);
        _recordBtn.tag=600;
        _recordBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        [_recordBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_recordBtn];
        [_recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tipBtn.mas_top);
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(self.tipBtn.mas_height);
            make.width.mas_equalTo(self.tipBtn.mas_width);
        }];
    }
    return _recordBtn;
}

- (EMO_SelectPrizeNumView *)fiveBtn{
    if (!_fiveBtn) {
        _fiveBtn = [[EMO_SelectPrizeNumView alloc] init];
        _fiveBtn.bgImageView.image = KGetImage(@"UY_chouJiangDownImg");
        _fiveBtn.tag=200;
        _fiveBtn.titleLabel.textColor = UIColor.whiteColor;
        [_fiveBtn.priceBtm setTitleColor:UIColor.whiteColor forState:0];
        _fiveBtn.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(concernAction:)];
         [_fiveBtn addGestureRecognizer:tap];
        [self addSubview:_fiveBtn];
        [_fiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(KAdaptedWidth(110));
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(KAdaptedHeight(-30)-KSAFEAREA_BOTTOM_HEIHGHT);
            make.height.mas_equalTo(KAdaptedHeight(50));
            
        }];
    }
    return _fiveBtn;
}

- (EMO_SelectPrizeNumView *)oneBtn{
    if (!_oneBtn) {
        _oneBtn = [[EMO_SelectPrizeNumView alloc] init];
        _oneBtn.bgImageView.image = KGetImage(@"UY_chouJiangDownImg");
        _oneBtn.titleLabel.textColor = UIColor.whiteColor;
        [_oneBtn.priceBtm setTitleColor:UIColor.whiteColor forState:0];
        _oneBtn.tag=100;
        _oneBtn.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(concernAction:)];
         [_oneBtn addGestureRecognizer:tap];
        [self addSubview:_oneBtn];
        [_oneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.fiveBtn.mas_width);
            make.height.mas_equalTo(self.fiveBtn.mas_height);
            make.centerY.mas_equalTo(self.fiveBtn.mas_centerY);
            make.leading.mas_equalTo(self.bgImgView.mas_leading);
        }];
    }
    return _oneBtn;
}

- (EMO_SelectPrizeNumView *)tenBtn{
    if (!_tenBtn) {
        _tenBtn = [[EMO_SelectPrizeNumView alloc] init];
        _tenBtn.tag=300;
        _tenBtn.bgImageView.image = KGetImage(@"UY_chouJiangDownImg");
        _tenBtn.titleLabel.textColor = UIColor.whiteColor;
        [_tenBtn.priceBtm setTitleColor:UIColor.whiteColor forState:0];
        _tenBtn.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(concernAction:)];
         [_tenBtn addGestureRecognizer:tap];
        [self addSubview:_tenBtn];
        [_tenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.fiveBtn.mas_width);
            make.height.mas_equalTo(self.fiveBtn.mas_height);
            make.centerY.mas_equalTo(self.fiveBtn.mas_centerY);
            make.trailing.mas_equalTo(self.bgImgView.mas_trailing);
        }];
    }
    return _tenBtn;
}

- (EMO_PrizeResultsView *)prizeResultView{
    if (!_prizeResultView) {
        _prizeResultView = [[EMO_PrizeResultsView alloc] init];
        _prizeResultView.backgroundColor = RGBA(0, 0, 0, 0.12);
        [self addSubview:_prizeResultView];
        [_prizeResultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(0);
        }];
    }
    return _prizeResultView;
}

-(void)BtnClick:(UIButton *)sender{
    switch (sender.tag) {
        case 500:{
            [CustomAlertViewA showAlertView_Type:AlertType_Bottom ContentType:GiftDescriptionCustomViewTag andData:@{@"data":self.Description,@"type":@(self.type)}];
        }break;
        case 600:{
            [CustomAlertViewA showAlertView_Type:AlertType_Bottom ContentType:WinningRecordCustomViewTag andData:@{@"data":@(2)}];
        }break;
        case 300:{
            self.type=0;
            self.luckBtn.selected = YES;
            self.superBtn.selected = NO;
            [self APPGiftData];
            WeakSelf;
            [UIView animateWithDuration:0.25 animations:^{
                wself.topBackView.left = 0;
            }];
        }break;
        case 400:{
            self.type=1;
            self.luckBtn.selected = NO;
            self.superBtn.selected = YES;
            [self APPGiftData];
            WeakSelf;
            [UIView animateWithDuration:0.25 animations:^{
                wself.topBackView.left = wself.topView.width/2;
            }];
            
        }break;
        default:
            break;
    }
}

-(void)btnClick{
    [self viewHide];
}

- (void)viewHide{
    WeakSelf;
    wself.rootView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.25 animations:^{
        wself.rootView.top = kScreenHeight;
    } completion:^(BOOL finished) {
      
    }];
}

- (void)viewShow{
    WeakSelf;
    [UIView animateWithDuration:0.25 animations:^{
        wself.rootView.top = 0;
    } completion:^(BOOL finished) {
        wself.rootView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    }];
}

- (void)clickBtn:(UIButton *)sender {
   
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.isAnimation = NO;
    self.prizeResultView.hidden=NO;
    self.prizeResultView.type=1;
    self.prizeResultView.arrData=self.winningGiftArray;
    self.prizeResultView.priceLabel.text = [NSString stringWithFormat:@"总价值:%@",[Common isNullNumber:self.allPrice]];
}

#pragma mark 抽奖
-(void)startAnimation{
    if (self.isAnimation) {
        return;
    }
    self.isAnimation = YES;
    CGFloat perAngle = M_PI/180.0;
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    NSInteger num = self.giftArray.count -self.stopRunCount;
    NSInteger Angle = 0;
    if(self.stopRunCount == 0){
        Angle = 0;
    }else{
        Angle = 360-36*(self.stopRunCount-1);
    }
    [rotationAnimation setFromValue:[NSNumber numberWithFloat:M_PI * (0.0 + 0)]];
    rotationAnimation.toValue = [NSNumber numberWithFloat:Angle * perAngle + 360 * perAngle * 7];
    rotationAnimation.duration = 4.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.delegate = self;
    
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = NO;
    
    [self.roulette.rotateWheel.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

-(void)concernAction:(UITapGestureRecognizer *)tap{
    if(tap.view.tag==100){
        self.num=1;
    }else if(tap.view.tag==200){
        self.num=5;
    }else{
        self.num=10;
    }
    WeakSelf;
    //转盘抽奖
    NSString *url = VERSION_HTTPS_SERVER@"api/room/lottery";
    [NetworkRequest POST:url parmeters:@{@"status":@"2",@"type":@(self.type),@"num":@(self.num)} success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        NSLog(@"BBB=%@",basemodel.data);
        NSDictionary *dataDic = [[NSDictionary alloc] initWithDictionary:basemodel.data];
        self.winningGiftArray=dataDic[@"list"];
        self.allPrice = dataDic[@"total_gift_money"];
        if(self.winningGiftArray.count>0){
            NSDictionary *dicData=self.winningGiftArray[0];
            [wself.giftArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if([obj[@"id"] integerValue]==[dicData[@"id"] integerValue]){
                    wself.stopRunCount=idx;
                }
            }];
            [wself startAnimation];
        }else{
        }

    } failture:^(NSError *error) {

    }];
}

//转盘礼物
-(void)requestGift{
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    NSString *url = VERSION_HTTPS_SERVER@"api/gift/getTurntableList";
    [NetworkRequest POST:url
               parmeters:@{@"type":@"0"}
                 success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        self.dataServerDic = basemodel.data;
        [self APPGiftData];
    }failture:^(NSError *error) {
        
    }];
    
//    [NetworkRequest POST:Request_AppText parmeters:nil success:^(id responObject) {
//        BaseModel *baseModel = (BaseModel *)responObject;
//        
//        NSDictionary *dic =baseModel.data[8];
//        self.Description=[Common isNull:dic[@"content"]];
//        
//    } failture:^(NSError *error) {
//        
//        
//    }];
}
-(void)requestGiftChaoJi{
    NSString *url = VERSION_HTTPS_SERVER@"api/gift/getTurntableList";
    [NetworkRequest POST:url
               parmeters:@{@"type":@"1"}
                 success:^(id responObject) {
        [SVProgressHUD dismiss];
        BaseModel *basemodel=(BaseModel *)responObject;
        self.cjServerDic = basemodel.data;
    }failture:^(NSError *error) {
        
    }];
}

-(void)APPGiftData{
    if(self.type == 0){
        self.price=[Common isNull:self.dataServerDic[@"price"]];
        self.five_price=[Common isNull:self.dataServerDic[@"five_price"]];
        self.ten_price=[Common isNull:self.dataServerDic[@"ten_price"]];
        self.fiveBtn.dicData=@{@"price":self.five_price,@"nums":@"5"};
        self.oneBtn.dicData=@{@"price":self.price,@"nums":@"1"};
        self.tenBtn.dicData=@{@"price":self.ten_price,@"nums":@"10"};
        self.giftArray=[NSMutableArray arrayWithArray:self.dataServerDic[@"prize_list"]];
        [self.roulette giftArray:self.giftArray];
    }else{
        self.price=[Common isNull:self.cjServerDic[@"price"]];
        self.five_price=[Common isNull:self.cjServerDic[@"five_price"]];
        self.ten_price=[Common isNull:self.cjServerDic[@"ten_price"]];
        self.fiveBtn.dicData=@{@"price":self.five_price,@"nums":@"5"};
        self.oneBtn.dicData=@{@"price":self.price,@"nums":@"1"};
        self.tenBtn.dicData=@{@"price":self.ten_price,@"nums":@"10"};
        self.giftArray=[NSMutableArray arrayWithArray:self.cjServerDic[@"prize_list"]];
        [self.roulette giftArray:self.giftArray];
    }
}
@end
