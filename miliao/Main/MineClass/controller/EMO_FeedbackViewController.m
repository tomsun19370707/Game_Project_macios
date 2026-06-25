//
//  EMO_FeedbackViewController.m
//  miliao
//
//  Created by feifei on 2019/8/6.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "EMO_FeedbackViewController.h"


@interface EMO_FeedbackViewController ()<UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UIView                                *describeView;
@property (nonatomic, strong) UITextView                            *textView;
@property (nonatomic, strong) UILabel                               *bgLabel;
@property (nonatomic, strong) UIImageView                           *imageView;
@property (nonatomic, strong) UIImagePickerController               *imagePickerController;
@property (nonatomic, strong) UIImage                               *coverImage;
@property (nonatomic,strong) TKBottomView *bottomView ;



@end

@implementation EMO_FeedbackViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isNeedLine = YES;
    [self loadBar:YES needBack:YES needBackground:YES];
    self.leftButtonView.image = ImageNamed(@"xiaoxi_back");
    self.titleLabel.text = getLanguage(@"帮助与反馈");
    [self setUpView];
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
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
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark UIImagePickerControllerDelegate
//该代理方法仅适用于只选取图片时
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    _coverImage = info[@"UIImagePickerControllerOriginalImage"];
    self.imageView.image = _coverImage;
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

- (void)setUpView{
//    [self.bgView addSubview:self.describeLB];
    [self.bgView addSubview:self.describeView];
    [self.describeView addSubview:self.textView];
    [self.textView addSubview:self.bgLabel];
//    [self.describeView addSubview:self.numLabel];
//    [self.describeView addSubview:self.imageView];
 
    [self.describeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.barView.mas_bottom).offset(25);
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

    [self.view addSubview:self.bottomView];
    
    
    @weakify(self);
    [[self.bottomView.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (self.textView.text.length == 0){
            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:getLanguage(@"请输入反馈内容")];
            return ;
        }
        
        
        [NetworkRequest POST:Request_SubmitFeedback parmeters:@{@"content":self.textView.text} success:^(id responObject) {
            BaseModel *baseModel = (BaseModel *)responObject;
            [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:baseModel.msg]];
            [self.navigationController popViewControllerAnimated:YES];
            
        } failture:^(NSError *error) {
            
            
        }];
    }];
}





#pragma mark - getter methodsb
- (UIView *)describeView{
    if (!_describeView) {
        _describeView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:[UIColor whiteColor]];
        _describeView.layer.cornerRadius =  7;
        _describeView.layer.shadowOffset = CGSizeMake(0,1);
        _describeView.layer.masksToBounds = NO;
        _describeView.layer.shadowColor = mainQianColor.CGColor;
        _describeView.layer.shadowOpacity = 0.5f;
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
        _bgLabel = [ControlCreator createLabel:nil rect:CGRectZero text:getLanguage(@"请填写您遇到的问题或建议...") font:Font(12) color:mainQianColor backguoundColor:[UIColor clearColor] align:NSTextAlignmentLeft lines:1];
    }
    return _bgLabel;
}
  
-(TKBottomView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[[NSBundle mainBundle] loadNibNamed:@"TKBottomView" owner:self options:nil]lastObject];
        [_bottomView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, _bottomView.contentView.height)];
        [_bottomView.btn setTitle:@"提交" forState:UIControlStateNormal];
        _bottomView.selectionStyle = UITableViewCellSelectionStyleNone ;
        _bottomView.bottom = SCREEN_HEIGHT ;
    }
    return _bottomView ;
}

@end
