//
//  Global.h
//  君分时代
//
//  Created by 贠小飞 on 2018/4/10.
//  Copyright © 2018年 贠小飞. All rights reserved.
//


#import "AFNetworking.h"
#import "NetworkRequest.h"//请求
#import "NetTipView.h"//没有网络时显示的View
#import "DZCX_NetAPIPaths.h"//接口
#import "DZCX_MacroManager.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
//#import <FMDB.h>
#import <SVProgressHUD.h>
#import "OpenInstallSDK.h"
//#import "YYModel.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
//#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>
#import <AgoraRtmKit/AgoraRtmKit.h>
#import <AgoraRtcKit/AgoraRtcEngineKit.h>

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "TLKit.h"
//#import <CRBoxInputCellProperty.h>
//#import <CRLineView.h>
//#import <CRBoxInputView.h>
//#import "CRBoxInputCellProperty.h"
//#import "CRLineView.h"
//#import "CRBoxInputView.h"
#import "SVGA.h"
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>
//#import <UMAnalytics/MobClick.h>
//#import <RongIMKit/RongIMKit.h>
#import <RongCloudOpenSource/RongIMKit.h> //融云
#import "SPAlertController.h"
#import "UIViewController+AlertViewAndActionSheet.h"
#import <AlipaySDK/AlipaySDK.h>
//#import <RongIMLib/RongIMLib.h>
#import <TTTAttributedLabel/TTTAttributedLabel.h>

#import "EMO_WebViewController.h"
#import "YJT_NODataView.h"
#import "NSString+Extension.h"
#import "NSString+ExtensionA.h"
//#import "RoomFloatingWindow.h"
//#import "BaiduMobStat.h"

#import "BaseModel.h"
#import "SignInApple.h"
#import <SDWebImage.h>
#import "ScreenSize.h"
#import "ViewFrameGeometry.h"
#import "BaseUIStyle.h"
#import "ControlCreator.h"
#import "AppDelegate.h"
//#import "NavController.h"
#import "NSString+String.h"
#import "NSString+Mobile.h"
#import "ZJUIUtil.h"
#import "CGXPickerView.h"
#import "UIImage+Additions.h"
#import "JXCategoryView.h"
#import "HttpTool.h"
#import "UserManager.h"
#import "MLRoomInformationModel.h"
#import "YBEmojiInputView.h"
#import "NODataView.h"
#import "UIView+Frame.h"
#import "NSDate+Category.h"
#import "UIImage+ImgSize.h"
#import "IAPManager.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "BAButton.h"
#import "YYKit.h"
#import "DSAlert.h"
#import "ShareManager.h"
#import "WTBottomInputView.h"//输入框
#import "ZXNavigationController.h"
#import "ZXTabBarController.h"
#import "EMO_LoginViewController.h"
#import "BWShareView.h"
#import "BWItemModel.h"
#import "ZFAVPlayerManager.h"
#import "ZFPlayerControlView.h"
#import "CustomeBtn.h"

//#import "NSString+AES.h"
//#import "Account.h"
//#import "DNPayAlertView.h"
//#import "HttpTool.h"

//#import "HGBaseViewController.h"

//#import "BRPickerView.h"

#import "TYCyclePagerView.h"
#import "TYPageControl.h"
#import <SDCycleScrollView.h>
#import "JXCategoryTitleView.h"
#import "WMZPageController.h"//分页
#import "SingleInputView.h"//单行文本
#import "JQMultiInputView.h"//多行文本
#import "dgNavView.h"//

#import "PlayerManager.h"
#import "ConvertAudioFile.h"


#import<BRPickerView.h>
///类别
#import "Category.h"
#import "ReactiveObjC.h"
#import "DAConfig.h"
#import "HGDeviceHelper.h"
#import "UIButton+Block.h"
#import "UIButton+Gradient.h"
//#import "XQPersonalViewController.h"
#define kAccountFileName @"kAccountFileName"
#define kPersonId @"user_id"
#define AESKey @""



