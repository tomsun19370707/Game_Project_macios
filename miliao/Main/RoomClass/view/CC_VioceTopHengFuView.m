//
//  CC_VioceTopHengFuView.m
//  CCVioce
//
//  Created by jkkj on 2021/12/13.
//

#import "CC_VioceTopHengFuView.h"

@implementation CC_VioceTopHengFuView

- (void)awakeFromNib{
    [super awakeFromNib];
    setViewCorner(self.icon, self.icon.height/2);
    // 1.延迟执行某一段代码
    WeakSelf;
    if (@available(iOS 10.0, *)) {
        [NSTimer scheduledTimerWithTimeInterval:2.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
            [UIView animateWithDuration:2 animations:^{
                wself.alpha = 0.5;
            } completion:^(BOOL finished) {
                wself.alpha = 0;
            }];
        }];
    } else {
        // Fallback on earlier versions
    }
}

@end
