//
//  STRankCell.m
//  miliao
//
//  Created by Dylan Lee on 2025/12/10.
//  Copyright © 2025 EMO. All rights reserved.
//

#import "STRankCell.h"
@interface STRankCell ()
/** View */

@end

@implementation STRankCell

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
    [self.icon makeRoundCorner];
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
-(void)setRow:(NSUInteger)row
{
    switch (row) {
        case 0:
            {
                self.rankIcon.image = IMAGE(@"home_rank_1");
                self.rankNum.text = nil ;
            }
            break;
        case 1:
            {
                self.rankIcon.image = IMAGE(@"home_rank_2");
                self.rankNum.text = nil ;
            }
            break;
        case 2:
            {
                self.rankIcon.image = IMAGE(@"home_rank_3");
                self.rankNum.text = nil ;
            }
            break;
        default:
        {
            self.rankIcon.image = nil;
            self.rankNum.text = FORMAT_TYPE(@"%ld", row + 1) ;
        }
            break;
    }
}
-(void)setModel:(GoodListInfoModel *)model
{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:IMAGE(@"默认头像")];
    self.name.text = model.nickname ;
    
    switch (self.bangType) {
        case 0:
            self.money.text = FORMAT_TYPE(@"%.2f", model.contribute_diff.floatValue);
            break;
        case 1:
            self.money.text = FORMAT_TYPE(@"%.2f", model.total_gift_charm.floatValue);
            break;   
        default:
            break;
    }
}
#pragma mark --
#pragma mark --- ibaction

#pragma mark --
#pragma mark --- Method
@end
