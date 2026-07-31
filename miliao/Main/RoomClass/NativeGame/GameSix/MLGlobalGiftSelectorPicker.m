//
//  MLGlobalGiftSelectorPicker.m
//  miliao
//

#import "MLGlobalGiftSelectorPicker.h"
#import "Global.h"
#import <Masonry/Masonry.h>

@interface MLGlobalGiftSelectorPicker () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSInteger slotIndex;
@property (nonatomic, strong) NSArray<MLCandidateItemModel *> *items;
@property (nonatomic, copy) MLGlobalGiftSelectBlock selectBlock;

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *contentCard;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomBarView;
@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation MLGlobalGiftSelectorPicker

+ (void)showWithSlotIndex:(NSInteger)slotIndex
                    items:(NSArray<MLCandidateItemModel *> *)items
              selectBlock:(MLGlobalGiftSelectBlock)selectBlock {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (!keyWindow) {
        keyWindow = [UIApplication sharedApplication].windows.firstObject;
    }
    if (!keyWindow) return;
    
    MLGlobalGiftSelectorPicker *picker = [[MLGlobalGiftSelectorPicker alloc] initWithFrame:keyWindow.bounds
                                                                                 slotIndex:slotIndex
                                                                                     items:items
                                                                               selectBlock:selectBlock];
    [keyWindow addSubview:picker];
    [picker animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame
                    slotIndex:(NSInteger)slotIndex
                        items:(NSArray<MLCandidateItemModel *> *)items
                  selectBlock:(MLGlobalGiftSelectBlock)selectBlock {
    if (self = [super initWithFrame:frame]) {
        _slotIndex = slotIndex;
        _items = items ?: @[];
        _selectBlock = selectBlock;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    // 1. 半透明遮罩
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_maskView addGestureRecognizer:tap];
    
    // 2. 白色圆角居中面板 (1:1 还原 temp/样式.png)
    _contentCard = [[UIView alloc] init];
    _contentCard.backgroundColor = [UIColor whiteColor];
    _contentCard.layer.cornerRadius = KDialogAdaptedWidth(12);
    _contentCard.layer.masksToBounds = YES;
    [self addSubview:_contentCard];
    
    CGFloat cardWidth = KDialogAdaptedWidth(310);
    CGFloat cardHeight = KDialogAdaptedWidth(450);
    [_contentCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(cardWidth, cardHeight));
    }];
    
    // 2.1 顶部标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = [NSString stringWithFormat:@"选择全局大背包礼物放入【槽位 %ld】", (long)(_slotIndex + 1)];
    _titleLabel.textColor = [UIColor colorWithRed:0x22/255.0 green:0x22/255.0 blue:0x22/255.0 alpha:1.0];
    _titleLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(16)];
    _titleLabel.numberOfLines = 2;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [_contentCard addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(16));
        make.leading.mas_equalTo(KDialogAdaptedWidth(18));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(18));
    }];
    
    // 2.2 底部同一行按钮栏 (高度 50pt，分隔线)
    _bottomBarView = [[UIView alloc] init];
    _bottomBarView.backgroundColor = [UIColor whiteColor];
    [_contentCard addSubview:_bottomBarView];
    [_bottomBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.mas_equalTo(_contentCard);
        make.height.mas_equalTo(KDialogAdaptedWidth(50));
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithRed:0xEE/255.0 green:0xEE/255.0 blue:0xEE/255.0 alpha:1.0];
    [_bottomBarView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(_bottomBarView);
        make.height.mas_equalTo(1.0 / [UIScreen mainScreen].scale);
    }];
    
    // 同一行放置【清空此槽位】与【取消】按钮
    UIColor *themeGreen = [UIColor colorWithRed:0x00/255.0 green:0x85/255.0 blue:0x77/255.0 alpha:1.0];
    
    _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_clearButton setTitle:@"清空此槽位" forState:UIControlStateNormal];
    [_clearButton setTitleColor:themeGreen forState:UIControlStateNormal];
    _clearButton.titleLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(14)];
    [_clearButton addTarget:self action:@selector(clearClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBarView addSubview:_clearButton];
    [_clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(18));
        make.centerY.mas_equalTo(_bottomBarView);
    }];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:themeGreen forState:UIControlStateNormal];
    _cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(14)];
    [_cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBarView addSubview:_cancelButton];
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(18));
        make.centerY.mas_equalTo(_bottomBarView);
    }];
    
    // 2.3 中间列表
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    [_contentCard addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(KDialogAdaptedWidth(12));
        make.bottom.mas_equalTo(_bottomBarView.mas_top);
        make.leading.trailing.mas_equalTo(_contentCard);
    }];
}

#pragma mark - UITableView DataSource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KDialogAdaptedWidth(42);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"MLGlobalGiftCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    // 清理旧视图
    for (UIView *sub in cell.contentView.subviews) {
        [sub removeFromSuperview];
    }
    
    MLCandidateItemModel *item = _items[indexPath.row];
    
    UILabel *lb = [[UILabel alloc] init];
    lb.textColor = [UIColor colorWithRed:0x33/255.0 green:0x33/255.0 blue:0x33/255.0 alpha:1.0];
    lb.font = [UIFont systemFontOfSize:KDialogAdaptedWidth(14)];
    
    NSString *numStr = item.num > 0 ? [NSString stringWithFormat:@" x%ld", (long)item.num] : @"";
    lb.text = [NSString stringWithFormat:@"%ld. %@%@", (long)(indexPath.row + 1), item.name ?: @"", numStr];
    [cell.contentView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(cell.contentView);
        make.leading.mas_equalTo(KDialogAdaptedWidth(18));
    }];
    
    // 钻石图标
    UIImageView *diamondIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"theme_game_six_ic_token"]];
    diamondIV.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:diamondIV];
    [diamondIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(cell.contentView);
        make.leading.mas_equalTo(lb.mas_trailing).offset(KDialogAdaptedWidth(6));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(14), KDialogAdaptedWidth(14)));
    }];
    
    // 价值文本
    UILabel *valLb = [[UILabel alloc] init];
    valLb.text = [NSString stringWithFormat:@"%@)", item.unit_value ?: @"0"];
    valLb.textColor = [UIColor colorWithRed:0x33/255.0 green:0x33/255.0 blue:0x33/255.0 alpha:1.0];
    valLb.font = [UIFont systemFontOfSize:KDialogAdaptedWidth(14)];
    [cell.contentView addSubview:valLb];
    [valLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(cell.contentView);
        make.leading.mas_equalTo(diamondIV.mas_trailing).offset(KDialogAdaptedWidth(2));
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MLCandidateItemModel *chosen = _items[indexPath.row];
    if (self.selectBlock) {
        self.selectBlock(chosen, NO);
    }
    [self dismiss];
}

#pragma mark - Actions

- (void)clearClick {
    if (self.selectBlock) {
        self.selectBlock(nil, YES);
    }
    [self dismiss];
}

- (void)animateShow {
    self.alpha = 0.0;
    _contentCard.transform = CGAffineTransformMakeScale(0.85, 0.85);
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
        self.contentCard.transform = CGAffineTransformIdentity;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
        self.contentCard.transform = CGAffineTransformMakeScale(0.85, 0.85);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
