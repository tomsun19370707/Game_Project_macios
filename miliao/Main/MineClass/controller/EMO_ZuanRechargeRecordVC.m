//
//  EMO_ZuanRechargeRecordVC.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/5.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_ZuanRechargeRecordVC.h"
#import "EMO_ZuanRecordTableCell.h"

@interface EMO_ZuanRechargeRecordVC ()<UITableViewDelegate,UITableViewDataSource>
Strong UITableView *listView;
Strong NSMutableArray *listArray;

Strong UIButton *timeBtn;
Assign NSInteger page;

@end

@implementation EMO_ZuanRechargeRecordVC
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
    self.page=1;
    [self setUpMainTableRefresh];
    self.titleLabel.text=getLanguage(@"钻石明细");
    self.titleLabel.font=KFont(18);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSString *str = [formatter stringFromDate:[NSDate date]];
    [self reuqestList:str andFresh:YES];
    [self.timeBtn setTitle:str forState:UIControlStateNormal];
    
}

- (UIButton *)timeBtn{
    if (!_timeBtn) {
        _timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _timeBtn.backgroundColor=kWhiteColor;
        [_timeBtn setTitle:getLanguage(@"时间筛选") forState:UIControlStateNormal];
        [_timeBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        _timeBtn.titleLabel.font=KFont(13);
        [_timeBtn setImage:[UIImage imageNamed:@"DownImg"] forState:UIControlStateNormal];
        [_timeBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _timeBtn.layer.cornerRadius=KAdaptedHeight(20);
        _timeBtn.layer.masksToBounds=YES;
//        _timeBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        _timeBtn.tag=100;
        [self.view addSubview:_timeBtn];
        [_timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.top.mas_equalTo(KAdaptedHeight(5)+ZJTopNavH+ZJStatusBarH);
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(100), KAdaptedHeight(40)));
            
        }];
        [_timeBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5];
    }
    return _timeBtn;
}

- (UITableView *)listView{
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listView.backgroundColor = [UIColor clearColor];
        _listView.showsVerticalScrollIndicator = NO;
        _listView.rowHeight = KAdaptedHeight(50);
//        _listView.estimatedRowHeight = KAdaptedHeight(100);
//        _listView.rowHeight = UITableViewAutomaticDimension;
        [self.view addSubview:_listView];
        [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(-KSAFEAREA_BOTTOM_HEIHGHT);
            make.top.mas_equalTo(ZJTopNavH+ZJStatusBarH+KAdaptedHeight(60));
        }];
    }
    return _listView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EMO_ZuanRecordTableCell *cell=[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell"]];
    if (!cell) {
        cell=[[EMO_ZuanRecordTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[NSString stringWithFormat:@"Cell"]];
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
        [wself reuqestList:wself.timeBtn.titleLabel.text andFresh:YES];
    }];
    
    
    [ZJUIUtil refreshWithFooter:self.listView refresh:^(){
        wself.page ++;
        [wself reuqestList:wself.timeBtn.titleLabel.text andFresh:NO];
    }];
}


#pragma mark 获取数据
- (void)reuqestList:(NSString *)time andFresh:(BOOL)fresh{
    WeakSelf;
    [Common isNull:@""];
    NSDictionary *dic = @{@"time":[Common deleteUnicodeStr:time],@"page":@(self.page),@"size":@(PageSize)};
    [NetworkRequest POST:Request_getMyDiamondLog parmeters:dic success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        if(fresh){
            [wself.listArray removeAllObjects];
            wself.listArray=nil;
        }

        NSArray *array =baseModel.data;
        if (array.count>0) {
            for (NSDictionary *dic in array) {
                NSMutableDictionary *dicData=[NSMutableDictionary dictionaryWithDictionary:dic];
                [dicData setObject:@"0" forKey:@"select"];
                [wself.listArray addObject:dicData];
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
-(void)BtnClick:(UIButton *)sender{
    WeakSelf;
    //    // 1.创建日期选择器
    BRDatePickerView * _datePickerView = [[BRDatePickerView alloc]init];
        // 2.设置属性
    _datePickerView.pickerMode = BRDatePickerModeYM;
    _datePickerView.title = getLanguage(@"时间选择");
    _datePickerView.selectDate = [NSDate date];
    _datePickerView.maxDate = [NSDate date];
    _datePickerView.minDate = [NSDate br_setYear:2020 month:01];
    _datePickerView.isAutoSelect = NO;
    _datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
            NSLog(@"选择的值：%@", selectValue);
        [wself.timeBtn setTitle:[NSString stringWithFormat:@"%@",selectValue] forState:UIControlStateNormal];
        [wself.timeBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5];
        wself.page=1;
        [wself reuqestList:selectValue andFresh:YES];
        };
        // 设置自定义样式
        BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
    customStyle.pickerColor = kWhiteColor;
    customStyle.pickerTextColor = RGBA(34, 34, 34, 1);
    customStyle.separatorColor = RGBA(232, 232, 232, 1);
    customStyle.paddingBottom=KAdaptedHeight(-30);
    customStyle.titleBarColor=kWhiteColor;
    customStyle.titleTextColor=RGBA(34, 34, 34, 1);
    customStyle.cancelTextColor=RGBA(34, 34, 34, 1);
    customStyle.doneTextColor=RGBA(34, 34, 34, 1);
    customStyle.cancelBtnTitle=getLanguage(@"取消");
    customStyle.doneBtnTitle=getLanguage(@"确定");
    _datePickerView.pickerStyle = customStyle;
    [_datePickerView show];
    
}





@end
