//
//  EMO_PrizeView.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/25.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_PrizeView.h"
#import "EMO_SelectPrizeNumView.h"
#import "EMO_BtnView.h"
#import "EMO_PrizeResultsView.h"//抽奖结果
//#import "EMO_LotteryDescriptionView.h"//抽奖说明
#import "EMO_WinningRecordView.h"//抽奖记录
#import "CustomAlertViewA.h"
@interface EMO_PrizeView(){
    NSTimer    *_startTimer;
    CGFloat    _intervalTime;
    ///当前定时的时间
    NSInteger  _currentRunCount;
    UIImageView * _curImg;
}
@property (nonatomic, strong) NSMutableArray *btnMutableArray;
Assign  NSInteger stopRunCount;
///中奖的礼物数组
Strong NSArray *winningGiftArray;

Strong NSMutableArray *giftArray;

Strong UIView *bgView;
Strong UIButton *tipBtn;
Strong UIButton *recordBtn;

Strong UIImageView *bgImgView;
Strong UIButton *luckBtn;
Strong UIButton *superBtn;
Strong UIView *shopBgView;

Strong EMO_SelectPrizeNumView *oneBtn;
Strong EMO_SelectPrizeNumView *fiveBtn;
Strong EMO_SelectPrizeNumView *tenBtn;

Strong EMO_PrizeResultsView *prizeResultView;
//Strong EMO_LotteryDescriptionView *DescriptionView;
Strong EMO_WinningRecordView *winningRecordView;

Strong NSString *price;
Strong NSString *five_price;
Strong NSString *ten_price;
/// 循环圈数
@property (nonatomic, assign) NSInteger circleCount;
///1-普通抽奖 0-超级抽奖
Assign NSInteger type;
Assign NSInteger index;
///数量
Assign NSInteger num;

Strong NSString *Description;
//总价值
Strong NSString *allPrice;

@end

@implementation EMO_PrizeView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.allPrice = @"";
        self.backgroundColor=[UIColor clearColor];
        self.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

- (void)singleTapGesture:(UITapGestureRecognizer *)tap{
    [self removeFromSuperview];
}

-(void)initView{
    _stopRunCount = 0;
    self.type = 0;
    self.num = 1;
    self.circleCount= 4;
    self.btnMutableArray = [NSMutableArray arrayWithCapacity:9];
    [self bgView];
    [self tipBtn];
    [self recordBtn];
    [self bgImgView];
    [self luckBtn];
    [self superBtn];
    [self fiveBtn];
    [self oneBtn];
    [self tenBtn];
    
    [self prizeResultView];
//    [self DescriptionView];
    [self winningRecordView];
    self.prizeResultView.hidden=YES;
//    self.DescriptionView.hidden=YES;
    self.winningRecordView.hidden=YES;
    [self addData];
    
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = kWhiteColor;
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.bottom.mas_equalTo(KAdaptedHeight(20));
            make.height.mas_equalTo(KAdaptedHeight(530));
            
        }];
        setViewCorner(_bgView, KAdaptedHeight(20));
    }
    return _bgView;
}


- (UIButton *)tipBtn{
    if (!_tipBtn) {
        _tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tipBtn setTitle:getLanguage(@"抽奖说明") forState:UIControlStateNormal];
        [_tipBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        _tipBtn.titleLabel.font=KFontA(14);
        _tipBtn.tag=100;
        _tipBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [_tipBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_tipBtn];
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
        _recordBtn.titleLabel.font=KFontA(14);
        _recordBtn.tag=200;
        _recordBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        [_recordBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_recordBtn];
        [_recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tipBtn.mas_top);
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(self.tipBtn.mas_height);
            make.width.mas_equalTo(self.tipBtn.mas_width);
        }];
    }
    return _recordBtn;
}


- (UIImageView*)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.image=KGetImage(@"prizeGameBgImg");
        _bgImgView.userInteractionEnabled=YES;
        [self addSubview:_bgImgView];
        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tipBtn.mas_bottom).offset(KAdaptedHeight(10));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.bottom.mas_equalTo(KAdaptedHeight(-75)-KSAFEAREA_BOTTOM_HEIHGHT);
            
        }];
    }
    return _bgImgView;
}


