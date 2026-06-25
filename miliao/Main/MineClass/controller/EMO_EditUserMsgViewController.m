//
//  EMO_EditUserMsgViewController.m
//  miliao
//
//  Created by 张世浩 on 2022/10/13.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_EditUserMsgViewController.h"
#import "EMO_EditUserMsgTableViewCell.h"
#import "TZImagePickerController.h"
#import "PureCamera.h"
#import "RoomSetRoomIconCell.h"

#import "EMO_EditUserMsgVC.h"//个人资料编辑

@interface EMO_EditUserMsgViewController ()<UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableDictionary * dicData;
@property (nonatomic, strong) NSString *imageString;

Assign NSInteger type;
@end

@implementation EMO_EditUserMsgViewController
-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}

-(NSMutableDictionary *)dicData{
    if (!_dicData) {
        _dicData=[NSMutableDictionary dictionary];
    }
    return _dicData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBar:YES needBack:YES needBackground:YES];
    self.titleLabel.text=getLanguage(@"个人资料");
    self.titleLabel.font=KFont(18);
//    [self.rightButton setTitle:getLanguage(@"保存") forState:UIControlStateNormal];
//    [self.rightButton setTitleColor:RGBA(34, 34, 34, 1) forState:UIControlStateNormal];
//    self.rightButton.titleLabel.font=KFont(13);
//    self.rightButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    self.type=0;
    self.view.backgroundColor=RGBA(248, 248, 248, 1);
    NSString *sex=[NSString stringWithFormat:@"%@",[[UserManager userInfo].sex integerValue]==1?getLanguage(@"男"):getLanguage(@"女")];

    
    self.dataArr=[NSMutableArray arrayWithArray:@[
                  @{@"data":[Common isNull:[UserManager userInfo].avatar],@"name":getLanguage(@"头像"),@"change":@"0"},
//                  @{@"data":[Common isNull:[UserManager userInfo].cover_image],@"name":getLanguage(@"背景"),@"change":@"0"},
                  @{@"data":[Common isNull:[UserManager userInfo].nickname],@"name":getLanguage(@"昵称"),@"change":@"1"},
                  @{@"data":[Common isNull:[UserManager userInfo].uuid],@"name":getLanguage(@"ID"),@"change":@"1"},
                  @{@"data":sex,@"name":getLanguage(@"性别"),@"change":@"1"},
                  @{@"data":[Common isNull:[UserManager userInfo].birthday],@"name":getLanguage(@"年龄"),@"change":@"1"},
                  @{@"data":[Common isNull:[UserManager userInfo].constellation],@"name":getLanguage(@"星座"),@"change":@"1"},
                  @{@"data":[Common isNull:[UserManager userInfo].bio],@"name":getLanguage(@"个人签名"),@"change":@"1"}]];
    
    [self.dicData setObject:[UserManager userInfo].sex forKey:@"sex"];
    [self.dicData setObject:[Common isNull:[UserManager userInfo].nickname] forKey:@"nickname"];
    [self.dicData setObject:[Common isNull:[UserManager userInfo].birthday] forKey:@"birthday"];
    [self.dicData setObject:[Common isNull:[UserManager userInfo].bio] forKey:@"bio"];
    
    
    
    
    [self tableView];
    
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
        _tableView.rowHeight=KAdaptedHeight(55);
