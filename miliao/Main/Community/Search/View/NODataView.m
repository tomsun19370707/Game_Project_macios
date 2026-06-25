//
//  NODataView.m
//  miliao
//
//  Created by aa on 2019/8/8.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "NODataView.h"
@interface NODataView()
@property (nonatomic,strong) UIImageView *image;
@property (nonatomic,strong) UILabel *title;
@end
@implementation NODataView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewsAndLayout];
    }
    return self;
}
- (void)loadDataWithDic:(NSDictionary *)dic
{
    [self.image setImage:[UIImage imageNamed:dic[@"imageName"]]];
    self.title.text = dic[@"title"];
    [self layoutIfNeeded];
}
- (void)setupViewsAndLayout
{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.image];
    [self addSubview:self.title];
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-50);
        make.size.mas_offset(CGSizeMake(80, 80));
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.image.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self);
    }];
}
- (UIImageView *)image
{
    if (!_image) {
        _image = [[UIImageView alloc] init];
        _image.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _image;
}
- (UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = Font(12);
        _title.textColor = mainQianColor;
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}
@end
