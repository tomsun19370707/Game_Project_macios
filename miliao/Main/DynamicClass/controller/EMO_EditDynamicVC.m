//
//  EMO_EditDynamicVC.m
//  miliao
//
//  Created by ZhangShiHao on 2023/8/17.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_EditDynamicVC.h"
#import "TZImagePickerController.h"
#import "UIView+TZLayout.h"
#import "TZTestCell.h"
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"
#import "TZLocationManager.h"
#import "TZAssetCell.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "FLAnimatedImage.h"
#import "TZImageUploadOperation.h"
#import "TZVideoEditedPreviewController.h"
#import <CoreLocation/CoreLocation.h>
#import "EMO_AddTalkView.h"//话题视图
#import "MessageInfoModel.h"
@interface EMO_EditDynamicVC ()
<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,CLLocationManagerDelegate>

{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    BOOL _isAllowEditVideo;
    
    CGFloat _itemWH;
    CGFloat _margin;
}
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) UILabel *numLabel;
@property (nonatomic,strong) UIButton *sendBtn;
@property (nonatomic,strong) EMO_AddTalkView *talkView;
@property (nonatomic,strong) NSMutableDictionary *dataDic;
@property (nonatomic,strong) NSMutableArray *imgUrlArr;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) LxGridViewFlowLayout *layout;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@property (nonatomic,assign) BOOL showTakePhotoBtnSwitch; //允许拍照
@property (nonatomic,assign) BOOL showTakeVideoBtnSwitch; //允许拍视频
@property (nonatomic,assign) BOOL sortAscendingSwitch;  //照片排列按修改时间升序
@property (nonatomic,assign) BOOL allowPickingVideoSwitch;//允许选择视频
@property (nonatomic,assign) BOOL allowPickingImageSwitch;//允许选择图片
@property (nonatomic,assign) BOOL allowPickingGifSwitch;//允许选择gif图片
@property (nonatomic,assign) BOOL allowPickingOriginalPhotoSwitch;//允许选择照片原图
@property (nonatomic,assign) BOOL showSheetSwitch;//显示一个sheet,把拍照/拍视频按钮放在外面
@property (nonatomic,assign) BOOL allowCropSwitch;//单选模式允许剪裁
@property (nonatomic,assign) BOOL needCircleCropSwitch;//使用圆形剪裁框
@property (nonatomic,assign) BOOL allowPickingMuitlpleVideoSwitch;//允许多选图片、视频、gif
@property (nonatomic,assign) BOOL showSelectedIndexSwitch;//右上角显示选中序号
@property (nonatomic,strong) NSURL  *filePathURL;//视频路径
@property (nonatomic,assign) BOOL  selecVideo;//选择的是否是视频

Strong NSString *qiNiuToken;

#define MaxCount  9  //最多显示几张 为1时为单选
#define ColumnNum  3  // 每行显示几张


@end

@implementation EMO_EditDynamicVC

- (void)locatemap{
    
    if ([CLLocationManager locationServicesEnabled]) {
        CLLocationManager *locationManager = [[CLLocationManager alloc]init];
        locationManager.delegate = self;
        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 5.0;
        [locationManager startUpdatingLocation];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self locatemap];
//    {
//      "id" : 1,
//      "topic" : "# 灌篮高手"
//    },
    self.view.backgroundColor=kWhiteColor;
    [self loadBar:YES needBack:YES needBackground:YES];
    self.leftButtonView.image = KGetImage(@"xiaoxi_back");
    self.titleLabel.text = @"发布动态";
    [self getToken];
    [self sendBtn];
    [self textView];
    self.showTakePhotoBtnSwitch=YES;
    self.showTakeVideoBtnSwitch=NO;//不允许拍视频
    self.sortAscendingSwitch=YES;
    self.allowPickingVideoSwitch=NO;//不允许选择视频
    self.allowPickingImageSwitch=YES;
    self.allowPickingGifSwitch=NO;
    self.allowPickingOriginalPhotoSwitch=YES;
    self.showSheetSwitch=YES;
    self.allowCropSwitch=NO;
    self.needCircleCropSwitch=NO;
    self.allowPickingMuitlpleVideoSwitch=NO;
    self.showSelectedIndexSwitch=YES;
    
    [self.dataDic setObject:self.model.topic_id forKey:@"topic_id"];
    
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    
    if ([NSString NotNull:self.model.images]) {
        for (int i=0; i<self.model.image_arr.count; i++) {
            [_selectedPhotos addObject:self.model.image_arr[i]];
    //        UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.image_arr[i]]]];
    //        [_selectedPhotos addObject:image];
    //        UIImage *image11 =KGetImage(@"gameBgImg");
    //        [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
    //            PHAssetChangeRequest *request =[PHAssetChangeRequest creationRequestForAssetFromImage:image11];
    //            NSString *locallndentifier =request.placeholderForCreatedAsset.localIdentifier;
    //
    //            PHFetchResult *assetResult =[PHAsset fetchAssetsWithLocalIdentifiers:@[locallndentifier] options:nil];
    //            PHAsset *asset=assetResult.firstObject;
    //            [self->_selectedAssets addObject:asset];
    //        } error:nil];

        }
    }
    
    [self configCollectionView];

    
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

-(NSMutableDictionary *)dataDic{
    if (!_dataDic) {
        _dataDic=[NSMutableDictionary dictionary];
    }
    return _dataDic;
}
-(NSMutableArray *)imgUrlArr{
    if (!_imgUrlArr) {
        _imgUrlArr=[NSMutableArray array];
    }
    return _imgUrlArr;
}

-(UITextView *)textView{
    if (!_textView) {
        _textView=[[UITextView alloc] init];
            _textView.text=[Common isNull:self.model.content];
        _textView.textContainer.lineFragmentPadding = 3;
        _textView.delegate= self;
        _textView.font=KFont(14);
        _textView.backgroundColor=RGBA(255, 255, 255, 1);
        if([_textView.text isEqualToString:getLanguage(@"  开心Share一下你的动态啊~")]){
            _textView.textColor=RGBA(153, 153, 153, 1);
        }else{
            _textView.textColor=kBlackColor;
        }
        _textView.layer.cornerRadius=KAdaptedHeight(10);
        _textView.layer.masksToBounds=YES;
        [self.view addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedWidth(10)+ZJTopNavH+ZJStatusBarH);
            make.leading.mas_equalTo(KAdaptedWidth(14));
            make.trailing.mas_equalTo(KAdaptedWidth(-14));
            make.height.mas_equalTo(KAdaptedHeight(130));
        }];
    }
    return _textView;
}

