//
//  EMO_RenZhengViewController.m
//  miliao
//
//  Created by apple on 2020/3/24.
//  Copyright © 2020 miliao. All rights reserved.
//

#import "EMO_RenZhengViewController.h"
#import "EMO_RenZhengViewController+Photo.h"
#import <AliyunFaceAuthFacade/AliyunFaceAuthFacade.h>
@interface EMO_RenZhengViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic, strong) UITextField *myPhoneText;
@property(nonatomic, strong) UITextField *myVcodeText;



@end

@implementation EMO_RenZhengViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(248, 248, 248, 1);
    [self loadBar:YES needBack:YES needBackground:YES];
    self.leftButtonView.image = ImageNamed(@"xiaoxi_back");
    self.titleLabel.text = @"身份认证";
    
    UIView *bgView=[[UIView alloc] initWithFrame:CGRectMake(0,ZJTopNavH+ZJStatusBarH+KAdaptedHeight(10), kWidth, KAdaptedHeight(450))];
    bgView.backgroundColor=kWhiteColor;
    [self.view addSubview:bgView];
    
    UILabel *phoneLab = [UILabel new];
    phoneLab.text = @"真实姓名:";
    phoneLab.textColor = COLOR_333333;
    phoneLab.font = KFont(16);
    [bgView addSubview:phoneLab];
    phoneLab.frame = CGRectMake(20, 0, 90, 30);
    
    UITextField *numText = [[UITextField alloc] init];
    numText.placeholder = getLanguage(@"请输入");//@"请输入您的真实姓名";
    numText.font = KFont(16);
    self.myPhoneText = numText;
//    numText.keyboardType = UIKeyboardTypeNumberPad;
    numText.textColor = COLOR_666666;
    numText.textAlignment=NSTextAlignmentRight;
    [bgView addSubview:numText];
    numText.frame = CGRectMake(phoneLab.right+5, phoneLab.top, kWidth-40-90, 30);
    
    UIView *firstLine = [UIView new];
    firstLine.frame = CGRectMake(phoneLab.left, numText.bottom+0.5+10, ScreenWidth-40, 0.5);
    firstLine.backgroundColor = MHColorFromHexString(@"#EEEEEE");
    [bgView addSubview:firstLine];
    
    UILabel *codeLab = [UILabel new];
    codeLab.text = @"身份证号:";
    codeLab.textColor = COLOR_333333;
    codeLab.font = KFont(16);
    [bgView addSubview:codeLab];
    codeLab.frame = CGRectMake(20, phoneLab.bottom+40, 90, 30);
    
    UITextField *vcodeText = [[UITextField alloc] init];
    vcodeText.placeholder =getLanguage(@"请输入") ;//@"请输入您的身份证号"
    self.myVcodeText = vcodeText;
    vcodeText.font = KFont(16);
    vcodeText.keyboardType = UIKeyboardTypeDefault;
    vcodeText.textColor = COLOR_666666;
    vcodeText.textAlignment=NSTextAlignmentRight;
    [bgView addSubview:vcodeText];
    vcodeText.frame = CGRectMake(codeLab.right+5, codeLab.top, kWidth-40-90, 30);
    UIView *secLine = [UIView new];
    secLine.frame = CGRectMake(codeLab.left, codeLab.bottom+0.5+10, ScreenWidth-40, 0.5);
    secLine.backgroundColor = MHColorFromHexString(@"#EEEEEE");
    [bgView addSubview:secLine];

    
    /** 去掉身份证 照片*/
//    _carView = [[EMO_UpLoadCardImgView alloc] initWithFrame:CGRectMake(0, secLine.bottom, 200, 320)];
//    _carView.backgroundColor = [UIColor whiteColor];
//    _carView.tipDic=@{@"title":getLanguage(@"身份证"),@"tip":getLanguage(@""),@"zhengTip":getLanguage(@""),@"fanTip":getLanguage(@"")};
//    WeakSelf;
//    _carView.SelectPhotoBlock = ^(NSInteger tag) {
//        wself.Picturetype=tag;
//        [wself choosePicture];
//        
//    };
//    [bgView addSubview:_carView];
    
  
    UIButton *jiebangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [jiebangBtn setTitle:getLanguage(@"提交") forState:UIControlStateNormal];
    [jiebangBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    jiebangBtn.titleLabel.font=KFont(15);
    jiebangBtn.frame = CGRectMake(KAdaptedWidth(15), kHeight-KAdaptedHeight(70)-KSAFEAREA_BOTTOM_HEIHGHT, ScreenWidth-KAdaptedWidth(30), 45);
    jiebangBtn.backgroundColor = BaseMainColor ;
    [jiebangBtn makeRoundCorner];

    
    [self.view addSubview:jiebangBtn];
    __weak __typeof(self)weakSelf = self;
    [jiebangBtn buttonAddTaget:^(UIButton *btn) {
        [weakSelf jieBangMethod];
    } forControlEvents:UIControlEventTouchUpInside];
    
}
//认证
- (void)jieBangMethod {
    if (self.myPhoneText.text.length==0) {
        [SVProgressHUD showImage:KGetImage(@"") status:@"姓名不能为空"];
        return;
    }
    if (self.myVcodeText.text.length==0) {
        [SVProgressHUD showImage:KGetImage(@"") status:@"身份证号不能为空"];
        return;
    }
    
//    if (self.carViewZMStr.length<1) {
//        return [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"请上传身份证正面")];
//    }
//    if (self.carViewFMStr.length<1) {
//        return [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"请上传身份证反面")];
//    }
    
    WeakSelf;
    /** 严格串行流程：先向后端初始化活体检测凭证 certifyId */
    [SVProgressHUD show];
    NSDictionary *metaInfoDic = [AliyunFaceAuthFacade getMetaInfo] ?: @{};
    NSString *str = [NSString dictionaryToJson:metaInfoDic] ?: @"";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"name"] = self.myPhoneText.text ?: @"";
    params[@"idcard"] = self.myVcodeText.text ?: @"";
    params[@"metaInfo"] = str;
    [NetworkRequest POST:Request_InitFace parmeters:params success:^(id responObject) {
        [SVProgressHUD dismiss];
        BaseModel *mode = (BaseModel *)responObject;
        NSString *certifyId = nil;
        if ([mode.data isKindOfClass:[NSDictionary class]]) {
            certifyId = mode.data[@"certifyId"];
        } else if ([mode.data isKindOfClass:[NSString class]]) {
            certifyId = (NSString *)mode.data;
        }
        if (certifyId && certifyId.length > 0) {
            [wself CertifyID:certifyId];
        } else {
            NSString *errMsg = mode.msg.length > 0 ? mode.msg : @"获取失败";
            [SVProgressHUD showImage:KGetImage(@"") status:errMsg];
        }
    } failture:^(NSError *error) {
        // NetworkRequest.m already handles HUD error display on failure
    }];
}

