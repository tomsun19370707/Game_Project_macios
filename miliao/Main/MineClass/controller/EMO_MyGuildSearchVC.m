//
//  EMO_MyGuildSearchVC.m
//  miliao
//
//  Created by 张世浩 on 2022/10/18.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_MyGuildSearchVC.h"
#import "EMO_MyGuildTableViewCell.h"
@interface EMO_MyGuildSearchVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UITextField * searchTextField;
@property (nonatomic, strong) UIButton * searchBtn;
@property (nonatomic, strong) NODataView * dataView;


@end

@implementation EMO_MyGuildSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadBar:YES needBack:YES needBackground:YES];
    self.titleLabel.text=getLanguage(@"家族搜索");
    self.titleLabel.font=KFont(18);
    self.view.backgroundColor=kWhiteColor;
    
    [self searchTextField];
    [self searchBtn];
    [self tableView];

    
}


-(UITextField*)searchTextField{
    if (!_searchTextField) {
        _searchTextField =[[UITextField alloc] init];
        _searchTextField.backgroundColor =RGB(245, 245, 245);
        _searchTextField.placeholder = getLanguage(@"  请搜索关键词");
        _searchTextField.font = KFont(14);
        _searchTextField.delegate=self;
        _searchTextField.layer.cornerRadius=KAdaptedHeight(36)/2;
        _searchTextField.layer.masksToBounds=YES;
        _searchTextField.textColor = [UIColor blackColor];
        //输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
        _searchTextField.clearButtonMode = UITextFieldViewModeAlways;
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(15, 8, KAdaptedWidth(30), KAdaptedHeight(20))];
        UIImageView *imageV=[[UIImageView alloc] initWithFrame:CGRectMake(8, 0, KAdaptedWidth(20), KAdaptedHeight(20))];
        imageV.image=KGetImage(@"homeSearchImg");
        [view addSubview:imageV];
        _searchTextField.leftView=view;
        _searchTextField.leftViewMode=UITextFieldViewModeAlways;
        _searchTextField.returnKeyType = UIReturnKeySearch;
        [self.view addSubview:_searchTextField];
        [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(14));
            make.trailing.mas_equalTo(KAdaptedWidth(-50));
            make.top.mas_equalTo(ZJTopNavH+ZJStatusBarH);
            make.height.mas_equalTo(KAdaptedHeight(36));
            
        }];
    }
    return _searchTextField;
}


- (UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBtn setTitle:getLanguage(@"搜索") forState:UIControlStateNormal];
        [_searchBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        _searchBtn.titleLabel.font=KFontA(14);
        [_searchBtn addTarget:self action:@selector(BtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_searchBtn];
        [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.searchTextField.mas_trailing);
            make.top.mas_equalTo(self.searchTextField.mas_top);
            make.height.mas_equalTo(self.searchTextField.mas_height);
            make.trailing.mas_equalTo(KAdaptedWidth(-0));
            
        }];
    }
    return _searchBtn;
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
            make.top.mas_equalTo(self.searchTextField.mas_bottom).offset(KAdaptedHeight(17));
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
    return 0.5;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.5)];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EMO_MyGuildTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[EMO_MyGuildTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    cell.dicData = self.dataArr[indexPath.row];
    return cell;
}


#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    
}





//委托方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

//返回一个BOOL值，指定是否循序文本字段开始编辑

return YES;

}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
 //开始编辑时触发，文本字段将成为first responder
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{

//返回BOOL值，指定是否允许文本字段结束编辑，当编辑结束，文本字段会让出first responder
//要想在用户结束编辑时阻止文本字段消失，可以返回NO
//这对一些文本字段必须始终保持活跃状态的程序很有用，比如即时消息

    return YES;

}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

//当用户使用自动更正功能，把输入的文字
 
    //这对于想要加入撤销选项的应用程序特别有用

    //可以跟踪字段内所做的最后一次修改，也可以对所有编辑做日志记录,用作审计用途。

    //要防止文字被改变可以返回NO

    //这个方法的参数中有一个NSRange对象，指明了被改变文字的位置，建议修改的文本也在其中

    return YES;

    }

- (BOOL)textFieldShouldClear:(UITextField *)textField{

//返回一个BOOL值指明是否允许根据用户请求清除内容
//可以设置在特定条件下才允许清除内容

return YES;

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

//返回一个BOOL值，指明是否允许在按下回车键时结束编辑
 //如果允许要调用resignFirstResponder 方法，这回导致结束编辑，而键盘会被收起[textField resignFirstResponder];
    [self.searchTextField resignFirstResponder];
    
    return YES;

}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    [self searchwithKeywords:textField.text];
}

-(void)BtnClick{
    [self.searchTextField resignFirstResponder];
    
}


- (void)searchwithKeywords:(NSString *)string
{
    self.dataArr=nil;
    
    [NetworkRequest POST:Request_FamilyList parmeters:@{@"keyword":string} success:^(id responObject) {
        BaseModel *model=(BaseModel *)responObject;
        [self.dataArr addObjectsFromArray:model.data];
        [self.tableView reloadData];
        [self dataViewAddUpView];
        
    } failture:^(NSError *error) {
        
    }];

    
}
- (void)dataViewAddUpView{
    if (self.dataArr.count == 0 ) {
        [self.view addSubview:self.dataView];
    }else{
        [self.dataView removeFromSuperview];
    }
}

- (NODataView *)dataView{
    if (!_dataView) {
        _dataView = [[NODataView alloc] initWithFrame:CGRectMake(0,ZJTopNavH+ZJStatusBarH+KAdaptedHeight(17), ScreenWidth, ScreenHeight - (ZJTopNavH+ZJStatusBarH+KAdaptedHeight(17)))];
        [_dataView loadDataWithDic:@{@"imageName":@"no_result",
                                     @"title":getLanguage(@"搜索不到任何结果哦")
                                     }];
    }
    return _dataView;
}



//邀请会员
-(void)InvitationData:(NSDictionary *)dic{
    
    [HttpTool postRequstInvitationGuildUserWithParameters:@{@"organiza_id":self.guildID,@"invite_user":dic[@"id"]} success:^(id response) {
        [SVProgressHUD showImage:KGetImage(@"") status:[NSString stringWithFormat:@"%@",response[@"message"]]];
        if ([response[@"code"] integerValue] == 1) {
            
        }
    } failure:^(NSError *error) {
        
    }];
    
}

@end
