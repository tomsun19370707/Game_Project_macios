//
//  MLMaskView.h
//  miliao
//
//  Created by aa on 2019/5/29.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "BaseView.h"

@interface MLMaskView : BaseView

@property (nonatomic , copy) void(^determineClickBlock)(void);
@property (nonatomic, copy) void(^leftButtonBlock)(void);
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

- (void)setLeftButtonString:(NSString *)left rightButton:(NSString *)right promptLB:(NSString *)title maskViewH:(CGFloat )maskViewH;
@end
