//
//  MLSearchViewController.m
//  miliao
//
//  Created by aa on 2019/8/7.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "MLSearchViewController.h"
#import "UISearchBar+custom.h"
//#import "SearchCollectionView.h"
//#import "HistoryCollectionViewCell.h"
//#import "SearchHistoryHeaderView.h"
//#import "SearchHistoryHeaderView.h"
//#import "SearchModel.h"
//#import "TrendTableViewCell.h"
#import "EMO_SearchFriendsTableViewCell.h"
#import "EMO_HomeTableViewCell.h"
//#import "UICollectionViewLeftAlignedLayout.h"
#import "ResultHeaderView.h"
//#import "TrendModel.h"


#import "RoomFloatingWindow.h"
#import "NODataView.h"
#import "RoomPasswordView.h"
#import "EMO_ZhauanZengDetailVC.h"
#import "EMO_MLRoomNewVC.h"
#import "EMO_PersonalDataBaseVC.h"

#import "EMO_StartPlayViewController.h"
#import "EMO_EndPlayViewController.h"


static NSString *sectionHeaderID = @"sectionHeaderID";
static NSString * const historyCell = @"HistoryCell";
static NSString *cellID = @"cellID";
@interface MLSearchViewController ()<UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>//TrendCellDelegate

@property (nonatomic, strong) UISearchBar *customSearchBar;
//@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) NSMutableArray *hotArray;
//@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic, strong) NSMutableArray *userArray;
@property (nonatomic, strong) NSMutableArray *roomArray;
//@property (nonatomic, strong) NSMutableArray *dynamicArray;
@property (nonatomic, strong) NSString *keywords;
@property (nonatomic, strong) NODataView *dataView;
@property (nonatomic, strong) RoomPasswordView *passWordView;
@end

@implementation MLSearchViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isNeedLine = YES;
    [self loadBar:YES needBack:YES needBackground:YES];
    self.leftButtonView.image = ImageNamed(@"xiaoxi_back");
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.collectionView];
    
    _customSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(45,self.barView.height - 40, ScreenWidth - 65, 40)];
    _customSearchBar.delegate = self;
    _customSearchBar.backgroundImage = [[UIImage alloc] init];
    // 设置SearchBar的颜色主题为白色
    _customSearchBar.barTintColor = MHColorFromHexString(@"#EEEEEE");
    UITextField *searchField = [_customSearchBar valueForKey:@"searchField"];
    [searchField setBackgroundColor:MHColorFromHexString(@"#EEEEEE")];
    searchField.layer.cornerRadius = 14.0f;
    searchField.placeholder = getLanguage(@"支持昵称/ID/房间");
    searchField.font = Font(14);
    searchField.layer.masksToBounds = YES;
    [_customSearchBar fm_setCancelButtonTitle:getLanguage(@"取消")];
    _customSearchBar.tintColor = mainQianColor;
    [_customSearchBar fm_setTextColor:[UIColor blackColor]];
    [_customSearchBar fm_setTextFont:[UIFont systemFontOfSize:14]];
    [self.barView addSubview:self.customSearchBar];
    
//    [self.tableView registerNib:[UINib nibWithNibName:@"TrendTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
//    [self.collectionView registerClass:[HistoryCollectionViewCell class] forCellWithReuseIdentifier:historyCell];
//    [self.collectionView registerNib:[UINib nibWithNibName:@"SearchHistoryHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderID];
//    [self getSearchList];
    self.keywords = @"";
    [self.view addSubview:self.tableView];
}

//#pragma mark 获取搜索历史
//- (void)getSearchList{

