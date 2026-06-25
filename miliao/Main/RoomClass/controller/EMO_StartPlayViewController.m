//
//  EMO_StartPlayViewController.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/19.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_StartPlayViewController.h"
#import "EMO_MLRoomNewVC.h"//进入直播间
#import "EMO_StartRoomHostView.h"//主播和麦位视图
#import "EMO_RoomAnnouncementVC.h"//房间公告
#import "EMO_EditUserMsgVC.h"//房间名称
#import "TZImagePickerController.h"
#import "PureCamera.h"
#import "CustomAlertViewA.h"


@interface EMO_StartPlayViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

Strong UIImageView *bgImgView;
Strong UIButton *backBtn;
Strong UIView *topView;
Strong UIImageView *headView;
Strong UILabel *headTipLabel;
Strong UIButton *headTipBtn;
Strong UIButton *nameBtn;
Strong UIButton *typeBtn;
Strong UIButton *noticeBtn;
Strong UIButton *startPlayBtn;
Strong EMO_StartRoomHostView   *roomHostView;
Strong NSMutableArray *dataArr;



@end

@implementation EMO_StartPlayViewController

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBar:YES needBack:YES needBackground:YES];
    self.barView.backgroundColor=kClearColor;
    [self bgImgView];
    [self backBtn];
    [self topView];
    [self headView];
    [self headTipLabel];
    [self headTipBtn];
    
    [self nameBtn];
    [self typeBtn];
    [self noticeBtn];
    
    [self roomHostView];
    
    [self startPlayBtn];
    
    [self addData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddTalkNotification:) name:@"RoomTypeNotification" object:nil];
 
    
}

- (UIImageView*)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.image=KGetImage(@"roombg2");
        [self.view addSubview:_bgImgView];
        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(KAdaptedWidth(0));
        }];
    }
    return _bgImgView;
}


- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"closeBackImg"] forState:UIControlStateNormal];
        _backBtn.tag=200;
        [_backBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(KAdaptedWidth(35));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.top.mas_equalTo(ZJStatusBarH);
            
            
        }];
    }
    return _backBtn;
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = RGBA(0, 0, 0, 0.12);
        [self.view addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedHeight(100));
//            make.top.mas_equalTo(KAdaptedHeight(100));
            make.top.mas_equalTo(self.backBtn.mas_bottom).offset(KAdaptedHeight(30));
            
        }];
        setViewCorner(_topView, KAdaptedHeight(10));
    }
    return _topView;
}

- (UIImageView*)headView{
    if (!_headView) {
        _headView = [[UIImageView alloc] init];
        _headView.image=KGetImage(@"未加载头像");
        [self.topView addSubview:_headView];
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(5));
            make.width.height.mas_equalTo(KAdaptedHeight(90));
            make.centerY.mas_equalTo(KAdaptedWidth(0));
        }];
        setViewCorner(_headView, KAdaptedHeight(5));
    }
    return _headView;
}

- (UILabel *)headTipLabel{
    if (!_headTipLabel) {
        _headTipLabel = [[UILabel alloc] init];
        _headTipLabel.backgroundColor=RGBA(0, 0, 0, 0.4);
        _headTipLabel.text = getLanguage(@"更换封面");
        _headTipLabel.textColor = kWhiteColor;
        _headTipLabel.font=KFontA(12);
        _headTipLabel.textAlignment=NSTextAlignmentCenter;
        [self.headView addSubview:_headTipLabel];
        [_headTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.bottom.trailing.mas_equalTo(KAdaptedWidth(0));
            make.height.mas_equalTo(KAdaptedHeight(20));
        }];
    }
    return _headTipLabel;
}


- (UIButton *)headTipBtn{
    if (!_headTipBtn) {
        _headTipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _headTipBtn.tag=300;
        [_headTipBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:_headTipBtn];
        [_headTipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headView.mas_top);
            make.leading.mas_equalTo(self.headView.mas_leading);
            make.trailing.mas_equalTo(self.headView.mas_trailing);
            make.bottom.mas_equalTo(self.headView.mas_bottom);
        }];
    }
    return _headTipBtn;
}