/** category*/
#import "NSTimer+Addition.h"  
#import "UIView+AdditionsDy.h"
#import "UIColor+BSCustome.h"
#import "UILabel+Addtional.h"
#import "NSString+StringNull.h"
#import "UIButton+ExteralButton.h"
#import "UIView+RectCorner.h"
#import "UIFont+Addition.h"
#import "SVProgressHUD+Addition.h"

#import "TKBottomView.h"

#if DEBUG
#define DLog(...) NSLog(__VA_ARGS__)
#else
#define DLog(...)
#endif

/** 提示框展示时长*/
#define     ALERT_MESSAGE_DISPLAY_INTERVAL     1.5f
/** app*/
#define  AppDelegateInstance    ((AppDelegate *)[UIApplication sharedApplication].delegate)
/** 图片*/
#define  IMAGE(A)   [UIImage imageNamed:A]

#import "ObjectTool.h"
#import "DeviceOpinion.h"
#import "XXMediaUtil.h"
#import "MsgPushUtil.h"
#import "DYActionSheet.h"
#import "DYAlertView.h"
#import "DYSeachBarView.h"
#import "UIScrollView+EmptyDataSet.h"
#import "UITableViewCell+RoundCorner.h"
#import "ModeIndex.h"
#import "WebLoadVc.h"
#import "WebJSVc.h"
#import "DTAutoFitCollectionFlowView.h"
#import "DPlaceholder.h"


/** scheme url*/
#define  APPLICATION_SCHEME   @"cfmChatRoomService"


//#define VERSION_HTTPS_SERVER @""//正式
//#define kAppAgoraKitId @""
//#define NIAPPKey @""


//#define VERSION_HTTPS_SERVER @"https://uyu.jiangkukeji.cn/"//测试域名
//#define VERSION_HTTPS_SERVER @"https://api.emo.group/"//正式域名
//#define VERSION_HTTPS_SERVER @"http://emo.yunqizhongguo.com/"
//#define VERSION_HTTPS_SERVER @"http://cfm.yunqizhongguo.com/"
#define VERSION_HTTPS_SERVER @"https://app.qingle.ink/"  //正式 2026-01-26

#define SRAppDomain @".qingle.ink"

////  Air的测试APP证书
#define kAppAgoraKitToken @"007eJxTYNDMXOQmfEhgg29YSl0t37SgS6fNUq8f/RPOXXtm9VqZTjsFBkMjS/PE1LRUAyMTM5NUE/MkA+M0E4OkNMvkJJNU42SL19rlyQ2BjAwKvEkMjFAI4rMzlKQWlxgYGDEwAAA/oR5u"///测试专用
//  Air的测试APP证书
#define kAppAgoraKitZhengShu @"45081df9304743c9800ebedb27ed0307"///测试专用



//  EMO的测试APPID
//#define kAppAgoraKitId @"c03d9d9b80aa4ba4af81aa3d39d4dd04"///<声网APPK
#define kAppAgoraKitId @"35cddda12f6e4b8b80dfe5bc4685fdaa"///<声网APPK


//#define RONYUNAPPKey @"z3v5yqkbzg4y0"//融云 正式
//#define RONYUNAPPKey @"k51hidwqkxh9b"//融云 测试
// APP Secret:2cLX35SQ4JA
//#define RONYUNAPPKey @"mgb7ka1nmogig"//融云  云启汇申请1
#define RONYUNAPPKey @"lmxuhwaglncbd"//融云  云启汇申请2


#define UMENGAPPKey @"6960c9209a7f37648828fb89"//友盟


#define kIsOpenRoomGiftAnimation @"kIsOpenRoomGiftAnimation"


#define WEIXINAPPKey @"wxc2e41b29908db2f4"
#define WEIXINAPPSecret @"205911e0aef691c801b5a56c29ebae04"

#define QQID @"101813872"
#define QQKey @"8358b3268e4a3153181b2d35f1acafc8"




#define kOpenBoxWithLoacalNotification @"kOpenBoxWithLoacalNotification"

#ifndef Global_h
#define Global_h

#ifdef DEBUG //处于开发阶段

#define MYLog(...) printf("[%s] %s [第%d行]: %s\n", __TIME__ ,__PRETTY_FUNCTION__ ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])

