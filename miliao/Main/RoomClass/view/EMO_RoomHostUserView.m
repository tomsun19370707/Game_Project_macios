//
//  EMO_RoomHostView.m
//  miliao
//
//  Created by aa on 2019/6/15.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "EMO_RoomHostUserView.h"
#import "Global.h"
#import "BAButton.h"

@interface EMO_RoomHostUserView ()

@end


@implementation EMO_RoomHostUserView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setUpUI];
}

-(void)setUpUI
{
    self.mALB.layer.cornerRadius = 15/2.0;
    self.mALB.layer.masksToBounds = YES;
    self.mALB.hidden = YES;
    self.genderIcon.hidden = YES;
    
    [self addSubview:self.bgView];
    
    [self sendSubviewToBack:self.bgView];
    [self addSubview:self.hostIconBox];
    
    [self addSubview:self.hostIcon];
    [self addSubview:self.headIconImg];
    [self addSubview:self.headSvgaImg];
    
    [self addSubview:self.genderIcon];
    [self bringSubviewToFront:self.genderIcon];
    
    [self addSubview:self.hostName];
    [self bringSubviewToFront:self.hostName];
    
//    [self addSubview:self.hostNameVipImg];
//    [self bringSubviewToFront:self.hostNameVipImg];
    
    [self addSubview:self.mALB];
    [self bringSubviewToFront:self.mALB];
    
    [self addSubview:self.closeIcon];
    [self bringSubviewToFront:self.closeIcon];
    
//    [self addSubview:self.hostName];
//    [self bringSubviewToFront:self.hostName];
    
    [self addSubview:self.expreImage];
    [self addSubview:self.bottomLabel];
    
//    [self addSubview:self.gradeImgView];
//    [self bringSubviewToFront:self.gradeImgView];
    
    [self.hostIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(10);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.6);
        make.height.mas_equalTo(self.hostIcon.mas_width);
    }];
    
    [self.headIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.hostIcon.mas_centerX);
        make.centerY.mas_equalTo(self.hostIcon.mas_centerY);
        make.width.mas_equalTo(self.hostIcon.mas_width).multipliedBy(1.3);
        make.height.mas_equalTo(self.hostIcon.mas_height).multipliedBy(1.3);
        
    }];
    
    [self.headSvgaImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.hostIcon.mas_centerX);
        make.centerY.mas_equalTo(self.hostIcon.mas_centerY);
        make.width.mas_equalTo(self.hostIcon.mas_width).multipliedBy(1.3);
        make.height.mas_equalTo(self.hostIcon.mas_height).multipliedBy(1.3);
        
        
    }];
    
    
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.mas_centerX);
        //        make.top.mas_equalTo(self.hostName.mas_bottom).offset(KAdaptedHeight(-13));
        make.top.mas_equalTo(self.hostIcon.mas_bottom).offset(3);
        make.centerX.mas_equalTo(self.hostIcon);
        make.width.mas_equalTo(KAdaptedWidth(30));
        make.height.mas_equalTo(KAdaptedHeight(15));
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.hostIcon);
        make.height.mas_equalTo(self.hostIcon);
        make.width.mas_equalTo(self.hostIcon);
    }];
    
    [self.hostIconBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hostIcon).offset(-9);
        make.bottom.mas_equalTo(self.hostIcon).offset(9);
        make.left.mas_equalTo(self.hostIcon).offset(-9);
        make.right.mas_equalTo(self.hostIcon).offset(9);
    }];
    
    [self.expreImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hostIcon).offset(-5);
        make.bottom.mas_equalTo(self.hostIcon).offset(5);
        make.left.mas_equalTo(self.hostIcon).offset(-5);
        make.right.mas_equalTo(self.hostIcon).offset(5);
    }];
    [self.genderIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.hostIcon.mas_bottom);
        make.centerX.mas_equalTo(self.hostIcon);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(15);
    }];
    
    [self.hostName mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.mALB.mas_bottom).offset(5);
        make.top.mas_equalTo(self.hostIcon.mas_bottom).offset(23);
