//
//  CFMRewardHistoryCell.m
//  miliao
//
//  Created by Dylan Lee on 2025/12/31.
//  Copyright © 2025 EMO. All rights reserved.
//

#import "CFMRewardHistoryCell.h"
@interface CFMRewardHistoryCell ()
/** View */
@property (weak, nonatomic) IBOutlet UIImageView *header;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameWid;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *giftName;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

@implementation CFMRewardHistoryCell

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
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(15, self.contentView.height - 1, SCREEN_WIDTH - 15 * 2, 0.5)];
    line.backgroundColor = LineColor ;
    [self.contentView addSubview:line];  
    
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
-(void)setModel:(GoodListInfoModel *)model
{
    [self.header sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:IMAGE(@"默认头像")];
    self.name.text = model.nickname ;
    self.nameWid.constant = [NSString widthForContent:self.name.text font:self.name.font] + 3 ;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:IMAGE(@"正方形")];
    self.giftName.text = model.name ;
    self.time.text = model.create_time;
}
#pragma mark --
#pragma mark --- ibaction

#pragma mark --
#pragma mark --- Method
@end