- (void)CertifyID:(NSString *)certifyId {
    WeakSelf;
    [AliyunFaceAuthFacade verifyWith:certifyId extParams:@{@"currentCtr":self} onCompletion:^(ZIMResponse * _Nonnull response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (response.code) {
                case ZIMResponseSuccess:{
                    // 1000: 活体刷脸检测成功后，才调用接口真正落库
                    [wself requestShiMing];
                }break;
                case ZIMInterrupt://1003。
                    [SVProgressHUD showImage:KGetImage(@"") status:@"用户退出"];
                    break;
                case ZIMNetworkfail://2002。
                    [SVProgressHUD showImage:KGetImage(@"") status:@"网络错误"];
                    break;
                case ZIMTIMEError: //2003。
                    [SVProgressHUD showImage:KGetImage(@"") status:@"设备时间设置不对"];
                    break;
                case ZIMResponseFail: //2006。
                    [SVProgressHUD showImage:KGetImage(@"") status:@"认证失败"];
                    break;
                case ZIMInternalError://1001。
                    [SVProgressHUD showImage:KGetImage(@"") status:@"初始化失败"];
                    break;
                default:
                    [SVProgressHUD showImage:KGetImage(@"") status:@"认证未完成"];
                    break;
            }
        });
    }];
}

// 活体成功后真正提交落库
- (void)requestShiMing {
    WeakSelf;
    [SVProgressHUD show];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"name"] = self.myPhoneText.text ?: @"";
    parameter[@"idcard"] = self.myVcodeText.text ?: @"";
    parameter[@"face_image"] = @"";
    parameter[@"back_image"] = @"";
    [NetworkRequest POST:user_userRealName parmeters:parameter success:^(id responObject) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showTextHUDWithMessage:@"提交成功"];
        [ObjectTool performSelectorAfterDelay:ALERT_MESSAGE_DISPLAY_INTERVAL completion:^{
            [wself.navigationController popViewControllerAnimated:YES];
        }];
    } failture:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSString *errMsg = error.localizedDescription.length > 0 ? error.localizedDescription : @"提交失败";
        [SVProgressHUD showImage:KGetImage(@"") status:errMsg];
    }];
}

/**
 校验身份证号码是否正确 返回BOOL值

 @param idCardString 身份证号码
 @return 返回BOOL值 YES or NO
 */
- (BOOL)cly_verifyIDCardString:(NSString *)idCardString {
    NSString *regex = @"^[1-9]\\d{5}(18|19|([23]\\d))\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isRe = [predicate evaluateWithObject:idCardString];
    if (!isRe) {
         //身份证号码格式不对
        return NO;
    }
    //加权因子 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2
    NSArray *weightingArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    //校验码 1, 0, 10, 9, 8, 7, 6, 5, 4, 3, 2
    NSArray *verificationArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    NSInteger sum = 0;//保存前17位各自乖以加权因子后的总和
    for (int i = 0; i < weightingArray.count; i++) {//将前17位数字和加权因子相乘的结果相加
        NSString *subStr = [idCardString substringWithRange:NSMakeRange(i, 1)];
        sum += [subStr integerValue] * [weightingArray[i] integerValue];
    }
    
    NSInteger modNum = sum % 11;//总和除以11取余
    NSString *idCardMod = verificationArray[modNum]; //根据余数取出校验码
    NSString *idCardLast = [idCardString.uppercaseString substringFromIndex:17]; //获取身份证最后一位
    
    if (modNum == 2) {//等于2时 idCardMod为10  身份证最后一位用X表示10
        idCardMod = @"X";
    }
    if ([idCardLast isEqualToString:idCardMod]) { //身份证号码验证成功
        return YES;
    } else { //身份证号码验证失败
        return NO;
    }
}
@end
