//
//  EMO_RoomGameAlertView.m
//

#import "EMO_RoomGameAlertView.h"
#import "CFMultiplierGamesVC.h"
#import "SRWKWebViewController.h"

#define ALERT_SCALE 1.0

@interface EMO_RoomGameAlertView ()
@property (nonatomic, strong) UIImageView *baseView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray <NSDictionary *> *dataArr;
@end

@implementation EMO_RoomGameAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI {

    UIView *tapView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:tapView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    [tapView addGestureRecognizer:tap];

    self.backgroundColor = UIColor.clearColor;

    /// ✅ 宽度自适应安全居中 (设计 690px 在 1x 下为 345 pt)
    self.baseView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, hh(345), hh(238 * ALERT_SCALE))];
    self.baseView.image = [UIImage imageNamed:@"mgame_alertviewbg"];
//    UIImage *image = [UIImage imageNamed:@"mgame_alertviewbg"];
//
//    UIImage *resizableImg = [image resizableImageWithCapInsets:UIEdgeInsetsMake(130, 150, 120, 150)
//                                                 resizingMode:UIImageResizingModeStretch];
//
//    self.baseView.image = resizableImg;
    self.baseView.userInteractionEnabled = YES;
    [self addSubview:self.baseView];
    self.baseView.center = self.center;

    /// ✅ scrollView 放置于安全居中位置，高保真还原设计高度 160 pt
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(hh(15),
                                                                     hh(65),
                                                                     hh(315),
                                                                     hh(160))];
    [self.baseView addSubview:self.scrollView];

    [self fetchRewardPanList];
}

- (void)showInView:(UIView *)view {
    [view addSubview:self];

    self.baseView.mj_y += ScreenHeight;
    [UIView animateWithDuration:0.3 animations:^{
        self.baseView.mj_y -= ScreenHeight;
    }];
}

- (void)hideView {
    [UIView animateWithDuration:0.3 animations:^{
        self.baseView.mj_y += ScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 数据

- (void)fetchRewardPanList {
    WeakSelf

    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"page_size"] = @"1000";
    parameter[@"page"] = @"1";

    __block int i = 0, j = 0;
    self.dataArr = [NSMutableArray new];

    [FFHomeHandel customeNoPageListRequestHandle:parameter apiStr:lottery_get_rooms success:^(NSMutableArray <NSDictionary *> *dataArr) {
        i = 1;
        if (i + j == 2) {
            [wself.dataArr insertObjects:dataArr atIndex:0];
            [wself refreshCell];
        } else {
            [wself.dataArr addObjectsFromArray:dataArr];
        }
    } failure:^{
        [wself refreshCell];
    }];

    [FFHomeHandel customeNoPageListRequestHandle:parameter apiStr:lottery_get_rooms_new success:^(NSMutableArray <NSDictionary *> *dataArr) {
        j = 1;
        if (i + j == 2) {
            [wself.dataArr addObjectsFromArray:dataArr];
            [wself refreshCell];
        } else {
            [wself.dataArr addObjectsFromArray:dataArr];
        }
    } failure:^{
        [wself refreshCell];
    }];
}

#pragma mark - UI刷新

- (void)refreshCell {

    [self.scrollView removeAllSubviews];

    NSInteger line = self.dataArr.count / 3 + (self.dataArr.count % 3 > 0 ? 1 : 0);

    /// ✅ 每行高度 100 pt
    CGFloat rowH = hh(100);
    CGFloat contentH = line * rowH;

    self.scrollView.contentSize = CGSizeMake(0, contentH);

    /// ✅ baseView 动态高度与屏幕安全限高 (maxH 设为 450 pt 以防 iPhone X 超屏)
    CGFloat minH = hh(238 * ALERT_SCALE);
    CGFloat maxH = hh(450); /// 防止超屏

    CGFloat needH = contentH + hh(80);

    self.baseView.mj_h = MAX(minH, MIN(needH, maxH));
    self.baseView.center = self.center;

    // 动态调整 scrollView 的 frame 高度，以防内容超出 maxH 被截断（启用内部滚动）
    self.scrollView.frame = CGRectMake(hh(15), hh(65), hh(315), self.baseView.mj_h - hh(80));

    /// cell尺寸 1x 适配
    CGFloat w = hh(75);              /// 宽度适配为 75 pt
    CGFloat h = hh(87);

    for (int i = 0; i < self.dataArr.count; i++) {

        NSDictionary *dic = self.dataArr[i];

        int x = (i % 3) * hh(105) + hh(15);
        int y = (i / 3) * rowH;

        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        view.userInteractionEnabled = YES;
        view.image = [UIImage imageNamed:@"mgame_alertview_cellbg"];
        [self.scrollView addSubview:view];

        /// 图片尺寸适配
        UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(hh(7.5),
                                                                         hh(7.5),
                                                                         hh(60),
                                                                         hh(60))];
        [pic sd_setImageWithURL:[NSURL URLWithString:dic[@"image"]]];
        [view addSubview:pic];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                   h - hh(20),
                                                                   view.width,
                                                                   hh(15))];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = dic[@"name"];
        label.font = [UIFont systemFontOfSize:12];
        [view addSubview:label];

        UIControl *c = [[UIControl alloc] initWithFrame:view.bounds];
        c.tag = 100 + i;
        [c addTarget:self action:@selector(cellClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:c];
    }
}

#pragma mark - 点击

- (void)cellClick:(UIControl *)sender {

    NSDictionary *model = self.dataArr[sender.tag - 100];
    [self hideView];

    if ([model[@"status"] isEqualToString:@"normal"]) {

        NSString *mode = FORMAT(model[@"mode"]);

        CFMultiplierGamesVC *re = [[CFMultiplierGamesVC alloc]init];
        re.rewardId = FORMAT(model[@"id"]);
        re.vcType = mode.intValue;
        re.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);

        [[ObjectTool SharedSettings].currentVC addChildViewController:re];
        [re showInView:[ObjectTool SharedSettings].currentVC.view];

    } else {

        NSString *url = [NSString stringWithFormat:@"%@?token=%@&id=%@",lottery_lottery_h5,UserDefaultsGet(kToken),model[@"id"]];

        SRWKWebViewController *load = [[SRWKWebViewController alloc]init];
        load.mainURL = url;
        load.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);

        [[ObjectTool SharedSettings].currentVC addChildViewController:load];
        [load showInView:[ObjectTool SharedSettings].currentVC.view];
    }
}

@end
