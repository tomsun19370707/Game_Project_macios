//
//  MLChatRoomThemeGameSixFusionDialog.m
//  miliao
//
//  Created for Game 6 (玲珑珍宝塔) 门票融合说明与合成弹窗.
//

#import "MLChatRoomThemeGameSixFusionDialog.h"
#import "Global.h"
#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface MLChatRoomThemeGameSixFusionDialog ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *boardContainer;
@property (nonatomic, strong) UIImageView *boardBgImageView;

// 1. 顶部 3 配方槽位区
@property (nonatomic, strong) UIView *topSlotsContainer;
@property (nonatomic, strong) NSMutableArray<UIButton *> *slotButtons;

// 2. 中间融合动作按钮
@property (nonatomic, strong) UIButton *fusionActionButton;

// 3. 底部背包待选面板区
@property (nonatomic, strong) UIView *bottomPackPanelContainer;
@property (nonatomic, strong) UIImageView *packPanelBgImageView;
@property (nonatomic, strong) UIButton *prevButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) NSMutableArray<UIButton *> *itemButtons;

@end

@implementation MLChatRoomThemeGameSixFusionDialog

+ (void)showInView:(nullable UIView *)parentView {
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
    
    MLChatRoomThemeGameSixFusionDialog *dialog = [[MLChatRoomThemeGameSixFusionDialog alloc] initWithFrame:targetView.bounds];
    [targetView addSubview:dialog];
    [dialog animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _slotButtons = [NSMutableArray array];
        _itemButtons = [NSMutableArray array];
        [self setupUI];
    }
    return self;
}

