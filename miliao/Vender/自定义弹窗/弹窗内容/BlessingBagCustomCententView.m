//
//  BlessingBagCustomCententView.m
//  miliao
//
//  Created by 张世浩 on 2022/5/28.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "BlessingBagCustomCententView.h"
#import "BlessingBagGiftView.h"
#import "SCAdView.h"
#import "HeroModel.h"
#import "CustomAlertViewA.h"
#import "RoomFuDaiModel.h"
#import "EMO_PrizeResultsView.h"
@interface BlessingBagCustomCententView ()<UIScrollViewDelegate,SCAdViewDelegate>

{
    SCAdView *_adView;
}
@property(nonatomic,strong) UIView * bgView;
@property(nonatomic,strong) UIImageView * bgImgView;
@property(nonatomic,strong) UIImageView * bgTwoImgView;
@property(nonatomic,strong) UIImageView * titleImgView;
@property(nonatomic,strong) UIButton * backBtn;
@property(nonatomic,strong) UIButton * moreBtn;
@property(nonatomic,strong) UILabel * tipLabel;
@property(nonatomic,strong) UIView * centerView;
@property(nonatomic,strong) UIScrollView * scrollView;

@property(nonatomic,strong) UIView * bottomView;
@property(nonatomic,strong) UIImageView * ringImgView;
@property(nonatomic,strong) UIImageView * bottomImgView;
@property(nonatomic,strong) UIButton * moneyBtn;

@property(nonatomic,strong) NSMutableArray * idArr;
@property(nonatomic,strong) NSMutableArray * titleArr;
@property(nonatomic,strong) NSMutableArray * imgArr;
@property(nonatomic,strong) NSMutableArray * shopArr;

Strong EMO_PrizeResultsView *prizeResultView;

Strong  NSString *tipStr;

@end


@implementation BlessingBagCustomCententView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addChildrenViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addChildrenViews];
    }
    return self;
}
-(NSMutableArray *)idArr{
    if (!_idArr) {
        _idArr=[NSMutableArray array];
    }
    return _idArr;
}
-(NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr=[NSMutableArray array];
    }
    return _titleArr;
}
-(NSMutableArray *)imgArr{
    if (!_imgArr) {
        _imgArr=[NSMutableArray array];
    }
    return _imgArr;
}
-(NSMutableArray *)shopArr{
    if (!_shopArr) {
        _shopArr=[NSMutableArray array];
    }
    return _shopArr;
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    NSArray *arr=dicData[@"data"];
    
    if(arr.count>0){
        self.shopArr=[NSMutableArray arrayWithArray:arr];
        for (int i=0; i<arr.count; i++) {
            RoomFuDaiModel *dic=arr[i];
            if(i==0){
                [self addData:dic];
            }
            [self.idArr addObject:dic.fuDaiID];
            [self.titleArr addObject:dic.name];
            [self.imgArr addObject:dic.image];
           
        }
        [self showAdHorizontally];//水平显示
    }
 
}


- (void) addChildrenViews{
    [super addChildrenViews];
    [self bgView];
    [self bgImgView];
    [self bgTwoImgView];
    [self backBtn];
    [self moreBtn];
    [self titleImgView];
    [self tipLabel];
    [self centerView];
    [self scrollView];
    [self bottomView];
    [self ringImgView];
    [self bottomImgView];
    [self moneyBtn];
    [self prizeResultView];
    [self tipData];
    
    self.prizeResultView.hidden=YES;
    
}


-(void)BtnClick:(UIButton *)sender{
    if (sender.tag==100) {
        //           礼物说明
        [CustomAlertViewA showAlertView_Type:AlertType_Bottom ContentType:GiftDescriptionCustomViewTag andData:@{@"data":self.tipStr,@"type":@"66"}];
    }else {
        //           中奖记录
        [CustomAlertViewA showAlertView_Type:AlertType_Bottom ContentType:WinningRecordCustomViewTag andData:@{@"data":@(0)}];
    }
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor =kWhiteColor;
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(self);
            make.height.mas_equalTo(KAdaptedHeight(485)+DBottomDangerArea);
        }];
        
    }
    return _bgView;
}

