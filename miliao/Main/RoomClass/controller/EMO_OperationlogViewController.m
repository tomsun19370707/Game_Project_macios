//
//  EMO_OperationlogViewController.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/10.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_OperationlogViewController.h"
#import "EMO_OperationlogCell.h"
@interface EMO_OperationlogViewController ()<UITableViewDelegate,UITableViewDataSource>
Strong UITableView *listView;
Strong NSMutableArray *listArray;
Assign NSInteger page;
@end

@implementation EMO_OperationlogViewController
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
    self.titleLabel.text=getLanguage(@"操作日志");
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
        [self.view addSubview:_listView];
        [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(-KSAFEAREA_BOTTOM_HEIHGHT);
            make.top.mas_equalTo(ZJTopNavH+ZJStatusBarH+KAdaptedHeight(10));
        }];
    }
    return _listView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
//    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EMO_OperationlogCell *cell=[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell"]];
    if (!cell) {
        cell=[[EMO_OperationlogCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[NSString stringWithFormat:@"Cell"]];
    }
    cell.dicData=self.listArray[indexPath.row];
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
- (void)reuqestList:(BOOL )freah{
    WeakSelf;
    [NetworkRequest POST:Request_GetOperateLog parmeters:@{@"room_id":[MLRoomInformationModel currentAccount].room_id} success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        if(freah){
            [wself.listArray removeAllObjects];
            wself.listArray=nil;
        }
        [wself.listArray addObjectsFromArray:baseModel.data];
//        NSArray *array =baseModel.data;
//        if (array.count>0) {
//            for (NSDictionary *dic in array) {
//                NSMutableDictionary *dicData=[NSMutableDictionary dictionaryWithDictionary:dic];
//                [dicData setObject:@"0" forKey:@"select"];
//                [wself.listArray addObject:dicData];
//            }
//        }
        [wself.listView reloadData];
    } failture:^(NSError *error) {
        
    }];
}






@end
