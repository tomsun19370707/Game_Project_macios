//
//  EMO_DressingCenterViewController.m
//  miliao
//
//  Created by 张世浩 on 2022/12/1.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_DressingCenterViewController.h"
#import "EMO_DressingCollectionViewCell.h"
#import "EMO_SquareCollectionViewCell.h"
#import "PackModel.h"
#import "NODataView.h"
static NSString *const SquareViewCell = @"EMO_SquareCollectionViewCell";
static NSString *const RectangleViewCell = @"EMO_DressingCollectionViewCell";
@interface EMO_DressingCenterViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic,strong) NSMutableArray *listModel;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) NODataView *dataView;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) PackModel *selectModel;

Assign NSInteger page;

@end

@implementation EMO_DressingCenterViewController
- (void)refreView
{

    [self.listModel enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PackModel *packModel = (PackModel *)obj;
        
        if ([packModel.select isEqualToString:@"1"]) {
            packModel.select = @"0";
           
        }
    }];
    [self.collectionView reloadData];
   
}
-(void)listDidDisappear
{
    [self.listModel enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PackModel *packModel = (PackModel *)obj;
        if ([packModel.select isEqualToString:@"1"]) {
            packModel.select = @"0";
        }
    }];
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
    self.page=1;
    [self setUpMainTableRefresh];
    
    [self.view addSubview:self.collectionView];
    [self sendBtn];
    self.sendBtn.hidden=YES;
    [self getListModel:YES];
    
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


#pragma mark 获取数据
- (void)getListModel:(BOOL)fresh{

    
// 我的背包  type 类型：0=礼物；1=头像框；2=进场特效；3=坐骑;4=靓号
    //   status 礼物时查看,0=可赠送，1=不可赠送
    
    
// 背包商城  类型:0=头像框,1=靓号,2=进场特效,3=坐骑

    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:@{@"type":@(self.index),@"page":@(self.page),@"size":@(PageSize)}];
//    if(self.index==0&&self.type==2){
//        [dic setObject:@"0" forKey:@"status"];
//    }
    WeakSelf;
    [NetworkRequest POST:self.type==2?Request_GetMyKnapsack:Request_GetDressList parmeters:dic success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        if(fresh){
            [wself.listModel removeAllObjects];
        }
        NSArray *arr=basemodel.data;
        for (NSDictionary *dic in arr) {
            PackModel *mode=[PackModel mj_objectWithKeyValues:dic];
            mode.type=self.type;
            if(self.type==2){
                mode.is_dress=@"0";
                if (([[UserManager userInfo].avatar_frame_id integerValue]==[mode.dress_id integerValue]&&self.index==1)) {
                    mode.is_dress=@"1";
                }
                if (([[UserManager userInfo].enter_effects_id integerValue]==[mode.dress_id integerValue]&&self.index==2)) {
                    mode.is_dress=@"1";
                }
                if (([[UserManager userInfo].rode_id integerValue]==[mode.dress_id integerValue]&&self.index==3)) {
                    mode.is_dress=@"1";
                }
                if (([[UserManager userInfo].uuid integerValue]==[mode.name integerValue]&&self.index==4)) {
                    mode.is_dress=@"1";
                }
            }else{
                mode.is_dress=@"0";
            }
            mode.select=@"0";
            [wself.listModel addObject:mode];
        }
        [wself.collectionView reloadData];
        [wself dataViewAddUpView];
        [wself.collectionView.mj_header endRefreshing];
        [wself.collectionView.mj_footer endRefreshing];
    } failture:^(NSError *error) {
        [wself.collectionView.mj_header endRefreshing];
        [wself.collectionView.mj_footer endRefreshing];
    }];
    
    
    
    
    
    
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        if(self.type==1){
            if(self.index==1){
                flowLayout.itemSize = CGSizeMake(KAdaptedWidth(110), KAdaptedHeight(80));
            }else{
                flowLayout.itemSize = CGSizeMake(KAdaptedWidth(100), KAdaptedHeight(150));
            }
        }else{
            if(self.index==4){
                flowLayout.itemSize = CGSizeMake(KAdaptedWidth(110), KAdaptedHeight(60));
            }else{
                flowLayout.itemSize = CGSizeMake(KAdaptedWidth(100), KAdaptedHeight(130));
            }
        }
        
        
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight /3 *2 - KAdaptedHeight(100)) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[EMO_SquareCollectionViewCell class] forCellWithReuseIdentifier:SquareViewCell];
        [_collectionView registerClass:[EMO_DressingCollectionViewCell class] forCellWithReuseIdentifier:RectangleViewCell];
    
    }
    return _collectionView;
}
#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return self.listModel.count;
 
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.index == 5|| self.index == 6) {
    if ((self.index == 1&&self.type==1)||(self.index == 4&&self.type==2)) {
        EMO_DressingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:RectangleViewCell forIndexPath:indexPath];
        cell.model = self.listModel[indexPath.row];
        
        return cell;
    }
    
    EMO_SquareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SquareViewCell forIndexPath:indexPath];
    cell.model = self.listModel[indexPath.row];
    
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
  
    
    self.sendBtn.hidden = NO;
    self.selectModel = self.listModel[indexPath.row];
    
    if ((self.index == 0&&self.type==1)||(self.index == 1&&self.type==2)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HeadChange" object:@{@"head_Box":self.selectModel.image,@"svga_img":[Common isNull:self.selectModel.svga_file]}];
        
    }
    if ((self.index == 1&&self.type==1)||(self.index == 4&&self.type==2)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HeadChangeID" object:@{@"head_Box":@"2",@"IDStr":self.type==1?self.selectModel.uuid:self.selectModel.name}];
    }
    
    if ([self.selectModel.is_dress integerValue]==1) {
        self.sendBtn.selected=YES;
    }else{
        self.sendBtn.selected=NO;
    }

    [self.listModel enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PackModel *packModel = (PackModel *)obj;
        if ([packModel.target_id isEqualToString:self.selectModel.target_id]) {
            if (![packModel.select isEqualToString:@"1"]) {
                packModel.select = @"1";

            }
            
        }else{
            packModel.select = @"0";
        }
    }];
    [self.collectionView reloadData];

}