- (UIImageView*)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.image=[UIImage imageNamed:@"fuDaibgImg"];
        [self.bgView addSubview:_bgImgView];
        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.leading.trailing.bottom.mas_equalTo(0);
            make.top.mas_equalTo(KAdaptedHeight(50));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.bottom.mas_equalTo(KAdaptedWidth(-KAdaptedHeight(23)));
        }];
    }
    return _bgImgView;
}

- (UIImageView*)bgTwoImgView{
    if (!_bgTwoImgView) {
        _bgTwoImgView = [[UIImageView alloc] init];
        _bgTwoImgView.image=[UIImage imageNamed:@"bgTwoImg"];
        [self.bgView addSubview:_bgTwoImgView];
        [_bgTwoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bgImgView.mas_top).offset(KAdaptedHeight(30));
            make.leading.mas_equalTo(self.bgImgView.mas_leading);
            make.trailing.mas_equalTo(self.bgImgView.mas_trailing);
            make.bottom.mas_equalTo(self.bgImgView.mas_bottom);
        }];
    }
    return _bgTwoImgView;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_backBtn setImage:[UIImage imageNamed:@"alertBackImg"] forState:UIControlStateNormal];
        [_backBtn setTitle:@"礼物说明" forState:UIControlStateNormal];
        [_backBtn setTitleColor:RGBA(0, 0, 0, 1) forState:UIControlStateNormal];
        _backBtn.titleLabel.font=KFontBold(14);
        _backBtn.tag=100;
        _backBtn.layer.cornerRadius=KAdaptedWidth(25/2);
        _backBtn.layer.masksToBounds=YES;
        [_backBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(KAdaptedWidth(65));
            make.height.mas_equalTo(KAdaptedWidth(25));
            make.top.mas_equalTo(KAdaptedHeight(15));
            make.leading.mas_equalTo(KAdaptedWidth(15));
        }];
    }
    return _backBtn;
}

- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_moreBtn setImage:[UIImage imageNamed:@"moreImg"] forState:UIControlStateNormal];
        [_moreBtn setTitle:@"中奖记录" forState:UIControlStateNormal];
        [_moreBtn setTitleColor:RGBA(0, 0, 0, 1) forState:UIControlStateNormal];
        _moreBtn.titleLabel.font=KFontBold(14);
        _moreBtn.tag=200;
        _moreBtn.layer.cornerRadius=KAdaptedWidth(25/2);
        _moreBtn.layer.masksToBounds=YES;
        [_moreBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_moreBtn];
        [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.backBtn.mas_width);
            make.height.mas_equalTo(self.backBtn.mas_height);
            make.top.mas_equalTo(self.backBtn.mas_top);
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
        }];
    }
    return _moreBtn;
}

- (UIImageView*)titleImgView{
    if (!_titleImgView) {
        _titleImgView = [[UIImageView alloc] init];
        _titleImgView.image=[UIImage imageNamed:@"luckyGigtImg"];
        [self.bgView addSubview:_titleImgView];
        [_titleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bgImgView.mas_top).offset(KAdaptedHeight(10));
            make.centerX.mas_equalTo(KAdaptedWidth(0));
            make.height.mas_equalTo(KAdaptedHeight(40));
            make.width.mas_equalTo(KAdaptedWidth(145));

            
        }];
    }
    return _titleImgView;
}


- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = getLanguage(@"初级宝箱有机会抽中以下奖品");
        _tipLabel.textColor = RGBA(9, 28, 90, 1);
        _tipLabel.textAlignment=NSTextAlignmentCenter;
        _tipLabel.font=KFont(13);
        [self.bgView addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(KAdaptedHeight(0));
            make.height.mas_equalTo(KAdaptedWidth(20));
            make.top.mas_equalTo(self.titleImgView.mas_bottom).offset(KAdaptedHeight(5));
        }];
    }
    return _tipLabel;
}





