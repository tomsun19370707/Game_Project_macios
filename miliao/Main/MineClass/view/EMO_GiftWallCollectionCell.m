//
//  EMO_GiftWallCollectionCell.m
//  NormalProject
//
//  Created by 大靠山Mac mini on 2021/10/23.
//  Copyright © 2021 WYL. All rights reserved.
//

#import "EMO_GiftWallCollectionCell.h"

#import "EMO_GiftView.h"

@interface EMO_GiftWallCollectionCell()
@property (nonatomic,strong)UIImageView *headImageView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *seeNumLabel;

@property (nonatomic,strong)EMO_GiftView *giftView;


@end

@implementation EMO_GiftWallCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor=RGBA(242, 242, 242, 1);
        [self giftView];
        
//        [self headImageView];
//        [self nameLabel];
//        [self seeNumLabel];
    }
    
    return self;
    

}


- (EMO_GiftView *)giftView{
    if (!_giftView) {
        _giftView = [[EMO_GiftView alloc] init];
        _giftView.backgroundColor = RGBA(255, 255, 255, 1);
        _giftView.layer.cornerRadius=KAdaptedHeight(5);
        _giftView.layer.masksToBounds=YES;
        [self.contentView addSubview:_giftView];
        [_giftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(KAdaptedHeight(-7));
            
        }];
    }
    return _giftView;
}




-(UIImageView *)headImageView{
    
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc]init];
        _headImageView.image=KGetImage(@"bag_bxlw_xzlw");
        [self.contentView addSubview:_headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(KAdaptedHeight(0));
            make.top.mas_equalTo(KAdaptedHeight(15));
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(25), KAdaptedHeight(25)));
        }];
    }
    return _headImageView;
    
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text =@"礼物名";
        _nameLabel.textColor = RGB(102, 102, 102);
        _nameLabel.font = KFontBold(11);
        _nameLabel.numberOfLines=0;
        _nameLabel.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headImageView.mas_top).offset(KAdaptedHeight(3));
            make.trailing.mas_equalTo(KAdaptedWidth(-5));
            make.leading.mas_equalTo(self.headImageView.mas_trailing).offset(KAdaptedWidth(15));
            make.height.mas_equalTo(KAdaptedWidth(20));
        }];
    }
    return _nameLabel;
}
- (UILabel *)seeNumLabel{
    if (!_seeNumLabel) {
        
        _seeNumLabel = [[UILabel alloc] init];
        _seeNumLabel.textColor=RGBA(153, 153, 153, 1);
        _seeNumLabel.text=@"x10";
        _seeNumLabel.font=KFont(9);
        _seeNumLabel.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:_seeNumLabel];
        [_seeNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(KAdaptedWidth(3));
            make.trailing.mas_equalTo(self.nameLabel.mas_trailing);
            make.leading.mas_equalTo(self.nameLabel.mas_leading);
            make.height.mas_equalTo(self.nameLabel.mas_height);
        }];
    }
    return _seeNumLabel;
}

-(void)setBackDicData:(NSDictionary *)BackDicData{
    _BackDicData=BackDicData;
    self.giftView.BackDicData=BackDicData;
}


-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    self.giftView.diData=dicData;
    
    
//    WeakSelf(ws);
//    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"icon"]]] placeholderImage:KGetImage(@"") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        NSLog(@"AAA===%@,%ld,%@",error,(long)cacheType,imageURL);
//        if (error) {
////            ws.headImageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"icon"]]]]];
//        }
//
//    }];
    
    
    
//    _nameLabel.text=[NSString stringWithFormat:@"%@",dicData[@"name"]];
//    _seeNumLabel.text=[NSString stringWithFormat:@"x%@",dicData[@"count"]];
}

@end
