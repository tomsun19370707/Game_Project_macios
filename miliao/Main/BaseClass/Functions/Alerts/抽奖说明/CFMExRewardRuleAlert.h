//
//  CFMExRewardRuleAlert.h
//  miliao
//
//  Created by Dylan Lee on 2026/1/4.
//  Copyright © 2026 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFMExRewardRuleAlert : UITableViewCell
/** 网页html*/
@property (nonatomic,strong)NSString *webHtml;

/** alert*/
- (void)show;
@end
