//
//  EMO_CommentMoreVC.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/7.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_CommentMoreVC.h"
#import "EMO_CommentXQTableCell.h"
#import "MessageInfoModel.h"
#import "WTBottomInputView.h"
@interface EMO_CommentMoreVC ()<UITableViewDelegate, UITableViewDataSource,WTBottomInputViewDelegate>
@property(strong,nonatomic) WTBottomInputView *bottomView;//inputView
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
Strong UILabel *commentNumLabel;

Assign NSInteger mainPage;

Strong NSDictionary *selectDicData;

@end

@implementation EMO_CommentMoreVC

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}

-(NSDictionary *)selectDicData{
    if(!_selectDicData){
        _selectDicData=[NSDictionary dictionary];
    }
    return _selectDicData;
}

-(void)viewWillAppear:(BOOL)animated{
    [self commentData:YES];
    [self.bottomView resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(248, 248, 248, 1);
    [self loadBar:YES needBack:YES needBackground:YES];
    self.view.backgroundColor=RGBA(248, 248, 248, 1);
    self.titleLabel.font=KFont(18);
    self.titleLabel.text=getLanguage(@"评论详情");
    [self setUpMainTableRefresh];
    self.mainPage = 1;
    [self tableView];
    
    
    self.bottomView = [[WTBottomInputView alloc]init];
     self.bottomView.delegate = self;
    [self.view addSubview:self.bottomView];
    self.bottomView.hidden=YES;
    
}


#pragma mark - setUpMainTableRefresh
- (void)setUpMainTableRefresh
{
    WeakSelf;
    [ZJUIUtil refreshWithHeader:self.tableView refresh:^{
        wself.mainPage = 1;
        [wself commentData:YES];
    }];
    
    
    [ZJUIUtil refreshWithFooter:self.tableView refresh:^(){
        wself.mainPage ++;
        [wself commentData:NO];
    }];
}

-(void)commentData:(BOOL)type{
    
    WeakSelf;
    [SVProgressHUD show];
    [NetworkRequest POST:Request_DynamicCommnetList parmeters:@{@"dynamic_id":self.model.message_id,@"page":@(self.mainPage),@"size":@(PageSize)} success:^(id responObject) {
        NSLog(@"%@",responObject);
        [SVProgressHUD dismiss];
        BaseModel *baseModel = (BaseModel *)responObject;
        if(type){
            [self.dataArr removeAllObjects];
            self.dataArr=nil;
        }
        NSArray *arr=baseModel.data[@"list"];
        for(NSDictionary *dic1 in arr){
            NSArray *twoArr=dic1[@"children"];
            NSMutableDictionary *dic1Data=[NSMutableDictionary dictionaryWithDictionary:dic1];
            [dic1Data setObject:@"1" forKey:@"commentType"];
            [self.dataArr addObject:dic1Data];
            if(twoArr.count>0){
                for (NSDictionary *dic2 in twoArr) {
                    NSMutableDictionary *dic2Data=[NSMutableDictionary dictionaryWithDictionary:dic2];
                    [dic2Data setObject:@"2" forKey:@"commentType"];
                    [dic2Data setObject:dic1[@"id"] forKey:@"commentOneId"];
                    [self.dataArr addObject:dic2Data];
                }
            }
        }
        [wself.tableView reloadData];
        [wself.tableView.mj_header endRefreshing];
        [wself.tableView.mj_footer endRefreshing];
    } failture:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        [wself.tableView.mj_header endRefreshing];
        [wself.tableView.mj_footer endRefreshing];

    }];
    

    
}


