# CFChatRoom (秘聊/miliao) iOS 社交语音聊天室项目说明文档

CFChatRoom（项目内部代号 `miliao`）是一款高品质、功能完备的 iOS 社交语音聊天室应用程序。项目基于 Objective-C 开发，集成了语音通话、即时通讯、高精地图定位、社交分享、虚拟礼物打赏与扭蛋/倍率盘抽奖等丰富功能，能够为用户提供沉浸式的实时语音社交互动体验。

---

## 📱 功能特性

1. **多人语音聊天室**
   - 接入了 **Agora 语音通话 SDK（AgoraAudio_iOS）**，支持多人高音质实时语音互动、房间麦位控制。
   - 实时房间状态同步与房间悬浮窗功能 (`RoomFloatingWindow`)，让用户在浏览其他页面时仍能保持语音连接。

2. **即时通讯 (IM) 系统**
   - 接入 **融云 IM SDK（RongCloudOpenSource/IMKit）**，支持单聊、群聊、聊天室。
   - 注册了多种自定义消息类型，如 `EMO_APPCustomMessage` (应用自定义消息) 和 `EMO_APPCustomRoomMessage` (房间自定义消息)，满足复杂的社交场景需求。

3. **趣味游戏与虚拟互动**
   - 炫酷的**全屏礼物动效** (`WholeGiftView`)，增强打赏互动仪式感。
   - 趣味扭蛋机、幸运抽奖盘 (`WholeBoxView`, `CFMultiplierGamesVC`) 游戏，丰富聊天室玩法与娱乐性。

4. **支付与账号提现**
   - 深度集成 **微信支付 (WechatOpenSDK)** 与 **支付宝支付 (AlipaySDK)**。
   - 具备完整的用户钱包、充值钻石、背包礼物兑换及提现审核逻辑。

5. **定位与社交分享**
   - 采用 **高德地图 SDK（AMap2DMap-NO-IDFA 等）** 提供无 IDFA 安全的周边定位与搜索功能。
   - 整合了 **友盟 (UMCCommon / UMCShare)** 多平台分享及深度链接拉起功能 (**OpenInstall**)，提供便捷的用户裂变和邀请机制。

---

## 🛠 技术架构与核心依赖

项目采用典型的 **MVC** 软件架构设计，通过 **CocoaPods** 进行三方库与 SDK 依赖管理。

### 核心技术选型

| 依赖库名称 | 功能描述 | 用途分类 |
| :--- | :--- | :--- |
| **AgoraAudio_iOS** | 声网音频 SDK | 多人实时语音聊天、连麦互动 |
| **RongCloudOpenSource/IMKit** | 融云即时通讯 SDK | 单聊、群聊、系统通知与自定义消息 |
| **AFNetworking** | 网络请求组件 | 与服务端 API 的数据通信交互 |
| **YYKit** | 综合工具箱 | 包含富文本、图片异步加载、高效模型解析等全方位支撑 |
| **Masonry** | 自动布局框架 | 优雅的声明式 Auto Layout 界面编写 |
| **ReactiveObjC** | 响应式编程框架 | 处理复杂的界面事件绑定与状态流转 |
| **WechatOpenSDK / AlipaySDK** | 支付与授权 SDK | 微信及支付宝支付、微信快捷登录与分享 |
| **AMap2DMap-NO-IDFA** | 高德无 IDFA 地图服务 | 隐私安全的定位、地理围栏与周边搜索 |
| **UMCCommon / UMCShare / UMCPush** | 友盟全家桶 | 社交分享、统计分析、消息推送与 APM 监控 |
| **libOpenInstallSDK** | OpenInstall SDK | 免填邀请码一键拉起与精准渠道统计 |

---

## 📁 目录结构说明

```text
CFChatRoom/
├── Podfile                 # CocoaPods 依赖配置文件
├── Podfile.lock            # 依赖锁定文件
├── Pods/                   # CocoaPods 第三方库目录
├── miliao.xcworkspace      # Xcode 统一工作空间（推荐打开此文件开发编译）
├── miliao.xcodeproj        # Xcode 单独工程文件
└── miliao/                 # 核心业务代码源目录
    ├── Main/               # 业务模块主目录
    │   ├── BaseClass/      # 基础基类与通用功能 (基类控制器、Alert弹窗组件等)
    │   ├── HomeClass/      # 首页模块 (搜索、排行榜、轮播图等)
    │   ├── RoomClass/      # 语音聊天室核心模块 (麦位管理、房间动效、连麦控制等)
    │   ├── ChatClass/      # 融云聊天会话模块
    │   ├── MineClass/      # "我的" 个人中心模块 (背包、钱包、绑定手机号、系统设置等)
    │   └── Other/          # 应用启动入口 (AppDelegate, main.m, scanCode等)
    ├── SocketRocket/       # WebSocket 底层通信模块
    ├── Expand/             # 扩展分类与全局宏定义 (Global.h, MLNetWorkHelper等)
    ├── Vender/             # 手动集成的第三方库与插件 (如弹幕飘屏、三方特效等)
    └── Resource/           # 静态素材、图片、Assets 与国际化资源
```

