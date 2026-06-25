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
    
    WeakSelf
    /** 调用接口，后台审核*/
    /** para*/
    NSMutableDictionary *parameter =[NSMutableDictionary dictionary];
    parameter[@"name"] = self.myPhoneText.text;
    parameter[@"idcard"] = self.myVcodeText.text;
    parameter[@"face_image"] = @"";
    parameter[@"back_image"] = @"";
//    parameter[@"face_image"] = self.carViewZMStr;
//    parameter[@"back_image"] = self.carViewFMStr;
    [NetworkRequest POST:user_userRealName parmeters:parameter success:^(id responObject) {
        [SVProgressHUD showTextHUDWithMessage:@"提交成功"];
        [ObjectTool performSelectorAfterDelay:ALERT_MESSAGE_DISPLAY_INTERVAL completion:^{
            [wself backClick];
        }];
    } failture:^(NSError *error) {
        
    }];
    
    
    /** 继续活体*/
    [SVProgressHUD show];
    NSString *str = [NSString dictionaryToJson:[AliyunFaceAuthFacade getMetaInfo]];
    [NetworkRequest POST:Request_InitFace parmeters:@{@"name":self.myPhoneText.text,@"idcard":self.myVcodeText.text,@"metaInfo":str} success:^(id responObject) {
        [SVProgressHUD dismiss];
        BaseModel *mode=(BaseModel *)responObject;
        [wself CertifyID:mode.data[@"certifyId"]];
    } failture:^(NSError *error) {
        [SVProgressHUD dismiss];
   
    }];
}
-(void)CertifyID:(NSString *)certifyId{
    WeakSelf;
    [AliyunFaceAuthFacade verifyWith:certifyId extParams:@{@"currentCtr":self} onCompletion:^(ZIMResponse * _Nonnull response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *title = @"认证已完成";
                    switch (response.code) {
                        case ZIMResponseSuccess:{
                            //1000。
                            [wself requestShiMing];
                        }break;
                        case ZIMInterrupt://1003。
                            title = @"用户退出";
                            break;
                        case ZIMNetworkfail://2002。
                            title = @"网络错误";
                            break;
                        case ZIMTIMEError: //2003。
                            title = @"设备时间设置不对";
                            break;
                        case ZIMResponseFail: //2006。
                            title = @"认证失败";
                            break;
                        case ZIMInternalError://1001。
                            title = @"初始化失败";
                            break;
                        default:
                            break;
                    }
            [SVProgressHUD showImage:KGetImage(@"") status:title];
            });
    }];
}

//实名认证
-(void)requestShiMing{
    [NetworkRequest POST:Request_userNameAuthentication parmeters:@{@"name":self.myPhoneText.text,@"idcard":self.myVcodeText.text,@"face_image":self.carViewZMStr,@"back_image":self.carViewFMStr} success:^(id responObject) {
        [SVProgressHUD dismiss];
        BaseModel *baseModel = (BaseModel *)responObject;
        [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:baseModel.msg]];
        [self.navigationController popViewControllerAnimated:YES];

    } failture:^(NSError *error) {
        [SVProgressHUD dismiss];
   
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
