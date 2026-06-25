//
//  EMO_GradeView.m
//  miliao
//
//  Created by aa on 2019/8/5.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "EMO_GradeView.h"
@interface EMO_GradeView()
Strong UIView *shadowView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIView *bgProgressView;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UILabel *number;
@end
@implementation EMO_GradeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}
- (void)loadViewWithDic:(NSDictionary *)dic
{
    self.title.text = [NSString stringWithFormat:@"%@LV%@",dic[@"title"],dic[@"current_level"]];
    
    CGFloat widthA=[dic[@"currnet_num"] floatValue]/[dic[@"next_num"]floatValue];
    self.number.text = NSStringFormat(@"%.1f%%",widthA*100);
    if([dic[@"type"] integerValue]==1){
        self.number.textColor=RGBA(45, 130, 255, 1);
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0,0,kWidth-KAdaptedWidth(60),KAdaptedHeight(10));
        gl.startPoint = CGPointMake(0.5, 0);
        gl.endPoint = CGPointMake(0.5, 1);
        gl.colors = @[(__bridge id)RGBA(236, 244, 255, 1).CGColor,(__bridge id)RGBA(199, 229, 255, 1).CGColor];
        gl.locations = @[@(0.0),@(1.0f)];
        [_bgProgressView.layer addSublayer:gl];
        
        CAGradientLayer *gl1 = [CAGradientLayer layer];
        gl1.frame = CGRectMake(0,0,kWidth-KAdaptedWidth(100),KAdaptedHeight(10));
        gl1.startPoint = CGPointMake(0.5, 0);
        gl1.endPoint = CGPointMake(0.5, 1);
        gl1.colors = @[(__bridge id)RGBA(101, 163, 255, 1).CGColor,(__bridge id)RGBA(199, 229, 255, 1).CGColor];
        gl1.locations = @[@(0.0),@(0.3)];
        [_progressView.layer addSublayer:gl1];
    }
    else{
        self.number.textColor=RGBA(255, 111, 0, 1);
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0,0,kWidth-KAdaptedWidth(60),KAdaptedHeight(10));
        gl.startPoint = CGPointMake(0.5, 0);
        gl.endPoint = CGPointMake(0.5, 1);
        gl.colors = @[(__bridge id)RGBA(255, 237, 236, 1).CGColor,(__bridge id)RGBA(255, 221, 199, 1).CGColor];
        gl.locations = @[@(0.0),@(1.0f)];
        [_bgProgressView.layer addSublayer:gl];
        
        CAGradientLayer *gl1 = [CAGradientLayer layer];
        gl1.frame = CGRectMake(0,0,kWidth-KAdaptedWidth(100),KAdaptedHeight(10));
        gl1.startPoint = CGPointMake(0.5, 0);
        gl1.endPoint = CGPointMake(0.5, 1);
        gl1.colors = @[(__bridge id)RGBA(255, 133, 101, 1).CGColor,(__bridge id)RGBA(255, 209, 199, 1).CGColor];
        gl1.locations = @[@(0.0),@(1.0f)];
        [_progressView.layer addSublayer:gl1];
    }

    CGFloat prohW = (kWidth-KAdaptedWidth(60)) *widthA;
    [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(prohW);
    }];
    [self layoutIfNeeded];
}
- (void)setUpView{
    
    [self bgView];
    [self title];
    [self number];
    [self bgProgressView];
    [self progressView];
    

    
}

- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.layer.cornerRadius=KAdaptedHeight(10);
        _shadowView.layer.shadowColor = RGBA(162, 162, 162, 0.16).CGColor;
        _shadowView.layer.shadowOffset = CGSizeMake(0,0);
        _shadowView.layer.shadowOpacity = 1;
        _shadowView.layer.shadowRadius =3;
        [self addSubview:_shadowView];
        [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(10);
            make.leading.mas_equalTo(15);
            make.trailing.mas_equalTo(-15);
            make.bottom.mas_equalTo(self).offset(-10);
            
        }];

    }
    return _shadowView;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor=kWhiteColor;
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(10);
            make.leading.mas_equalTo(15);
            make.trailing.mas_equalTo(-15);
            make.bottom.mas_equalTo(self).offset(-10);
            
        }];
        setViewCorner(_bgView, KAdaptedHeight(10));
    }
    return _bgView;
}