//        make.left.mas_equalTo(self.mas_left).offset(18);//暂时不显示等级图片
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-40);
        make.width.mas_equalTo(80);
    }];

    
//    [self.hostNameVipImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.hostName.mas_centerY);
//        make.left.mas_equalTo(self.mas_left).offset(11);
//        make.width.mas_equalTo(25);
//        make.height.mas_equalTo(15);
//    }];
    
    
    
    [self.mALB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.hostIcon.mas_bottom);
        make.top.mas_equalTo(self.hostName.mas_bottom).offset(KAdaptedHeight(-5));
        make.centerX.mas_equalTo(self.hostIcon);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(15);
    }];
    
    [self.closeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hostIcon.mas_left);
        make.right.mas_equalTo(self.hostIcon.mas_right);
        make.top.mas_equalTo(self.hostIcon.mas_top);
        make.bottom.mas_equalTo(self.hostIcon.mas_bottom);
    }];
//    [self.gradeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.mALB.mas_bottom).offset(5);
//        make.left.mas_equalTo(self.mas_left).offset(2);
//        make.bottom.mas_equalTo(self.mas_bottom).offset(5);
//        make.width.mas_equalTo(80);
//    }];
//    [self.hostName mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.mALB.mas_bottom).offset(5);
//        make.left.mas_equalTo(self.mas_left).offset(2);
//        make.bottom.mas_equalTo(self.mas_bottom).offset(5);
//        make.width.mas_equalTo(80);
//    }];
    
    
    [self.bgView.layer addSublayer:self.waveLayer];
    self.expreImage.hidden = YES;

    [self.waveLayer start];
}

- (void)setMeiLiString:(NSString *)meiLiString{
    if (meiLiString.length==0||[meiLiString integerValue]==0) {
        [self.bottomLabel setTitle:@"0" forState:UIControlStateNormal];
    }else{
         float width = [Common getStringWidthWithText:[Common isNullNumber:meiLiString] font:FONT_10 viewHeight:20];
        [self.bottomLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            if (width<40) {
                make.width.mas_offset(KAdaptedWidth(40));
            }else{
                make.width.mas_offset(width);
            }
            
        }];
        [self.bottomLabel setTitle:[NSString stringWithFormat:@" %@",meiLiString] forState:UIControlStateNormal];
    }
}

- (NSString *)getDealNumwithstring:(NSString *)string{
    if (string.length==0||[string isEqualToString:@"0"]) {
        return @"0";
    }
    if (string.length<5) {
        return string;
    }
    NSNumber *number = @([string floatValue]/10000);
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"###0.0"];
    formatter.roundingMode = NSNumberFormatterRoundDown;
    formatter.maximumFractionDigits = 1;
    NSLog(@"%@", [formatter stringFromNumber:number]);
    return [NSString stringWithFormat:@"%@w",[formatter stringFromNumber:number]];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.hostIcon.layer.cornerRadius = CGRectGetWidth(self.hostIcon.bounds)/2.0;
    self.hostIcon.layer.masksToBounds = YES;
    
    
    self.waveLayer.position = CGPointMake(self.hostIcon.width /2, self.hostIcon.height/2);
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (UIButton *)bottomLabel{
    if (!_bottomLabel) {
        _bottomLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomLabel setBackgroundImage:KGetImage(@"roomMeiLiBgImg") forState:UIControlStateNormal];
//        [_bottomLabel setImage:KGetImage(@"meiLiIconImg") forState:UIControlStateNormal];
//        CAGradientLayer *gl = [CAGradientLayer layer];
//        gl.frame = CGRectMake(0,0,KAdaptedWidth(50), KAdaptedHeight(15));
//        gl.startPoint = CGPointMake(0.5, 0);
//        gl.endPoint = CGPointMake(0.5, 1);
//        gl.colors = @[(__bridge id)RGBA(202, 9, 115, 1).CGColor,(__bridge id)RGBA(164, 5, 168, 1).CGColor];
//        gl.locations = @[@(0.0),@(1.0f)];
//        [_bottomLabel.layer addSublayer:gl];
//        [_bottomLabel.layer insertSublayer:gl atIndex:1];
        [_bottomLabel setTitle:@"0" forState:UIControlStateNormal];
        [_bottomLabel setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _bottomLabel.titleLabel.font = FONT_10;
        setViewCorner(_bottomLabel, KAdaptedHeight(15)/2);
    }
    return _bottomLabel;
}

