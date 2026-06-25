//
//  EMO_MySkillsViewController.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/3.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_MySkillsViewController.h"
#import "EMO_PersonalSkillCell.h"
#import "EMO_SkillXQViewController.h"//技能详情
#import "EMO_SkillsListViewController.h"//添加技能

@interface EMO_MySkillsViewController ()<UITableViewDataSource,UITableViewDelegate,ETPlayerDelagate>
Strong UITableView *listView;
Strong NSMutableArray *listArray;
Strong UIButton *senderBtn;
Strong PlayerManager *playManager;
Strong NSIndexPath *currentIndex;

@end

@implementation EMO_MySkillsViewController
-(NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc] init];
    }
    return _listArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self reuqestList:1];
}

- (void)viewWillDisappear:(BOOL)animated {
    if(self.playManager.status==ETPlayer_Playing){
        [self.playManager stop];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(248, 248, 248, 1);
    [self loadBar:YES needBack:YES needBackground:YES];
    self.titleLabel.text=getLanguage(@"我的技能");
    self.titleLabel.font=KFont(18);
    
    [self listView];
    [self senderBtn];
    
    self.playManager=[PlayerManager sharedInstance];
    
    
    [RACObserve(self.playManager,status) subscribeNext:^(id  _Nullable x) {
        if(self.playManager.status==ETPlayer_FinishedPlay||self.playManager.status==ETPlayer_Stop){
            if(self.currentIndex){
                EMO_PersonalSkillCell *cell=[self.listView cellForRowAtIndexPath:self.currentIndex];
                cell.play=NO;
            }
        }

    }];
    
}

-(void)BtnClick{
    
    [self.navigationController pushViewController:[EMO_SkillsListViewController new] animated:YES];
    
}

- (UIButton *)senderBtn{
    if (!_senderBtn) {
        _senderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0,0,kWidth-KAdaptedWidth(30),KAdaptedHeight(50));
        gl.startPoint = CGPointMake(0.5, 0);
        gl.endPoint = CGPointMake(0.5, 1);
        gl.colors = @[(__bridge id)BaseMainColor.CGColor,(__bridge id)RGBA(255, 238, 1, 1).CGColor];
        gl.locations = @[@(0.0),@(1.0f)];
        [_senderBtn.layer addSublayer:gl];
        _senderBtn.layer.cornerRadius = KAdaptedHeight(50)/2;
        _senderBtn.layer.masksToBounds=YES;
        [_senderBtn setTitle:getLanguage(@"添加技能") forState:UIControlStateNormal];
        [_senderBtn addTarget:self action:@selector(BtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_senderBtn];
        [_senderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-KSAFEAREA_BOTTOM_HEIHGHT-KAdaptedHeight(40));
            make.centerX.mas_equalTo(KAdaptedHeight(0));
            make.size.mas_equalTo(CGSizeMake(kWidth-KAdaptedWidth(30), KAdaptedHeight(50)));
            
        }];
    }
    return _senderBtn;
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
            make.bottom.mas_offset(-100);

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
    
        EMO_PersonalSkillCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CellA"];
        if (!cell) {
            cell=[[EMO_PersonalSkillCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellA"];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell cellDicData:self.listArray[indexPath.row] andIndex:indexPath];
    
    WeakSelf;
    cell.PlayVoiceBlock = ^(NSDictionary * _Nonnull dic, BOOL playStatus, NSIndexPath *index) {
        if(playStatus){
            if(wself.playManager.status==ETPlayer_Playing){
                [wself.playManager stop];
            }
            wself.currentIndex=index;
            [wself.playManager playWithVoiceURL:[NSURL URLWithString:[Common isNull:dic[@"video_url"]]]];
//            [wself.playManager playWithVoiceURL:[NSURL URLWithString:@"https://heart-chat.oss-cn-beijing.aliyuncs.com/uploads/20230705/a312df7abb1d21f6caee92a0b8e53482.mp3"]];
        }else{
            [wself.playManager stop];
        }
       
        
    };
        return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        EMO_SkillXQViewController *vc=[EMO_SkillXQViewController new];
        vc.skillID=self.listArray[indexPath.row][@"id"];
        vc.type=1;
        [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)reuqestList:(NSInteger)type{
    WeakSelf;
    [NetworkRequest POST:Request_GetMySkillList parmeters:nil success:^(id responObject) {
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
