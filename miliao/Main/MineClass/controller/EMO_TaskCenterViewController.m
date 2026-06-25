//
//  EMO_TaskCenterViewController.m
//  miliao
//
//  Created by ZhangShiHao on 2023/6/30.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_TaskCenterViewController.h"
#import "EMO_TaskTableViewCell.h"
#import "EMO_TaskHeadView.h"
#import "EMO_RechargeViewController.h"
@interface EMO_TaskCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
Strong UITableView *listView;
Strong NSMutableArray *listArray;
Strong NSMutableArray *signListArray;
Strong NSDictionary *dicData;
Strong EMO_TaskHeadView *headView;

@end

@implementation EMO_TaskCenterViewController
-(NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc] init];
    }
    return _listArray;
}
-(NSMutableArray *)signListArray{
    if (!_signListArray) {
        _signListArray = [[NSMutableArray alloc] init];
    }
    return _signListArray;
}

-(NSDictionary *)dicData{
    if(!_dicData){
        _dicData=[NSDictionary dictionary];
    }
    return _dicData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(255, 255, 255, 1);
    [self loadBar:YES needBack:YES needBackground:YES];
    self.barView.backgroundColor=kClearColor;
    self.titleLabel.text=getLanguage(@"任务中心");
    self.titleLabel.font=KFont(18);
//    self.titleLabel.textColor=kWhiteColor;
//    self.leftButtonView.image=KGetImage(@"backWhiteImg");
    [self reuqestList];
    [self listView];
    
    [self.view insertSubview:self.barView aboveSubview:self.listView];
    
}


- (EMO_TaskHeadView *)headView{
    if (!_headView) {
        _headView = [[EMO_TaskHeadView alloc] initWithFrame:CGRectMake(0, 0, kWidth, KAdaptedHeight(350))];
        _headView.backgroundColor = RGBA(248, 248, 248, 0.16);

    }
    return _headView;
}



- (UITableView *)listView{
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listView.backgroundColor = RGBA(248, 248, 248, 0.16);
        _listView.showsVerticalScrollIndicator = NO;
        _listView.rowHeight = KAdaptedHeight(70);
        _listView.tableHeaderView=self.headView;
//        _listView.tableFooterView=self.footView;
        [self.view addSubview:_listView];
        [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(-KSAFEAREA_BOTTOM_HEIHGHT);
            make.top.mas_equalTo(-ZJStatusBarH);
        }];
    }
    return _listView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EMO_TaskTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell"]];
    if (!cell) {
        cell=[[EMO_TaskTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[NSString stringWithFormat:@"Cell"]];
    }
    cell.dicData=self.listArray[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    WeakSelf;
    cell.BtnBlock = ^(NSDictionary * _Nonnull dic) {

        [wself signData:dic];
    };
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    
}

#pragma mark 获取数据
- (void)reuqestList{
    WeakSelf;
    [NetworkRequest POST:Request_TaskList parmeters:nil success:^(id responObject) {

        BaseModel *baseModel = (BaseModel *)responObject;
        [wself.listArray removeAllObjects];
        wself.listArray=nil;
//        NSArray *array =baseModel.data;
//        if (array.count>0) {
//            for (NSDictionary *dic in array) {
//                NSMutableDictionary *dicData=[NSMutableDictionary dictionaryWithDictionary:dic];
//                [dicData setObject:@"0" forKey:@"select"];
//                [wself.listArray addObject:dicData];
//            }
//        }
        
        [wself.listArray addObjectsFromArray:baseModel.data];
        [wself.listView reloadData];
    } failture:^(NSError *error) {
        
    }];
    
    
    [NetworkRequest POST:Request_SigninList parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        [wself.signListArray removeAllObjects];
        wself.signListArray=nil;
        [wself.signListArray addObjectsFromArray:baseModel.data];
        
        
        
        
        
    } failture:^(NSError *error) {
        
    }];
}


-(void)signData:(NSDictionary *)dic{
    if([dic[@"is_finish"] integerValue]!=1){
        if ([dic[@"id"] integerValue]==2){
            EMO_RechargeViewController *vc =[EMO_RechargeViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:NO];
            ZXTabBarController *tabbar = (ZXTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            if ([dic[@"id"] integerValue]==3||[dic[@"id"] integerValue]==1){
                tabbar.selectedIndex = 1;
            }else{
                tabbar.selectedIndex = 3;
            }
        }
    }
    
    
}






@end
