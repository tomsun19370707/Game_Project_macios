//
//  CFMHomeFlow.m
//  miliao
//
//  Created by Dylan Lee on 2025/12/9.
//  Copyright © 2025 EMO. All rights reserved.
//

#import "CFMHomeFlow.h"
#import "CFMHomeFlowCollCell.h"
#import "CFMChatRoomSkipManager.h"
@interface CFMHomeFlow ()
/** View */
@property (nonatomic,strong) UICollectionView *collection;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation CFMHomeFlow

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
    [self.contentView addSubview:self.collection];
    self.backgroundColor = UIColor.clearColor ;
}
#pragma mark --
#pragma mark --- collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CFMHomeFlowCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CFMHomeFlowCollCell" forIndexPath:indexPath];
    if (indexPath.row < self.dataArr.count) {
        NSDictionary *model = self.dataArr[indexPath.row];
        cell.model = model ;
    }
    return cell ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataArr.count) {
        NSDictionary *model = self.dataArr[indexPath.row];
        /** 点击房间的判断逻辑*/
        CFMChatRoomSkipManager *man = [CFMChatRoomSkipManager shared];
        [man getRoomInfo:model];
    }
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
-(UICollectionView *)collection
{
    if (!_collection) {
        CGFloat width = (SCREEN_WIDTH - 12 * 3) / 2.0 ;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        //        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal ;
        layout.sectionInset = UIEdgeInsetsMake(12, 12, 12, 12);
        layout.itemSize = CGSizeMake(width, 199);
        layout.minimumLineSpacing = 10 ;
        layout.minimumInteritemSpacing =10 ;
        
        _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 10) collectionViewLayout:layout];
        _collection.delegate  =self;
        _collection.dataSource  =self;
        _collection.backgroundColor = [UIColor clearColor];
        _collection.showsHorizontalScrollIndicator = NO ;
        _collection.showsVerticalScrollIndicator = NO ;
        _collection.scrollEnabled = NO;
        
        [_collection registerNib:[UINib nibWithNibName:@"CFMHomeFlowCollCell" bundle:nil] forCellWithReuseIdentifier:@"CFMHomeFlowCollCell"];
    }
    return _collection ;
}
-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr ;
}
#pragma mark --
#pragma mark --- Setter
- (void)setLimitArr:(NSMutableArray *)limitArr
{
    [self.dataArr removeAllObjects] ;
    [self.dataArr addObjectsFromArray:limitArr];
 
    CGFloat width = 199 + 12 ;
    //设置collectionview 和 contentview高度
    NSUInteger temp = limitArr.count / 2;
    if (limitArr.count % 2 != 0) {
        temp += 1 ;
    }
    [self.collection setHeight:width *temp ];
    /** height*/
    [self.contentView setHeight:self.collection.bottom + 20];
    
    [self.collection reloadData];
}
#pragma mark --
#pragma mark --- ibaction

#pragma mark --
#pragma mark --- Method

@end