//        _tableView.tableHeaderView=self.headView;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ZJTopNavH+ZJStatusBarH+1);
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0||indexPath.row==1){
        return KAdaptedHeight(65);
    }else{
        return KAdaptedHeight(55);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if(indexPath.row==0){
//        RoomSetRoomIconCell *cell = [RoomSetRoomIconCell cellWithTableView:tableView];
//        [cell.roomIcon sd_setImageWithURL:[NSURL URLWithString:@"https://img0.baidu.com/it/u=3834908638,635499117&fm=253&fmt=auto&app=120&f=JPEG?w=1422&h=800"]];
//
//        return cell;
//    }else{
        EMO_EditUserMsgTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell=[[EMO_EditUserMsgTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        }
        cell.dicData = self.dataArr[indexPath.row];
        cell.selectionStyle=0;
        return cell;
//    }
    
   
}


#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    if(indexPath.row==0){
        self.type=indexPath.row;
        [self choosePicture];
    }else{
        
        EMO_EditUserMsgTableViewCell *cell = (EMO_EditUserMsgTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        switch (indexPath.row) {
            case 1:{
                EMO_EditUserMsgVC *vc=[EMO_EditUserMsgVC new];
                vc.contentStr=self.dataArr[indexPath.row][@"data"];
                vc.type=1;
                vc.MsgBlock = ^(NSString * _Nonnull contentStr) {
                    cell.changeStr = contentStr;
//                    [wself.dicData setObject:contentStr forKey:@"nickname"];
                    [self upDataUserInfo:@{@"nickname":contentStr}];
                };
                [self.navigationController pushViewController:vc animated:YES];
                return;
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@" " message:getLanguage(@"请输入昵称") preferredStyle:UIAlertControllerStyleAlert];
                //增加取消按钮；
                [alertController addAction:[UIAlertAction actionWithTitle:getLanguage(@"取消") style:UIAlertActionStyleDefault handler:nil]];
                //增加确定按钮；
                [alertController addAction:[UIAlertAction actionWithTitle:getLanguage(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                  //获取第1个输入框；
                  UITextField *userNameTextField = alertController.textFields.firstObject;
                    
                    if (userNameTextField.text.length>0) {
                        cell.changeStr = userNameTextField.text;
                        [self upDataUserInfo:@{@"nickname":userNameTextField.text}];
//                        [self.dicData setObject:userNameTextField.text forKey:@"nickname"];
              
                    }else{
                        [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"昵称不能为空")];
                    }
                }]];
                
                //定义第一个输入框；
                [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = getLanguage(@"请输入昵称");
                }];
                [self presentViewController:alertController animated:true completion:nil];
                
                
            }break;
            case 3:{
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:getLanguage(@"请选择性别") message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
                [alert addAction:[UIAlertAction actionWithTitle:getLanguage(@"取消") style:UIAlertActionStyleCancel handler:nil]];
                [alert addAction:[UIAlertAction actionWithTitle:getLanguage(@"男") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    cell.changeStr=getLanguage(@"男");
//                    [self.dicData setObject:@"1" forKey:@"sex"];
                    [self upDataUserInfo:@{@"sex":@"1"}];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:getLanguage(@"女") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    cell.changeStr=getLanguage(@"女");
//                    [self.dicData setObject:@"2" forKey:@"sex"];
                    [self upDataUserInfo:@{@"sex":@"2"}];
    
                }]];
    
                [self presentViewController:alert animated:YES completion:nil];
                
            }break;
            case 4:{

                //    // 1.创建日期选择器
                BRDatePickerView * _datePickerView = [[BRDatePickerView alloc]init];
                    // 2.设置属性
                _datePickerView.pickerMode = BRDatePickerModeYMD;
                _datePickerView.title = getLanguage(@"时间选择");
                _datePickerView.selectDate = [NSDate date];
                _datePickerView.maxDate = [NSDate date];
                _datePickerView.minDate = [NSDate br_setYear:1970 month:01 day:01];
                _datePickerView.isAutoSelect = NO;
                _datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
                        NSLog(@"选择的值：%@", selectValue);
                    cell.changeStr=selectValue;
                    [wself upDataUserInfo:@{@"birthday":selectValue}];
                    
                    };
                    // 设置自定义样式
                    BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
                customStyle.pickerColor = kWhiteColor;
                customStyle.pickerTextColor = RGBA(34, 34, 34, 1);
                customStyle.separatorColor = RGBA(232, 232, 232, 1);
                customStyle.paddingBottom=KAdaptedHeight(-30);
                customStyle.titleBarColor=kWhiteColor;
                customStyle.titleTextColor=RGBA(34, 34, 34, 1);
                customStyle.cancelTextColor=RGBA(34, 34, 34, 1);
                customStyle.doneTextColor=RGBA(34, 34, 34, 1);
                customStyle.cancelBtnTitle=getLanguage(@"取消");
                customStyle.doneBtnTitle=getLanguage(@"确定");
                _datePickerView.pickerStyle = customStyle;
                [_datePickerView show];
 
            }break;
            case 5:{
               
            }break;

            case 6:{
                
                EMO_EditUserMsgVC *vc=[EMO_EditUserMsgVC new];
                vc.contentStr=self.dataArr[indexPath.row][@"data"];
                vc.type=2;
                vc.MsgBlock = ^(NSString * _Nonnull contentStr) {
                    cell.changeStr = contentStr;
                    [self upDataUserInfo:@{@"bio":contentStr}];
//                    [wself.dicData setObject:contentStr forKey:@"bio"];
                };
                [self.navigationController pushViewController:vc animated:YES];
                return;
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:getLanguage(@"请输入个人签名") preferredStyle:UIAlertControllerStyleAlert];
                //增加取消按钮；
                [alertController addAction:[UIAlertAction actionWithTitle:getLanguage(@"取消") style:UIAlertActionStyleDefault handler:nil]];
                //增加确定按钮；
                [alertController addAction:[UIAlertAction actionWithTitle:getLanguage(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                  //获取第1个输入框；
                  UITextField *userNameTextField = alertController.textFields.firstObject;
                    if (userNameTextField.text.length>0) {
                        cell.changeStr = userNameTextField.text;
                        [self upDataUserInfo:@{@"bio":userNameTextField.text}];
//                        [self.dicData setObject:userNameTextField.text forKey:@"bio"];
                        
                    }else{
                        [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"个人签名不能为空")];
                    }
                }]];
                
                //定义第一个输入框；
                [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = getLanguage(@"请输入个人签名");
                }];
                [self presentViewController:alertController animated:true completion:nil];

            }break;
                
            default:
                break;
        }
        
    }
    
}




