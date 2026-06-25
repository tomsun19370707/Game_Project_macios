//
//  CFMHomeFlowCollCell.m
//  miliao
//
//  Created by Dylan Lee on 2025/12/9.
//  Copyright © 2025 EMO. All rights reserved.
//

#import "CFMHomeFlowCollCell.h"
@interface CFMHomeFlowCollCell ()
/** View */
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIView *maskVie;
@property (weak, nonatomic) IBOutlet UIImageView *header;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *hotNum;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hotNumWid;
@property (weak, nonatomic) IBOutlet UIView *cateBg;
@property (weak, nonatomic) IBOutlet UIImageView *cateIcon;
@property (weak, nonatomic) IBOutlet UILabel *cateLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cateBgWid;

@end
@implementation CFMHomeFlowCollCell

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
    [self.header makeRoundCorner];
    [self.cateBg makeRoundCorner];

    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = 10 ;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10 ;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    /** 初始化*/
    [self initContentview];
    /** RAC*/
    [self initRacChain];
    
    // Initialization code
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
    self.title.text = model[@"name"];
    
    self.cateLab.text = model[@"partition_name"];
    self.cateBgWid.constant = [NSString widthForContent:self.cateLab.text font:self.cateLab.font] + 3 + 21;
    
    self.hotNum.text = FORMAT_TYPE(@"%@", model[@"heat_text"]);
    /** 用户信息*/
    [self.header sd_setImageWithURL:[NSURL URLWithString:model[@"avatar"]] placeholderImage:IMAGE(@"默认头像")];
    self.nickName.text = model[@"nickname"] ;
}
#pragma mark --
#pragma mark --- ibaction

#pragma mark --
#pragma mark --- Method
@end
