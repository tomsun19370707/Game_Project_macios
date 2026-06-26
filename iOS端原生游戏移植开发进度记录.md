# 📝 iOS 端原生游戏（寻梦之旅 & 神木栖灵）移植开发进度记录

本文件用于记录 iOS 原生端游戏的移植重写开发进度、已交付模块、调试日志及待办事项（TODO List），作为开发过程中的进度基线与 Worklog 记录。

---

## 📊 一、 整体进度看板 (Milestones & Status)

| 阶段 | 核心任务模块 | 预估工时 | 当前状态 | 实际交付时间 | 备注 |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **前置** | 方案对齐、资源解压与蓝图规划 | - | **✅ 已完成 (DONE)** | 2026-06-25 | 100% 搞定 Git 备份、蓝图撰写和切图校验 |
| **阶段一**| 前置环境搭建与依赖资源集成 | 0.5 天 | **✅ 已完成 (DONE)** | 2026-06-25 | Podfile 修改完毕，117张超清切图已导入 Assets，SVGA 已存入物理目录 |
| **阶段二**| 数据模型与底层计算工具构建 | 1.0 天 | **✅ 已完成 (DONE)** | 2026-06-25 | Model 层、网络服务 Service 层及物理定位换算 UIImageView 分类全部编写就绪 |
| **阶段三**| 抽奖弹窗与交互逻辑开发 | 2.5 天 | **🔄 进行中 (WIP)** | - | 双玩法主面板及结果展示页已就绪，剩余次级弹窗待补全 |
| **阶段四**| 跑马灯算法与合并去重逻辑落地 | 2.0 天 | **✅ 已完成 (DONE)** | 2026-06-25 | 18格顺时针跑马灯、插值减速动画及有序合并去重算法全交付 |
| **阶段五**| 网络对接、乐观扣减与超时回滚 | 1.5 天 | **✅ 已完成 (DONE)** | 2026-06-25 | Service 联调完成，乐观扣减钥匙与30s超时不回滚逻辑已集成 |
| **阶段六**| 真机多设备测试与细节调优 | 1.0 天 | **⏳ 待启动 (TODO)** | - | 视觉还原验收，弱网超时回滚防刷测试 |

---

## 📅 二、 开发日志与阶段明细 (Worklog)