-(void)tapView:(UITapGestureRecognizer *)tap{
    [self choosePicture];
}

- (void)rightButtonClick:(UIButton *)sender{
    
  
//    if (![self.dicData.allKeys containsObject:@"nickname"]) {
//        [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"您还未设置昵称,请先设置昵称")];
//        return;
//    }
//
//    if (![self.dicData.allKeys containsObject:@"birthday"]) {
//        [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"请先设置出生日期")];
//        return;
//    }
//
//[self.dicData setObject:[UserManager userInfo].sex forKey:@"sex"];
    
    
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
            [self GetToken:ss];
//            EMO_EditUserMsgTableViewCell *cellA = (EMO_EditUserMsgTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//            cellA.headImgView.image=ss;
//            wself.imageString= @"";
//                NSData *imageData = UIImageJPEGRepresentation(ss, 0.7);
//                NSString *imageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//            wself.imageString = NSStringFormat(@"data:image/jpg;base64,%@",imageStr);
//            [wself.dicData setObject:wself.imageString forKey:@"img"];
            
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
            [self GetToken:img];
//            EMO_EditUserMsgTableViewCell *cellA = (EMO_EditUserMsgTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//            cellA.headImgView.image=img;
//            wself.imageString= @"";
//                NSData *imageData = UIImageJPEGRepresentation(img, 0.7);
//                NSString *imageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//            wself.imageString = NSStringFormat(@"data:image/jpg;base64,%@",imageStr);
//            [wself.dicData setObject:wself.imageString forKey:@"img"];
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
        EMO_EditUserMsgTableViewCell *cellA = (EMO_EditUserMsgTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.type inSection:0]];
        cellA.headImgView.image=image;
//        wself.imageString = NSStringFormat(@"%@",baseModel.data[@"fullurl"]);
//        [wself.dicData setObject:wself.imageString forKey:@"avatar"];
        if(self.type==0){
            [wself upDataUserInfo:@{@"avatar":[Common isNull:baseModel.data[@"fullurl"]]}];
        }else{
            [wself upDataUserInfo:@{@"cover_image":[Common isNull:baseModel.data[@"fullurl"]]}];
        }
        
        
    } error:^(NSError *errors) {
        [SVProgressHUD dismiss];
        
    }];
    

}



-(void)upDataUserInfo:(NSDictionary *)dic{
    
//    [SVProgressHUD show];
    [NetworkRequest POST:Request_ChangeUserInfo parmeters:dic success:^(id responObject) {
//        [SVProgressHUD dismiss];
        BaseModel *baseModel = (BaseModel *)responObject;
        [UserManager saveUserInfo:baseModel.data];
        if([dic.allKeys containsObject:@"birthday"]){
            EMO_EditUserMsgTableViewCell *cellA = (EMO_EditUserMsgTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
            cellA.changeStr=[NSString stringWithFormat:@"%@",[UserManager userInfo].constellation];
        }
    } failture:^(NSError *error) {
//        [SVProgressHUD dismiss];
    }];
}
@end
