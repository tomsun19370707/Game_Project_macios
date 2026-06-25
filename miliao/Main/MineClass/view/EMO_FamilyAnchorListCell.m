//
//  EMO_FamilyAnchorListCell.m
//  miliao
//
//  Created by ZhangShiHao on 2023/6/29.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_FamilyAnchorListCell.h"
#import "EMO_AnchorCollectionCell.h"
@interface EMO_FamilyAnchorListCell()<UICollectionViewDataSource, UICollectionViewDelegate>
@property(nonatomic, strong) UICollectionView *myCollectionView;

@end

@implementation EMO_FamilyAnchorListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
          
          UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
          // 设置UICollectionView为横向滚动
          flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
          // 每一行cell之间的间距
          flowLayout.minimumLineSpacing = KAdaptedWidth(20);
           // 每一列cell之间的间距
           // flowLayout.minimumInteritemSpacing = 10;
          // 设置第一个cell和最后一个cell,与父控件之间的间距
          flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);

          flowLayout.itemSize = CGSizeMake(KAdaptedWidth(50), KAdaptedHeight(80));
          UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWidth, KAdaptedHeight(100)) collectionViewLayout:flowLayout];
          collectionView.backgroundColor = [UIColor whiteColor];
          collectionView.dataSource = self;
          collectionView.delegate = self;
          collectionView.showsHorizontalScrollIndicator=NO;
          _myCollectionView = collectionView;
          [self.contentView addSubview:collectionView];
          [self.myCollectionView registerClass:[EMO_AnchorCollectionCell class] forCellWithReuseIdentifier:@"EMO_AnchorCollectionCell"];
          
        
    }
    return self;
}

-(void)setListArr:(NSMutableArray *)ListArr{
    _ListArr=ListArr;
    
    [self.myCollectionView reloadData];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.ListArr.count;
//    return 30;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    EMO_AnchorCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EMO_AnchorCollectionCell" forIndexPath:indexPath];
    cell.dicData=self.ListArr[indexPath.row];

    return cell;
    
}







@end
