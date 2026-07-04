# 🗺️ iOS 端原生游戏（寻梦之旅 & 神木栖灵）移植项目实施蓝图计划 (终极完善版)

本实施蓝图计划基于双端研发团队对齐的最新共识，深度整合了安卓端提供的最新 [UI布局尺寸与标注表.md](file:///Users/ssl/iosWorkSpace/CFChatRoom/iOS%E7%AB%AF%E5%8E%9F%E7%94%9F%E6%B8%B8%E6%88%8F%E7%A7%BB%E6%A4%8DUI%E5%B8%83%E5%B1%80%E5%B0%BA%E5%AF%B8%E4%B8%8E%E6%A0%87%E6%B3%A8%E8%A1%A8.md)、[新原生游戏后端接口对接指南.md](file:///Users/ssl/iosWorkSpace/CFChatRoom/%E6%96%B0%E5%8E%9F%E7%94%9F%E6%B8%B8%E6%88%8F%E5%90%8E%E7%AB%AF%E6%8E%A5%E5%8F%A3%E5%AF%B9%E6%8E%A5%E6%8C%87%E5%8D%97.md) 以及解压的 117 张切图与 SVGA 动效包，旨在为 iOS 端开发团队提供一站式、零视觉感官误差、零字段类型坑点的终极工程落地指导。

---

## 📂 1. 项目物理与 Xcode 目录结构规范

为了维持代码的可维护性，iOS 端将在 `CFChatRoom/miliao/Main/RoomClass/` 目录下新建独立的 **`NativeGame/`** Group，所有源文件与子文件夹结构必须严格按下表镜像映射：

```text
CFChatRoom/miliao/Main/RoomClass/NativeGame/
├── Entry/                                  # 抽奖入口选择弹窗
│   ├── MLChatRoomNativeGameView.h          # 入口 Dialog 视图
│   ├── MLChatRoomNativeGameView.m
│   ├── MLChatRoomNativeGameCell.h          # 列表项目 Cell
│   └── MLChatRoomNativeGameCell.m
│
├── GameOne/                                # 玩法1（寻梦之旅，type_id = 3）
│   ├── MLChatRoomThemeGameOneView.h        # 游戏主面板 (包含 18 宫格跑马灯)
│   ├── MLChatRoomThemeGameOneView.m
│   ├── MLChatRoomThemeGameOneRuleView.h    # 规则页弹窗
│   ├── MLChatRoomThemeGameOneRuleView.m
│   ├── MLChatRoomThemeGameOneRecordView.h  # 历史记录明细弹窗
│   ├── MLChatRoomThemeGameOneRecordView.m
│   ├── MLChatRoomThemeGameOnePurchaseView.h# 钥匙购买弹窗
│   ├── MLChatRoomThemeGameOnePurchaseView.m
│   ├── MLChatRoomThemeGameOneResultView.h  # 结果展示弹窗
│   ├── MLChatRoomThemeGameOneResultView.m
│   ├── MLChatRoomThemeGameOneExchangeView.h# 藏宝图高级兑换弹窗
│   └── MLChatRoomThemeGameOneExchangeView.m
│
├── GameTwo/                                # 玩法2（神木栖灵，type_id = 4）
│   ├── MLChatRoomThemeGameTwoView.h        # 游戏主面板 (包含 9 个灵果定位)
│   ├── MLChatRoomThemeGameTwoView.m
│   ├── MLChatRoomThemeGameTwoRuleView.h    # 规则页弹窗
│   ├── MLChatRoomThemeGameTwoRuleView.m
│   ├── MLChatRoomThemeGameTwoRecordView.h  # 历史记录明细弹窗
│   ├── MLChatRoomThemeGameTwoRecordView.m
│   ├── MLChatRoomThemeGameTwoPurchaseView.h# 钥匙购买弹窗
│   ├── MLChatRoomThemeGameTwoPurchaseView.m
│   ├── MLChatRoomThemeGameTwoResultView.h  # 结果展示弹窗
│   └── MLChatRoomThemeGameTwoResultView.m
│
└── Model/                                  # 双端通用数据 Model 与 API 服务层
    ├── MLGameLotteryService.h              # 统一接口请求封装类 (AFNetworking)
    ├── MLGameLotteryService.m
    ├── MLGameLotteryInfoModel.h            # 玩法详情与余额数据模型
    ├── MLGameLotteryInfoModel.m
    ├── MLGameDrawResultModel.h             # 抽奖结果数据模型 (实现 NSCopying)
    └── MLGameDrawResultModel.m
```

---

## 🎨 2. UI 布局自适应与比例适配方案

为了解决不同屏幕设备（普通手机与 iPad/平板/折叠屏）上的自适应缩放问题，iOS 端统一采用“锁定高宽比底座 + 自适应缩放宏 + 设备边界限宽”的设计体系：

### 2.1 自适应比例宏 KDialogAdaptedWidth
在游戏主页面（如 `MLChatRoomThemeGameOneView.m` 等）头部引入专用的弹窗比例缩放宏：
```objc
#define KDialogAdaptedWidth(x) (isPadA ? ceilf((x) * (390.0 / 375.0)) : KAdaptedWidth(x))
```
*   **普通手机端 (iPhone)**：缩放因子根据实际物理屏幕宽度与设计宽度 `375.0` 计算，横向 100% 铺满适配。
*   **平板与宽屏折叠屏端 (iPad)**：将游戏面板的最大宽度强行锁定在 `390 pt`，比例因子锁定为 `390.0 / 375.0 = 1.04` 倍，游戏面板在屏幕中等比例缩放并居中，防止过度拉伸变形。

### 2.2 核心底板 _bgImageView 的自适应约束
大背景图高宽比硬性锁定为切图的 `1136.0 / 740.0`。在 `setupUI` 中进行如下约束：
```objc
[_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.mas_equalTo(self);
    if (isPadA) {
        make.width.mas_equalTo(390);
    } else {
        make.width.mas_equalTo(self);
    }
    make.height.mas_equalTo(_bgImageView.mas_width).multipliedBy(1136.0 / 740.0);
}];
```

### 2.3 子控件级联自适应约束红线
*   **高内聚定位依赖**：所有主板内部的子控件（如卡片容器、充值余额条、跑马灯等）必须**直接作为 `_bgImageView` 的子视图（addSubview）**，且其约束只能相对 `_bgImageView` 或同级兄弟控件定位，严禁直接与外层全屏容器 `self` 发生约束依赖，实现核心面板的高内聚与解耦。
*   **等比适配覆盖**：子控件的 `top`、`bottom`、`leading`、`trailing` 间距、偏移量以及物理 `size` 统一使用 `KDialogAdaptedWidth(x)` 计算。
*   **关键位置防挤压与遮挡**：在横纵向比例变化时，确保今日运势、规则/记录与跑马灯等顶部组件的垂直顺序。其中跑马灯 `_marqueeLabel` 统一使用 `KDialogAdaptedWidth(62)` 做绝对纵向偏移，规避横向与右上角功能按钮的重叠风险。

---

## 📡 3. 后端 API 路由契约与数据模型映射

所有网络接口统一通过 `MLGameLotteryService` 进行集中管理，各 API 的调用契约及本地模型映射规范如下：

### 3.1 资产计费接口 `/api/emo/user/getMoney`
* **请求头**：`token` 校验。
* **响应报文坑点避空**：
  ```json
  "data": {
    "money": "0.00",
    "diamond": "100.00",
    "lottery_coin": 1000
  }
  ```
  * **红线要求**：`diamond` 钻石余额在 JSON 中是 **String 字符串**（例如 `"100.00"`）。在 iOS 映射模型中必须定义为 `NSString *diamond;`，**绝对严禁**声明为 `NSInteger` 强类型，否则会在数据转换时触发**应用闪退崩溃**。
  * 钥匙余额 `lottery_coin` 在 JSON 中是整型，iOS 映射为 `NSInteger lotteryCoin;`。

### 3.2 玩法动态详情与价格接口 `/api/emo/lottery/get_room_detail`
* **入参**：`id` (玩法对应 type_id：玩法1传 `3`，玩法2传 `4`)。
* **按钮价格动态渲染**：
  必须动态读取回包中 `coin_cost_opt` 数组列表中的 `nums`（抽奖次数）和 `coin_cost`（钥匙消耗），动态绑定到主面板的 1/10/100 抽按钮上，**严禁在前端代码中硬编码单价**。

### 3.3 抽奖执行与大奖落点接口 `/api/emo/lottery/draw`
* **入参**：`type_id` (3 或 4)，`times` (抽奖次数)。
* **多连抽跑马灯落点算法**：
  1. 遍历中奖回包的 `list` 列表，比较每个礼物实体的 `price` 属性，筛选出**其中 `price`（钻石价值）最大的那一个礼物实体**；
  2. 提取该大奖的礼物 ID，与页面初始化时由 `/api/emo/lottery/get_prizes` 获取的 18 格奖池列表做比对；
  3. 查找到该礼物在转盘中对应的物理索引 index（0~17），作为跑马灯插值减速定格的终点。

### 3.4 玩法一特有功能接口
1. **手动刷新 18 格奖池**：`/api/emo/lottery/refresh_pool`。参数为 `type_id = 3`。返回刷新后的 18 格礼物配置并更新界面。
2. **高级兑换配置列表**：`/api/emo/lottery/exchange_config`。
3. **执行藏宝图高级兑换**：`/api/emo/lottery/exchange_gift`。参数为 `exchange_id`，`card_count`。
   * **零藏宝图必败原则**：客户端进行本地安全限制，若 `card_count == 0`，兑换成功率直接设为 `0%`（必定兑换失败，只扣除宝石碎片，不发放目标礼物）。
``

## 🔄 5. 交互状态机、宿主桥接与防刷机制

### 5.1 延迟一致性余额更新 (UX)
* **乐观扣减**：用户点击抽奖的瞬间，本地直接扣除钥匙余额（如 `self.keyBalance -= requiredKeys;`）并刷新 UI，同时将 1/10/100 抽按钮全部设为 `enabled = NO` 锁定状态。
* **延迟更新**：在收到中奖结果到播放动画、弹出结果弹窗期间，**绝对不调用主页面的重载数据接口**。
* **最终一致性**：在结果弹窗被用户手动 **Dismiss** 时，再触发主页面的 `loadData()` 去向服务端拉取真实资产余额进行最终同步。
* **快速连抽**：如果用户在结果弹窗内直接点击“再抽一次”，直接 Dismiss 弹窗并跳过主页的 `loadData()` 请求，直接触发本地乐观扣减并发起下一轮抽奖请求，提供极速顺畅的连抽体验。

### 5.2 钥匙购买不自动关闭与“其它”自定义购买校验
* **连续购买**：在钥匙购买弹窗（`MLChatRoomThemeGameXxxPurchaseView`）中点击确认购买并调用 API 成功后，**不执行 Dismiss 逻辑**，而是在本地扣除钻石，增加钥匙，并调用弹窗内部局部更新余额，实现无缝连续购买。
* **“其它”自定义购买交互与防刷红线**：
  * 点击“其它”按钮时，在弹窗中间动态展示一个原生的 `UITextField` 输入框。
  * **键盘类型限制**：输入框必须设置 `keyboardType = UIKeyboardTypeNumberPad`，只允许输入正整数，过滤非数字字符。
  * **空/零值阻断**：点击“确认购买”时，如果输入框为空或输入为 `0`，直接拦截请求并弹出 Toast 提示：*“请输入购买数量”*。
  * **上限拦截**：单次购买最大数量限制为 **`9999`**。若输入值超过 `9999`，弹出提示：*“单次购买不能超过 9999 个”* 并拦截。
  * **动态计价**：监听输入框 of 文本变化（`EditingChanged`），实时计算更新确认按钮文字：
    $$\text{需要钻石} = \text{输入数量} \times \text{单把钥匙价格(200钻石)}$$

### 5.3 玩法1（寻梦之旅）高级兑换藏宝图调节交互
* **循环切换交互**：因为 UI 布局上没有空间去绘制加减号输入器，采用独特的循环单点击交互：
  * 兑换弹窗右侧展示“X张/去拥有”的藏宝图文本标签作为点击按钮。
  * 用户每点击一次文本，投入的藏宝图数量 `card_count` 在 **`0` 到 `用户当前拥有最大数量`** 之间循环递增切换。例如，拥有 3 张藏宝图时，点击循环路径为：`0 ──► 1 ──► 2 ──► 3 ──► 0`。
  * 根据 `card_count` 实时计算并刷新兑换成功率展示：
    $$\text{成功率} = \min(100, \text{单张成功率} \times \text{card\_count})$$

### 5.4 宿主组件联动
* **隐藏/显示悬浮窗**：
  * 在游戏主面板 `MLChatRoomThemeGameXxxView` 初始化并弹出时，调用 `[[RoomFloatingWindow shareInstance] setHidden:YES];` 隐藏语音聊天悬浮球。
  * 主面板销毁时，重新调用 `[[RoomFloatingWindow shareInstance] setHidden:NO];` 恢复。
* **充值页面跳转**：
  点击钻石旁边的 `+` 按钮，通过路由拉起宿主工程的充值控制器 `WalletRechargeViewController`。

---

## ⏱️ 6. 阶段性实施时间表与验收标准

```
[阶段一: 依赖与资源] ──► [阶段二: 数据模型] ──► [阶段三: 交互与弹窗] ──► [阶段四: 算法与跑马灯] ──► [阶段五: 联调与回滚]
    (0.5 个工作日)            (1.0 个工作日)             (2.5 个工作日)              (2.0 个工作日)              (1.5 个工作日)
```

### 验收交付物与红线指标
* **兼容性红线**：在大/小屏幕 iOS 设备上，9 个灵果完美贴靠树洞，无任何物理漂移。
* **防连击红线**：快速连击抽奖按钮，不能产生第二次网络请求。
* **资产安全红线**：网络超时（30秒）本地余额不回滚并温和提示；其余网络错误本地立刻将扣除的钥匙加回。
* **交互体验红线**：抽奖无 Loading 等待卡顿，点击即转，且关闭弹窗后余额无缝对齐。

---

*本蓝图计划作为后续具体编码工作的技术规范红线，开发团队应严格对照各章节设计完成编码。*