- (UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.text = getLanguage(@"贡献值LV1");
        _title.textColor = RGBA(51, 51, 51, 1);
        _title.font=KFontA(14);
        [self.bgView addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.top.mas_equalTo(KAdaptedHeight(20));
            make.height.mas_equalTo(KAdaptedHeight(20));
        }];
    }
    return _title;
}

- (UILabel *)number{
    if (!_number) {
        _number = [[UILabel alloc] init];
        _number.text = getLanguage(@"0%");
        _number.textColor = RGBA(45, 130, 255, 1);
        _number.font=KFontA(13);
        _number.textAlignment=NSTextAlignmentRight;
        [self.bgView addSubview:_number];
        [_number mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.top.mas_equalTo(self.title.mas_top);
            make.height.mas_equalTo(self.title.mas_height);
            make.width.mas_equalTo(KAdaptedWidth(100));
        }];
    }
    return _number;
}



- (UIView *)bgProgressView{
    if (!_bgProgressView) {
        _bgProgressView = [[UIView alloc] init];
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0,0,kWidth-KAdaptedWidth(60),KAdaptedHeight(10));
        gl.startPoint = CGPointMake(0.5, 0);
        gl.endPoint = CGPointMake(0.5, 1);
        gl.colors = @[(__bridge id)RGBA(236, 244, 255, 1).CGColor,(__bridge id)RGBA(199, 229, 255, 1).CGColor];
        gl.locations = @[@(0.0),@(1.0f)];
        [_bgProgressView.layer addSublayer:gl];
        _bgProgressView.layer.cornerRadius = KAdaptedHeight(10)/2;
        _bgProgressView.layer.masksToBounds=YES;
        [self.bgView addSubview:_bgProgressView];
        [_bgProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.title.mas_bottom).offset(KAdaptedHeight(10));
//            make.top.mas_equalTo(self.title).offset(KAdaptedHeight(10));
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(kWidth-KAdaptedWidth(60));
            make.height.mas_equalTo(10);
            
        }];
    }
    return _bgProgressView;
}


- (UIView *)progressView{
    if (!_progressView) {
        _progressView = [[UIView alloc] init];
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0,0,kWidth-KAdaptedWidth(100),KAdaptedHeight(10));
        gl.startPoint = CGPointMake(0.5, 0);
        gl.endPoint = CGPointMake(0.5, 1);
        gl.colors = @[(__bridge id)RGBA(101, 163, 255, 1).CGColor,(__bridge id)RGBA(199, 229, 255, 1).CGColor];
        gl.locations = @[@(0.0),@(1.0f)];
        [_progressView.layer addSublayer:gl];
        _progressView.layer.cornerRadius = KAdaptedHeight(10)/2;
        _progressView.layer.masksToBounds=YES;
        [self.bgView addSubview:_progressView];
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.title).offset(KAdaptedHeight(10));
            make.top.mas_equalTo(self.title.mas_bottom).offset(KAdaptedHeight(10));
            make.leading.mas_equalTo(self.bgProgressView.mas_leading);
            make.width.mas_equalTo(kWidth-KAdaptedWidth(100));
            make.height.mas_equalTo(10);
            
        }];
    }
    return _progressView;
}




//- (UIImageView *)currentLevel{
//    if (!_currentLevel) {
//        _currentLevel = [ControlCreator createImageView:self rect:CGRectMake(0, 0, 0, 0) imageName:@"meiliImg-1" backguoundColor:nil];
//    }
//    return _currentLevel;
//}
//
//- (UIImageView *)nextLevel {
//    if (!_nextLevel) {
//        _nextLevel = [ControlCreator createImageView:self rect:CGRectMake(0, 0, 0, 0) imageName:@"meiliImg-2" backguoundColor:nil];
//    }
//    return _nextLevel;
//}
//- (UIView *)bgProgressView{
//    if (!_bgProgressView) {
//        _bgProgressView = [ControlCreator createView:self rect:CGRectMake(0, 0, 0, 0) backguoundColor:HEXCOLOR(0xE6F7F5)];
//        _bgProgressView.layer.cornerRadius = 2.5;
//        _bgProgressView.layer.masksToBounds = YES;
//    }
//    return  _bgProgressView;
//}
//- (UIView *)progressView{
//    if (!_progressView) {
//        _progressView = [ControlCreator createView:self rect:CGRectMake(0, 0, 0, 0) backguoundColor:MHColorFromHexString(@"#81D8CF")];
//        _progressView.layer.cornerRadius= 2.5;
//        _progressView.layer.masksToBounds = YES;
//    }
//    return _progressView;
//}

@end
