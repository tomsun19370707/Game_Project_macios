//
//  ZX_RankingVC.m
//  miliao
//
//  Created by jkkj on 2022/3/14.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_CollectVC.h"
#import "MKWithdrawalView.h"
#import "FSPageContentView.h"
#import "EMO_CollectListVC.h"
@interface EMO_CollectVC ()<MKWithdrawalViewDelegate,FSPageContentViewDelegate>
Strong FSPageContentView *pageContentView;
Strong MKWithdrawalView *titleView;
Strong UIImageView *backImg;
Strong NSMutableArray *childVCs;
@end

@implementation EMO_CollectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBar:YES needBack:YES needBackground:YES];
    self.titleLabel.text=getLanguage(@"我的收藏");
    self.titleLabel.font=KFont(18);
    self.barView.backgroundColor = [UIColor whiteColor];
//    self.view.backgroundColor=RGBA(255, 255, 255, 1);
    
    [self createUI];
    [self addVC];
}

- (void)createUI{
    self.view.backgroundColor = RGBA(248, 248, 248, 1);
    self.titleView = [[MKWithdrawalView alloc] initWithFrame:CGRectMake(0,self.barView.bottom + 1, ScreenWidth, 44)];
    self.titleView.selectColor = RGBA(34, 34, 34, 1);
    self.titleView.noteColor = RGBA(102, 102, 102, 1);
    self.titleView.noteFont = Font(14);
    self.titleView.selectFont = Font(14);
    self.titleView.lineColor = BaseMainColor;
    self.titleView.typeUI = MKUITypeDefault;
    self.titleView.delegate = self;
    self.titleView.titleArray = @[getLanguage(@"已开播"),getLanguage(@"未开播")];
    self.titleView.backgroundColor = [UIColor clearColor];
    [self.bgView addSubview:self.titleView];
}

//创建首页内容视图
- (void)addVC{
    self.childVCs = [[NSMutableArray alloc]init];
    for (int i=0;i<2;i++) {
        EMO_CollectListVC *vc = [[EMO_CollectListVC alloc] init];
        vc.type=i;//0已开播 1未开播
        [self.childVCs addObject:vc];
    }
    float height = self.bgView.height - self.barView.height;
    _pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0,self.titleView.bottom, ScreenWidth, height) childVCs:self.childVCs parentVC:self delegate:self];
    _pageContentView.backgroundColor = [UIColor clearColor];
    _pageContentView.contentViewCurrentIndex = 0;
    [self.bgView addSubview:_pageContentView];
}

- (void)switchIndex:(NSInteger )index{
    self.pageContentView.contentViewCurrentIndex = index;
}

#pragma mark --
- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.titleView.selectIndex = endIndex;
}

@end