- (UIView *)centerView{
    if (!_centerView) {
        _centerView = [[UIView alloc] init];

        [self addSubview:_centerView];
        [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(KAdaptedHeight(15));
            make.leading.mas_equalTo(self.bgImgView.mas_leading).offset(KAdaptedWidth(15));
            make.trailing.mas_equalTo(self.bgImgView.mas_trailing).offset(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedHeight(110));
        }];
    }
    return _centerView;
}



-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView=[[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.delegate=self;
        if (@available(iOS 11.0, *)) {//顶部留白
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _scrollView.showsVerticalScrollIndicator=NO;
        _scrollView.showsHorizontalScrollIndicator=NO;
//        _scrollView.scrollEnabled=YES;
//        _scrollView.pagingEnabled=YES;
        _scrollView.bounces=NO;
        _scrollView.layer.contents=(id)KGetImage(@"giftScrollViewBgImg").CGImage;
        [self.centerView addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(KAdaptedHeight(0));

        }];
    }
    return _scrollView;
}


- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        [self addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.centerView.mas_bottom).offset(KAdaptedHeight(10));
            make.leading.mas_equalTo(KAdaptedWidth(0));
            make.trailing.mas_equalTo(KAdaptedWidth(-0));
            make.bottom.mas_equalTo(KAdaptedHeight(-23)-DBottomDangerArea);
        }];
    }
    return _bottomView;
}

- (UIImageView*)ringImgView{
    if (!_ringImgView) {
        _ringImgView = [[UIImageView alloc] init];
        _ringImgView.image=[UIImage imageNamed:@"huanImg"];
        [self.bottomView addSubview:_ringImgView];
        [_ringImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(KAdaptedHeight(-10));
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(KAdaptedWidth(155));
            make.height.mas_equalTo(KAdaptedHeight(65));
            
        }];
    }
    return _ringImgView;
}

- (UIImageView*)bottomImgView{
    if (!_bottomImgView) {
        _bottomImgView = [[UIImageView alloc] init];
        _bottomImgView.image=[UIImage imageNamed:@"diZuoImg"];
        [self.bottomView addSubview:_bottomImgView];
        [_bottomImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(KAdaptedHeight(-10));
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(kWidth-KAdaptedWidth(120));
            make.top.mas_equalTo(KAdaptedHeight(0));
        }];
    }
    return _bottomImgView;
}


- (UIButton *)moneyBtn{
    if (!_moneyBtn) {
        _moneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moneyBtn.backgroundColor=RGBA(227, 227, 227, 0.35);
        [_moneyBtn setTitle:@"0" forState:UIControlStateNormal];
        [_moneyBtn setTitleColor:RGBA(207, 221, 248, 1) forState:UIControlStateNormal];
        _moneyBtn.titleLabel.font=KFontA(11);
        [_moneyBtn setImage:[UIImage imageNamed:@"coinSmallImg"] forState:UIControlStateNormal];
        _moneyBtn.userInteractionEnabled=NO;
        [self.bottomView addSubview:_moneyBtn];
        [_moneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(KAdaptedWidth(0));
            make.top.mas_equalTo(self.ringImgView.mas_bottom).offset(KAdaptedHeight(15));
            make.height.mas_equalTo(KAdaptedHeight(15));
            make.width.mas_equalTo(KAdaptedWidth(60));
            
        }];
        setViewCorner(_moneyBtn, KAdaptedHeight(15)/2);
    }
    return _moneyBtn;
}

- (EMO_PrizeResultsView *)prizeResultView{
    if (!_prizeResultView) {
        _prizeResultView = [[EMO_PrizeResultsView alloc] init];
        _prizeResultView.backgroundColor = RGBA(0, 0, 0, 0.52);
        [self addSubview:_prizeResultView];
        [_prizeResultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(0);
        }];
    }
    return _prizeResultView;
}






#pragma mark -水平模式
/**
 *  @brief 水平显示
 */
