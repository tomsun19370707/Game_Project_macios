//
//  EMO_UserInfoView.m
//  miliao
//
//  Created by 张世浩 on 2022/10/21.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_UserInfoView.h"
#import "EMO_BtnView.h"
#import "MLRoomUserModel.h"
#import "WZBGradualLabel.h"
#import "MLSessionViewController.h"
@interface EMO_UserInfoView()
@property(nonatomic, strong) UIView *mengbanView;//透明蒙版
@property(nonatomic, strong) UIView *whiteView;//白色背景
@property(nonatomic, strong) UIImageView *bgImgView;//背景IMG

@property(nonatomic, strong) UIButton *reportBtn;//举报
@property(nonatomic, strong) UIImageView *headImgView;//头像
@property(nonatomic, strong) UILabel *nameLabel;//昵称
@property(nonatomic, strong) UIButton *ageBtn;//年龄
@property(nonatomic, strong) UIButton *constellationBtn;//星座
@property(nonatomic, strong) UIImageView *gongxianImgView;//贡献等级
@property(nonatomic, strong) UIImageView *meiLiImgView;//魅力等级
Strong WZBGradualLabel *IDColorLabel;
@property(nonatomic, strong) UIButton *IDLabel;//IDlabel
//@property(nonatomic, strong) UIButton *btnCopy;//复制/
@property(nonatomic, strong) UILabel *introductionLabel;//个性签名

@property(nonatomic,strong) UIScrollView * scrollView;//技能

@property(nonatomic, strong) EMO_BtnView *meiliBtn;//魅力值Btn
@property(nonatomic, strong) EMO_BtnView *biMaiBtn;//闭麦Btn
@property(nonatomic, strong) EMO_BtnView *jinYanBtn;//禁言Btn
@property(nonatomic, strong) EMO_BtnView *getOutBtn;//踢出房间Btn
@property(nonatomic, strong) EMO_BtnView *xiaMaiBtn;//下麦Btn


@property(nonatomic, strong) UIButton *guanZhuBtn;//关注Btn
@property(nonatomic, strong) UIButton *messageBtn;//消息Btn
@property(nonatomic, strong) UILabel *messageNum;//消息数
@property(nonatomic, strong) UIButton *personBtn;//@人Btn
@property(nonatomic, strong) UIView *lineView;
@property(nonatomic, strong) UIButton *giftBtn;//送礼物Btn
@property(nonatomic, assign) float spacing;
@end


@implementation EMO_UserInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.spacing = (kScreenWidth - 55*4)/5;
        [self initView];
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}
-(void)initView{
    [self mengbanView];
    [self whiteView];
    [self bgImgView];
    [self reportBtn];
    [self headImgView];
    [self nameLabel];
    [self ageBtn];
    [self constellationBtn];
    [self gongxianImgView];
    [self meiLiImgView];
    
    [self IDLabel];
//    [self btnCopy];
    [self introductionLabel];
    
    [self scrollView];
    
    [self getOutBtn];
    [self jinYanBtn];
    [self biMaiBtn];
    [self xiaMaiBtn];
    [self meiliBtn];
    
    [self guanZhuBtn];
    [self messageBtn];
    [self giftBtn];
    [self personBtn];
    [self lineView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:@"UpDataMessage" object:nil];
    
}

