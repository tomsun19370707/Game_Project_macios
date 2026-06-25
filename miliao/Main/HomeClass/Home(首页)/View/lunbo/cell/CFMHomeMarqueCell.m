//
//  CFMHomeMarqueCell.m
//  miliao
//
//  Created by Dylan Lee on 2025/12/10.
//  Copyright © 2025 EMO. All rights reserved.
//

#import "CFMHomeMarqueCell.h"
@interface CFMHomeMarqueCell ()
/** View */
@property (weak, nonatomic) IBOutlet UIImageView *header;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameWid;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *giftName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giftWid;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numWid;
@end

@implementation CFMHomeMarqueCell

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
    [self.header sd_setImageWithURL:[NSURL URLWithString:model[@"avatar"]] placeholderImage:IMAGE(@"默认头像")];
    self.name.text = model[@"nickname"];
    self.nameWid.constant = [NSString widthForContent:self.name.text font:self.name.font] + 3 ;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model[@"image"]] placeholderImage:IMAGE(@"默认头像")];
    self.giftName.text = model[@"name"];
    self.giftWid.constant = [NSString widthForContent:self.giftName.text font:self.giftName.font] + 3 ;
    self.num.text = [NSString stringWithFormat:@"x%@",model[@"num"]];
}
#pragma mark --
#pragma mark --- ibaction

#pragma mark --
#pragma mark --- Method
@end
