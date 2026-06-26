#import "MLChatRoomThemeGameTwoResultView.h"
#import "Global.h"

@interface MLChatRoomThemeGameTwoResultView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *retryButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *totalValueLabel;

@property (nonatomic, strong) NSArray<MLGameDrawResultModel *> *mergedGifts;
@property (nonatomic, assign) NSInteger totalValue;
@property (nonatomic, copy) void(^retryBlock)(void);

@end

@implementation MLChatRoomThemeGameTwoResultView

+ (void)showInView:(UIView *)parentView 
             gifts:(NSArray<MLGameDrawResultModel *> *)gifts 
        totalValue:(NSInteger)value 
        retryBlock:(void(^)(void))retry {
    MLChatRoomThemeGameTwoResultView *resultView = [[MLChatRoomThemeGameTwoResultView alloc] initWithFrame:parentView.bounds 
                                                                                                    gifts:gifts 
                                                                                               totalValue:value 
                                                                                               retryBlock:retry];
    [parentView addSubview:resultView];
    [resultView animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame 
                        gifts:(NSArray<MLGameDrawResultModel *> *)gifts 
                   totalValue:(NSInteger)value 
                   retryBlock:(void(^)(void))retry {
    if (self = [super initWithFrame:frame]) {
        self.retryBlock = retry;
        self.totalValue = value;
        
        // 核心算法：进行有序中奖结果去重合并，保障展示顺序和数量累加
        self.mergedGifts = [MLGameDrawResultModel mergeAndSortDrawGifts:gifts];
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    // 背景蒙层
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    // 弹窗外框背景
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_two_result_bg"];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
    _bgImageView.userInteractionEnabled = YES;
    [self addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(315, 470));
    }];
    
    // 关闭按钮
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:[UIImage imageNamed:@"theme_game_two_purchase_back"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KAdaptedHeight(16));
        make.trailing.mas_equalTo(-KAdaptedWidth(16));
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    // 总计价值 Label
    _totalValueLabel = [[UILabel alloc] init];
    _totalValueLabel.textColor = mHexRGB(0xFFE400); // 黄色文字突出价值
    _totalValueLabel.font = [UIFont boldSystemFontOfSize:16];
    _totalValueLabel.text = [NSString stringWithFormat:@"获得总价值: %ld 钻石", (long)self.totalValue];
    [_bgImageView addSubview:_totalValueLabel];
    [_totalValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KAdaptedHeight(60));
        make.centerX.mas_equalTo(_bgImageView);
    }];
    
    // 滚动奖品展示区域
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = YES;
    [_bgImageView addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_totalValueLabel.mas_bottom).offset(KAdaptedHeight(20));
        make.leading.mas_equalTo(KAdaptedWidth(20));
        make.trailing.mas_equalTo(-KAdaptedWidth(20));
        make.bottom.mas_equalTo(-KAdaptedHeight(80));
    }];
    
    [self layoutGiftsInScrollView];
    
    // “再抽一次”按钮
    _retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_retryButton setImage:[UIImage imageNamed:@"theme_game_two_purchase_confirm"] forState:UIControlStateNormal]; // 复用底图或标题
    [_retryButton setTitle:@"再抽一次" forState:UIControlStateNormal];
    [_retryButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _retryButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [_retryButton addTarget:self action:@selector(retryClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_retryButton];
    [_retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bgImageView);
        make.bottom.mas_equalTo(-KAdaptedHeight(25));
        make.size.mas_equalTo(CGSizeMake(160, 32));
    }];
}

#pragma mark - 奖品格自适应排布
- (void)layoutGiftsInScrollView {
    CGFloat itemW = 64.0f;
    CGFloat itemH = 80.0f;
    CGFloat gap = 12.0f;
    NSInteger colCount = 3; // 3列
    
    for (int i = 0; i < self.mergedGifts.count; i++) {
        MLGameDrawResultModel *gift = self.mergedGifts[i];
        
        NSInteger row = i / colCount;
        NSInteger col = i % colCount;
        
        UIView *itemBg = [[UIView alloc] init];
        itemBg.backgroundColor = [UIColor colorWithWhite:1 alpha:0.05];
        setViewCorner(itemBg, 6);
        [_scrollView addSubview:itemBg];
        [itemBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(row * (itemH + gap));
            make.leading.mas_equalTo(col * (itemW + gap) + KAdaptedWidth(10));
            make.size.mas_equalTo(CGSizeMake(itemW, itemH));
        }];
        
        // 礼物图
        UIImageView *giftImg = [[UIImageView alloc] init];
        giftImg.contentMode = UIViewContentModeScaleAspectFit;
        [itemBg addSubview:giftImg];
        [giftImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(6);
            make.centerX.mas_equalTo(itemBg);
            make.size.mas_equalTo(CGSizeMake(48, 48));
        }];
        
        NSURL *url = [NSURL URLWithString:[gift imageUrl]];
        if ([giftImg respondsToSelector:@selector(setImageWithURL:placeholder:)]) {
            [giftImg performSelector:@selector(setImageWithURL:placeholder:) withObject:url withObject:[UIImage imageNamed:@""]];
        } else if ([giftImg respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:)]) {
            [giftImg performSelector:@selector(sd_setImageWithURL:placeholderImage:) withObject:url withObject:[UIImage imageNamed:@""]];
        }
        
        // 数量角标 (右上角红色高保真)
        UILabel *numLabel = [[UILabel alloc] init];
        numLabel.textColor = kWhiteColor;
        numLabel.backgroundColor = [UIColor redColor];
        numLabel.font = KFontA(9);
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.text = [NSString stringWithFormat:@"x%ld", (long)gift.num];
        setViewCorner(numLabel, 6);
        [itemBg addSubview:numLabel];
        [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(giftImg);
            make.trailing.mas_equalTo(giftImg).offset(4);
            make.height.mas_equalTo(12);
            make.width.mas_greaterThanOrEqualTo(16);
        }];
        
        // 名字
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = kWhiteColor;
        nameLabel.font = KFontA(10);
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = gift.name;
        [itemBg addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-4);
            make.leading.trailing.mas_equalTo(itemBg);
        }];
    }
    
    // 设置 ScrollView 滚动区域
    NSInteger totalRows = (self.mergedGifts.count + colCount - 1) / colCount;
    CGFloat contentH = totalRows * (itemH + gap) + gap;
    _scrollView.contentSize = CGSizeMake(315 - 40, contentH);
}

#pragma mark - 交互
- (void)retryClick {
    // 快速连抽：跳过主页面 loadData 更新，直接本地发起连抽以保障体验
    if (self.retryBlock) {
        self.retryBlock();
    }
    [self dismiss];
}

- (void)closeClick {
    [self dismiss];
}

- (void)animateShow {
    self.alpha = 0.0;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