- (UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.text = @"0/200";
        _numLabel.font=KFont(14);
        _numLabel.textAlignment=NSTextAlignmentRight;
        _numLabel.textColor = RGBA(102, 102, 102, 1);
        [self.view addSubview:_numLabel];
        [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.textView.mas_bottom).offset(KAdaptedHeight(-10));
            make.trailing.mas_equalTo(self.textView.mas_trailing).offset(KAdaptedWidth(-15));
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(100), KAdaptedHeight(25)));
        }];
    }
    return _numLabel;
}


- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0,0,KAdaptedWidth(55),KAdaptedHeight(25));
        gl.startPoint = CGPointMake(0.5, 0);
        gl.endPoint = CGPointMake(0.5, 1);
        gl.colors = @[(__bridge id)RGBA(247, 212, 91, 0.59).CGColor,(__bridge id)RGBA(255, 238, 1, 1).CGColor];
        gl.locations = @[@(0.0),@(1.0f)];
        [_sendBtn.layer addSublayer:gl];
        _sendBtn.layer.cornerRadius = KAdaptedHeight(25)/2;
        _sendBtn.layer.masksToBounds=YES;
        [_sendBtn setTitle:getLanguage(@"发布") forState:UIControlStateNormal];
        [_sendBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        _sendBtn.titleLabel.font=KFontA(13);
        _sendBtn.tag=100;
        [_sendBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_sendBtn];
        [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(55), KAdaptedHeight(25)));
            make.trailing.mas_equalTo(KAdaptedWidth(-14));
            make.bottom.mas_equalTo(self.barView.mas_bottom).offset(KAdaptedHeight(-5));
            
        }];
    }
    return _sendBtn;
}



#pragma mark 寄出
-(void)BtnClick:(UIButton *)sender{
    [self.view endEditing:YES];
    if (sender.tag==100) {
        if (self.selecVideo) {
            [self sendData];
        }else{
            if (_selectedAssets.count>0) {
                [self upPictures:1];
            }else{
                [self sendData];
            }
            
        }
        
    }
    else{
        BOOL showSheet = self.showSheetSwitch;
        if (showSheet) {
            NSString *takePhotoTitle = @"拍照";
            if (self.showTakeVideoBtnSwitch && self.showTakePhotoBtnSwitch) {
                takePhotoTitle = @"相机";
            } else if (self.showTakeVideoBtnSwitch) {
                takePhotoTitle = @"拍摄";
            }
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:takePhotoTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self takePhoto];
            }];
            [alertVc addAction:takePhotoAction];
            UIAlertAction *imagePickerAction = [UIAlertAction actionWithTitle:@"去相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self pushTZImagePickerController];
            }];
            [alertVc addAction:imagePickerAction];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertVc addAction:cancelAction];
          
            [self presentViewController:alertVc animated:YES completion:nil];
        } else {
            [self pushTZImagePickerController];
        }
        
    }
    
}

-(void)getToken{
    
    [NetworkRequest POST:Request_getQiNiuToken parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        if(baseModel.code==1){
            self.qiNiuToken=[Common isNull:baseModel.data[@"qiniutoken"]];
        }
    } failture:^(NSError *error) {
        
    }];
    
}