- (XLKWavePulsLayer *)waveLayer {
    if (_waveLayer == nil) {
        _waveLayer = [XLKWavePulsLayer layer];
        _waveLayer.animationDuration = 6;
        _waveLayer.haloLayerNumber = 6;
        _waveLayer.fromValueForAlpha = 0.6;
        _waveLayer.fromValueForRadius = 0.5;
        _waveLayer.backgroundColor = [UIColor whiteColor].CGColor;
        _waveLayer.radius = self.hostIcon.width / 2.0+3;
        
    }
    return _waveLayer;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:[UIColor clearColor]];
    }
    return _bgView;
}
- (UIImageView *)expreImage{
    if (!_expreImage) {
        _expreImage = [ControlCreator createImageView:nil rect:CGRectZero imageName:@"" backguoundColor:[UIColor clearColor]];
    }
    return _expreImage;
}
- (UIImageView *)hostIconBox{
    if (!_hostIconBox) {
        _hostIconBox = [ControlCreator createImageView:nil rect:CGRectZero imageName:nil backguoundColor:[UIColor clearColor]];
    }
    return _hostIconBox;
}
-(UILabel *)mALB
{
    if (!_mALB) {
        _mALB = [[UILabel alloc] init];
        _mALB.textAlignment = NSTextAlignmentCenter;
        _mALB.textColor = [UIColor whiteColor];
        _mALB.font = [UIFont systemFontOfSize:14.0];
    }
    return _mALB;
}
- (UILabel *)hostName
{
    if (!_hostName) {
        _hostName = [[UILabel alloc] init];
        _hostName.textAlignment = NSTextAlignmentCenter;
        _hostName.textColor = [UIColor whiteColor];
        _hostName.font = [UIFont systemFontOfSize:14.0];
    }
    return _hostName;
}

//-(UIImageView *)hostNameVipImg
//{
//    if (!_hostNameVipImg) {
//        _hostNameVipImg = [[UIImageView alloc] init];
//    }
//    return _hostNameVipImg;
//}

-(UIImageView *)closeIcon
{
    if (!_closeIcon) {
        _closeIcon = [[UIImageView alloc] init];
        _closeIcon.image = [UIImage imageNamed:@"closeMaiImg"];
    }
    return _closeIcon;
}

-(UIImageView *)genderIcon
{
    if (!_genderIcon) {
        _genderIcon = [[UIImageView alloc] init];
//        _genderIcon.image=KGetImage(@"room_xuhao_boy");
    }
    return _genderIcon;
}

-(UIImageView *)hostIcon
{
    if (!_hostIcon) {
        _hostIcon = [ControlCreator createImageView:nil rect:CGRectZero imageName:@"" backguoundColor:[UIColor clearColor]];
    }
    return _hostIcon;
}

-(UIImageView *)headIconImg
{
    if (!_headIconImg) {
        _headIconImg = [ControlCreator createImageView:nil rect:CGRectZero imageName:@"" backguoundColor:[UIColor clearColor]];
    }
    return _headIconImg;
}

- (SVGAImageView *)headSvgaImg{
    if (!_headSvgaImg) {
        _headSvgaImg = [[SVGAImageView alloc] init];
        _headSvgaImg.contentMode=UIViewContentModeScaleToFill;
        _headSvgaImg.autoPlay=YES;
    }
    return _headSvgaImg;
}







@end