#pragma mark ======================  数据处理   ======================
- (void)setModel:(MLRoomUserModel *)model{
    _model = model;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:ImageNamed(@"default_userIcon")];
    
    self.nameLabel.text=[NSString stringWithFormat:@"%@",model.nickname];
    
    self.introductionLabel.text =[NSString stringWithFormat:@"%@",model.bio];
    
    
    [self.IDColorLabel removeFromSuperview];
    if (([model.uuid integerValue]>0)&&([model.uuid integerValue]!=[model.userID integerValue])) {
        self.IDColorLabel= [WZBGradualLabel gradualLabelWithFrame:(CGRect){15, 0, 80, 15} title:[NSString stringWithFormat:@"ID:%@",model.uuid] duration:1.5 superview:self.IDLabel];
        self.IDColorLabel.gradualColors = @[[UIColor redColor], [UIColor orangeColor], [UIColor yellowColor], [UIColor greenColor], [UIColor cyanColor], [UIColor blueColor], [UIColor purpleColor]];
        self.IDColorLabel.font = KFontA(12);
        self.IDColorLabel.textAlignment = NSTextAlignmentLeft;
        self.IDColorLabel.textColor=RGBA(153, 153, 153, 1);
        [self.IDLabel setTitleColor:kClearColor forState:0];
        [self.IDLabel setTitle:[NSString stringWithFormat:@"ID:%@",model.uuid] forState:UIControlStateNormal];
        [self.IDLabel setImage:[UIImage imageNamed:@"liangIconImg"] forState:UIControlStateNormal];
    }else{
        [self.IDLabel setTitleColor:RGBA(153, 153, 153, 1) forState:0];
        [self.IDLabel setTitle:[NSString stringWithFormat:@"ID:%@",model.userID] forState:UIControlStateNormal];
        [self.IDLabel setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    
    self.ageBtn.userInteractionEnabled = NO;
    [self.ageBtn setTitle:model.age forState:UIControlStateNormal];
    if ([model.sex integerValue] == 1) {
        [self.ageBtn setImage:ImageNamed(@"manImg") forState:UIControlStateNormal];
        self.ageBtn.backgroundColor=RGBA(0, 168, 255, 1);
    }else{
        self.ageBtn.backgroundColor=RGBA(255, 92, 100, 1);
        [self.ageBtn setImage:ImageNamed(@"womanImg") forState:UIControlStateNormal];
        
    }
    if(model.constellation.length>0){
        [self.constellationBtn setImage:[UIImage imageNamed:[Common isNull:model.constellation]] forState:UIControlStateNormal];
        [self.constellationBtn setTitle:[Common isNull:model.constellation] forState:UIControlStateNormal];
    }else{
        self.constellationBtn.hidden=YES;
    }
  
    [self.meiLiImgView sd_setImageWithURL:[NSURL URLWithString:model.level_image]];
    
    if ([model.is_attention isEqualToString:@"1"]) {
        self.guanZhuBtn.selected=YES;
    }else{
        self.guanZhuBtn.selected=NO;
    }
    
    [self.scrollView removeAllSubviews];
    NSInteger skilListHeight=KAdaptedHeight(80);
    NSArray *arr=model.skill_info;
    if ([Common isBlankArr:arr]) {
        skilListHeight=0;
        self.scrollView.hidden=YES;
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.introductionLabel.mas_bottom).offset(KAdaptedHeight(5));
            make.height.mas_equalTo(KAdaptedHeight(0));
            
        }];
        [self.scrollView layoutIfNeeded];
     }else{
        self.scrollView.hidden=NO;
        for (int i=0; i<arr.count; i++) {
            EMO_BtnView *  gamrBtn = [[EMO_BtnView alloc] init];
//            gamrBtn.iconImgView.image=KGetImage(@"gameImg");
            [gamrBtn.iconImgView sd_setImageWithURL:[NSURL URLWithString:[Common isNull:arr[i][@"skill_image"]]]placeholderImage:KGetImage(@"gameImg")];
            gamrBtn.nameLabel.text=[Common isNull:arr[i][@"skill_name"]];
            gamrBtn.BtnBlock = ^(NSInteger tag) {
                
            };
            [self.scrollView addSubview:gamrBtn];
            [gamrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(KAdaptedWidth(15)+KAdaptedWidth(65)*i);
                make.centerY.mas_equalTo(0);
                make.width.mas_equalTo(KAdaptedWidth(50));
                make.height.mas_equalTo(KAdaptedHeight(70));
            }];
        }
        self.scrollView.contentSize=CGSizeMake(KAdaptedWidth(65)*10+KAdaptedWidth(15), KAdaptedHeight(70));
        
    }
    
    self.getOutBtn.nameLabel.text=getLanguage(@"踢出房间");
    
    if ([model.userID integerValue] == [[UserManager userInfo].user_id integerValue]) {
        self.reportBtn.hidden=YES;
        //如果是自己
        //隐藏举报按钮
//        self.closeBtn.hidden = YES;
        if ([[MLRoomInformationModel currentAccount].uuid integerValue] == [model.userID integerValue]) {
//            并且是房主
            [_whiteView mas_remakeConstraints:^(MASConstraintMaker *make) {
               make.leading.trailing.bottom.mas_equalTo(0);
               make.height.mas_equalTo(KAdaptedHeight(200+80)+skilListHeight);
           }];
            
            self.xiaMaiBtn.hidden = NO;
            self.biMaiBtn.hidden = NO;
            self.jinYanBtn.hidden = NO;
            self.getOutBtn.hidden = NO;
            self.meiliBtn.hidden = NO;
            
            self.giftBtn.hidden = YES;
            self.guanZhuBtn.hidden = YES;
            self.lineView.hidden=YES;
            self.getOutBtn.nameLabel.text=getLanguage(@"关闭房间");
        }else{
            [_whiteView mas_remakeConstraints:^(MASConstraintMaker *make) {
               make.leading.trailing.bottom.mas_equalTo(0);
               make.height.mas_equalTo(KAdaptedHeight(200)+skilListHeight);
           }];
            self.xiaMaiBtn.hidden = YES;
            self.biMaiBtn.hidden = YES;
            self.jinYanBtn.hidden = YES;
            self.getOutBtn.hidden = YES;
            self.giftBtn.hidden = YES;
            self.guanZhuBtn.hidden = YES;
            self.lineView.hidden=YES;
            self.meiliBtn.hidden = YES;
        }
    }
        else{
            self.reportBtn.hidden=NO;
        //如果不是自己
        //判断自己的身份，如果是房主或者管理员
        if ([[MLRoomInformationModel currentAccount].user_type integerValue]==1 || [[MLRoomInformationModel currentAccount].user_type integerValue]==2) {
            if ([[MLRoomInformationModel currentAccount].user_type integerValue]==1) {
                //如果我是房主，被点开的只能是管理员或者一般用户，上下麦和送礼都显示
                [_whiteView mas_remakeConstraints:^(MASConstraintMaker *make) {
                   make.leading.trailing.bottom.mas_equalTo(0);
                   make.height.mas_equalTo(KAdaptedHeight(310)+skilListHeight);
               }];
                self.meiliBtn.hidden = NO;
                self.xiaMaiBtn.hidden = NO;
                self.biMaiBtn.hidden = NO;
                self.jinYanBtn.hidden = NO;
                self.getOutBtn.hidden = NO;
                self.guanZhuBtn.hidden = NO;
                self.giftBtn.hidden = NO;
                self.lineView.hidden=NO;
            }else{
                //我是管理员，对面不管是房主，管理员都只显示魅力值，不显示上下麦
                //对方是否是房主，需要自己判断
                //对方如果不是房主，在通过user_type判断角色 //对方如果不是房主，根据user_type判断暂时取消
                if ([[MLRoomInformationModel currentAccount].uuid integerValue]==[model.userID integerValue]) {

                    [_whiteView mas_remakeConstraints:^(MASConstraintMaker *make) {
                       make.leading.trailing.bottom.mas_equalTo(0);
                       make.height.mas_equalTo(KAdaptedHeight(230)+skilListHeight);
                   }];
                    self.xiaMaiBtn.hidden = YES;
                    self.biMaiBtn.hidden = YES;
                    self.jinYanBtn.hidden = YES;
                    self.getOutBtn.hidden = YES;
                    self.meiliBtn.hidden = YES;
                    self.giftBtn.hidden = NO;
                    self.guanZhuBtn.hidden = NO;
                    self.lineView.hidden=NO;
                }else{
                    [_whiteView mas_remakeConstraints:^(MASConstraintMaker *make) {
                       make.leading.trailing.bottom.mas_equalTo(0);
                       make.height.mas_equalTo(KAdaptedHeight(310)+skilListHeight);
                   }];

                        self.xiaMaiBtn.hidden = NO;
                        self.biMaiBtn.hidden = NO;
                        self.jinYanBtn.hidden = NO;
                        self.getOutBtn.hidden = NO;
                        self.guanZhuBtn.hidden = NO;
                        self.giftBtn.hidden = NO;
                        self.lineView.hidden=NO;
                        self.meiliBtn.hidden = NO;
                }

            }
        }else{
            [_whiteView mas_remakeConstraints:^(MASConstraintMaker *make) {
               make.leading.trailing.bottom.mas_equalTo(0);
               make.height.mas_equalTo(KAdaptedHeight(230)+skilListHeight);
           }];

            self.xiaMaiBtn.hidden = YES;
            self.biMaiBtn.hidden = YES;
            self.jinYanBtn.hidden = YES;
            self.getOutBtn.hidden = YES;
            self.meiliBtn.hidden = YES;
            self.giftBtn.hidden = NO;
            self.guanZhuBtn.hidden = NO;
            self.lineView.hidden=NO;
        }
    }
    
    if ([model.microphone_position_type integerValue] == 0) {
        self.biMaiBtn.nameLabel.text=getLanguage(@"闭麦");
        self.biMaiBtn.iconImgView.image=ImageNamed(@"U_CloseMaikImg");
    }else{
        self.biMaiBtn.nameLabel.text=getLanguage(@"开麦");
        self.biMaiBtn.iconImgView.image=ImageNamed(@"U_openMaikImg");
    }
    if ([model.is_muted integerValue] == 0) {
        self.jinYanBtn.nameLabel.text=getLanguage(@"解禁");
        self.jinYanBtn.iconImgView.image=ImageNamed(@"U_msgImg");
    }else{
        self.jinYanBtn.nameLabel.text=getLanguage(@"禁言");
        self.jinYanBtn.iconImgView.image=ImageNamed(@"U_CleanMsgImg");

    }
    
    
    MYLog(@"%@",model.zaiMaiShang);
    if ([model.zaiMaiShang isEqualToString:@"1"]) {
        self.xiaMaiBtn.iconImgView.image=ImageNamed(@"U_XiaMaiImg");
        self.xiaMaiBtn.nameLabel.text=getLanguage(@"下麦");
    }else{
        
    }
}

