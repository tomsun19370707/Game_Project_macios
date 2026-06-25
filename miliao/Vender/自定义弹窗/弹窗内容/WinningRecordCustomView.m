//
//  WinningRecordCustomView.m
//  miliao
//
//  Created by 张世浩 on 2022/5/28.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "WinningRecordCustomView.h"
#import "RecordTableCell.h"


@interface WinningRecordCustomView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UIView * bgView;
@property(nonatomic,strong) UIButton * backBtn;
@property(nonatomic,strong) UILabel * tipLabel;
@property(nonatomic,strong) NSMutableArray * dataArr;
@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,assign) NSInteger mainPage;
@property(nonatomic,strong) UILabel * noDataLabel;
@property(nonatomic,assign) NSInteger type;
@end


@implementation WinningRecordCustomView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addChildrenViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addChildrenViews];
        self.mainPage=1;
        self.type=0;
        [self setUpMainTableRefresh];
    }
    return self;
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}


- (void) addChildrenViews{
    [super addChildrenViews];
    [self bgView];
    [self backBtn];
    [self tipLabel];
    [self tableView];
    [self noDataLabel];
    
    self.noDataLabel.hidden=YES;
   
}


-(void)setDicData:(NSDictionary *)dicData{
    
    self.type=[dicData[@"data"] integerValue];
    
    [self getMiniOfficial_messageWithParameters:YES];
}



-(void)BtnClick:(UIButton *)sender{
    if (sender.tag==100) {
        if (self.cancleBtnClick) {
            self.cancleBtnClick(@{@"data":@(self.tag)});
        }
    }
    
    
}



- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor =RGBA(255, 255, 255, 0.8);
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(self);
            make.height.mas_equalTo(KAdaptedHeight(485)+DBottomDangerArea);
        }];
    }
    return _bgView;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
        _backBtn.tag=100;
        _backBtn.layer.cornerRadius=KAdaptedWidth(25/2);
        _backBtn.layer.masksToBounds=YES;
        [_backBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(KAdaptedWidth(25));
            make.top.mas_equalTo(KAdaptedHeight(20));
            make.leading.mas_equalTo(KAdaptedWidth(17));
        }];
    }
    return _backBtn;
}


- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = getLanguage(@"中奖记录");
        _tipLabel.textColor = Color(51, 51, 51, 1);
        _tipLabel.textAlignment=NSTextAlignmentCenter;
        _tipLabel.font=KFont(14);
        [self.bgView addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(KAdaptedHeight(0));
            make.height.mas_equalTo(KAdaptedWidth(25));
            make.top.mas_equalTo(KAdaptedHeight(10));
        }];
    }
    return _tipLabel;
}


- (UILabel *)noDataLabel{
    if (!_noDataLabel) {
        _noDataLabel = [[UILabel alloc] init];
        _noDataLabel.text = getLanguage(@"暂无中奖记录");
        _noDataLabel.textColor = Color(229, 157, 255, 1);
        _noDataLabel.textAlignment=NSTextAlignmentCenter;
        _noDataLabel.font=KFont(14);
        [self.bgView addSubview:_noDataLabel];
        [_noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(KAdaptedHeight(0));
            make.height.mas_equalTo(KAdaptedWidth(20));
            make.centerY.mas_equalTo(KAdaptedHeight(0));
        }];
    }
    return _noDataLabel;
}



-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = KAdaptedHeight(60);
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.separatorStyle=0;
        _tableView.backgroundColor=Color(237, 227, 255, 0);
        [self.bgView addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(KAdaptedHeight(51));
            make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(KAdaptedHeight(15));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.bottom.mas_equalTo(KAdaptedHeight(-10));
            
        }];
    }
    return _tableView;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.dataArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecordTableCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[RecordTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.dataDic=self.dataArr[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
}








#pragma mark - setUpMainTableRefresh
- (void)setUpMainTableRefresh
{
    WeakSelf;
    [ZJUIUtil refreshWithHeader:self.tableView refresh:^{
        wself.mainPage = 1;
        [wself getMiniOfficial_messageWithParameters:YES];
    }];
    
    
    [ZJUIUtil refreshWithFooter:self.tableView refresh:^(){
        wself.mainPage ++;
        [wself getMiniOfficial_messageWithParameters:NO];
    }];
}


#pragma mark data
- (void)getMiniOfficial_messageWithParameters:(BOOL)isRefresh{
    if (isRefresh) {
        [self.dataArr removeAllObjects];
    }
    
    WeakSelf;
    [NetworkRequest POST:Request_GetDrawListRecord parmeters:@{@"type":@(self.type),@"page":@(self.mainPage),@"size":@(PageSize)} success:^(id responObject) {
        BaseModel *model=(BaseModel *)responObject;
        
        for (NSDictionary *dic in model.data) {
            NSMutableDictionary *dicdata=[NSMutableDictionary dictionaryWithDictionary:dic];
            [dicdata setObject:@(self.type) forKey:@"type"];
            [wself.dataArr addObject:dicdata];
        }
//        [wself.dataArr addObjectsFromArray:model.data];
        if (wself.dataArr.count>0) {
            wself.noDataLabel.hidden=YES;
        }else{
            wself.noDataLabel.hidden=NO;
        }
        [wself.tableView.mj_header endRefreshing];
        [wself.tableView.mj_footer endRefreshing];
        [wself.tableView reloadData];
        
    } failture:^(NSError *error) {
        [wself.tableView.mj_header endRefreshing];
        [wself.tableView.mj_footer endRefreshing];
        
    }];
    
    
    
    
    
    
    
}





@end
