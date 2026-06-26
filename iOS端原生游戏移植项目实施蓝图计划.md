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

## 🎨 2. UI 布局尺寸与绝对定位常量矩阵

为了规避视觉感官误差，iOS 端在使用 `Masonry` 或 `Frame` 布局时，必须直接绑定并对齐以下参数：

### 2.1 玩法2（神木栖灵）9个灵果（桃子）定位坐标与显示规范
* **背景大图比例**：以 $750 \times 1311$ 像素（等价于 iOS `@3x`）为设计基准大图。
* **物理位置映射**：在 `layoutSubviews` 之后基于背景图的 `AspectFit` 实际 CGRect 进行转换。
* **9个灵果坐标常量矩阵**：
  ```objc
  // 在 MLChatRoomThemeGameTwoView.m 中声明 of 绝对定位常量 (设计值)
  static const CGPoint PEACH_COORDS[] = {
      {385.0f, 330.0f}, // 灵果 1
      {205.0f, 450.0f}, // 灵果 2
      {585.0f, 460.0f}, // 灵果 3
      {425.0f, 560.0f}, // 灵果 4
      {100.0f, 610.0f}, // 灵果 5
      {635.0f, 695.0f}, // 灵果 6
      {270.0f, 680.0f}, // 灵果 7
      {130.0f, 760.0f}, // 灵果 8
      {470.0f, 830.0f}  // 灵果 9
  };

  // 原始设计大小 (宽度 = 高度)
  static const CGFloat PEACH_SIZES[] = {
      105.0f, 75.0f, 75.0f, 60.0f, 65.0f, 70.0f, 60.0f, 65.0f, 80.0f
  };

  // 渲染时额外物理缩放系数
  static const CGFloat PEACH_RENDER_SCALE_FACTOR = 0.6f;
  ```
* **灵果交互与渲染细则**：
  * **无点击手势**：树上挂载的 9 个灵果控件**纯粹作为静态奖池展示挂件，不需要任何点击响应手势**。用户点击树上灵果不会触发单抽，抽奖动作完全由底部的祝灵按钮（1/10/100抽）发起。
  * **动态奖品加载**：进入页面调用 `/api/emo/lottery/get_prizes` 后，使用 `YYWebImage` 或 `SDWebImage` 将返回的 9 个礼物的**真实网络图**（`pic` / `image` 字段）动态渲染到大树对应的 9 个灵果控件上展示。
  * **移除旧版居中控件**：旧版预览壳子中的 `theme_game_two_center_fruit.png` 和 `theme_game_two_center_frame.png`（居中果实及边框）**已被客户确认砍掉**，iOS 落地时**无需**绘制这两个居中控件。

### 2.2 玩法1（寻梦之旅）格子与按钮布局约束
* **18宫格礼物卡片大小**：固定为宽 `46` pt，高 `60` pt。
* **卡片排布间距**：水平间距 `8` pt，垂直间距 `6` pt。
* **卡片环形排布**：
  * **顶部横排 6 个**：索引 0 ~ 5 (对应格子 1 ~ 6)。
  * **右侧竖排 2 个**：索引 6 ~ 7 (对应格子 7 ~ 8)。
  * **底部横排 6 个**：索引 8 ~ 13 (对应格子 9 ~ 14)。
  * **左侧竖排 2 个**：索引 14 ~ 17 (对应格子 15 ~ 18)。
* **底部抽奖品字按钮组**：
  * 按钮大小统一为：宽 `112` pt，高 `56` pt。
  * 顶部居中：“十运齐聚”按钮（10连抽，对应 `theme_game_one_draw_ten.png`）。
  * 左下与右下对称分布：“一星纳福”与“百祥落盘”，与顶部按钮的垂直间距为 `12` pt。

### 2.3 弹窗组件规格 (Popups)
* **购买钥匙弹窗**：背景大小宽 `315` pt，高 `360` pt。确认按钮大小 `260 * 86` pt。
* **结果展示弹窗**：背景大小宽 `315` pt，高 `470` pt。再抽一次按钮宽 `160` pt，高 `32` pt。

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

