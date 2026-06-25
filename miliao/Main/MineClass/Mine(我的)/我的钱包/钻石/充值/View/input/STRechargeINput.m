//
//  STRechargeINput.m
//  SecondTrading
//
//  Created by Dylan on 2025/10/25.
//

#import "STRechargeINput.h"
#import "STRechargeINputCollCell.h"
@interface STRechargeINput ()
/** View */
@property (nonatomic,strong) UICollectionView *collection;
@property (nonatomic,strong) NSMutableArray *dataArr;
/** 选中的index*/
@property (nonatomic,assign) NSInteger selINdex;
@end

@implementation STRechargeINput

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

//首先给让cell左右偏移一点的距离，通过重写cell的setframe方法来实现   
- (void)setFrame:(CGRect)frame{
    CGFloat margin = 12;
    frame.origin.x = margin;
    frame.size.width = SCREEN_WIDTH - margin*2;
    [super setFrame:frame];
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
    self.selINdex = 0 ;
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
    STRechargeINputCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"STRechargeINputCollCell" forIndexPath:indexPath];
    if (indexPath.row < self.dataArr.count) {
        NSDictionary *model = self.dataArr[indexPath.row];
        cell.model = model ;
    }
    /** 图片*/
    if (self.selINdex==indexPath.row) {
        cell.isSel = YES ;
    }else{
        cell.isSel = NO ;
    }
    return cell ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataArr.count) {
        NSDictionary *model = self.dataArr[indexPath.row];

        self.selINdex = indexPath.row ;
        /** 刷新*/
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collection reloadData];
        });

        if (self.fetchMoneyDone) {
            self.fetchMoneyDone(model);
        }
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

-(UICollectionView *)collection
{
    if (!_collection) {
        CGFloat width = (SCREEN_WIDTH - 12 * 2 - 10 * 4) / 3.0 ;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        //        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal ;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.itemSize = CGSizeMake(width, 74);
        layout.minimumLineSpacing = 6 ;
        layout.minimumInteritemSpacing =6 ;
        
        _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH - 12 * 2, 10) collectionViewLayout:layout];
        _collection.delegate  =self;
        _collection.dataSource  =self;
        _collection.backgroundColor = [UIColor whiteColor];
        _collection.showsHorizontalScrollIndicator = NO ;
        _collection.showsVerticalScrollIndicator = NO ;
        _collection.scrollEnabled = NO;
        
        [_collection registerNib:[UINib nibWithNibName:@"STRechargeINputCollCell" bundle:nil] forCellWithReuseIdentifier:@"STRechargeINputCollCell"];
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
 
    CGFloat width = 74 + 10 ;
    //设置collectionview 和 contentview高度
    NSUInteger temp = limitArr.count / 3;
    if (limitArr.count % 3 != 0) {
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
