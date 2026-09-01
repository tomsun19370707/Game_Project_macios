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
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];

        UIView *tap = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:tap];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewtap:)];
        [tap addGestureRecognizer:tapGestureRecognizer];

        UIImageView *view = [[UIImageView alloc] init];
        view.image = [UIImage imageNamed:@"mgame_result_bg"];
        view.contentMode = UIViewContentModeScaleAspectFit;
        view.userInteractionEnabled = YES;
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.mas_equalTo(KDialogAdaptedWidth(324));
            make.height.mas_equalTo(KDialogAdaptedWidth(291));
        }];

        UIImageView *pic = [[UIImageView alloc] init];
        pic.image = [UIImage imageNamed:@"mgame_result_pic"];
        pic.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:pic];
        [pic mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.top.equalTo(view).offset(KDialogAdaptedWidth(80));
            make.width.mas_equalTo(KDialogAdaptedWidth(111));
            make.height.mas_equalTo(KDialogAdaptedWidth(69));
        }];

        self.numLabel = [[UILabel alloc] init];
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        self.numLabel.font = [UIFont boldSystemFontOfSize:18];
        self.numLabel.textColor = HexColorDy(@"#8B2A00");
        [view addSubview:self.numLabel];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.top.equalTo(pic.mas_bottom).offset(KDialogAdaptedWidth(12));
        }];

        self.ratioLabel = [[UILabel alloc] init];
        self.ratioLabel.textAlignment = NSTextAlignmentCenter;
        self.ratioLabel.font = [UIFont systemFontOfSize:15];
        self.ratioLabel.textColor = HexColorDy(@"#8B2A00");
        [view addSubview:self.ratioLabel];
        [self.ratioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.top.equalTo(self.numLabel.mas_bottom).offset(KDialogAdaptedWidth(6));
        }];

    }
    return self;
}
- (void)viewtap:(UITapGestureRecognizer *)tap {
    self.hidden = YES;
    [self removeFromSuperview];
}
@end
