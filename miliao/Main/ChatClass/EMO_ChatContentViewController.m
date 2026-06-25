//
//  EMO_ChatContentViewController.m
//  miliao
//
//  Created by 张世浩 on 2022/10/12.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_ChatContentViewController.h"
#import "EMO_ChatCollectionViewCell.h"
#import "EMO_ChatCollectionHeadView.h"

#import "RoomPasswordView.h"
#import "EMO_WebViewController.h"
#import "EMO_StartPlayViewController.h"//直播开始
#import "EMO_EndPlayViewController.h"//直播结束

@interface EMO_ChatContentViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

Strong UIView *topView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic,strong)NSMutableArray *listArr;
@property (nonatomic, strong) EMO_ChatCollectionHeadView *headView;
Strong NSMutableArray *scycleArray;
Strong RoomPasswordView *passWordView;

Assign NSInteger selectType;

@end

@implementation EMO_ChatContentViewController
-(NSMutableArray *)scycleArray{
    if (!_scycleArray) {
        _scycleArray=[NSMutableArray array];
    }
    return _scycleArray;
}
-(NSMutableArray *)listArr{
    if (!_listArr) {
        _listArr=[NSMutableArray array];
    }
    return _listArr;
}




-(void)viewWillAppear:(BOOL)animated{
//    if (self.index == 0 ) {
        [self scycleData];
//    }
    [self getRoom_recommend_room:self.index andFresh:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor clearColor];
    self.page=1;
    
    [self topView];
    [self createUI];
    [self setUpcollectionViewRefresh];
    [self collectionView];
        
    
}


#pragma mark 创建标签视图
- (void)createUI{
   
    CGFloat tagBtnX = KAdaptedWidth(16);
    CGFloat tagBtnY = KAdaptedHeight(0);
    
//    NSArray *arr=@[@"推荐",@"最热",@"我的收藏",@"找男生",@"找女生",@"治愈"];
    
    NSArray *arr=self.dicD[@"children"];
    if(arr.count<1){
        return;
    }
//    for (int i= 0; i<arc4random()%5; i++) {
    int i=0;
    for (NSDictionary *dic in arr) {

//        CGSize tagTextSize = [arr[i] sizeWithFont:KFont(13) maxSize:CGSizeMake(kWidth-KAdaptedWidth(32)-KAdaptedWidth(32), KAdaptedHeight(30))];
        CGSize tagTextSize = [dic[@"name"] sizeWithFont:KFont(13) maxSize:CGSizeMake(kWidth-KAdaptedWidth(32)-KAdaptedWidth(32), KAdaptedHeight(30))];
        if (tagBtnX+tagTextSize.width+KAdaptedWidth(30) > kWidth-KAdaptedWidth(32)) {
            tagBtnX = KAdaptedWidth(16);
            tagBtnY += KAdaptedHeight(30);
        }
        UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        tagBtn.tag = 100+i;
        tagBtn.tag = [dic[@"id"] integerValue];
        tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+KAdaptedWidth(30), KAdaptedHeight(30));
        [tagBtn setTitle:dic[@"name"] forState:UIControlStateNormal];
        if(i==0){
            self.selectType=[dic[@"id"] integerValue];
            tagBtn.backgroundColor=RGBA(255, 255, 255, 0.4);
            [tagBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        }else{
            tagBtn.backgroundColor=RGBA(255, 255, 255, 0);
            [tagBtn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
        }
        tagBtn.titleLabel.font = KFont(13);
        tagBtn.layer.cornerRadius =  KAdaptedHeight(15);
        tagBtn.layer.masksToBounds = YES;
        [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:tagBtn];
        tagBtnX = CGRectGetMaxX(tagBtn.frame)+KAdaptedWidth(10);
        i++;
        
    }
}

#pragma mark 选中
- (void)tagBtnClick:(UIButton *)btn
{
    for (UIButton *subBtn in self.topView.subviews) {
        if(subBtn.tag==btn.tag){
            btn.backgroundColor=RGBA(255, 255, 255, 0.4);
            [btn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        }else{
            subBtn.backgroundColor=RGBA(255, 255, 255, 0);
            [subBtn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
        }
    }
    self.selectType=btn.tag;
    self.page=1;
    [self getRoom_recommend_room:self.index andFresh:YES];
    
}



- (RoomPasswordView *)passWordView{
    if (!_passWordView) {
        _passWordView = [[RoomPasswordView alloc] initWithFrame:CGRectMake(0, 0, ScreenViewWidth, ScreenViewHeight)];
    }
    return _passWordView;
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        [self.view addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.height.mas_equalTo(KAdaptedHeight(40));
        }];
    }
    return _topView;
}

- (EMO_ChatCollectionHeadView *)headView{
    if (!_headView) {
        _headView = [[EMO_ChatCollectionHeadView alloc] init];
        WeakSelf;
        _headView.sureClickBlock = ^(NSInteger index) {
            NSLog(@"%ld",index);
            EMO_WebViewController *vc=[EMO_WebViewController new];
            NSDictionary *dic= wself.scycleArray[index];
            vc.titleType=getLanguage(@"详情");
            vc.strUrl=dic[@"content"];
            [wself.navigationController pushViewController:vc animated:YES];
        };
    }
    return _headView;
}



#pragma mark - 懒加载UIcollectionCell
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
         _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.scrollsToTop = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces=YES;
        _collectionView.showsVerticalScrollIndicator=NO;
        _collectionView.backgroundColor=[UIColor clearColor];
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [_collectionView registerClass:[EMO_ChatCollectionViewCell class] forCellWithReuseIdentifier:@"EMO_ChatCollectionViewCell"];
//        if (self.index==0) {
            [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerA"];
//        }
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(0);
            make.top.mas_equalTo(self.topView.mas_bottom);
            make.leading.mas_equalTo(KAdaptedWidth(0));
            make.trailing.mas_equalTo(KAdaptedWidth(-0));
            make.bottom.mas_equalTo(-TabBar_H);
        }];
    }
    return _collectionView;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
         UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerA" forIndexPath:indexPath];
