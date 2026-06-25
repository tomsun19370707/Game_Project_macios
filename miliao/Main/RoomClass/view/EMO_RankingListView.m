//
//  EMO_RankingListView.m
//  miliao
//
//  Created by 张世浩 on 2022/10/26.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_RankingListView.h"
#import "EMO_RankingListTableCell.h"
//#import "YYF_RankingListTabelHeadView.h"
#import "EMO_PersonalDataBaseVC.h"

@interface EMO_RankingListView()<UITableViewDelegate,UITableViewDataSource>
//Strong UIButton *historyBtn;
Strong UIButton *contributionBtn;
Strong UIButton *charmBtn;
Strong UIView *lineView;
Strong UIView *topLineView;

Strong UIView *btBgView;
Strong UIButton *weekBtn;
Strong UIButton *DaylistBtn;
Strong UIButton *monthBtn;

Strong UIView *topBgView;
Strong UIImageView *bgImgOneView;
Strong UIImageView *bgImgTwoView;
Strong UITableView *tableView;
//Strong YYF_RankingListTabelHeadView *tableHeadView;
Strong NSMutableArray *dataArr;
Assign NSInteger page;

Assign NSInteger titleSelectTag;
Assign NSInteger labelSelectTag;


@end

@implementation EMO_RankingListView

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.backgroundColor=[UIColor clearColor];
        self.userInteractionEnabled=YES;
    }
    return self;
}

- (void)singleTapGesture:(UITapGestureRecognizer *)tap{
    [self removeFromSuperview];
}


-(void)initView{
    self.titleSelectTag=0;
    self.labelSelectTag=0;
    self.page=1;
    [self topBgView];
    [self bgImgOneView];
    [self bgImgTwoView];
    [self topLineView];
    [self contributionBtn];
    [self charmBtn];
    [self lineView];
    
    [self btBgView];
    [self DaylistBtn];
    [self weekBtn];
    [self monthBtn];
    
    [self tableView];
    
    [self GetData:YES];
    
    [self setUpMainTableRefresh];
    
    
    
}


#pragma mark - setUpMainTableRefresh
- (void)setUpMainTableRefresh
{
    WeakSelf;
    [ZJUIUtil refreshWithHeader:self.tableView refresh:^{
        wself.page = 1;
        [wself GetData:YES];
    }];
    
    
    [ZJUIUtil refreshWithFooter:self.tableView refresh:^(){
        wself.page ++;
        [wself GetData:NO];
    }];
}

- (UIView *)topBgView{
    if (!_topBgView) {
        _topBgView = [[UIView alloc] init];
        _topBgView.backgroundColor = [UIColor clearColor];
       
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
        [_topBgView addGestureRecognizer:singleTap];
        [self addSubview:_topBgView];
        [_topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(KAdaptedHeight(180));
            make.top.leading.trailing.mas_equalTo(0);
        }];
    }
    return _topBgView;
}


- (UIImageView*)bgImgOneView{
    if (!_bgImgOneView) {
        _bgImgOneView = [[UIImageView alloc] init];
//        _bgImgOneView.image=KGetImage(@"pankTwoBgimg");
        _bgImgOneView.userInteractionEnabled=YES;
        _bgImgOneView.backgroundColor=RGBA(255, 255, 255, 0.95);
        [self addSubview:_bgImgOneView];
        [_bgImgOneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(180));
            make.leading.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(KAdaptedHeight(15));
            
        }];
        setViewCorner(_bgImgOneView, KAdaptedHeight(15));
    }
    return _bgImgOneView;
}

- (UIImageView*)bgImgTwoView{
    if (!_bgImgTwoView) {
        _bgImgTwoView = [[UIImageView alloc] init];
//        _bgImgTwoView.image=KGetImage(@"pankOneBgImg");
        _bgImgTwoView.userInteractionEnabled=YES;
        [self addSubview:_bgImgTwoView];
        [_bgImgTwoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bgImgOneView.mas_top).offset(KAdaptedHeight(53));
            make.bottom.leading.trailing.mas_equalTo(0);
        }];
    }
    return _bgImgTwoView;
}

- (UIView *)topLineView{
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor=RGBA(227, 227, 227, 1);
        [self addSubview:_topLineView];
        [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bgImgTwoView.mas_top).offset(KAdaptedHeight(-1));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(1);
            
        }];
    }
    return _topLineView;
}





- (UIButton *)contributionBtn{
    if (!_contributionBtn) {
        _contributionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contributionBtn setTitle:getLanguage(@"财富榜") forState:UIControlStateNormal];
        _contributionBtn.tag=2000;
        [_contributionBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        _contributionBtn.titleLabel.font=KFont(16);
        [_contributionBtn addTarget:self action:@selector(BtnCLick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgImgOneView addSubview:_contributionBtn];
        [_contributionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.trailing.mas_equalTo(self.mas_centerX).offset(KAdaptedWidth(-20));
            make.size.mas_equalTo(CGSizeMake(kWidth/3, KAdaptedHeight(53)));
        }];
    }
    return _contributionBtn;
}


