#import "MLChatRoomThemeGameFourResultView.h"
#import <SVProgressHUD.h>

@implementation MLChatRoomThemeGameFourResultView

+ (void)showInView:(UIView *)parentView 
             gifts:(NSArray<MLGameDrawResultModel *> *)gifts 
        totalValue:(NSInteger)value {
    NSMutableString *giftNames = [NSMutableString string];
    for (MLGameDrawResultModel *gift in gifts) {
        [giftNames appendFormat:@"%@ x%ld, ", gift.name, (long)gift.num];
    }
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"恭喜获得: %@", giftNames]];
}

@end