- (NSMutableArray *)listModel
{
    if (!_listModel) {
        _listModel = [NSMutableArray array];
    }
    return _listModel;
}
- (UIView *)listView {
    
    return self.view;
    
}

- (void)dataViewAddUpView{
    if (self.listModel.count == 0 ) {
        [self.collectionView addSubview:self.dataView];
    }else{
        [self.dataView removeFromSuperview];
    }
}
-(NODataView *)dataView
{
    if (!_dataView) {
        _dataView = [[NODataView alloc] initWithFrame:CGRectMake(0, 88, ScreenWidth, 300)];
        _dataView.backgroundColor=[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
        [_dataView loadDataWithDic:@{@"imageName":@"bag_kong",
                                     @"title":getLanguage(@"空空如也~")
                                     }];
    }
    return _dataView;

}


- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0,0,kWidth-KAdaptedWidth(55),KAdaptedHeight(45));
        gl.startPoint = CGPointMake(0.5, 0);
        gl.endPoint = CGPointMake(0.5, 1);
        gl.colors = @[(__bridge id)BaseMainColor.CGColor,(__bridge id)RGBA(255, 238, 1, 1).CGColor];
        gl.locations = @[@(0.0),@(1.0f)];

        [self.sendBtn.layer addSublayer:gl];
        _sendBtn.layer.cornerRadius = 22.5;
        _sendBtn.layer.masksToBounds=YES;
        if(self.type==1){
            [_sendBtn setTitle:getLanguage(@"立即购买") forState:UIControlStateNormal];
            [_sendBtn setTitle:getLanguage(@"立即购买") forState:UIControlStateSelected];
            
        }else{
            [_sendBtn setTitle:getLanguage(@"立即装扮") forState:UIControlStateNormal];
            [_sendBtn setTitle:getLanguage(@"卸下装扮") forState:UIControlStateSelected];
        }
    
        [_sendBtn setTitleColor:RGBA(34, 34, 34, 1) forState:UIControlStateNormal];
        _sendBtn.titleLabel.font=KFont(15);
        _sendBtn.tag=500;
        [_sendBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_sendBtn];
        [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(27.5));
            make.trailing.mas_equalTo(KAdaptedWidth(-27.5));
            make.top.mas_equalTo(self.collectionView.mas_bottom).offset(KAdaptedHeight(-20));
            make.height.mas_equalTo(KAdaptedHeight(45));
        }];
    }
    return _sendBtn;
}


-(void)BtnClick:(UIButton *)sender{

    if(self.type==1){
#pragma mark 购买装扮
        [NetworkRequest POST:Request_PayDress parmeters:@{@"dress_id":self.selectModel.target_id} success:^(id responObject) {
            BaseModel *basemodel=(BaseModel *)responObject;
            [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:basemodel.msg]];
            
        } failture:^(NSError *error) {
            
        }];
        
        
    }else{
        NSInteger type = 1;
        if ([self.selectModel.is_dress integerValue]==1) {
            type = 2;
        }
        [self dressUpBtnClickWithType:type andID:self.selectModel];
    }
    
    
    
    
}
#pragma mark 使用装扮 or 卸下装扮
- (void)dressUpBtnClickWithType:(NSInteger )type andID:(PackModel *)model
{
    WeakSelf;
    [NetworkRequest POST:type==2?Request_RemoveDress:Request_UseDress parmeters:@{@"my_knapsack_id":self.selectModel.target_id} success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:basemodel.msg]];
        if (type==2) {
            wself.sendBtn.selected=NO;
            if ((self.index == 1&&self.type==2)) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HeadChange" object:@{@"head_Box":@"",@"svga_img":@""}];
            }
            if ((self.index == 4&&self.type==2)) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HeadChangeID" object:@{@"head_Box":@"1"}];
            }
        }else{
            wself.sendBtn.selected=YES;
            if ((self.index == 1&&self.type==2)) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HeadChange" object:@{@"head_Box":self.selectModel.image,@"svga_img":[Common isNull:self.selectModel.svga_file]}];
                
            }
            if ((self.index == 4&&self.type==2)) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HeadChangeID" object:@{@"head_Box":@"2",@"IDStr":self.selectModel.name}];
            }
        }
            [wself.listModel enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PackModel *packModel = (PackModel *)obj;
                if ([packModel.target_id isEqualToString:model.target_id]) {
                    if ([packModel.is_dress isEqualToString:@"1"]) {
                        packModel.is_dress = @"0";
                    }else{
                        packModel.is_dress = @"1";
                    }
                    
                }else{
                    packModel.is_dress = @"0";
                }
            }];
        
        [wself.collectionView reloadData];
    } failture:^(NSError *error) {

    }];
    
    
}


@end