#pragma mark - UI Setup (SUAS 375x812pt & ALURS Constraint Contract)

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
    
    // 1. 融合卷轴主背板容器 (锁死 614:879 高宽比与 330pt 适配宽度)
    _boardContainer = [[UIView alloc] init];
    _boardContainer.userInteractionEnabled = YES;
    [self addSubview:_boardContainer];
    
    CGFloat boardWidth = KDialogAdaptedWidth(330);
    CGFloat boardHeight = boardWidth * (879.0 / 614.0);
    
    [_boardContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(boardWidth, boardHeight));
    }];
    
    // 卷轴背景图 (theme_game_six_fusion_board_bg)
    _boardBgImageView = [[UIImageView alloc] init];
    _boardBgImageView.image = [UIImage imageNamed:@"theme_game_six_fusion_board_bg"];
    _boardBgImageView.contentMode = UIViewContentModeScaleToFill;
    [_boardContainer addSubview:_boardBgImageView];
    [_boardBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_boardContainer);
    }];
    
    // 2. 顶部 3 配方槽位区 (缩小2%至92.7x94.9pt)
    _topSlotsContainer = [[UIView alloc] init];
    [_boardContainer addSubview:_topSlotsContainer];
    [_topSlotsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(boardHeight * 0.10);
        make.centerX.mas_equalTo(_boardContainer);
        make.height.mas_equalTo(KDialogAdaptedWidth(94.9));
    }];
    
    UIView *lastSlotView = nil;
    for (int i = 0; i < 3; i++) {
        UIButton *slotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [slotBtn setBackgroundImage:[UIImage imageNamed:@"theme_game_six_fusion_slot_frame"] forState:UIControlStateNormal];
        slotBtn.contentMode = UIViewContentModeScaleToFill;
        slotBtn.imageView.contentMode = UIViewContentModeScaleToFill;
        slotBtn.tag = i + 1;
        [slotBtn addTarget:self action:@selector(slotClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topSlotsContainer addSubview:slotBtn];
        [_slotButtons addObject:slotBtn];
        
        [slotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_topSlotsContainer);
            make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(92.7), KDialogAdaptedWidth(94.9)));
            if (lastSlotView) {
                make.leading.mas_equalTo(lastSlotView.mas_trailing).offset(KDialogAdaptedWidth(6));
            } else {
                make.leading.mas_equalTo(_topSlotsContainer);
            }
        }];
        lastSlotView = slotBtn;
    }
    if (lastSlotView) {
        [_topSlotsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(lastSlotView.mas_trailing);
        }];
    }
    
    // 3. 中间融合操作按钮 (Top 36% 区域 210x56pt)
    _fusionActionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_fusionActionButton setBackgroundImage:[UIImage imageNamed:@"theme_game_six_fusion_btn_action"] forState:UIControlStateNormal];
    _fusionActionButton.contentMode = UIViewContentModeScaleToFill;
    _fusionActionButton.imageView.contentMode = UIViewContentModeScaleToFill;
    [_fusionActionButton addTarget:self action:@selector(fusionActionClick) forControlEvents:UIControlEventTouchUpInside];
    [_boardContainer addSubview:_fusionActionButton];
    [_fusionActionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(boardHeight * 0.36);
        make.centerX.mas_equalTo(_boardContainer);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(210), KDialogAdaptedWidth(56)));
    }];
    
    // 4. 底部背包待选面板区 (Top 53% ~ 91% 区域)
    _bottomPackPanelContainer = [[UIView alloc] init];
    _bottomPackPanelContainer.clipsToBounds = NO; // 允许两侧指示箭头向外突出 -16pt
    [_boardContainer addSubview:_bottomPackPanelContainer];
    [_bottomPackPanelContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(boardHeight * 0.53);
        make.height.mas_equalTo(boardHeight * (0.91 - 0.53));
        make.leading.mas_equalTo(KDialogAdaptedWidth(30));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(30));
    }];
    
    _packPanelBgImageView = [[UIImageView alloc] init];
    _packPanelBgImageView.image = [UIImage imageNamed:@"theme_game_six_fusion_pack_panel_bg"];
    _packPanelBgImageView.contentMode = UIViewContentModeScaleToFill;
    [_bottomPackPanelContainer addSubview:_packPanelBgImageView];
    [_packPanelBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_bottomPackPanelContainer);
    }];
    
    // 4.1 左指示箭头按钮 (放大10%至52.8x40.7pt，向外突出 -16pt)
    _prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_prevButton setBackgroundImage:[UIImage imageNamed:@"theme_game_six_fusion_btn_prev"] forState:UIControlStateNormal];
    _prevButton.contentMode = UIViewContentModeScaleToFill;
    _prevButton.imageView.contentMode = UIViewContentModeScaleToFill;
    [_prevButton addTarget:self action:@selector(prevClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomPackPanelContainer addSubview:_prevButton];
    [_prevButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(26));
        make.leading.mas_equalTo(-KDialogAdaptedWidth(16));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(52.8), KDialogAdaptedWidth(40.7)));
    }];
    
    // 4.2 右指示箭头按钮 (放大10%至52.8x40.7pt，向外突出 16pt)
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextButton setBackgroundImage:[UIImage imageNamed:@"theme_game_six_fusion_btn_next"] forState:UIControlStateNormal];
    _nextButton.contentMode = UIViewContentModeScaleToFill;
    _nextButton.imageView.contentMode = UIViewContentModeScaleToFill;
    [_nextButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomPackPanelContainer addSubview:_nextButton];
    [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(26));
        make.trailing.mas_equalTo(KDialogAdaptedWidth(16));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(52.8), KDialogAdaptedWidth(40.7)));
    }];
    
    // 4.3 底部 3 个待选背包礼物卡槽 (放大10%至79.2x81.4pt，间距 8pt，向下偏移20pt)
    UIView *itemsRowView = [[UIView alloc] init];
    [_bottomPackPanelContainer addSubview:itemsRowView];
    [itemsRowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_bottomPackPanelContainer).offset(KDialogAdaptedWidth(20));
        make.centerX.mas_equalTo(_bottomPackPanelContainer);
        make.height.mas_equalTo(KDialogAdaptedWidth(81.4));
    }];
    
    UIView *lastItemView = nil;
    for (int j = 0; j < 3; j++) {
        UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemBtn setBackgroundImage:[UIImage imageNamed:@"theme_game_six_fusion_item_frame"] forState:UIControlStateNormal];
        itemBtn.contentMode = UIViewContentModeScaleToFill;
        itemBtn.imageView.contentMode = UIViewContentModeScaleToFill;
        itemBtn.tag = j + 1;
        [itemBtn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [itemsRowView addSubview:itemBtn];
        [_itemButtons addObject:itemBtn];
        
        [itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(itemsRowView);
            make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(79.2), KDialogAdaptedWidth(81.4)));
            if (lastItemView) {
                make.leading.mas_equalTo(lastItemView.mas_trailing).offset(KDialogAdaptedWidth(8));
            } else {
                make.leading.mas_equalTo(itemsRowView);
            }
        }];
        lastItemView = itemBtn;
    }
    if (lastItemView) {
        [itemsRowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(lastItemView.mas_trailing);
        }];
    }
}

#pragma mark - User Interaction Callbacks

- (void)fusionActionClick {
    [SVProgressHUD showInfoWithStatus:@"正在校验融合配方并生成门票..."];
}

- (void)prevClick {
    [SVProgressHUD showInfoWithStatus:@"已切换至上一页"];
}

- (void)nextClick {
    [SVProgressHUD showInfoWithStatus:@"已切换至下一页"];
}

- (void)slotClick:(UIButton *)btn {
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"清空融合槽位 %ld", (long)btn.tag]];
}

- (void)itemClick:(UIButton *)btn {
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"已选择礼物 %ld 加入融合槽位", (long)btn.tag]];
}

#pragma mark - Animations & Dismissal

- (void)animateShow {
    self.alpha = 0.0;
    _boardContainer.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
        self.boardContainer.transform = CGAffineTransformIdentity;
    }];
}

- (void)closeClick {
    [self dismiss];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
        self.boardContainer.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