#else//处于发布阶段


#define MYLog(...) printf("[%s] %s [第%d行]: %s\n", __TIME__ ,__PRETTY_FUNCTION__ ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#define MYLog(...)

#endif


#ifdef DEBUG
# define NSLog(FORMAT, ...) printf("\n***************%s:%d***************\n%s\n**********************end**********************\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
# define NSLog(FORMAT, ...)
#endif



#define kTagForItemButton 1000

#define VERSION_HTTPS_SERVER_PATH(PATH) [NSString stringWithFormat:@"%@/%@",VERSION_HTTPS_SERVER,PATH]


// applegate
#define APPDELEGATE (AppDelegate *)[UIApplication sharedApplication].delegate

#define ScreenViewWidth [ScreenSize screenViewWidth]
#define ScreenViewHeight [ScreenSize screenViewHeight]
#define ScreenDesignWidth [ScreenSize screenDesignWidth]
#define Scale [ScreenSize scale]

#define WEAK_SELF __weak typeof(self) weakSelf=self ;

#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

#define NSUserDefault [NSUserDefaults standardUserDefaults]
#define NSUserTake(name) [NSUserDefault objectForKey:name]
#define NSUserRemove(name) [NSUserDefault removeObjectForKey:name]
#define NSUserValueNameA(value,name) [NSUserDefault setObject:value forKey:name]


//适配阿拉伯语言宏定义
#define isRTL() [[NSLocale preferredLanguages].firstObject hasPrefix:@"ug-CN"]||[[NSLocale preferredLanguages].firstObject hasPrefix:@"kk"]||[[NSLocale preferredLanguages].firstObject hasPrefix:@"ar"]

//中文
#define LChinese @"zh-Hans"
//中文繁体
#define LChineseFan @"zh-Hant"
// 中文繁体(台湾)  zh-Hant;
// 中文繁体(香港)  zh-Hant-HK;
//英文
#define LEnglish @"en"
//缅甸语
#define LMM @"my-MM"
//日文
//#define LJPN @"ja-JP"
#define LJPN @"ja"

//图片
#define KGetImage(str)  [UIImage imageNamed:str]
// 判断是否是ipad
#define isPadA ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define KFontBold(R)     BOLDSYSTEMFONT(KAdaptedWidth((isPadA?(R-4):R)))
#define KFont(R)         SYSTEMFONT(KAdaptedWidth((isPadA?(R-4):R)))

#define KFontN(N,R)         SYSTEMFONTA(N,KAdaptedWidth((isPadA?(R-4):R)))
// 字体大小(常规/粗体)
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]

#define SYSTEMFONTA(FONTNAME,FONTSIZE)    [UIFont fontWithName:FONTNAME size:FONTSIZE]

//获取屏幕宽高
#define  kWidth               [[UIScreen mainScreen] bounds].size.width
#define  kHeight              [[UIScreen mainScreen] bounds].size.height
#define   SCREEN_MAX_LENGTH   (MAX(kWidth, kHeight))
#define   SCREEN_MIN_LENGTH   (MIN(kWidth, kHeight))
//像素适配
#define kScreenWidthRatio  (kWidth / 375.0)
#define kScreenHeightRatio (kHeight / 667.0)
#define KAdaptedWidth(x)  ceilf((x) * kScreenWidthRatio)

#define IS_IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define KAdaptedHeight(x) ({\
float height = 0;\
if ([UIScreen instancesRespondToSelector:@selector(currentMode)]) {\
if (IS_IPHONE_X) {\
height = ceilf((x) * kScreenHeightRatio / 812 * 375 * 736 / 414.0);\
}else{\
height = ceilf((x) * kScreenHeightRatio);\
}\
}else{\
height = ceilf((x) * kScreenHeightRatio);\
}\
height;\
})