- (UIButton *)charmBtn{
    if (!_charmBtn) {
        _charmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_charmBtn setTitle:getLanguage(@"魅力榜") forState:UIControlStateNormal];
        _charmBtn.tag=3000;
        [_charmBtn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
        _charmBtn.titleLabel.font=KFont(15);
        [_charmBtn addTarget:self action:@selector(BtnCLick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgImgOneView addSubview:_charmBtn];
        [_charmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contributionBtn.mas_top);
            make.leading.mas_equalTo(self.contributionBtn.mas_trailing).offset(KAdaptedWidth(40));
            make.width.mas_equalTo(self.contributionBtn.mas_width);
            make.height.mas_equalTo(self.contributionBtn.mas_height);
        }];
    }
    return _charmBtn;
}


- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor=BaseMainColor;
//        CAGradientLayer *gl = [CAGradientLayer layer];
//        gl.frame = CGRectMake(0,0,KAdaptedWidth(20),KAdaptedHeight(3.5));
//        gl.startPoint = CGPointMake(0, 0);
//        gl.endPoint = CGPointMake(1, 1);
//        gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:149/255.0 blue:73/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:177/255.0 blue:120/255.0 alpha:1.0].CGColor];
//        gl.locations = @[@(0.0),@(1.0f)];
//        [_lineView.layer addSublayer:gl];
        _lineView.layer.cornerRadius = KAdaptedHeight(3.5)/2;
        _lineView.layer.masksToBounds=YES;
        [self.bgImgOneView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(30),KAdaptedHeight(3.5)));
            make.top.mas_equalTo(self.contributionBtn.mas_centerY).offset(KAdaptedHeight(8));
            make.centerX.mas_equalTo(self.contributionBtn.mas_centerX);
            
            
        }];
    }
    return _lineView;
}


- (UIView *)btBgView{
    if (!_btBgView) {
        _btBgView = [[UIView alloc] init];

        [self.bgImgTwoView addSubview:_btBgView];
        [_btBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kWidth,KAdaptedHeight(35)));
            make.top.mas_equalTo(self.bgImgTwoView.mas_top).offset(KAdaptedHeight(18));
            make.centerX.mas_equalTo(0);
            
        }];
    }
    return _btBgView;
}



- (UIButton *)DaylistBtn{
    if (!_DaylistBtn) {
        _DaylistBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _DaylistBtn.backgroundColor=BaseMainColor;
        [_DaylistBtn setTitle:getLanguage(@"小时榜") forState:UIControlStateNormal];
        _DaylistBtn.tag=4000;
        [_DaylistBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _DaylistBtn.titleLabel.font=KFontBold(15);
        _DaylistBtn.layer.cornerRadius=KAdaptedHeight(35)/2;
        _DaylistBtn.layer.masksToBounds=YES;
        [_DaylistBtn addTarget:self action:@selector(BtnCLick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btBgView addSubview:_DaylistBtn];
        [_DaylistBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.leading.mas_equalTo(KAdaptedWidth(40));
            make.width.mas_equalTo(KAdaptedWidth(70));
            make.height.mas_equalTo(KAdaptedHeight(35));
            
        }];
    }
    return _DaylistBtn;
}

- (UIButton *)weekBtn{
    if (!_weekBtn) {
        _weekBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _weekBtn.backgroundColor=RGBA(255, 233, 156, 0);
        [_weekBtn setTitle:getLanguage(@"日榜") forState:UIControlStateNormal];
        _weekBtn.tag=5000;
        [_weekBtn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
        _weekBtn.titleLabel.font=KFont(14);
        _weekBtn.layer.cornerRadius=KAdaptedHeight(35)/2;
        _weekBtn.layer.masksToBounds=YES;
        [_weekBtn addTarget:self action:@selector(BtnCLick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btBgView addSubview:_weekBtn];
        [_weekBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.DaylistBtn.mas_top);
//            make.centerX.mas_equalTo(self.btBgView.mas_centerX);
//            make.width.mas_equalTo(self.DaylistBtn.mas_width);
//            make.height.mas_equalTo(self.DaylistBtn.mas_height);
            
            make.top.mas_equalTo(self.DaylistBtn.mas_top);
            make.trailing.mas_equalTo(KAdaptedWidth(-40));
            make.width.mas_equalTo(self.DaylistBtn.mas_width);
            make.height.mas_equalTo(self.DaylistBtn.mas_height);
        }];
    }
    return _weekBtn;
}

- (UIButton *)monthBtn{
    if (!_monthBtn) {
//        _monthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _monthBtn.backgroundColor=RGBA(255, 233, 156, 0);
//        [_monthBtn setTitle:getLanguage(@"月榜") forState:UIControlStateNormal];
//        _monthBtn.tag=6000;
//        [_monthBtn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
//        _monthBtn.titleLabel.font=KFont(14);
//        _monthBtn.layer.cornerRadius=KAdaptedHeight(35)/2;
//        _monthBtn.layer.masksToBounds=YES;
//        [_monthBtn addTarget:self action:@selector(BtnCLick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.btBgView addSubview:_monthBtn];
//        [_monthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.DaylistBtn.mas_top);
//            make.trailing.mas_equalTo(KAdaptedWidth(-40));
//            make.width.mas_equalTo(self.DaylistBtn.mas_width);
//            make.height.mas_equalTo(self.DaylistBtn.mas_height);
//            
//        }];
    }
    return _monthBtn;
}



- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kClearColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor=[UIColor clearColor];
        _tableView.rowHeight=KAdaptedHeight(80);
//        _tableView.tableHeaderView=self.tableHeadView;
        [self.bgImgTwoView addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.btBgView.mas_bottom).offset(KAdaptedHeight(5));
            make.leading.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(KAdaptedHeight(-0));
//            make.bottom.mas_equalTo(self.bgBottomView.mas_top).offset(KAdaptedHeight(-10));
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
//    return 10;
}
-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.5)];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EMO_RankingListTableCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[EMO_RankingListTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    cell.titleSelectTag = self.titleSelectTag ;
    cell.dicData = self.dataArr[indexPath.row];
    cell.rowindex=indexPath.row+1;
    cell.selectionStyle=0;
    return cell;
}


