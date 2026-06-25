//
//  ZJUIUtil.m
//  ZJW_Course
//
//  Created by imac on 2018/5/4.
//  Copyright © 2018年 wangmeng. All rights reserved.
//

#import "ZJUIUtil.h"



@implementation ZJUIUtil
 //设置下拉刷新
+ (void)refreshWithHeader:(UIScrollView *) tableView
           backgroudColor:(UIColor *)color
                  refresh:(dispatch_block_t)refresh
{
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        refresh();
    }];
    // 设置文字
    [header setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开后刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    // 设置颜色
    header.stateLabel.textColor = [UIColor grayColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
    header.backgroundColor = color;
    header.scrollView.backgroundColor = color;
    // 设置箭头
    [header arrowView].image=[UIImage imageNamed:@"refresh_arrow"];
    tableView.mj_header=header;
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
}

// 设置下拉刷新
+ (void)refreshWithHeader:(UIScrollView *) tableView
                  refresh:(dispatch_block_t) refresh
{
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        refresh();
    }];
    // 设置文字
    [header setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开后刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    // 设置颜色
    header.stateLabel.textColor = [UIColor grayColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
    // 设置箭头
    [header arrowView].image=[UIImage imageNamed:@"refresh_arrow"];
    tableView.mj_header=header;
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
}
// 设置白色箭头下拉刷新
+ (void)refreshWithWhiteHeader:(UIScrollView *) tableView
                       refresh:(dispatch_block_t) refresh
{
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        refresh();
    }];
    // 设置文字
    [header setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开后刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    // 设置颜色
    header.stateLabel.textColor = [UIColor whiteColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor whiteColor];
    // 设置箭头
    [header arrowView].image=[UIImage imageNamed:@"refresh_arrow_white"];
    tableView.mj_header=header;
    // 设置加载菊花
    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
}

//设置下拉刷新
+ (void)refreshWithCollectionViewHeader:(UICollectionView *) collectionView
                                     refresh:(dispatch_block_t) refresh{
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        refresh();
    }];
    // 设置文字
    [header setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开后刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    // 设置颜色
    header.stateLabel.textColor = [UIColor grayColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
    // 设置箭头
    [header arrowView].image=[UIImage imageNamed:@"refresh_arrow"];
    collectionView.mj_header=header;
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    collectionView.mj_header.automaticallyChangeAlpha = YES;

}

// 设置下拉加载
+ (void)loadWithHeader:(UITableView *) tableView
               refresh:(dispatch_block_t) refresh
{
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        refresh();
    }];
    // 设置文字
    [header setTitle:@"下拉可以加载" forState:MJRefreshStateIdle];
    [header setTitle:@"松开后加载" forState:MJRefreshStatePulling];
    [header setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    // 设置颜色
    header.stateLabel.textColor = [UIColor grayColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
    // 设置箭头
    [header arrowView].image=[UIImage imageNamed:@"refresh_arrow"];
    tableView.mj_header=header;
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
}
// 设置上拉刷新
+ (void)refreshWithFooter:(UITableView *) tableView
                  refresh:(dispatch_block_t) refresh
{
    MJRefreshBackNormalFooter *footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        refresh();
    }];
    // 设置文字
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"我是有底线的" forState:MJRefreshStateNoMoreData];
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:14];
    // 设置颜色
    footer.stateLabel.textColor = [UIColor grayColor];
    // 设置箭头
    [footer arrowView].image=[UIImage imageNamed:@"refresh_arrow"];
    tableView.mj_footer=footer;
    tableView.mj_footer.automaticallyChangeAlpha = YES;
}

// 设置上拉刷新
+ (void) refreshWithCollectionViewFooter:(UICollectionView *) collectionView
                                 refresh:(dispatch_block_t) refresh{
    MJRefreshBackNormalFooter *footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        refresh();
    }];
    // 设置文字
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"我是有底线的" forState:MJRefreshStateNoMoreData];
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:14];
    // 设置颜色
    footer.stateLabel.textColor = [UIColor grayColor];
    // 设置箭头
    [footer arrowView].image=[UIImage imageNamed:@"refresh_arrow"];
    collectionView.mj_footer=footer;
    collectionView.mj_footer.automaticallyChangeAlpha = YES;
    
}



