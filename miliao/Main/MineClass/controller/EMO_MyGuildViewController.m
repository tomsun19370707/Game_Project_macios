//
//  EMO_MyGuildViewController.m
//  miliao
//
//  Created by 张世浩 on 2022/10/15.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_MyGuildViewController.h"
#import "EMO_MyGuildTableViewCell.h"
#import "EMO_MyGuildHeadView.h"
#import "EMO_MyGuildSearchVC.h"
#import "EMO_MyGuildXQViewController.h"//家族详情
@interface EMO_MyGuildViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) EMO_MyGuildHeadView *headView;
@property (nonatomic, assign) NSInteger mainPage;
@end

@implementation EMO_MyGuildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(255, 255, 255, 1);
    [self loadBar:YES needBack:YES needBackground:YES];
    self.barView.backgroundColor=kClearColor;
    self.titleLabel.text=getLanguage(@"我的家族");
    self.titleLabel.font=KFont(18);
    [self.rightButton setImage:KGetImage(@"myFamilyImg") forState:UIControlStateNormal];
    self.rightButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    
    [self setUpMainTableRefresh];
    [self headView];
    [self tableView];
    [self backBtn];
    [self getData:YES];
    [self.view insertSubview:self.barView aboveSubview:self.headView];
    
}
-(void)rightButtonClick:(UIButton *)sender{
    [NetworkRequest POST:Request_MyFamily parmeters:nil success:^(id responObject) {
        BaseModel *model=(BaseModel *)responObject;
        EMO_MyGuildXQViewController *vc=[EMO_MyGuildXQViewController new];
        vc.type=1;
        vc.guildID=model.data[@"id"];
        [self.navigationController pushViewController:vc animated:YES];
            
    } failture:^(NSError *error) {
        
    }];
    
    
}

-(void)LoadUrlData:(NSInteger )tag{
    [NetworkRequest POST:Request_AppText parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        NSDictionary *dic =[NSDictionary dictionary];
        EMO_WebViewController *vc=[EMO_WebViewController new];
        if (tag==100) {
            dic =baseModel.data[4];
        }else{
            dic =baseModel.data[5];
        }
        vc.titleType=dic[@"title"];
        vc.strUrl= dic[@"content"];
        [self.navigationController pushViewController:vc animated:YES];
    
        
    } failture:^(NSError *error) {
        
        
    }];
    
    
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"left_top_fanhui"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(BackBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(8));
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(40), KAdaptedHeight(40)));
            make.bottom.mas_equalTo(self.view.mas_top).offset(ZJTopNavH+ZJStatusBarH-KAdaptedHeight(0));
            
        }];
    }
    return _backBtn;
}
-(void)BackBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}


- (EMO_MyGuildHeadView *)headView{
    if (!_headView) {
        _headView = [[EMO_MyGuildHeadView alloc] init];
        _headView.backgroundColor = [UIColor whiteColor];
        _headView.layer.masksToBounds=YES;
        WeakSelf;
        _headView.BtnBlock = ^(NSInteger tag) {
            if(tag==888){
                EMO_MyGuildSearchVC *vc=[EMO_MyGuildSearchVC new];
                [wself.navigationController pushViewController:vc animated:YES];
            }else{
                
                [self LoadUrlData:tag];
            }
        };
        [self.view addSubview:_headView];
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(0);
            make.height.mas_equalTo(KAdaptedHeight(230));
        }];
    }
    return _headView;
}


-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor =  kWhiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor=[UIColor clearColor];
        _tableView.rowHeight=KAdaptedHeight(75);
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(KAdaptedHeight(0));
            make.top.mas_equalTo(self.headView.mas_bottom);
            make.leading.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(-KSAFEAREA_BOTTOM_HEIHGHT);
        }];
    }
    return _tableView;
}



#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 30)];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(KAdaptedWidth(15), 0, kWidth-KAdaptedWidth(30), KAdaptedHeight(30))];
    label.text=getLanguage(@"荣耀家族");
    label.textColor=RGBA(0, 0, 0, 1);
    label.font=KFontA(16);
    [view addSubview:label];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EMO_MyGuildTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[EMO_MyGuildTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    cell.selectionStyle=0;
    cell.dicData = self.dataArr[indexPath.row];
    return cell;
}


#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    EMO_MyGuildXQViewController *vc=[EMO_MyGuildXQViewController new];
    vc.guildID=self.dataArr[indexPath.row][@"id"];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


#pragma mark - setUpMainTableRefresh
- (void)setUpMainTableRefresh
{
    WeakSelf;
    [ZJUIUtil refreshWithHeader:self.tableView refresh:^{
        wself.mainPage = 1;
        [wself getData:YES];
    }];
    
    
//    [ZJUIUtil refreshWithFooter:self.tableView refresh:^(){
//        wself.mainPage ++;
//        [wself getData:NO];
//    }];
}


-(void)getData:(BOOL)isRefresh{
    if (isRefresh) {
        [self.dataArr removeAllObjects];
    }
    [NetworkRequest POST:Request_FamilyList parmeters:nil success:^(id responObject) {
        BaseModel *model=(BaseModel *)responObject;
        [self.dataArr addObjectsFromArray:model.data];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failture:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    


}



@end