-(void)concernAction{
    [self Click:666];
}

- (void)singleTapGesture:(UITapGestureRecognizer *)tap{
    [self removeFromSuperview];
}

#pragma mark ======================  懒加载   ======================
- (UIView *)mengbanView{
    if (!_mengbanView) {
        _mengbanView = [UIView new];
        _mengbanView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        _mengbanView.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
        [_mengbanView addGestureRecognizer:singleTap];
        [self addSubview:_mengbanView];
        [_mengbanView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(0);
            
        }];
    }
    return _mengbanView;
}
- (UIView *)whiteView{
    if (!_whiteView) {
        _whiteView = [UIView new];
//        _whiteView.backgroundColor=[UIColor redColor];
        [self addSubview:_whiteView];
        [_whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.mas_equalTo(0);
            make.height.mas_equalTo(KAdaptedHeight(320+80));
            
            
        }];
    }
    return _whiteView;
}


- (UIImageView*)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
//        _bgImgView.image=KGetImage(@"U_UserInfoBgImg");
        _bgImgView.backgroundColor=RGBA(255, 255, 255, 0.95);
        [self.whiteView addSubview:_bgImgView];
        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(KAdaptedHeight(15));
        }];
        setViewCorner(_bgImgView, KAdaptedHeight(15));
    }
    return _bgImgView;
}


