//
//  EMO_PrizeResultsView.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/26.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_PrizeResultsView.h"
#import "EMO_BtnView.h"
@interface EMO_PrizeResultsView ()

Strong UIView *bgView;
Strong UILabel *titleLabel;

Strong UIButton *agreenBtn;


@end

@implementation EMO_PrizeResultsView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.backgroundColor=[UIColor clearColor];
        self.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture)];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

- (void)singleTapGesture{
    self.hidden=YES;
//    [self removeFromSuperview];
}

-(void)initView{
    [self bgView];
    [self titleLabel];
    [self priceLabel];
    [self agreenBtn];
}


-(void)setType:(NSInteger)type{
    _type=type;
    if(type==2){
        [_bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedHeight(10));
        }];
    }
}


-(void)setArrData:(NSArray *)arrData{
    _arrData=arrData;
    
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(KAdaptedHeight(200)+KAdaptedHeight(100)*(floor(arrData.count/3)));
    }];
    [self.bgView layoutIfNeeded];
    
    for (EMO_BtnView *view in self.bgView.subviews) {
        if([view isKindOfClass:[EMO_BtnView class]]){
            [view removeFromSuperview];
        }
    }
    CGFloat margin_X = KAdaptedWidth(8);
    CGFloat margin_Y = KAdaptedHeight(8);
    CGFloat itemWidth = KAdaptedWidth(95);
    CGFloat itemHeight = KAdaptedWidth(95);
    int totalColumns = 3;
    // 初始化九宫格
    for (int index = 0; index < arrData.count; index++) {
        NSDictionary *model = arrData[index];
        int row = index / totalColumns;
        int col = index % totalColumns;
        CGFloat cellX =  col * (itemWidth + margin_X);
        CGFloat cellY = row * (itemHeight + margin_Y);
        
        EMO_BtnView *  gamrBtn = [[EMO_BtnView alloc] init];
        gamrBtn.frame  = CGRectMake(KAdaptedWidth(20)+cellX,KAdaptedHeight(75)+cellY, itemWidth, itemHeight);
        gamrBtn.imgTop=KAdaptedHeight(15);
        gamrBtn.labelBottom=KAdaptedHeight(-10);
        gamrBtn.layer.contents=(id)KGetImage(@"shopBgImg").CGImage;
        NSString *giftName = [Common isEmptyString:model[@"gift_name"]]==NO?model[@"gift_name"]:model[@"type_text"];
        gamrBtn.nameLabel.text=[NSString stringWithFormat:@"%@",giftName];
        if(self.type==2){
            [gamrBtn.iconImgView sd_setImageWithURL:[NSURL URLWithString:[Common isNull:model[@"gift_image"]]]];
        }else{
    //        type 0神秘 1头像框 2金币 3钻石
//            if([model[@"type"] integerValue]==0){
//                gamrBtn.iconImgView.image=KGetImage(@"giftIconImg2");
//            }else if ([model[@"type"] integerValue]==1){
//                [gamrBtn.iconImgView sd_setImageWithURL:[NSURL URLWithString:[Common isNull:model[@"dress_image"]]]];
//            }else if ([model[@"type"] integerValue]==2){
//                gamrBtn.iconImgView.image=KGetImage(@"giftIconImg6");
//                gamrBtn.nameLabel.text=[NSString stringWithFormat:@"%@%@",model[@"money"],model[@"type_text"]];
//            }else if ([model[@"type"] integerValue]==3){
//                gamrBtn.iconImgView.image=KGetImage(@"giftIconImg3");
//                gamrBtn.nameLabel.text=[NSString stringWithFormat:@"%@%@",model[@"price"],model[@"type_text"]];
//            }
            if ([model[@"type"] integerValue]==2){
                gamrBtn.iconImgView.image = KGetImage(@"giftIconImg6");
            }else if ([model[@"type"] integerValue]==3){
                gamrBtn.iconImgView.image = KGetImage(@"giftIconImg3");
            }else{
                [gamrBtn.iconImgView sd_setImageWithURL:[NSURL URLWithString:[Common isNull:model[@"dress_image"]]] placeholderImage:defaultionPhotoIcon];
            }
        }
            gamrBtn.ClickBtn.tag=index;
//        WeakSelf;
        gamrBtn.BtnBlock = ^(NSInteger tag) {
            
            
        };
        [self.bgView addSubview:gamrBtn];
        setViewCorner(gamrBtn, 10);
    }
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = RGBA(255, 255, 255, 0.9);
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedHeight(10));
        }];
        setViewCorner(_bgView, KAdaptedHeight(10));
    }
    return _bgView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = getLanguage(@"恭喜您抽中了以下奖品");
        _titleLabel.textColor = RGBA(51, 51, 51, 1);
        _titleLabel.textAlignment=NSTextAlignmentCenter;
        [_bgView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(10));
            make.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.height.mas_equalTo(KAdaptedHeight(30));
        }];
    }
    return _titleLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.text = getLanguage(@"总价值:");
        _priceLabel.textColor = RGBA(51, 51, 51, 1);
        _priceLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
        _priceLabel.textAlignment=NSTextAlignmentCenter;
        [_bgView addSubview:_priceLabel];
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(KAdaptedHeight(5));
            make.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.height.mas_equalTo(KAdaptedHeight(30));
        }];
    }
    return _priceLabel;
}


- (UIButton *)agreenBtn{
    if (!_agreenBtn) {
        _agreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreenBtn setTitle:getLanguage(@"确认") forState:UIControlStateNormal];
        [_agreenBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _agreenBtn.titleLabel.font=KFontA(14);
        _agreenBtn.layer.contents=(id)KGetImage(@"prizeGameBgImg").CGImage;
        [_agreenBtn addTarget:self action:@selector(singleTapGesture) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_agreenBtn];
        [_agreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(KAdaptedWidth(90));
            make.height.mas_equalTo(KAdaptedHeight(30));
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.bgView.mas_bottom).offset(KAdaptedHeight(20));
        }];
        setViewCorner(_agreenBtn, KAdaptedHeight(15));
    }
    return _agreenBtn;
}
@end
