//
//  EMO_CollectListVC.m
//  miliao
//
//  Created by jkkj on 2022/3/15.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_CollectListVC.h"
#import "NODataView.h"
#import "RoomPasswordView.h"
#import "EMO_ChatCollectionViewCell.h"

#import "EMO_HomeTableViewCell.h"
#import "EMO_StartPlayViewController.h"//直播开始
#import "EMO_EndPlayViewController.h"//直播结束

// DTO
#import "CFMChatRoomSkipManager.h"
// View
#import "CFMHomeFlowCollCell.h"

@interface EMO_CollectListVC ()<UICollectionViewDelegate, UICollectionViewDataSource,UISearchBarDelegate>
/** collection */
@property (strong, nonatomic) UICollectionView *collection;
/** 数据筛选字典*/
@property (nonatomic,strong) NSMutableDictionary *parameter;
Strong NSMutableArray *listArray;
Assign NSInteger page;

Strong NODataView *dataView;
Strong RoomPasswordView * passWordView;

@end

@implementation EMO_CollectListVC

-(NSMutableArray *)listArray{
    if(!_listArray){
        _listArray=[NSMutableArray array];
    }
    return _listArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(248, 248, 248, 1);
    [self setUpMainTableRefresh];
    [self collection];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getGet_mykeepWithParameters:YES];
}

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
        
        /** 初始化*/
        _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, NavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT_FULL - NavBarHeight) collectionViewLayout:layout];
        _collection.delegate  =self;
        _collection.dataSource  =self;
        _collection.backgroundColor = [UIColor clearColor];
        _collection.showsHorizontalScrollIndicator = NO ;
        _collection.showsVerticalScrollIndicator = NO ;
        if (@available(iOS 11.0, *)) {
            _collection.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        /** 注册cell*/
        [_collection registerNib:[UINib nibWithNibName:@"CFMHomeFlowCollCell" bundle:nil] forCellWithReuseIdentifier:@"CFMHomeFlowCollCell"];
//        /** 无数据默认图*/
//        _collection.emptyDataSetDelegate = self ;
//        _collection.emptyDataSetSource = self ;
        
        [self.view addSubview:_collection];
        [_collection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(0));
            make.leading.trailing.mas_offset(0);
            make.bottom.mas_offset(-5);
        }];
    }
    return _collection ;
}


#pragma mark -
#pragma mark --- collectiondelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CFMHomeFlowCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CFMHomeFlowCollCell" forIndexPath:indexPath];
    if (self.listArray.count != 0) {
        cell.model = self.listArray[indexPath.row];
    }
    return cell ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.listArray.count) {
        NSDictionary *model = self.listArray[indexPath.row];
        /** 点击房间的判断逻辑*/
        CFMChatRoomSkipManager *man = [CFMChatRoomSkipManager shared];
        [man getRoomInfo:model];
    }
}



#pragma mark - setUpMainTableRefresh
- (void)setUpMainTableRefresh
{
    WeakSelf;
    [ZJUIUtil refreshWithHeader:self.collection refresh:^{
        wself.page = 1;
        [wself getGet_mykeepWithParameters:YES];
    }];
    
    
    [ZJUIUtil refreshWithFooter:self.collection refresh:^(){
        wself.page ++;
        [wself getGet_mykeepWithParameters:NO];
    }];
}


- (void)getGet_mykeepWithParameters:(BOOL)fresh{
    
    WeakSelf;
    [NetworkRequest POST:Request_GetMyCollectRoomList parmeters:@{@"type":@(self.type),@"page":@(self.page),@"size":@(PageSize)} success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        if(fresh){
            [wself.listArray removeAllObjects];
        }
        [wself.listArray addObjectsFromArray:basemodel.data];
        if (wself.listArray.count == 0) {
            [wself.bgView addSubview:wself.dataView];
        }else{
            [wself.dataView removeFromSuperview];
        }
        [wself.collection reloadData];
        [wself.collection.mj_header endRefreshing];
        [wself.collection.mj_footer endRefreshing];
    } failture:^(NSError *error) {
        [wself.collection.mj_header endRefreshing];
        [wself.collection.mj_footer endRefreshing];
    }];
    
    
   
}

- (NODataView *)dataView{
    if (!_dataView) {
        _dataView = [[NODataView alloc] initWithFrame:CGRectMake(0, self.barView.bottom, ScreenWidth, 300)];
        [_dataView loadDataWithDic:@{@"imageName":@"no_sc",
                                     @"title":getLanguage(@"还没有收藏哦，快去互动吧~")
                                     }];
    }
    return _dataView;
}
- (RoomPasswordView *)passWordView{
    if (!_passWordView) {
        _passWordView = [[RoomPasswordView alloc] initWithFrame:CGRectMake(0, 0, ScreenViewWidth, ScreenViewHeight)];
    }
    return _passWordView;
}
@end
