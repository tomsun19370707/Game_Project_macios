//
//  EMO_RoomSetViewController.m
//  miliao
//
//  Created by aa on 2019/7/3.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "EMO_RoomSetViewController.h"
#import "RoomSetRoomNameCell.h"
#import "RoomSetRoomTypeCell.h"
#import "RoomSetRoomPWCell.h"
#import "RoomSetRoomIconCell.h"
#import "RoomSetRoomBgCell.h"
#import "RoomSetRoomAnnouncementCell.h"

#import "EMO_RoomAnnouncementVC.h"

#import "SelectPhotoManager.h"

#import "EMO_RoomTypeView.h"

#import "CustomAlertViewA.h"


@interface EMO_RoomSetViewController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView                       *tableView;

@property (nonatomic, strong) NSMutableDictionary                  *infoDic;
@property (nonatomic, strong) UIImagePickerController           *imagePickerController;
@property (nonatomic, strong) UIImageView                       *coverIcon;
@property (nonatomic, strong) UIImage                           *coverImage;
@property (nonatomic, strong)SelectPhotoManager *photoManager;

@property (nonatomic, strong) UIButton  *sendBtn;

Strong EMO_RoomTypeView *roomTypeView;

@end

@implementation EMO_RoomSetViewController

-(NSMutableDictionary *)infoDic{
    if(!_infoDic){
        _infoDic=[NSMutableDictionary dictionary];
    }
    return _infoDic;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(248, 248, 248, 1);
    self.bgView.backgroundColor=RGBA(248, 248, 248, 1);
    [self loadBar:YES needBack:YES needBackground:YES];
    self.leftButtonView.image = ImageNamed(@"xiaoxi_back");
    self.titleLabel.text = getLanguage(@"房间设置");
    self.titleLabel.textColor = COLOR_333333;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self getRoomInfoWithParameters];
    [self.bgView addSubview:self.tableView];
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self sendBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddTalkNotification:) name:@"RoomTypeNotification" object:nil];
    
}
#pragma mark 通知
-(void)AddTalkNotification:(NSNotification *)content{
    NSDictionary *dic=content.userInfo;
    ;
     
    RoomSetRoomTypeCell *cell = (RoomSetRoomTypeCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.typeName=dic[@"name"];
    [self.infoDic setObject:dic[@"id"] forKey:@"partition_id"];

    
}



- (void)saveBtnClick{

    if([self.infoDic.allKeys containsObject:@"backgrounds"]){
        [self.infoDic removeObjectForKey:@"backgrounds"];
    }
    
    [NetworkRequest POST:Request_EditRoomInfo parmeters:self.infoDic success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:getLanguage(@"保存成功")];
        ! self.roomSetClickBlock ?: self.roomSetClickBlock(self.infoDic);
        [self backClick];

        
    } failture:^(NSError *error) {

    }];
    
 
    
}

#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf;
    if (indexPath.row == 0) {
        RoomSetRoomTypeCell *cell = [RoomSetRoomTypeCell cellWithTableView:tableView];
        return cell;
    }else if (indexPath.row == 1){
        RoomSetRoomNameCell *cell = [RoomSetRoomNameCell cellWithTableView:tableView];
        cell.textTF = [Common isNull:self.infoDic[@"name"]];
        cell.nickNameClickBlock = ^(NSString *text) {
            [wself.infoDic setObject:text forKey:@"name"];
        };
        return cell;
    }else if(indexPath.row == 2){
        RoomSetRoomPWCell *cell = [RoomSetRoomPWCell cellWithTableView:tableView];
        cell.passwordTX = self.infoDic[@"password"];
        cell.passwordTXClickBlock = ^(NSString *passwordTX) {
            [wself.infoDic setObject:passwordTX forKey:@"password"];
        };
        return cell;
    }else if (indexPath.row == 3){
        RoomSetRoomIconCell *cell = [RoomSetRoomIconCell cellWithTableView:tableView];
        [cell.roomIcon sd_setImageWithURL:[NSURL URLWithString:self.infoDic[@"image"]]];
        self.coverIcon = cell.roomIcon;

        return cell;
    }else if (indexPath.row == 4){
        RoomSetRoomBgCell *cell = [RoomSetRoomBgCell cellWithTableView:tableView];
        cell.bgViewArray = self.infoDic[@"backgrounds"];
        cell.roomBgViewClickBlock = ^(NSDictionary *model) {
            [wself.infoDic setObject:[Common isNull:model[@"id"]] forKey:@"room_image_id"];
        };
        return cell;
    }else if (indexPath.row == 5){
        RoomSetRoomAnnouncementCell *cell = [RoomSetRoomAnnouncementCell cellWithTableView:tableView];
        cell.notice = [Common isNull:self.infoDic[@"notice"]];
        return cell;
    }
    return nil;
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
    switch (indexPath.row) {
        case 0:
            return 60;
            break;
        case 1:
//            return 60;//暂时隐藏房间类型选项
            return 60;
            break;
        case 2:
            return 60;
            break;
        case 3:
            return 60;
            break;
        case 4:
            return 176;
            break;
        case 5:
            return 60;
            break;
        case 6:
            return 150;
            break;
        default:
            break;
    }
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf;
    switch (indexPath.row) {
        case 0:{
            [NetworkRequest POST:Request_GetRoomPartition parmeters:nil success:^(id responObject) {
                BaseModel *basemodel=(BaseModel *)responObject;
                [CustomAlertViewA showAlertView_Type:AlertType_Bottom ContentType:EMO_DBCustomRoomTypeViewTag andData:@{@"data":basemodel.data}];
            } failture:^(NSError *error) {


            }];

        }break;
        case 3:{
            
            [self.photoManager startSelectPhotoWithImageName:@"headerImage"];
            self.photoManager.successHandle=^(SelectPhotoManager *manager,UIImage *image){
//                wself.coverIcon.image = image;
//                wself.coverImage =image;
                [wself GetToken:image];
            };
        }

            break;
        case 5:{
            EMO_RoomAnnouncementVC *VC = [[EMO_RoomAnnouncementVC alloc] init];
            VC.announcementStr = self.infoDic[@"notice"];
            VC.announcementStrClickBlock = ^(NSString *announcementStr) {
                [self.infoDic setObject:announcementStr forKey:@"notice"];
                RoomSetRoomAnnouncementCell *cell = (RoomSetRoomAnnouncementCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
                cell.notice=announcementStr;
                
            };
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

-(SelectPhotoManager *)photoManager
{
    if (!_photoManager) {
        _photoManager = [[SelectPhotoManager alloc]init];
    }
    return _photoManager;
}
#pragma mark -- 修改头像弹出提示框
-(void)alterHeadPortrait{
    
    UIAlertController * alert = [ UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:getLanguage(@"从相册选择") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectImageFromAlbum];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:getLanguage(@"拍照") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectImageFromCamera];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:getLanguage(@"取消") style:UIAlertActionStyleDefault handler:nil]];
    alert.modalPresentationStyle = 0;
    [self presentViewController:alert animated:YES completion:nil];
    
}


