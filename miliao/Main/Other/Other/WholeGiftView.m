//
//  WholeGiftView.m
//  miliao
//
//  Created by aa on 2019/8/9.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "WholeGiftView.h"
@interface WholeGiftView()
@property (nonatomic, strong) UIImageView       *imageView;
@property (nonatomic, strong) YYLabel           *title;
@property (nonatomic, strong) UIImageView       *bgImageView;
@end
@implementation WholeGiftView

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
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
    NSString *str = @"";
    str = NSStringFormat(@"惊现土豪~%@送给%@ %@X%@",model.user_name,model.from_name,model.gift_name, model.num);
    NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attrDescribeStr setColor:MHColorFromHexString(@"#FFFFFF") range:[str rangeOfString:str]];
    [attrDescribeStr setColor:MHColorFromHexString(@"#FFE765") range:[str rangeOfString:model.from_name]];
    [attrDescribeStr setColor:MHColorFromHexString(@"#FFE765") range:[str rangeOfString:model.user_name]];
    [attrDescribeStr setColor:MHColorFromHexString(@"#FFE765") range:[str rangeOfString:model.gift_name]];
    self.title.attributedText = attrDescribeStr;
    
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
        make.size.mas_offset(CGSizeMake(50, 50));
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
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"礼物"]];
        
    }
    return _bgImageView;
}
- (YYLabel *)title
{
    if (!_title) {
        _title = [YYLabel new];
        _title.textColor = [UIColor whiteColor];
//        _title.text = @"AAA送给BBB1888个宇宙飞船～  点击围观";
        _title.font = Font(13);
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
