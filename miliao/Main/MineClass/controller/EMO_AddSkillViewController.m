//
//  EMO_AddSkillViewController.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/3.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_AddSkillViewController.h"
#import "EMO_SendVoiceView.h"
#define isValidString(string)               (string && [string isEqualToString:@""] == NO)
#define ETRECORD_RATE 11025.0
#define ENCODE_MP3    1

@interface EMO_AddSkillViewController ()<UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource,AVAudioRecorderDelegate>

@property (nonatomic, strong) UILabel        *describeLB;
@property (nonatomic, strong) UIView         *describeView;
@property (nonatomic, strong) UITextView    *textView;
@property (nonatomic, strong) UILabel        *bgLabel;
//@property (nonatomic, strong) UILabel                               *numLabel;
@property (nonatomic, strong) UIImageView   *imageView;
@property (nonatomic, strong) UIButton     *submitButton;
@property (nonatomic, strong) UIImagePickerController               *imagePickerController;
//@property (nonatomic, strong) UIImage  *coverImage;
@property (nonatomic, strong) NSString  *coverImageUrl;

@property (nonatomic,strong) EMO_SendVoiceView *voiceView;
@property (nonatomic,strong) NSString *sendMp3Path;
@property (nonatomic,assign) NSInteger timeDuration;

@property (nonatomic,strong) NSString *qiNiuToken;

@end

@implementation EMO_AddSkillViewController{
    NSInteger time;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(248, 248, 248, 1);
    [self loadBar:YES needBack:YES needBackground:YES];
    self.titleLabel.text=getLanguage(@"技能介绍");
    self.titleLabel.font=KFont(18);
    self.isNeedLine = YES;
    [self getToken];
    [self setUpView];
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;

    [self voiceView];
    self.sendMp3Path=@"";
    self.timeDuration=0;
    
}

- (void)submitData:(NSString *)voiceUrl{

    [NetworkRequest POST:Request_AddSkill parmeters:@{@"skill_id":self.dicData[@"id"],@"desc":self.textView.text,@"image":self.coverImageUrl,@"video_url":voiceUrl,@"times":@(self.timeDuration)} success:^(id responObject) {
        [SVProgressHUD dismiss];
        BaseModel *baseModel = (BaseModel *)responObject;
        [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:baseModel.msg]];
        [self.navigationController popViewControllerAnimated:YES];
    } failture:^(NSError *error) {
        [SVProgressHUD dismiss];
        
        
    }];
    
    
    
    
    
    
//    if (self.coverImageUrl.length>0){
//        NSData *data = UIImageJPEGRepresentation(self.coverImage, 0.5f);
//        NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//        [dict setValue:NSStringFormat(@"data:image/jpg;base64,%@",encodedImageStr) forKey:@"img"];
//    }
//    [HttpTool getFeedbackWithParameters:dict success:^(id response) {
//        if ([response[@"code"] integerValue] == 1) {
//
//        }
//        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:response[@"message"]];
//    } failure:^(NSError *error) {
//
//    }];
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


-(void)requestMp3Data{
    if (self.textView.text.length == 0){
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:getLanguage(@"内容不能为空!")];
        return ;
    }
    if(self.coverImageUrl.length<1){
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:getLanguage(@"你还没有上传图片!")];
        return ;
    }
    if(self.sendMp3Path.length<1){
        
        return [SVProgressHUD showImage:[UIImage imageNamed:@""] status:getLanguage(@"你还未上传语音介绍")];
    }
    [SVProgressHUD show];
    [NetworkRequest uploadOneVoice:Request_AppUpload parameters:@{@"qiniutoken":self.qiNiuToken} path:[NSURL fileURLWithPath:self.sendMp3Path] fileName:@"file" progress:^(NSProgress *uploadProgress) {

    } success:^(id responObject) {
        NSLog(@"%@",responObject);
        if ([responObject[@"code"] integerValue]==1) {
            [self submitData:[Common isNull:responObject[@"data"][@"fullurl"]]];
//            self.bgView.hidden=NO;
//            self.delVoiceBtn.hidden=NO;
//            self.tipLabel.text=getLanguage(@"语音打招呼待提交");
//            if (self.VoiceBlock) {
//                self.VoiceBlock(responObject[@"data"][@"url"],self->time);
//            }
        }else{
            [SVProgressHUD dismiss];
        }
        

    } error:^(NSError *errors) {
        [SVProgressHUD dismiss];
    }];
    
    
}



