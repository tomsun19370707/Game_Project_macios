//
//  MLMusicLibraryViewController.m
//  miliao
//
//  Created by aa on 2019/7/15.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "MLMusicLibraryViewController.h"


#import "Global.h"

#import "RoomMusicModel.h"
#import "RoomMusicTableViewCell.h"

@interface MLMusicLibraryViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic, strong) NSMutableArray        <RoomMusicModel *>*myMusicArray;
@property (nonatomic, strong) UITextField           *searchTF;
@property (nonatomic, strong) UIView                *headerView;

@property (nonatomic, assign) NSInteger             mainPage;

@end

@implementation MLMusicLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.bgView.backgroundColor = [UIColor redColor];
    self.mainPage = 1;
    [self.bgView addSubview:self.tableView];
    [self getNetworkExaminationWithText:@"" data:YES];
    [self setUpMainTableRefresh];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(next_music:) name:@"Next_music" object:nil];
    
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
    WEAK_SELF
    cell.playAndSuspendedClickBlock = ^(RoomMusicModel *model) {
        MYLog(@"%@",model.music_name);
        [weakSelf getCopy_musicWithParameters:model];
    };
    return cell;
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
- (void)getNetworkExaminationWithText:(NSString *)text data:(BOOL)isRefresh{
    if (isRefresh) {
        [self.myMusicArray removeAllObjects];
    }
    NSDictionary *dict = @{@"user_id":[UserManager userInfo].user_id,
                           @"page":@(self.mainPage),
                           @"keywords":text
                           };
    [HttpTool getLocal_musicsWithParameters:dict success:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            NSArray *array = [RoomMusicModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            if (array.count > 0) {
                [self.myMusicArray addObjectsFromArray:array];
                [self.myMusicArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    RoomMusicModel *playModel = (RoomMusicModel *)obj;
                    playModel.myMusic = @"2";
                }];
            }else{
                self.mainPage --;
            }
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
- (void)getCopy_musicWithParameters:(RoomMusicModel *)model{
    NSDictionary *dict = @{@"id":model.musicID,
                           @"user_id":[UserManager userInfo].user_id
                           };
    [HttpTool getCopy_musicWithParameters:dict success:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            [self.myMusicArray enumerateObjectsUsingBlock:^(RoomMusicModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.musicID isEqualToString:model.musicID]) {
                    obj.is_mymusic = @"1";
                }
            }];
        }
        [self.tableView reloadData];
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:response[@"message"]];
    } failure:^(NSError *error) {
        
    }];
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

- (UIView *)listView {
    return self.view;
}


@end