//        if (self.index==0) {
            [header addSubview:self.headView];
          [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
               make.top.mas_equalTo(0);
               make.trailing.leading.mas_equalTo(0);
              make.height.mas_equalTo(KAdaptedHeight(130));
              
           }];
//        }

        return header;
    
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    if (self.index==0) {
        return CGSizeMake(kWidth,KAdaptedHeight(130));
//    }else{
//        return CGSizeMake(kWidth,KAdaptedHeight(0));
//    }
        
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, KAdaptedWidth(10), 0, KAdaptedWidth(10));
 
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake(KAdaptedWidth(170), KAdaptedHeight(170));

   
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.listArr.count;
//    return 20;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EMO_ChatCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EMO_ChatCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *dic=self.listArr[indexPath.row];
    cell.dicData=dic;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf;
    NSDictionary *dic=self.listArr[indexPath.row];

    if([dic[@"status"] integerValue]==0){
        if([[UserManager userInfo].user_id integerValue]==[dic[@"uid"] integerValue]){
//            EMO_StartPlayViewController*vc=[EMO_StartPlayViewController new];
//            vc.dicData=[NSMutableDictionary dictionaryWithDictionary:dic];
//            [self.navigationController pushViewController:vc animated:YES];
            
            
            /** 2026-01-24 不在进入准备开播页面*/
            if([dic[@"type"] integerValue]==0){
                [self getIntoTheRoom:dic passWord:@""];
            }else{
                if([[UserManager userInfo].user_id integerValue]==[dic[@"uid"] integerValue]){
                    [self getIntoTheRoom:dic passWord:@""];
                }else{
                    [[UIApplication sharedApplication].delegate.window addSubview:self.passWordView];
                    [self.passWordView setDicModel:dic];
                    WeakSelf;
                    self.passWordView.sendDicSeBlock = ^(NSDictionary *model, NSString *text) {
                        [wself getIntoTheRoom:model passWord:text];
                    };
                }
            }
            
            
        }else{
            EMO_EndPlayViewController*vc=[EMO_EndPlayViewController new];
            vc.dicData = [NSMutableDictionary dictionaryWithDictionary:dic];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    }else if ([dic[@"status"] integerValue]==1){
        NSLog(@"禁播");
        [SVProgressHUD showImage:KGetImage(@"") status:@"该房间已被禁播"];
    }else{
        if([dic[@"type"] integerValue]==0){
            [self getIntoTheRoom:dic passWord:@""];
        }else{
            if([[UserManager userInfo].user_id integerValue]==[dic[@"uid"] integerValue]){
                [self getIntoTheRoom:dic passWord:@""];
            }else{
                [[UIApplication sharedApplication].delegate.window addSubview:self.passWordView];
                [self.passWordView setDicModel:dic];
                WeakSelf;
                self.passWordView.sendDicSeBlock = ^(NSDictionary *model, NSString *text) {
                    [wself getIntoTheRoom:model passWord:text];
                };
            }
        }
      
    }
 
}

#pragma  mark 进入房间前获取RTCtoken

