//
//  EMO_CommentXQTableCell.m
//  MeetHer
//
//  Created by 张世浩 on 2023/2/17.
//

#import "EMO_CommentXQTableCell.h"

@interface EMO_CommentXQTableCell()
Strong NSDictionary *reportDic;
Strong UIView *bgView;
Strong UIImageView *headImgView;
Strong UILabel *nickLabel;
Strong UIButton *reportBtn;
Strong UILabel *commentLabel;
Strong UILabel *timeLabel;

Strong UIButton *likeBtn;

Assign NSInteger type;

@end


@implementation EMO_CommentXQTableCell

-(NSDictionary *)reportDic{
    if(!_reportDic){
        _reportDic=[NSDictionary dictionary];
    }
    return _reportDic;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self bgView];
        [self headImgView];
        [self nickLabel];
        [self reportBtn];
        [self timeLabel];
        [self commentLabel];
        [self likeBtn];
        
    }
    return self;
}




-(void)setModelDic:(NSMutableDictionary *)modelDic{
    _modelDic=modelDic;
    
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",modelDic[@"avatar"]]]placeholderImage:KGetImage(@"未加载头像")];
    self.timeLabel.text=[NSString stringWithFormat:@"%@",modelDic[@"createtime"]];
    CGFloat sizeWidth= 0.0;
    
    
    if([modelDic[@"commentType"] integerValue]==2){
        if ([modelDic.allKeys containsObject:@"to_comment_user_id"]) {
            self.nickLabel.text=[NSString stringWithFormat:@"%@回复%@",modelDic[@"nickname"],modelDic[@"to_comment_user_nickname"]];
            
        }else{
            self.nickLabel.text=[NSString stringWithFormat:@"%@",modelDic[@"nickname"]];
        }
        sizeWidth= kWidth-KAdaptedWidth(75+23+50);
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(50));
        }];
        [self.bgView layoutIfNeeded];
        
    }else{
        self.nickLabel.text=[NSString stringWithFormat:@"%@",modelDic[@"nickname"]];
        sizeWidth= kWidth-KAdaptedWidth(75+23);
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(0));
        }];
        [self.bgView layoutIfNeeded];
    }
    
    self.commentLabel.text=[NSString stringWithFormat:@"%@",modelDic[@"comment"]];
    
    if([modelDic[@"is_like"] integerValue]==1){
        self.likeBtn.selected=YES;
    }else{
        self.likeBtn.selected=NO;
    }
    [self.likeBtn setTitle:[Common isNull:modelDic[@"like_num"]] forState:UIControlStateNormal];
    
    if([modelDic[@"uid"] integerValue]==[[UserManager userInfo].user_id integerValue]){
        self.likeBtn.userInteractionEnabled=NO;
    }else{
        self.likeBtn.userInteractionEnabled=YES;
    }
    
    
    
    CGFloat widht= [self.nickLabel.text boundingRectWithSize:CGSizeMake(sizeWidth, CGFLOAT_MAX) font:KFont(13) lineSpacing:2.0].width;
    
    [self.nickLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(widht);
    }];
    

    
}











- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(0);
            
        }];
    }
    return _bgView;
}

- (UIImageView*)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        _headImgView.image=KGetImage(@"未加载头像");
        _headImgView.layer.cornerRadius=KAdaptedHeight(20);
        _headImgView.layer.masksToBounds=YES;
        [self.bgView addSubview:_headImgView];
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(KAdaptedHeight(40));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.top.mas_equalTo(KAdaptedHeight(10));
            
        }];
    }
    return _headImgView;
}

- (UILabel *)nickLabel{
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc] init];
        _nickLabel.text = @"昵称";
        _nickLabel.font=KFont(13);
        _nickLabel.textColor = RGBA(102, 102, 102, 1);
        [self.bgView addSubview:_nickLabel];
        [_nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headImgView.mas_top);
            make.leading.mas_equalTo(self.headImgView.mas_trailing).offset(KAdaptedWidth(10));
//            make.trailing.mas_equalTo(KAdaptedWidth(-23));
            make.width.mas_equalTo(KAdaptedWidth(100));
            make.height.mas_equalTo(KAdaptedHeight(15));
        }];
    }
    return _nickLabel;
}



- (UIButton *)reportBtn{
    if (!_reportBtn) {
        _reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reportBtn setImage:KGetImage(@"commentMoreImg") forState:UIControlStateNormal];
        _reportBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        [_reportBtn addTarget:self action:@selector(reportBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _reportBtn.tag=100;
        [self.bgView addSubview:_reportBtn];
        [_reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.nickLabel.mas_centerY);
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.width.mas_equalTo(KAdaptedWidth(40));
            make.height.mas_equalTo(KAdaptedHeight(25));
        }];
    }
    return _reportBtn;
}



- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"2022-10-29 20:00";
        _timeLabel.font=KFont(12);
        _timeLabel.textColor = RGBA(102, 102, 102, 1);
        [self.bgView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(KAdaptedHeight(15));
            make.leading.mas_equalTo(self.nickLabel.mas_leading).offset(KAdaptedWidth(0));
            make.trailing.mas_equalTo(KAdaptedWidth(-120));
            make.bottom.mas_equalTo(KAdaptedHeight(-10));
        }];
    }
    return _timeLabel;
}

- (UIButton *)likeBtn{
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeBtn setTitle:@"0" forState:UIControlStateNormal];
        [_likeBtn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
        [_likeBtn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateSelected];
        _likeBtn.titleLabel.font=KFontA(11);
        [_likeBtn setImage:[UIImage imageNamed:@"LikeNoImg"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"likeSelectImg"] forState:UIControlStateSelected];
        [_likeBtn addTarget:self action:@selector(reportBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _likeBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        _likeBtn.tag=200;
        _likeBtn.selected=NO;
        [self.bgView addSubview:_likeBtn];
        [_likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.timeLabel.mas_centerY);
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.width.mas_equalTo(KAdaptedWidth(100));
            make.height.mas_equalTo(KAdaptedHeight(25));
        }];
    }
    return _likeBtn;
}



- (UILabel *)commentLabel{
    if (!_commentLabel) {
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.text = @"评论";
        _commentLabel.numberOfLines=0;
        _commentLabel.font=KFont(14);
        _commentLabel.textColor = RGBA(0, 0, 0, 1);
        [self.bgView addSubview:_commentLabel];
        [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nickLabel.mas_bottom).offset(KAdaptedHeight(5));
            make.leading.mas_equalTo(self.nickLabel.mas_leading).offset(KAdaptedWidth(0));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.bottom.mas_equalTo(self.timeLabel.mas_top).offset(KAdaptedHeight(-5));
        }];
    }
    return _commentLabel;
}



-(void)reportBtnClick:(UIButton *)sender{

    if(self.BtnClick){
        self.BtnClick(self.modelDic, sender.tag);
    }
    
    
}








@end
