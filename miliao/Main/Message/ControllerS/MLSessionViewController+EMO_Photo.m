//
//  MLSessionViewController+EMO_Photo.m
//  miliao
//
//  Created by jkkj on 2023/12/21.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "MLSessionViewController+EMO_Photo.h"
#import "TZImagePickerController.h"
@implementation MLSessionViewController (EMO_Photo)
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
            RCImageMessage *content = [RCImageMessage messageWithImageData:UIImageJPEGRepresentation(img, 0.4)] ;
            [self sendMessage:content pushContent:@"【图片】"];
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
    RCImageMessage *content = [RCImageMessage messageWithImageData:UIImageJPEGRepresentation(image, 0.4)] ;
    [self sendMessage:content pushContent:@"【图片】"];
}

@end
