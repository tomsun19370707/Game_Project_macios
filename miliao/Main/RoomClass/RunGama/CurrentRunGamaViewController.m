//
//  CurrentRunGamaViewController.m
//  miliao
//
//  Created by wzd on 2026-04-17.
//  Copyright © 2026 EMO. All rights reserved.
//

#import "CurrentRunGamaViewController.h"

@interface CurrentRunGamaViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *balanceLabel;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation CurrentRunGamaViewController
-(void)sureClick{
    [self.view endEditing:YES];
    
}
- (instancetype)initWithInfoDic:(NSDictionary *)infoDic{
    if (self = [super init]) {
        _infoDic=infoDic;
        self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self addSubView];
    }
    return self;
}
-(void)addSubView{
    UIControl *control =[[UIControl alloc]initWithFrame:self.view.bounds];
    [control addTarget:self action:@selector(closeVc) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:control];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    UIImageView *contentImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"实时赛况info"]];
    contentImageView.userInteractionEnabled=YES;
    [self.contentView addSubview:contentImageView];
    [contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(-10);
        make.height.mas_equalTo(contentImageView.mas_width).multipliedBy(948.0/669.0);
    }];
    
    float totalHeight= (SCREENWIDTH-30)*(948.0/669.0);
    UIButton *closeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton addTarget:self action:@selector(closeVc) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"Game返回"] forState:UIControlStateNormal];
    [contentImageView addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(totalHeight*(84.0/948.0)-23);
        make.height.mas_equalTo(46);
        make.width.mas_equalTo(46*(293.0/134.0));
        make.right.mas_equalTo(20);
    }];

    [contentImageView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(totalHeight*(140.0/948.0));
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-30);
    }];
    [self getDataRequest];
}

- (NSAttributedString *)attributedStringFromHTML:(NSString *)htmlString {
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                              NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding]
                                                                            options:options
                                                                 documentAttributes:nil
                                                                              error:nil];
    
    // 设置默认字体 & 行高
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0;  // 设置行间距
    paragraphStyle.minimumLineHeight = 20.0;  // 设置最小行高
    paragraphStyle.maximumLineHeight = 25.0;  // 设置最大行高
    NSDictionary *attributes = @{
        NSFontAttributeName: [UIFont systemFontOfSize:16],  // 默认字体
        NSParagraphStyleAttributeName: paragraphStyle  // 设置段落样式（包括行高）
    };
    [mutableAttributedString addAttributes:attributes range:NSMakeRange(0, mutableAttributedString.length)];
    
    return mutableAttributedString;
}

-(void)closeVc{
    [self dismissViewControllerAnimated:NO completion:^{
        if(self.cancel){
            self.cancel();
        }
    }];
}

-(UIView *)contentView{
    if(!_contentView){
        _contentView=[[UIView alloc] initWithFrame:CGRectZero];
    }
    return _contentView;
}
-(void)getDataRequest{
    WeakSelf
    [NetworkRequest requestGET:rungame_getHistory parameters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        wself.dataArray=baseModel.data;
        [wself.tableView reloadData];
    } error:^(NSError *errors) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.fd_prefersNavigationBarHidden=YES;
    
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 50;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.tableFooterView = [UIView new];
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_14_5
        if (@available(iOS 15.0, *)) {
            self.tableView.sectionHeaderTopPadding = 0;
        }
#endif
    }
    return _tableView;
}

#pragma mark - DZNEmptyDataSetSource DZNEmptyDataSetDelegate
//
//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
//    NSString *title = @"暂无数据";
//    return [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[uifon],NSForegroundColorAttributeName:[[uic] colorWithAlphaComponent:0.4]}];
//}

//- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
//    NSString *title = @"点击重新加载";
//    return [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:TitleFont,NSForegroundColorAttributeName:LightGrayColor}];
//}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"nodataicon"];
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    return 30;
}
// 设置往上的偏移量
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -70;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
   
}

#pragma mark - UITableView UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

#pragma mark - UITableView UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndextifier = @"cellIndextifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndextifier];
    if (cell) {
        [cell removeFromSuperview];
        cell = nil;
    }
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndextifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    NSDictionary *dataDic=[self.dataArray objectAtIndex:indexPath.row];
    
    UIImageView *contentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"底板"]];
    [cell.contentView addSubview:contentImageView];
    [contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(15);
    }];
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self getInconName:[NSString stringWithFormat:@"%@",[dataDic valueForKey:@"winner_top_name"]]]]];
    leftImageView.contentMode=UIViewContentModeScaleAspectFit;
    [contentImageView addSubview:leftImageView];
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(40);
        make.centerX.mas_equalTo(contentImageView.mas_centerX).offset(-40);
    }];
    
    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self getInconName:[NSString stringWithFormat:@"%@",[dataDic valueForKey:@"winner_bottom_name"]]]]];
    rightImageView.contentMode=UIViewContentModeScaleAspectFit;
    [contentImageView addSubview:rightImageView];
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(40);
        make.centerX.mas_equalTo(contentImageView.mas_centerX).offset(40);
    }];
    
    return cell;
}
-(NSString *)getInconName:(NSString *)name{
    if ([name containsString:@"猪"]) {
        return @"猪";
    }else if ([name containsString:@"狗"]) {
        return @"狗狗";
    }else if ([name containsString:@"虎"]) {
        return @"老虎";
    }else if ([name containsString:@"龟"]) {
        return @"乌龟";
    }else if ([name containsString:@"兔"]) {
        return @"兔子";
    }else{
        return @"兔子";
    }
}
@end