- (UIButton *)reportBtn{
    if (!_reportBtn) {
        _reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reportBtn setImage:KGetImage(@"reportImg") forState:UIControlStateNormal];
        _reportBtn.tag=1000;
        [_reportBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.whiteView addSubview:_reportBtn];
        [_reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(14));
            make.trailing.mas_equalTo(KAdaptedWidth(-14));
            make.width.height.mas_equalTo(KAdaptedWidth(25));
            
        }];
    }
    return _reportBtn;
}


- (UIImageView*)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        _headImgView.image=KGetImage(@"未加载头像");
        _headImgView.layer.cornerRadius=KAdaptedHeight(77/2);
        _headImgView.layer.masksToBounds=YES;
        _headImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(concernAction)];
        [_headImgView addGestureRecognizer:tap];
        [self addSubview:_headImgView];
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(KAdaptedHeight(77));
            make.centerY.mas_equalTo(self.whiteView.mas_top);
            make.centerX.mas_equalTo(0);
            
        }];
    }
    return _headImgView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = getLanguage(@"ONE-倩倩！~");
        _nameLabel.textColor = RGBA(51, 51, 51, 1);
        _nameLabel.font=KFontBold(14);
        _nameLabel.textAlignment=NSTextAlignmentRight;
        [self.whiteView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(45));
            make.leading.mas_equalTo(KAdaptedWidth(40));
            make.trailing.mas_equalTo(self.whiteView.mas_centerX).offset(KAdaptedWidth(-10));
