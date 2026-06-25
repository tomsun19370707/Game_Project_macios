//
//  SearchCollectionView.m
//  miliao
//
//  Created by aa on 2019/8/7.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "SearchCollectionView.h"
#import "HistoryCollectionViewCell.h"
#import "SearchHistoryHeaderView.h"
#import "SearchHistoryHeaderView.h"
static NSString *sectionHeaderID = @"sectionHeaderID";
static NSString * const historyCell = @"HistoryCell";
@interface SearchCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>

@end
@implementation SearchCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(20, 10, 10, 20);
        // 2.设置 最小列间距
        flowLayout. minimumInteritemSpacing  = 10;
        flowLayout.headerReferenceSize = CGSizeMake(ScreenWidth, 20);
        self.collectionViewLayout = flowLayout;
        self.scrollEnabled = NO;
        self.backgroundColor = [UIColor whiteColor];
        [self registerNib:[UINib nibWithNibName:@"HistoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:historyCell];
        [self registerClass:[SearchHistoryHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderID];
    }
    return self;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        
        SearchHistoryHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderID forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor whiteColor];
       
        if (indexPath.section == 0) {
            headerView.title = @"历史搜索";
        }
        else headerView.title = @"热门搜索";
      
        return headerView;
    }else {
        return nil;
    }
}
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.historyArray.count;
    }
    return self.hotArray.count;
}

- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    HistoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HistoryCollectionViewCell" forIndexPath:indexPath];
    return cell;
}

@end