- (UIButton *)luckBtn{
    if (!_luckBtn) {
        _luckBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_luckBtn setTitle:getLanguage(@"幸运抽奖") forState:UIControlStateNormal];
        [_luckBtn setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
        _luckBtn.titleLabel.font=KFontA(14);
        _luckBtn.tag=300;
        _luckBtn.layer.contents=(id)KGetImage(@"GamebtnBgImg2").CGImage;
        [_luckBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgImgView addSubview:_luckBtn];
        [_luckBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(15));
            make.leading.mas_equalTo(KAdaptedWidth(13));
            make.height.mas_equalTo(KAdaptedHeight(40));
            make.trailing.mas_equalTo(self.bgImgView.mas_centerX).offset(KAdaptedWidth(-8));
            
        }];
    }
    return _luckBtn;
}

- (UIButton *)superBtn{
    if (!_superBtn) {
        _superBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_superBtn setTitle:getLanguage(@"超级抽奖") forState:UIControlStateNormal];
        [_superBtn setTitleColor:RGBA(72, 31, 12, 1) forState:UIControlStateNormal];
        _superBtn.titleLabel.font=KFontA(14);
        _superBtn.tag=400;
        _superBtn.layer.contents=(id)KGetImage(@"GamebtnBgImg1").CGImage;
        [_superBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgImgView addSubview:_superBtn];
        [_superBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.luckBtn.mas_top);
            make.trailing.mas_equalTo(KAdaptedWidth(-13));
            make.height.mas_equalTo(self.luckBtn.mas_height);
            make.leading.mas_equalTo(self.bgImgView.mas_centerX).offset(KAdaptedWidth(8));
            
        }];
    }
    return _superBtn;
}

- (UIView *)shopBgView{
    if (!_shopBgView) {
        _shopBgView = [[UIView alloc] init];
        _shopBgView.backgroundColor = kClearColor;
        [self.bgImgView addSubview:_shopBgView];
        [_shopBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.bottom.mas_equalTo(KAdaptedHeight(0));
            make.top.mas_equalTo(self.luckBtn.mas_bottom).offset(KAdaptedHeight(5));
            
        }];
    }
    return _shopBgView;
}

- (EMO_SelectPrizeNumView *)fiveBtn{
    if (!_fiveBtn) {
        _fiveBtn = [[EMO_SelectPrizeNumView alloc] init];
        _fiveBtn.backgroundColor = kClearColor;
        _fiveBtn.tag=200;
        _fiveBtn.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(concernAction:)];
         [_fiveBtn addGestureRecognizer:tap];
        [self.bgView addSubview:_fiveBtn];
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
        _oneBtn.backgroundColor = kClearColor;
        _oneBtn.tag=100;
        _oneBtn.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(concernAction:)];
         [_oneBtn addGestureRecognizer:tap];
        [self.bgView addSubview:_oneBtn];
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
        _tenBtn.backgroundColor = kClearColor;
        _tenBtn.tag=300;
        _tenBtn.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(concernAction:)];
         [_tenBtn addGestureRecognizer:tap];
        [self.bgView addSubview:_tenBtn];
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

//- (EMO_LotteryDescriptionView *)DescriptionView{
//    if (!_DescriptionView) {
//        _DescriptionView = [[EMO_LotteryDescriptionView alloc] init];
//        _DescriptionView.backgroundColor = RGBA(0, 0, 0, 0.12);
//        _DescriptionView.type=self.type;
//        [self addSubview:_DescriptionView];
//        [_DescriptionView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.leading.trailing.bottom.mas_equalTo(0);
//        }];
//    }
//    return _DescriptionView;
//}
- (EMO_WinningRecordView *)winningRecordView{
    if (!_winningRecordView) {
        _winningRecordView = [[EMO_WinningRecordView alloc] init];
        _winningRecordView.backgroundColor = RGBA(0, 0, 0, 0.12);
        [self addSubview:_winningRecordView];
        [_winningRecordView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(0);
        }];
    }
    return _winningRecordView;
}