- (void)requestPhoto:(UIImage *)img andToken:(NSString *)token{

    WeakSelf;
    [SVProgressHUD showWithStatus:getLanguage(@"上传中")];
    [NetworkRequest uploadOneImage:Request_AppUpload parameters:@{@"qiniutoken":token} image:img fileName:@"file" progress:^(NSProgress *uploadProgress) {

    } success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        [SVProgressHUD dismiss];
        [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"上传成功")];
        NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:baseModel.data];
        wself.coverImageUrl=[Common isNull:dic[@"fullurl"]];
        [wself.imageView sd_setImageWithURL:[NSURL URLWithString:[Common isNull:dic[@"fullurl"]]]placeholderImage:KGetImage(@"addPictureImg")];

    } error:^(NSError *errors) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"上传失败")];

    }];
    
    
}


- (void)singleTapGesture:(UITapGestureRecognizer *)tap{
    [self selectImageFromAlbum];
}
#pragma mark 从相册获取图片或视频
- (void)selectImageFromAlbum {
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePickerController.modalPresentationStyle = 0;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate
//该代理方法仅适用于只选取图片时
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
//    _coverImage = info[@"UIImagePickerControllerOriginalImage"];
//    self.imageView.image = _coverImage;
    if(self.qiNiuToken.length>0){
        [self requestPhoto:info[@"UIImagePickerControllerOriginalImage"] andToken:self.qiNiuToken];
    }else{
        [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"请求超时,请重试")];
        [self getToken];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        //禁止输入换行
        return NO;
    }
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text]; //得到输入框的内容
    if (toBeString.length > 0) {
        self.bgLabel.hidden = YES;
    }else{
        self.bgLabel.hidden = NO;
    }
    if (self.textView == textView)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 300) { //如果输入框内容大于12则弹出警告
            textView.text = [toBeString substringToIndex:300];
//            self.numLabel.text = NSStringFormat(@"%ld/300",textView.text.length);
            return NO;
        }
//        self.numLabel.text = NSStringFormat(@"%ld/300",textView.text.length);
    }
    return YES;
}

- (EMO_SendVoiceView *)voiceView{
    if (!_voiceView) {
        WeakSelf;
        _voiceView = [[EMO_SendVoiceView alloc] init];
        _voiceView.backgroundColor = RGBA(248, 248, 248, 1);
        _voiceView.VoiceBlock = ^(NSString * _Nonnull voiceFilePath, NSInteger duration) {
            wself.sendMp3Path=voiceFilePath;
            wself.timeDuration=duration;
            NSLog(@"录音文件路径:%@\n长度:%lu秒",wself.sendMp3Path,wself.timeDuration);
        };
        [self.bgView addSubview:_voiceView];
        [_voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.submitButton.mas_top).offset(KAdaptedHeight(-10));
            make.trailing.leading.mas_equalTo(KAdaptedWidth(0));
            make.top.mas_equalTo(self.describeView.mas_bottom).offset(KAdaptedHeight(10));
        }];
    }
    return _voiceView;
}

- (void)setUpView{
    [self.bgView addSubview:self.describeLB];
    [self.bgView addSubview:self.describeView];
    [self.describeView addSubview:self.textView];
    [self.textView addSubview:self.bgLabel];
//    [self.describeView addSubview:self.numLabel];
    [self.describeView addSubview:self.imageView];
    [self.bgView addSubview:self.submitButton];
    
    
    [self.describeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.barView.mas_bottom).offset(25);
        make.left.mas_equalTo(self.bgView).offset(13);
    }];
    [self.describeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.describeLB.mas_bottom).offset(10);
        make.left.mas_equalTo(self.bgView).offset(13);
        make.right.mas_equalTo(self.bgView).offset(-13);
        make.height.mas_equalTo(175);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.describeView).offset(15);
        make.left.mas_equalTo(self.describeView).offset(11);
        make.right.mas_equalTo(self.describeView).offset(-11);
        make.height.mas_equalTo(130);
    }];
    [self.bgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView).offset(6);
        make.left.mas_equalTo(self.textView).offset(5);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.describeView).offset(-12);
        make.left.mas_equalTo(self.describeView).offset(11);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
    }];
