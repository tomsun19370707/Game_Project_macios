//
//  EMO_CommentBottomView.m
//  MeetHer
//
//  Created by 张世浩 on 2023/2/16.
//

#import "EMO_CommentBottomView.h"

@interface EMO_CommentBottomView ()

Strong NSString *life_id;
@end


@implementation EMO_CommentBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

-(void)initView{
    [self bgView];
    [self commentBtn];
    [self likeBtn];
    [self collectBtn];

}



-(void)setModel:(MessageInfoModel *)model{
    _model=model;
    self.life_id=model.message_id;
    self.likeBtn.selected=model.is_like;
    self.collectBtn.selected=model.is_collect;
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%ld",model.like_num] forState:UIControlStateNormal];
//    [self.commentBtn setTitle:[NSString stringWithFormat:@"%ld",model.comment_num] forState:UIControlStateNormal];
    [self.collectBtn setTitle:[NSString stringWithFormat:@"%ld",model.collect_num] forState:UIControlStateNormal];
}


- (void)setLayout:(ZFTableViewCellLayout *)layout {
    _layout = layout;
    self.life_id=layout.data.message_id;
    self.likeBtn.selected=[self.layout.data.is_star boolValue];
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%@",layout.data.star_num] forState:UIControlStateNormal];
//    [self.commentBtn setTitle:[NSString stringWithFormat:@"%@",layout.data.comment_num] forState:UIControlStateNormal];
}






- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = kClearColor;
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(KAdaptedWidth(0));
            make.leading.mas_equalTo(KAdaptedWidth(14));
            make.trailing.mas_equalTo(KAdaptedWidth(-14));
        }];
    }
    return _bgView;
}

- (CustomeBtn *)reportBtn{
    if (!_reportBtn) {
        CustomeBtn *btn1 = [[CustomeBtn alloc]init];
        btn1.title = @"举报";
        btn1.image = IMAGE(@"er_dynamic_report_list");
        btn1.textColor = RGBA(157, 157, 157, 1);
        btn1.lableHeight = 20 ;
        btn1.iconWidth = 21 ;
        btn1.font = KFont(12);;
        btn1.type = CustomeBtnTypeLeftImageAndRightTitle;
        [btn1 sizeToFitForCurrentSetting];
        [self.bgView addSubview:btn1];
        [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(KAdaptedWidth(0));
            make.centerY.mas_equalTo(KAdaptedHeight(0));
            make.width.mas_equalTo(KAdaptedWidth(45));
            make.height.mas_equalTo(KAdaptedHeight(21));
        }];
        _reportBtn = btn1 ;
    }
    return _reportBtn;
}

- (UIButton *)commentBtn{
    if (!_commentBtn) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_commentBtn setTitle:getLanguage(@"0") forState:UIControlStateNormal];
//        _commentBtn.titleLabel.font=KFont(12);
//        [_commentBtn setTitleColor:RGBA(157, 157, 157, 1) forState:UIControlStateNormal];
        [_commentBtn setBackgroundImage:[UIImage imageNamed:@"er_dynamic_share"] forState:UIControlStateNormal];
//        _commentBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        [self.bgView addSubview:_commentBtn];
        [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.reportBtn.mas_leading).offset(KAdaptedWidth(-15));
            make.centerY.mas_equalTo(self.reportBtn.mas_centerY).offset(KAdaptedHeight(0));
//            make.width.mas_equalTo(KAdaptedWidth(45));
            make.width.mas_equalTo(KAdaptedWidth(21));
            make.height.mas_equalTo(KAdaptedHeight(21));
        }];
//        [_commentBtn setImagePositionWithType:SSImagePositionTypeLeft spacing:5];
    }
    return _commentBtn;
}



- (UIButton *)likeBtn{
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeBtn setTitle:getLanguage(@"0") forState:UIControlStateNormal];
        _likeBtn.titleLabel.font=KFont(12);
        [_likeBtn setTitleColor:RGBA(157, 157, 157, 1) forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"likeNormalImg"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"likeSelectImg"] forState:UIControlStateSelected];
       
        _likeBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        [self.bgView addSubview:_likeBtn];
        [_likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.commentBtn.mas_leading).offset(KAdaptedWidth(-15));
            make.centerY.mas_equalTo(self.commentBtn.mas_centerY).offset(KAdaptedHeight(0));
            make.width.mas_equalTo(KAdaptedWidth(45));
            make.height.mas_equalTo(KAdaptedHeight(25));
        }];
        [_likeBtn setImagePositionWithType:SSImagePositionTypeLeft spacing:5];
    }
    return _likeBtn;
}


- (UIButton *)collectBtn{
    if (!_collectBtn) {
        _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectBtn setTitle:getLanguage(@"0") forState:UIControlStateNormal];
        _collectBtn.titleLabel.font=KFont(12);
        [_collectBtn setTitleColor:RGBA(157, 157, 157, 1) forState:UIControlStateNormal];
        [_collectBtn setImage:[UIImage imageNamed:@"collectNormalImg"] forState:UIControlStateNormal];
        [_collectBtn setImage:[UIImage imageNamed:@"collectSelectImg"] forState:UIControlStateSelected];
        _collectBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        [self.bgView addSubview:_collectBtn];
        [_collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.likeBtn.mas_leading).offset(KAdaptedWidth(-15));
            make.centerY.mas_equalTo(self.commentBtn.mas_centerY).offset(KAdaptedHeight(0));
            make.width.mas_equalTo(KAdaptedWidth(45));
            make.height.mas_equalTo(KAdaptedHeight(25));
        }];
        [_collectBtn setImagePositionWithType:SSImagePositionTypeLeft spacing:5];
    }
    return _collectBtn;
}





-(void)setShowReport:(BOOL)showReport
{
    if (!showReport) {
        [self.reportBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0.0001);
        }];
    }
    
    self.reportBtn.hidden = !showReport ;
}



@end
