//
//  ZFTableViewCell.m
//  ZFPlayer
//
//  Created by 紫枫 on 2018/4/3.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import "ZFTableViewCell.h"
#import "UIImageView+ZFCache.h"
#import "EMO_CommentBottomView.h"
#import "CommentInfoModel.h"

@interface ZFTableViewCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIView *onLineView;
@property (nonatomic, strong) UILabel *nickNameLabel;
//@property (nonatomic, strong) UIButton *ageBtn;

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIView *fullMaskView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, weak) id<ZFTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UIView *effectView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property(nonatomic,strong)EMO_CommentBottomView *commentView;

@end

@implementation ZFTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.contentView.backgroundColor = RGBA(248, 248, 248, 1);
        self.backgroundColor=RGBA(0, 0, 0, 0);
        self.contentView.backgroundColor =kClearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self bgView];
        [self.bgView addSubview:self.headImageView];
        [self.bgView addSubview:self.onLineView];
        [self.bgView addSubview:self.nickNameLabel];
//        [self.bgView addSubview:self.ageBtn];
        [self.bgView addSubview:self.delBtn];
        [self.bgView addSubview:self.followBtn];
        [self.bgView addSubview:self.timeLabel];
        
        [self.bgView addSubview:self.bgImgView];
        [self.bgImgView addSubview:self.effectView];
        [self.bgView addSubview:self.coverImageView];
        [self.coverImageView addSubview:self.playBtn];
        [self.bgView addSubview:self.titleLabel];
        [self.bgView addSubview:self.fullMaskView];
        [self.coverImageView addGestureRecognizer:self.tapGesture];
        
        [self commentView];
        
    }
    return self;
}

-(void)TapPush{
    if(self.headImgClickBlock){
        self.headImgClickBlock();
    }
}


