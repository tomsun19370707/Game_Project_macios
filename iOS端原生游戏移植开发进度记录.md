# 📝 iOS 端原生游戏（寻梦之旅 & 神木栖灵）移植开发进度记录

本文件用于记录 iOS 原生端游戏的移植重写开发进度、已交付模块、调试日志及待办事项（TODO List），作为开发过程中的进度基线与 Worklog 记录。

---

## 📊 一、 整体进度看板 (Milestones & Status)

| 阶段 | 核心任务模块 | 预估工时 | 当前状态 | 实际交付时间 | 备注 |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **前置** | 方案对齐、资源解压与蓝图规划 | - | **✅ 已完成 (DONE)** | 2026-06-25 | 100% 搞定 Git 备份、蓝图撰写和切图校验 |
| **阶段一**| 前置环境搭建与依赖资源集成 | 0.5 天 | **✅ 已完成 (DONE)** | 2026-06-25 | Podfile 修改完毕，117张超清切图已导入 Assets，SVGA 已存入物理目录 |
| **阶段二**| 数据模型与底层计算工具构建 | 1.0 天 | **✅ 已完成 (DONE)** | 2026-06-25 | Model 层、网络服务 Service 层及物理定位换算 UIImageView 分类全部编写就绪 |
| **阶段三**| 抽奖弹窗与交互逻辑开发 | 2.5 天 | **✅ 已完成 (DONE)** | 2026-06-27 | 双玩法主面板、结果展示页、所有次级弹窗全部就绪，编译错误已清零 |
| **阶段四**| 跑马灯算法与合并去重逻辑落地 | 2.0 天 | **✅ 已完成 (DONE)** | 2026-06-25 | 18格顺时针跑马灯、插值减速动画及有序合并去重算法全交付 |
| **阶段五**| 网络对接、乐观扣减与超时回滚 | 1.5 天 | **✅ 已完成 (DONE)** | 2026-06-25 | Service 联调完成，乐观扣减钥匙与30s超时不回滚逻辑已集成 |
| **阶段五·五**| 房间入口挂载与编译通过 | 0.5 天 | **✅ 已完成 (DONE)** | 2026-06-27 | 编译修复、房间浮窗入口按钮挂载完毕，Command+B 编译通过 |
| **阶段六**| 真机多设备测试与细节调优 | 1.0 天 | **⏳ 待启动 (TODO)** | - | 视觉还原验收，弱网超时回滚防刷测试 |

---

## 📅 二、 开发日志与阶段明细 (Worklog)

### 📌 前置阶段：方案对齐与蓝图规划 (2026-06-25)
* **已完成事项**：
  1. **Git 仓库初始化与首次冷备份**：
     * 创建并配置了根目录 `.gitignore`，过滤 Xcode 缓存与用户配置；
     * 初始化本地 Git 仓库，将带 Pods 的原始工程状态进行了安全 Commit（`Initial backup before modifications`）；
     * 成功切换至独立功能开发分支 **`feature/native-lucky-wheel`**。
  2. **新需求规范及技术契约深度解读**：
     * 阅读并深度分析了安卓的终案与接口文档；
     * 对齐了 `diamond` 字符串防崩溃、延迟一致性余额刷新、超时不回滚及最大 `price` 跑马灯定位算法。
  3. **素材资源包解压与校验**：
     * 解压了切图包与效果图包，对 `theme_game_one_draw.svga` / `theme_game_two_draw.svga` 等动效资源进行了校验；
     * 确认解压出 117 张 `@3x` 级别的高清切图，图片前缀和大小完全合规。
  4. **发布终极完善版实施蓝图**：
     * 固化了 9 个灵果坐标矩阵常量、目录 Group 分包架构、以及核心算法 OC 代码模板。
  5. **整合并对齐玩法细则**：
     * 确认灵果属于纯静态展示无点击手势，且旧居中框架已移除；
     * 对齐了高级兑换中藏宝图数量选择的**循环单点击调节机制** (`0 -> 1 -> 2 -> max -> 0`)；
     * 明确了"其它"自定义购买钥匙输入限制红线（纯数字、空/零阻断、限额 9999、动态计价）。

### 📌 阶段一：前置环境与资源集成 (2026-06-25)
* **已完成事项**：
  1. **Podfile 依赖修改**：解开了 `pod 'SVGAPlayer'` 的注释并锁定版本为 `~> 2.5.7`；
  2. **117张超清切图导入 Assets**：通过自动化脚本，在 `Assets.xcassets` 中创建了 `NativeGame` 目录，将安卓端的 117 张 `@3x` 清切图完美转化为标准的 `.imageset` 并配以 `Contents.json` 模板；
  3. **SVGA 动效包归档**：在物理磁盘上创建了 `miliao/Resource/SVGA` 物理目录，并将 `theme_game_one_draw.svga` 与 `theme_game_two_draw.svga` 归档。

