//
//  EMO_RoomManagerView.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/10.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_RoomManagerView.h"
#import "EMO_RoomManagerCell.h"
#import "EMO_PersonalDataBaseVC.h"
@interface EMO_RoomManagerView()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

Strong UIView *lineView;
Strong UIButton *weekBtn;
Strong UIButton *DaylistBtn;
Strong UIButton *monthBtn;


Strong UIImageView *bgImgOneView;
Strong UITableView *tableView;
Strong NSMutableArray *dataArr;
Assign NSInteger page;

Assign NSInteger labelSelectTag;

@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) NSArray *searchArry;
@property (nonatomic, assign) BOOL isSearch;

@end

@implementation EMO_RoomManagerView

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
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

- (void)singleTapGesture:(UITapGestureRecognizer *)tap{
    [self removeFromSuperview];
}


-(void)initView{
    self.labelSelectTag=4000;
    self.page=1;
    self.isSearch=YES;
    [self bgImgOneView];

    
    [self DaylistBtn];
    [self weekBtn];
    [self monthBtn];
    [self lineView];
    [self searchTF];
    [self tableView];
    
    [self GetData:YES andkeyword:@""];
    
    [self setUpMainTableRefresh];
    
    
    
}


#pragma mark - setUpMainTableRefresh
- (void)setUpMainTableRefresh
{
    WeakSelf;
    [ZJUIUtil refreshWithHeader:self.tableView refresh:^{
        wself.page = 1;
        [wself GetData:YES andkeyword:self.searchTF.text];
    }];
    
    
    [ZJUIUtil refreshWithFooter:self.tableView refresh:^(){
        wself.page ++;
        [wself GetData:NO andkeyword:self.searchTF.text];
    }];
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



- (UIButton *)DaylistBtn{
    if (!_DaylistBtn) {
        _DaylistBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_DaylistBtn setTitle:getLanguage(@"房管") forState:UIControlStateNormal];
        _DaylistBtn.tag=4000;
        [_DaylistBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        _DaylistBtn.titleLabel.font=KFontBold(16);
        [_DaylistBtn addTarget:self action:@selector(BtnCLick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgImgOneView addSubview:_DaylistBtn];
        [_DaylistBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(10));
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
        [_weekBtn setTitle:getLanguage(@"禁言") forState:UIControlStateNormal];
        _weekBtn.tag=5000;
        [_weekBtn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
        _weekBtn.titleLabel.font=KFont(14);
        [_weekBtn addTarget:self action:@selector(BtnCLick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgImgOneView addSubview:_weekBtn];
        [_weekBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.DaylistBtn.mas_top);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.width.mas_equalTo(self.DaylistBtn.mas_width);
            make.height.mas_equalTo(self.DaylistBtn.mas_height);
            
        }];
    }
    return _weekBtn;
}

- (UIButton *)monthBtn{
    if (!_monthBtn) {
        _monthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_monthBtn setTitle:getLanguage(@"黑名单") forState:UIControlStateNormal];
        _monthBtn.tag=6000;
        [_monthBtn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
        _monthBtn.titleLabel.font=KFont(14);
        [_monthBtn addTarget:self action:@selector(BtnCLick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgImgOneView addSubview:_monthBtn];
        [_monthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.DaylistBtn.mas_top);
            make.trailing.mas_equalTo(KAdaptedWidth(-40));
            make.width.mas_equalTo(self.DaylistBtn.mas_width);
            make.height.mas_equalTo(self.DaylistBtn.mas_height);
            
        }];
    }
    return _monthBtn;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor=BaseMainColor;
        _lineView.layer.cornerRadius = KAdaptedHeight(3.5)/2;
        _lineView.layer.masksToBounds=YES;
        [self.bgImgOneView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(30),KAdaptedHeight(3.5)));
            make.top.mas_equalTo(self.DaylistBtn.mas_centerY).offset(KAdaptedHeight(8));
            make.centerX.mas_equalTo(self.DaylistBtn.mas_centerX);
            
        }];
    }
    return _lineView;
}