- (void)setLayout:(ZFTableViewCellLayout *)layout {
    _layout = layout;
    self.headImageView.frame = layout.headerRect;
    self.onLineView.frame=CGRectMake(layout.headerRect.origin.x+layout.headerRect.size.width-KAdaptedWidth(14), layout.headerRect.origin.y+layout.headerRect.size.height-KAdaptedWidth(10), KAdaptedWidth(8), KAdaptedWidth(8));
    self.nickNameLabel.frame = layout.nickNameRect;
//    self.ageBtn.frame=layout.ageRect;
    
    self.delBtn.frame=CGRectMake(kWidth-KAdaptedWidth(14+45+14), layout.ageRect.origin.y, KAdaptedWidth(45), KAdaptedWidth(45));
    
    self.followBtn.frame=CGRectMake(kWidth-KAdaptedWidth(14+70+14), layout.ageRect.origin.y, KAdaptedWidth(70), KAdaptedWidth(25));
    
    self.timeLabel.frame=layout.timeRect;
    self.coverImageView.frame = layout.videoRect;
    self.bgImgView.frame = layout.videoRect;
    self.effectView.frame = self.bgImgView.bounds;
    self.titleLabel.frame = layout.titleLabelRect;
    self.playBtn.frame = layout.playBtnRect;
    self.fullMaskView.frame = layout.maskViewRect;
    
//    [self.headImageView setImageWithURLString:[NSString stringWithFormat:@"%@%@",VERSION_HTTPS_SERVER,layout.data.user[@"avatar"]] placeholder:[UIImage imageNamed:@"未加载头像"]];
    [self.headImageView setImageWithURLString:[NSString stringWithFormat:@"%@",layout.data.user[@"avatar"]] placeholder:[UIImage imageNamed:@"未加载头像"]];
    
    
    if ([[Common isNullNumber:layout.data.user[@"is_show_online"]] integerValue]==0) {
        self.onLineView.hidden=NO;
        if([layout.data.user[@"is_line"] integerValue]==1){
            self.onLineView.backgroundColor=RGBA(8, 214, 139, 1);
        }else{
            self.onLineView.backgroundColor=[UIColor colorWithRed:0.72 green:0.72 blue:0.73 alpha:1.00];
        }
    }else{
        self.onLineView.hidden=YES;
    }
    
    
    
    if([layout.data.user_id integerValue]==[UserDefaultsGet(kUserID) integerValue]){
        self.delBtn.hidden=NO;
        self.followBtn.hidden=YES;
        self.onLineView.backgroundColor=RGBA(8, 214, 139, 1);
    }else{
        self.delBtn.hidden=YES;
        self.followBtn.hidden=NO;
        if((arc4random()%40)%2==0){
            CAGradientLayer *gl = [CAGradientLayer layer];
            gl.frame = CGRectMake(0,0,KAdaptedWidth(70), KAdaptedWidth(25));
            gl.startPoint = CGPointMake(0.5, 0);
            gl.endPoint = CGPointMake(0.5, 1);
            gl.colors = @[(__bridge id)RGBA(255, 255, 255, 1).CGColor,(__bridge id)RGBA(255, 255, 255, 1).CGColor];
            gl.locations = @[@(0.0),@(1.0f)];
            [self.followBtn.layer addSublayer:gl];
            [self.followBtn.layer insertSublayer:gl atIndex:1];
            [self.followBtn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
            [self.followBtn setTitle:getLanguage(@"取消关注") forState:UIControlStateNormal];
            self.followBtn.layer.borderColor=RGBA(155, 155, 155, 0.16).CGColor;
        }else{
            CAGradientLayer *gl = [CAGradientLayer layer];
            gl.frame = CGRectMake(0,0,KAdaptedWidth(70), KAdaptedWidth(25));
            gl.startPoint = CGPointMake(0.5, 0);
            gl.endPoint = CGPointMake(0.5, 1);
            gl.colors = @[(__bridge id)RGBA(247, 212, 91, 0.59).CGColor,(__bridge id)RGBA(255, 238, 1, 1).CGColor];
            gl.locations = @[@(0.0),@(1.0f)];
            [self.followBtn.layer addSublayer:gl];
            [_followBtn.layer insertSublayer:gl atIndex:1];
            [self.followBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
            [self.followBtn setTitle:getLanguage(@"关注") forState:UIControlStateNormal];
            self.followBtn.layer.borderColor=RGBA(155, 155, 155, 0).CGColor;
        }
        
        
    }
    
//    if ([[Common isNullNumber:layout.data.user[@"gender"]] integerValue]==0) {
//        self.ageBtn.layer.contents=(id)KGetImage(@"womanIconBgImg").CGImage;
//        [self.ageBtn setImage:KGetImage(@"womanIconImg") forState:UIControlStateNormal];
//    }else{
//        self.ageBtn.layer.contents=(id)KGetImage(@"manIconBgImg").CGImage;
//        [self.ageBtn setImage:KGetImage(@"manIconImg") forState:UIControlStateNormal];
//    }
//    [self.ageBtn setTitle:[NSString stringWithFormat:@" %@",[Common isNull:layout.data.user[@"age"]]] forState:UIControlStateNormal];
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?x-oss-process=video/snapshot,t_1000,f_jpg,w_375,h_375,m_fast",layout.data.imgs[0]]]];
    
    [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?x-oss-process=video/snapshot,t_1000,f_jpg,w_375,h_375,m_fast",layout.data.imgs[0]]]];
    

    self.nickNameLabel.text = [Common isNull:layout.data.user[@"nickname"]];
    self.titleLabel.text = layout.data.text;
    
    self.timeLabel.text=layout.data.createtime_text;
    
    self.commentView.layout=layout;
    


}

- (void)setDelegate:(id<ZFTableViewCellDelegate>)delegate withIndexPath:(NSIndexPath *)indexPath {
    self.delegate = delegate;
    self.indexPath = indexPath;
}

- (void)setNormalMode {
    self.fullMaskView.hidden = YES;
    self.titleLabel.textColor = [UIColor blackColor];
    self.nickNameLabel.textColor = [UIColor blackColor];
//    self.contentView.backgroundColor = RGBA(248, 248, 248, 1);
}

- (void)showMaskView {
    [UIView animateWithDuration:0.3 animations:^{
        self.fullMaskView.alpha = 1;
    }];
}

- (void)hideMaskView {
    [UIView animateWithDuration:0.3 animations:^{
        self.fullMaskView.alpha = 0;
    }];
}

- (void)playClick {
    if ([self.delegate respondsToSelector:@selector(zf_playTheVideoAtIndexPath:)]) {
        [self.delegate zf_playTheVideoAtIndexPath:self.indexPath];
    }
}

#pragma mark - getter


- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = kClearColor;
        _bgView.layer.cornerRadius=KAdaptedHeight(10);
        _bgView.layer.masksToBounds=YES;
        [self.contentView addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(KAdaptedHeight(0));
            make.bottom.mas_equalTo(KAdaptedHeight(-10));
        }];
    }
    return _bgView;
}


- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"playVideoImg"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIView *)fullMaskView {
    if (!_fullMaskView) {
        _fullMaskView = [UIView new];
        _fullMaskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        _fullMaskView.userInteractionEnabled = NO;
    }
    return _fullMaskView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = KFont(14);
    }
    return _titleLabel;
}

- (UILabel *)nickNameLabel {
    if (!_nickNameLabel) {
        _nickNameLabel = [UILabel new];
        _nickNameLabel.textColor = RGBA(34, 34, 34, 1);
        _nickNameLabel.font = KFontBold(15);
    }
    return _nickNameLabel;
}