#pragma mark 上传图片
-(void)upPictures:(NSInteger)index{
    
    if(self.qiNiuToken.length<1){
        [self getToken];
    }
    
    WeakSelf;
    if (index==2) {
        [SVProgressHUD showWithStatus:@"处理中..."];
        [NetworkRequest uploadOneVideo:Request_AppUpload parameters:@{@"qiniutoken":self.qiNiuToken} path:self.filePathURL fileName:@"file" progress:^(NSProgress *uploadProgress) {
            
        } success:^(id responObject) {
            NSLog(@"%@",responObject);
            if ([responObject[@"code"] integerValue]==1) {
                [self.dataDic setObject:[NSString stringWithFormat:@"%@",responObject[@"data"][@"url"]] forKey:@"imgs"];
            }
            [SVProgressHUD dismiss];
            

        } error:^(NSError *errors) {
            [SVProgressHUD dismiss];
        }];

        return;
    }
    
    [self.imgUrlArr removeAllObjects];
    
    [SVProgressHUD showWithStatus:@"上传中..."];
    
    for (PHAsset *image in _selectedAssets) {

          [[PHImageManager defaultManager] requestImageDataForAsset:image options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
//         NSURL *url = [info valueForKey:@"PHImageFileURLKey"];
//         NSString *str = [url absoluteString];   //url>string
//         NSArray *arr = [str componentsSeparatedByString:@"/"];
//         NSString *imgName = [arr lastObject];  // 图片名字
//         NSInteger length = imageData.length;   // 图片大小，单位B
            UIImage * image = [UIImage imageWithData:imageData];

              [NetworkRequest uploadOneImage:Request_AppUpload parameters:@{@"qiniutoken":self.qiNiuToken} image:image fileName:@"file" progress:^(NSProgress *uploadProgress) {

              } success:^(id responObject) {
                  BaseModel *baseModel = (BaseModel *)responObject;
//                  NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:baseModel.data];
                  [wself.imgUrlArr addObject:[Common isNull:baseModel.data[@"fullurl"]]];
                  NSLog(@"aaa=%ld",wself.imgUrlArr.count);
                  if (wself.imgUrlArr.count==self->_selectedAssets.count) {
                      [self sendData];
                  }else{

                  }
              } error:^(NSError *errors) {
                  [SVProgressHUD dismiss];
                  
              }];
              
           }];
         
    }
    
}


#pragma mark 提交
-(void)sendData{
   
    for (NSString *urlimgStr in _selectedPhotos) {
        if([urlimgStr isKindOfClass:[NSString class]]){
            [self.imgUrlArr addObject:urlimgStr];
        }
    }
    [self.dataDic setObject:[self.imgUrlArr componentsJoinedByString:@","] forKey:@"images"];
    
    if (self.textView.text.length<1||([self.textView.text isEqualToString:getLanguage(@"  开心Share一下你的动态啊~")])) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"内容不能为空")];
        return;
    }else{
        [self.dataDic setObject:self.textView.text forKey:@"content"];
    }

    [NetworkRequest POST:Request_CheckMessage parmeters:@{@"message":self.textView.text} success:^(id responObject) {
        [self upLoadData];
    } failture:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
    
}

-(void)upLoadData{
    NSLog(@"%@",self.dataDic);
    [self.dataDic setObject:[Common isNull:self.model.message_id] forKey:@"dynamic_id"];
    [NetworkRequest POST:Request_EditDynamic parmeters:self.dataDic success:^(id responObject) {
        NSLog(@"%@",responObject);
        BaseModel *baseModel = (BaseModel *)responObject;
        [SVProgressHUD dismiss];
        [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:baseModel.msg]];
        if (baseModel.code==1) {
//            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"UpDataDynamic" object:nil userInfo:nil]];
            if(self.successBlock){
                self.successBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failture:^(NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD dismiss];
        
    }];
    
}


#pragma mark 定位
-(void )checkLocation{
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"" message:getLanguage(@"您还未开启定位,是否开启") preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:getLanguage(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }else{
                NSURL *url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
                [[UIApplication sharedApplication] openURL:url];
            }
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:getLanguage(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        }]];
        [self presentViewController:alert animated:YES completion:nil];
    } else{
        
        
    }
   
}

// 将要开始编辑
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if([textView.text isEqualToString:getLanguage(@"  开心Share一下你的动态啊~")]){
        textView.text=@"";
    }
    textView.textColor=kBlackColor;
    return YES;
}
// 将要结束编辑
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{

    if (textView.text.length<1) {
        textView.text=getLanguage(@"  开心Share一下你的动态啊~");
//        self.numLabel.text=@"0/200";
    }
    
    _textView.textColor=RGBA(153, 153, 153, 1);
    return YES;
}

