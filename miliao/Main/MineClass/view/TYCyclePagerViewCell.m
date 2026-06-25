//
//  TYCyclePagerViewCell.m
//  TYCyclePagerViewDemo
//
//  Created by tany on 2017/6/14.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYCyclePagerViewCell.h"

@interface TYCyclePagerViewCell ()
Strong UIView *topView;
Strong UIImageView *bgImgView;
Strong UIImageView *iconImgView;
Strong UILabel *titleOneLabel;

@end

@implementation TYCyclePagerViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
        [self addView];
    }
    return self;
}


- (void)addView {
    [self topView];
    [self bgImgView];
    [self iconImgView];
    [self titleOneLabel];
    
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    
    [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"bg_image"]]]];
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"image"]]]];
    self.titleOneLabel.text = [NSString stringWithFormat:@"%@等级",dicData[@"name"]];
    
    if([dicData[@"name"] isEqualToString:@"公爵"]){
        self.titleOneLabel.textColor = RGBA(206, 60, 1, 1);
    }else if ([dicData[@"name"] isEqualToString:@"伯爵"]){
        self.titleOneLabel.textColor = RGBA(255, 13, 187, 1);
    }else if ([dicData[@"name"] isEqualToString:@"国王"]){
        self.titleOneLabel.textColor = RGBA(155, 45, 0, 1);
    }else if ([dicData[@"name"] isEqualToString:@"帝王"]){
        self.titleOneLabel.textColor = RGBA(208, 48, 219, 1);
    }else if ([dicData[@"name"] isEqualToString:@"侯爵"]){
        self.titleOneLabel.textColor = RGBA(206, 60, 1, 1);
    }else if ([dicData[@"name"] isEqualToString:@"子爵"]){
        self.titleOneLabel.textColor = RGBA(110, 50, 220, 1);
    }
}


- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
//        _topView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(0));
            make.leading.mas_equalTo(KAdaptedWidth(0));
            make.trailing.mas_equalTo(KAdaptedWidth(-0));
            make.height.mas_equalTo(KAdaptedHeight(160));
        }];
    }
    return _topView;
}

- (UIImageView*)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.image=KGetImage(@"privilegeBGImgG");
        [self.topView addSubview:_bgImgView];
        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(0);
        }];
    }
    return _bgImgView;
}

- (UIImageView*)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image=KGetImage(@"jueweiBgImg");
        [self.topView addSubview:_iconImgView];
        [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(KAdaptedWidth(0));
            make.width.height.mas_equalTo(KAdaptedWidth(100));
            make.centerY.mas_equalTo(KAdaptedHeight(0));
        }];

    }
    return _iconImgView;
}

- (UILabel *)titleOneLabel{
    if (!_titleOneLabel) {
        _titleOneLabel = [[UILabel alloc] init];
        _titleOneLabel.text = getLanguage(@"公爵等级");
        _titleOneLabel.textColor = RGBA(206, 60, 1, 1);
        _titleOneLabel.font=KFontA(18);
        [self.topView addSubview:_titleOneLabel];
        [_titleOneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(KAdaptedHeight(0));
            make.leading.mas_equalTo(KAdaptedWidth(18));
            make.width.mas_equalTo(KAdaptedWidth(120));
            make.height.mas_equalTo(KAdaptedHeight(30));
        }];
    }
    return _titleOneLabel;
}


@end
