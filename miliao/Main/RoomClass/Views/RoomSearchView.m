//
//  RoomSearchView.m
//  miliao
//
//  Created by aa on 2019/7/4.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "RoomSearchView.h"


@interface RoomSearchView ()<UITextFieldDelegate>


@property (nonatomic, strong) UIButton *queDingButton;

@end

@implementation RoomSearchView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUpUI];
        
    }
    return self;
}

- (void)quDingButtonClick:(UIButton *)sender{
    if ([self.searchTF.text isEqualToString:@""]) {
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:getLanguage(@"  支持用户ID/昵称")];
    }else{
        ! self.quDingButtonClickBlock ?: self.quDingButtonClickBlock(self.searchTF.text);
    }
}


- (void)setUpUI{
    [self addSubview:self.searchTF];
    [self addSubview:self.queDingButton];
    
    [self.queDingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-12);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(60);
    }];
    
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(12);
        make.height.mas_equalTo(35);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.queDingButton.mas_left).offset(-16);
    }];
    
}
- (UITextField *)searchTF{
    if (!_searchTF) {
        _searchTF = [ControlCreator createTextField:nil rect:CGRectMake(0, 0, 0, 0) placeholder:getLanguage(@"  支持用户ID/昵称") placeholderColor:nil text:@"" font:Font(12) color:mainViceColor backguoundColor:MHColorFromHexString(@"#F8F8F8")];
        _searchTF.delegate = self;
        _searchTF.layer.masksToBounds = YES;
        _searchTF.layer.cornerRadius = 17.5;
        _searchTF.keyboardType = UIKeyboardTypeNumberPad;
        UIView *leftTFView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 35)];
        leftTFView.backgroundColor = [UIColor clearColor];
        _searchTF.leftView = leftTFView;
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _searchTF;
}
- (UIButton *)queDingButton{
    if (!_queDingButton) {
//        _queDingButton = [ControlCreator createButton:nil rect:CGRectZero text:getLanguage(@"确定") font:Font(13) color:RGBA(34, 34, 34, 1) backguoundColor:RGBA(0, 0, 0, 0) imageName:nil target:self action:@selector(quDingButtonClick:)];
        _queDingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0,0,60,30);
        gl.startPoint = CGPointMake(0, 0);
        gl.endPoint = CGPointMake(1, 1);
        gl.colors = @[(__bridge id)[UIColor colorWithRed:73/255.0 green:174/255.0 blue:252/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:2/255.0 green:237/255.0 blue:252/255.0 alpha:1.0].CGColor];
        gl.locations = @[@(0.0),@(1.0f)];
        [_queDingButton.layer addSublayer:gl];
        _queDingButton.layer.masksToBounds = YES;
        _queDingButton.layer.cornerRadius = 7;
        [_queDingButton setTitle:getLanguage(@"确定") forState:UIControlStateNormal];
        [_queDingButton setTitleColor:RGBA(34, 34, 34, 1) forState:UIControlStateNormal];
        _queDingButton.titleLabel.font=KFont(13);
        [_queDingButton addTarget:self action:@selector(quDingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _queDingButton;
}




@end