// 开始编辑
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
}
// 结束编辑
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length>0&&(![textView.text isEqualToString:getLanguage(@"  开心Share一下你的动态啊~")])) {
        _textView.textColor=kBlackColor;
    }else{
        _textView.textColor=RGBA(153, 153, 153, 1);
    }
 
}

// 文本将要改变
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    NSString *temp = [textView.text stringByReplacingCharactersInRange:range withString:text];
//    if (temp.length > 300)
//    {
//        textView.text = [temp substringToIndex:300];
//      return NO;
//    }
    return YES;
}
// 文本发生改变
- (void)textViewDidChange:(UITextView *)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    NSUInteger count = textView.text.length;
    self.numLabel.text = [NSString stringWithFormat:@"%ld/200", (unsigned long)count];
}
// 焦点发生改变
- (void)textViewDidChangeSelection:(UITextView *)textView{
    
}





- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (@available(iOS 9, *)) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
 
    }
    return _imagePickerVc;
}



- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    _layout = [[LxGridViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
//    _collectionView.scrollEnabled=NO;
    _collectionView.bounces=NO;
    _collectionView.showsVerticalScrollIndicator=NO;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FootA"];
    _margin = KAdaptedWidth(4);
    _itemWH=KAdaptedWidth(100);
    _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    _layout.minimumInteritemSpacing = _margin;
    _layout.minimumLineSpacing = _margin;
    [self.collectionView setCollectionViewLayout:_layout];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView.mas_bottom).offset(KAdaptedHeight(20));
        make.leading.mas_equalTo(KAdaptedWidth(14));
        make.trailing.mas_equalTo(KAdaptedWidth(-14));
//        make.bottom.mas_equalTo(-KAdaptedHeight(100));
        make.bottom.mas_equalTo(-KSAFEAREA_BOTTOM_HEIHGHT);
        
    }];
}

- (EMO_AddTalkView *)talkView{
    if (!_talkView) {
//        _talkView = [[EMO_AddTalkView alloc] init];
//        NSArray *idArr=[self.model.topic_id componentsSeparatedByString:@","];
//        NSArray *strArr=[self.model.topic_list componentsSeparatedByString:@","];
//        NSMutableArray *dataArr=[NSMutableArray array];
//        for (int i=0; i<idArr.count; i++) {
//            [dataArr addObject:@{@"id":idArr[i],@"topic":strArr[i]}];
//        }
//        _talkView.selectDataArr=dataArr;
//        WeakSelf;
//        _talkView.talkBlock = ^(NSMutableArray * _Nonnull dataArr) {
//            NSString *str=[NSString string];
//            for (NSDictionary *dic in dataArr) {
//                str=[str stringByAppendingString:[NSString stringWithFormat:@"%@,",dic[@"id"]]];
//            }
//            [wself.dataDic setObject:str forKey:@"topic_id"];
//        };
    }
    return _talkView;
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    

}

#pragma mark UICollectionView

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        UICollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FootA" forIndexPath:indexPath];
        [headerView addSubview:self.talkView];
      [self.talkView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.mas_equalTo(0);
           make.trailing.leading.mas_equalTo(0);
          make.bottom.mas_equalTo(KAdaptedHeight(-0));

       }];
        
        return headerView;
    }else{
        return nil;
    }
        


}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(kWidth,KAdaptedHeight(200));
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_selectedPhotos.count >=MaxCount) {
        return _selectedPhotos.count;
    }
    if (!self.allowPickingMuitlpleVideoSwitch) {
        if (_isAllowEditVideo) {
            return 1;
        } else {
            for (PHAsset *asset in _selectedAssets) {
                if (asset.mediaType == PHAssetMediaTypeVideo) {
                    return _selectedPhotos.count;
                }
            }
        }
    }
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.item == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"selectPictureImg"];
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
    } else {
        if([_selectedPhotos[indexPath.item] isKindOfClass:[UIImage class]]){
            cell.imageView.image = _selectedPhotos[indexPath.item];
        }else{
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:_selectedPhotos[indexPath.item]]];
        }
