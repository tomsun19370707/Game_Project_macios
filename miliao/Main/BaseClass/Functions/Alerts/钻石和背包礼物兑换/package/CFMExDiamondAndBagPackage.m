//
//  CFMExDiamondAndBagPackage.m
//  miliao
//
//  Created by Dylan Lee on 2026/1/4.
//  Copyright © 2026 EMO. All rights reserved.
//

#import "CFMExDiamondAndBagPackage.h"
#import "CFMExDiamondAndBagPackageCollCell.h"
@interface CFMExDiamondAndBagPackage ()
/** View */
@property (nonatomic,strong) UICollectionView *collection;
@property (nonatomic,strong) NSMutableArray *dataArr;
/** 选中的index*/
@property (nonatomic,assign) int selIndex;
@end

@implementation CFMExDiamondAndBagPackage

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
}
#pragma mark --
#pragma mark --- collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CFMExDiamondAndBagPackageCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CFMExDiamondAndBagPackageCollCell" forIndexPath:indexPath];
    if (self.selIndex == indexPath.row) {
        cell.isSel = YES ;
    }else{
        cell.isSel = NO ;
    }
    if (indexPath.row < self.dataArr.count) {
        cell.model = self.dataArr[indexPath.row];
    }
    return cell ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selIndex = indexPath.row ;
    /** 刷新*/
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collection reloadData];
    });
    
    if (self.fetchClick) {
        self.fetchClick(indexPath.row);
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
        CGFloat height = 72 ;
        CGFloat width = 72 ;
        
        UICollectionViewFlowLayout *layout4 = [[UICollectionViewFlowLayout alloc]init];
        layout4.scrollDirection = UICollectionViewScrollDirectionHorizontal ;
        layout4.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout4.itemSize = CGSizeMake(width, height);
        layout4.minimumLineSpacing = 0 ;
        layout4.minimumInteritemSpacing =0 ;
        /** 初始化*/
        _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(16, 16, SCREEN_WIDTH - 16 * 2, height) collectionViewLayout:layout4];
        _collection.delegate  =self;
        _collection.dataSource  =self;
        _collection.backgroundColor = UIColor.whiteColor;
        _collection.showsHorizontalScrollIndicator = NO ;
        _collection.showsVerticalScrollIndicator = NO ;
//        _collection.scrollEnabled = NO ;
        /** 注册cell*/
        [_collection registerNib:[UINib nibWithNibName:@"CFMExDiamondAndBagPackageCollCell" bundle:nil] forCellWithReuseIdentifier:@"CFMExDiamondAndBagPackageCollCell"];
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
//    if (limitArr.count == 0) {
//        return ;
//    }
//    CGFloat height = 67 ;
//    //设置collectionview 和 contentview高度
//    NSUInteger temp = limitArr.count / 4;
//    if (limitArr.count % 4 != 0) {
//        temp += 1 ;
//    }
//    [self.collection setHeight:height *temp ];
//    /** height*/
//    [self.contentView setHeight:self.collection.bottom + 10];
//    [self setHeight:self.contentView.height];
    
    /** 刷新*/
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collection reloadData];
    });
}
#pragma mark --
#pragma mark --- ibaction

#pragma mark --
#pragma mark --- Method
@end
