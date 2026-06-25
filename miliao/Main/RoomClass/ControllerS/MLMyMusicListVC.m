//
//  MLMyMusicListVCViewController.m
//  miliao
//
//  Created by aa on 2019/7/15.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "MLMyMusicListVC.h"

#import "Global.h"

#import "RoomMusicModel.h"
#import "RoomMusicTableViewCell.h"
//#import "MLMaskView.h"/

@interface MLMyMusicListVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic, strong) NSMutableArray        *myMusicArray;
@property (nonatomic, strong) UITextField           *searchTF;
@property (nonatomic, strong) UIView                *headerView;

@property (nonatomic, assign) NSInteger             mainPage;
//@property (nonatomic, strong) MLMaskView            *maskView;
@property (nonatomic, strong) NODataView            *dataView;

@property (nonatomic, strong) RoomMusicModel        *cellModel;
@end

@implementation MLMyMusicListVC

- (void)viewWillAppear:(BOOL)animated{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.bgView.backgroundColor = [UIColor redColor];
    self.mainPage = 1;
    [self.bgView addSubview:self.tableView];
    [self getNetworkExaminationWithText:@"" data:YES];
    [self setUpMainTableRefresh];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(next_music:) name:@"Next_music" object:nil];
    
}

//- (void)rightButtonClick:(UIButton *)sender{
//    [SVProgressHUD showImage:[UIImage imageNamed:@""] status:getLanguage(@"请在Air官网进行音乐上传")];
//}

- (void)next_music:(NSNotification *)noti{
    RoomMusicModel *model = [noti object];
    [self.myMusicArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RoomMusicModel *playModel = (RoomMusicModel *)obj;
        if ([playModel.musicID isEqualToString:model.musicID]) {
            playModel.isPlay = @"1";
            self.musicModel = playModel;
        }else{
            playModel.isPlay = @"2";
        }
    }];
    [self.tableView reloadData];
}

#pragma mark - setUpMainTableRefresh
- (void)setUpMainTableRefresh
{
    WEAK_SELF
    [ZJUIUtil refreshWithHeader:self.tableView refresh:^{
        weakSelf.mainPage = 1;
        [weakSelf getNetworkExaminationWithText:self.searchTF.text data:YES];
    }];
    
    
    [ZJUIUtil refreshWithFooter:self.tableView refresh:^(){
        weakSelf.mainPage ++;
        [weakSelf getNetworkExaminationWithText:self.searchTF.text data:NO];
    }];
}

#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myMusicArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RoomMusicTableViewCell *cell = [RoomMusicTableViewCell cellWithTableView:tableView];
    cell.model = self.myMusicArray[indexPath.row];
    cell.playAndSuspendedClickBlock = ^(RoomMusicModel *model) {
        [self.myMusicArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            RoomMusicModel *playModel = (RoomMusicModel *)obj;
            if ([playModel.musicID isEqualToString:model.musicID]) {
                if ([model.isPlay integerValue] == 1) {
                    playModel.isPlay = @"0";
                }else {
                    playModel.isPlay = @"1";
                }
                self.musicModel = playModel;
            }else{
                playModel.isPlay = @"2";
            }
        }];
        
        ! self.playClickBlock ?: self.playClickBlock(self.musicModel);
        [self.tableView reloadData];
    };

    UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
    [cell addGestureRecognizer:longPressGesture];
    return cell;
}
- (void)cellLongPress:(UIGestureRecognizer *)recognizer{
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        RoomMusicTableViewCell *cell = (RoomMusicTableViewCell *)recognizer.view;
        self.cellModel = cell.model;
        //这里把cell做为第一响应(cell默认是无法成为responder,需要重写canBecomeFirstResponder方法)
        [cell becomeFirstResponder];
        UIMenuItem *itDelete = [[UIMenuItem alloc] initWithTitle:getLanguage(@"删除") action:@selector(handleDeleteCell:)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        menu.arrowDirection = UIMenuControllerArrowDefault;
        [menu setMenuItems:[NSArray arrayWithObjects:itDelete,  nil]];
        [menu setTargetRect:cell.frame inView:self.tableView];
        [menu setMenuVisible:YES animated:YES];
    }
}
- (void)handleDeleteCell:(id)sender{//复制cell
    [self getDel_user_musicWithParameters:self.cellModel];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    [self.headerView addSubview:self.searchTF];
    return self.headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

#pragma mark -
#pragma mark Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
#pragma mark -
#pragma mark UITextField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self getNetworkExaminationWithText:text data:YES];
    return YES;
}
#pragma mark getDataHttp
//getUser_musicsWithParameters
- (void)getNetworkExaminationWithText:(NSString *)text data:(BOOL)isRefresh{
    if (isRefresh) {
        [self.myMusicArray removeAllObjects];
    }
    NSDictionary *dict = @{@"user_id":[UserManager userInfo].user_id,
                           @"page":@(self.mainPage),
                           @"keywords":text
                           };
    [HttpTool getUser_musicsWithParameters:dict success:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            NSArray *array = [RoomMusicModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            if (array.count > 0) {
                [self.myMusicArray addObjectsFromArray:array];
                [self.myMusicArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    RoomMusicModel *model = (RoomMusicModel *)obj;
                    if ([model.musicID isEqualToString:self.musicModel.musicID]) {
                        model.isPlay = self.musicModel.isPlay;
                    }else{
                        model.isPlay = @"2";
                    }
                    model.myMusic = @"1";
                }];
            }else{
                self.mainPage --;
            }
        }
        [self dataViewAddUpView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
- (void)setMaskViewModel:(RoomMusicModel *)model{
    [self getDel_user_musicWithParameters:model];
//    [self.maskView setLeftButtonString:getLanguage(@"取消") rightButton:getLanguage(@"确定") promptLB:getLanguage(@"确定要删除此音乐吗？") maskViewH:140.f];
//    WEAK_SELF
//    self.maskView.determineClickBlock = ^{
//        [weakSelf getDel_user_musicWithParameters:model];
//    };
//    [self.bgView addSubview:self.maskView];
}
- (void)getDel_user_musicWithParameters:(RoomMusicModel *)model{
    NSDictionary *dict = @{@"id":model.musicID,
                           @"user_id":[UserManager userInfo].user_id
                           };
    [HttpTool getDel_user_musicWithParameters:dict success:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            [self.myMusicArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                RoomMusicModel *delModel = (RoomMusicModel *)obj;
                if ([delModel.musicID isEqualToString:delModel.musicID]) {
                    [self.myMusicArray removeObject:delModel];
                }
            }];
        }
        [self dataViewAddUpView];
        [self.tableView reloadData];
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:response[@"message"]];
    } failure:^(NSError *error) {
        
    }];
}