// 是否是iPhonePorXM
#define IsIphoneP ((ScreenViewWidth==414)?YES:NO)
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断是否是iPhone XR
#define iPhoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断是否是iPhone XS
#define iPhoneXS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断是否是iPhone X Max
#define iPhoneXMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)
// 状态栏的高
#define ZJStatusBarH (IS_IPHONE_NEWX ? 44:20)
// 导航栏的高
#define ZJTopNavH (IS_IPHONE_NEWX ? 88:44)
// 底部导航TabBar的高
#define TabBar_H (IS_IPHONE_NEWX ? (49+34):49)
//底部危险区域高度
#define DBottomDangerArea (IS_IPHONE_NEWX ? 34:0)
#define HOME_INDICATOR_HEIGHT (IS_IPHONE_NEWX ? 34.f : 0.f)

#define IS_IPHONE_NEWX (IS_IOS_11 && IS_IPHONE && (MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) >= 375 && MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) >= 812))
// 颜色R,G,B
#define Color(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
// 背景颜色
#define mainBgColor [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0]

//颜色
#define RGBA(r, g, b ,a)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define RGB(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]
//随机色
#define RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

// 主颜色
#define mainColor [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1]
// 副颜色
#define mainViceColor MHColorFromHexString(@"#333333")
//浅灰色
#define mainQianColor MHColorFromHexString(@"#999999")
#define mainShenColor MHColorFromHexString(@"#666666")
// 随机颜色
#define RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
/// 根据hex 获取颜色
#define MHColorFromHexString(__hexString__) ([ZJUIUtil colorWithHexString:__hexString__])
//#define MLControlsColor  MHColorFromHexString(@"#A837FA")
#define MLControlsColor  MHColorFromHexString(@"#40BBAF")
#define MLBtnBackGroundColor  MHColorFromHexString(@"#81D8CF")
#define MLControlsHuiColor MHColorFromHexString(@"#EEEEEE")
#define MLControlsBaiColor MHColorFromHexString(@"#FFFFFF")
//当前App主题色
#define kColorMain MHColorFromHexString(@"#81D8CF")

//适配黑色模式
#define ML_DarkColor MHColorFromHexString(@"#100D20")
//靓号ID的颜色
#define ML_BrightIDColor MHColorFromHexString(@"81D8CF")

#define PFR @"Helvetica"
#define Font(x) [UIFont fontWithName:PFR size:x]
#define KCFont(__VA_ARGS__) [UIFont fontWithName:@"Helvetica-Bold" size:__VA_ARGS__]
#define FontA @"PingFang-SC-Heavy"
#define FontB @"DINOT-CondMedium"
#define Font1(x) [UIFont fontWithName:FontA size:x]
#define Font2(x) [UIFont fontWithName:FontB size:x]

// 设备名称
#define PERIPHERAL_DEVICE_NAME           @"未填写"


/**
 *  获得图片
 *
 *  @param str_Name 图片名字
 *
 *  @return 返回一个UIImage对象
 */
#define ImageNamed(str_Name) [UIImage imageNamed:str_Name]

#define PageSize 20

/**
 *  UIButton起始Tag 19911022
 */
#define BUTTON_TAG(tag)         (19911022+tag)

/**
 *  UILabel起始Tag 19981022
 */
#define LABEL_TAG(tag)          (19981022+tag)

/**
 *  UIImageView起始Tag 19991022
 */
#define IMAGEVIEW_TAG(tag)      (19991022+tag)


#define ScreenWidth     ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight    ([UIScreen mainScreen].bounds.size.height)


// 十六进制色值 01_06
#define HexColorA(rgbValue,a) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:a]

/*================================COLOR/FONT===============================*/
#pragma mark  -  color

/**
 *  十六进制色值转化
 *
 *  @param rgbValue 当前色值
 *
 *  @return 返回当前UIColor颜色
 */
#define COLOR_HEX_RGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define COLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define kBlackColor         [UIColor blackColor]
#define kDarkGrayColor      [UIColor darkGrayColor]
#define kLightGrayColor     [UIColor lightGrayColor]
#define kWhiteColor         [UIColor whiteColor]
#define kGrayColor          [UIColor grayColor]
#define kRedColor           [UIColor redColor]
#define kGreenColor         [UIColor greenColor]
#define kBlueColor          [UIColor blueColor]
#define kCyanColor          [UIColor cyanColor]
#define kYellowColor        [UIColor yellowColor]
#define kMagentaColor       [UIColor magentaColor]
#define kOrangeColor        [UIColor orangeColor]
#define kPurpleColor        [UIColor purpleColor]
#define kClearColor         [UIColor clearColor]

