//
//  EMO_GiftWallHeadView.m
//  miliao
//
//  Created by 张世浩 on 2022/10/15.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_GiftWallHeadView.h"

@interface EMO_GiftWallHeadView ()

Strong UIView *bgView;
Strong UILabel *NumLabel;
Strong UIButton *giftBtn;



@end


@implementation EMO_GiftWallHeadView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.backgroundColor= kClearColor;
    }
    return self;
}

- (void)initView{
    [self bgView];
    [self NumLabel];
    [self giftBtn];

    
    
}


-(void)hidenImg:(BOOL)hidenImg andGiftAllNum:(NSString *)giftNum{
    
    self.NumLabel.text = [NSString stringWithFormat:@"%@\n\n%@",giftNum,getLanguage(@"礼物总数")];

    NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc]initWithString:self.NumLabel.text];
//        字符串分割判断
    [AttributedStr1 addAttribute:NSForegroundColorAttributeName value:RGBA(34, 34, 34, 1) range:NSMakeRange(0,giftNum.length+1)];
    [AttributedStr1 addAttribute:NSForegroundColorAttributeName value:RGBA(102, 102, 102, 1) range:NSMakeRange(giftNum.length+1,AttributedStr1.length-giftNum.length-1)];
    [AttributedStr1 addAttribute:NSFontAttributeName value:KFontBold(18) range:NSMakeRange(0,giftNum.length+1)];
    [AttributedStr1 addAttribute:NSFontAttributeName value:KFont(13) range:NSMakeRange(giftNum.length+1,AttributedStr1.length-giftNum.length-1)];
    self.NumLabel.attributedText = AttributedStr1;
    
    
}



- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];

        _bgView.backgroundColor=kWhiteColor;
        _bgView.layer.cornerRadius=KAdaptedHeight(10);
        _bgView.layer.masksToBounds=YES;
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.top.mas_equalTo(KAdaptedHeight(15));
//            make.bottom.mas_equalTo(KAdaptedHeight(-50));
            make.height.mas_equalTo(KAdaptedHeight(90));
            
            
        }];
    }
    return _bgView;
}

- (UILabel *)NumLabel{
    if (!_NumLabel) {
        _NumLabel = [[UILabel alloc] init];
        _NumLabel.text = [NSString stringWithFormat:@"0\n\n%@",getLanguage(@"收到礼物")];
        _NumLabel.textColor = kBlackColor;
        _NumLabel.numberOfLines=0;
        _NumLabel.textAlignment=NSTextAlignmentCenter;
        NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc]initWithString:_NumLabel.text];
//        字符串分割判断
        [AttributedStr1 addAttribute:NSForegroundColorAttributeName value:RGBA(34, 34, 34, 1) range:NSMakeRange(0,5)];
        [AttributedStr1 addAttribute:NSForegroundColorAttributeName value:RGBA(102, 102, 102, 1) range:NSMakeRange(5,AttributedStr1.length-5)];
        [AttributedStr1 addAttribute:NSFontAttributeName value:KFontBold(20) range:NSMakeRange(0,5)];
        [AttributedStr1 addAttribute:NSFontAttributeName value:KFont(13) range:NSMakeRange(5,AttributedStr1.length-5)];
        _NumLabel.attributedText = AttributedStr1;
        [self.bgView addSubview:_NumLabel];
        [_NumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(0);
        }];
    }
    return _NumLabel;
}

- (UIButton *)giftBtn{
    if (!_giftBtn) {
        _giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_giftBtn setTitle:getLanguage(@"收到的礼物") forState:UIControlStateNormal];
        [_giftBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        _giftBtn.titleLabel.font=KFontA(14);
        [_giftBtn setImage:[UIImage imageNamed:@"giftIconImg"] forState:UIControlStateNormal];
        _giftBtn.userInteractionEnabled=NO;
        _giftBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [self addSubview:_giftBtn];
        [_giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.width.mas_equalTo(KAdaptedWidth(150));
            make.height.mas_equalTo(KAdaptedHeight(30));
            make.top.mas_equalTo(self.bgView.mas_bottom).offset(KAdaptedHeight(15));

        }];
        [_giftBtn setImagePositionWithType:SSImagePositionTypeLeft spacing:5];
    }
    return _giftBtn;
}



@end
