//
//  MLSessionSetViewController.m
//  miliao
//
//  Created by feifei on 2019/8/3.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "MLSessionSetViewController.h"

#import "EMO_UserReportViewController.h"

#import "SessageSetTableViewCell.h"
#import "MLSessionSetTableViewCell.h"

#import "MLMaskView.h"

#import "MLUserReportModel.h"

@interface MLSessionSetViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView           *tableView;

@property (nonatomic, strong) NSMutableArray        *setArray;
@property (nonatomic, strong) NSString              *focusOn;

@property (nonatomic, strong) MLMaskView            *maskView;

Assign BOOL isBlack;

@end

@implementation MLSessionSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.backgroundColor=RGBA(248, 248, 248, 1);
    self.isNeedLine = YES;
    // Do any additional setup after loading the view.
    [self loadBar:YES needBack:YES needBackground:YES];
    self.leftButtonView.image = ImageNamed(@"xiaoxi_back");
    self.titleLabel.text = getLanguage(@"聊天设置");
    [self.bgView addSubview:self.tableView];
    
}
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.setArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    switch (indexPath.row) {
        case 0:{
            SessageSetTableViewCell *cell = [SessageSetTableViewCell cellWithTableView:tableView];
            cell.ryUserID = weakSelf.ryUserID;
            return cell;
        }
            break;
        case 1:{
            SessageSetTableViewCell *cell = [SessageSetTableViewCell cellWithTableView:tableView];
            cell.type=@"black";
            cell.ryUserID = weakSelf.ryUserID;
            cell.addBlock = ^(BOOL addBlack) {
//                if (addBlack) {
//                [weakSelf setMaskViewModel:addBlack];
//                }
            };
            return cell;
        }
            break;
            
//        case 1:{
//            SetFocusOnTableViewCell *cell = [SetFocusOnTableViewCell cellWithTableView:tableView];
//
//            cell.focusOn = self.focusOn;
//            cell.setConversationToTop = ^{
//                if ([self.focusOn integerValue] == 1) {
//                    [weakSelf getCancel_followWithParameters];
//                }else{
//                    [weakSelf getFollowWithParameters];
//                }
//            };
//            return cell;
//        }
//            break;
        default:
            break;
    }
    MLSessionSetTableViewCell *cell = [MLSessionSetTableViewCell cellWithTableView:tableView];
    cell.focusOn = self.setArray[indexPath.row];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

#pragma mark -
#pragma mark Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0.0001;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.00001;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
//        [self setMaskViewModel];
//        [self getReportWithParameters];
//    }
//    else if (indexPath.row == 3){
        [self getReportWithParameters];
    }
}




//拉黑 取黑
- (void)getPull_blackWithParameters{
    
    
    WeakSelf;
    [NetworkRequest POST:Request_GetfollowOrBlack parmeters:@{@"type":@"1",@"to_uid":self.ryUserID} success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        wself.isBlack=!wself.isBlack;
        if(wself.isBlack){
            [[RCCoreClient sharedCoreClient] addToBlacklist:self.ryUserID success:^{
            } error:^(RCErrorCode status) {

            }];
        }else{
            [[RCCoreClient sharedCoreClient] removeFromBlacklist:self.ryUserID success:^{
            } error:^(RCErrorCode status) {

            }];
        }
       
        
    } failture:^(NSError *error) {
        
    }];
    
    
 
}

-(void)reportReasonId:(NSString *)reportID{
//type类型:0=动态,1=房间,2=会员，3=评论
    [NetworkRequest POST:Request_AddReport parmeters:@{@"reason_id":reportID,@"to_uid":self.ryUserID,@"type":@"2"} success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:baseModel.msg]];
        
    } failture:^(NSError *error) {
        
    }];
    
    
}

//获取举报类型
- (void)getReportWithParameters{
    
    WeakSelf;
    [NetworkRequest POST:Request_GetReportReason parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:getLanguage(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        for (NSDictionary *dic in baseModel.data) {
            [alert addAction:[UIAlertAction actionWithTitle:[Common isNull:dic[@"reason"]] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                for (NSDictionary *dic in baseModel.data) {
                    if([dic[@"reason"] isEqualToString:action.title]){
                        [self reportReasonId:dic[@"id"]];
                        break;;
                    }
                }
            }]];
        }
        [wself presentViewController:alert animated:YES completion:nil];
        
    } failture:^(NSError *error) {
        
    }];
    
}

#pragma mark get
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, self.barView.bottom + 10, ScreenViewWidth, ScreenViewHeight - self.barView.bottom-10) style:UITableViewStyleGrouped];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundView = nil;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = RGBA(248, 248, 248, 1);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor=[UIColor clearColor];
//        _tableView.bounces = NO;
    }
    return _tableView;
}
- (NSMutableArray *)setArray{
    if (!_setArray) {
//        _setArray = [NSMutableArray arrayWithArray:@[@"置顶聊天", @"关注", @"拉黑", @"举报"]];
        _setArray = [NSMutableArray arrayWithArray:@[getLanguage(@"置顶聊天"), getLanguage(@"拉黑"),getLanguage(@"举报")]];
    }
    return _setArray;
}
- (MLMaskView *)maskView{
    if (!_maskView) {
        _maskView = [[NSBundle mainBundle] loadNibNamed:@"MLMaskView" owner:nil options:nil].lastObject;
        _maskView.frame = CGRectMake(0, 0, ScreenViewWidth, ScreenViewHeight);
    }
    return _maskView;
}
- (void)setMaskViewModel:(BOOL)selectOpen{
    [self.maskView setLeftButtonString:getLanguage(@"取消") rightButton:selectOpen==NO?getLanguage(@"拉黑"):getLanguage(@"移除") promptLB:selectOpen==NO?getLanguage(@"确定拉黑此用户吗"):getLanguage(@"确定把此用户移除黑名单吗") maskViewH:140.f];
    WEAK_SELF
    self.maskView.leftButtonBlock = ^{
        [weakSelf.tableView reloadData];
    };
    self.maskView.determineClickBlock = ^{
            [weakSelf getPull_blackWithParameters];
        
    };
    [self.view addSubview:self.maskView];
}


@end
