//
//  AppDelegate.h
//  miliao
//  com.chuizi.testAppId.miyu
//  Created by aa on 2019/5/22.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EMO_MLRoomNewVC.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) EMO_MLRoomNewVC *roomViewController;

@property (strong, nonatomic) UIWindow *window;

-(void)UpdataVersion;

@end

