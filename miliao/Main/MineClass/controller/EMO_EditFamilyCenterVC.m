//
//  EMO_EditFamilyCenterVC.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/4.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_EditFamilyCenterVC.h"
#import "EMO_EditUserMsgTableViewCell.h"
#import "TZImagePickerController.h"
#import "PureCamera.h"

@interface EMO_EditFamilyCenterVC ()<UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSString *imageString;

Strong NSMutableDictionary *changeDic;
Assign BOOL change;
@end

@implementation EMO_EditFamilyCenterVC
-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableDictionary *)changeDic{
    if(!_changeDic){
        _changeDic=[NSMutableDictionary dictionary];
    }
    return _changeDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBar:YES needBack:YES needBackground:YES];
    self.titleLabel.text=getLanguage(@"公会资料");
    self.titleLabel.font=KFont(18);
    self.view.backgroundColor=RGBA(248, 248, 248, 1);
    self.change=NO;
    self.dataArr=[NSMutableArray arrayWithArray:@[@{@"data":self.dicData[@"image"],@"name":getLanguage(@"头像"),@"change":@"0"},@{@"data":self.dicData[@"name"],@"name":getLanguage(@"昵称"),@"change":@"1"}]];
    self.changeDic=[NSMutableDictionary dictionaryWithDictionary:self.dicData];
    [self tableView];
    
}

-(void)backClick{
    if(self.change){
        if(self.changeBlock){
            self.changeBlock(self.changeDic);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
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
    if(indexPath.row==0){
        return KAdaptedHeight(65);
    }else{
        return KAdaptedHeight(55);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        EMO_EditUserMsgTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell=[[EMO_EditUserMsgTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        }
        cell.dicData = self.dataArr[indexPath.row];
        return cell;

}


#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    if(indexPath.row==0){
        [self choosePicture];
    }else{
        
       
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:getLanguage(@"请输入公会昵称") preferredStyle:UIAlertControllerStyleAlert];
            //增加取消按钮；
            [alertController addAction:[UIAlertAction actionWithTitle:getLanguage(@"取消") style:UIAlertActionStyleDefault handler:nil]];
            //增加确定按钮；
            [alertController addAction:[UIAlertAction actionWithTitle:getLanguage(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
              //获取第1个输入框；
              UITextField *userNameTextField = alertController.textFields.firstObject;
                if (userNameTextField.text.length>0) {
                    
                    [wself upDataUserInfo:@{@"family_id":self.dicData[@"id"],@"name":userNameTextField.text}];
          
                }else{
                    [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"昵称不能为空")];
                }
            }]];
            
            //定义第一个输入框；
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = getLanguage(@"请输入公会昵称");
            }];
            [self presentViewController:alertController animated:true completion:nil];

    }
    
}




-(void)tapView:(UITapGestureRecognizer *)tap{
    [self choosePicture];
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
        EMO_EditUserMsgTableViewCell *cellA = (EMO_EditUserMsgTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cellA.headImgView.image=image;
        [wself upDataUserInfo:@{@"image":[Common isNull:baseModel.data[@"fullurl"]],@"family_id":self.dicData[@"id"]}];
        
    } error:^(NSError *errors) {
        [SVProgressHUD dismiss];
        
    }];
    

}



-(void)upDataUserInfo:(NSDictionary *)dic{
    
    [SVProgressHUD show];
    [NetworkRequest POST:Request_EditFamily parmeters:dic success:^(id responObject) {
        [SVProgressHUD dismiss];
        BaseModel *baseModel = (BaseModel *)responObject;
        [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:baseModel.msg]];
        self.change=YES;
        if([dic.allKeys containsObject:@"name"]){
            EMO_EditUserMsgTableViewCell *cell = (EMO_EditUserMsgTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            cell.changeStr = dic[@"name"];
            [self.changeDic setObject:dic[@"name"] forKey:@"name"];
            
        }else{
            [self.changeDic setObject:dic[@"image"] forKey:@"image"];
        }
        
        
    } failture:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
    
    
}









@end
