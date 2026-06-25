//
//  DB_CustomAddressView.m
//  MeetHer
//
//  Created by 张世浩 on 2023/2/17.
//

#import "DB_CustomAddressView.h"

@interface DB_CustomAddressView()<UITableViewDataSource,UITableViewDelegate,AMapLocationManagerDelegate,AMapSearchDelegate>

@property (nonatomic ,strong) UIView *bgView;
@property (nonatomic ,strong) UIButton *cancalBtn;
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UIButton *noShowAddressBtn;
Strong UITableView *listView;
Strong NSMutableArray *listArray;
@property (nonatomic,strong) AMapLocationManager *locationManager;
@property (nonatomic,strong) AMapSearchAPI *search;


@end


@implementation DB_CustomAddressView

-(NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc] init];
    }
    return _listArray;
}
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
        //更新App是否显示隐私弹窗的状态，隐私弹窗是否包含高德SDK隐私协议内容的状态. since 8.1.0
        [self LocationAddress];
        [self addChildrenViews];
    }
    return self;
}



- (void) addChildrenViews{
    [super addChildrenViews];
    [self bgView];
    [self titleLabel];
    [self cancalBtn];
    [self noShowAddressBtn];

    [self listView];
    
    
    
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor =kWhiteColor;
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(self);
            make.height.mas_equalTo(KAdaptedHeight(600));
        }];
    }
    return _bgView;
}


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = getLanguage(@"添加位置");
        _titleLabel.textColor = RGBA(34, 34, 34, 1);
        _titleLabel.textAlignment=NSTextAlignmentCenter;
        _titleLabel.font=KFontBold(17);
        [self.bgView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(KAdaptedWidth(150));
            make.height.mas_equalTo(KAdaptedWidth(25));
            make.top.mas_equalTo(self.bgView.mas_top).offset(KAdaptedHeight(19));
        }];
    }
    return _titleLabel;
}


- (UIButton *)cancalBtn{
    if (!_cancalBtn) {
        _cancalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancalBtn setImage:[UIImage imageNamed:@"closeImg"] forState:UIControlStateNormal];
        [_cancalBtn addTarget:self action:@selector(cancalBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_cancalBtn];
        [_cancalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(45), KAdaptedHeight(45)));
            make.leading.mas_equalTo(self.bgView.mas_leading).offset(KAdaptedHeight(14));
            make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
           
        }];
    }
    return _cancalBtn;
}

- (UIButton *)noShowAddressBtn{
    if (!_noShowAddressBtn) {
        _noShowAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_noShowAddressBtn setTitle:getLanguage(@"不显示位置") forState:UIControlStateNormal];
        [_noShowAddressBtn setTitleColor:RGBA(255, 36, 62, 1) forState:UIControlStateNormal];
        _noShowAddressBtn.titleLabel.font=KFont(14);
        [_noShowAddressBtn addTarget:self action:@selector(noShowBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _noShowAddressBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [self.bgView addSubview:_noShowAddressBtn];
        [_noShowAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(80), KAdaptedHeight(45)));
            make.leading.mas_equalTo(self.bgView.mas_leading).offset(KAdaptedHeight(20));
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(KAdaptedHeight(20));
           
        }];
    }
    return _noShowAddressBtn;
}



- (UITableView *)listView{
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listView.backgroundColor = [UIColor whiteColor];
        _listView.showsVerticalScrollIndicator = NO;
        _listView.rowHeight = KAdaptedHeight(55);
        [self.bgView addSubview:_listView];
        [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.noShowAddressBtn.mas_bottom).offset(KAdaptedHeight(10));
            make.leading.trailing.mas_offset(0);
            make.bottom.mas_offset(-KSAFEAREA_BOTTOM_HEIHGHT-KAdaptedHeight(5));

        }];
    }
    return _listView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    AMapPOI *poidData=self.listArray[indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"%@",poidData.name];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@%@%@%@",poidData.city,poidData.district,poidData.businessArea,poidData.address];
    cell.backgroundColor=kWhiteColor;
    cell.textLabel.textColor=RGBA(34, 34, 34, 1);
    cell.textLabel.font=KFont(14);
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AMapPOI *poidData=self.listArray[indexPath.row];
    if (self.cancleBtnClick) {
        self.cancleBtnClick(@{@"type":@"2",@"province":poidData.province,@"city":poidData.city,@"district":poidData.district,@"businessArea":poidData.businessArea,@"address":poidData.address,@"name":poidData.name,@"lng":@(poidData.location.longitude),@"lat":@(poidData.location.latitude)});
    }
}

-(void)cancalBtnClick{
    
    if (self.cancleBtnClick) {
        self.cancleBtnClick(@{@"type":@"1"});
    }
    
}

-(void)noShowBtnClick{
    
    if (self.cancleBtnClick) {
        self.cancleBtnClick(@{@"type":@"3"});
    }
    
}



#pragma mark 定位
-(void)LocationAddress{
    WeakSelf;
   
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    self.locationManager.delegate=self;
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
            if (error) {
                NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
                if (error.code == AMapLocationErrorLocateFailed){
                    [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"定位失败!")];
                    return;
                }
            }
            NSLog(@"location:%@", location)
            if (regeocode){
                NSLog(@"reGeocode:%@", regeocode);
            }
        
        [wself searchLocation:location];
//            [ws prepareListData:location.coordinate.latitude andLongitude:location.coordinate.longitude];


        }];

}


-(void)searchLocation:(CLLocation *)location{
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location            = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
//    request.keywords            = @"";
    /* 按照距离排序. */
    request.sortrule            = 0;
//    request.requireExtension    = YES;
    [self.search AMapPOIAroundSearch:request];
    
    
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    if (response.pois.count == 0){
        [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"暂无更多数据")];
        return;
    }

    self.listArray=[NSMutableArray arrayWithArray:response.pois];
    
    [self.listView reloadData];
    NSLog(@"%@",response);
    
    
    
    
    
}



@end