// 设置上拉刷新(白色)
+ (void)refreshWithWhiteFooter:(UITableView *) tableView
                       refresh:(dispatch_block_t) refresh
{
    MJRefreshBackNormalFooter *footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        refresh();
    }];
    // 设置文字
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"已加载完全部数据" forState:MJRefreshStateNoMoreData];
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:14];
    // 设置颜色
    footer.stateLabel.textColor = [UIColor whiteColor];
    // 设置箭头
    [footer arrowView].image=[UIImage imageNamed:@"refresh_arrow_white"];
    tableView.mj_footer=footer;
    tableView.mj_footer.automaticallyChangeAlpha = YES;
}
+ (UIColor *) colorWithHexString:(NSString *) hex
{
    NSString *cleanString = [hex stringByReplacingOccurrencesOfString:@"#" withString:@""];
    CGFloat alpha = 1.0;
    if ([cleanString length] == 8) {
        alpha = 1-[[cleanString.mutableCopy substringToIndex:2] floatValue];
        cleanString = [cleanString.mutableCopy substringFromIndex:2];
    }
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
// 16进制颜色
+ (UIColor *) colorWithHex:(long) hexColor
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

+ (UIColor *) colorWithHex:(long) hexColor alpha:(CGFloat)alpha{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIImage *) imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1,1)];
}

+ (UIImage *) imageWithColor:(UIColor *)color
                        size:(CGSize)size
{
    if(color==nil){
        color=[UIColor redColor];
    }
    if(size.width<1){
        size.width=1;
    }
    if(size.height<1){
        size.height=1;
    }
    @autoreleasepool {
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(ctx, color.CGColor);
        CGContextFillRect(ctx, rect);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
}

// 设置导航栏左侧按钮偏移
+ (void) leftNavItem:(UIViewController *)current
              button:(UIButton *)button
             offsetX:(CGFloat)offsetX
{
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *spaceItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = offsetX;
    current.navigationItem.leftBarButtonItems = @[spaceItem,leftItem];
    
}
/** 根据字体计以及最大宽度计算控件高度*/
+ (CGSize)sizeWith:(NSString *) text
              font:(UIFont *) fontSize
             width:(NSInteger) width
{
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode=NSLineBreakByCharWrapping;
    NSDictionary *attribute = @{NSFontAttributeName: fontSize, NSParagraphStyleAttributeName:paragraph};
    CGSize size = [text boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size;
}

+ (NSMutableAttributedString *)setHtmlStr:(NSString *)html isAnalyze:(BOOL)isAnalyze
{
    NSAttributedString *briefAttrStr;
    if (isAnalyze) {
        briefAttrStr = [[NSAttributedString alloc] initWithData:[[NSString stringWithFormat:@"%@<head><style>img{width:%fpx !important;height:auto}</style></head>",html,ScreenViewWidth - 80] dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    }else{
        briefAttrStr = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2];
    paragraphStyle.firstLineHeadIndent = 20;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:briefAttrStr];
    [attr addAttributes:@{NSFontAttributeName: Font(15)} range:NSMakeRange(0, attr.string.length)];
    if (!isAnalyze) {
        [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attr length])];
    }
    
    return attr;
    
}
+ (NSString *)autoWebAutoImageSize:(NSString *)html{
    
    NSString * regExpStr = @"<img\\s+.*?\\s+(style\\s*=\\s*.+?\")";
    NSRegularExpression *regex=[NSRegularExpression regularExpressionWithPattern:regExpStr options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *matches=[regex matchesInString:html
                                    options:0
                                      range:NSMakeRange(0, [html length])];
    
    
    NSMutableArray * mutArray = [NSMutableArray array];
    for (NSTextCheckingResult *match in matches) {
        NSString* group1 = [html substringWithRange:[match rangeAtIndex:1]];
        [mutArray addObject: group1];
    }
    
    NSUInteger len = [mutArray count];
    for (int i = 0; i < len; ++ i) {
        html = [html stringByReplacingOccurrencesOfString:mutArray[i] withString: @"style=\"width:200; height:auto;\""];
    }
    
    return html;
}


@end