- (UITextField *)searchTF{
    if (!_searchTF) {
        _searchTF = [ControlCreator createTextField:nil rect:CGRectMake(0, 0, 0, 0) placeholder:@"查找添加新房管" placeholderColor:nil text:@"" font:KFontA(13) color:mainViceColor backguoundColor:RGBA(227, 227, 227, 0.4)];
        _searchTF.delegate = self;
        _searchTF.layer.masksToBounds = YES;
        _searchTF.layer.cornerRadius = 17.5;
        _searchTF.keyboardType = UIKeyboardTypeDefault;
        UIView *leftTFView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 35)];
        leftTFView.backgroundColor = [UIColor clearColor];
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(14, 7, 20, 20)];
        imageView.image=KGetImage(@"roomSearchUserImg");
        [leftTFView addSubview:imageView];
        _searchTF.leftView = leftTFView;
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
        [self.bgImgOneView addSubview:_searchTF];
        [_searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.DaylistBtn.mas_bottom).offset(14);
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(35);
        }];
    }
    return _searchTF;
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
        [self.bgImgOneView addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.searchTF.mas_bottom).offset(KAdaptedHeight(5));
            make.leading.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(KAdaptedHeight(-0));

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
    
    EMO_RoomManagerCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[EMO_RoomManagerCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    cell.dicData = self.dataArr[indexPath.row];
    WeakSelf;
    cell.quDingButtonClickBlock = ^(NSDictionary * _Nonnull dic) {
        if ([dic[@"status"] integerValue]==4000){
            //                取消
            [wself setData:dic andStatus:NO andType:1];
        }else if ([dic[@"status"] integerValue]==5000){
            //                解除禁言
            [wself setData:dic andStatus:[dic[@"is_muted"] integerValue]==0?NO:YES andType:2];
        }else if (([dic[@"status"] integerValue]==6000)||([dic[@"status"] integerValue]==1)){
            //                解除拉黑
            [wself setData:dic andStatus:[dic[@"is_black"] integerValue]==0?NO:YES andType:3];
        }else{
            if([dic[@"type"] integerValue]==0){
//                设置管理员
                [wself setData:dic andStatus:YES andType:1];
            }else if([dic[@"type"] integerValue]==2){
                //                取消管理员
                [wself setData:dic andStatus:NO andType:1];
            }
            
        }
        
    };
    
    return cell;
}


#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    EMO_PersonalDataBaseVC *VC=[EMO_PersonalDataBaseVC new];
    VC.userID = self.dataArr[indexPath.row][@"user_id"];
    [[Common getCurrentVC].navigationController pushViewController:VC animated:YES];
    
}



-(void)BtnCLick:(UIButton *)sender{
    WeakSelf;
    switch (sender.tag) {
        
        case 4000:{
            self.labelSelectTag=4000;
            [wself.DaylistBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
            [wself.weekBtn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
            [wself.monthBtn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
            wself.DaylistBtn.titleLabel.font=KFontBold(16);
            wself.weekBtn.titleLabel.font=KFont(14);
            wself.monthBtn.titleLabel.font=KFont(14);
            [UIView animateWithDuration:0.5 animations:^{
                [wself.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(20),KAdaptedHeight(3.5)));
                    make.top.mas_equalTo(wself.DaylistBtn.mas_centerY).offset(KAdaptedHeight(10));
                    make.centerX.mas_equalTo(wself.DaylistBtn.mas_centerX);

                }];
            }];
        }break;
        case 5000:{
            self.labelSelectTag=5000;
            [wself.weekBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
            [wself.DaylistBtn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
            [wself.monthBtn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
            wself.weekBtn.titleLabel.font=KFontBold(16);
            wself.DaylistBtn.titleLabel.font=KFont(14);
            wself.monthBtn.titleLabel.font=KFont(14);
            [UIView animateWithDuration:0.5 animations:^{
                [wself.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(20),KAdaptedHeight(3.5)));
                    make.top.mas_equalTo(wself.DaylistBtn.mas_centerY).offset(KAdaptedHeight(10));
                    make.centerX.mas_equalTo(wself.weekBtn.mas_centerX);

                }];
            }];
        }break;
        case 6000:{
            self.labelSelectTag=6000;
            [wself.monthBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
            [wself.weekBtn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
            [wself.DaylistBtn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
            wself.monthBtn.titleLabel.font=KFontBold(16);
            wself.weekBtn.titleLabel.font=KFont(14);
            wself.DaylistBtn.titleLabel.font=KFont(14);
            [UIView animateWithDuration:0.5 animations:^{
                [wself.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(20),KAdaptedHeight(3.5)));
                    make.top.mas_equalTo(wself.DaylistBtn.mas_centerY).offset(KAdaptedHeight(10));
                    make.centerX.mas_equalTo(wself.monthBtn.mas_centerX);

                }];
            }];
        }break;
           
            
        default:
            break;
    }
    
    [self GetData:YES andkeyword:self.searchTF.text];
}