- (UIButton *)nameBtn{
    if (!_nameBtn) {
        _nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nameBtn setTitle:getLanguage(@"房间名称") forState:UIControlStateNormal];
        [_nameBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _nameBtn.titleLabel.font=KFontBold(14);
        [_nameBtn setImage:[UIImage imageNamed:@"editNoticeImg"] forState:UIControlStateNormal];
        _nameBtn.tag=400;
        _nameBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [_nameBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:_nameBtn];
        [_nameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headView.mas_top).offset(KAdaptedHeight(5));
            make.leading.mas_equalTo(self.headView.mas_trailing).offset(KAdaptedWidth(10));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedHeight(25));
            
        }];
        [_nameBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5];
    }
    return _nameBtn;
}


- (UIButton *)typeBtn{
    if (!_typeBtn) {
        _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_typeBtn setTitle:getLanguage(@"选择分区") forState:UIControlStateNormal];
        [_typeBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _typeBtn.titleLabel.font=KFontA(11);
        _typeBtn.layer.borderColor=kWhiteColor.CGColor;
        _typeBtn.layer.borderWidth=1;
        _typeBtn.tag=500;
        [_typeBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:_typeBtn];
        [_typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.headView.mas_centerY).offset(KAdaptedHeight(0));
            make.leading.mas_equalTo(self.nameBtn.mas_leading).offset(KAdaptedWidth(0));
            make.width.mas_equalTo(KAdaptedWidth(60));
            make.height.mas_equalTo(KAdaptedHeight(20));
            
        }];
        setViewCorner(_typeBtn, KAdaptedHeight(10));
    }
    return _typeBtn;
}





- (UIButton *)noticeBtn{
    if (!_noticeBtn) {
        _noticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_noticeBtn setTitle:getLanguage(@"公告") forState:UIControlStateNormal];
        [_noticeBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _noticeBtn.titleLabel.font=KFontBold(12);
        [_noticeBtn setImage:[UIImage imageNamed:@"noticImg"] forState:UIControlStateNormal];
        _noticeBtn.tag=600;
        _noticeBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [_noticeBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:_noticeBtn];
        [_noticeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.headView.mas_bottom).offset(KAdaptedHeight(-5));
            make.leading.mas_equalTo(self.nameBtn.mas_leading).offset(KAdaptedWidth(0));
            make.trailing.mas_equalTo(self.nameBtn.mas_trailing);
            make.height.mas_equalTo(self.nameBtn.mas_height);
            
        }];
        [_noticeBtn setImagePositionWithType:SSImagePositionTypeLeft spacing:5];
    }
    return _noticeBtn;
}





///房间人员view
- (EMO_StartRoomHostView *)roomHostView{
    if (!_roomHostView) {
        _roomHostView = [[NSBundle mainBundle] loadNibNamed:@"EMO_StartRoomHostView" owner:nil options:nil].lastObject;
        [self.view addSubview:_roomHostView];
        [_roomHostView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.topView.mas_bottom).offset(KAdaptedHeight(30));
            make.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.height.mas_equalTo(KAdaptedHeight(280));
            
            
            
        }];
    }
    return _roomHostView;
}

- (UIButton *)startPlayBtn{
    if (!_startPlayBtn) {
        _startPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0,0,kWidth-KAdaptedWidth(30),KAdaptedHeight(50));
        gl.startPoint = CGPointMake(0.5, 0);
        gl.endPoint = CGPointMake(0.5, 1);
        gl.colors = @[(__bridge id)RGBA(255, 240, 187, 1).CGColor,(__bridge id)RGBA(255, 241, 44, 1).CGColor];
        gl.locations = @[@(0.0),@(1.0f)];
        [_startPlayBtn.layer addSublayer:gl];
        _startPlayBtn.layer.cornerRadius = KAdaptedHeight(50)/2;
        _startPlayBtn.layer.masksToBounds=YES;
        [_startPlayBtn setTitle:getLanguage(@"开始直播") forState:UIControlStateNormal];
        [_startPlayBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        _startPlayBtn.titleLabel.font=KFontA(16);
        _startPlayBtn.tag=100;
        [_startPlayBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_startPlayBtn];
        [_startPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(KAdaptedHeight(50));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.bottom.mas_equalTo(KAdaptedHeight(-35));
            
        }];
    }
    return _startPlayBtn;
}

