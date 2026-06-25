//
//  RoomMusicViewController.m
//  miliao
//
//  Created by aa on 2019/7/10.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "RoomMusicViewController.h"
#import "Global.h"

#import "MLMyMusicListVC.h"
#import "MLMusicLibraryViewController.h"

@interface RoomMusicViewController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *myCategoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) MLMyMusicListVC *myMusicVC;
@property (nonatomic, strong) MLMusicLibraryViewController *musicLibraryVC;


@end

@implementation RoomMusicViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //处于第一个item的时候，才允许屏幕边缘手势返回
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.myCategoryView.selectedIndex == 0);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //离开页面的时候，需要恢复屏幕边缘手势，不能影响其他页面
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WEAK_SELF
    self.isNeedLine = YES;
    [self loadBar:YES needBack:YES needBackground:YES];
    self.leftButtonView.image = ImageNamed(@"xiaoxi_back");
    self.bgView.backgroundColor = MLControlsHuiColor;
    self.myMusicVC = [[MLMyMusicListVC alloc] init];
    
    self.myMusicVC.musicModel = self.musicModel;
    self.myMusicVC.playClickBlock = ^(RoomMusicModel *musicModel) {
        ! weakSelf.playClickBlock ?: weakSelf.playClickBlock(musicModel);
    };
    
    
    
    self.musicLibraryVC = [[MLMusicLibraryViewController alloc] init];
//    self.rightTitleLabel.text = @"上传";
    self.titles = @[getLanguage(@"我的音乐"),getLanguage(@"音乐库")];
    self.listContainerView.frame = CGRectMake(0, [self preferredCategoryViewHeight], self.bgView.width, self.bgView.height);
    self.myCategoryView.delegate = self;
    self.listContainerView.didAppearPercent = 0.01; //滚动一点就触发加载
    self.myCategoryView.contentScrollView = self.listContainerView.scrollView;
    self.myCategoryView.titleColor = mainQianColor;
    self.myCategoryView.titleSelectedColor = mainViceColor;
    self.myCategoryView.titleFont =  [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    self.myCategoryView.titleSelectedFont = [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
    self.myCategoryView.titleLabelZoomScale = 1.3;
    self.myCategoryView.titleLabelVerticalOffset = 1;
    self.myCategoryView.titles = self.titles;
    [self.myCategoryView removeFromSuperview];
    [self.barView addSubview:self.myCategoryView];
    [self.myCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(220, 30));
        make.centerX.mas_equalTo(self.barView.mas_centerX);
        make.centerY.mas_equalTo(self.barView.mas_centerY).offset(10);
    }];
    [self.bgView addSubview:self.listContainerView];
    
    
    
}
- (void)rightButtonClick:(UIButton *)sender{
    
}
- (CGFloat)preferredCategoryViewHeight {
//    return ZJTopNavH + 0.5;
    return self.barView.bottom;
}
- (JXCategoryBaseView *)myCategoryView {
    if (_myCategoryView == nil) {
        _myCategoryView = [[JXCategoryTitleView alloc] init];
    }
    return _myCategoryView;
}

- (JXCategoryListContainerView *)listContainerView {
    if (_listContainerView == nil) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithDelegate:self];
    }
    return _listContainerView;
}


#pragma mark - JXCategoryViewDelegate
- (id<JXCategoryListContentViewDelegate>)preferredListAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return self.myMusicVC;
            break;
        case 1:
            return self.musicLibraryVC;
            break;
        default:
            break;
    }
    return nil;
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    if (!index) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }else{
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    MYLog(@"%@", NSStringFromSelector(_cmd));
    [self.listContainerView didClickSelectedItemAtIndex:index];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    [self.listContainerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
}

#pragma mark - JXCategoryListContainerViewDelegate

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    id<JXCategoryListContentViewDelegate> list = [self preferredListAtIndex:index];
    
    return list;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
