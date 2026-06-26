# 🍎 iOS 端原生游戏移植技术库与接口规范

为了保障 iOS 开发团队在复刻**玩法1（寻梦之旅）**与**玩法2（神木栖灵）**时，能够与 Android 端共享完全一致的代码结构、接口对接逻辑和资产计费防刷规则，特将 [通用开发文档.md](file:///home/pantehr/Downloads/项目/通用开发文档.md) 与 [新原生游戏后端接口对接指南.md](file:///home/pantehr/Downloads/项目/新原生游戏后端接口对接指南.md) 中的核心技术点与避坑准则提炼汇总为本规范：

---

## 📅 一、 iOS 类镜像命名与结构规范 (OC 架构)

为了维持双端可维护性的一致，iOS 端建议将每个玩法独立建包，并采用与 Android 端一一对应的**五大核心 UI 组件类**进行镜像重构：

| Android 核心 Dialog | iOS 对应组件类名规范 (Objective-C) | 对应职责 |
| :--- | :--- | :--- |
| `ChatRoomThemeGameXxxDialog` | `MLChatRoomThemeGameXxxView` | 游戏主面板（资产展示、跑马灯/格子定位、动效播放、事件分发） |
| `ChatRoomThemeGameXxxRuleDialog` | `MLChatRoomThemeGameXxxRuleView` | 玩法规则说明弹窗 |
| `ChatRoomThemeGameXxxRecordDialog` | `MLChatRoomThemeGameXxxRecordView` | 历史记录折叠明细列表弹窗 |
| `ChatRoomThemeGameXxxPurchaseDialog` | `MLChatRoomThemeGameXxxPurchaseView` | 钥匙/代币购买弹窗（带连续购买局部刷新） |
| `ChatRoomThemeGameXxxResultDialog` | `MLChatRoomThemeGameXxxResultView` | 恭喜获得结果页（有序去重合并） |

> **命名红线**：iOS 端的切图、图标及 SVGA 文件必须使用与 Android 端完全相同的命名系统，全部以 `theme_game_xxx_` 为前缀（例如 `theme_game_two_`），严防全局命名冲突。

---

## 🛠️ 二、 iOS 接口对接核心数据类型与避坑陷阱 (Crucial)

双端共享同一套后台 API。iOS 在做网络层解析及数据模型（如使用 `MJExtension`）映射时，须特别防范以下字段的数据类型坑点：

### 1. 个人资产接口 `/api/emo/user/getMoney`
* **钻石余额字段 (`diamond`)**：
  > [!WARNING]
  > **类型陷阱**：后台返回的 `diamond` 字段在 JSON 中为 **String 字符串**（例如 `"100.00"`），而非整型。iOS 定义模型时必须将其声明为 `NSString *`，在需要计算或展示字号时再转换为 `double` / `float`，禁止强类型声明为 `NSInteger` 否则会导致解析错误崩溃。
* **钥匙代币字段 (`lottery_coin`)**：
  返回值为 **Number/Int**（例如 `1000`）。iOS 中对应映射为 `NSInteger lotteryCoin`。

### 2. 接口成功响应状态码对齐
* **统一的 code 规则**：
  在语聊房项目接口规范中，请求成功返回的 `code` 值为 **`1`**（注意：非 200 或 0）；失败时返回 `code == 0`，未登录或失效时返回 `code == 401`。
* **双端对齐拦截**：若发生 `401`，需通过工程统一的导航管理器跳转回登录页清空本地缓存。

### 3. 数据层优先加载 Pic 规则
* **图片防空**：所有接口（包括奖池列表、抽奖结果明细及历史记录）返回的礼物图片字段中，同时存在 `image` 和 `pic`。
* **对齐逻辑**：iOS 端的 UIImageView 在使用 SDWebImage / YYWebImage 加载网络图时，**必须优先读取 `pic` 字段**。若 `pic` 为空或长度为 0，再回滚加载 `image`，防止个别礼物图片不显示。

---

## 🧭 三、 核心联调数据流与定位算法

### 1. 档位价格动态获取 (No Hardcoding)
* 在主页面以及购买弹窗中，单抽、十抽、百抽的代币钥匙消耗值，**严禁在代码中写死为 `200` 或 `2000` 价格**。
* 必须在进入页面时，调用 `/api/emo/lottery/get_room_detail`，动态读取其 `coin_cost_opt` 数组列表中的 `nums` 档位以及对应的 `coin_cost` 消耗，动态绑定渲染至抽奖与购买按钮上。

### 2. 多连抽跑马灯最终落点算法 (Highest Price Anchor)
当用户执行 10 连抽/100 连抽时，接口 `/api/emo/lottery/draw` 返回的 `list` 中将包含多个奖品。iOS 端应按以下逻辑定位跑马灯的停留格子：
1. 遍历接口返回的 `list` 数组，通过比较每一个礼物的 `price` 属性，**检索出其中 `price`（价值）最大的那一个礼物实体**。
2. 提取该最高价值礼物的 `id`，在本地页面初始化时缓存的 `/api/emo/lottery/get_prizes` 奖池列表（含有当前格子的礼物）中进行比对。
3. 查找该 `id` 对应的索引 index（例如 18 格跑马灯的 0~17），将该索引 index 作为跑马灯减速物理定位的终点。

### 3. 玩法 1 藏宝图高级兑换逻辑判定
* 接口 `/api/emo/lottery/exchange_gift` 在执行高级兑换时：
* **零藏宝图必败原则**：客户端必须实现本地控制。当用户在兑换时投入的藏宝图数量 `card_count == 0` 时，系统判定成功率为 `0%`（必定失败，但依然会扣除宝石碎片）。

---

## 📂 四、 iOS 项目物理与 Xcode 目录结构规范

为了规范代码架构和物理文件的管理，iOS 端应在 `CFChatRoom/miliao/Main/RoomClass/`（或主项目的 Room 相关目录下）新建独立的 `NativeGame` Group 及物理文件夹。其目录层级与 Android 包保持镜像映射：

```text
CFChatRoom/miliao/Main/RoomClass/NativeGame/
├── Entry/                              # 抽奖入口选择弹窗
│   ├── MLChatRoomNativeGameView.h      # 入口 Dialog 视图
│   ├── MLChatRoomNativeGameView.m
│   ├── MLChatRoomNativeGameCell.h      # 列表项目 Cell
│   └── MLChatRoomNativeGameCell.m
│
├── GameOne/                            # 玩法1（寻梦之旅）模块
│   ├── MLChatRoomThemeGameOneView.h        # 游戏主面板
│   ├── MLChatRoomThemeGameOneView.m
│   ├── MLChatRoomThemeGameOneRuleView.h    # 规则页
│   ├── MLChatRoomThemeGameOneRuleView.m
│   ├── MLChatRoomThemeGameOneRecordView.h  # 记录页
│   ├── MLChatRoomThemeGameOneRecordView.m
│   ├── MLChatRoomThemeGameOnePurchaseView.h# 购买页
│   ├── MLChatRoomThemeGameOnePurchaseView.m
│   ├── MLChatRoomThemeGameOneResultView.h  # 结果页
│   ├── MLChatRoomThemeGameOneResultView.m
│   ├── MLChatRoomThemeGameOneExchangeView.h# 兑换页
│   └── MLChatRoomThemeGameOneExchangeView.m
│
├── GameTwo/                            # 玩法2（神木栖灵）模块
│   ├── MLChatRoomThemeGameTwoView.h        # 游戏主面板
│   ├── MLChatRoomThemeGameTwoView.m
│   ├── MLChatRoomThemeGameTwoRuleView.h    # 规则页
│   ├── MLChatRoomThemeGameTwoRuleView.m
│   ├── MLChatRoomThemeGameTwoRecordView.h  # 记录页
│   ├── MLChatRoomThemeGameTwoRecordView.m
│   ├── MLChatRoomThemeGameTwoPurchaseView.h# 购买页
│   ├── MLChatRoomThemeGameTwoPurchaseView.m
│   ├── MLChatRoomThemeGameTwoResultView.h  # 结果页
│   └── MLChatRoomThemeGameTwoResultView.m
│
└── Model/                              # 双端通用数据 Model 与 API 联调
    ├── MLGameLotteryService.h          # 统一接口请求封装类
    ├── MLGameLotteryService.m
    ├── MLGameLotteryInfoModel.h        # 初始化信息数据模型
    ├── MLGameLotteryInfoModel.m
    ├── MLGameDrawResultModel.h         # 抽奖结果数据模型
    └── MLGameDrawResultModel.m
```

通过上述结构，使得：
1. **业务边界极度清晰**：GameOne 与 GameTwo 独立，后续任何单独的 UI 迭代不会影响另一套玩法。
2. **符合 iOS 模块化封装规范**：网络请求和模型序列化等底层机制全部被解耦至 `Model/` 下，View 视图类只被设计为通过回调刷新 UI，严防业务代码腐化。