- (UILabel *)commentNumLabel{
    if (!_commentNumLabel) {
        _commentNumLabel = [[UILabel alloc] init];
        _commentNumLabel.text = getLanguage(@"评论 (0)");
        _commentNumLabel.textColor = RGBA(0, 0, 0, 1);
        _commentNumLabel.font=KFontA(14);
    }
    return _commentNumLabel;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kWhiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor=[UIColor clearColor];
        _tableView.estimatedRowHeight=KAdaptedHeight(80);
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(KAdaptedHeight(-0));
            make.top.mas_equalTo(ZJTopNavH+ZJStatusBarH+2);
            make.leading.trailing.bottom.mas_equalTo(0);
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
    return KAdaptedHeight(50);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, KAdaptedHeight(50))];
    [view addSubview:self.commentNumLabel];
    [self.commentNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(KAdaptedHeight(0));
        make.leading.mas_equalTo(KAdaptedWidth(15));
        make.trailing.mas_equalTo(KAdaptedWidth(-15));
        
    }];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    EMO_CommentXQTableCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[EMO_CommentXQTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    cell.modelDic=self.dataArr[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    WeakSelf;
    cell.BtnClick = ^(NSMutableDictionary * _Nonnull dic, NSInteger tag) {
        if(tag==100){
            
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
            [alert addAction:[UIAlertAction actionWithTitle:getLanguage(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            for (NSDictionary *dic in self.reportArr) {
                [alert addAction:[UIAlertAction actionWithTitle:[Common isNull:dic[@"reason"]] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    for (NSDictionary *dic in self.reportArr) {
                        if([dic[@"reason"] isEqualToString:action.title]){
                            [self report:dic andReasonId:dic[@"id"]];
                            break;;
                        }
                    }
                    
                }]];
            }
            [wself presentViewController:alert animated:YES completion:nil];
            
        }else{
            [self likeData:dic andIndex:indexPath.row];
            
        }
    };
    return cell;

}


#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectDicData=self.dataArr[indexPath.row];
    self.bottomView.hidden=NO;
    [self.bottomView.textView becomeFirstResponder];
    
}


-(void)likeData:(NSMutableDictionary *)dic andIndex:(NSInteger)index{
    
    
    [NetworkRequest POST:Request_LikeOrFollow parmeters:@{@"dynamic_id":self.model.message_id,@"comment_id":dic[@"id"],@"type":@"0"} success:^(id responObject) {
//        self.mainPage = 1;
//        [self commentData:YES];
        
        NSInteger likenum=[dic[@"like_num"]integerValue];
        if([dic[@"is_like"] integerValue]==1){
            [dic setObject:@"0" forKey:@"is_like"];
            [dic setObject:[NSString stringWithFormat:@"%ld",likenum-1<0?0:likenum-1] forKey:@"like_num"];
        }else{
            [dic setObject:@"1" forKey:@"is_like"];
            [dic setObject:[NSString stringWithFormat:@"%ld",likenum+1] forKey:@"like_num"];
        }
        [self.dataArr replaceObjectAtIndex:index withObject:dic];
        EMO_CommentXQTableCell *cell = (EMO_CommentXQTableCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        cell.modelDic=dic;
        
    } failture:^(NSError *error) {
        
    }];
    
    
    
    
}


-(void)report:(NSDictionary *)dic andReasonId:(NSString *)reportID{
//type类型:0=动态,1=房间,2=会员，3=评论
    [NetworkRequest POST:Request_AddReport parmeters:@{@"reason_id":reportID,@"comment_id":dic[@"id"],@"type":@"3"} success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:baseModel.msg]];
        
    } failture:^(NSError *error) {
        
    }];
    
    
}

- (void)WTBottomInputViewSendTextMessage:(NSString *)message{
    self.bottomView.hidden=YES;
    if ([message isEqualToString:@"轻轻敲醒沉睡的心灵，让我看看你的点评~"]||[message isEqualToString:@""]) {
        return;
    }
    [self sendMessage:message];
}

#pragma mark 评论
-(void)sendMessage:(NSString *)text{
    self.bottomView.hidden=YES;
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    [dic setObject:text forKey:@"comment"];
    [dic setObject:self.model.message_id forKey:@"dynamic_id"];
    [dic setObject:self.selectDicData[@"id"] forKey:@"comment_id"];
    if([self.selectDicData[@"commentType"] integerValue]==2){
        [dic setObject:self.selectDicData[@"commentOneId"] forKey:@"first_comment_id"];
    }else{
        [dic setObject:self.selectDicData[@"id"] forKey:@"first_comment_id"];
      
    }
    
    [NetworkRequest POST:Request_CheckMessage parmeters:@{@"message":text} success:^(id responObject) {
        [self sendCommentData:dic];
    } failture:^(NSError *error) {

    }];

    
}


-(void)sendCommentData:(NSDictionary *)dic{
    
    [NetworkRequest POST:Request_AddComment parmeters:dic success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        NSLog(@"%@",baseModel.data);
        self.mainPage=1;
        [self commentData:YES];

    } failture:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
    
    
}




@end
