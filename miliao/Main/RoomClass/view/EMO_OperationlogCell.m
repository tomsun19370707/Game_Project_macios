//
//  EMO_OperationlogCell.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/10.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_OperationlogCell.h"

@interface EMO_OperationlogCell()

Strong UIImageView *headImgView;
Strong UILabel *nameLabel;
Strong UILabel *timLabel;



@end

@implementation EMO_OperationlogCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
     
        [self headImgView];
        [self nameLabel];
        [self timLabel];
        
    }
    return self;
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[Common isNull:dicData[@"avatar"]]]placeholderImage:KGetImage(@"未加载头像")];
    self.timLabel.text=[Common isNull:dicData[@"createtime"]];
    self.nameLabel.text=[Common isNull:dicData[@"memo"]];
    NSString *useName=[Common isNull:dicData[@"nickname"]];
    NSMutableAttributedString *attributedString=[[NSMutableAttributedString alloc] initWithString:self.nameLabel.text];
        [attributedString addAttribute:NSForegroundColorAttributeName value:RGBA(0, 0, 0, 1) range:NSMakeRange(0,useName.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:RGBA(153, 153, 153, 1) range:NSMakeRange(useName.length,self.nameLabel.text.length-useName.length)];
    _nameLabel.attributedText=attributedString;
    
}



- (UIImageView*)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        _headImgView.image=KGetImage(@"未加载头像");
        _headImgView.layer.cornerRadius=KAdaptedHeight(55)/2;
        _headImgView.layer.masksToBounds=YES;
        [self.contentView addSubview:_headImgView];
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(KAdaptedHeight(0));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.width.height.mas_equalTo(KAdaptedHeight(55));
            
        }];
    }
    return _headImgView;
}



- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = getLanguage(@"贴心小棉袄  打开1号麦");
        _nameLabel.textColor = RGBA(0, 0, 0, 1);
        _nameLabel.font=KFont(14);
        NSMutableAttributedString *attributedString=[[NSMutableAttributedString alloc] initWithString:_nameLabel.text];
            [attributedString addAttribute:NSForegroundColorAttributeName value:RGBA(0, 0, 0, 1) range:NSMakeRange(0,5)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:RGBA(153, 153, 153, 1) range:NSMakeRange(6,5)];
        _nameLabel.attributedText=attributedString;
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.headImgView.mas_centerY);
            make.leading.mas_equalTo(self.headImgView.mas_trailing).offset(KAdaptedWidth(10));
            make.top.mas_equalTo(self.headImgView.mas_top);
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            
        }];
    }
    return _nameLabel;
}


- (UILabel *)timLabel{
    if (!_timLabel) {
        _timLabel = [[UILabel alloc] init];
        _timLabel.text = getLanguage(@"2023-01-01");
        _timLabel.textColor = RGBA(153, 153, 153, 1);
        _timLabel.font=KFont(12);
        _timLabel.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:_timLabel];
        [_timLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.nameLabel.mas_leading).offset(KAdaptedWidth(0));
            make.trailing.mas_equalTo(self.nameLabel.mas_trailing);
            make.bottom.mas_equalTo(self.headImgView.mas_bottom);
            make.top.mas_equalTo(self.headImgView.mas_centerY);
        }];
    }
    return _timLabel;
}




@end
