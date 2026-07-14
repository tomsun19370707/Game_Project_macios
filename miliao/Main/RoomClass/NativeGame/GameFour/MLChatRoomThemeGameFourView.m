//
//  MLChatRoomThemeGameFourView.m
//  miliao
//

#import "MLChatRoomThemeGameFourView.h"
#import <Masonry/Masonry.h>

@interface MLChatRoomThemeGameFourView ()

@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation MLChatRoomThemeGameFourView

+ (void)showInView:(UIView *)parentView typeId:(NSInteger)typeId {
    if (!parentView) return;
    
    // Remove existing if any
    for (UIView *subview in parentView.subviews) {
        if ([subview isKindOfClass:[MLChatRoomThemeGameFourView class]]) {
            [subview removeFromSuperview];
        }
    }
    
    MLChatRoomThemeGameFourView *gameView = [[MLChatRoomThemeGameFourView alloc] initWithFrame:parentView.bounds typeId:typeId];
    [parentView addSubview:gameView];
    [gameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(parentView);
    }];
}

- (instancetype)initWithFrame:(CGRect)frame typeId:(NSInteger)typeId {
    self = [super initWithFrame:frame];
    if (self) {
        _typeId = typeId;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [_maskView addGestureRecognizer:tap];
    
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = RGBA(30, 36, 50, 1.0);
    _contentView.layer.cornerRadius = 16;
    _contentView.layer.masksToBounds = YES;
    [self addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(@300);
        make.height.mas_equalTo(@200);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    NSString *bagName = @"福袋";
    if (_typeId == 8) {
        bagName = @"青玉福袋";
    } else if (_typeId == 9) {
        bagName = @"碧海福袋";
    } else if (_typeId == 10) {
        bagName = @"鎏金福袋";
    }
    titleLabel.text = [NSString stringWithFormat:@"%@ (已开奖)", bagName];
    [_contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_contentView).offset(30);
        make.leading.trailing.mas_equalTo(_contentView);
        make.height.mas_equalTo(@25);
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.textColor = RGBA(207, 221, 248, 0.8);
    descLabel.font = [UIFont systemFontOfSize:14];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.numberOfLines = 0;
    descLabel.text = @"玩法4主界面正在开发中...\n感谢您的体验！";
    [_contentView addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(20);
        make.leading.mas_equalTo(_contentView).offset(20);
        make.trailing.mas_equalTo(_contentView).offset(-20);
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setTitle:@"确定" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    closeBtn.backgroundColor = RGBA(180, 0, 230, 1.0);
    closeBtn.layer.cornerRadius = 18;
    closeBtn.layer.masksToBounds = YES;
    [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_contentView).offset(-20);
        make.centerX.mas_equalTo(_contentView);
        make.width.mas_equalTo(@120);
        make.height.mas_equalTo(@36);
    }];
}

- (void)close {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