//    NSDictionary *dic = @{@"user_id":@"12"};
//    [HttpTool getSearhListWithParameters:dic success:^(id response) {
//        if ([response[@"code"] intValue] == 1) {
//            self.hotArray = [SearchModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"hot"]];
//            self.historyArray = [SearchModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"histor"]];
//            [self.collectionView reloadData];
//        }
//    } failure:^(NSError *error) {
//
//    }];
//}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self.customSearchBar setShowsCancelButton:NO animated:YES];
    // 如果希望在点击取消按钮调用结束编辑方法需要让加上这句代码
    [self.customSearchBar resignFirstResponder];
    
}
//#pragma mark ----- collectionViewDelegete
//
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    if (kind == UICollectionElementKindSectionHeader) {
//
//        SearchHistoryHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderID forIndexPath:indexPath];
//        headerView.backgroundColor = [UIColor whiteColor];
//        headerView.deleteHistoryBlock = ^{
//            NSDictionary *dic = @{@"user_id":[UserManager userInfo].user_id};
//            [HttpTool cleanSarhListWithParameters:dic success:^(id response) {
//                if ([response[@"code"] intValue] == 1) {
//                    [self getSearchList];
//                }
//
//            } failure:^(NSError *error) {
//
//            }];
//        };
////        暂时隐藏
////        if (indexPath.section == 0) {
////            headerView.title = getLanguage(@"历史搜索");
////        }
////        else headerView.title =getLanguage(@"热门搜索");
//
//        return headerView;
//    }else {
//        return nil;
//    }
//}
//
//- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
////    return 2;//不要热门搜索
//    return 1;
//}
//#pragma mark - <UICollectionViewDataSource>
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    if (section == 0) {
//        return self.historyArray.count;
//    }
//    return self.hotArray.count;
//}
//
//- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
//
//    HistoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:historyCell  forIndexPath:indexPath];
//    if (indexPath.section == 0) {
//        cell.model = self.historyArray[indexPath.row];
//    }
//    else
//    {
//        cell.model = self.hotArray[indexPath.row];
//    }
//    return cell;
//}
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    SearchModel *model = [[SearchModel alloc] init];
//    if (indexPath.section == 0) {
//        model = self.historyArray[indexPath.row];
//    }
//    else
//    {
//        model = self.hotArray[indexPath.row];
//    }
//    self.customSearchBar.text = model.search;
//    [self.customSearchBar setShowsCancelButton:YES animated:YES]; // 动画效果显示取消按钮
//    [self searchwithKeywords:self.customSearchBar.text];
//    self.keywords = self.customSearchBar.text;
//
//}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//     SearchModel *model = [[SearchModel alloc] init];
//    if (indexPath.section == 0) {
//       model = self.historyArray[indexPath.row];
//    }
//    else
//    {
//        model = self.hotArray[indexPath.row];
//    }
//
//    CGFloat width = [SDHelper widthForLabel:[NSString stringWithFormat:@"%@",model.search] fontSize:14];
//    return CGSizeMake(width + 10,18);
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 10;
//}



#pragma mark ---- tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WEAK_SELF
    if (section == 0 && self.userArray.count > 0) {
        ResultHeaderView *headerView = [[ResultHeaderView alloc] init];
        headerView.title = getLanguage(@"相关用户");
        headerView.moreBtnBlock = ^{
//            SearchUserViewController *vc = [[SearchUserViewController alloc] init];
//            vc.searchKeywords = wselfkeywords;
//            [wselfnavigationController pushViewController:vc animated:YES];
        };
        return headerView;
    }
    if (section == 1 && self.roomArray.count > 0) {
        ResultHeaderView *headerView = [[ResultHeaderView alloc] init];
        headerView.title = getLanguage(@"相关房间");
        headerView.moreBtnBlock = ^{
//            SearchRoomViewController *vc = [[SearchRoomViewController alloc] init];
//            vc.searchKeywords = wselfkeywords;
//            [wselfnavigationController pushViewController:vc animated:YES];
        };
        return headerView;
    }
//   else if (section == 2 && self.dynamicArray.count > 0) {
//        ResultHeaderView *headerView = [[ResultHeaderView alloc] init];
//        headerView.title = getLanguage(@"相关动态");
//        headerView.moreBtnBlock = ^{
////            TrendViewController *vc = [[TrendViewController alloc] init];
////            vc.searchKeywords = wselfkeywords;
////            vc.type = searchTrend;
////            [wselfnavigationController pushViewController:vc animated:YES];
//
//        };
//       return headerView;
//    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.userArray.count> 0 ) {
            return 40;
        }
        else return 0.001;
    }
//    if (section == 1) {
        if (self.roomArray.count> 0 ) {
            return 40;
        }
        else return 0.001;
//    }
    
//    if (self.dynamicArray.count> 0 ) {
//        return 40;
//    }
//    else return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.userArray.count> 0 ) {
            return 10;
        }
        else return 0.001;
    }
//    if (section == 1) {
        if (self.roomArray.count> 0 ) {
            return 10;
        }
        else return 0.001;