//        if (!_isAllowEditVideo) {
//            cell.asset = _selectedAssets[indexPath.item];
//        }
        cell.deleteBtn.hidden = NO;
    }
    if (!self.allowPickingGifSwitch) {
        cell.gifLable.hidden = YES;
    }
    cell.deleteBtn.tag = indexPath.item;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == _selectedPhotos.count) {
        BOOL showSheet = self.showSheetSwitch;
        if (showSheet) {
            NSString *takePhotoTitle = @"拍照";
            if (self.showTakeVideoBtnSwitch && self.showTakePhotoBtnSwitch) {
                takePhotoTitle = @"相机";
            } else if (self.showTakeVideoBtnSwitch) {
                takePhotoTitle = @"拍摄";
            }
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:takePhotoTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self takePhoto];
            }];
            [alertVc addAction:takePhotoAction];
            UIAlertAction *imagePickerAction = [UIAlertAction actionWithTitle:@"去相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self pushTZImagePickerController];
            }];
            [alertVc addAction:imagePickerAction];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertVc addAction:cancelAction];
            UIPopoverPresentationController *popover = alertVc.popoverPresentationController;
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            if (popover) {
                popover.sourceView = cell;
                popover.sourceRect = cell.bounds;
                popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
            }
            [self presentViewController:alertVc animated:YES completion:nil];
        } else {
            [self pushTZImagePickerController];
        }
        
    } else if (_isAllowEditVideo && [_selectedAssets[indexPath.item] isKindOfClass:[NSURL class]]) { // preview edited video / 预览编辑后的视频
        TZVideoEditedPreviewController *vc = [[TZVideoEditedPreviewController alloc] init];
        vc.videoURL = _selectedAssets[indexPath.item];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    } else { // preview photos or video / 预览照片或者视频
        PHAsset *asset = _selectedAssets[indexPath.item];
        BOOL isVideo = NO;
        isVideo = asset.mediaType == PHAssetMediaTypeVideo;
        if ([[asset valueForKey:@"filename"] containsString:@"GIF"] && self.allowPickingGifSwitch && !self.allowPickingMuitlpleVideoSwitch) {
            TZGifPhotoPreviewController *vc = [[TZGifPhotoPreviewController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypePhotoGif timeLength:@""];
            vc.model = model;
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:nil];
        } else if (isVideo && !self.allowPickingMuitlpleVideoSwitch) { // perview video / 预览视频
            TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
            vc.model = model;
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:nil];
        } else { // preview photos / 预览照片
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.item];
            imagePickerVc.maxImagesCount = MaxCount;
            imagePickerVc.allowPickingGif = self.allowPickingGifSwitch;
            imagePickerVc.autoSelectCurrentWhenDone = NO;
            imagePickerVc.allowPickingOriginalPhoto = self.allowPickingOriginalPhotoSwitch;
            imagePickerVc.allowPickingMultipleVideo = self.allowPickingMuitlpleVideoSwitch;
            imagePickerVc.showSelectedIndex = self.showSelectedIndexSwitch;
            imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
            imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                self->_selectedPhotos = [NSMutableArray arrayWithArray:photos];
                self->_selectedAssets = [NSMutableArray arrayWithArray:assets];
                self->_isSelectOriginalPhoto = isSelectOriginalPhoto;
                [self->_collectionView reloadData];
                self->_collectionView.contentSize = CGSizeMake(0, ((self->_selectedPhotos.count + 2) / 3 ) * (self->_margin + self->_itemWH));
            }];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }
    }
}

#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
    [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = _selectedAssets[sourceIndexPath.item];
    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    
    [_collectionView reloadData];
}

#pragma mark - TZImagePickerController

- (void)pushTZImagePickerController {
    if (MaxCount<= 0) {
        return;
    }

    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:MaxCount columnNumber:ColumnNum delegate:self pushPhotoPickerVc:YES];
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    
    if (MaxCount > 1) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    }
    imagePickerVc.allowTakePicture = self.showTakePhotoBtnSwitch; // 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = self.showTakeVideoBtnSwitch;   // 在内部显示拍视频按
    imagePickerVc.videoMaximumDuration = 10; // 视频最大拍摄时间
    imagePickerVc.allowTakeVideo = YES; // 允许编辑视频
//     imagePickerVc.saveEditedVideoToCollection = YES; // 编辑后的视频是否自动保存到相册
    // imagePickerVc.maxCropVideoDuration = 30; // 裁剪视频的最大时长
