//
//  CFMMyGiftOpr.h
//  miliao
//
//  Created by Dylan Lee on 2025/12/8.
//  Copyright © 2025 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFMMyGiftOpr : UITableViewCell
@property (nonatomic,copy) void (^fetchClick)(int index);
@end