//- (UIButton *)ageBtn{
//    if (!_ageBtn) {
//        _ageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _ageBtn.layer.contents=(id)KGetImage(@"womanIconBgImg").CGImage;
//        [_ageBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
//        [_ageBtn setTitle:@"0" forState:UIControlStateNormal];
//        [_ageBtn setImage:KGetImage(@"womanIconImg") forState:UIControlStateNormal];
//        _ageBtn.titleLabel.font=KFont(12);
//    }
//    return _ageBtn;
//}

- (UIButton *)delBtn{
    if (!_delBtn) {
        _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_delBtn setImage:KGetImage(@"delegateImg") forState:UIControlStateNormal];
        [_delBtn addTarget:self action:@selector(delDynamicBolck) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delBtn;
}


- (UIButton *)followBtn{
    if (!_followBtn) {
        _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0,0,KAdaptedWidth(70), KAdaptedWidth(25));
        gl.startPoint = CGPointMake(0.5, 0);
        gl.endPoint = CGPointMake(0.5, 1);
        gl.colors = @[(__bridge id)RGBA(247, 212, 91, 0.59).CGColor,(__bridge id)RGBA(255, 238, 1, 1).CGColor];
        gl.locations = @[@(0.0),@(1.0f)];
        [_followBtn.layer addSublayer:gl];
//        [_followBtn.layer insertSublayer:gl atIndex:1];
        [_followBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        [_followBtn setTitle:getLanguage(@"关注") forState:UIControlStateNormal];
        _followBtn.titleLabel.font=KFontA(13);
        [_followBtn addTarget:self action:@selector(delDynamicBolck) forControlEvents:UIControlEventTouchUpInside];
        _followBtn.layer.borderColor=RGBA(155, 155, 155, 0.16).CGColor;
        _followBtn.layer.borderWidth=1;
        _followBtn.layer.cornerRadius=KAdaptedHeight(25)/2;
        _followBtn.layer.masksToBounds=YES;
        
    }
    return _followBtn;
}





- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.textColor =RGBA(102, 102, 102, 1);
        _timeLabel.font = KFont(13);
        
    }
    return _timeLabel;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.userInteractionEnabled = YES;
        _headImageView.layer.cornerRadius=KAdaptedHeight(30);
        _headImageView.layer.masksToBounds=YES;
        [_headImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapPush)]];
    }
    return _headImageView;
}


- (UIView *)onLineView {
    if (!_onLineView) {
        _onLineView = [UIView new];
        _onLineView.backgroundColor=[UIColor colorWithRed:0.72 green:0.72 blue:0.73 alpha:1.00];
        _onLineView.layer.cornerRadius=KAdaptedWidth(8)/2;
        _onLineView.layer.masksToBounds=YES;
    }
    return _onLineView;
}


- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.tag = 8888;
        _coverImageView.clipsToBounds = YES;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coverImageView;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.userInteractionEnabled = YES;
        _bgImgView.layer.cornerRadius=KAdaptedHeight(10);
        _bgImgView.layer.masksToBounds=YES;
    }
    return _bgImgView;
}

- (UIView *)effectView {
    if (!_effectView) {
        if (@available(iOS 8.0, *)) {
            UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        } else {
            UIToolbar *effectView = [[UIToolbar alloc] init];
            effectView.barStyle = UIBarStyleBlackTranslucent;
            _effectView = effectView;
        }
    }
    return _effectView;
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playClick)];
    }
    return _tapGesture;
}


- (EMO_CommentBottomView *)commentView{
    if (!_commentView) {
        _commentView = [[EMO_CommentBottomView alloc] init];
        [_commentView.likeBtn addTarget:self action:@selector(likeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_commentView.commentBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_commentView.collectBtn addTarget:self action:@selector(commentMoreClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_commentView];
        [_commentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.height.mas_equalTo(KAdaptedHeight(50));
            make.bottom.mas_equalTo(KAdaptedHeight(-15));
        }];
    }
    return _commentView;
}




    
-(void)likeBtnClick{
    if (self.likeBtnClickBlock) {
        self.likeBtnClickBlock(self.commentView.likeBtn, self.commentView.likeBtn.selected,self.layout);
    }
}

-(void)commentBtnClick{
    if (self.CommentBtnClickBlock) {
        self.CommentBtnClickBlock(self.commentView.commentBtn,self.layout);
    }
}

-(void)commentMoreClick{
    if (self.MoreBtnClickBlock) {
        self.MoreBtnClickBlock();
    }
}

-(void)delDynamicBolck{
    if (self.delBtnClickBlock) {
        self.delBtnClickBlock(self.layout.data.message_id);
    }
}
    
    
    


@end
