//
//  CFMMyGiftCell.m
//  miliao
//
//  Created by Dylan Lee on 2025/12/8.
//  Copyright © 2025 EMO. All rights reserved.
//

#import "CFMMyGiftCell.h"
@interface CFMMyGiftCell ()
/** View */
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *giftName;
@property (weak, nonatomic) IBOutlet UIImageView *giftIcon;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameWid;

@end

@implementation CFMMyGiftCell

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
    self.name.text = [NSString stringWithFormat:@"赠送给%@的",model.nickname];
    if (self.oprIndex==0) {
        self.name.text = [NSString stringWithFormat:@"收到%@赠送的",model.nickname];
    }
    self.nameWid.constant = [NSString widthForContent:self.name.text font:self.name.font] + 3 ;
    
    [self.giftIcon sd_setImageWithURL:[NSURL URLWithString:model.gift_image] placeholderImage:IMAGE(@"正方形")];
    self.giftName.text = [NSString stringWithFormat:@"%@ x%d",model.gift_name,model.gift_num];
    self.time.text = model.createtime;
}
#pragma mark --
#pragma mark --- ibaction

#pragma mark --
#pragma mark --- Method
@end
