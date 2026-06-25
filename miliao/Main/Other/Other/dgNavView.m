
//
//  dgNavView.m
//  SilkyWXList
//
//  Created by Runing on 2019/10/12.
//  Copyright © 2019 Doogore. All rights reserved.
//

#import "dgNavView.h"


@interface dgNavView ()

@end

@implementation dgNavView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self bulidUI];
    }
    return self;
}

- (void)bulidUI {
    
    UIView *navV = [[UIView alloc]initWithFrame:self.bounds];
//    navV.backgroundColor = RGB(239, 239, 239);
    navV.backgroundColor=kWhiteColor;
    navV.alpha = 0;
    [self addSubview:navV];
    self.navV = navV;
    
    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-1, self.bounds.size.width, 1)];
    lineView.backgroundColor=RGBA(0, 0, 0, 0.05);
    lineView.alpha=0;
    [self addSubview:lineView];
    self.lineVivew=lineView;
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(20, navV.height - 40 , 30, 30);
    [backBtn setImage:[[UIImage imageNamed:@"left_top_fanhui"]hal_imageFlippedForRightToLeftLayoutDirection] forState:0];
    [self addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KAdaptedWidth(15));
        make.bottom.mas_equalTo(KAdaptedHeight(-10));
        make.width.height.mas_equalTo(KAdaptedWidth(30));
        
    }];
    backBtn.tag = 1;
    [backBtn addTarget:self action:@selector(navClick:) forControlEvents:1<<6];
    self.backBtn = backBtn;
    
    UIButton *camareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    camareBtn.frame = CGRectMake(SCREEN_WIDTH - 20 - 30,navV.height - 40 , 30, 30);
    [camareBtn setImage:[UIImage imageNamed:@"camera_w"] forState:0];
    [self addSubview:camareBtn];
    [camareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(KAdaptedWidth(-20));
        make.bottom.mas_equalTo(KAdaptedHeight(-10));
        make.width.height.mas_equalTo(KAdaptedWidth(30));
        
    }];
    camareBtn.tag = 2;
    [camareBtn addTarget:self action:@selector(navClick:) forControlEvents:1<<6];
    self.camareBtn = camareBtn;
    
    UILabel *navLabel = [[UILabel alloc]init];
    navLabel.textAlignment = 1;
    navLabel.text = getLanguage(@"");
    navLabel.alpha = 0;
    navLabel.font = [UIFont boldSystemFontOfSize:17];
    [self addSubview:navLabel];
    [navLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KAdaptedWidth(-0));
        make.bottom.mas_equalTo(KAdaptedHeight(-10));
        make.height.mas_equalTo(KAdaptedWidth(30));
        make.trailing.mas_equalTo(0);
    }];
    self.navLabel = navLabel;
}
-(void)setTitleStr:(NSString *)titleStr{
    self.navLabel.text=titleStr;
}
- (void)setIsScrollUp:(BOOL)isScrollUp {
    
    _isScrollUp = isScrollUp;
    
    if (_isScrollUp) {
        self.lineVivew.alpha=1;
        [self.backBtn setImage:[[UIImage imageNamed:@"left_top_fanhui"]hal_imageFlippedForRightToLeftLayoutDirection] forState:0];
        [self.camareBtn setImage:[UIImage imageNamed:@"moreImg"] forState:0];
        
    } else {
        self.lineVivew.alpha=0;
        [self.backBtn setImage:[[UIImage imageNamed:@"backWhiteImg"]hal_imageFlippedForRightToLeftLayoutDirection]  forState:0];
        [self.camareBtn setImage:[UIImage imageNamed:@"moreWhiteImg"] forState:0];
    }
    
}

- (void)navClick:(UIButton *)btn {
    
    if (btn.tag == 1) {
        
        if ([self.delegate respondsToSelector:@selector(navBackClick)]) {
            [self.delegate navBackClick];
        }
        
    } else {
        
        if ([self.delegate respondsToSelector:@selector(navCameraClick)]) {
            [self.delegate navCameraClick];
        }
    }
    
}


@end