-(void)getIntoTheRoom:(NSDictionary *)dic passWord:(NSString *)passWord{
    WeakSelf;
    
    [NetworkRequest POST:Request_Get_rtc_token parmeters:@{@"room_id":dic[@"id"]} success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        UserDefaultsSave(basemodel.data,@"ShengWangRTCToken");
        [wself getRoomInformationWithModel:dic passWord:passWord];
        
    } failture:^(NSError *error) {
        
    }];
    
    
}


#pragma mark 进入房间
- (void)getRoomInformationWithModel:(NSDictionary *)model passWord:(NSString *)passWord{
    WeakSelf;
    [NetworkRequest POST:Request_EnterRoom parmeters:passWord.length<1?@{@"room_id":model[@"id"]}:@{@"room_id":model[@"id"],@"password":passWord} success:^(id responObject) {
        BaseModel *basemolde=(BaseModel *)responObject;
        if(basemolde.code==1){
            EMO_MLRoomNewVC *vc=[EMO_MLRoomNewVC new];
            MLRoomInformationModel *mode=[MLRoomInformationModel mj_objectWithKeyValues:basemolde.data[@"room_info"]];
            mode.microphone_position=basemolde.data[@"microphone_position"];
            NSDictionary *userDic=[NSDictionary dictionary];
            userDic=basemolde.data[@"userinfo"];
            mode.userinfo=userDic;
            mode.is_muted=[userDic[@"is_muted"] boolValue];
            mode.user_type=[Common isNullNumber:userDic[@"type"]];
                MLRoomInformationModel *model1 = [MLRoomInformationModel currentAccount];
            [model1 mj_setKeyValues:mode];
            
            [wself.navigationController pushViewController:vc animated:YES];
        }else{
            [[UIApplication sharedApplication].delegate.window addSubview:self.passWordView];
            [self.passWordView setDicModel:model];
            WeakSelf;
            self.passWordView.sendDicSeBlock = ^(NSDictionary *model, NSString *text) {
                [wself getIntoTheRoom:model passWord:text];
            };
        }

    } failture:^(NSError *error) {
        
    }];
    
    
    
    
    
}


- (void)setUpcollectionViewRefresh
{
    ///下来刷新
    WEAK_SELF
    [ZJUIUtil refreshWithHeader:self.collectionView refresh:^{
      
//        if (weakSelf.index == 0 ) {
            [weakSelf scycleData];
//        }
        weakSelf.page=1;
        [weakSelf getRoom_recommend_room:self.index andFresh:YES];
    }];
    
    [ZJUIUtil refreshWithCollectionViewFooter:self.collectionView refresh:^{
//        if (weakSelf.index == 0 ) {
            [weakSelf scycleData];
//        }
        weakSelf.page++;
        [weakSelf getRoom_recommend_room:self.index andFresh:NO];

    }];
    
    
}





#pragma mark 轮播数据
-(void)scycleData{
    
    
    [NetworkRequest POST:Request_GetBanner parmeters:@{@"type":@"1"} success:^(id responObject) {
        BaseModel *baseModel=(BaseModel *)responObject;
        self.scycleArray=[NSMutableArray arrayWithArray:baseModel.data];
        NSMutableArray *imgArr=[NSMutableArray array];
        for (NSDictionary *dic in self.scycleArray) {
            [imgArr addObject:dic[@"image"]];
        }
        self.headView.shufflingArray=imgArr;
        [self.collectionView reloadData];
    } failture:^(NSError *error) {
        
    }];
    
    
 
    
}



///获取其他类型列表数据
- (void)getRoom_recommend_room:(NSInteger )categories andFresh:(BOOL)fresh{

    NSDictionary *dict = [NSDictionary dictionary];
    if(self.selectType==666){
        dict=@{@"page":@(self.page)};
    }else{
        dict=@{@"type":@(self.selectType),@"page":@(self.page)};
    }
    WeakSelf;
    [SVProgressHUD showWithStatus:getLanguage(@"加载中…")];
    [NetworkRequest POST:self.selectType==666?Request_GetMyCollectRoomList:Request_GetRoomList parmeters:dict success:^(id responObject) {
        BaseModel *baseModel=(BaseModel *)responObject;
        [SVProgressHUD dismiss];
        if (fresh) {
            [wself.listArr removeAllObjects];
        }
        [wself.listArr addObjectsFromArray:baseModel.data];
        [wself.collectionView reloadData];
        [wself.collectionView.mj_header endRefreshing];
        [wself.collectionView.mj_footer endRefreshing];
    } failture:^(NSError *error) {
        [SVProgressHUD dismiss];
        [wself.collectionView.mj_header endRefreshing];
        [wself.collectionView.mj_footer endRefreshing];
        
    }];
    

}





@end