---

## 📐 4. 核心重难点算法 OC 实现模板

### 4.1 UIImageView 高精度定位换算
在 `layoutSubviews` 刷新完毕后调用，换算 AspectFit 下的物理 `center`：
```objc
- (CGPoint)ml_calculatePhysicalCenterWithDesignX:(CGFloat)designX 
                                         designY:(CGFloat)designY 
                                     designWidth:(CGFloat)designWidth 
                                    designHeight:(CGFloat)designHeight {
    if (self.image == nil) {
        CGFloat scaleX = self.bounds.size.width / designWidth;
        CGFloat scaleY = self.bounds.size.height / designHeight;
        return CGPointMake(designX * scaleX, designY * scaleY);
    }
    
    CGSize viewSize = self.bounds.size;
    CGFloat scale = MIN(viewSize.width / designWidth, viewSize.height / designHeight);
    
    CGFloat transX = (viewSize.width - designWidth * scale) / 2.0;
    CGFloat transY = (viewSize.height - designHeight * scale) / 2.0;
    
    CGFloat physicalX = designX * scale + transX;
    CGFloat physicalY = designY * scale + transY;
    
    return CGPointMake(physicalX, physicalY);
}
```

### 4.2 跑马灯二次方指数减速步进
在网络数据返回，拿到大奖的终点索引后，无缝接续减速：
```objc
- (void)startDeceleratingStepWithStepIndex:(NSInteger)step 
                               totalSteps:(NSInteger)totalSteps 
                             minDelayTime:(NSTimeInterval)minDelay 
                             maxDelayTime:(NSTimeInterval)maxDelay {
    if (step >= totalSteps) {
        [self showResultDialog]; // 定格，销毁时钟，弹出结算页
        return;
    }
    
    NSInteger highlightIndex = (self.currentStartIndex + step) % 18;
    [self highlightGiftViewAtIndex:highlightIndex];
    
    NSTimeInterval nextDelay = minDelay;
    NSInteger decayStartStep = totalSteps - 10; // 倒数 10 步开始插值减速
    if (step >= decayStartStep) {
        NSInteger progress = step - decayStartStep;
        nextDelay = minDelay + (maxDelay - minDelay) * pow((double)progress / 10.0, 2.0); // 二次方衰减
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(nextDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startDeceleratingStepWithStepIndex:step + 1 
                                     totalSteps:totalSteps 
                                   minDelayTime:minDelay 
                                   maxDelayTime:maxDelay];
    });
}
```

### 4.3 中奖礼物有序去重合并
iOS 端使用 `NSMutableArray` (记录添加顺序) + `NSMutableDictionary` (处理去重累加) 对齐安卓的 `LinkedHashMap`，避免连抽礼物在结果页刷屏：
```objc
// MLGameDrawResultModel 需要实现 <NSCopying> 并在 .m 中补充 mj_replacedKeyFromPropertyName 重映射关系
+ (NSArray<MLGameDrawResultModel *> *)mergeAndSortDrawGifts:(NSArray<MLGameDrawResultModel *> *)drawResultList {
    if (drawResultList == nil || drawResultList.count == 0) return @[];
    
    NSMutableArray *orderedIds = [NSMutableArray array];
    NSMutableDictionary<NSNumber *, MLGameDrawResultModel *> *mergedDict = [NSMutableDictionary dictionary];

    for (MLGameDrawResultModel *item in drawResultList) {
        NSNumber *itemId = @(item.giftId);
        if (mergedDict[itemId]) {
            mergedDict[itemId].num += item.num; // 累加数量
        } else {
            [orderedIds addObject:itemId];
            mergedDict[itemId] = [item copy]; // 执行深拷贝防止篡改源数据
        }
    }

    NSMutableArray<MLGameDrawResultModel *> *resultArray = [NSMutableArray array];
    for (NSNumber *itemId in orderedIds) {
        if (mergedDict[itemId]) {
            [resultArray addObject:mergedDict[itemId]];
        }
    }
    return [resultArray copy];
}
```

---

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
