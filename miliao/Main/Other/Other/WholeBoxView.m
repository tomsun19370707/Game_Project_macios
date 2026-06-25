//
//  WholeBoxView.m
//  miliao
//
//  Created by feifei on 2019/9/24.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "WholeBoxView.h"

@interface WholeBoxView ()

@property (nonatomic, strong) UIImageView       *imageView;
@property (nonatomic, strong) YYLabel           *title;
@property (nonatomic, strong) UIImageView       *bgImageView;

@end


@implementation WholeBoxView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
        [self setupLayouts];
    }
    return self;
}
- (void)setModel:(GitfPostModel *)model
{
    _model = model;
    NSString *str = @"";
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
    {
        str = NSStringFormat(@"哇哦~%@在普通蛋中开出%@",model.user_name,model.gift_name);
        NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrDescribeStr setColor:MHColorFromHexString(@"#FFFFFF") range:[str rangeOfString:str]];
        [attrDescribeStr setColor:MHColorFromHexString(@"#FF3E6D") range:[str rangeOfString:model.user_name]];
        [attrDescribeStr setColor:MHColorFromHexString(@"#FF3E6D") range:[str rangeOfString:model.gift_name]];
        self.title.attributedText = attrDescribeStr;
    }
    
}
- (void)setUpView
{
    [self addSubview:self.bgImageView];
    [self addSubview:self.imageView];
    [self addSubview:self.title];
}
- (void)setupLayouts
{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.centerY.equalTo(self);
        make.size.mas_offset(CGSizeMake(40, 40));
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(25);
        make.height.mas_offset(30);
        make.centerY.equalTo(self.imageView.mas_centerY);
    }];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView).offset(10);
        make.right.equalTo(self.title.mas_right).offset(35);
        make.centerY.equalTo(self.imageView.mas_centerY);
        make.height.mas_offset(90);
    }];
}
- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"宝箱"]];
        
    }
    return _bgImageView;
}
- (YYLabel *)title
{
    if (!_title) {
        _title = [YYLabel new];
        _title.textColor = [UIColor whiteColor];
        //        _title.text = @"AAA送给BBB1888个宇宙飞船～  点击围观";
        _title.font = Font(15);
    }
    return _title;
}
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}


@end
