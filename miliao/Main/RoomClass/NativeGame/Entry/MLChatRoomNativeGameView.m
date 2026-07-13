#import "MLChatRoomNativeGameView.h"
#import "MLChatRoomNativeGameCell.h"
#import "MLChatRoomThemeGameOneView.h"
#import "MLChatRoomThemeGameTwoView.h"
#import "MLChatRoomThemeGameThreeView.h"
#import "Global.h"

@interface MLChatRoomNativeGameView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *bgImageView; // 背景底板
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation MLChatRoomNativeGameView

+ (void)showInView:(UIView *)parentView {
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
        targetView = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    }
    if (!targetView) {
        return;
    }
    
    MLChatRoomNativeGameView *view = [[MLChatRoomNativeGameView alloc] initWithFrame:targetView.bounds];
    [targetView addSubview:view];
    [view animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _maskView.userInteractionEnabled = YES;
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
    [_maskView addGestureRecognizer:tap];
    
    // 背景底板 (youxi_dialog_bg, 297 * 393 pt)
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"youxi_dialog_bg"];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.userInteractionEnabled = YES;
    [self addSubview:_bgImageView];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(297), KAdaptedWidth(393)));
    }];
    
    // 标题 (15 pt bold, top 16 pt, color #FFFFFF)
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"抽奖盘";
    _titleLabel.textColor = kWhiteColor;
    _titleLabel.font = KFontBoldA(15);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_bgImageView addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.centerX.mas_equalTo(_bgImageView);
    }];
    
    // 右上角关闭按钮 (img_cancal, 24 * 24 pt, top 14 pt, right 14 pt)
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *closeImg = [UIImage imageNamed:@"img_cancal"];
    if (closeImg) {
        [_closeButton setImage:closeImg forState:UIControlStateNormal];
    } else {
        [_closeButton setTitle:@"✕" forState:UIControlStateNormal];
        [_closeButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_closeButton];
    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.trailing.mas_equalTo(-14);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    // UICollectionView (Cell 72 * 90 pt, 3列布局, minimumLineSpacing = 6, minimumInteritemSpacing = 16)
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(KAdaptedWidth(72), KAdaptedWidth(90));
    layout.minimumLineSpacing = KAdaptedWidth(6);
    layout.minimumInteritemSpacing = KAdaptedWidth(16);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = NO;
    [_collectionView registerClass:[MLChatRoomNativeGameCell class] forCellWithReuseIdentifier:[MLChatRoomNativeGameCell cellIdentifier]];
    [_bgImageView addSubview:_collectionView];
    
    // 距弹窗顶部 87 pt，距左右边缘各 20 pt，距底部 11 pt
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KAdaptedWidth(87));
        make.leading.mas_equalTo(KAdaptedWidth(20));
        make.trailing.mas_equalTo(-KAdaptedWidth(20));
        make.bottom.mas_equalTo(-KAdaptedWidth(11));
    }];
}

#pragma mark - UICollectionViewDataSource & Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 7; // 7个格子
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MLChatRoomNativeGameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MLChatRoomNativeGameCell cellIdentifier] forIndexPath:indexPath];
    
    if (indexPath.item == 0) {
        [cell configureWithTitle:@"寻梦之旅"
                       logoName:@"native_game_one_preview"
                      textColor:[UIColor blackColor]];
    } else if (indexPath.item == 1) {
        [cell configureWithTitle:@"神木栖灵"
                       logoName:@"theme_game_two_entry_icon"
                      textColor:[UIColor blackColor]];
    } else if (indexPath.item == 2) {
        [cell configureWithTitle:@"星辰序章"
                       logoName:@"native_game_entry_icon"
                      textColor:[UIColor blackColor]];
    } else {
        [cell configureWithTitle:@"敬请期待"
                       logoName:@"chat_room_plate_draw"
                      textColor:mHexRGB(0x9E9E9E)];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item >= 3) {
        // “敬请期待”格子 -> 拦截点击事件，直接忽略
        return;
    }
    
    UIView *parentView = self.superview;
    [self dismissWithCompletion:^{
        if (indexPath.item == 0) {
            // 打开玩法1 (寻梦之旅, lottery_id = 7, typeId = 7)
            [MLChatRoomThemeGameOneView showInView:parentView typeId:7];
        } else if (indexPath.item == 1) {
            // 打开玩法2 (神木栖灵, lottery_id = 2, typeId = 6)
            [MLChatRoomThemeGameTwoView showInView:parentView typeId:6];
        } else if (indexPath.item == 2) {
            // 打开玩法3 (星辰序章, lottery_id = 3, typeId = 7)
            [MLChatRoomThemeGameThreeView showInView:parentView typeId:7];
        }
    }];
}

#pragma mark - Animation

- (void)animateShow {
    self.alpha = 0.0;
    _bgImageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1.0;
        self.bgImageView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)closeClick {
    [self dismissWithCompletion:nil];
}

- (void)dismissWithCompletion:(void (^ _Nullable)(void))completion {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
        self.bgImageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}

@end