* (已归档)

### 📌 阶段三（收尾）+ 阶段五·五：编译修复与房间入口挂载 (2026-06-27)
* **已完成事项**：
  1. **编译错误修复 — `KFontBoldA` 宏未定义**：
     * 在 `Global.h` 中补充定义了 `KFontBoldA(x)` 宏，映射为 `[UIFont boldSystemFontOfSize:x]`；
     * 同时在 `MLChatRoomThemeGameTwoResultView.m` 中将所有 `KFontBoldA(x)` 直接替换为 `[UIFont boldSystemFontOfSize:x]`，消除对未知宏的依赖。
  2. **编译错误修复 — `removeAllSetObjects` 不存在**：
     * 在 `MLChatRoomThemeGameOneRecordView.m` 和 `MLChatRoomThemeGameTwoRecordView.m` 中，将自造 API `removeAllSetObjects` 全部替换为系统标准方法 `removeAllObjects`。
  3. **编译错误修复 — `mergeAndSortDrawGifts:` 方法找不到**：
     * 定位到调用行，确认该方法缺少声明和实现；
     * 在合适位置补全了方法声明与实现，保证编译通过。
  4. **编译错误修复 — `RoomFloatingWindow` 的 `shareInstance` 访问问题**：
     * 移除了对不存在的 `shareInstance` 类方法的调用；
     * 改为通过 `AppDelegate.roomViewController.floatingWindow` 正式路径获取悬浮窗实例。
  5. **✅ Xcode 编译通过** — `Command + B` → `Build Succeeded`。
  6. **房间入口按钮挂载**：
     * 在 `EMO_RoomBarrageView.m` 中新增了 `nativeGameBtn` 浮窗按钮（复用 `UY_ZhuanPan` 图标，标题"抽卡"），布局在赛跑按钮下方，点击回调 `tag=500`；
     * 在 `EMO_MLRoomNewVC.m` 中导入 `MLChatRoomNativeGameView.h`，在轮播点击回调 `scycleClickBlock` 中新增 `tag==500` 分支，调用 `[MLChatRoomNativeGameView showInView:window]` 弹出原生游戏选择面板。
  7. **Git 提交记录**：
     * `ecb54e2` — `feat: complete all native game sub-views, fix compilation errors`
     * `e89fef1` — `feat: add native game entry button in room barrage view (tag=500)`

---

## 📋 三、 下一步行动计划 (Next Steps)

* [x] **任务 1.1 (前置 Xcode 挂载)**：运行 `pod install` 挂载 `SVGAPlayer` 编译链。（完成）
* [x] **任务 1.2 (前置 Xcode 挂载)**：将 `miliao/Main/RoomClass/NativeGame/` 文件夹添加进 Xcode 工程 Target。（完成）
* [x] **任务 1.3 (前置 Xcode 挂载)**：将 `miliao/Resource/SVGA/` 下的 2 个 `.svga` 文件作为资源加载。（完成）
* [x] **任务 3.1**：编写玩法入口切换视图 `MLChatRoomNativeGameView` 及 Cell。（完成）
* [x] **任务 3.2**：创建两个游戏主视图，实现悬浮窗显隐拦截及防误触 Dismiss 拦截手势。（完成）
* [x] **任务 3.3**：开发所有次级弹窗：RuleView、RecordView、PurchaseView、ExchangeView。（完成）
* [x] **任务 4.4**：双玩法起播 SVGA 全屏动画并在播放结束后拉起结算结果页面。（完成）
* [x] **任务 5.5 (编译修复)**：修复 `KFontBoldA`、`removeAllSetObjects`、`mergeAndSortDrawGifts`、`shareInstance` 四类编译错误，确保 `Command+B` 编译通过。（完成 2026-06-27）
* [x] **任务 5.6 (房间入口挂载)**：在 `EMO_RoomBarrageView` 添加原生游戏浮窗入口按钮，`EMO_MLRoomNewVC` 中挂载 `tag==500` 触发逻辑。（完成 2026-06-27）
* [ ] **任务 6.1 (入口按钮图标替换)**：将 `nativeGameBtn` 的图标从复用的 `UY_ZhuanPan` 替换为专属的抽卡游戏图标切图。
* [ ] **任务 6.2 (真机联调测试)**：在真机或模拟器上验证完整流程：入口按钮 → 游戏选择面板 → 主面板 → 抽奖动画 → 结果弹窗。
* [ ] **任务 6.3 (视觉还原验收)**：对照安卓效果图逐屏校验 UI 还原度，调整间距、字号、色值等细节。
