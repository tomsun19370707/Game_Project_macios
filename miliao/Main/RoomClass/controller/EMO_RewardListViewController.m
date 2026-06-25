//
//  EMO_RewardListViewController.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/10.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_RewardListViewController.h"
#import "EMO_FamilyCenterDetailsCell.h"
@interface EMO_RewardListViewController ()<UITableViewDelegate,UITableViewDataSource>
Strong UITableView *listView;
Strong NSMutableArray *listArray;
Assign NSInteger page;
@end

@implementation EMO_RewardListViewController
-(NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc] init];
    }
    return _listArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(248, 248, 248, 1);
    [self loadBar:YES needBack:YES needBackground:YES];
    self.titleLabel.text=getLanguage(@"打赏清单");
    self.titleLabel.font=KFont(18);
    self.page=1;
    [self reuqestList:YES];
    [self listView];
    
    [self setUpMainTableRefresh];
    
}



- (UITableView *)listView{
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listView.backgroundColor = [UIColor clearColor];
        _listView.showsVerticalScrollIndicator = NO;
        _listView.rowHeight = KAdaptedHeight(75);
//        _listView.estimatedRowHeight = KAdaptedHeight(100);
//        _listView.rowHeight = UITableViewAutomaticDimension;
        if (@available(iOS 11.0, *)) {
            _listView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [self.view addSubview:_listView];
        [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(-KSAFEAREA_BOTTOM_HEIHGHT);
            make.top.mas_equalTo(ZJTopNavH+ZJStatusBarH+KAdaptedHeight(10));
        }];
    }
    return _listView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return KAdaptedHeight(50);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, KAdaptedHeight(50))];
    bgView.backgroundColor=RGBA(248, 248, 248, 1);
    UILabel *timeLabel=[[UILabel alloc] init];
    timeLabel.text=[Common isNull:self.listArray[section][0][@"createtime_text"]];
    timeLabel.textColor=RGBA(51, 51, 51, 1);
    timeLabel.font=KFontA(13);
    [bgView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.leading.mas_equalTo(KAdaptedWidth(15));
        make.trailing.mas_equalTo(KAdaptedWidth(-15));
    }];
    
    
    return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    bgView.backgroundColor=kWhiteColor;
    return bgView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr=self.listArray[section];
    return arr.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EMO_FamilyCenterDetailsCell *cell=[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell"]];
    if (!cell) {
        cell=[[EMO_FamilyCenterDetailsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[NSString stringWithFormat:@"Cell"]];
    }
    cell.dicData=self.listArray[indexPath.section][indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    
}


#pragma mark - setUpMainTableRefresh
- (void)setUpMainTableRefresh
{
    WeakSelf;
    [ZJUIUtil refreshWithHeader:self.listView refresh:^{
        wself.page = 1;
        [wself reuqestList:YES];
    }];
    
    
    [ZJUIUtil refreshWithFooter:self.listView refresh:^(){
        wself.page ++;
        [wself reuqestList:NO];
    }];
}


#pragma mark 获取数据
- (void)reuqestList:(BOOL )fresh{
    WeakSelf;
    
    [NetworkRequest POST:Request_GetRoomPriceLog parmeters:@{@"room_id":[MLRoomInformationModel currentAccount].room_id,@"page":@(self.page),@"size":@(PageSize)} success:^(id responObject) {

        BaseModel *baseModel = (BaseModel *)responObject;
        if(fresh){
            [wself.listArray removeAllObjects];
            wself.listArray=nil;
        }
//        [wself.listArray addObjectsFromArray:baseModel.data];
        NSArray *array =baseModel.data;
        NSArray *array2 =baseModel.data;
        if (array.count>0) {
            for (NSDictionary *dic in array) {
                NSMutableArray *dataArr=[NSMutableArray array];
                for (NSDictionary *dic2 in array2){
                    if([dic[@"createtime_text"] isEqualToString:dic2[@"createtime_text"]]){
                        [dataArr addObject:dic2];
                    }
                }
                [self.listArray addObject:dataArr];
            }
        }
        [wself.listView reloadData];
        [wself.listView.mj_header endRefreshing];
        [wself.listView.mj_footer endRefreshing];
    } failture:^(NSError *error) {
        [wself.listView.mj_header endRefreshing];
        [wself.listView.mj_footer endRefreshing];
        
    }];
}






@end
