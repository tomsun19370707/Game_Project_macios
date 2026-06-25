//
//  EMO_WMTimeLineHeaderView.m
//  WeChat
//
//  Created by zhengwenming on 2017/9/18.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import "EMO_WMTimeLineHeaderView.h"
#import "CopyAbleLabel.h"
#import "EMO_CommentBottomView.h"
@interface EMO_WMTimeLineHeaderView (){
    CGFloat commentBtnWidth;
    CGFloat commentBtnHeight;
    CGFloat MaxLabelHeight;
}

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIView *effectView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property(nonatomic,retain)UIView *bgView;
@property(nonatomic,retain)UIImageView *avatarIV;
@property(nonatomic,retain)UIView *onLineView;
@property(nonatomic,retain)UILabel *userNameLabel;
//@property(nonatomic,retain)UIButton *ageBtn;
//@property(nonatomic,retain)UIButton *followBtn;
@property(nonatomic,retain)UILabel *timeStampLabel;
@property(nonatomic,strong)CopyAbleLabel *messageTextLabel;
@property(nonatomic,retain)UIButton *commentBtn;
@property(nonatomic,retain)UIButton *moreBtn;
@property(nonatomic,assign)BOOL isExpandNow;
@property(nonatomic,assign)NSInteger headerSection;
@property(nonatomic,strong)JGGView *jggView;

//@property(nonatomic,strong)EMO_CommentBottomView *commentView;

@property(nonatomic,strong)UILabel *titleLabel;


/**
// *  评论按钮的block
// */
//@property (nonatomic, copy)void(^CommentBtnClickBlock)(UIButton *commentBtn,NSInteger headerSection);
//
///**
// *  更多按钮的block
// */
//@property (nonatomic, copy)void(^MoreBtnClickBlock)(UIButton *moreBtn,BOOL isExpand);

@end

@implementation EMO_WMTimeLineHeaderView


- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = RGBA(255, 255, 255, 1);
        
        self.bgView=[[UIView alloc] init];
        self.bgView.backgroundColor=kWhiteColor;
        self.bgView.layer.cornerRadius=KAdaptedHeight(10);
        self.bgView.layer.masksToBounds=YES;
        [self addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(KAdaptedHeight(0));
            make.bottom.mas_equalTo(KAdaptedHeight(-10));
        }];
        
        self.avatarIV = [[UIImageView alloc]initWithFrame:CGRectMake(kGAP, kGAP, kAvatar_Size, kAvatar_Size)];
        [self.bgView addSubview:self.avatarIV];
        self.avatarIV.layer.cornerRadius =kAvatar_Size/2;
        self.avatarIV.clipsToBounds = YES;
        self.avatarIV.userInteractionEnabled=YES;
        [self.avatarIV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapPush)]];
        self.onLineView=[[UIView alloc] initWithFrame:CGRectMake(kAvatar_Size+kGAP-KAdaptedWidth(14), kAvatar_Size+kGAP-KAdaptedWidth(10), KAdaptedWidth(8), KAdaptedWidth(8))];
        self.onLineView.backgroundColor=[UIColor colorWithRed:0.72 green:0.72 blue:0.73 alpha:1.00];
        self.onLineView.layer.cornerRadius=KAdaptedWidth(8)/2;
        self.onLineView.layer.masksToBounds=YES;
        [self.bgView addSubview:self.onLineView];
        
        
        self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.avatarIV.frame)+kGAP, kGAP,KAdaptedWidth(60), kAvatar_Size/2)];
        self.userNameLabel.font = KFontBold(15);
        self.userNameLabel.textColor = RGBA(34, 34, 34, 1);
        [self.bgView addSubview:self.userNameLabel];
        
//        self.ageBtn=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userNameLabel.frame)+kGAP, kGAP+KAdaptedHeight(7),KAdaptedWidth(45), KAdaptedHeight(16))];
//        self.ageBtn.layer.contents=(id)KGetImage(@"womanIconBgImg").CGImage;
//        [self.ageBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
//        [self.ageBtn setTitle:@"12" forState:UIControlStateNormal];
//        [self.ageBtn setImage:KGetImage(@"womanIconImg") forState:UIControlStateNormal];
//        self.ageBtn.titleLabel.font=KFont(12);
//        [self.bgView addSubview:self.ageBtn];
        