#pragma mark 抽奖UI
- (void)chouJiangView:(NSMutableArray *)giftArray{
    [self.shopBgView removeAllSubviews];
    [self.btnMutableArray removeAllObjects];
    CGFloat margin_X = KAdaptedWidth(8);
    CGFloat margin_Y = KAdaptedHeight(8);
    CGFloat itemWidth = KAdaptedWidth(95);
    CGFloat itemHeight = KAdaptedWidth(95);
    int totalColumns = 3;
    // 初始化九宫格
    for (int index = 0; index < giftArray.count; index++) {
        NSDictionary *model = giftArray[index];
        int row = index / totalColumns;
        int col = index % totalColumns;
        CGFloat cellX =  col * (itemWidth + margin_X);
        CGFloat cellY = row * (itemHeight + margin_Y);
        
        EMO_BtnView *  gamrBtn = [[EMO_BtnView alloc] init];
        gamrBtn.frame  = CGRectMake(KAdaptedWidth(20)+cellX,cellY, itemWidth, itemHeight);
        gamrBtn.imgTop=KAdaptedHeight(15);
        gamrBtn.labelBottom=KAdaptedHeight(-15);
        gamrBtn.layer.contents=(id)KGetImage(@"shopBgImg").CGImage;
//        type 0神秘 1头像框 2金币 3钻石
//        if([model[@"type"] integerValue]==0){
//            gamrBtn.iconImgView.image=KGetImage(@"giftIconImg2");
//        }else if ([model[@"type"] integerValue]==1){
//            [gamrBtn.iconImgView sd_setImageWithURL:[NSURL URLWithString:[Common isNull:model[@"dress_image"]]]];
//        }else
        if ([model[@"type"] integerValue]==2){
            gamrBtn.iconImgView.image=KGetImage(@"giftIconImg6");
        }else if ([model[@"type"] integerValue]==3){
            gamrBtn.iconImgView.image=KGetImage(@"giftIconImg3");
        }else{
            [gamrBtn.iconImgView sd_setImageWithURL:[NSURL URLWithString:model[@"dress_image"]] placeholderImage:defaultionPhotoIcon];
        }
        gamrBtn.nameLabel.text=[Common isNull:model[@"type_text"]];
            gamrBtn.ClickBtn.tag=index;
//        WeakSelf;
        gamrBtn.BtnBlock = ^(NSInteger tag) {
            
            
        };
        [self.shopBgView addSubview:gamrBtn];
        setViewCorner(gamrBtn, 10);
        [self.btnMutableArray addObject:gamrBtn];
    }
    _curImg = [[UIImageView alloc] init];
    _curImg.backgroundColor = [UIColor clearColor];
    _curImg.width = KAdaptedWidth(100);
    _curImg.height =KAdaptedWidth(100);
    _curImg.hidden = YES;
    _curImg.image = KGetImage(@"TT_ChouJiangZD");
    [self.shopBgView addSubview:_curImg];
    
    EMO_BtnView *oldBtn = [self.btnMutableArray objectAtIndex:0];
    _curImg.center = oldBtn.center;
    
}

#pragma mark 开始抽奖
- (void)startChouJiang{
    _currentRunCount = 0;
    _intervalTime = 0.1;
    _stopRunCount = _stopRunCount+9*self.circleCount;
    self.oneBtn.userInteractionEnabled=NO;
    self.fiveBtn.userInteractionEnabled=NO;
    self.tenBtn.userInteractionEnabled=NO;

    _curImg.hidden = NO;
    _startTimer = [NSTimer scheduledTimerWithTimeInterval:_intervalTime target:self selector:@selector(chouJiangStart:) userInfo:nil repeats:YES];
}

#pragma mark 抽奖动画开始
- (void)chouJiangStart:(NSTimer *)timer{
    UIButton *oldBtn = [self.btnMutableArray objectAtIndex:_currentRunCount % self.btnMutableArray.count];
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_curImg.center = oldBtn.center;
    });
    _currentRunCount++;
    // 停止循环
    if (_currentRunCount > _stopRunCount) {
        [timer invalidate];
        [self shouJiangEnd];
        return;
    }
    // 一直循环
    if (_currentRunCount > _stopRunCount - 5) {
        _intervalTime += 0.1;
        [timer invalidate];
        _startTimer = [NSTimer scheduledTimerWithTimeInterval:_intervalTime target:self selector:@selector(chouJiangStart:) userInfo:nil repeats:YES];
    }
}

#pragma mark 抽奖结束
- (void)shouJiangEnd{
    self.oneBtn.userInteractionEnabled=YES;
    self.fiveBtn.userInteractionEnabled=YES;
    self.tenBtn.userInteractionEnabled=YES;
    [self sendWinningUI];
}