//    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.textView);
//        make.top.mas_equalTo(self.textView.mas_bottom).offset(5);
//    }];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.describeView.mas_bottom).offset(200);
        make.bottom.mas_equalTo(-KSAFEAREA_BOTTOM_HEIHGHT-KAdaptedHeight(36));
        make.leading.mas_equalTo(self.bgView).offset(40);
        make.trailing.mas_equalTo(self.bgView).offset(-40);
        make.height.mas_equalTo(KAdaptedHeight(45));
        
    }];

    
    
}

#pragma mark - getter methodsb
- (UILabel *)describeLB{
    if (!_describeLB) {
        _describeLB = [ControlCreator createLabel:nil rect:CGRectZero text:getLanguage(@"技能介绍") font:Font(14) color:mainViceColor backguoundColor:[UIColor clearColor] align:NSTextAlignmentLeft lines:1];
    }
    return _describeLB;
}
- (UIView *)describeView{
    if (!_describeView) {
        _describeView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:[UIColor whiteColor]];
//        _describeView.layer.cornerRadius =  7;
//        _describeView.layer.shadowOffset = CGSizeMake(0,1);
//        _describeView.layer.masksToBounds = NO;
//        _describeView.layer.shadowColor = mainQianColor.CGColor;
//        _describeView.layer.shadowOpacity = 0.5f;
    }
    return _describeView;
}
- (UITextView *)textView{
    if (!_textView) {
        _textView = [ControlCreator createTextView:nil rect:CGRectZero text:@"" font:Font(12) color:[UIColor blackColor] backguoundColor:[UIColor clearColor]];
        _textView.delegate = self;
    }
    return _textView;
}
- (UILabel *)bgLabel{
    if (!_bgLabel) {
        _bgLabel = [ControlCreator createLabel:nil rect:CGRectZero text:getLanguage(@"快来让别人知道你的技能吧~") font:Font(12) color:mainQianColor backguoundColor:[UIColor clearColor] align:NSTextAlignmentLeft lines:1];
    }
    return _bgLabel;
}
//- (UILabel *)numLabel{
//    if (!_numLabel) {
//        _numLabel = [ControlCreator createLabel:nil rect:CGRectZero text:@"0/300" font:Font(11) color:mainQianColor backguoundColor:[UIColor clearColor] align:NSTextAlignmentRight lines:1];
//    }
//    return _numLabel;
//}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [ControlCreator createImageView:nil rect:CGRectZero imageName:@"addPictureImg" backguoundColor:[UIColor clearColor]];
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
        [_imageView addGestureRecognizer:singleTap];
    }
    return _imageView;
}

    
- (UIButton *)submitButton{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0,0,kWidth-KAdaptedWidth(55),KAdaptedHeight(45));
        gl.startPoint = CGPointMake(0.5, 0);
        gl.endPoint = CGPointMake(0.5, 1);
        gl.colors = @[(__bridge id)BaseMainColor.CGColor,(__bridge id)RGBA(255, 238, 1, 1).CGColor];
        gl.locations = @[@(0.0),@(1.0f)];

        [self.submitButton.layer addSublayer:gl];
        _submitButton.layer.cornerRadius = 22.5;
        _submitButton.layer.masksToBounds=YES;
        [_submitButton setTitle:getLanguage(@"提交") forState:UIControlStateNormal];
        [_submitButton setTitleColor:RGBA(34, 34, 34, 1) forState:UIControlStateNormal];
        _submitButton.titleLabel.font=KFont(15);
        _submitButton.tag=500;
        [_submitButton addTarget:self action:@selector(requestMp3Data) forControlEvents:UIControlEventTouchUpInside];

    }
    return _submitButton;
}

    
    
  
@end




