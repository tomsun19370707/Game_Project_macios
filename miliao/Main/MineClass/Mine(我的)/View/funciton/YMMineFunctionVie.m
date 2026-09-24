//
//  YMMineFunctionVie.m
//  YunMarket
//
//  Created by 李东阳 on 2021/3/17.
//

#import "YMMineFunctionVie.h"
#import "YMMineFunctionVieCollect.h"

#import "EMO_GiftWallViewController.h"
#import "EMO_CollectVC.h"
#import "EMO_MyRoomViewController.h"
#import "EMO_GradeCenterViewController.h"
#import "EMO_FeedbackViewController.h"
#import "CFMMyGiftVc.h"
#import "EMO_AddRoomVC.h"
#import "EMO_RenZhengViewController.h"
#import "DYAlertView.h"
#import "UserManager.h"
#define  itemheight  67

@interface YMMineFunctionVie ()<UICollectionViewDelegate,UICollectionViewDataSource>
/** View */
@property (nonatomic,strong) UICollectionView *collection;
/** 分割线*/
@property (nonatomic,strong)  UIImageView *line;
@end

@implementation YMMineFunctionVie

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
//首先给让cell左右偏移一点的距离，通过重写cell的setframe方法来实现   
- (void)setFrame:(CGRect)frame{
    CGFloat margin = 12;
    frame.origin.x = margin;
    frame.size.width = SCREEN_WIDTH - margin*2;
    [super setFrame:frame];
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
    [self.contentView addSubview:self.collection];
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
-(UICollectionView *)collection
{
    if (!_collection) {
        UICollectionViewFlowLayout *layout4 = [[UICollectionViewFlowLayout alloc]init];
        layout4.scrollDirection = UICollectionViewScrollDirectionVertical ;
        layout4.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout4.minimumLineSpacing = 0 ;
        layout4.minimumInteritemSpacing =0 ;
        /** 初始化*/
        _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH - 12 * 2, itemheight) collectionViewLayout:layout4];
        _collection.delegate  =self;
        _collection.dataSource  =self;
        _collection.backgroundColor = UIColor.whiteColor;
        _collection.showsHorizontalScrollIndicator = NO ;
        _collection.showsVerticalScrollIndicator = NO ;
        _collection.scrollEnabled = NO ;
        /** 注册cell*/
        [_collection registerNib:[UINib nibWithNibName:@"YMMineFunctionVieCollect" bundle:nil] forCellWithReuseIdentifier:@"YMMineFunctionVieCollect"];
    }
    return _collection ;
}
#pragma mark --
#pragma mark --- Setter

#pragma mark --
#pragma mark --- collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YMMineFunctionVieCollect *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YMMineFunctionVieCollect" forIndexPath:indexPath];
    cell.icon.image = IMAGE(self.icons[indexPath.row]);
    cell.lab.text = self.titles[indexPath.row];
    /** num*/
    [self setNumForCell:cell title:cell.lab.text];
    return cell ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (![DUserClient isLogin]) {
//        [DUserClient askToLoginVc];
//        return;
//    }
    NSString *title = self.titles[indexPath.row];
    if ([title isEqualToString:@"我的礼物"]) {
//        EMO_GiftWallViewController *vc=[EMO_GiftWallViewController new];
//        vc.titleStr=getLanguage(@"我的礼物");
//        [Dn_NAVPUSH pushViewController:vc animated:YES];
        
        CFMMyGiftVc *fi = [[CFMMyGiftVc alloc]init];
        [Dn_NAVPUSH pushViewController:fi  animated:YES];
    }else if ([title isEqualToString:@"我的收藏"]) {
        [Dn_NAVPUSH pushViewController:[EMO_CollectVC new] animated:YES];
    }else if ([title isEqualToString:@"我的房间"]) {
        // 【回滚恢复点】原业务逻辑（展示“我创建的”和“我管理的”双Tab房间列表页）：
        // 如需恢复原业务，取消下面一行的注释，并注释掉 [self handleCreateRoomEntry] 即可：
        // [Dn_NAVPUSH pushViewController:[EMO_MyRoomViewController new] animated:YES];

        // [需求变更] 点击“我的房间”承接原首页“+”创建房间业务流程
        [self handleCreateRoomEntry];
    }else if ([title isEqualToString:@"我的等级"]) {
        [Dn_NAVPUSH pushViewController:[EMO_GradeCenterViewController new] animated:YES];
    }else if ([title isEqualToString:@"帮助反馈"]) {
        [Dn_NAVPUSH pushViewController:[EMO_FeedbackViewController new] animated:YES];
    }
}

