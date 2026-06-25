//
//  EMO_InviteFriendsVC.m
//  miliao
//
//  Created by ZhangShiHao on 2023/6/30.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_InviteFriendsVC.h"
#import "EMO_InviteTableViewCell.h"
#import "EMO_InviteFriendsView.h"


@interface EMO_InviteFriendsVC ()<UITableViewDelegate,UITableViewDataSource>
Strong UITableView *listView;
Strong NSMutableArray *listArray;
Strong NSDictionary *dicData;
Strong EMO_InviteFriendsView *headView;
Strong EMO_InviteFriendsView *footView;

Assign NSInteger mainPage;


@end

@implementation EMO_InviteFriendsVC
-(NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc] init];
    }
    return _listArray;
}

-(NSDictionary *)dicData{
    if(!_dicData){
        _dicData=[NSDictionary dictionary];
    }
    return _dicData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(107, 71, 255, 1);
    [self loadBar:YES needBack:YES needBackground:YES];
    self.barView.backgroundColor=kClearColor;
    self.titleLabel.text=getLanguage(@"邀请好友");
    self.titleLabel.font=KFont(18);
    self.titleLabel.textColor=kWhiteColor;
    self.leftButtonView.image=KGetImage(@"backWhiteImg");
    [self setUpMainTableRefresh];
    [self reuqestList:YES];
    [self listView];
    
    [self.view insertSubview:self.barView aboveSubview:self.listView];
    
}
#pragma mark - setUpMainTableRefresh
- (void)setUpMainTableRefresh
{
    WeakSelf;
    [ZJUIUtil refreshWithHeader:self.listView refresh:^{
        wself.mainPage = 1;
        [wself reuqestList:YES];
    }];
    
    
    [ZJUIUtil refreshWithFooter:self.listView refresh:^(){
        wself.mainPage ++;
        [wself reuqestList:NO];
    }];
}




- (EMO_InviteFriendsView *)headView{
    if (!_headView) {
        _headView = [[EMO_InviteFriendsView alloc] initWithFrame:CGRectMake(0, 0, kWidth, KAdaptedHeight(630))];
        _headView.type=1;
    }
    return _headView;
}

- (EMO_InviteFriendsView *)footView{
    if (!_footView) {
        _footView = [[EMO_InviteFriendsView alloc] initWithFrame:CGRectMake(0, 0, kWidth, KAdaptedHeight(280))];
        _footView.type=2;
    }
    return _footView;
}


- (UITableView *)listView{
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listView.backgroundColor = [UIColor clearColor];
        _listView.showsVerticalScrollIndicator = NO;
        _listView.rowHeight = KAdaptedHeight(70);
        _listView.tableHeaderView=self.headView;
        _listView.tableFooterView=self.footView;
        [self.view addSubview:_listView];
        [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(-KSAFEAREA_BOTTOM_HEIHGHT);
            make.top.mas_equalTo(0);
        }];
    }
    return _listView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
//    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EMO_InviteTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell"]];
    if (!cell) {
        cell=[[EMO_InviteTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[NSString stringWithFormat:@"Cell"]];
    }
    cell.dicData=self.listArray[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    
}

#pragma mark 获取数据
- (void)reuqestList:(BOOL )fresh{
    WeakSelf;
    [NetworkRequest POST:Request_GetMyInvite parmeters:@{@"page":@(self.mainPage),@"size":@(PageSize)} success:^(id responObject) {
        if(fresh){
            [wself.listArray removeAllObjects];
            wself.listArray=nil;
        }
        BaseModel *baseModel = (BaseModel *)responObject;

        [wself.listArray addObjectsFromArray:baseModel.data];
        [wself.listView reloadData];
    } failture:^(NSError *error) {
        
    }];
}



@end
