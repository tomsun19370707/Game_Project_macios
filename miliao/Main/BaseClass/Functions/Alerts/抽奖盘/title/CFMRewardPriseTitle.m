//
//  CFMRewardPriseTitle.m
//  miliao
//
//  Created by Dylan Lee on 2025/12/31.
//  Copyright © 2025 EMO. All rights reserved.
//

#import "CFMRewardPriseTitle.h"
#import "YMMineFunctionVieCollect.h"
#import "CFMRateRewardVc.h"
#import "SRWKWebViewController.h"
@interface CFMRewardPriseTitle ()
@property (nonatomic,strong) UICollectionView *collection;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation CFMRewardPriseTitle

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
#pragma mark --
#pragma mark --- collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YMMineFunctionVieCollect *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YMMineFunctionVieCollect" forIndexPath:indexPath];
    if (indexPath.row < self.dataArr.count) {
        NSDictionary *model = self.dataArr[indexPath.row];
        [cell.icon sd_setImageWithURL:[NSURL URLWithString:model[@"image"]] placeholderImage:IMAGE(@"reward_roll")];
        cell.lab.text = model[@"name"];
    }
    return cell ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *model = self.dataArr[indexPath.row];
    
    if (self.cellType==2) {
        /** 倍率盘*/
        NSString *mode = FORMAT(model[@"mode"]);
        /** 倍率盘抽奖*/
        CFMRateRewardVc *re = [[CFMRateRewardVc alloc]init];
        re.rewardId = FORMAT(model[@"id"]);
        re.vcType = mode.intValue ;
        [Dn_NAVPUSH pushViewController:re  animated:YES];
    }else{
        /** 抽奖盘*/
        NSString *url = [NSString stringWithFormat:@"%@?token=%@&id=%@",lottery_lottery_h5,UserDefaultsGet(kToken),model[@"id"]];
        SRWKWebViewController*load = [[SRWKWebViewController alloc]init];
//        WebJSVc *load = [[WebJSVc alloc]init];
        load.mainURL = url;
        load.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [[ObjectTool SharedSettings].currentVC addChildViewController:load];
        [load showInView:[ObjectTool SharedSettings].currentVC.view];
//        [Dn_NAVPUSH pushViewController:load animated:YES];
    }
    
    if (self.fetchClick) {
        self.fetchClick();
    }
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
        CGFloat height = 67 ;
        CGFloat width = (SCREEN_WIDTH - 12 * 4) / 4.0 ;
        
        UICollectionViewFlowLayout *layout4 = [[UICollectionViewFlowLayout alloc]init];
        layout4.scrollDirection = UICollectionViewScrollDirectionVertical ;
        layout4.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout4.itemSize = CGSizeMake(width, height);
        layout4.minimumLineSpacing = 0 ;
        layout4.minimumInteritemSpacing =0 ;
        /** 初始化*/
        _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH - 12 * 4, height) collectionViewLayout:layout4];
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
-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr ;
}
#pragma mark --
#pragma mark --- Setter
- (void)setLimitArr:(NSMutableArray *)limitArr
{
    [self.dataArr removeAllObjects] ;
    [self.dataArr addObjectsFromArray:limitArr];
    if (limitArr.count == 0) {
        return ;
    }
    CGFloat height = 67 ;
    //设置collectionview 和 contentview高度
    NSUInteger temp = limitArr.count / 4;
    if (limitArr.count % 4 != 0) {
        temp += 1 ;
    }
    [self.collection setHeight:height *temp ];
    /** height*/
    [self.contentView setHeight:self.collection.bottom + 10];
    [self setHeight:self.contentView.height];
}
#pragma mark --
#pragma mark --- ibaction

#pragma mark --
#pragma mark --- Method
@end
