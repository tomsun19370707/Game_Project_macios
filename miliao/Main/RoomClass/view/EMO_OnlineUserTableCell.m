//
//  EMO_OnlineUserTableCell.m
//  miliao
//
//  Created by 张世浩 on 2022/10/25.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_OnlineUserTableCell.h"

@interface EMO_OnlineUserTableCell()
Strong UIImageView *headImgView;
Strong UILabel *nameLabel;


@end


@implementation EMO_OnlineUserTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self headImgView];
        [self nameLabel];
        
    }
    
    return self;
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"avatar"]]] placeholderImage:KGetImage(@"未加载头像")];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",dicData[@"nickname"]];
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.nameLabel.text];
//    NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
//    attchment.bounds=CGRectMake(5,-2,35,15);//设置frame
//        attchment.image=[UIImage imageNamed:@"meili_13"];//设置图片
//    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(attchment)];
//    [attributedString appendAttributedString:string]; //添加到尾部
//    self.nameLabel.attributedText = attributedString;
    
    
}



- (UIImageView*)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        _headImgView.image=KGetImage(@"未加载头像");
        _headImgView.layer.cornerRadius=KAdaptedWidth(53/2);
        _headImgView.layer.masksToBounds=YES;
        [self.contentView addSubview:_headImgView];
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(53), KAdaptedWidth(53)));
            make.leading.mas_equalTo(KAdaptedHeight(15.5));
            
        }];
    }
    return _headImgView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = getLanguage(@"昵称");
        _nameLabel.textColor = RGBA(34, 34, 34, 1);
        _nameLabel.font=KFont(14);
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_nameLabel.text];
//        NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
//        attchment.bounds=CGRectMake(5,-2,35,15);//设置frame
//            attchment.image=[UIImage imageNamed:@"meili_13"];//设置图片
//        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(attchment)];
//        [attributedString appendAttributedString:string]; //添加到尾部
//        _nameLabel.attributedText = attributedString;
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headImgView.mas_top);
            make.bottom.mas_equalTo(self.headImgView.mas_bottom).offset(KAdaptedWidth(0));
            make.leading.mas_equalTo(self.headImgView.mas_trailing).offset(KAdaptedWidth(9.5));
            make.trailing.mas_equalTo(KAdaptedWidth(-100));
            
        }];
    }
    return _nameLabel;
}


@end
