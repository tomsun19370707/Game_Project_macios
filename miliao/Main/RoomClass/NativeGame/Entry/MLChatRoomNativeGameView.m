#import "MLChatRoomNativeGameView.h"
#import "MLChatRoomNativeGameCell.h"
#import "MLChatRoomThemeGameOneView.h"
#import "MLChatRoomThemeGameTwoView.h"
#import "Global.h"

@interface MLChatRoomNativeGameView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MLChatRoomNativeGameView

+ (void)showInView:(UIView *)parentView {
    MLChatRoomNativeGameView *view = [[MLChatRoomNativeGameView alloc] initWithFrame:parentView.bounds];
    [parentView addSubview:view];
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
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    _maskView.userInteractionEnabled = YES;
    [self addSubview:_maskView];
    
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMaskTap:)];
    [_maskView addGestureRecognizer:tap];
    
    // 弹窗容器 (居中, 315 * 280)
    _containerView = [[UIView alloc] init];
    _containerView.backgroundColor = mHexRGB(0x1B1923); // 深紫灰色调背景
    setViewCorner(_containerView, 16);
    [self addSubview:_containerView];
    
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(315, 280));
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"游戏大厅";
    _titleLabel.textColor = kWhiteColor;
    _titleLabel.font = KFontBoldA(18);
    [_containerView addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.centerX.mas_equalTo(_containerView);
    }];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    // 如果有通用的关闭按钮，或者用 theme_game_one_result_close，或者用文字 X
    UIImage *closeImg = [UIImage imageNamed:@"theme_game_one_result_close"];
    if (closeImg) {
        [_closeButton setImage:closeImg forState:UIControlStateNormal];
    } else {
        [_closeButton setTitle:@"✕" forState:UIControlStateNormal];
        [_closeButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _closeButton.titleLabel.font = KFontA(20);
    }
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_containerView addSubview:_closeButton];
    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.trailing.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 90;
    _tableView.scrollEnabled = NO;
    [_tableView registerClass:[MLChatRoomNativeGameCell class] forCellReuseIdentifier:[MLChatRoomNativeGameCell cellIdentifier]];
    [_containerView addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(15);
        make.leading.trailing.bottom.mas_equalTo(_containerView);
    }];
}

#pragma mark - UITableViewDataSource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLChatRoomNativeGameCell *cell = [tableView dequeueReusableCellWithIdentifier:[MLChatRoomNativeGameCell cellIdentifier] forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        [cell configureWithTitle:@"寻梦之旅"
                       subtitle:@"开启您的寻梦转盘之旅"
                      bgImgName:@"native_game_one_bg"
                    logoImgName:@"theme_game_one_cover_box"];
    } else {
        [cell configureWithTitle:@"神木栖灵"
                       subtitle:@"凝聚灵力 供奉神木"
                      bgImgName:@"native_game_two_bg"
                    logoImgName:@"theme_game_two_center_fruit"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIView *parentView = self.superview;
    [self dismissWithCompletion:^{
        if (indexPath.row == 0) {
            // 打开玩法1
            [MLChatRoomThemeGameOneView showInView:parentView typeId:3];
        } else {
            // 打开玩法2
            [MLChatRoomThemeGameTwoView showInView:parentView typeId:4];
        }
    }];
}

#pragma mark - Animation

- (void)animateShow {
    self.alpha = 0.0;
    _containerView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1.0;
        self.containerView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)closeClick {
    [self dismissWithCompletion:nil];
}

- (void)handleMaskTap:(UITapGestureRecognizer *)sender {
    [self dismissWithCompletion:nil];
}

- (void)dismissWithCompletion:(void(^ _Nullable)(void))completion {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
        self.containerView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}

@end