//     imagePickerVc.presetName = AVAssetExportPresetMediumQuality // 编辑后的视频的导出质量
    [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }];
    // imagePickerVc.autoSelectCurrentWhenDone = NO;
    
    // imagePickerVc.photoWidth = 1600;
    // imagePickerVc.photoPreviewMaxWidth = 1600;
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // imagePickerVc.barItemTextColor = [UIColor blackColor];
    // imagePickerVc.navigationBar.translucent = NO;
    // [imagePickerVc.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    // imagePickerVc.navigationBar.tintColor = [UIColor blackColor];
    // if (@available(iOS 13.0, *)) {
    //     UINavigationBarAppearance *barAppearance = [[UINavigationBarAppearance alloc] init];
    //     barAppearance.backgroundColor = imagePickerVc.navigationBar.barTintColor;
    //     barAppearance.titleTextAttributes = imagePickerVc.navigationBar.titleTextAttributes;
    //     imagePickerVc.navigationBar.standardAppearance = barAppearance;
    //     imagePickerVc.navigationBar.scrollEdgeAppearance = barAppearance;
    // }
    
    imagePickerVc.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    imagePickerVc.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    /*
    [imagePickerVc setPhotoPickerPageUIConfigBlock:^(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine) {
        [doneButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }];
     */
    /*
    [imagePickerVc setAssetCellDidSetModelBlock:^(TZAssetCell *cell, UIImageView *imageView, UIImageView *selectImageView, UILabel *indexLabel, UIView *bottomView, UILabel *timeLength, UIImageView *videoImgView) {
        cell.contentView.clipsToBounds = YES;
        cell.contentView.layer.cornerRadius = cell.contentView.tz_width * 0.5;
    }];
     */
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = self.allowPickingVideoSwitch;
    imagePickerVc.allowPickingImage = self.allowPickingImageSwitch;
    imagePickerVc.allowPickingOriginalPhoto = self.allowPickingOriginalPhotoSwitch;
    imagePickerVc.allowPickingGif = self.allowPickingGifSwitch;
    imagePickerVc.allowPickingMultipleVideo = self.allowPickingMuitlpleVideoSwitch; // 是否可以多选视频
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = self.sortAscendingSwitch;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = self.allowCropSwitch;
    imagePickerVc.needCircleCrop = self.needCircleCropSwitch;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 30;
    NSInteger widthHeight = self.view.tz_width - 2 * left;
    NSInteger top = (self.view.tz_height - widthHeight) / 2;
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    imagePickerVc.scaleAspectFillCrop = YES;
    // 设置横屏下的裁剪尺寸
    // imagePickerVc.cropRectLandscape = CGRectMake((self.view.tz_height - widthHeight) / 2, left, widthHeight, widthHeight);
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    // imagePickerVc.allowPreview = NO;
    // 自定义导航栏上的返回按钮
    /*
    [imagePickerVc setNavLeftBarButtonSettingBlock:^(UIButton *leftButton){
        [leftButton setImage:[UIImage imageNamed:@"backBtnImg"] forState:UIControlStateNormal];
        [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 20)];
    }];
    imagePickerVc.delegate = self;
    */
    
    // Deprecated, Use statusBarStyle
    // imagePickerVc.isStatusBarDefault = NO;
    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    
    // 设置是否显示图片序号
    imagePickerVc.showSelectedIndex = self.showSelectedIndexSwitch;
    
    // 设置拍照时是否需要定位，仅对选择器内部拍照有效，外部拍照的，请拷贝demo时手动把pushImagePickerController里定位方法的调用删掉
    // imagePickerVc.allowCameraLocation = NO;
    
    // 自定义gif播放方案
    [[TZImagePickerConfig sharedInstance] setGifImagePlayBlock:^(TZPhotoPreviewView *view, UIImageView *imageView, NSData *gifData, NSDictionary *info) {
        FLAnimatedImage *animatedImage = [FLAnimatedImage animatedImageWithGIFData:gifData];
        FLAnimatedImageView *animatedImageView;
        for (UIView *subview in imageView.subviews) {
            if ([subview isKindOfClass:[FLAnimatedImageView class]]) {
                animatedImageView = (FLAnimatedImageView *)subview;
                animatedImageView.frame = imageView.bounds;
                animatedImageView.animatedImage = nil;
            }
        }
        if (!animatedImageView) {
            animatedImageView = [[FLAnimatedImageView alloc] initWithFrame:imageView.bounds];
            animatedImageView.runLoopMode = NSDefaultRunLoopMode;
            [imageView addSubview:animatedImageView];
        }
        animatedImageView.animatedImage = animatedImage;
    }];
    
    // 设置首选语言 / Set preferred language
    // imagePickerVc.preferredLanguage = @"zh-Hans";
    
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {

    }];
    
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

/*
// 设置了navLeftBarButtonSettingBlock后，需打开这个方法，让系统的侧滑返回生效
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
 
    navigationController.interactivePopGestureRecognizer.enabled = YES;
    if (viewController != navigationController.viewControllers[0]) {
        navigationController.interactivePopGestureRecognizer.delegate = nil; // 支持侧滑
    }
}
*/

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhoto];
                });
            }
        }];
        // 拍照之前还需要检查相册权限
    } else if ([PHPhotoLibrary authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    __weak typeof(self) weakSelf = self;
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(NSArray<CLLocation *> *locations) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = [locations firstObject];
    } failureBlock:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = nil;
    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        NSMutableArray *mediaTypes = [NSMutableArray array];
        if (self.showTakeVideoBtnSwitch) {
            [mediaTypes addObject:(NSString *)kUTTypeMovie];
        }
        if (self.showTakePhotoBtnSwitch) {
            [mediaTypes addObject:(NSString *)kUTTypeImage];
        }
        if (mediaTypes.count) {
            _imagePickerVc.mediaTypes = mediaTypes;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    tzImagePickerVc.sortAscendingByModificationDate = self.sortAscendingSwitch;
    [tzImagePickerVc showProgressHUD];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSDictionary *meta = [info objectForKey:UIImagePickerControllerMediaMetadata];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image meta:meta location:self.location completion:^(PHAsset *asset, NSError *error){
            [tzImagePickerVc hideProgressHUD];
            if (error) {
                NSLog(@"图片保存失败 %@",error);
            } else {
                TZAssetModel *assetModel = [[TZImageManager manager] createModelWithAsset:asset];
                if (self.allowCropSwitch) { // 允许裁剪,去裁剪
                    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                        [self refreshCollectionViewWithAddedAsset:asset image:cropImage];
                    }];
                    imagePicker.allowPickingImage = YES;
                    imagePicker.needCircleCrop = self.needCircleCropSwitch;
                    imagePicker.circleCropRadius = 100;
                    [self presentViewController:imagePicker animated:YES completion:nil];
                } else {
                    [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                }
            }
        }];
    } else if ([type isEqualToString:@"public.movie"]) {
        NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        if (videoUrl) {
            [[TZImageManager manager] saveVideoWithUrl:videoUrl location:self.location completion:^(PHAsset *asset, NSError *error) {
                [tzImagePickerVc hideProgressHUD];
                if (!error) {
                    TZAssetModel *assetModel = [[TZImageManager manager] createModelWithAsset:asset];
                    [[TZImageManager manager] getPhotoWithAsset:assetModel.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
                        if (!isDegraded && photo) {
                            [self refreshCollectionViewWithAddedAsset:assetModel.asset image:photo];
                        }
                    }];
                }
            }];
        }
    }
}

