//
//  RecordTableCell.m
//  miliao
//
//  Created by 张世浩 on 2022/5/28.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "RecordTableCell.h"

@interface  RecordTableCell()

@property(nonatomic,strong) UIView * bgView;
@property(nonatomic,strong) UIImageView * iconImgView;
@property(nonatomic,strong) UILabel * nameLabel;
@property(nonatomic,strong) UILabel * timeLabel;


@end


@implementation RecordTableCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor=Color(1, 1, 1, 0);
        self.contentView.backgroundColor=Color(1, 1, 1, 0);
        [self bgView];
        [self iconImgView];
        [self timeLabel];
        [self nameLabel];
        
        
        
    }
    return self;
}


-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic=dataDic;

    if([dataDic[@"type"] integerValue]==0){
        self.nameLabel.text= [NSString stringWithFormat:@"%@",dataDic[@"gift_name"]];
        self.timeLabel.text = [Common isNull:dataDic[@"createtime"]];
        [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:[Common isNull:dataDic[@"gift_image"]]]];
    }else{
        self.nameLabel.text= [NSString stringWithFormat:@"%@%@",dataDic[@"price"],dataDic[@"status_text"]];
        self.timeLabel.text = [Common isNull:dataDic[@"createtime"]];
        if([dataDic[@"status"] integerValue]==0){
            self.iconImgView.image=KGetImage(@"giftIconImg6");
        }else if ([dataDic[@"status"] integerValue]==1){
            self.iconImgView.image=KGetImage(@"giftIconImg3");
        }else {
            if ([dataDic[@"status"] integerValue]==2){
                [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:[Common isNull:dataDic[@"gift_image"]]]];
            }else if ([dataDic[@"status"] integerValue]==3){
                [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:[Common isNull:dataDic[@"dress_image"]]]];
            }
            self.nameLabel.text= [NSString stringWithFormat:@"%@",dataDic[@"status_text"]];
        }

      
    }
    
    
}





- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
//        _bgView.backgroundColor =Color(31, 13, 91, 1);
//        _bgView.layer.cornerRadius=KAdaptedHeight(7);
//        _bgView.layer.masksToBounds=YES;
        [self.contentView addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.top.bottom.mas_equalTo(KAdaptedWidth(0));
        }];
    }
    return _bgView;
}


- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"2020-10-10 10:10:10";
        _timeLabel.textColor = Color(102, 102, 102, 1);
        _timeLabel.font=KFont(12);
        _timeLabel.textAlignment=NSTextAlignmentRight;
        [self.bgView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(KAdaptedWidth(120));
            make.trailing.mas_equalTo(self.bgView.mas_trailing);
            make.height.mas_equalTo(KAdaptedHeight(26));
            
        }];
    }
    return _timeLabel;
}


- (UIImageView*)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image=[UIImage imageNamed:@"未加载图片"];
        [self.bgView addSubview:_iconImgView];
        [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(0));
            make.centerY.mas_equalTo(self.bgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(40), KAdaptedWidth(40)));
            
        }];
    }
    return _iconImgView;
}


- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"名称";
        _nameLabel.textColor = Color(51, 51, 51, 1);
        _nameLabel.font=KFont(13);
        _nameLabel.textAlignment=NSTextAlignmentLeft;
        [self.bgView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.iconImgView.mas_trailing).offset(KAdaptedWidth(15));
            make.centerY.mas_equalTo(self.bgView.mas_centerY);
            make.trailing.mas_equalTo(self.timeLabel.mas_leading);
            make.height.mas_equalTo(KAdaptedHeight(26));
            
        }];
    }
    return _nameLabel;
}





@end