#pragma mark - 设置每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.width / self.columnNum, itemheight);
}

#pragma mark --
#pragma mark --- ibaction

#pragma mark --
#pragma mark --- Method
/** 加载数据*/
- (void)loadData
{
    int count = (int)self.columnNum ;

    //设置collectionview 和 contentview高度
    NSUInteger temp2 = self.titles.count / count ;
    if (self.titles.count % count != 0 ) {
        temp2 += 1 ;
    }
    [self.collection setHeight: temp2 * itemheight] ;
    [self.contentView setHeight:self.collection.bottom + 10];
    
    [self.collection reloadData];
}

/** 设置角标数量*/
- (void)setNumForCell:(YMMineFunctionVieCollect *)cell title:(NSString *)title
{
//    if ([title isEqualToString:@"待付款"]) {
//        NSString *waitPayNum = self.normalOrderStatic[@"waitPayCount"];
//        cell.numStr = waitPayNum ;
//    }else if ([title isEqualToString:@"待发货"]) {
//        NSString *waitPayNum = self.normalOrderStatic[@"waitSendCount"];
//        cell.numStr = waitPayNum ;
//    }else if ([title isEqualToString:@"待收货"]) {
//        NSString *waitPayNum = self.normalOrderStatic[@"waitReceiveCount"];
//        cell.numStr = waitPayNum ;
//    }else if ([title isEqualToString:@"已完成"]) {
//        NSString *waitPayNum = self.normalOrderStatic[@"finishCount"];
//        cell.numStr = waitPayNum ;
//    }else if ([title isEqualToString:@"售后/退款"]) {
//        NSString *waitPayNum = self.normalOrderStatic[@"afterCount"];
//        cell.numStr = waitPayNum ;
//    }
}

#pragma mark - 创建房间流转与实名认证校验
- (void)handleCreateRoomEntry {
    UserInfo *userInfo = [UserManager userInfo];
    if (!userInfo) {
        return;
    }
    
    NSString *realNameStatus = [NSString stringWithFormat:@"%@", userInfo.real_name_status];
    
    // 实名认证状态判定：0=未认证, 1=申请中, 2=审核通过, 3=申请驳回
    if ([realNameStatus isEqualToString:@"2"]) {
        // 1. 已实名认证：直接打开创建房间页
        EMO_AddRoomVC *createVC = [[EMO_AddRoomVC alloc] init];
        [Dn_NAVPUSH pushViewController:createVC animated:YES];
    } else if ([realNameStatus isEqualToString:@"1"]) {
        // 2. 实名认证审核中：轻提示
        [SVProgressHUD showInfoWithStatus:@"实名认证中，请耐心等待审核"];
    } else {
        // 3. 未实名认证 / 被驳回：弹出引导弹窗
        [self showRealNameAuthDialog];
    }
}

#pragma mark - 实名引导弹窗
- (void)showRealNameAuthDialog {
    DYAlertView *alert = [[DYAlertView alloc] initWithTitle:@"提示"
                                                   content:@"暂未实名认证，无法创建房间，是否去实名认证？"
                                                 construct:@"确认"
                                                completion:^{
        EMO_RenZhengViewController *authVC = [[EMO_RenZhengViewController alloc] init];
        [Dn_NAVPUSH pushViewController:authVC animated:YES];
    }];
    [alert addButtonTitle:@"取消" completion:^{
        
    }];
    [alert show];
}

@end