//            make.trailing.mas_equalTo(self.whiteView.mas_centerX).offset(KAdaptedWidth(-2.5));
            make.height.mas_equalTo(KAdaptedHeight(15));
            
        }];
    }
    return _nameLabel;
}


- (UIButton *)ageBtn{
    if (!_ageBtn) {
        _ageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _ageBtn.backgroundColor=RGBA(255, 92, 100, 1);
//        CAGradientLayer *gl = [CAGradientLayer layer];
//        gl.frame = CGRectMake(0,0,KAdaptedWidth(40),KAdaptedHeight(15));
//        gl.startPoint = CGPointMake(0, 0);
//        gl.endPoint = CGPointMake(1, 1);
//        gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:175/255.0 blue:230/255.0 alpha:0.2].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:127/255.0 blue:241/255.0 alpha:0.2].CGColor];
//        gl.locations = @[@(0.0),@(1.0f)];
//        [_ageBtn.layer addSublayer:gl];
        _ageBtn.layer.cornerRadius = KAdaptedHeight(15/2);
        _ageBtn.layer.masksToBounds=YES;
        [_ageBtn setImage:KGetImage(@"womanImg") forState:UIControlStateNormal];
        [_ageBtn setTitle:getLanguage(@"22") forState:UIControlStateNormal];
        [_ageBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _ageBtn.titleLabel.font=KFont(11);
        
        [self.whiteView addSubview:_ageBtn];
        [_ageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_top);
            make.leading.mas_equalTo(self.nameLabel.mas_trailing).offset(KAdaptedWidth(5));
            make.height.mas_equalTo(KAdaptedHeight(15));
            make.width.mas_equalTo(KAdaptedWidth(40));
            
        }];
    }
    return _ageBtn;
}


- (UIButton *)constellationBtn{
    if (!_constellationBtn) {
        _constellationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _constellationBtn.layer.contents = (id) KGetImage(@"constellationImg").CGImage;    // 如果需要背景透明加上下面这句
        _constellationBtn.layer.backgroundColor = [UIColor clearColor].CGColor;
        [_constellationBtn setImage:[UIImage imageNamed:@"xingzuoImg"] forState:UIControlStateNormal];
        [_constellationBtn setTitle:@"金牛" forState:UIControlStateNormal];
        [_constellationBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _constellationBtn.titleLabel.font=KFont(10);
        [self.whiteView addSubview:_constellationBtn];
        [_constellationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(KAdaptedWidth(60));
            make.height.mas_equalTo(self.ageBtn.mas_height);
            make.top.mas_equalTo(self.ageBtn.mas_top).offset(KAdaptedHeight(0));
            make.leading.mas_equalTo(self.ageBtn.mas_trailing).offset(KAdaptedWidth(5));
            
        }];
        [_constellationBtn setImagePositionWithType:SSImagePositionTypeLeft spacing:3];
    }
    return _constellationBtn;
}

- (UIImageView*)gongxianImgView{
    if (!_gongxianImgView) {
        _gongxianImgView = [[UIImageView alloc] init];
        _gongxianImgView.image=KGetImage(@"gongxian_8");
        [self.whiteView addSubview:_gongxianImgView];
        [_gongxianImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(KAdaptedHeight(10));
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(35), KAdaptedHeight(15)));
            make.trailing.mas_equalTo(self.whiteView.mas_centerX).offset(KAdaptedWidth(-3));
            
        }];
    }
    return _gongxianImgView;
}

- (UIImageView*)meiLiImgView{
    if (!_meiLiImgView) {
        _meiLiImgView = [[UIImageView alloc] init];
        _meiLiImgView.image=KGetImage(@"GXImg-1");
        [self.whiteView addSubview:_meiLiImgView];
        [_meiLiImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.gongxianImgView.mas_centerY);
            make.leading.mas_equalTo(self.gongxianImgView.mas_trailing).offset(KAdaptedWidth(6));
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(35), KAdaptedHeight(15)));
        }];
    }
    return _meiLiImgView;
}

