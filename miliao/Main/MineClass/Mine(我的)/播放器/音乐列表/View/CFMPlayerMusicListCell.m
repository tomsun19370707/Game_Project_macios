//
//  CFMPlayerMusicListCell.m
//  miliao
//
//  Created by Dylan Lee on 2025/12/29.
//  Copyright © 2025 EMO. All rights reserved.
//

#import "CFMPlayerMusicListCell.h"
@interface CFMPlayerMusicListCell ()
/** View */
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

@implementation CFMPlayerMusicListCell

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
//首先给让cell左右偏移一点的距离，通过重写cell的setframe方法来实现   
- (void)setFrame:(CGRect)frame{
    CGFloat margin = 12;
    frame.origin.x = margin;
    frame.size.width = SCREEN_WIDTH - margin*2;
    [super setFrame:frame];
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
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = 5 ;
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(15, self.contentView.height - 1, SCREEN_WIDTH - 15 * 4, 0.5)];
    line.backgroundColor = LineColor ;
    [self.contentView addSubview:line];  
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
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:IMAGE(@"正方形")];
    self.title.text = model.title ;
    self.desc.text = model.author ;
    self.time.text = model.duration;
}
#pragma mark --
#pragma mark --- ibaction

#pragma mark --
#pragma mark --- Method
@end