- (void)refreshCollectionViewWithAddedAsset:(PHAsset *)asset image:(UIImage *)image {
    [_selectedAssets addObject:asset];
    [_selectedPhotos addObject:image];
    [_collectionView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

// The picker should dismiss itself; when it dismissed these handle will be called.
// You can also set autoDismiss to NO, then the picker don't dismiss itself.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 你也可以设置autoDismiss属性为NO，选择器就不会自己dismis了
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    
//    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
//    NSMutableArray *arrr=[NSMutableArray arrayWithArray:_selectedPhotos];
    NSArray *arrr =[[_selectedPhotos reverseObjectEnumerator] allObjects];
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    NSInteger i=0;
    for (NSString *strUrl in arrr) {
        if([strUrl isKindOfClass:[NSString class]]){
            [_selectedPhotos insertObject:strUrl atIndex:0];
            
        }
        i++;
    }
    
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));

    // 1.打印图片名字
    [self printAssetsName:assets];
    // 2.图片位置信息
    for (PHAsset *phAsset in assets) {
        NSLog(@"location:%@",phAsset.location);
    }
    
    // 3. 获取原图的示例，用队列限制最大并发为1，避免内存暴增
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.maxConcurrentOperationCount = 1;
    for (NSInteger i = 0; i < assets.count; i++) {
        PHAsset *asset = assets[i];
        // 图片上传operation，上传代码请写到operation内的start方法里，内有注释
        TZImageUploadOperation *operation = [[TZImageUploadOperation alloc] initWithAsset:asset completion:^(UIImage * photo, NSDictionary *info, BOOL isDegraded) {
            if (isDegraded) return;
            NSLog(@"图片获取&上传完成");
        } progressHandler:^(double progress, NSError * _Nonnull error, BOOL * _Nonnull stop, NSDictionary * _Nonnull info) {
            NSLog(@"获取原图进度 %f", progress);
        }];
        [self.operationQueue addOperation:operation];
    }
}

/// 如果用户选择了某张照片下面的代理方法会被执行
/// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
/// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
- (void)imagePickerController:(TZImagePickerController *)picker didSelectAsset:(PHAsset *)asset photo:(UIImage *)photo isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
//    [_selectedAssets addObject:asset];
//    [_selectedPhotos addObject:photo];
//    [self.collectionView reloadData];
}

/// 如果用户取消选择了某张照片下面的代理方法会被执行
/// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
/// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
- (void)imagePickerController:(TZImagePickerController *)picker didDeselectAsset:(PHAsset *)asset photo:(UIImage *)photo isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
//    int index = -1;
//    for (int i = 0; i < _selectedAssets.count; i++) {
//        if ([_selectedAssets[i] isEqual:asset]) {
//            index = i;
//        }
//    }
//    if (index > -1) {
//        [_selectedAssets removeObjectAtIndex:index];
//        [_selectedPhotos removeObjectAtIndex:index];
//        [self.collectionView reloadData];
//    }
}

// If user picking a video and allowPickingMultipleVideo is NO, this callback will be called.
// If allowPickingMultipleVideo is YES, will call imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:
// 如果用户选择了一个视频且allowPickingMultipleVideo是NO，下面的代理方法会被执行
// 如果allowPickingMultipleVideo是YES，将会调用imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    // open this code to send video / 打开这段代码发送视频
    [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPresetLowQuality success:^(NSString *outputPath) {
        // NSData *data = [NSData dataWithContentsOfFile:outputPath];
        NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
        // Export completed, send video here, send by outputPath or NSData
        // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    } failure:^(NSString *errorMessage, NSError *error) {
        NSLog(@"视频导出失败:%@,error:%@",errorMessage, error);
    }];
    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