- (UIButton *)IDLabel{
    if (!_IDLabel) {
        _IDLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_IDLabel setTitle:getLanguage(@"ID:00000") forState:UIControlStateNormal];
        [_IDLabel setTitleColor:RGBA(153, 153, 153, 1) forState:0];
        _IDLabel.titleLabel.font=KFontA(12);
        _IDLabel.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        _IDLabel.tag=100;
        [self addSubview:_IDLabel];
        [_IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.gongxianImgView.mas_bottom).offset(KAdaptedHeight(10));
            make.width.mas_equalTo(KAdaptedWidth(80));
            make.centerX.mas_equalTo(self.whiteView.mas_centerX).offset(KAdaptedWidth(0));
            make.height.mas_equalTo(KAdaptedHeight(15));
            
        }];
        [_IDLabel setImagePositionWithType:SSImagePositionTypeLeft spacing:5];
    }
    return _IDLabel;
}

- (UILabel *)introductionLabel{
    if (!_introductionLabel) {
        _introductionLabel = [[UILabel alloc] init];
        _introductionLabel.numberOfLines=2;
        _introductionLabel.textColor = RGBA(102, 102, 102, 1);
        _introductionLabel.font=KFont(13);
        _introductionLabel.textAlignment=NSTextAlignmentCenter;
        [self.whiteView addSubview:_introductionLabel];
        [_introductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.IDLabel.mas_bottom).offset(KAdaptedHeight(10));
            make.leading.mas_equalTo(KAdaptedWidth(30));
            make.trailing.mas_equalTo(KAdaptedWidth(-30));
            make.height.mas_equalTo(KAdaptedHeight(20));
            
        }];
    }
    return _introductionLabel;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView=[[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.backgroundColor=kWhiteColor;
        if (@available(iOS 11.0, *)) {//顶部留白
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _scrollView.showsVerticalScrollIndicator=NO;
        _scrollView.showsHorizontalScrollIndicator=NO;
        _scrollView.scrollEnabled=YES;
        _scrollView.bounces=NO;
        _scrollView.contentSize=CGSizeMake(kWidth-KAdaptedWidth(30), KAdaptedHeight(70));
        [self.whiteView addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.introductionLabel.mas_bottom).offset(KAdaptedHeight(10));
            make.width.mas_equalTo(kWidth-KAdaptedWidth(30));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.height.mas_equalTo(KAdaptedHeight(70));

        }];
        
        setViewCorner(_scrollView, KAdaptedHeight(10));
    }
    return _scrollView;
}

- (EMO_BtnView *)getOutBtn{
    if (!_getOutBtn) {
        _getOutBtn = [[EMO_BtnView alloc] init];
        _getOutBtn.iconImgView.image=KGetImage(@"U_GetOutImg");
        _getOutBtn.nameLabel.text=getLanguage(@"踢出房间");
        WeakSelf;
        _getOutBtn.BtnBlock  = ^(NSInteger tag) {
            [wself Click:5000];
        };

        [self.whiteView addSubview:_getOutBtn];
        [_getOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.introductionLabel.mas_bottom).offset(KAdaptedHeight(10));
            make.top.mas_equalTo(self.scrollView.mas_bottom).offset(KAdaptedHeight(10));
            make.centerX.mas_equalTo(self.whiteView.mas_centerX).offset(KAdaptedWidth(0));
            make.width.mas_equalTo(KAdaptedWidth(51));
            make.height.mas_equalTo(KAdaptedHeight(95));
            
        }];

    }
    return _getOutBtn;
}

- (EMO_BtnView *)jinYanBtn{
    if (!_jinYanBtn) {
        _jinYanBtn = [[EMO_BtnView alloc] init];
        _jinYanBtn.iconImgView.image=KGetImage(@"U_CleanMsgImg");
        _jinYanBtn.nameLabel.text=getLanguage(@"禁言");
        WeakSelf;
        _jinYanBtn.BtnBlock = ^(NSInteger tag) {

                [wself Click:9000];
            };
        [self.whiteView addSubview:_jinYanBtn];
        [_jinYanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.getOutBtn.mas_leading).offset(KAdaptedHeight(-15));
            make.centerY.mas_equalTo(self.getOutBtn.mas_centerY).offset(KAdaptedWidth(0));
            make.width.mas_equalTo(self.getOutBtn.mas_width);
            make.height.mas_equalTo(self.getOutBtn.mas_height);
        }];

    }
    return _jinYanBtn;
}


