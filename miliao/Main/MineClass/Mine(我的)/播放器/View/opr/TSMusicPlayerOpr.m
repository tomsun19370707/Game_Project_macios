//
//  TSMusicPlayerOpr.m
//  TreasureUser
//
//  Created by Dylan on 2024/12/20.
//

#import "TSMusicPlayerOpr.h"
@interface TSMusicPlayerOpr ()
/** View */
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *author;

@end

@implementation TSMusicPlayerOpr

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
    /** 默认*/
    self.playMode = 1 ;
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
    @weakify(self);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self);
        if (self.fetchClickMusicLook) {
            self.fetchClickMusicLook();
        }
    }];
    [self.title addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]init];
    [[tap2 rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self);
        if (self.fetchClickMusicLook) {
            self.fetchClickMusicLook();
        }
    }];
    [self.author addGestureRecognizer:tap2];
}

#pragma mark -
#pragma mark --- Getter

#pragma mark --
#pragma mark --- Setter
-(void)setModel:(GoodListInfoModel *)model
{
    self.title.text = model.title;
    self.author.text = model.author ;
}
#pragma mark --
#pragma mark --- ibaction
- (IBAction)frontAc:(id)sender {
    /** 上一首*/
    if (self.fetchClick) {
        self.fetchClick(0);
    }
}
- (IBAction)nextAc:(id)sender {
    /** 下一首*/
    if (self.fetchClick) {
        self.fetchClick(1);
    }
}
- (IBAction)oprAc:(id)sender {
    /** 播放暂停*/
    if (self.fetchClick) {
        self.fetchClick(2);
    }
}
- (IBAction)modeSwitch:(id)sender {
    /** 模式切换 1列表循环 2随机 3单曲 */
    self.playMode ++ ;
    
    if (self.playMode > 3) {
        self.playMode = 1 ;
    }
    
    switch (self.playMode) {
        case 1:
            [self.modeBtn setBackgroundImage:IMAGE(@"mp_mode_circle") forState:UIControlStateNormal];
            break;
        case 2:
            [self.modeBtn setBackgroundImage:IMAGE(@"mp_mode_random") forState:UIControlStateNormal];
            break;
        case 3:
            [self.modeBtn setBackgroundImage:IMAGE(@"mp_mode_repeat") forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}
#pragma mark --
#pragma mark --- Method
@end