// If allowEditVideo is YES and allowPickingMultipleVideo is NO, When user picking a video, this callback will be called.
// If allowPickingMultipleVideo is YES, video editing is not supported, will call imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:
// 当allowEditVideo是YES且allowPickingMultipleVideo是NO是，如果用户选择了一个视频，下面的代理方法会被执行
// 如果allowPickingMultipleVideo是YES，则不支持编辑视频，将会调用imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:

#pragma mark 导出视频
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingAndEditingVideo:(UIImage *)coverImage outputPath:(NSString *)outputPath error:(NSString *)errorMsg {
    _isAllowEditVideo = YES;
    self->_selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    self->_selectedAssets = [NSMutableArray arrayWithArray:@[[NSURL fileURLWithPath:outputPath]]];
    if (outputPath) {
        // NSData *data = [NSData dataWithContentsOfFile:outputPath];
        NSLog(@"视频导出到本地完成,outputPath为:%@",outputPath);
        self.filePathURL=[NSURL URLWithString:[NSString stringWithFormat:@"file://%@",outputPath]];
        self.selecVideo=YES;
        [self upPictures:2];
        // Export completed, send video here, send by outputPath or NSData
        // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    } else {
        NSLog(@"视频导出失败:%@",errorMsg);
    }
    [self.collectionView reloadData];
}

// If user fail to save edited, this callback will be called.
// 如果用户保存编辑好的视频失败，将会调用
- (void)imagePickerController:(TZImagePickerController *)picker didFailToSaveEditedVideoWithError:(NSError *)error {
    NSLog(@"编辑后的视频自动保存到相册失败:%@",error.description);
}

// If user picking a gif image and allowPickingMultipleVideo is NO, this callback will be called.
// If allowPickingMultipleVideo is YES, will call imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:
// 如果用户选择了一个gif图片且allowPickingMultipleVideo是NO，下面的代理方法会被执行
// 如果allowPickingMultipleVideo是YES，将会调用imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(PHAsset *)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[animatedImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    [_collectionView reloadData];
}

// Decide album show or not't
// 决定相册显示与否
- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(PHFetchResult *)result {
    /*
    if ([albumName isEqualToString:@"个人收藏"]) {
        return NO;
    }
    if ([albumName isEqualToString:@"视频"]) {
        return NO;
    }*/
    return YES;
}

// Decide asset show or not't
// 决定asset显示与否
- (BOOL)isAssetCanBeDisplayed:(PHAsset *)asset {
    /*
    switch (asset.mediaType) {
        case PHAssetMediaTypeVideo: {
            // 视频时长
            // NSTimeInterval duration = phAsset.duration;
            return NO;
        } break;
        case PHAssetMediaTypeImage: {
            // 图片尺寸
            if (asset.pixelWidth > 3000 || asset.pixelHeight > 3000) {
                 return NO;
            }
            return YES;
        } break;
        case PHAssetMediaTypeAudio:
            return NO;
            break;
        case PHAssetMediaTypeUnknown:
            return NO;
            break;
        default: break;
    }
     */
    return YES;
}

// Decide asset can be selected
// 决定照片能否被选中
- (BOOL)isAssetCanBeSelected:(PHAsset *)asset {
    /*
    switch (asset.mediaType) {
        case PHAssetMediaTypeVideo: {
            // 视频时长
            // NSTimeInterval duration = phAsset.duration;
            return NO;
        } break;
        case PHAssetMediaTypeImage: {
            // 图片尺寸
            if (asset.pixelWidth > 3000 || asset.pixelHeight > 3000) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"不支持选择超大图片" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
                [self.presentedViewController presentViewController:alertController animated:YES completion:nil];
                return NO;
            }
            return YES;
        } break;
        case PHAssetMediaTypeAudio:
            return NO;
            break;
        case PHAssetMediaTypeUnknown:
            return NO;
            break;
        default: break;
    }
     */
    return YES;
}

#pragma mark - Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    if ([self collectionView:self.collectionView numberOfItemsInSection:0] <= _selectedPhotos.count) {
        [_selectedPhotos removeObjectAtIndex:sender.tag];
        [_selectedAssets removeObjectAtIndex:sender.tag];
        [self.collectionView reloadData];
        if (self.selecVideo==YES) {
            self.filePathURL=[NSURL URLWithString:@""];
            self.selecVideo=NO;
        }
        
        return;
    }
    
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    if( _selectedAssets.count>sender.tag){
        [_selectedAssets removeObjectAtIndex:sender.tag];
    }
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [self->_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self->_collectionView reloadData];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark - Private

/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (PHAsset *asset in assets) {
        fileName = [asset valueForKey:@"filename"];
        // NSLog(@"图片名字:%@",fileName);
    }
}

#pragma clang diagnostic pop

@end