-(void)BtnClick:(UIButton *)sender{
    WeakSelf;
    switch (sender.tag) {
        case 100:{
            NSLog(@"开播");
            [self getIntoTheRoom:self.dicData passWord:@""];
//            [self getRoomInformationWithModel:self.dicData passWord:@""];
        } break;
        case 200:{
            [self.navigationController popViewControllerAnimated:YES];
        } break;
        case 300:{
            [self choosePicture];
        } break;
        case 400:{
            EMO_EditUserMsgVC *vc=[EMO_EditUserMsgVC new];
            vc.contentStr=@"";
            vc.type=3;
            vc.MsgBlock = ^(NSString * _Nonnull contentStr) {
                [wself.nameBtn setTitle:contentStr forState:UIControlStateNormal];
                [wself.nameBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5];
                [self upDataUserInfo:@{@"room_id":self.dicData[@"id"],@"name":contentStr} andtype:2];
            };
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case 500:{
            [CustomAlertViewA showAlertView_Type:AlertType_Bottom ContentType:EMO_DBCustomRoomTypeViewTag andData:@{@"data":self.dataArr}];
        } break;
        case 600:{
            EMO_RoomAnnouncementVC *vc=[EMO_RoomAnnouncementVC new];
            vc.announcementStr=@"";
            vc.announcementStrClickBlock = ^(NSString *announcementStr) {
                [wself.noticeBtn setTitle:announcementStr forState:UIControlStateNormal];
                [wself upDataUserInfo:@{@"room_id":self.dicData[@"id"],@"notice":announcementStr} andtype:3];
            };
            [self.navigationController pushViewController:vc animated:YES];
        } break;
            
        default:
            break;
    }
    
    
    
}

- (void)choosePicture {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cance = [UIAlertAction actionWithTitle:getLanguage(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    WeakSelf;
    UIAlertAction *camera = [UIAlertAction actionWithTitle:getLanguage(@"相机") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [wself addPhoto];
    }];
    UIAlertAction *album = [UIAlertAction actionWithTitle:getLanguage(@"相册") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [wself xiangce];
    }];
    
    [actionSheet addAction:cance];
    [actionSheet addAction:camera];
    [actionSheet addAction:album];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)addPhoto{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        PureCamera *homec = [[PureCamera alloc] init];
        WeakSelf;
        homec.fininshcapture = ^(UIImage *ss) {
            [wself GetToken:ss];
        };
        homec.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:homec animated:YES completion:nil];
    }
}

- (void)xiangce{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] init];
    imagePickerVc.maxImagesCount = 1;
    imagePickerVc.allowTakePicture  = NO;
    imagePickerVc.allowTakeVideo = NO;
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    imagePickerVc.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    imagePickerVc.sortAscendingByModificationDate = YES;
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.showSelectedIndex = YES;
    imagePickerVc.naviTitleColor = [UIColor blackColor];
    imagePickerVc.barItemTextColor = [UIColor blackColor];
    imagePickerVc.notScaleImage = YES;
    WeakSelf;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        for (UIImage *img in photos) {
            [wself GetToken:img];
        }
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

-(void)GetToken:(UIImage *)image{
    [NetworkRequest POST:Request_getQiNiuToken parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        if(baseModel.code==1){
            [self addavtarImg:image andToken:baseModel.data[@"qiniutoken"]];
        }
    } failture:^(NSError *error) {
        
    }];
    
}

