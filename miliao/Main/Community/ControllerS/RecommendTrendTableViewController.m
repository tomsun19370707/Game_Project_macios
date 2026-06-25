//
//  RecommendTrendTableViewController.m
//  miliao
//
//  Created by aa on 2019/7/5.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "RecommendTrendTableViewController.h"
#import "TopicHeaderView.h"
#import "TopicCollectionViewCell.h"
#import "TrendModel.h"
#import "TrendTableViewCell.h"

#import "UITableView+SDAutoTableViewCellHeight.h"


static NSString *MCellIdentifier = @"MCollectionCell";
static NSString *sectionHeaderID = @"sectionHeaderID";
static NSString *cellID = @"cellID";


@interface RecommendTrendTableViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>


@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) NSArray *pointArray;
@property (strong, nonatomic) UICollectionView *ServerView;
@property (nonatomic,strong) NSArray *backgroundImageArray;
@property (strong,nonatomic) NSMutableArray *listModel;

@end

@implementation RecommendTrendTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupHeaderView];
    self.listModel = [[NSMutableArray alloc] init];
     [self.tableView registerNib:[UINib nibWithNibName:@"TrendTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    self.tableView.frame = CGRectMake(0, ZJTopNavH, ScreenWidth, ScreenHeight-TabBar_H);

    [self loadData];
}



- (void)setupHeaderView
{
    self.tableView.tableHeaderView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //该方法也可以设置itemSize
        layout.itemSize = CGSizeMake(110, 150);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.headerReferenceSize = CGSizeMake(ScreenWidth, 20);
        //2.初始化collectionView
        self.ServerView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        self.ServerView.frame = CGRectMake(0, 0, ScreenWidth, 280);
        self.ServerView.backgroundColor = [UIColor whiteColor];
        self.automaticallyAdjustsScrollViewInsets = NO; //自动布局，自己定义的高度
        self.ServerView.scrollEnabled = NO;//collectionview不能滚动
        //代理
        self.ServerView.delegate = self;
        self.ServerView.dataSource = self;
        [self.ServerView registerClass:[TopicCollectionViewCell class] forCellWithReuseIdentifier:MCellIdentifier];
        [self.ServerView registerClass:[TopicHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderID];
        self.ServerView;
    });
}
- (void)loadData
{
    NSDictionary *dict = @{@"page":@(0)};
    [HttpTool getRecommended_dynamicWithParameters:dict success:^(id response) {
        if ([response[@"code"] intValue] == 1) {
            
            self.listModel = [TrendModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"data"]];
            NSLog(@"动态 %@",response);
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _titleArray.count;
    
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
- (UIView *)listView {
    return self.view;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TopicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MCellIdentifier forIndexPath:indexPath];
    cell.titleLabel.text = _titleArray[indexPath.row];
    cell.pointLabel.text = _pointArray[indexPath.row];
    NSString *imageName = _backgroundImageArray[indexPath.row];
    cell.bgroundView.image = [UIImage imageNamed:imageName];
    cell.contentView.layer.cornerRadius = 7.0f;
    cell.contentView.layer.borderWidth = 1.0f;
    cell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    cell.contentView.layer.masksToBounds = YES;
    
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    //    if (collectionView == self.functionView) {
    //        return nil;
    //    }
    if (kind == UICollectionElementKindSectionHeader) {
        TopicHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderID forIndexPath:indexPath];
        headerView.title = @"热门话题";
        headerView.backgroundColor = [UIColor whiteColor];
        
        
        return headerView;
    }else {
        return nil;
    }
}
//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(ScreenWidth/2-20, ScreenWidth/5);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 10, 20, 10);//top left bottom right
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.listModel.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor lightGrayColor];
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrendModel *model = self.listModel[indexPath.section];
    return model.cellHeight;
//    return 370;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[TrendTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.model = self.listModel[indexPath.section];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置cell点击效果
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat sectionHeaderHeight = 10;
    
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        
    }
}

@end
