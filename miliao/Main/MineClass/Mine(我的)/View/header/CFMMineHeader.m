//
//  CFMMineHeader.m
//  miliao
//
//  Created by Dylan Lee on 2025/12/6.
//  Copyright © 2025 EMO. All rights reserved.
//

#import "CFMMineHeader.h"
#import "EMO_EditUserMsgViewController.h"
#import "EMO_PersonalDataBaseVC.h"
#import "EMO_OhterUserDynamicVC.h"
#import "EMO_FriendsContentVC.h"
@interface CFMMineHeader ()
/** View */
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *IDLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IDLabWid;
@property (weak, nonatomic) IBOutlet UIView *wealthBg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wealBgWid;

@property (weak, nonatomic) IBOutlet UIView *meiBg;
@property (weak, nonatomic) IBOutlet UIView *genderBg;
@property (weak, nonatomic) IBOutlet UIImageView *gender;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (weak, nonatomic) IBOutlet UIView *elaBg;
@property (weak, nonatomic) IBOutlet UIImageView *elaIcon;
@property (weak, nonatomic) IBOutlet UILabel *ela;
@property (weak, nonatomic) IBOutlet UILabel *dynamicNum;
@property (weak, nonatomic) IBOutlet UILabel *fpcusNum;
@property (weak, nonatomic) IBOutlet UILabel *fansNum;
@property (weak, nonatomic) IBOutlet UILabel *visitNum;

@property (weak, nonatomic) IBOutlet UILabel *wealthLab;
@property (weak, nonatomic) IBOutlet UILabel *meiLab;


@end

@implementation CFMMineHeader

#pragma mark -
#pragma mark --- init
-(instancetype)init
{
    self = [super init];
    if (self) {
        /** 初始化*/
        [self initContentview];
        /** RAC*/
        [self initRacChain];
    }
    return self ;
}

#pragma mark -
#pragma mark --- init frame
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /** 初始化*/
        [self initContentview];
        /** RAC*/
        [self initRacChain];
    }
    return self ;
}

#pragma mark -
#pragma mark --- 初始化view
- (void)initContentview
{
    [self.icon makeRoundCornerAndLayerColor:UIColor.whiteColor];
    self.icon.layer.borderWidth = 2.5 ;
    [self.genderBg makeRoundCorner];
    [self.elaBg makeRoundCorner];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    /** 初始化*/
    [self initContentview];
    /** RAC*/
    [self initRacChain];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -
#pragma mark --- Rac
- (void)initRacChain {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        EMO_PersonalDataBaseVC *vc=[EMO_PersonalDataBaseVC new];
        vc.userID=[UserManager userInfo].user_id;
        [[Common getCurrentVC].navigationController pushViewController:vc animated:YES];
    }];
    [self.icon addGestureRecognizer:tap];
}

#pragma mark -
#pragma mark --- Getter

#pragma mark --
#pragma mark --- Setter
-(void)setModel:(UserInfo *)model
{
    _model = model ;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:IMAGE(@"默认头像")];
    self.name.text = model.nickname;
    self.IDLab.text = [NSString stringWithFormat:@"ID：%@",model.uuid];
    self.IDLabWid.constant = [NSString widthForContent:self.IDLab.text font:self.IDLab.font] + 3 ;
    
    if ([NSString NotNull:model.constellation]) {
        self.elaBg.hidden = NO ;
        self.ela.text = model.constellation;
        self.elaIcon.image = IMAGE(model.constellation);
    }else{
        self.elaBg.hidden = YES ;
    }
    self.age.text = FORMAT(model.age);
    
    self.dynamicNum.text = FORMAT_TYPE(@"%@", model.dynamic_nums);
    self.fpcusNum.text = FORMAT_TYPE(@"%@", model.attention_nums);
    self.fansNum.text = FORMAT_TYPE(@"%@", model.fans_nums);
    
    /** 财富值 和 魅力值*/
    if (model.contribute_level.intValue > 0) {
        self.wealthBg.hidden = NO ;
        self.wealBgWid.constant = 62 ;
        self.wealthLab.text = [NSString stringWithFormat:@"财富值LV%d",model.contribute_level.intValue];
    }else{
        self.wealthBg.hidden = YES ;
        self.wealBgWid.constant = 0.0001 ;
    }
    
    if (model.charm_level.intValue > 0) {
        self.meiBg.hidden = NO ;
        self.meiLab.text = [NSString stringWithFormat:@"魅力值LV%d",model.charm_level.intValue];
    }else{
        self.meiBg.hidden = YES ;
    }
}
-(void)setVisitToatleCount:(int)visitToatleCount
{
    self.visitNum.text = FORMAT_TYPE(@"%d", visitToatleCount);
}
#pragma mark --
#pragma mark --- ibaction
- (IBAction)fuzhiAc:(id)sender {
    [SVProgressHUD showTextHUDWithMessage:@"复制成功"];
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = _model.uuid;
}
- (IBAction)infoAc:(id)sender {
    EMO_EditUserMsgViewController *VC=[[EMO_EditUserMsgViewController alloc]init];
    [[Common getCurrentVC].navigationController pushViewController:VC animated:YES];
}
- (IBAction)dynamicAc:(id)sender {
    /** 我的动态*/
    EMO_OhterUserDynamicVC *vc=[EMO_OhterUserDynamicVC new];
    vc.userID=[UserManager userInfo].user_id;
    vc.type=2;
    [[Common getCurrentVC].navigationController pushViewController:vc animated:YES];
}
- (IBAction)focusAc:(id)sender {
    /** 关注*/
    EMO_FriendsContentVC *vc=[EMO_FriendsContentVC new];
    vc.index=200;
    [[Common getCurrentVC].navigationController pushViewController:vc animated:YES];
}
- (IBAction)fansAc:(id)sender {
    /** 粉丝*/
    EMO_FriendsContentVC *vc=[EMO_FriendsContentVC new];
    vc.index=1;
    [[Common getCurrentVC].navigationController pushViewController:vc animated:YES];
}
- (IBAction)visitAc:(id)sender {
    /** 访客*/
    EMO_FriendsContentVC *vc=[EMO_FriendsContentVC new];
    vc.index=15;
    [[Common getCurrentVC].navigationController pushViewController:vc animated:YES];
}

#pragma mark --
#pragma mark --- Method
@end