#define COLOR_F42415 COLOR_HEX_RGB(0xF42415)    //  C1  重要色:用于特别需要强调和突出的文字、按钮和 icon,如页面状态栏与界面相关按钮、icon、提示等
#define COLOR_333333 COLOR_HEX_RGB(0x333333)    //  C2  重要色:用于重要及文字信息、内容标题信息
#define COLOR_477aac COLOR_HEX_RGB(0x477aac)    //  C8  重要色:小面积使用，用于重要链接文字颜色
#define COLOR_999999 COLOR_HEX_RGB(0x999999)    //  C3  一般色:用于辅助、次要的文字信息
#define COLOR_f5f5f5 COLOR_HEX_RGB(0xf5f5f5)    //  C6  较弱色:用于内容区域底色
#define COLOR_e5e5e5 COLOR_HEX_RGB(0xe5e5e5)    //  C5  较弱色:用于分割线
#define COLOR_cccccc COLOR_HEX_RGB(0xcccccc)    //  C7  较弱色:用于特殊说明字体及提示字体
#define COLOR_666666 COLOR_HEX_RGB(0x666666)    //  C4  较弱色:？
#define COLOR_2A9F5D COLOR_HEX_RGB(0x2A9F5D)    //  C4  绿帽子的颜色
#define COLOR_696969 COLOR_HEX_RGB(0x696969)    //  C4  较弱色:？
#define COLOR_477AAC COLOR_HEX_RGB(0x477AAC)    //  C4  较弱色:？
#define COLOR_FF3F24 COLOR_HEX_RGB(0xFF3F24)    //  C4  红色偏橘色:？

#define FONT_18 [UIFont systemFontOfSize:18.f]    //  T1  用在导航栏标题
#define FONT_16 [UIFont systemFontOfSize:16.f]    //  T2  用于筛选标题或戏曲标题
#define FONT_15 [UIFont systemFontOfSize:15.f]
#define FONT_14 [UIFont systemFontOfSize:14.f]    //  T3  用于小标题
#define FONT_13 [UIFont systemFontOfSize:13.f]    //  T4  用于辅助性文字（如唱过人数、歌曲大小、时间等）
#define FONT_12 [UIFont systemFontOfSize:12.f]
#define FONT_11 [UIFont systemFontOfSize:11.f]    //
#define FONT_10 [UIFont systemFontOfSize:10.f]    //  T5  用于辅助性文字（如底部导航栏字体大小或需要特殊说明地方）

#define FONT_24 [UIFont systemFontOfSize:(24.f)]    //  分数
#define FONT_22 [UIFont systemFontOfSize:(22.f)]    //  用于商品价格
#define FONT_20 [UIFont systemFontOfSize:(20.f)]    //  用于商品详情原价格

#define FONT_Medium_20 [UIFont fontWithName:@"PingFangSC-Medium" size:RationEnlarge(20.f)]    //Medium_20加粗
#define FONT_Medium_18 [UIFont fontWithName:@"PingFangSC-Medium" size:RationEnlarge(18.f)]    //Medium_18加粗
#define FONT_Medium_16 [UIFont fontWithName:@"PingFangSC-Medium" size:RationEnlarge(16.f)]    //Medium_16加粗
#define FONT_Medium_15 [UIFont fontWithName:@"PingFangSC-Medium" size:RationEnlarge(15.f)]    //Medium_15加粗
#define FONT_Medium_14 [UIFont fontWithName:@"PingFangSC-Medium" size:RationEnlarge(14.f)]    //Medium_14加粗


/**全局字体*/
#define KFontA(__VA_ARGS__) ([UIFont systemFontOfSize:SFont(__VA_ARGS__)])
#define KFontBoldA(__VA_ARGS__) ([UIFont boldSystemFontOfSize:SFont(__VA_ARGS__)])
#define KCFont(__VA_ARGS__) [UIFont fontWithName:@"Helvetica-Bold" size:__VA_ARGS__]
/**字体比例*/
#define SFont(__VA_ARGS__)  ([UIScreen mainScreen].bounds.size.width/375)*(__VA_ARGS__)