---

## 💻 编译与环境搭建

### 1. 编译环境要求
- **操作系统**: macOS 13.0 或更高版本
- **开发工具**: Xcode 14.1 或更高版本
- **依赖管理**: CocoaPods 1.10.0+
- **构建目标**: iOS 12.0 最低支持版本

### 2. 编译准备步骤
1. 打开终端，进入项目根目录：
   ```bash
   cd /Users/ssl/iosWorkSpace/CFChatRoom
   ```
2. 执行依赖安装（项目已预置 Pod 缓存，如需更新或重置可执行）：
   ```bash
   pod install
   ```
3. 双击打开 `miliao.xcworkspace` 文件进入 Xcode。

### 3. Xcode 16 兼容性特别说明
本项目原本配置了 Xcode 16 特有的 `PBXFileSystemSynchronizedRootGroup` 文件系统自动同步功能（用于 `Alerts`、`cell`、`sms` 文件夹）。为了在 **Xcode 14 / 15** 等较低版本的 Xcode 环境下顺利编译，本项目已通过专用脚本进行了平滑向下兼容转换：
- 将所有的 `PBXFileSystemSynchronizedRootGroup` 转换为了传统的 `PBXGroup` 格式。
- 将这些文件夹下的所有源文件（`.h`、`.m`、`.xib` 等）自动注册到了 `project.pbxproj` 中的对应编译阶段（`SourcesBuildPhase` / `ResourcesBuildPhase`）。
- 将工程的 `objectVersion` 恢复为了兼容性极佳的 `56` (Xcode 14 格式)。

---

## 📦 项目编译运行

> [!IMPORTANT]
> **关于构建目标的特别提示（真机限定）**:
> 本项目引入的手动集成动态库 `miliao/Vender/CSVisitorSDK/CSVisitorSDK.framework`（及相关的 `SocketIO`、`Starscream`）为 precompiled **真机单架构库**（只含 `arm64` 真机切片，无 Simulator 专用的 `x86_64` 或 `arm64-simulator` 虚拟切片）。
> 因此，项目**无法支持 iOS 模拟器编译与链接**。请在 Xcode 或命令行编译时，**务必选择真机设备（Any iOS Device / iphoneos）** 进行构建。

### 命令行编译验证

如需通过命令行验证项目是否可以成功编译，请在根目录下执行以下命令（构建真机 Debug 包并跳过签名限制）：

```bash
xcodebuild -workspace miliao.xcworkspace \
           -scheme miliao \
           -configuration Debug \
           -sdk iphoneos \
           CODE_SIGNING_ALLOWED=NO \
           CODE_SIGNING_REQUIRED=NO \
           CODE_SIGN_IDENTITY="" \
           PROVISIONING_PROFILE_SPECIFIER=""
```

### Xcode 界面编译
1. 双击打开 `miliao.xcworkspace`。
2. 选择 Scheme：在 Xcode 顶部选择 `miliao`。
3. 选择运行设备：**不要选择模拟器**，请在真机列表的最上方选择 **"Any iOS Device (arm64)"** 或连接您的真实苹果真机设备。
4. 按下快捷键 `Cmd + B` 开始构建项目。构建成功后，若有真机调试证书，可按 `Cmd + R` 运行应用。

---

## 📝 贡献与修改说明

1. **添加新文件**:
   - 当在 `Alerts`、`cell` 或 `sms` 目录下添加、删除或重命名文件时，由于已转换为标准的 Xcode 物理组，请确保手动在 Xcode 工程导航器中“Add Files to miliao...”以将其加入正确的 Targets 编译，以免出现链接错误。
2. **三方库更新**:
   - 请在修改 `Podfile` 后使用 `pod install` 进行更新，切勿直接手动修改 `Pods/` 目录。
