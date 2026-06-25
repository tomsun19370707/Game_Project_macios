//
//  SQBottomView.m
//  miliao
//
//  Created by TonyStark on 2020/3/11.
//  Copyright © 2020 miliao. All rights reserved.
//

#import "SQBottomView.h"
#import "BAButton.h"
@implementation SQBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup_UI];
    }
    return self;
}
-(void)setup_UI{
    CGFloat wid = 60;
    NSArray *images = @[@"sq_sc",@"xiaoxi 拷贝 2",@"dianzan 拷贝",@"fenxiang 拷贝"];
//    NSArray *selectImages = @[@"shoucang",@"xiaoxi",@"dianzan",@"fenxiang"];
    @autoreleasepool {
        for (int i=0; i<4; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(ScreenWidth-10-4*60+60*i, 5, 60, 30);
            [button setTitle:@"0" forState:UIControlStateNormal];
            if (i==0) {
                [button setTitle:@"" forState:UIControlStateNormal];
            }
            button.titleLabel.font = Font(12);
            [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
            [button ba_button_setButtonLayoutType:BAKit_ButtonLayoutTypeLeftImageLeft padding:5];
            [self addSubview:button];
            [button setTitleColor:MHColorFromHexString(@"#BBBBBB") forState:UIControlStateNormal];
            if (i==0) {
                self.shoucangBtn = button;
                [self.shoucangBtn setImage:[UIImage imageNamed:@"shoucang_select"] forState:UIControlStateSelected];
            }
            if (i==1) {
                self.pinglunBtn  = button;
            }
            if (i==2) {
                self.dianzanBtn = button;
                 [self.dianzanBtn setImage:[UIImage imageNamed:@"dianzan_select"] forState:UIControlStateSelected];
            }
            if (i==3) {
                self.fenxiangBtn = button;
            }
        }
    }
}
@end
