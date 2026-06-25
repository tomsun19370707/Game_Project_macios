//
//  EMO_SkillsListViewController.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/3.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_SkillsListViewController.h"
#import "EMO_SkillTableViewCell.h"//
#import "EMO_AddSkillViewController.h"//添加技能
@interface EMO_SkillsListViewController ()<UITableViewDataSource,UITableViewDelegate>
Strong UITableView *listView;
Strong NSMutableArray *listArray;

@end

@implementation EMO_SkillsListViewController
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
    self.titleLabel.text=getLanguage(@"添加技能");
    self.titleLabel.font=KFont(18);
    [self reuqestList:1];
    [self listView];
    
}

-(void)BtnClick{
    
    [self.navigationController pushViewController:[EMO_SkillsListViewController new] animated:YES];
    
}



- (UITableView *)listView{
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listView.backgroundColor = RGBA(248, 248, 248, 1);
        _listView.showsVerticalScrollIndicator = NO;
        _listView.rowHeight = KAdaptedHeight(120);
//        _listView.bounces=NO;
        [self.view addSubview:_listView];
        [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.barView.mas_bottom).offset(KAdaptedHeight(10));
            make.leading.trailing.mas_offset(0);
            make.bottom.mas_offset(-5);

        }];
    }
    return _listView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return 1;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view=[[UIView alloc] init];
    view.backgroundColor=RGBA(255, 255, 255, 1);
    return view;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EMO_SkillTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CellA"];
        if (!cell) {
            cell=[[EMO_SkillTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellA"];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    WeakSelf;
    cell.dicData=self.listArray[indexPath.row];
    cell.BtnBlock = ^(NSDictionary * _Nonnull dic) {
        EMO_AddSkillViewController *vc=[EMO_AddSkillViewController new];
        vc.dicData=dic;
        [wself.navigationController pushViewController:vc animated:YES];
        
    };
        return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EMO_AddSkillViewController *vc=[EMO_AddSkillViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    
}




- (void)reuqestList:(NSInteger)type{
    WeakSelf;
    [NetworkRequest POST:Request_GetSkillList parmeters:nil success:^(id responObject) {
        NSLog(@"%@",responObject);
        if (type==1) {
            [wself.listArray removeAllObjects];
        }
        BaseModel *baseModel = (BaseModel *)responObject;
        [wself.listArray addObjectsFromArray:baseModel.data];
        [wself.listView reloadData];
    } failture:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
   
}


@end
