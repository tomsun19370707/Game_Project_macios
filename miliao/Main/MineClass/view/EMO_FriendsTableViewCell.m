//
//  EMO_FriendsTableViewCell.m
//  miliao
//
//  Created by 张世浩 on 2022/10/15.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_FriendsTableViewCell.h"

@interface EMO_FriendsTableViewCell()

Strong UIImageView *headImgView;
Strong UILabel *liveLabel;
Strong UILabel *nameLabel;
Strong UIView *lineView;



@end


@implementation EMO_FriendsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self headImgView];
        [self liveLabel];
        [self nameLabel];
        [self IDLabel];
        [self relieveBtn];
//        [self lineView];
        
    }
    
    return self;
}

//-(void)setHidden:(BOOL)hidden{
//    _hidden=hidden;
//    self.relieveBtn.hidden=YES;
//}

-(void)setDicData:(NSDictionary *)dicData{
    
    if (![dicData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    _dicData=dicData;

    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"avatar"]]] placeholderImage:KGetImage(@"未加载头像")];
    if([dicData[@"is_open_room"] integerValue]==1){
        self.liveLabel.hidden=NO;
    }else{
        self.liveLabel.hidden=YES;
    }
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@  ",dicData[@"nickname"]];
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_nameLabel.text];
//    NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
//    attchment.bounds=CGRectMake(5,-2,15,15);//设置frame
//    if ([dicData[@"sex"] integerValue]==1) {
//        attchment.image=[UIImage imageNamed:@"manImg1"];//设置图片
//    }else{
//        attchment.image=[UIImage imageNamed:@"womanImg1"];//设置图片
//    }
//
//    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(attchment)];
//    [attributedString appendAttributedString:string]; //添加到尾部
//    self.nameLabel.attributedText = attributedString;
    
//    self.IDLabel.text = [NSString stringWithFormat:@"ID:%@",dicData[@"id"]];
    self.IDLabel.text = [NSString stringWithFormat:@"%@",dicData[@"bio"]];
    if(self.IDLabel.text.length<1){
        self.IDLabel.text=@"暂无";
    }
//    if ([dicData[@"type"] integerValue]==3) {
//        if ([dicData[@"is_attention"] integerValue]==0) {
//            self.relieveBtn.backgroundColor=RGBA(255, 238, 1, 1);
//            [self.relieveBtn setTitle:getLanguage(@"关注") forState:UIControlStateNormal];
//            [self.relieveBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
//            self.relieveBtn.layer.borderColor=RGBA(55, 171, 255, 0).CGColor;
//        }else
            if([dicData[@"is_attention"] integerValue]==1){
            self.relieveBtn.backgroundColor=kClearColor;
            [self.relieveBtn setTitle:getLanguage(@"互相关注") forState:UIControlStateNormal];
            [self.relieveBtn setTitleColor:BaseMainColor forState:UIControlStateNormal];
            self.relieveBtn.layer.borderColor=BaseMainColor.CGColor;
        }
        else{
            if(self.indexType==200){
                self.relieveBtn.backgroundColor=kClearColor;
                [self.relieveBtn setTitle:getLanguage(@"取消关注") forState:UIControlStateNormal];
                [self.relieveBtn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
                self.relieveBtn.layer.borderColor=RGBA(155, 155, 155, 0.16).CGColor;
            }else{
                self.relieveBtn.backgroundColor=RGBA(255, 238, 1, 1);
               [self.relieveBtn setTitle:getLanguage(@"关注") forState:UIControlStateNormal];
               [self.relieveBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
               self.relieveBtn.layer.borderColor=RGBA(55, 171, 255, 0).CGColor;
            }
            
        }
    
//
//    }else{
//        [_relieveBtn setTitle:getLanguage(@"互相关注") forState:UIControlStateNormal];
//        [_relieveBtn setTitleColor:RGBA(34, 34, 34, 1) forState:UIControlStateNormal];
//        _relieveBtn.layer.borderColor=RGBA(34, 34, 34, 1).CGColor;
//         if ([dicData[@"type"] integerValue]==2){
//             [_relieveBtn setTitle:getLanguage(@"已关注") forState:UIControlStateNormal];
//        }
//    }
}

-(void)setIndexType:(NSInteger)indexType{
    _indexType=indexType;
    
    if (indexType==300) {
        [_relieveBtn setTitle:getLanguage(@"关注") forState:UIControlStateNormal];
        [_relieveBtn setTitleColor:RGBA(55, 171, 255, 1) forState:UIControlStateNormal];
        _relieveBtn.layer.borderColor=RGBA(55, 171, 255, 1).CGColor;
    }else{
        [_relieveBtn setTitle:getLanguage(@"互相关注") forState:UIControlStateNormal];
        [_relieveBtn setTitleColor:RGBA(34, 34, 34, 1) forState:UIControlStateNormal];
        _relieveBtn.layer.borderColor=RGBA(34, 34, 34, 1).CGColor;
         if (indexType==2){
             [_relieveBtn setTitle:getLanguage(@"已关注") forState:UIControlStateNormal];
        }
    }
    
    
    
    
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

- (UILabel *)liveLabel{
    if (!_liveLabel) {
        _liveLabel = [[UILabel alloc] init];
        _liveLabel.backgroundColor=BaseMainColor;
        _liveLabel.text = getLanguage(@"直播中");
        _liveLabel.textColor = RGBA(51, 51, 51, 1);
        _liveLabel.font=KFont(11);
        _liveLabel.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:_liveLabel];
        [_liveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headImgView.mas_bottom).offset(KAdaptedHeight(-10));
            make.height.mas_equalTo(KAdaptedHeight(16));
            make.leading.mas_equalTo(self.headImgView.mas_leading).offset(KAdaptedWidth(2));
            make.trailing.mas_equalTo(self.headImgView.mas_trailing).offset(KAdaptedWidth(-2));
            
        }];
        setViewCorner(_liveLabel, KAdaptedHeight(8));
    }
    return _liveLabel;
}





- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = getLanguage(@"昵称");
        _nameLabel.textColor = RGBA(34, 34, 34, 1);
        _nameLabel.font=KFont(14);
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_nameLabel.text];
        NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
        attchment.bounds=CGRectMake(5,-2,15,15);//设置frame
            attchment.image=[UIImage imageNamed:@"manImg1"];//设置图片
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(attchment)];
        [attributedString appendAttributedString:string]; //添加到尾部
        _nameLabel.attributedText = attributedString;
        
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headImgView.mas_top);
            make.bottom.mas_equalTo(self.headImgView.mas_centerY).offset(KAdaptedWidth(0));
            make.leading.mas_equalTo(self.headImgView.mas_trailing).offset(KAdaptedWidth(9.5));
            make.trailing.mas_equalTo(KAdaptedWidth(-100));
            
        }];
    }
    return _nameLabel;
}

- (UILabel *)IDLabel{
    if (!_IDLabel) {
        _IDLabel = [[UILabel alloc] init];
        _IDLabel.text = getLanguage(@"ID:");
        _IDLabel.textColor = RGBA(153, 153, 153, 1);
        _IDLabel.font=KFont(12);
        [self.contentView addSubview:_IDLabel];
        [_IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom);
            make.bottom.mas_equalTo(self.headImgView.mas_bottom).offset(KAdaptedWidth(0));
            make.leading.mas_equalTo(self.nameLabel.mas_leading).offset(KAdaptedWidth(0));
            make.trailing.mas_equalTo(self.nameLabel.mas_trailing);
            
        }];
    }
    return _IDLabel;
}



- (UIButton *)relieveBtn{
    if (!_relieveBtn) {
        _relieveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _relieveBtn.backgroundColor=RGBA(101, 190, 255, 1);
        [_relieveBtn setTitle:getLanguage(@"互相关注") forState:UIControlStateNormal];
        [_relieveBtn setTitleColor:RGBA(34, 34, 34, 1) forState:UIControlStateNormal];
        _relieveBtn.titleLabel.font=KFont(13);
        _relieveBtn.layer.cornerRadius=KAdaptedHeight(14);
        _relieveBtn.layer.masksToBounds=YES;
        _relieveBtn.layer.borderColor=RGBA(34, 34, 34, 1).CGColor;
        _relieveBtn.layer.borderWidth=KAdaptedWidth(0.5);
        [_relieveBtn addTarget:self action:@selector(BtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_relieveBtn];
        [_relieveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(KAdaptedWidth(-14.5));
            make.centerY.mas_equalTo(self.headImgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(68), KAdaptedHeight(28)));
            
        }];
    }
    return _relieveBtn;
}


- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGBA(238, 238, 238, 1);
        [self.contentView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(KAdaptedHeight(0));
            make.height.mas_equalTo(KAdaptedHeight(0.5));
            make.leading.mas_equalTo(KAdaptedWidth(14));
            make.trailing.mas_equalTo(KAdaptedWidth(-14));
    
        }];
    
    }
    return _lineView;
}



-(void)BtnClick{
    if (self.BtnBlock) {
        self.BtnBlock(self.dicData);
    }
    
    
    
}


@end