//        self.followBtn=[[UIButton alloc] initWithFrame:CGRectMake(kWidth-KAdaptedWidth(23+55), kGAP,KAdaptedWidth(55), KAdaptedHeight(25))];
//        CAGradientLayer *gl = [CAGradientLayer layer];
//        gl.frame = CGRectMake(0,0,KAdaptedWidth(55),KAdaptedHeight(25));
//        gl.startPoint = CGPointMake(0, 0);
//        gl.endPoint = CGPointMake(1, 1);
//        gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:58/255.0 blue:92/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:115/255.0 blue:142/255.0 alpha:1.0].CGColor];
//        gl.locations = @[@(0.0),@(1.0f)];
//        [self.followBtn.layer addSublayer:gl];
//        self.followBtn.layer.cornerRadius = KAdaptedHeight(25)/2;
//        self.followBtn.layer.masksToBounds=YES;
//        [self.followBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
//        [self.followBtn setTitle:getLanguage(@"关注") forState:UIControlStateNormal];
//        [self.followBtn addTarget:self action:@selector(follewBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        self.followBtn.titleLabel.font=KFont(12);
//        [self.bgView addSubview:self.followBtn];
        
        
        
        self.timeStampLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.avatarIV.frame)+kGAP, kGAP+self.avatarIV.frame.size.height/2,kScreenWidth-kAvatar_Size-2*kGAP-kGAP, self.avatarIV.frame.size.height/2)];
        self.timeStampLabel.font = KFont(13);
        self.timeStampLabel.textColor =RGBA(102, 102, 102, 1);
        [self.bgView addSubview:self.timeStampLabel];
        
        self.messageTextLabel = [[CopyAbleLabel alloc]init];
        self.messageTextLabel.numberOfLines = 0;
        self.messageTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.messageTextLabel.textColor=RGBA(34, 34, 34, 1);
        self.messageTextLabel.font = KFont(14);
        [self.bgView addSubview:self.messageTextLabel];
        
        commentBtnWidth = 60;
        commentBtnHeight = 22;
        MaxLabelHeight = 75.0;
        self.commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.commentBtn.backgroundColor = [UIColor whiteColor];
        [self.commentBtn setTitle:@"评论" forState:UIControlStateNormal];
        [self.commentBtn setTitle:@"评论" forState:UIControlStateSelected];
        [self.commentBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.commentBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.commentBtn.layer.borderWidth = 1;
        self.commentBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [self.commentBtn setImage:[UIImage imageNamed:@"commentBtn"] forState:UIControlStateNormal];
        [self.commentBtn setImage:[UIImage imageNamed:@"commentBtn"] forState:UIControlStateSelected];
        
        [self.commentBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:self.commentBtn];
        
        
        self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.moreBtn setTitle:@"全文" forState:UIControlStateNormal];
        [self.moreBtn setTitle:@"收起" forState:UIControlStateSelected];
        [self.moreBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.moreBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        self.moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [self.moreBtn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:self.moreBtn];
        self.isExpandNow = NO;
        self.jggView = [[JGGView alloc] init];
        [self.bgView addSubview:self.jggView];
        
        
        
        [self.bgView addSubview:self.effectView];
        [self.bgView addSubview:self.coverImageView];
        [self.coverImageView addSubview:self.playBtn];
        [self.coverImageView addGestureRecognizer:self.tapGesture];
        
        
        
//        self.commentView=[[EMO_CommentBottomView alloc] init];
//        [self.commentView.likeBtn addTarget:self action:@selector(likeBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [self.commentView.commentBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [_commentView.collectBtn addTarget:self action:@selector(commentMoreClick) forControlEvents:UIControlEventTouchUpInside];
//        [self.bgView addSubview:self.commentView];
//        [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.trailing.mas_equalTo(KAdaptedHeight(0));
//            make.height.mas_equalTo(KAdaptedHeight(50));
//            make.bottom.mas_equalTo(KAdaptedHeight(-15));
//        }];
//

        
        
        self.titleLabel = [[UILabel alloc]init];
//        self.titleLabel.text=getLanguage(@"评论");
        self.titleLabel.text=nil ;
        self.titleLabel.font = KFontBold(14);
        self.titleLabel.textColor =RGBA(34, 34, 34, 1);
        [self.bgView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(24));
            make.trailing.mas_equalTo(KAdaptedHeight(0));
            make.height.mas_equalTo(KAdaptedHeight(30));
//            make.bottom.mas_equalTo(self.commentView.mas_bottom);
            make.bottom.mas_equalTo(KAdaptedHeight(-5));
            
            
        }];
        
        
        UIView *lineView=[[UIView alloc] init];
        lineView.backgroundColor=RGBA(241, 241, 241, 1);
        [self.bgView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.titleLabel.mas_top).offset(KAdaptedHeight(-15));
            make.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.height.mas_equalTo(1);
            
        }];
        
        
    }
    return self;
}