#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    EMO_PersonalDataBaseVC *VC=[EMO_PersonalDataBaseVC new];
    VC.userID = self.dataArr[indexPath.row][@"uid"];
    [[Common getCurrentVC].navigationController pushViewController:VC animated:YES];
    
}



-(void)BtnCLick:(UIButton *)sender{
    WeakSelf;
    switch (sender.tag) {
        case 2000:{
            wself.titleSelectTag=0;
            [wself.contributionBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
            [wself.charmBtn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
            [UIView animateWithDuration:0.5 animations:^{
                [wself.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(20),KAdaptedHeight(3.5)));
                    make.top.mas_equalTo(wself.contributionBtn.mas_centerY).offset(KAdaptedHeight(10));
                    make.centerX.mas_equalTo(wself.contributionBtn.mas_centerX);

                }];
            }];
        }break;
        case 3000:{
            wself.titleSelectTag=1;
            [wself.charmBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
            [wself.contributionBtn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
                [UIView animateWithDuration:0.5 animations:^{
                    [wself.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(20),KAdaptedHeight(3.5)));
                        make.top.mas_equalTo(wself.contributionBtn.mas_centerY).offset(KAdaptedHeight(10));
                        make.centerX.mas_equalTo(wself.charmBtn.mas_centerX);

                    }];
                }];
        }break;
        case 4000:{
            wself.labelSelectTag=0;

            wself.DaylistBtn.backgroundColor=BaseMainColor;
            [wself.DaylistBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            wself.weekBtn.backgroundColor=UIColor.clearColor;
            [wself.weekBtn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
            wself.monthBtn.backgroundColor=RGBA(255, 233, 156, 0);
            [wself.monthBtn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
            wself.DaylistBtn.titleLabel.font=KFontBold(15);
            wself.weekBtn.titleLabel.font=KFont(15);
            wself.monthBtn.titleLabel.font=KFont(15);
        }break;
        case 5000:{
            wself.labelSelectTag=1;
            wself.weekBtn.backgroundColor=BaseMainColor;
            [wself.weekBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            wself.DaylistBtn.backgroundColor=UIColor.clearColor;
            [wself.DaylistBtn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
            wself.monthBtn.backgroundColor=RGBA(255, 233, 156, 0);
            [wself.monthBtn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
            wself.weekBtn.titleLabel.font=KFontBold(15);
            wself.DaylistBtn.titleLabel.font=KFont(15);
            wself.monthBtn.titleLabel.font=KFont(15);
        }break;
        case 6000:{
            wself.labelSelectTag=2;
            wself.monthBtn.backgroundColor=RGBA(255, 233, 156, 1);
            [wself.monthBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
            wself.DaylistBtn.backgroundColor=RGBA(255, 233, 156, 0);
            [wself.DaylistBtn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
            wself.weekBtn.backgroundColor=RGBA(255, 233, 156, 0);
            [wself.weekBtn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
            wself.monthBtn.titleLabel.font=KFontBold(15);
            wself.DaylistBtn.titleLabel.font=KFont(15);
            wself.weekBtn.titleLabel.font=KFont(15);
        }break;
           
            
        default:
            break;
    }
    
    [self GetData:YES];
}



-(void)GetData:(BOOL)fresh{
    
    /** 0日榜，1周榜，2月榜，3小时榜*/
    NSString *statusStr = @"3";
    if (self.labelSelectTag==1) {
        statusStr = @"0";
    }
    
    NSDictionary *dict = @{@"type":@(self.titleSelectTag), @"status":statusStr, @"room_id":[MLRoomInformationModel currentAccount].room_id,@"page":@(self.page),@"size":@(PageSize)};
    [SVProgressHUD showWithStatus:getLanguage(@"加载中...")];
    
    [NetworkRequest POST:Request_GetRanking parmeters:dict success:^(id responObject) {
        [SVProgressHUD dismiss];
        BaseModel *baseModel=(BaseModel *)responObject;
        if(fresh){
            [self.dataArr removeAllObjects];
        }
        
        [self.dataArr addObjectsFromArray:baseModel.data];
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failture:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}






@end