- (EMO_BtnView *)biMaiBtn{
    if (!_biMaiBtn) {
        _biMaiBtn = [[EMO_BtnView alloc] init];
        _biMaiBtn.iconImgView.image=KGetImage(@"U_CloseMaikImg");
        _biMaiBtn.nameLabel.text=getLanguage(@"闭麦");
        WeakSelf;
        _biMaiBtn.BtnBlock  = ^(NSInteger tag) {
            [wself Click:3000];
        };
        [self.whiteView addSubview:_biMaiBtn];
        [_biMaiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.jinYanBtn.mas_leading).offset(KAdaptedHeight(-15));
            make.centerY.mas_equalTo(self.getOutBtn.mas_centerY).offset(KAdaptedWidth(0));
            make.width.mas_equalTo(self.getOutBtn.mas_width);
            make.height.mas_equalTo(self.getOutBtn.mas_height);
        }];

    }
    return _biMaiBtn;
}

- (EMO_BtnView *)xiaMaiBtn{
    if (!_xiaMaiBtn) {
        _xiaMaiBtn = [[EMO_BtnView alloc] init];
        _xiaMaiBtn.iconImgView.image=KGetImage(@"U_XiaMaiImg");
        _xiaMaiBtn.nameLabel.text=getLanguage(@"下麦");
        WeakSelf;
        _xiaMaiBtn.BtnBlock  = ^(NSInteger tag) {
            [wself Click:6000];
        };
        [self.whiteView addSubview:_xiaMaiBtn];
        [_xiaMaiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.getOutBtn.mas_trailing).offset(KAdaptedHeight(15));
            make.centerY.mas_equalTo(self.getOutBtn.mas_centerY).offset(KAdaptedWidth(0));
            make.width.mas_equalTo(self.getOutBtn.mas_width);
            make.height.mas_equalTo(self.getOutBtn.mas_height);
        }];
    }
    return _xiaMaiBtn;
}

- (EMO_BtnView *)meiliBtn{
    if (!_meiliBtn) {
        _meiliBtn = [[EMO_BtnView alloc] init];
        _meiliBtn.iconImgView.image=KGetImage(@"U_cleanMeiLiImg");
        _meiliBtn.nameLabel.text=getLanguage(@"清空魅力值");
        WeakSelf;
        _meiliBtn.BtnBlock = ^(NSInteger tag) {
            [wself Click:4000];
        };

        [self.whiteView addSubview:_meiliBtn];
        [_meiliBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.xiaMaiBtn.mas_trailing).offset(KAdaptedHeight(15));
            make.centerY.mas_equalTo(self.getOutBtn.mas_centerY).offset(KAdaptedWidth(0));
            make.width.mas_equalTo(self.getOutBtn.mas_width);
            make.height.mas_equalTo(self.getOutBtn.mas_height);
        }];

    }
    return _meiliBtn;
}

- (UIButton *)guanZhuBtn{
    if (!_guanZhuBtn) {
        _guanZhuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_guanZhuBtn setTitle:getLanguage(@"+关注") forState:UIControlStateNormal];
        [_guanZhuBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        [_guanZhuBtn setTitle:getLanguage(@"取消关注") forState:UIControlStateSelected];
        [_guanZhuBtn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateSelected];
        _guanZhuBtn.titleLabel.font=KFontA(14);
        _guanZhuBtn.tag=7000;
        [_guanZhuBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.whiteView addSubview:_guanZhuBtn];
        [_guanZhuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(self.spacing);
            make.bottom.mas_equalTo(KAdaptedHeight(-25)-KSAFEAREA_BOTTOM_HEIHGHT);
            make.width.mas_equalTo(KAdaptedWidth(55));
            make.height.mas_equalTo(KAdaptedHeight(15));
        }];
    }
    return _guanZhuBtn;
}

