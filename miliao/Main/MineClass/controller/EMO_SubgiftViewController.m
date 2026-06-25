//
//  EMO_SubgiftViewController.m
//  miliao
//
//  Created by 张世浩 on 2022/10/17.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_SubgiftViewController.h"
#import "EMO_SubgiftTableViewCell.h"
#import "EMO_SubgiftRecordViewController.h"//转赠记录
#import "EMO_ZhauanZengDetailVC.h"//转赠界面
#import "EMO_FriendsModel.h"
@interface EMO_SubgiftViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UITextField * searchTextField;
@property (nonatomic, strong) UIImageView * wuImgView;

Assign NSInteger page;
Strong  NSString *searchText;

@end

@implementation EMO_SubgiftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadBar:YES needBack:YES needBackground:YES];
    self.titleLabel.text=getLanguage(@"我的转赠");
    self.titleLabel.font=KFont(18);
    self.rightTitleLabel.text=getLanguage(@"转赠记录");
    self.rightTitleLabel.textColor=RGBA(55, 171, 255, 1);
    self.rightTitleLabel.font=KFont(13);
    self.view.backgroundColor=kWhiteColor;
    self.page=1;
    [self searchTextField];
    [self setUpMainTableRefresh];
    [self tableView];
    [self wuImgView];
    self.tableView.hidden=YES;
   
    
    
    
}

-(void)rightButtonClick:(UIButton *)sender{
//    [SVProgressHUD showImage:KGetImage(@"") status:@"记录"];
    [self.navigationController pushViewController:[EMO_SubgiftRecordViewController new] animated:YES];
    
}


- (UIImageView*)wuImgView{
    if (!_wuImgView) {
        _wuImgView = [[UIImageView alloc] init];
        _wuImgView.image=KGetImage(@"noDataImg");
        [self.view addSubview:_wuImgView];
        [_wuImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(290), KAdaptedHeight(200)));
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.searchTextField.mas_bottom).offset(KAdaptedHeight(100));
            
        }];
    }
    return _wuImgView;
}

-(UITextField*)searchTextField{
    if (!_searchTextField) {
        _searchTextField =[[UITextField alloc] init];
        _searchTextField.backgroundColor =RGB(245, 245, 245);
        _searchTextField.placeholder = getLanguage(@"  支持用户ID/昵称");
        _searchTextField.font = KFont(14);
        _searchTextField.delegate=self;
        _searchTextField.layer.cornerRadius=KAdaptedHeight(13);
        _searchTextField.layer.masksToBounds=YES;
        _searchTextField.textColor = [UIColor blackColor];
        //输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
        _searchTextField.clearButtonMode = UITextFieldViewModeAlways;
        [self.view addSubview:_searchTextField];
        [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(14));
            make.trailing.mas_equalTo(KAdaptedWidth(-14));
            make.top.mas_equalTo(ZJTopNavH+ZJStatusBarH);
            make.height.mas_equalTo(KAdaptedHeight(36));
            
        }];
    }
    return _searchTextField;
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
        _tableView.backgroundColor =  RGBA(248, 248, 248, 1);
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
    WeakSelf;
    EMO_SubgiftTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[EMO_SubgiftTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    cell.selectionStyle=0;
    cell.dicData = self.dataArr[indexPath.row];
    cell.BtnBlock = ^(NSDictionary * _Nonnull dic) {
        NSLog(@"%@",dic);
        EMO_FriendsModel *model = [EMO_FriendsModel mj_objectWithKeyValues:dic];
        EMO_ZhauanZengDetailVC *vc = [[EMO_ZhauanZengDetailVC alloc] init];
        vc.dicdata = dic;
        [wself.navigationController pushViewController:vc animated:YES];
    };
    
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

    self.wuImgView.hidden=YES;
    self.tableView.hidden=NO;
    self.searchText=self.searchTextField.text;
    [self searchwithKeywords:self.searchTextField.text andffresh:YES];
    
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

//查一下resign这个单词的意思就明白这个方法了
    
    [self.searchTextField resignFirstResponder];
    
    return YES;

}


#pragma mark - setUpMainTableRefresh
- (void)setUpMainTableRefresh
{
    WeakSelf;
    [ZJUIUtil refreshWithHeader:self.tableView refresh:^{
        wself.page = 1;
        [wself searchwithKeywords:self.searchText andffresh:YES];
    }];
    
    
    [ZJUIUtil refreshWithFooter:self.tableView refresh:^(){
        wself.page ++;
        [wself searchwithKeywords:self.searchText andffresh:NO];
    }];
}



- (void)searchwithKeywords:(NSString *)string andffresh:(BOOL)fresh{
    
    [NetworkRequest POST:Request_SearchGiveUser parmeters:@{@"keyword":string,@"page":@(self.page),@"size":@(PageSize)} success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
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
    
    
    
    
    
    
    
//    NSDictionary *dic = @{@"user_id":@"12",@"keywords":string};
//    [HttpTool merge_searchWithParameters:dic success:^(id response) {
//        if ([response[@"code"] intValue] == 1) {
//            self.dataArr =response[@"data"][@"user"];
//            if (self.dataArr>0) {
//                self.tableView.hidden=NO;
//            }else{
//                [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"暂无更多数据")];
//                self.tableView.hidden=YES;
//            }
//            [self.tableView reloadData];
//        }
//
//    } failure:^(NSError *error) {
//
//    }];
}

@end
