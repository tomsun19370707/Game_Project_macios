//
//  CFMutiplierGamesResultView.m
//  miliao
//
//  Created by xxf on 2026/2/12.
//  Copyright © 2026 EMO. All rights reserved.
//

#import "CFMutiplierGamesResultView.h"

@interface CFMutiplierGamesResultView()

@end
@implementation CFMutiplierGamesResultView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    if (self) {

        UIView *tap = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:tap];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewtap:)];
        [tap addGestureRecognizer:tapGestureRecognizer];

        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(hh(51), (ScreenHeight - hh(582))/2, hh(648), hh(582))];
        view.image = [UIImage imageNamed:@"mgame_result_bg"];
        [self addSubview:view];

        UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(hh(230), hh(160), hh(222), hh(138))];
        pic.image = [UIImage imageNamed:@"mgame_result_pic"];
        [view addSubview:pic];

        self.numLabel = [[UILabel alloc] init];
        self.numLabel.textAlignment = 1;
        self.numLabel.font = [UIFont boldSystemFontOfSize:18];
        [view addSubview:self.numLabel];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(pic.bottom + hh(30));
        }];
        self.ratioLabel = [[UILabel alloc] init];
        self.ratioLabel.textAlignment = 1;
        self.ratioLabel.font = [UIFont systemFontOfSize:17];
        self.ratioLabel.textColor = UIColor.lightGrayColor;
        [view addSubview:self.ratioLabel];
        [self.ratioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.numLabel.mas_bottom).offset(hh(30));
        }];

    }
    return self;
}
- (void)viewtap :(UITapGestureRecognizer *)tap {
    self.hidden = YES;
    [self removeFromSuperview];
}
@end