#pragma mark -- 修改头像
#pragma mark 从摄像头获取图片或视频
- (void)selectImageFromCamera {
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    _imagePickerController.modalPresentationStyle = 0;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}
#pragma mark 从相册获取图片或视频
- (void)selectImageFromAlbum {
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePickerController.modalPresentationStyle = 0;
    [self presentViewController:_imagePickerController animated:YES completion:nil];

}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark UIImagePickerControllerDelegate
//该代理方法仅适用于只选取图片时
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
 
    [self GetToken:image];
    [self dismissViewControllerAnimated:YES completion:nil];
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
        
        self.coverIcon.image = image;
        self.coverImage = image;
        
//        EMO_EditUserMsgTableViewCell *cellA = (EMO_EditUserMsgTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//        cellA.headImgView.image=image;

        [self.infoDic setObject:[Common isNull:baseModel.data[@"fullurl"]] forKey:@"image"];
        
    } error:^(NSError *errors) {
        [SVProgressHUD dismiss];
        
    }];
    

}




#pragma mark  获取房间设置
- (void)getRoomInfoWithParameters{
    
    [self.infoDic setObject:[Common isNull:[MLRoomInformationModel currentAccount].room_id] forKey:@"room_id"];
    [self.infoDic setObject:[Common isNull:[MLRoomInformationModel currentAccount].partition_id] forKey:@"partition_id"];
    [self.infoDic setObject:[Common isNull:[MLRoomInformationModel currentAccount].room_pass] forKey:@"password"];
    [self.infoDic setObject:[Common isNull:[MLRoomInformationModel currentAccount].name] forKey:@"name"];
    [self.infoDic setObject:[Common isNull:[MLRoomInformationModel currentAccount].notice] forKey:@"notice"];
    [self.infoDic setObject:[Common isNull:[MLRoomInformationModel currentAccount].room_image_id] forKey:@"room_image_id"];
    [self.infoDic setObject:[Common isNull:[MLRoomInformationModel currentAccount].image] forKey:@"image"];
    
    
    
    
//    房间背景图
    [NetworkRequest POST:Request_GetRoomImage parmeters:@{@"room_id":[MLRoomInformationModel currentAccount].room_id} success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;

        [self.infoDic setObject:basemodel.data forKey:@"backgrounds"];
        [self.tableView reloadData];
    } failture:^(NSError *error) {
        
    }];
    

    
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.barView.bottom + 10, ScreenViewWidth, ScreenViewHeight - self.barView.bottom - 20 - 60-60) style:UITableViewStyleGrouped];
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


- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.frame=CGRectMake(KAdaptedWidth(27.5), kHeight-KAdaptedHeight(36+50)-KSAFEAREA_BOTTOM_HEIHGHT, kWidth-KAdaptedWidth(55), KAdaptedHeight(45));
        
        _sendBtn.backgroundColor = BaseMainColor ;
        [_sendBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_sendBtn makeRoundCorner];
        
        [_sendBtn setTitle:getLanguage(@"完成") forState:UIControlStateNormal];
        _sendBtn.titleLabel.font=KFont(15);
        [_sendBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_sendBtn];

    }
    return _sendBtn;
}
- (EMO_RoomTypeView *)roomTypeView{
    if (!_roomTypeView) {
        _roomTypeView = [[EMO_RoomTypeView alloc] init];
        _roomTypeView.BtnClick = ^(NSInteger senderTag, NSInteger type) {
            [SVProgressHUD showImage:KGetImage(@"") status:[NSString stringWithFormat:@"%ld==%ld",senderTag,type]];
            
            
            
        };
    }
    return _roomTypeView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
