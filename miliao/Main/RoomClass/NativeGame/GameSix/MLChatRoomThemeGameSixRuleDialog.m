//
//  MLChatRoomThemeGameSixRuleDialog.m
//  miliao
//
//  Created for Game 6 (玲珑珍宝塔) 游戏规则说明弹窗.
//

#import "MLChatRoomThemeGameSixRuleDialog.h"
#import "Global.h"
#import <Masonry/Masonry.h>

static NSString * const kDefaultRuleContent = 
    @"1. 🏰 塔层与进阶规则：\n"
     "全塔共 7 层（1层➜7层）。每层包含 5 种礼物，按价值从左到右递增。\n"
     "• 抽中第 5 种（最右侧最高价值礼物）：直上 2 层；\n"
     "• 抽中第 4 种（右二第二高价值礼物）：直上 1 层；\n"
     "• 抽中第 1~3 种礼物：保持在当前层。\n\n"
     "2. ⚠️ 边界与重置规则：\n"
     "• 处于第 6 层时抽中最高价值礼物（直上2层），直接升至第 7 层封顶；\n"
     "• 处于第 7 层时再次抽中进阶礼物（第 4 或 5 种），清零重置回到第 1 层。\n\n"
     "3. 🎟️ 门票与重铸规则：\n"
     "• 在【主页融合】弹窗中可选择背包礼物或已抽中礼物进行融合；只要选中礼物总价值达到阈值，即可融合成 1 张门票；\n"
     "• 1 张门票包含 7 次抽奖/重铸次数（重铸 7 次）。\n\n"
     "4. 🎁 暂存与取回规则：\n"
     "• 抽中礼物后存入暂存池，可在【礼物包】中查看存货，随时放入大背包。";

@interface MLChatRoomThemeGameSixRuleDialog ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *rulePanelContainer;
@property (nonatomic, strong) UIImageView *ruleBgImageView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *ruleLabel;

@property (nonatomic, copy) NSString *ruleContent;

@end

@implementation MLChatRoomThemeGameSixRuleDialog

+ (void)showInView:(nullable UIView *)parentView {
    [self showInView:parentView ruleContent:nil];
}

+ (void)showInView:(nullable UIView *)parentView ruleContent:(nullable NSString *)ruleContent {
    UIView *targetView = parentView;
    if (!targetView) {
        targetView = [UIApplication sharedApplication].keyWindow;
    }
    if (!targetView) {
        for (UIWindow *w in [UIApplication sharedApplication].windows) {
            if (w.isKeyWindow) {
                targetView = w;
                break;
            }
        }
    }
    if (!targetView) {
        targetView = [UIApplication sharedApplication].windows.firstObject;
    }
    if (!targetView) {
        return;
    }
    
    MLChatRoomThemeGameSixRuleDialog *dialog = [[MLChatRoomThemeGameSixRuleDialog alloc] initWithFrame:targetView.bounds ruleContent:ruleContent];
    [targetView addSubview:dialog];
    [dialog animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame ruleContent:(NSString *)ruleContent {
    if (self = [super initWithFrame:frame]) {
        if (ruleContent.length > 0) {
            _ruleContent = [ruleContent copy];
        } else {
            _ruleContent = kDefaultRuleContent;
        }
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    // 0. 全屏半透明遮罩
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _maskView.userInteractionEnabled = YES;
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
    [_maskView addGestureRecognizer:tap];
    
    // 1. 羊皮纸规则背板主容器 (锁死 748:1118 高宽比例与最大宽度 350pt)
    _rulePanelContainer = [[UIView alloc] init];
    _rulePanelContainer.userInteractionEnabled = YES;
    [self addSubview:_rulePanelContainer];
    
    CGFloat panelWidth = KDialogAdaptedWidth(350);
    CGFloat panelHeight = panelWidth * (1118.0 / 748.0);
    
    [_rulePanelContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(panelWidth, panelHeight));
    }];
    
    // 2. 羊皮纸背景图 (theme_game_six_rule_bg)
    _ruleBgImageView = [[UIImageView alloc] init];
    _ruleBgImageView.image = [UIImage imageNamed:@"theme_game_six_rule_bg"];
    _ruleBgImageView.contentMode = UIViewContentModeScaleToFill;
    [_rulePanelContainer addSubview:_ruleBgImageView];
    [_ruleBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_rulePanelContainer);
    }];
    
    // 3. 右上角关闭按钮 (theme_game_six_rule_close 35x35pt)
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"theme_game_six_rule_close"] forState:UIControlStateNormal];
    _closeButton.contentMode = UIViewContentModeScaleToFill;
    _closeButton.imageView.contentMode = UIViewContentModeScaleToFill;
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_rulePanelContainer addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(68));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(28));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(35), KDialogAdaptedWidth(35)));
    }];
    
    // 4. 可垂直平滑滑动的规则 ScrollView
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    [_rulePanelContainer addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(85));
        make.leading.mas_equalTo(KDialogAdaptedWidth(30));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(30));
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(35));
    }];
    
    // 5. 多行规则文本 Label (色号 #5C3A1A，字号 13pt，行间距 5pt)
    _ruleLabel = [[UILabel alloc] init];
    _ruleLabel.numberOfLines = 0;
    _ruleLabel.textColor = [UIColor colorWithRed:0x5C/255.0 green:0x3A/255.0 blue:0x1A/255.0 alpha:1.0];
    _ruleLabel.font = [UIFont systemFontOfSize:KDialogAdaptedWidth(13)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = KDialogAdaptedWidth(5);
    NSDictionary *attributes = @{
        NSFontAttributeName: [UIFont systemFontOfSize:KDialogAdaptedWidth(13)],
        NSForegroundColorAttributeName: [UIColor colorWithRed:0x5C/255.0 green:0x3A/255.0 blue:0x1A/255.0 alpha:1.0],
        NSParagraphStyleAttributeName: paragraphStyle
    };
    _ruleLabel.attributedText = [[NSAttributedString alloc] initWithString:_ruleContent attributes:attributes];
    
    [_scrollView addSubview:_ruleLabel];
    [_ruleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.trailing.mas_equalTo(_scrollView);
        make.width.mas_equalTo(_scrollView);
    }];
}

#pragma mark - Animations & Dismissal

- (void)animateShow {
    self.alpha = 0.0;
    _rulePanelContainer.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
        self.rulePanelContainer.transform = CGAffineTransformIdentity;
    }];
}

- (void)closeClick {
    [self dismiss];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
        self.rulePanelContainer.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