- (UIButton *)messageBtn{
    if (!_messageBtn) {
        _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_messageBtn setTitleColor:UIColor.blackColor forState:0];
        _messageBtn.titleLabel.font=KFontA(14);
        [_messageBtn setTitle:@"消息" forState:0];
        [_messageBtn addTarget:self action:@selector(buttonAtTheBottomOfTheClick) forControlEvents:UIControlEventTouchUpInside];
        _messageBtn.tag=8;
        [self.whiteView addSubview:_messageBtn];
        [_messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.guanZhuBtn);
            make.width.mas_equalTo(KAdaptedWidth(55));
            make.height.mas_equalTo(KAdaptedHeight(15));
            make.left.mas_equalTo(self.guanZhuBtn.mas_right).offset(self.spacing);
        }];
        
        _messageNum = [[UILabel alloc] init];
        _messageNum.textColor = UIColor.whiteColor;
        _messageNum.backgroundColor = [UIColor redColor];
        _messageNum.textAlignment = NSTextAlignmentCenter;
        _messageNum.hidden = YES;
        _messageNum.font = KFont(10);
        [self.whiteView addSubview:_messageNum];
        [_messageNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(20);
            make.width.mas_greaterThanOrEqualTo(20);
            make.left.equalTo(_messageBtn.mas_right).offset(-20);
            make.top.equalTo(_messageBtn.mas_top).offset(-10);
        }];
        setViewCorner(_messageNum, 10);
    }
    return _messageBtn;
}

//单聊消息
-(void)buttonAtTheBottomOfTheClick{
    MLSessionViewController *VC = [[MLSessionViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:self.model.userID];
    VC.title = self.model.nickname;
    [[Common getCurrentVC].navigationController pushViewController:VC animated:YES];
    WeakSelf;
    VC.popBlock = ^{
        wself.messageNum.hidden = YES;
    };
}

- (UIButton *)giftBtn{
    if (!_giftBtn) {
        _giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_giftBtn setTitle:getLanguage(@"投喂") forState:UIControlStateNormal];
        [_giftBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        _giftBtn.titleLabel.font=KFont(14);
        _giftBtn.tag=8000;
        [_giftBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.whiteView addSubview:_giftBtn];
        [_giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.messageBtn.mas_right).offset(self.spacing);
            make.centerY.mas_equalTo(self.guanZhuBtn.mas_centerY).offset(KAdaptedWidth(0));
            make.width.mas_equalTo(KAdaptedWidth(55));
            make.height.mas_equalTo(KAdaptedHeight(15));
        }];
    }
    return _giftBtn;
}
//@人
- (UIButton *)personBtn{
    if (!_personBtn) {
        _personBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_personBtn setTitle:getLanguage(@"@TA") forState:UIControlStateNormal];
        [_personBtn setTitleColor:UIColor.blackColor forState:0];
        _personBtn.titleLabel.font=KFontA(14);
        _personBtn.tag=10000;
        [_personBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.whiteView addSubview:_personBtn];
        [_personBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.giftBtn.mas_right).offset(self.spacing);
            make.centerY.mas_equalTo(self.guanZhuBtn.mas_centerY).offset(KAdaptedWidth(0));
            make.width.mas_equalTo(KAdaptedWidth(55));
            make.height.mas_equalTo(KAdaptedHeight(15));
        }];
    }
    return _personBtn;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGBA(242, 235, 255, 1);
        [self.whiteView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.guanZhuBtn.mas_top);
            make.centerX.mas_equalTo(KAdaptedWidth(0));
            make.width.mas_equalTo(KAdaptedWidth(0.5));
            make.bottom.mas_equalTo(self.guanZhuBtn.mas_bottom);
        }];
    }
    return _lineView;
}

-(void)BtnClick:(UIButton *)sender{
    [self Click:sender.tag];
}

-(void)Click:(NSInteger )tag{
    if (self.personalBtnClickBlock) {
        self.personalBtnClickBlock(self.model, tag);
    }
    [self removeFromSuperview];
}

//接收到新消息
- (void)InfoNotificationAction:(NSNotification *)notification{
    [self uploadMessageNum];
}

//获取单人未读消息数
-(void)uploadMessageNum{
    WeakSelf;
    [[RCCoreClient sharedCoreClient] getUnreadCount:ConversationType_PRIVATE
                                           targetId:self.model.userID
                                         completion:^(int count) {
        if(count>0){
            dispatch_async(dispatch_get_main_queue(), ^{
                wself.messageNum.hidden = NO;
                wself.messageNum.text = [NSString stringWithFormat:@"%d",count];
                  });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                wself.messageNum.hidden = YES;
            });
        }
    }];
}

@end
