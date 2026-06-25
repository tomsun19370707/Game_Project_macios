//
//  EMO_GiftWallViewController.m
//  miliao
//
//  Created by 张世浩 on 2022/10/15.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_GiftWallViewController.h"
#import "EMO_GiftWallCollectionCell.h"
#import "EMO_GiftWallHeadView.h"


@interface EMO_GiftWallViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong) EMO_GiftWallHeadView *headViewA;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,strong) NODataView *dataView;
Strong NSMutableArray *dataArr;



@end

@implementation EMO_GiftWallViewController

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(248, 248, 248, 1);
    self.page=1;
    [self loadBar:YES needBack:YES needBackground:YES];
    self.barView.backgroundColor=kClearColor;
    self.titleLabel.text=self.titleStr;
    self.titleLabel.font=KFont(18);
//    self.view.backgroundColor=RGBA(255, 255, 255, 1);
    [self setUpMainTableRefresh];
    [self getListModel:YES];
    [self topView];
    [self headViewA];
    [self collectionView];
    
    [self.view sendSubviewToBack:self.topView];
    
    
}

#pragma mark - setUpMainTableRefresh
- (void)setUpMainTableRefresh
{
    WeakSelf;
    [ZJUIUtil refreshWithHeader:self.collectionView refresh:^{
        wself.page = 1;
        [wself getListModel:YES];
    }];
    
    
    [ZJUIUtil refreshWithCollectionViewFooter:self.collectionView refresh:^(){
        wself.page ++;
        [wself getListModel:NO];
    }];
}



- (void)getListModel:(BOOL)fresh{

    WeakSelf;
    [NetworkRequest POST:Request_GetMyReceiveGift parmeters:nil success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        if(fresh){
            [wself.dataArr removeAllObjects];
        }
        [wself.headViewA hidenImg:YES andGiftAllNum:[NSString stringWithFormat:@"%@",basemodel.data[@"total"]]];
        [wself.dataArr addObjectsFromArray:basemodel.data[@"list"]];
        [wself.collectionView reloadData];
        [wself.collectionView.mj_header endRefreshing];
        [wself.collectionView.mj_footer endRefreshing];
    } failture:^(NSError *error) {
        [wself.collectionView.mj_header endRefreshing];
        [wself.collectionView.mj_footer endRefreshing];
    }];
    
    
    
    
    
    
}


-(NODataView *)dataView
{
    if (!_dataView) {
        _dataView = [[NODataView alloc] initWithFrame:CGRectMake(0, 88, ScreenWidth, 300)];
        [_dataView loadDataWithDic:@{@"imageName":@"bag_kong",
                                     @"title":getLanguage(@"空空如也~")
                                     }];
    }
    return _dataView;

}
-(UIView *)topView{
    if(!_topView){
        _topView=[[UIView alloc] init];
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0,0,kWidth,KAdaptedHeight(235));
        gl.startPoint = CGPointMake(0.5, 0);
        gl.endPoint = CGPointMake(0.5, 1);
        gl.colors = @[(__bridge id)BaseMainColor.CGColor, (__bridge id)RGBA(255, 238, 1, 0).CGColor];
        gl.locations = @[@(0), @(1.0f)];
        [_topView.layer addSublayer:gl];
        [self.view addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(0);
            make.height.mas_equalTo(KAdaptedHeight(235));
            
        }];
    }
    return _topView;
}

- ( EMO_GiftWallHeadView*)headViewA{
    if (!_headViewA) {
        _headViewA = [[EMO_GiftWallHeadView alloc] init];
        _headViewA.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_headViewA];
        [_headViewA mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ZJTopNavH+ZJStatusBarH);
            make.leading.trailing.mas_equalTo(0);
            make.height.mas_equalTo(KAdaptedHeight(160));
            
        }];
    }
    return _headViewA;
}

#pragma mark - 懒加载UIcollectionCell
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
         _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.scrollsToTop = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //设施最小行间距
        _collectionView.backgroundColor=RGBA(248, 248, 248, 1);
        _collectionView.showsVerticalScrollIndicator=NO;
        [_collectionView registerClass:[EMO_GiftWallCollectionCell class] forCellWithReuseIdentifier:@"EMO_GiftWallCollectionCell"];
//        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerA"];
        
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(ZJTopNavH+ZJStatusBarH);
            make.top.mas_equalTo(self.headViewA.mas_bottom).offset(0);
            make.leading.mas_offset(KAdaptedWidth(14));
            make.trailing.mas_equalTo(KAdaptedWidth(-14));
            make.bottom.mas_equalTo(-KSAFEAREA_BOTTOM_HEIHGHT);
            
        }];
//        _collectionView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            self.page=1;
//            self.dataArr=nil;
//            [self.dataArr removeAllObjects];
////            [self getData];
//        }];
//        _collectionView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//            self.page++;
////            [self getData];
//
//        }];
    }
    return _collectionView;
}

//-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//         UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerA" forIndexPath:indexPath];
//            [header addSubview:self.headViewA];
//          [self.headViewA mas_makeConstraints:^(MASConstraintMaker *make) {
//               make.top.mas_equalTo(0);
//               make.trailing.leading.mas_equalTo(0);
//              make.height.mas_equalTo(KAdaptedHeight(235));
//
//           }];
//
//        return header;
//
//
//}
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//        return CGSizeMake(kWidth,KAdaptedHeight(235));
//
//}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5,7,5,5);

}
//最小行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake(KAdaptedWidth(75), KAdaptedHeight(105));
   
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
//    return 20;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    EMO_GiftWallCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EMO_GiftWallCollectionCell" forIndexPath:indexPath];
    cell.BackDicData=self.dataArr[indexPath.row];
    return cell;
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSMutableDictionary *dict=self.dataArr[indexPath.row];

    
}













@end