-(void)showAdHorizontally{
    
    NSMutableArray *arrayFromService  = [NSMutableArray array];
    int i=0;
    for (NSString *text in self.imgArr) {
        HeroModel *hero = [HeroModel new];
        hero.imageName = text;
        hero.fuDaiID=[NSString stringWithFormat:@"%@",self.idArr[i]];
        hero.introduction = [NSString stringWithFormat:@"%@",self.titleArr[i]];
        i++;
        [arrayFromService addObject:hero];
    }
    
    SCAdView *adView = [[SCAdView alloc] initWithBuilder:^(SCAdViewBuilder *builder) {
        builder.adArray = arrayFromService;
        builder.viewFrame = (CGRect){KAdaptedWidth(20),-20,kWidth-KAdaptedWidth(40),KAdaptedHeight(170)};
        builder.adItemSize = (CGSize){kWidth/2.5f,kWidth/4.f};
        builder.minimumLineSpacing = -20;
        builder.secondaryItemMinAlpha = 0.6;
//        builder.threeDimensionalScale = 1.45;
        builder.threeDimensionalScale = 1.5;
        builder.itemCellNibName = @"SCAdDemoCollectionViewCell";
    }];
    adView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0];
    adView.delegate = self;
    _adView = adView;
    [self.bottomView addSubview:adView];

}
#pragma mark -delegate

-(void)sc_didClickAd:(id)adModel{
    NSLog(@"sc_didClickAd-->%@",adModel);
    if ([adModel isKindOfClass:[HeroModel class]]) {
        HeroModel *model=(HeroModel*)adModel;
        NSLog(@"%@",((HeroModel*)adModel).introduction);
        
        WeakSelf;
        [NetworkRequest POST:Request_Lottery parmeters:@{@"status":@"0",@"box_id":model.fuDaiID} success:^(id responObject) {
            BaseModel *basemodel=(BaseModel *)responObject;
            NSLog(@"BBB=%@",basemodel.data);
            NSDictionary *dataDic = [[NSDictionary alloc] initWithDictionary:basemodel.data];
            wself.prizeResultView.hidden=NO;
            wself.prizeResultView.type=2;
            wself.prizeResultView.arrData=dataDic[@"list"];
            wself.prizeResultView.priceLabel.text = @"";// [NSString stringWithFormat:@"总价值:%@",dataDic[@"total_gift_money"]];
        } failture:^(NSError *error) {
            
        }];
    }
}

-(void)sc_scrollToIndex:(NSInteger)index{
    NSLog(@"sc_scrollToIndex-->%ld",index);
    _tipLabel.text = [NSString stringWithFormat:@"%@%@",self.titleArr[index],getLanguage(@"有机会抽中以下奖品")];
    [self addData:self.shopArr[index]];

}

-(void)addData:(RoomFuDaiModel *)fuDaiModel{
    
    [NetworkRequest POST:Request_GetBoxInfo parmeters:@{@"box_id":fuDaiModel.fuDaiID} success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        NSArray *arr=basemodel.data[@"box_gift_list"];
        [self.scrollView removeAllSubviews];
            for (int i=0; i<arr.count; i++) {
                BlessingBagGiftView *burtton = [[BlessingBagGiftView alloc] init];
                burtton.dicData=arr[i];
                burtton.frame=CGRectMake(KAdaptedWidth(20+80*i), KAdaptedHeight(10), KAdaptedWidth(50), KAdaptedHeight(85));
                [self.scrollView addSubview:burtton];
            }
        self.scrollView.contentSize=CGSizeMake(KAdaptedWidth(20)+80*arr.count, KAdaptedHeight(110));
        
    } failture:^(NSError *error) {
        
        
    }];
    
    
}

-(void)tipData{
    [NetworkRequest POST:Request_AppText parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        NSDictionary *dic =baseModel.data[6];
                self.tipStr=[Common isNull:dic[@"content"]];
//        self.tipStr=getLanguage(@"1.这里是内容，不知道写点啥这里是内容2.不知道写点啥这里是内容不知道写点啥这里是内容3.不知道写点这里是内容，不知道写点啥这里是道写点啥这里是内容不知道写点啥这里是内容不知道写点1.这里是内容，不知道写点啥这里是内容           2.不知道写点啥这里是内容不知道写点啥这里是内容3.不知道写点这里是内容，不知道写点啥这里是道写点啥这里是内容不知道写点啥这里是内容不知道写点");;
    } failture:^(NSError *error) {
        
        
    }];
}











@end
