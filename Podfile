# Uncomment the next line to define a global platform for your project
# platform :ios, '9.1'
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '12.0'

#inhibit_all_warnings
!
target 'miliao' do
  use_frameworks!
  
pod "AFNetworking"
#pod "FMDB"
pod "MJRefresh"
pod 'SVProgressHUD'
pod 'YYKit'
#pod 'CRBoxInputView'
pod "MJExtension"
#pod 'AgoraRtcEngine_iOS','~> 2.4.1' #安装的版本(3.7.1)视频通话
pod 'AgoraAudio_iOS' #,'~> 3.7.1'#, 安装的版本(3.7.1)语音通话

pod "Masonry"
#pod 'BlocksKit', '~> 2.2.5'
#pod 'SVGAPlayer'
pod 'Protobuf', '3.9.0'
pod 'SSZipArchive'
pod 'UMCCommon'
pod 'UMDevice'
pod 'UMCPush'
pod 'UMAPM'
pod 'UMCShare/Social/ReducedWeChat'
pod 'UMCShare/Social/ReducedQQ'
#支付
#pod 'AlipaySDK-iOS'
pod 'WechatOpenSDK'
#pod 'RongCloudIM/IMKit','~> 5.2.4'   #// 即时通讯基础 UI 组件 5.2.4版本
#pod 'RongCloudIM/IMLib','~> 5.2.4'  # // 即时通讯基础能力 5.2.4版本

pod 'RongCloudOpenSource/IMKit'#5.4.1

pod 'SDWebImage'
pod 'HWPopController', '~> 1.0.5'
pod 'SDCycleScrollView'
pod 'TYCyclePagerView'
#pod 'Bugly'
pod 'TZImagePickerController'#相册选择
pod 'ReactiveObjC'
pod 'BRPickerView'#时间选择
pod 'WMZPageController' #分页控制器

pod 'AMap2DMap-NO-IDFA'   #5.6.1
pod 'AMapLocation-NO-IDFA'   #2.9.0
pod 'AMapSearch-NO-IDFA'  #9.3.1

pod 'TTTAttributedLabel', '~> 2.0.0'


pod 'libOpenInstallSDK'


end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end
end

