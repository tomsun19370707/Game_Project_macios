//
//  EMO_RenZhengViewController+Photo.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/5.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_RenZhengViewController+Photo.h"
#import "TZImagePickerController.h"

@implementation EMO_RenZhengViewController (Photo)
- (void)choosePicture {
    [self.view endEditing:YES];
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil
                                                                         message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cance = [UIAlertAction actionWithTitle:getLanguage(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    WeakSelf(wself);
    UIAlertAction *camera = [UIAlertAction actionWithTitle:getLanguage(@"拍一张") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [wself paizhao];
    }];
    UIAlertAction *album = [UIAlertAction actionWithTitle:getLanguage(@"从相册选择") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [wself xiangce];
    }];
    
    [actionSheet addAction:cance];
    [actionSheet addAction:camera];
    [actionSheet addAction:album];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)paizhao
{
    WeakSelf;
    ImagePicker_Camera(YES);
}

- (void)xiangce{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] init];
    imagePickerVc.preferredLanguage = [DAConfig userLanguage];
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
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        for (UIImage *img in photos) {
//            [self requestPhoto:img];
            [self getToken:img];
        }
    }];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
#pragma -mark
#pragma -mark fix UIIMagePickerController bug
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType ==     UIImagePickerControllerSourceTypePhotoLibrary) {
    }
}
//每次请求都需要传文件大小（[imageData length]）
#pragma -mark
#pragma -mark choose image to upload
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    //    [self requestPhoto:image];
    [self getToken:image];
    
}


-(void)getToken:(UIImage *)image{
    [NetworkRequest POST:Request_getQiNiuToken parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        if(baseModel.code==1){
            [self requestPhoto:image andToken:baseModel.data[@"qiniutoken"]];
        }
    } failture:^(NSError *error) {
        
    }];
    
    
}


- (void)requestPhoto:(UIImage *)img andToken:(NSString *)token{
    
    
    
//    if (self.Picturetype == 100) {
//        self.carViewZMStr = @"https://img1.baidu.com/it/u=2555904807,2390319494&fm=253&fmt=auto&app=138&f=JPEG?w=333&h=500";
//        self.carView.ZMStr  = @"https://img1.baidu.com/it/u=2555904807,2390319494&fm=253&fmt=auto&app=138&f=JPEG?w=333&h=500";
//    }else{
//        self.carViewFMStr = @"https://img1.baidu.com/it/u=640593135,209279600&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500";
//        self.carView.FMStr = @"https://img1.baidu.com/it/u=640593135,209279600&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500";
//    }
    
    
    WeakSelf;
    [SVProgressHUD showWithStatus:getLanguage(@"上传中")];
    [NetworkRequest uploadOneImage:Request_AppUpload parameters:@{@"qiniutoken":token} image:img fileName:@"file" progress:^(NSProgress *uploadProgress) {

    } success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        [SVProgressHUD dismiss];
        [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"上传成功")];
        NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:baseModel.data];
        if (wself.Picturetype == 100) {
//            wself.carViewZMStr = [Common isNull:dic[@"url"]];
            wself.carViewZMStr = [Common isNull:dic[@"fullurl"]];
            wself.carView.ZMStr = [Common isNull:dic[@"fullurl"]];
        }else{
//            wself.carViewFMStr = [Common isNull:dic[@"url"]];
            wself.carViewFMStr = [Common isNull:dic[@"fullurl"]];
            wself.carView.FMStr = [Common isNull:dic[@"fullurl"]];
        }

    } error:^(NSError *errors) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"上传失败")];

    }];
    
    
    
    
}





@end