-(void)TapPush{
    if(self.headImgClickBlock){
        self.headImgClickBlock();
    }
}


-(void)setModel:(MessageInfoModel *)model{
    _model=model;
    __weak __typeof(self) weakSelf= self;
    
    self.jggView.tapBlock = ^(NSInteger index, NSArray *dataSource) {
        if (weakSelf.tapImageBlock) {
            weakSelf.tapImageBlock(index, dataSource);
        }
    };
    NSString *headImgStr=[Common isNull:model.user[@"avatar"]];
    if(![headImgStr hasPrefix:@"http"]){
        headImgStr=[headImgStr stringByAppendingString:VERSION_HTTPS_SERVER];
    }
    [self.avatarIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",headImgStr]] placeholderImage:[UIImage imageNamed:@"未加载图片"]];
    self.userNameLabel.text = [Common isNull:model.user[@"nickname"]];
    self.timeStampLabel.text=[Common isNull:model.createtime_text];
    CGSize textWidth = [self.userNameLabel.text sizeWithFont:KFontBold(15) maxSize:CGSizeMake(kWidth-kAvatar_Size-kGAP*2-KAdaptedWidth(50), CGFLOAT_MAX)];
    self.userNameLabel.frame=CGRectMake(CGRectGetMaxX(self.avatarIV.frame)+kGAP, kGAP,textWidth.width, kAvatar_Size/2);
//    self.ageBtn.frame=CGRectMake(CGRectGetMaxX(self.userNameLabel.frame)+kGAP, kGAP+KAdaptedHeight(7),KAdaptedWidth(45), KAdaptedHeight(16));
//
//    if ([model.user[@"gender"] integerValue]==0) {
//        self.ageBtn.layer.contents=(id)KGetImage(@"womanIconBgImg").CGImage;
//        [self.ageBtn setImage:KGetImage(@"womanIconImg") forState:UIControlStateNormal];
//    }else{
//        self.ageBtn.layer.contents=(id)KGetImage(@"manIconBgImg").CGImage;
//        [self.ageBtn setImage:KGetImage(@"manIconImg") forState:UIControlStateNormal];
//    }
//    [self.ageBtn setTitle:[NSString stringWithFormat:@" %@",model.user[@"age"]] forState:UIControlStateNormal];
    
    
//    if ([model.is_follow integerValue]==0) {
//        [self.followBtn setTitle:getLanguage(@"关注") forState:UIControlStateNormal];
//    }else{
//        [self.followBtn setTitle:getLanguage(@"已关注") forState:UIControlStateNormal];
//    }
    
    if ([model.user[@"is_show_online"] integerValue]==0) {
        self.onLineView.hidden=NO;
        if([model.user[@"is_line"] integerValue]==1){
            self.onLineView.backgroundColor=RGBA(8, 214, 139, 1);
        }else{
            self.onLineView.backgroundColor=[UIColor colorWithRed:0.72 green:0.72 blue:0.73 alpha:1.00];
        }
    }else{
        self.onLineView.hidden=YES;
    }
    

//    if([model.user_id integerValue]==[UserDefaultsGet(kUserID) integerValue]){
//        self.followBtn.hidden=YES;
//        self.onLineView.backgroundColor=RGBA(8, 214, 139, 1);
//    }

    
    self.messageTextLabel.attributedText = model.mutablAttrStr;
    self.messageTextLabel.frame = model.textLayout.frameLayout;
    ///解决图片复用问题
    [self.jggView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    self.jggView.dataSource = model.imgs;
    
    NSString *imgName=[Common isNull:model.images];
    NSMutableArray *imgArr=[NSMutableArray array];
    if(imgName.length>0){
        for (NSString *ingUrl in model.image_arr) {
           
            [imgArr addObject:[NSString stringWithFormat:@"%@",ingUrl]];
        }
    }
    self.jggView.dataSource =imgArr;
    self.jggView.frame = model.jggLayout.frameLayout;
    
    
//    self.commentView.model=model;
    
//    if ([model.type isEqualToString:@"video"]) {
    if ([model.type integerValue]==2) {
        self.jggView.hidden=YES;
        self.effectView.frame=CGRectMake(model.textLayout.frameLayout.origin.x, CGRectGetMaxY(model.textLayout.frameLayout)+kGAP, KAdaptedWidth(210), KAdaptedHeight(255));
        self.coverImageView.frame=CGRectMake(model.textLayout.frameLayout.origin.x, CGRectGetMaxY(model.textLayout.frameLayout)+kGAP, KAdaptedWidth(210), KAdaptedHeight(255));
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?x-oss-process=video/snapshot,t_1000,f_jpg,w_375,h_375,m_fast",model.image_arr[0]]]placeholderImage:KGetImage(@"未加载图片")];
        self.playBtn.frame=CGRectMake(( CGRectGetWidth(self.coverImageView.frame)-KAdaptedWidth(44))/2,(CGRectGetHeight(self.coverImageView.frame)-KAdaptedWidth(44))/2, KAdaptedWidth(44), KAdaptedWidth(44));
    }else{
        self.jggView.hidden=NO;
    }
    
   
    
}


-(void)commentAction:(UIButton *)sender{
//    if (self.CommentBtnClickBlock) {
//        self.CommentBtnClickBlock(sender,self.headerSection);
//    }
}
-(void)moreAction:(UIButton *)sender{
//    if (self.MoreBtnClickBlock) {
//        self.MoreBtnClickBlock(sender,_isExpandNow);
//    }
}




-(void)likeBtnClick{
    
//    self.commentView.likeBtn.userInteractionEnabled = NO;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.commentView.likeBtn.userInteractionEnabled = YES;
//    });
//
    
//    [NetworkRequest POST:@"" parmeters:@{@"life_id":self.model.message_id} success:^(id responObject) {
//        BaseModel *baseModel = (BaseModel *)responObject;
//        NSLog(@"%@",baseModel.data);
//        if (self.likeBtnClickBlock) {
//            self.likeBtnClickBlock(self.commentView.likeBtn, self.commentView.likeBtn.selected);
//        }
//    }failture:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
   
}

-(void)commentBtnClick{
//    if (self.CommentBtnClickBlock) {
//        self.CommentBtnClickBlock(self.commentView.commentBtn);
//    }
}

-(void)sendMsgBtnClick{

}

-(void)commentMoreClick{
//    if (self.MoreBtnClickBlock) {
//        self.MoreBtnClickBlock();
//    }
}



- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"playVideoImg"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}


- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.tag = 8888;
        _coverImageView.clipsToBounds = YES;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
//        _coverImageView.layer.cornerRadius=KAdaptedHeight(10);
//        _coverImageView.layer.masksToBounds=YES;
    }
    return _coverImageView;
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
        _effectView.layer.cornerRadius=KAdaptedHeight(10);
        _effectView.layer.masksToBounds=YES;
    }
    return _effectView;
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playClick)];
    }
    return _tapGesture;
}


- (void)playClick {
    if(self.playCallback){
        self.playCallback(self.coverImageView);
    }
    
}


-(void)follewBtnClick{
   
    
//    [NetworkRequest POST:@"" parmeters:@{@"follow_user_id":[Common isNull:self.model.user_id]} success:^(id responObject) {
//        NSLog(@"%@",responObject);
//        BaseModel *baseModel = (BaseModel *)responObject;
//        if ([self.model.is_follow integerValue]==0) {
//            self.model.is_follow=@"1";
//            [self.followBtn setTitle:getLanguage(@"已关注") forState:UIControlStateNormal];
//        }else{
//            self.model.is_follow=@"0";
//            [self.followBtn setTitle:getLanguage(@"关注") forState:UIControlStateNormal];
//        }
//        [SVProgressHUD showImage:KGetImage(@"") status:[NSString stringWithFormat:@"%@",baseModel.msg]];
//    } failture:^(NSError *error) {
//        NSLog(@"%@",error);
//
//    }];
    
    
}



@end
