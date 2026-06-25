//
//  TSMusicPlayerInfo.m
//  TreasureUser
//
//  Created by Dylan on 2024/12/20.
//

#import "TSMusicPlayerInfo.h"
@interface TSMusicPlayerInfo ()
/** View */
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@end

@implementation TSMusicPlayerInfo

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
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = 8 ;
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
}
#pragma mark --
#pragma mark --- ibaction

#pragma mark --
#pragma mark --- Method
@end