#pragma mark 动画结束，展示中奖UI和发送中奖消息
- (void)sendWinningUI{
    
//    [SVProgressHUD showImage:KGetImage(@"") status:@"展示中奖信息"];
    self.prizeResultView.hidden=NO;
    self.prizeResultView.type=1;
    self.prizeResultView.arrData=self.winningGiftArray;
    self.prizeResultView.priceLabel.text = [NSString stringWithFormat:@"总价值:%@",[Common isNullNumber:self.allPrice]];
}

#pragma mark 抽奖
-(void)concernAction:(UITapGestureRecognizer *)tap{
    if(tap.view.tag==100){
        self.num=1;
    }else if(tap.view.tag==200){
        self.num=5;
    }else{
        self.num=10;
    }
    WeakSelf;
    [NetworkRequest POST:Request_Lottery parmeters:@{@"status":@"1",@"type":@(self.type),@"num":@(self.num)} success:^(id responObject) {
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
            [wself startChouJiang];
        }else{
        }
        
    } failture:^(NSError *error) {
        
    }];
    
}



-(void)BtnClick:(UIButton *)sender{
    switch (sender.tag) {
        case 100:{
//            self.DescriptionView.hidden=NO;
            [CustomAlertViewA showAlertView_Type:AlertType_Bottom ContentType:GiftDescriptionCustomViewTag andData:@{@"data":self.Description,@"type":@(self.type)}];
        }break;
        case 200:{
//            self.winningRecordView.hidden=NO;
            [CustomAlertViewA showAlertView_Type:AlertType_Bottom ContentType:WinningRecordCustomViewTag andData:@{@"data":@(1)}];
//            [SVProgressHUD showImage:KGetImage(@"") status:@"中奖记录"];
        }break;
        case 300:{
            self.type=0;
            [self.superBtn setTitleColor:RGBA(72, 31, 12, 1) forState:UIControlStateNormal];
            self.superBtn.layer.contents=(id)KGetImage(@"GamebtnBgImg1").CGImage;
            [self.luckBtn setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
            self.luckBtn.layer.contents=(id)KGetImage(@"GamebtnBgImg2").CGImage;
//            self.DescriptionView.type=self.type;
            [self addData];
        }break;
        case 400:{
            self.type=1;
//            self.DescriptionView.type=self.type;
            [self.luckBtn setTitleColor:RGBA(72, 31, 12, 1) forState:UIControlStateNormal];
            self.luckBtn.layer.contents=(id)KGetImage(@"GamebtnBgImg1").CGImage;
            [self.superBtn setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
            self.superBtn.layer.contents=(id)KGetImage(@"GamebtnBgImg2").CGImage;
            [self addData];
        }break;
            
            
        default:
            break;
    }
}


#pragma mark 获取奖品数据
-(void)addData{
    
    [NetworkRequest POST:Request_GetDrawList parmeters:@{@"type":@(self.type)} success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        NSLog(@"");
        self.price=[Common isNull:basemodel.data[@"price"]];
        self.five_price=[Common isNull:basemodel.data[@"five_price"]];
        self.ten_price=[Common isNull:basemodel.data[@"ten_price"]];
        self.fiveBtn.dicData=@{@"price":self.five_price,@"nums":@"5"};
        self.oneBtn.dicData=@{@"price":self.price,@"nums":@"1"};
        self.tenBtn.dicData=@{@"price":self.ten_price,@"nums":@"10"};
        self.giftArray=[NSMutableArray arrayWithArray:basemodel.data[@"prize_list"]];
        [self chouJiangView:self.giftArray];
        
        
    } failture:^(NSError *error) {
            
    }];
    
    [NetworkRequest POST:Request_AppText parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        
        NSDictionary *dic =baseModel.data[6];
        self.Description=[Common isNull:dic[@"content"]];
//        self.Description=getLanguage(@"1.这里是内容，不知道写点啥这里是内容2.不知道写点啥这里是内容不知道写点啥这里是内容3.不知道写点这里是内容，不知道写点啥这里是道写点啥这里是内容不知道写点啥这里是内容不知道写点1.这里是内容，不知道写点啥这里是内容           2.不知道写点啥这里是内容不知道写点啥这里是内容3.不知道写点这里是内容，不知道写点啥这里是道写点啥这里是内容不知道写点啥这里是内容不知道写点");;
//        self.DescriptionView.contenStr=self.Description;
        
    } failture:^(NSError *error) {
        
        
    }];
    
}



@end
