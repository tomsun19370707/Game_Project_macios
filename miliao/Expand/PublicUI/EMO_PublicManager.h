//
//  EMO_PublicManager.h
//  miliao
//
//  Created by jkkj on 2023/11/3.
//  Copyright © 2023 EMO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMO_AdolescentModelView.h"
NS_ASSUME_NONNULL_BEGIN

@interface EMO_PublicManager : NSObject
+ (instancetype)manager;
@property(nonatomic,strong,nullable) EMO_AdolescentModelView*adolescentView;
@end

NS_ASSUME_NONNULL_END
