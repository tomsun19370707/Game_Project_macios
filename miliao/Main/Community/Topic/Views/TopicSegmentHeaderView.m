//
//  TopicSegmentHeaderView.m
//  miliao
//
//  Created by aa on 2019/8/3.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "TopicSegmentHeaderView.h"
#define kWidth self.frame.size.width
#define NORMAL_FONT [UIFont fontWithName:@"PingFang-SC-Medium" size: 17]
#define SELECTED_FONT [UIFont fontWithName:@"PingFang-SC-Medium" size: 18]

#define NORMAL_COLOR [UIColor blackColor]

@interface TopicSegmentHeaderViewCollectionViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@end;

@implementation TopicSegmentHeaderViewCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = NORMAL_FONT;
        _titleLabel.textColor = NORMAL_COLOR;
    }
    return _titleLabel;
}

@end
@interface TopicSegmentHeaderView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *titleArray;
//@property (nonatomic, strong) UIView *moveLine;
@property (nonatomic, strong) UIView *separator;
@property (nonatomic, assign) BOOL selectedCellExist;
@property (nonatomic, assign) CGFloat CellSpacing;

@end
CGFloat const SegmentViewHeight = 41;
static NSString * const SegmentHeaderViewCollectionViewCell = @"SegmentHeaderViewCollectionViewCell";
static CGFloat const MoveLineHeight = 3;
static CGFloat const SeparatorHeight = 0;
//static CGFloat const CellSpacing = ScreenWidth/3;
static CGFloat const CollectionViewHeight = SegmentViewHeight - SeparatorHeight;
@implementation TopicSegmentHeaderView
#pragma mark - Life
- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray {
    if (self = [super initWithFrame:frame]) {
        self.CellSpacing = ScreenWidth/2;
        [self setupSubViews];
        self.titleArray = titleArray;
        self.selectedIndex = 0;
        
    }
    return self;
}

#pragma mark - Public Method
- (void)changeItemWithTargetIndex:(NSUInteger)targetIndex {
    if (_selectedIndex == targetIndex) {
        return;
    }
    
    TopicSegmentHeaderViewCollectionViewCell *selectedCell = [self getCell:_selectedIndex];
    if (selectedCell) {
        selectedCell.titleLabel.textColor = mainQianColor;
        selectedCell.titleLabel.font = NORMAL_FONT;
    }
    TopicSegmentHeaderViewCollectionViewCell *targetCell = [self getCell:targetIndex];
    if (targetCell) {
        targetCell.titleLabel.textColor = MLControlsColor;
        //        targetCell.titleLabel.font = SELECTED_FONT;
    }
    
    
    _selectedIndex = targetIndex;
    
    [self layoutAndScrollToSelectedItem];
}

#pragma mark - Private Method
- (void)setupSubViews {
    [self addSubview:self.collectionView];
//    [self.collectionView addSubview:self.moveLine];
    [self addSubview:self.separator];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(CollectionViewHeight);
    }];
//    [self.moveLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(CollectionViewHeight - MoveLineHeight);
//        make.height.mas_equalTo(MoveLineHeight);
//    }];
    
    [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(SeparatorHeight);
    }];
}

- (TopicSegmentHeaderViewCollectionViewCell *)getCell:(NSUInteger)Index {
    return (TopicSegmentHeaderViewCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:Index inSection:0]];
}

- (void)layoutAndScrollToSelectedItem {
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView setNeedsLayout];
    [self.collectionView layoutIfNeeded];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    if (self.selectedItemHelper) {
        self.selectedItemHelper(_selectedIndex);
    }
    
    TopicSegmentHeaderViewCollectionViewCell *selectedCell = [self getCell:_selectedIndex];
    if (selectedCell) {
        self.selectedCellExist = YES;
        [self updateMoveLineLocation];
    } else {
        self.selectedCellExist = NO;
        //这种情况下updateMoveLineLocation将在self.collectionView滚动结束后执行（代理方法scrollViewDidEndScrollingAnimation）
    }
}

- (void)setupMoveLineDefaultLocation {
//    CGFloat firstCellWidth = [self getWidthWithContent:self.titleArray[0]];
//    [self.moveLine mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(firstCellWidth);
//        make.left.mas_equalTo(self.CellSpacing);
//    }];
}

- (void)updateMoveLineLocation {
//    TopicSegmentHeaderViewCollectionViewCell *cell = [self getCell:_selectedIndex];
//    [UIView animateWithDuration:0.25 animations:^{
//        [self.moveLine mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(CollectionViewHeight - MoveLineHeight);
//            make.height.mas_equalTo(MoveLineHeight);
//            make.width.centerX.equalTo(cell.titleLabel);
//        }];
//        [self.collectionView setNeedsLayout];
//        [self.collectionView layoutIfNeeded];
//    }];
}

- (CGFloat)getWidthWithContent:(NSString *)content {
    CGRect rect = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, CollectionViewHeight)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName:NORMAL_FONT}
                                        context:nil
                   ];
    return ceilf(rect.size.width);;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = [self getWidthWithContent:self.titleArray[indexPath.row]];
    return CGSizeMake(ScreenWidth/2, SegmentViewHeight - 1);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TopicSegmentHeaderViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SegmentHeaderViewCollectionViewCell forIndexPath:indexPath];
    
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.titleLabel.textColor = _selectedIndex == indexPath.row ? MLControlsColor : mainQianColor;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self changeItemWithTargetIndex:indexPath.row];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (!self.selectedCellExist) {
        [self updateMoveLineLocation];
    }
}

#pragma mark - Setter
- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray.copy;
    [self.collectionView reloadData];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (self.titleArray == nil && self.titleArray.count == 0) {
        return;
    }
    
    if (selectedIndex >= self.titleArray.count) {
        _selectedIndex = self.titleArray.count - 1;
    } else {
        _selectedIndex = selectedIndex;
    }
    
    //设置初始选中位置
    if (_selectedIndex == 0) {
        [self setupMoveLineDefaultLocation];
    } else {
        [self layoutAndScrollToSelectedItem];
    }
}

#pragma mark - Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.itemSize = CGSizeMake(kWidth/2,CollectionViewHeight);
        flowLayout.minimumInteritemSpacing = self.CellSpacing;
//        flowLayout.sectionInset = UIEdgeInsetsMake(0, self.CellSpacing, 0, self.CellSpacing);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWidth, CollectionViewHeight) collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        [_collectionView registerClass:[TopicSegmentHeaderViewCollectionViewCell class] forCellWithReuseIdentifier:SegmentHeaderViewCollectionViewCell];
    }
    return _collectionView;
}

//- (UIView *)moveLine {
//    if (!_moveLine) {
//        _moveLine = [[UIView alloc] init];
//        _moveLine.backgroundColor = MHColorFromHexString(@"#FF3E70");
//        _moveLine.clipsToBounds = YES;
//        _moveLine.layer.cornerRadius = 1.5;
//    }
//    return _moveLine;
//}

- (UIView *)separator {
    if (!_separator) {
        _separator = [[UIView alloc] init];
        _separator.backgroundColor = [UIColor lightGrayColor];
    }
    return _separator;
}

@end