-(void)addavtarImg:(UIImage *)image andToken:(NSString *)token{
        
    WeakSelf;
    [SVProgressHUD show];
    [NetworkRequest uploadOneImage:Request_AppUpload parameters:@{@"qiniutoken":token} image:image fileName:@"file" progress:^(NSProgress *uploadProgress) {
        
    } success:^(id responObject) {
        [SVProgressHUD dismiss];
        BaseModel *baseModel = (BaseModel *)responObject;
        wself.headView.image=image;
        [wself upDataUserInfo:@{@"room_id":wself.dicData[@"id"],@"image":[Common isNull:baseModel.data[@"fullurl"]]} andtype:1];
    } error:^(NSError *errors) {
        [SVProgressHUD dismiss];
        
    }];
    

}

-(void)upDataUserInfo:(NSDictionary *)dic andtype:(NSInteger)tag{
    
    [NetworkRequest POST:Request_EditRoomInfo parmeters:dic success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:baseModel.msg]];
    } failture:^(NSError *error) {

        
    }];
    
    
    
}


#pragma mark 通知
-(void)AddTalkNotification:(NSNotification *)content{
    NSDictionary *dic=content.userInfo;
    [self.typeBtn setTitle:dic[@"name"] forState:UIControlStateNormal];
    [self upDataUserInfo:@{@"room_id":self.dicData[@"id"],@"partition_id":dic[@"id"]} andtype:4];
    
}



-(void)addData{
    
    WeakSelf;
    [NetworkRequest POST:Request_GetRoomPartition parmeters:nil success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        [wself.dataArr addObjectsFromArray:basemodel.data];
        
    } failture:^(NSError *error) {


    }];
    
    [NetworkRequest POST:Request_GetRoomInfo parmeters:@{@"room_id":self.dicData[@"id"]} success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        NSDictionary *dic=basemodel.data[@"room_info"];
        [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"room_bg_image"]]]placeholderImage:KGetImage(@"roombg2")];
        [self.headView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"image"]]]placeholderImage:KGetImage(@"未加载头像")];
        [self.nameBtn setTitle:dic[@"name"] forState:UIControlStateNormal];
        [self.nameBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5];
        [self.typeBtn setTitle:dic[@"partition_name"] forState:UIControlStateNormal];
        [self.noticeBtn setTitle:dic[@"notice"] forState:UIControlStateNormal];
        
        
        
    } failture:^(NSError *error) {


    }];
    

    
}

#pragma  mark 进入房间前获取RTCtoken

-(void)getIntoTheRoom:(NSDictionary *)dic passWord:(NSString *)passWord{
    WeakSelf;
    
    [NetworkRequest POST:Request_Get_rtc_token parmeters:@{@"room_id":dic[@"id"]} success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        UserDefaultsSave(basemodel.data,@"ShengWangRTCToken");
        [wself getRoomInformationWithModel:dic passWord:passWord];
        
    } failture:^(NSError *error) {
        
    }];
    
    
}



#pragma mark 进入房间
- (void)getRoomInformationWithModel:(NSDictionary *)model passWord:(NSString *)passWord{
    WeakSelf;
    [NetworkRequest POST:Request_EnterRoom parmeters:passWord.length<1?@{@"room_id":model[@"id"]}:@{@"room_id":model[@"id"],@"password":passWord} success:^(id responObject) {
        BaseModel *basemolde=(BaseModel *)responObject;
        EMO_MLRoomNewVC *vc=[EMO_MLRoomNewVC new];
        
        MLRoomInformationModel *mode=[MLRoomInformationModel mj_objectWithKeyValues:basemolde.data[@"room_info"]];
        mode.microphone_position=basemolde.data[@"microphone_position"];
        NSDictionary *userDic=[NSDictionary dictionary];
        userDic=basemolde.data[@"userinfo"];
        mode.userinfo=userDic;
        mode.is_muted=[userDic[@"is_muted"] boolValue];
        mode.user_type=[Common isNullNumber:userDic[@"type"]];
            MLRoomInformationModel *model1 = [MLRoomInformationModel currentAccount];
        [model1 mj_setKeyValues:mode];
        
        [wself.navigationController pushViewController:vc animated:YES];

    } failture:^(NSError *error) {
        
    }];
}











@end