- (void)dataViewAddUpView{
    if (self.myMusicArray.count == 0) {
        [self.bgView addSubview:self.dataView];
    }else{
        [self.dataView removeFromSuperview];
    }
}

#pragma mark - getter methodsb
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.barView.bottom, self.bgView.width, self.bgView.height - self.barView.bottom - ZJTopNavH) style:UITableViewStyleGrouped];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundView = nil;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor=[UIColor clearColor];
    }
    return _tableView;
}
- (NSMutableArray *)myMusicArray{
    if (!_myMusicArray) {
        _myMusicArray = [NSMutableArray array];
    }
    return _myMusicArray;
}
- (UITextField *)searchTF{
    if (!_searchTF) {
        _searchTF = [ControlCreator createTextField:nil rect:CGRectMake(18, 15, ScreenWidth - 36, 35) placeholder:getLanguage(@"输入歌名或歌手名") placeholderColor:nil text:@"" font:Font(12) color:mainViceColor backguoundColor:MHColorFromHexString(@"#F8F8F8")];
        _searchTF.delegate = self;
        _searchTF.layer.masksToBounds = YES;
        _searchTF.layer.cornerRadius = 17.5;
//        _searchTF.keyboardType = UIKeyboardTypeNumberPad;
        UIImageView *leftTFView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, 18, 18)];
        leftTFView.backgroundColor = [UIColor clearColor];
        leftTFView.image = [UIImage imageNamed:@"music_sousuo"];
        _searchTF.leftView = leftTFView;
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _searchTF;
}
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [ControlCreator createView:nil rect:CGRectMake(0, 0, ScreenWidth, 65) backguoundColor:[UIColor whiteColor]];
    }
    return _headerView;
}
//- (MLMaskView *)maskView{
//    if (!_maskView) {
//        _maskView = [[NSBundle mainBundle] loadNibNamed:@"MLMaskView" owner:nil options:nil].lastObject;
//        _maskView.frame = CGRectMake(0, 0, ScreenViewWidth, ScreenViewHeight);
//
//    }
//    return _maskView;
//}
- (UIView *)listView {
    return self.view;
}
- (NODataView *)dataView{
    if (!_dataView) {
        _dataView = [[NODataView alloc] initWithFrame:CGRectMake(0, self.barView.bottom + 70, ScreenWidth, 300)];
        [_dataView loadDataWithDic:@{@"imageName":@"no_music",
                                     @"title":getLanguage(@"还没有音乐哦，快去添加吧~")
                                     }];
    }
    return _dataView;
}

@end