### 📌 前置阶段：方案对齐与蓝图规划 (2026-06-25)
* **已完成事项**：
  1. **Git 仓库初始化与首次冷备份**：
     * 创建并配置了根目录 [.gitignore](file:///Users/ssl/iosWorkSpace/CFChatRoom/.gitignore)，过滤 Xcode 缓存与用户配置；
     * 初始化本地 Git 仓库，将带 Pods 的原始工程状态进行了安全 Commit（`Initial backup before modifications`）；
     * 成功切换至独立功能开发分支 **`feature/native-lucky-wheel`**。
  2. **新需求规范及技术契约深度解读**：
     * 阅读并深度分析了安卓的终案与接口文档（[iOS端原生游戏移植技术库与接口规范.md](file:///Users/ssl/iosWorkSpace/CFChatRoom/iOS%E7%AB%AF%E5%8E%9F%E7%94%9F%E6%B8%B8%E6%88%8F%E7%A7%BB%E6%A4%8D%E6%8A%80%E6%9C%AF%E5%BA%93%E4%B8%8E%E6%8E%A5%E5%8F%A3%E8%A7%84%E8%8C%83.md) / [新原生游戏后端接口对接指南.md](file:///Users/ssl/iosWorkSpace/CFChatRoom/%E6%96%B0%E5%8E%9F%E7%94%9F%E6%B8%B8%E6%88%8F%E5%90%8E%E7%AB%AF%E6%8E%A5%E5%8F%A3%E5%AF%B9%E6%8E%A5%E6%8C%87%E5%8D%97.md)）；
     * 对齐了 `diamond` 字符串防崩溃、延迟一致性余额刷新、超时不回滚及最大 `price` 跑马灯定位算法。
  3. **素材资源包解压与校验**：
     * 解压了切图包与效果图包，对 `theme_game_one_draw.svga` / `theme_game_two_draw.svga` 等动效资源进行了校验；
     * 确认解压出 117 张 `@3x` 级别的高清切图，图片前缀和大小完全合规。
  4. **发布终极完善版实施蓝图**：
     * 在 [iOS端原生游戏移植项目实施蓝图计划.md](file:///Users/ssl/iosWorkSpace/CFChatRoom/iOS%E7%AB%AF%E5%8E%9F%E7%94%9F%E6%B8%B8%E6%88%8F%E7%A7%BB%E6%A4%8D%E9%A1%B9%E7%9B%AE%E5%AE%9E%E6%96%BD%E8%93%9D%E5%9B%BE%E8%AE%A1%E5%88%92.md) 中，固化了 9 个灵果坐标矩阵常量、目录 Group 分包架构、以及核心算法 OC 代码模板。
  5. **整合并对齐玩法细则**：
     * 阅读并深度分析了 [iOS端原生游戏移植核心玩法细则.md](file:///Users/ssl/iosWorkSpace/CFChatRoom/iOS%E7%AB%AF%E5%8E%9F%E7%94%9F%E6%B8%B8%E6%88%8F%E7%A7%BB%E6%A4%8D%E6%A0%B8%E5%BF%83%E7%8E%A9%E6%B3%95%E7%BB%86%E5%88%99.md)；
     * 确认灵果属于纯静态展示无点击手势，且旧居中框架已移除；
     * 对齐了高级兑换中藏宝图数量选择的**循环单点击调节机制** (`0 -> 1 -> 2 -> max -> 0`)；
     * 明确了“其它”自定义购买钥匙输入限制红线（纯数字、空/零阻断、限额 9999、动态计价）。

### 📌 阶段一：前置环境与资源集成 (2026-06-25)
* **已完成事项**：
  1. **Podfile 依赖修改**：解开了 [#pod 'SVGAPlayer'](file:///Users/ssl/iosWorkSpace/CFChatRoom/Podfile#L23) 的注释并锁定版本为 `~> 2.5.7`；
  2. **117张超清切图导入 Assets**：通过自动化脚本，在 [Assets.xcassets](file:///Users/ssl/iosWorkSpace/CFChatRoom/miliao/Resource/Image/Assets.xcassets) 中创建了 `NativeGame` 目录，将安卓端的 117 张 `@3x` 清切图完美转化为标准的 `.imageset` 并配以 `Contents.json` 模板；
  3. **SVGA 动效包归档**：在物理磁盘上创建了 `miliao/Resource/SVGA` 物理目录，并将 `theme_game_one_draw.svga` 与 `theme_game_two_draw.svga` 归档。

* (已归档)

---

## 📋 三、 下一步行动计划 (Next Steps)

* [x] **任务 1.1 (前置 Xcode 挂载)**：在你的电脑宿主终端进入工程目录，运行 `pod install` 以把 `SVGAPlayer` 挂载入编译链；（已确认 Xcode 编译通过，pods 正常）
* [x] **任务 1.2 (前置 Xcode 挂载)**：在 Xcode 工程导航中，右键 `RoomClass` Group，选择 **"Add Files to miliao..."**，将物理磁盘上的整个 `miliao/Main/RoomClass/NativeGame/` 文件夹添加进工程 Target；（已关联）
* [x] **任务 1.3 (前置 Xcode 挂载)**：在 Xcode 工程导航中，右键 `Resource` Group，选择 **"Add Files to "..."**，将 `miliao/Resource/SVGA/` 下的 2 个 `.svga` 文件作为资源加载；
* [x] **任务 3.1**：开启“阶段三：抽奖弹窗与交互开发”，编写玩法入口切换视图 `MLChatRoomNativeGameView` 及 Cell；（完成）
* [x] **任务 3.2**：创建两个游戏主视图 `MLChatRoomThemeGameOneView` 与 `MLChatRoomThemeGameTwoView`，实现悬浮窗 `RoomFloatingWindow` 的显隐拦截及防误触 Dismiss 拦截手势。（完成）
* [x] **任务 3.3**：开发所有次级弹窗包括 RuleView、RecordView 折叠明细排版、PurchaseView 自定义购买与限额、以及 ExchangeView 藏宝图调节及 0 张必败判定。（完成）
* [x] **任务 4.4**：双玩法起播 SVGA 全屏动画并在播放结束后拉起结算结果页面。（完成）
