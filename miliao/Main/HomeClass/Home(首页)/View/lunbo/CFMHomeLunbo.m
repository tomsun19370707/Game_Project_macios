//
//  CFMHomeLunbo.m
//  miliao
//
//  Created by Dylan Lee on 2025/12/9.
//  Copyright © 2025 EMO. All rights reserved.
//

#import "CFMHomeLunbo.h"
#import "UUMarqueeView.h"
#import "CFMHomeMarqueCell.h"
#import "STRankVc.h"
@interface CFMHomeLunbo ()<SDCycleScrollViewDelegate,UUMarqueeViewDelegate>
/** View */
@property (nonatomic,strong) UUMarqueeView *homeLoopView ;

@property (weak, nonatomic) IBOutlet UIView *noticeBg;

@end

@implementation CFMHomeLunbo

#pragma mark -
#pragma mark --- init
-(instancetype)init
{
    self = [super init];
    if (self) {
        /** 初始化*/
        [self initContentview];
        /** RAC*/
        [self initRacChain];
    }
    return self ;
}

#pragma mark -
#pragma mark --- init frame
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /** 初始化*/
        [self initContentview];
        /** RAC*/
        [self initRacChain];
    }
    return self ;
}

#pragma mark -
#pragma mark --- 初始化view
- (void)initContentview
{
    [self.contentView addSubview:self.cycleImageView];
    self.contentView.height = 150 + self.cycleImageView.bottom + 6 ;
    [self.noticeBg addSubview:self.homeLoopView];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    /** 初始化*/
    [self initContentview];
    /** RAC*/
    [self initRacChain];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -
#pragma mark --- Rac
- (void)initRacChain {
    
}

#pragma mark -
#pragma mark --- Getter
- (SDCycleScrollView *)cycleImageView
{
    if (!_cycleImageView) {
        CGFloat temp = 134.0 / 345.0 ;
        _cycleImageView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH - 15 * 2, (SCREEN_WIDTH - 15 * 2) * temp)];
        _cycleImageView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _cycleImageView.autoScrollTimeInterval = 5.0;
//        _cycleImageView.autoScroll = NO ;
        _cycleImageView.delegate = self;
        _cycleImageView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter ;
        _cycleImageView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill ;
        _cycleImageView.backgroundColor = UIColor.clearColor;
        _cycleImageView.showPageControl = YES;/** 是否显示分页控件 */
        _cycleImageView.placeholderImage = IMAGE(@"banner");
        _cycleImageView.currentPageDotColor = BaseMainColor ;
        _cycleImageView.pageDotColor = UIColorFromRGB(0xE6E6E6) ;
        _cycleImageView.layer.masksToBounds = YES;
        _cycleImageView.layer.cornerRadius = 10 ;
    }
    return _cycleImageView ;
}
-(UUMarqueeView *)homeLoopView
{
    if (!_homeLoopView) {
        _homeLoopView= [[UUMarqueeView alloc] initWithFrame:CGRectMake(0, 2, SCREENWIDTH - 15 * 2, self.noticeBg.height)];
        _homeLoopView.backgroundColor=UIColor.clearColor;
        _homeLoopView.delegate = self;
        _homeLoopView.timeIntervalPerScroll = 2.0f;//滚动间隔
        _homeLoopView.timeDurationPerScroll = 0.5f;//滚动速度
        _homeLoopView.touchEnabled = YES;
    }
    return _homeLoopView;
}
#pragma mark --
#pragma mark --- Setter
-(void)setNoticeData:(NSMutableArray<NSDictionary *> *)noticeData
{
    _noticeData = noticeData ;
    
    [self.homeLoopView reloadData];
}
#pragma mark --
#pragma mark --- ibaction
- (IBAction)rankAc:(id)sender {
    STRankVc *ran = [[STRankVc alloc]init];
    [Dn_NAVPUSH pushViewController:ran  animated:YES];
}
#pragma mark --
#pragma mark --- Method
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (index < self.lunboData.count) {
        NSDictionary *dic = self.lunboData[index];
        NSString *url = dic[@"url"];
        NSString *content = dic[@"content"];
        
        if ([NSString NotNull:url]) {
            WebLoadVc *load= [[WebLoadVc alloc]init];
            load.webUrl = url ;
            load.titleStr = dic[@"title"];
            [Dn_NAVPUSH pushViewController:load animated:YES];
        }else if ([NSString NotNull:content]) {
            WebLoadVc *load= [[WebLoadVc alloc]init];
            load.webHtml = content ;
            load.titleStr = dic[@"title"];
            [Dn_NAVPUSH pushViewController:load animated:YES];
        }
    }
}

#pragma mark - UUMarqueeViewDelegate
- (NSUInteger)numberOfVisibleItemsForMarqueeView:(UUMarqueeView*)marqueeView {
    return 1;
}

- (NSUInteger)numberOfDataForMarqueeView:(UUMarqueeView*)marqueeView {
    return _noticeData.count;

}

- (void)createItemView:(UIView*)itemView forMarqueeView:(UUMarqueeView*)marqueeView {
    
    CFMHomeMarqueCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"CFMHomeMarqueCell" owner:self options:nil]lastObject];
    cell.frame = CGRectMake(0, 0, marqueeView.width, marqueeView.height);
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.tag = 100797;
    [itemView addSubview:cell];
}

- (void)updateItemView:(UIView*)itemView atIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
 
    if (index < _noticeData.count) {
        NSDictionary *dicData=_noticeData[index];
        
        CFMHomeMarqueCell *view= [itemView viewWithTag:100797];
        if ([view isKindOfClass:[CFMHomeMarqueCell class]]) {
            view.model=dicData;
        }
    }
}

- (void)didTouchItemViewAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView 
{
    DLog(@"-----click--%ld",index);
}

@end