//    }
//
//    if (self.dynamicArray.count> 0 ) {
//        return 10;
//    }
//    else return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    return view;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.userArray.count;
    }
//    if (section == 1) {
        return self.roomArray.count;
//    }
//    return self.dynamicArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 65;
    }
//    if (indexPath.section == 2) {
//        TrendModel *model = self.dynamicArray[indexPath.row];
//        return model.cellHeight + 5;
//    }
    return KAdaptedHeight(100);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        EMO_SearchFriendsTableViewCell *cell = [EMO_SearchFriendsTableViewCell cellWithTableView:tableView];
        cell.model = self.userArray[indexPath.row];
        return cell;
    }
//    if (indexPath.section == 1) {
        EMO_HomeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"oneCell"];
        if (!cell) {
            cell=[[EMO_HomeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"oneCell"];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.dicData=self.roomArray[indexPath.row];
        return cell;
//    }
//
//    TrendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (!cell) {
//        cell = [[TrendTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//    }
//    cell.model = self.dynamicArray[indexPath.row];
//    WEAK_SELF
//    cell.playBtnActionBlock = ^(BOOL btnSelected, TrendModel *model) {
//        [weakSelf.dynamicArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            TrendModel *trendModel = (TrendModel *)obj;
//            if ([trendModel.uid isEqualToString:model.uid]) {
//                if (trendModel.isPlay == YES) {
//                    trendModel.isPlay = NO;
//                }else{
//                    trendModel.isPlay = YES;
//                }
//
//            }else{
//                trendModel.isPlay = NO;
//            }
//        }];
//        [weakSelf.tableView reloadData];
//    };
//    cell.AttentionBtn.hidden = YES;
//    cell.delegate = self;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置cell点击效果
//    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if (indexPath.section == 2) {
//            DetailTrendViewController *vc = [[DetailTrendViewController alloc] init];
//            vc.model = self.dynamicArray[indexPath.row];
//            [self.navigationController pushViewController:vc animated:YES];
//    }
    if (indexPath.section == 0) {
            NSDictionary *model = self.userArray[indexPath.row];
            EMO_PersonalDataBaseVC *VC=[EMO_PersonalDataBaseVC new];
            VC.userID = model[@"id"];
            [self.navigationController pushViewController:VC animated:YES];
        
    }
    if (indexPath.section == 1) {
        NSDictionary *dic = self.roomArray[indexPath.row];
        if([dic[@"status"] integerValue]==0){
            if([[UserManager userInfo].user_id integerValue]==[dic[@"uid"] integerValue]){
//                EMO_StartPlayViewController*vc=[EMO_StartPlayViewController new];
//                vc.dicData = self.roomArray[indexPath.row];
//                [self.navigationController pushViewController:vc animated:YES];
                
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
                vc.dicData = self.roomArray[indexPath.row];
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


- (RoomPasswordView *)passWordView{
    if (!_passWordView) {
        _passWordView = [[RoomPasswordView alloc] initWithFrame:CGRectMake(0, 0, ScreenViewWidth, ScreenViewHeight)];
    }
    return _passWordView;
}

#pragma makr trendCellDelegate
//- (void)trendTableViewCell:(TrendTableViewCell*)cell likeBtnClick:(id)sender{
//    UIButton *btn = sender;
//    btn.selected = !btn.selected;
//    NSString *hand = @"add";
//    if (!btn.selected) {
//        hand = @"del";
//    }
//    TrendModel *cellModel = cell.model;
//    NSDictionary *dict = @{@"target_id":cellModel.uid,@"user_id":[UserManager userInfo].user_id,@"type":@(1),@"hand":hand};
//    [HttpTool getDynamics_handWithParameters:dict success:^(id response) {
//        if ([response[@"code"] intValue] == 1) {
//
//            [self.dynamicArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                TrendModel *model = self.dynamicArray[idx];
//                if ([model.uid isEqualToString:cellModel.uid]) {
//                    int number = 0;
//                    if (btn.selected) {
//                        number = [model.praise intValue] + 1;
//                        model.is_praise = @"1";
//                    }
//                    else
//                    {
//                        number = [model.praise intValue] - 1;
//                        model.is_praise = @"0";
//                    }
//                    model.praise = [NSString stringWithFormat:@"%d",number];
//                }
//            }];
//            [self.tableView reloadData];
//            MYLog(@"点赞成功");
//        }
//    } failure:^(NSError *error) {
//        MYLog(@"点赞失败");
//    }];
//
//}
//- (void)trendTableViewCell:(TrendTableViewCell*)cell collectionBtnClick:(id)sender{
//    UIButton *btn = sender;
//    btn.selected = !btn.selected;
//    NSString *hand = @"add";
//    if (!btn.selected) {
//        hand = @"del";
//    }
//    TrendModel *cellModel = cell.model;
//    NSDictionary *dict = @{@"target_id":cellModel.uid,@"user_id":[UserManager userInfo].user_id,@"type":@(2),@"hand":hand};
//    [HttpTool getDynamics_handWithParameters:dict success:^(id response) {
//        if ([response[@"code"] intValue] == 1) {
//            MYLog(@"收藏（取消）成功");
//            [self.dynamicArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                TrendModel *model = self.dynamicArray[idx];
//                if ([model.uid isEqualToString:cellModel.uid]) {
//                    if (btn.selected) {
//
//                        model.is_collect = @"1";
//
//                    }
//                    else
//                    {
//                        model.is_collect = @"0";
//                    }
//                }
//            }];
//            [self.tableView reloadData];
//        }
//    } failure:^(NSError *error) {
//        MYLog(@"收藏（取消）失败");
//    }];
//}
//- (void)trendTableViewCell:(TrendTableViewCell*)cell forwardBtnClick:(id)sender{
    
//}
//- (void)trendTableViewCell:(TrendTableViewCell*)cell commentBtnClick:(id)sender{
//    DetailTrendViewController *vc = [[DetailTrendViewController alloc] init];
//    vc.model = cell.model;
//    vc.ispushKeyBoard = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//}
//- (void)trendTableViewCell:(TrendTableViewCell*)cell detailClick:(id)sender{
//    DetailTrendViewController *vc = [[DetailTrendViewController alloc] init];
//    vc.model = cell.model;
//    [self.navigationController pushViewController:vc animated:YES];
//}
//- (void)trendTableViewCell:(TrendTableViewCell*)cell cellRightBtnClick:(id)sender{
//}
//- (void)trendTableViewCell:(TrendTableViewCell*)cell attentationBtnClick:(id)sender{
//}
#pragma mark ----- searchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    //    searchBar.prompt = @"1.开始编辑文本";
    [searchBar setShowsCancelButton:YES animated:YES]; // 动画效果显示取消按钮
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //    searchBar.prompt = @"2.在改变文本过程中。。。";
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //    searchBar.prompt = @"3. 点击键盘上的搜索按钮";
    self.keywords = searchBar.text;
    [self searchwithKeywords:searchBar.text];
    
}

#pragma mark 搜索
- (void)searchwithKeywords:(NSString *)string
{
//    NSDictionary *dic = @{@"user_id":[UserManager userInfo].user_id,@"keywords":string};

    
    
    
    
    [NetworkRequest POST:Request_HomeSearch parmeters:@{@"keyword":string} success:^(id responObject) {
        BaseModel *baselModel=(BaseModel *)responObject;
        NSLog(@"%@",baselModel);
//        [self.collectionView removeFromSuperview];
        self.userArray=baselModel.data[@"user_list"];
        self.roomArray=baselModel.data[@"room_list"];
//        [self.view addSubview:self.tableView];
        [self.customSearchBar resignFirstResponder];
        [self.tableView reloadData];
        [self dataViewAddUpView];
    } failture:^(NSError *error) {
        
    }];
    
    
    
    
    
    
    
    
//    NSDictionary *dic = @{@"user_id":@"12",@"keywords":string};
//    [HttpTool merge_searchWithParameters:dic success:^(id response) {
//        if ([response[@"code"] intValue] == 1) {
//            [self.collectionView removeFromSuperview];
//            self.userArray = [EMO_FriendsModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"user"]];
//            self.roomArray = [MLRoomModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"rooms"]];
//            self.dynamicArray = [TrendModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"dynamics"]];
//            [self.view addSubview:self.tableView];
//            [self.customSearchBar resignFirstResponder];
//            [self.tableView reloadData];
//            [self dataViewAddUpView];
//        }
//
//    } failure:^(NSError *error) {
//
//    }];
}
- (void)dataViewAddUpView{
//    if (self.userArray.count == 0 && self.roomArray.count == 0 & self.dynamicArray.count == 0) {
    if (self.userArray.count == 0 && self.roomArray.count == 0) {
        [self.view addSubview:self.dataView];
    }else{
        [self.dataView removeFromSuperview];
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //    searchBar.prompt = @"4. 点击取消按钮";
    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO animated:YES];
    // 如果希望在点击取消按钮调用结束编辑方法需要让加上这句代码
    [searchBar resignFirstResponder];
//    [self.tableView removeFromSuperview];
//    [self.view addSubview:self.collectionView];
//    [self getSearchList];
    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    //    searchBar.prompt = @"5.已经结束编辑文本";
}


#pragma mark ----- 懒加载
//- (UICollectionView *)collectionView{
//    if (!_collectionView) {
//        UICollectionViewLeftAlignedLayout *flowLayout = [[UICollectionViewLeftAlignedLayout alloc]init];
//        //    flowLayout.betweenOfCell = 10;
//        flowLayout.minimumLineSpacing = 10;
//        flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
//        flowLayout.minimumInteritemSpacing = 15;
//        flowLayout.headerReferenceSize = CGSizeMake(ScreenWidth, 25);
//        // 设置collectionView
//        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
//
//        _collectionView.frame = CGRectMake(0,ZJTopNavH + 30, ScreenWidth, ScreenHeight - ZJTopNavH - 30);
//        _collectionView.delegate = self;
//        _collectionView.dataSource = self;
//        _collectionView.scrollEnabled = NO;
//
//        _collectionView.backgroundColor = [UIColor whiteColor];
//        [self.collectionView registerNib:[UINib nibWithNibName:@"HistoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:historyCell];
//        [self.collectionView registerClass:[SearchHistoryHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderID];
//    }
//    return _collectionView;
//}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.barView.bottom+1, ScreenWidth, ScreenHeight - self.barView.bottom - 1) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
//- (UISearchBar *)customSearchBar
//{
//    if (!_customSearchBar) {
//        _customSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(15,ZJStatusBarH, ScreenWidth - 30, 44)];
//        _customSearchBar.delegate = self;
//        _customSearchBar.backgroundImage = [[UIImage alloc] init];
//        // 设置SearchBar的颜色主题为白色
//        _customSearchBar.barTintColor = MHColorFromHexString(@"#EEEEEE");
//        UITextField *searchField = [_customSearchBar valueForKey:@"searchField"];
//        [searchField setBackgroundColor:MHColorFromHexString(@"#EEEEEE")];
//        searchField.layer.cornerRadius = 14.0f;
//        searchField.placeholder = @"搜索用户/关键字";
//        searchField.layer.masksToBounds = YES;
//        [_customSearchBar fm_setCancelButtonTitle:@"取消"];
//        _customSearchBar.tintColor = mainQianColor;
//        [_customSearchBar fm_setTextColor:[UIColor blackColor]];
//        [_customSearchBar fm_setTextFont:[UIFont systemFontOfSize:14]];
//    }
//    return _customSearchBar;
//}
//-(NSMutableArray *)historyArray
//{
//    if (!_historyArray) {
//        _historyArray = [NSMutableArray array];
//    }
//    return _historyArray;
//}
//- (NSMutableArray *)hotArray
//{
//    if (!_hotArray) {
//        _hotArray = [NSMutableArray array];
//    }
//    return _hotArray;
//}
- (NSMutableArray *)userArray
{
    if (!_userArray) {
        _userArray = [NSMutableArray array];
    }
    return _userArray;
}
- (NSMutableArray *)roomArray
{
    if (!_roomArray) {
        _roomArray = [NSMutableArray array];
    }
    return _roomArray;
}
//- (NSMutableArray *)dynamicArray
//{
//    if (!_dynamicArray) {
//        _dynamicArray = [NSMutableArray array];
//    }
//    return _dynamicArray;
//}
- (NODataView *)dataView{
    if (!_dataView) {
        _dataView = [[NODataView alloc] initWithFrame:CGRectMake(0,self.barView.bottom, ScreenWidth, ScreenHeight - self.barView.bottom)];
        [_dataView loadDataWithDic:@{@"imageName":@"no_result",
                                     @"title":@"搜索不到任何结果哦"
                                     }];
    }
    return _dataView;
}
@end
