//
//  RunGamaRuleViewController.m
//  miliao
//
//  Created by wzd on 2026-04-16.
//  Copyright © 2026 EMO. All rights reserved.
//

#import "RunGamaRuleViewController.h"

@interface RunGamaRuleViewController ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *balanceLabel;
@end

@implementation RunGamaRuleViewController
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
    UIImageView *contentImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"规则说明info"]];
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
    
    NSString *htmlString = [NSString stringWithFormat:@"%@",[self.infoDic valueForKey:@"betting_rules"]];
    UITextView *guiTextView = [[UITextView alloc] init];
    guiTextView.attributedText = [self attributedStringFromHTML:htmlString];
    guiTextView.textColor = [UIColor whiteColor];
    guiTextView.editable = NO;
    guiTextView.backgroundColor=[UIColor clearColor];
    guiTextView.font = [UIFont systemFontOfSize:16];
     [contentImageView addSubview:guiTextView];
    [guiTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(totalHeight*(140.0/948.0));
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-30);
    }];
  
   
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
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.fd_prefersNavigationBarHidden=YES;
    
}

@end
