//
//  SelectPhotoManager.m
//  SelectPhoto
//
//  Created by 吉祥 on 2017/8/29.
//  Copyright © 2017年 jixiang. All rights reserved.
//

#import "SelectPhotoManager.h"


@implementation SelectPhotoManager {
    //图片名
    NSString *_imageName;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _canEditPhoto = NO;
    }
    return self;
}

//开始选择照片
- (void)startSelectPhotoWithImageName:(NSString *)imageName{
    _imageName = imageName;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction: [UIAlertAction actionWithTitle: @"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self selectPhotoWithType:0];
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"从相册获取" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self selectPhotoWithType:1];
    }]];
    [alertController addAction:cancelAction];
    alertController.modalPresentationStyle = 0;
    [[self getCurrentVC] presentViewController:alertController animated:YES completion:nil];
}

//根据类型选取照片
- (void)startSelectPhotoWithType:(SelectPhotoType)type andImageName:(NSString *)imageName {
    _imageName = imageName;
    UIImagePickerController *ipVC = [[UIImagePickerController alloc] init];
    //设置跳转方式
    ipVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    if (_canEditPhoto) {
//        设置是否可对图片进行编辑
        ipVC.allowsEditing = YES;
    }
    
    ipVC.delegate = self;
    if (type == PhotoCamera) {
        MYLog(@"相机");
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            MYLog(@"没有摄像头");
            if (_errorHandle) {
                _errorHandle(@"没有摄像头");
            }
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的设备不支持拍照" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            }]];
            alertController.modalPresentationStyle = 0;
            [[self getCurrentVC] presentViewController:alertController animated:YES completion:nil];
            return ;
        }else{
            ipVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }else{
        MYLog(@"相册");
        ipVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    ipVC.modalPresentationStyle = 0;
    [[self getCurrentVC] presentViewController:ipVC animated:YES completion:nil];
}
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC {
    
    if (_superVC) {
        return _superVC;
    }
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
        
    }else{
        result = window.rootViewController;
    }
    return result;
}

#pragma mark 方法
-(void)selectPhotoWithType:(int)type {
    if (type == 2) {
        MYLog(@"取消");
        
    }else{
        if (@available(iOS 11, *)) {
         UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }
        UIImagePickerController *ipVC = [[UIImagePickerController alloc] init];
        //设置跳转方式
        ipVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        ipVC.modalPresentationStyle = 0;
//          ipVC.navigationBar.translucent = NO; //去除毛玻璃效果 解决导航栏遮挡相册的问题
        
        if (_canEditPhoto) {
//            设置是否可对图片进行编辑
            ipVC.allowsEditing = YES;
        }
        
        ipVC.delegate = self;
        if (type == 0) {
            MYLog(@"相机");
            BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
            if (!isCamera) {
                MYLog(@"没有摄像头");
                if (_errorHandle) {
                    _errorHandle(@"没有摄像头");
                }
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的设备不支持拍照" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                }]];
                alertController.modalPresentationStyle=0;
                [[self getCurrentVC] presentViewController:alertController animated:YES completion:nil];
                return ;
            }else{
                ipVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
        }else{
            MYLog(@"相册");
            ipVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
        }
//        [[self getCurrentVC].navigationController pushViewController:ipVC animated:YES];
        [[self getCurrentVC] presentViewController:ipVC animated:YES completion:nil];
    }
}

#pragma mark -----------------imagePickerController协议方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    YYImageClipViewController *imgCropperVC = [[YYImageClipViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f,ScreenWidth, ScreenWidth) limitScaleRatio:3.0];
    imgCropperVC.delegate = self;
    [picker pushViewController:imgCropperVC animated:NO];

//    MYLog(@"info = %@",info);
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (image == nil) {
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
    
}
#pragma mark - YYImageCropperDelegate
- (void)imageCropper:(YYImageClipViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    //图片旋转
    if (editedImage.imageOrientation != UIImageOrientationUp) {
        //图片旋转
        editedImage = [self fixOrientation:editedImage];
    }
    if (_imageName ==nil || _imageName.length == 0) {
        //获取当前时间,生成图片路径
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
        NSString *dateStr = [formatter stringFromDate:date];
        _imageName = [NSString stringWithFormat:@"photo_%@.jpg",dateStr];
    }
    
    [[self getCurrentVC] dismissViewControllerAnimated:YES completion:nil];
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectPhotoManagerDidFinishImage:)]) {
        [_delegate selectPhotoManagerDidFinishImage:editedImage];
    }
    
    if (_successHandle) {
        _successHandle(self,editedImage);
    }
}
- (void)imageCropperDidCancel:(YYImageClipViewController *)clipViewController {
    
    [[self getCurrentVC] dismissViewControllerAnimated:YES completion:nil];
    if (_delegate && [_delegate respondsToSelector:@selector(selectPhotoManagerDidError:)]) {
        [_delegate selectPhotoManagerDidError:nil];
    }
    if (_errorHandle) {
        _errorHandle(@"撤销");
    }
}

#pragma mark 图片处理方法
//图片旋转处理
- (UIImage *)fixOrientation:(UIImage *)aImage {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end