-(void)GetData:(BOOL)fresh andkeyword:(NSString *)keyword
{
    NSMutableDictionary *dict =[NSMutableDictionary dictionaryWithDictionary:@{ @"room_id":[MLRoomInformationModel currentAccount].room_id,@"page":@(self.page),@"size":@(PageSize),@"status":@(self.labelSelectTag/1000-3)}];
    if(keyword.length>0){
        [dict setObject:keyword forKey:@"keyword"];
        if(self.labelSelectTag==4000){
            [dict setObject:@"0" forKey:@"status"];
        }else  if(self.labelSelectTag==6000){
            [dict setObject:@"1" forKey:@"status"];
        }
    }
    
//   status 0=全部，1房管，2禁言，3拉黑
    [SVProgressHUD showWithStatus:getLanguage(@"加载中...")];
    [NetworkRequest POST:Request_GetRoomUser parmeters:dict success:^(id responObject) {
        [SVProgressHUD dismiss];
        BaseModel *basemodel=(BaseModel *)responObject;
        NSLog(@"%@",basemodel.data);
        if(fresh){
            [self.dataArr removeAllObjects];
        }
        for (NSDictionary *dic in basemodel.data) {
            NSMutableDictionary *dicData=[NSMutableDictionary dictionaryWithDictionary:dic];
            if(keyword.length>0){
                if(self.labelSelectTag==4000){
                    [dicData setObject:@"0" forKey:@"status"];
                }else  if(self.labelSelectTag==6000){
                    [dicData setObject:@"1" forKey:@"status"];
                }
            }else{
                [dicData setObject:@(self.labelSelectTag) forKey:@"status"];
            }
            [self.dataArr addObject:dicData];
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failture:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    

}

-(void)setData:(NSDictionary *)dic andStatus:(BOOL)status andType:(NSInteger )type{
    
    NSString *urlStr=[NSString string];
    NSMutableDictionary *dataDic=[NSMutableDictionary dictionary];
    [dataDic setObject:[MLRoomInformationModel currentAccount].room_id forKey:@"room_id"];
    [dataDic setObject:dic[@"id"] forKey:@"room_user_id"];
    if(type==1){//设置or取消管理员
        urlStr=Request_SetRoomAdmin;
    }else{
        urlStr=Request_SetRoomUser;
        [dataDic setObject:@"1" forKey:@"type"];////设置or取消拉黑
        if (type==2){//解除禁言
            [dataDic setObject:@"0" forKey:@"type"];
        }
    }
    
    [NetworkRequest POST:urlStr parmeters:dataDic success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:basemodel.msg]];
        if(self.SuccessClick){
            self.SuccessClick(dic, type);
        }
        [self GetData:YES andkeyword:self.searchTF.text];
        
    } failture:^(NSError *error) {
        
        
        
        
        
    }];
    
    
    
    
}









- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容

    [self GetData:YES andkeyword:toBeString];
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}



@end
