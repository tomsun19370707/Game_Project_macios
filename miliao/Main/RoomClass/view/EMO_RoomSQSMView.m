//
//  EMO_RoomSQSMView.m
//  miliao
//
//  Created by jkkj on 2021/7/6.
//  Copyright © 2021 miliao. All rights reserved.
//

#import "EMO_RoomSQSMView.h"
#import "EMO_RoomSQSMCell.h"

@interface EMO_RoomSQSMView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIButton *baseBtn;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL heightShow;

Assign NSInteger mainPage;


@end

@implementation EMO_RoomSQSMView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.heightShow=NO;
        self.width = ScreenWidth;
        self.dataArray = [[NSMutableArray alloc] init];
        [self createUI];
        self.mainPage=1;
        [self setUpMainTableRefresh];
        [self requestData:YES];
        
        [AddNoticeObserver(@"uploadSQSMListData"){
            if([[MLRoomInformationModel currentAccount].uuid integerValue]==[[UserManager userInfo].user_id integerValue]){
                [self.dataArray removeAllObjects];
                self.mainPage=1;
                [self requestData:YES];
            }
           
        }];
    }
    return self;
}

- (void)createUI{
    [self.baseBtn addTarget:self action:@selector(baseClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.baseView];
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(15);
        make.height.mas_offset(415);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = RGBA(51, 51, 51, 1);
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font=KFont(16);
    self.titleLabel.text = getLanguage(@"排队");
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.baseView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(KAdaptedWidth(50));
        make.trailing.mas_offset(KAdaptedWidth(-50));
        make.top.mas_offset(KAdaptedHeight(17));
        make.height.mas_offset(KAdaptedHeight(25));
    }];
    
//    [self backBtn];
    
}

#pragma mark -------View
- (UIView *)baseView{
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = RGBA(255, 255, 255, 0.95);
        _baseView.layer.cornerRadius=KAdaptedHeight(15);
        _baseView.layer.masksToBounds=YES;
        
    }
    return _baseView;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:KGetImage(@"closeListImg") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(baseClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(KAdaptedWidth(-14));
            make.width.height.mas_equalTo(KAdaptedWidth(30));
            make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
            
        }];
    }
    return _backBtn;
}



- (UIButton *)baseBtn{
    if (!_baseBtn) {
        _baseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_baseBtn];
        [_baseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_offset(0);
        }];
    }
    return _baseBtn;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
//        _tableView.backgroundColor = MHColorFromHexString(@"#ffffff");
        _tableView.backgroundColor=kClearColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [self.baseView addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
            make.bottom.mas_offset(0);
        }];
        [_tableView registerNib:[UINib nibWithNibName:@"EMO_RoomSQSMCell" bundle:nil] forCellReuseIdentifier:@"EMO_RoomSQSMCell"];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EMO_RoomSQSMCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EMO_RoomSQSMCell"];

    [cell cellModel:self.dataArray[indexPath.row] index:indexPath.row];
    cell.selectionStyle=0;
    cell.cellClickBlock = ^(NSDictionary * _Nonnull model, NSInteger index,NSInteger tag) {
        if (tag == 10) {
            //同意
            [self requestSubmit:1 ID:model[@"id"] userID:model[@"uid"] index:index];
        }else{
            //拒绝
            [self requestSubmit:2 ID:model[@"id"] userID:model[@"uid"] index:index];
        }
    };
    return cell;
}

- (void)showView{
    self.heightShow=YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.top = 0;
        self.height = ScreenHeight;
    }];
}

- (void)hideView{
    self.heightShow=NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.top = ScreenHeight;
        self.height = ScreenHeight;
    }];
}
- (void)baseClick{
    [self hideView];
}


-(void)setFreshDara:(BOOL)freshDara{
    _freshDara=freshDara;
    if([[MLRoomInformationModel currentAccount].uuid integerValue]==[[UserManager userInfo].user_id integerValue]){
        if (self.heightShow) {
            self.top = 0;
        }else{
            self.top = ScreenHeight;
        }
        self.mainPage=1;
        [self requestData:YES];
    }

}


#pragma mark - setUpMainTableRefresh
- (void)setUpMainTableRefresh
{
    WeakSelf;
    [ZJUIUtil refreshWithHeader:self.tableView refresh:^{
        wself.mainPage = 1;
        [wself requestData:YES];
    }];
    
    
    [ZJUIUtil refreshWithFooter:self.tableView refresh:^(){
        wself.mainPage ++;
        [wself requestData:NO];
    }];
}



- (void)requestData:(BOOL)fresh{


    [NetworkRequest POST:Request_GetApplyList parmeters:@{@"room_id":[MLRoomInformationModel currentAccount].room_id,@"page":@(self.mainPage),@"size":@(PageSize)} success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        NSLog(@"");
        if(fresh){
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:basemodel.data];
        [self.tableView reloadData];
        
    } failture:^(NSError *error) {
        
    }];
    
    
      
    
}
//type    否    string    1同意 2拒绝
- (void)requestSubmit:(NSInteger )type
                   ID:(NSString *)ID
                   userID:(NSString *)userID
                index:(NSInteger)index{
    
    NSDictionary *dic=[NSDictionary dictionary];
    if(type==1){
        dic=@{@"room_id":[MLRoomInformationModel currentAccount].room_id,@"room_microphone_apply_id":ID,@"type":@"0"};
    }else{
        dic=@{@"room_id":[MLRoomInformationModel currentAccount].room_id,@"room_microphone_apply_id":ID};
    }
    WeakSelf;
    [NetworkRequest POST:type==1?Request_AgreeMicrophoneApply:Request_delMicrophoneApply parmeters:dic success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        NSLog(@"");
//        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:[Common isNull:basemodel.data]];
        [wself.dataArray removeObjectAtIndex:index];
        [wself.tableView reloadData];
        if (wself.SQBlock) {
            wself.SQBlock(@{@"userid":userID,@"type":@(type)});
        }
    } failture:^(NSError *error) {
        
    }];
    
    
    
}
@end
