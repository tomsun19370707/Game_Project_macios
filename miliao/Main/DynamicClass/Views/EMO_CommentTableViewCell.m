//
//  EMO_CommentTableViewCell.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/17.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_CommentTableViewCell.h"

@interface EMO_CommentTableViewCell ()
Strong UIView *bgView;
Strong UILabel *contentLabel;


@end

@implementation EMO_CommentTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self bgView];
        [self contentLabel];
        
    }
    return self;
}


-(void)setDicData:(NSMutableDictionary *)dicData{
    _dicData=dicData;
    NSString *nameStr=[NSString string];
    NSString *contentStr=[Common isNull:dicData[@"comment"]];
    if([dicData.allKeys containsObject:@"to_comment_user_id"]){
        nameStr=[NSString stringWithFormat:@"%@回复%@:",dicData[@"nickname"],dicData[@"to_comment_user_nickname"]];
    }else{
        nameStr=[NSString stringWithFormat:@"%@:",dicData[@"nickname"]];
    }
    self.contentLabel.text=[NSString stringWithFormat:@"%@%@",nameStr,contentStr];
    NSMutableAttributedString *attributedString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.contentLabel.text]];
        [attributedString addAttribute:NSForegroundColorAttributeName value:RGBA(102, 102, 102, 1) range:NSMakeRange(0,nameStr.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:RGBA(51, 51, 51, 1) range:NSMakeRange(nameStr.length,contentStr.length)];
    [attributedString addAttribute:NSFontAttributeName value:KFont(12) range:NSMakeRange(0,self.contentLabel.text.length)];
    self.contentLabel.attributedText=attributedString;
    
    
    
    
}







- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = RGBA(248, 248, 248, 1);
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(KAdaptedWidth(0));
            make.leading.mas_equalTo(KAdaptedWidth(63));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
        }];
        setViewCorner(_bgView, KAdaptedHeight(5));
    }
    return _bgView;
}







- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.text = @"内容";
        _contentLabel.font=KFontA(14);
        _contentLabel.textColor = RGBA(0, 0, 0, 1);
        _contentLabel.numberOfLines=0;
        [self.bgView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(5));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.bottom.mas_equalTo(KAdaptedHeight(-5));
        }];
    }
    return _contentLabel;
}




@end