#define KFontBold(R)     BOLDSYSTEMFONT(KAdaptedWidth((isPadA?(R-4):R)))

#define KFontN(N,R)         SYSTEMFONTA(N,KAdaptedWidth((isPadA?(R-4):R)))
// 字体大小(常规/粗体)
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]

#define SYSTEMFONTA(FONTNAME,FONTSIZE)    [UIFont fontWithName:FONTNAME size:FONTSIZE]



// 通过十六进制获取色值
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//变量属性
#define Strong          @property(nonatomic, strong)
#define Weak            @property(nonatomic, weak)
#define Retain          @property(nonatomic, retain)
#define Copy            @property(nonatomic, copy)
#define Assign          @property(nonatomic, assign)
//默认头像
#define defaultionPhotoIcon [UIImage imageNamed:@"未加载头像"]



#define getLanguage(key) [Common getStringWithKey:key]


#define Attribute_Lock          @"Attribute_Lock" //频道9麦位的上锁状态
#define Attribute_Own           @"Attribute_Own" //频道房主信息
#define Attribute_Say           @"Attribute_Say" //频道9麦位的话简开关
#define Attribute_BgImg         @"Attribute_BgImg" //频道的背景图
#define Attribute_Publish       @"Attribute_Publish" //频道的公告
#define Attribute_CoverImg      @"Attribute_CoverImg" //频道的封面图
#define Attribute_Name          @"Attribute_Name" //频道的名称
#define Attribute_Update          @"Attribute_Update" //频道有更新指令



#define PeerMsg_MaiUp  @"PeerMsg_MaiUp"         // 点消息_被远端上麦
#define PeerMsg_MaiDown @"PeerMsg_MaiDown"      // 点消息_被远端下麦
#define PeerMsg_MaiOff @"PeerMsg_MaiOff"        // 点消息_被远端关闭麦
#define PeerMsg_MaiOn @"PeerMsg_MaiOn"          // 点消息_被远端打开麦
#define PeerMsg_AdminOn @"PeerMsg_AdminOn"   //点消息_被远端设为管理员角色
#define PeerMsg_AdminOff @"PeerMsg_AdminOff"// 点消息_被远端取消管理员角色
#define PeerMsg_RoomKick @"PeerMsg_RoomKick"    // 点消息_被远端踢出房间
#define PeerMsg_BlackRoomKick @"PeerMsg_BlackRoomKick"    // 点消息_被远端拉黑踢出房间
#define PeerMsg_ChatOff @"PeerMsg_ChatOff"    // 点消息_被远端禁止发言聊天
#define PeerMsg_ChatOn @"PeerMsg_ChatOn"    // 点消息_被远端解除发言聊天

#define PeerMsg_TimeOn @"PeerMsg_TimeOn"    // 点消息_被远端开启倒计时
#define PeerMsg_TimeOff @"PeerMsg_TimeOff"    // 点消息_被远端关闭倒计时
#define PeerMsg_TimeOver @"PeerMsg_TimeOver"    // 点消息_倒计时结束被下麦



#define  WebLoadPrefixJS  @"<head><meta name='viewport' content='width=device-width,initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no'/><meta http-equiv='content-type' content='text/html; charset=UTF-8'><meta charset='utf-8'><meta name='apple-mobile-web-app-capable' content='yes'><meta name='apple-touch-fullscreen' content='yes'><meta name='apple-mobile-web-app-status-bar-style' content='black'><meta name='format-detection' content='telephone=no'><meta name='format-detection' content='address=no'><style type='text/css'>body{margin: 0px 0;padding: 0px 0;} img{display: block;margin: 0px 0;data-height:435;padding: 0px 0; width: 100%; height:auto;} p{display: block;margin: 0px 0;data-height:435;padding: 0px 0; width: 100%;}</style></head>"



#endif /* Global_h */
