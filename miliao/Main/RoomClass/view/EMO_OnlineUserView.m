//
//  EMO_OnlineUserView.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/8.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_OnlineUserView.h"
#import "EMO_OnlineUserTableCell.h"
#import "EMO_PersonalDataBaseVC.h"
@interface EMO_OnlineUserView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *maskBgView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titelLB;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, assign) NSInteger mainPage;

@end

@implementation EMO_OnlineUserView

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}



-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        
        [self maskView];
        [self bgView];
        [self maskBgView];
        [self titelLB];
        [self tableView];
        [self setUpMainTableRefresh];
        [self userData:YES];
        
    }
    return self;
}

#pragma mark - setUpMainTableRefresh
- (void)setUpMainTableRefresh
{
    WeakSelf;
    [ZJUIUtil refreshWithHeader:self.tableView refresh:^{
        wself.mainPage = 1;
        [wself userData:YES];
    }];
    
    
    [ZJUIUtil refreshWithFooter:self.tableView refresh:^(){
        wself.mainPage ++;
        [wself userData:NO];
    }];
}



-(void)userData:(BOOL)fresh{
    
    [NetworkRequest POST:Request_GetRoomUser parmeters:@{@"room_id":[MLRoomInformationModel currentAccount].room_id,@"page":@(self.mainPage),@"size":@(PageSize),@"status":@"0"} success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        NSLog(@"%@",basemodel.data);
        if(fresh){
            [self.dataArr removeAllObjects];
        }
        [self.dataArr addObjectsFromArray:basemodel.data];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failture:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    

    
}
- (void)singleTapGesture:(UITapGestureRecognizer *)tap{
    [self removeFromSuperview];
}

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:[UIColor blackColor]];
        _maskView.alpha = 0.6;
        [self addSubview:_maskView];
        [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.bottom.mas_equalTo(self);
            make.left.mas_equalTo(self);
            make.right.mas_equalTo(self);
        }];
    }
    return _maskView;
}
- (UIView *)maskBgView{
    if (!_maskBgView) {
        _maskBgView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:[UIColor clearColor]];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
        [_maskBgView addGestureRecognizer:singleTap];
        [self addSubview:_maskBgView];
        [_maskBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.bgView.mas_top);
            make.left.mas_equalTo(self);
            make.right.mas_equalTo(self);
            make.top.mas_equalTo(self);
        }];
    }
    return _maskBgView;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:RGBA(255, 255, 255, 1)];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 15;
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self);
            make.left.mas_equalTo(self);
            make.right.mas_equalTo(self);
            make.height.mas_equalTo(400);
        }];
    }
    return _bgView;
}
- (UILabel *)titelLB{
    if (!_titelLB) {
        _titelLB = [ControlCreator createLabel:nil rect:CGRectZero text:@"在线用户" font:Font(15) color:[UIColor blackColor] backguoundColor:[UIColor clearColor] align:NSTextAlignmentCenter lines:1];
        [self.bgView addSubview:_titelLB];
        [_titelLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bgView.mas_top).offset(15);
            make.centerX.mas_equalTo(self.bgView.mas_centerX);
        }];
    }
    return _titelLB;
}




- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor =  RGBA(255, 255, 255, 0.95);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor=[UIColor clearColor];
        _tableView.rowHeight=KAdaptedHeight(75);
        [self.bgView addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titelLB.mas_bottom).offset(14);
            make.left.mas_equalTo(self.bgView);
            make.right.mas_equalTo(self.bgView);
            make.bottom.mas_equalTo(self.bgView);
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
    return 0.5;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.5)];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EMO_OnlineUserTableCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[EMO_OnlineUserTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    cell.dicData = self.dataArr[indexPath.row];
    cell.selectionStyle=0;
    return cell;
}


#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    EMO_PersonalDataBaseVC *vc=[EMO_PersonalDataBaseVC new];
    vc.userID=[NSString stringWithFormat:@"%@",self.dataArr[indexPath.row][@"uid"]];
    [[Common getCurrentVC].navigationController pushViewController:vc animated:YES];
    
}




@end
