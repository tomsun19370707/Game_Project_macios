//
//  DYActionSheet.m
//  GroupPurchaseProject
//
//  Created by 李东阳 on 2018/4/27.
//  Copyright © 2018年 锤子科技. All rights reserved.
//

#import "DYActionSheet.h"
/** 分割线高度*/
#define   lineMargin  3
/** 单个操作按钮高度*/
#define   oprButtonHeight  55
@interface DYActionSheet()<UITableViewDelegate,UITableViewDataSource>
/** list*/
@property (nonatomic,strong)UITableView *list;
/** 遮罩视图*/
@property (nonatomic,strong)UIView *maskView;
/** 可操作item*/
@property (nonatomic,strong)NSMutableArray *titleArr;
/** 异形屏，底部tab不可控区域*/
@property (nonatomic,strong)UIView *specia_screen_view;
@end
@implementation DYActionSheet

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
    
}
#pragma mark -
#pragma mark --- Rac
- (void)initRacChain {
    
}

#pragma mark --
#pragma mark --- method
- (instancetype)initWithTitleArr:(NSArray *)arr
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = YES ;
        self.backgroundColor = UIColor.clearColor ;
        
        /** 添加数据*/
        [self.titleArr addObjectsFromArray:arr];
        [self.titleArr addObject:@"取消"];
        
        /** 高度*/
        CGFloat viewHeight = self.titleArr.count * (oprButtonHeight + lineMargin) ;
        /** list height*/
        [self.list setHeight:viewHeight];
        
        /** add view*/
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.list.frame byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.list.frame;
        maskLayer.path = maskPath.CGPath;
        self.list.layer.mask = maskLayer;
        [self addSubview:self.list];
        [self setFrame:CGRectMake(0, SCREEN_HEIGHT_FULL + 30, SCREEN_WIDTH, self.list.bottom)];
    }
    return self ;
}

#pragma mark - tableviewdelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return oprButtonHeight ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == self.titleArr.count - 1) {
        return lineMargin ;
    }
    return 0.000001 ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.titleArr.count - 1) {
        return 0.000001 ;
    }
    return lineMargin;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /** 弹框消失*/
    [self hide];
    
    /** 点击取消的时候直接hide*/
    if (indexPath.section == self.titleArr.count - 1) {
        if (self.DActionSheetClick) {
            self.DActionSheetClick(-1,nil);
        }
        return ;
    }
    
    if (self.DActionSheetClick) {
        self.DActionSheetClick(indexPath.section,self.titleArr[indexPath.section]);
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.textLabel.font = PingFangFONT(15);
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
        cell.textLabel.textAlignment = NSTextAlignmentCenter ;
        cell.backgroundColor = UIColor.whiteColor ;
    }
    id obj = self.titleArr[indexPath.section] ;
    if ([obj isKindOfClass:[NSString class]]) {
        cell.textLabel.text = obj;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.accessoryType = UITableViewCellAccessoryNone ;
    return cell ;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArr.count  ;
}
#pragma mark -
#pragma mark --- Getter
-(NSMutableArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = [NSMutableArray array] ;
    }
    return _titleArr ;
}
-(UIView *)maskView
{
    if (!_maskView) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        backgroundView.userInteractionEnabled = YES;
        backgroundView.multipleTouchEnabled = YES ;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        [backgroundView addGestureRecognizer:tap];
        @weakify(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            @strongify(self);
            [self hide];
            /** 点击空白处消失*/
            if (self.DActionSheetClick) {
                self.DActionSheetClick(-2,nil);
            }
        }];
        _maskView = backgroundView ;
    }
    return _maskView ;
}
-(UIView *)specia_screen_view
{
    if (!_specia_screen_view) {
        _specia_screen_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH, 60)];
        _specia_screen_view.backgroundColor = [UIColor whiteColor];
        _specia_screen_view.bottom = SCREEN_HEIGHT_FULL ;
    }
    return _specia_screen_view ;
}
-(UITableView *)list
{
    if (!_list) {
        _list = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) style:UITableViewStyleGrouped];
        _list.delegate =self;
        _list.dataSource =self;
        _list.showsVerticalScrollIndicator = NO;
        _list.separatorStyle = UITableViewCellSeparatorStyleNone ;
        _list.backgroundColor = UIColorFromRGB(0xF5F6F8);
        _list.scrollEnabled = NO ;
    }
    return _list ;
}

#pragma mark --
#pragma mark --- Method
- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    /** 全部加载到window上*/
    [window addSubview:self];
    [window addSubview:self.maskView];
    [window bringSubviewToFront:self];
    
    if (IS_iPhoneX) {
        [window addSubview:self.specia_screen_view];
        [window insertSubview:self.specia_screen_view belowSubview:self];
    }
    
    /** 弹框动画*/
    [UIView animateWithDuration:0.3 animations:^{
        [self setBottom:SCREEN_HEIGHT];
    }completion:^(BOOL finished) {

    }];
}
- (void)hide
{
    [UIView animateWithDuration:0.2 animations:^{
        [self setTop:SCREEN_HEIGHT_FULL + 30];
    } completion:^(BOOL finished) {
        [self deallocSubview];
    }];
}
/** 销毁view*/
- (void)deallocSubview
{
    [_specia_screen_view removeFromSuperview];
    [_list removeFromSuperview];
    [_maskView removeFromSuperview];
    [self removeFromSuperview];
    _maskView.hidden = YES ;
}
@end





