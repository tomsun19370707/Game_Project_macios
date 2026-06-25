//
//  CFMHomeRoom.m
//  miliao
//
//  Created by Dylan Lee on 2025/12/9.
//  Copyright © 2025 EMO. All rights reserved.
//

#import "CFMHomeRoom.h"
#import "STSecMallSeachResVc.h"
@interface CFMHomeRoom ()
/** View */
@property (weak, nonatomic) IBOutlet UIView *bg;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIView *hotBg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hotBgWid;
@property (weak, nonatomic) IBOutlet UILabel *hotNum;
@property (weak, nonatomic) IBOutlet UIView *cateBg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cateBgWid;
@property (weak, nonatomic) IBOutlet UIImageView *cateIcon;
@property (weak, nonatomic) IBOutlet UILabel *cateLab;
@property (weak, nonatomic) IBOutlet UIImageView *bgIm;

@end

@implementation CFMHomeRoom

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
    [self.hotBg makeRoundCorner];
    [self.cateBg makeRoundCorner];

    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = 5 ;
    
    self.bgIm.layer.masksToBounds = YES;
    self.bgIm.layer.cornerRadius = 8 ;
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
    
}

#pragma mark -
#pragma mark --- Getter

#pragma mark --
#pragma mark --- Setter
-(void)setModel:(NSDictionary *)model
{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model[@"image"]] placeholderImage:IMAGE(@"正方形")];
    self.name.text = model[@"name"];
    
    /** 热度*/
    self.hotNum.text = FORMAT(model[@"heat"]);
    self.hotBgWid.constant = [NSString widthForContent:self.hotNum.text font:self.hotNum.font] + 3 + 24;
    
    /** 分类名称*/
    self.cateLab.text = FORMAT(model[@"partition_name"]);
    self.cateBgWid.constant = [NSString widthForContent:self.cateLab.text font:self.cateLab.font] + 3 + 21;
}
#pragma mark --
#pragma mark --- ibaction
- (IBAction)allRoomAc:(id)sender {
    /** 全部房间*/
    STSecMallSeachResVc *se = [[STSecMallSeachResVc alloc]init];
    [Dn_NAVPUSH pushViewController:se  animated:YES];
}
#pragma mark --
#pragma mark --- Method
@end
