//
//  EMO_PublicManager.m
//  miliao
//
//  Created by jkkj on 2023/11/3.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_PublicManager.h"

@implementation EMO_PublicManager
+ (instancetype)manager {
    static EMO_PublicManager *manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        manager = [self new];
    });
    return manager;
}

//青少年模式
- (EMO_AdolescentModelView *)adolescentView{
//    if(!_adolescentView){
//        _adolescentView = [[EMO_AdolescentModelView alloc] init];
//    }
//    WeakSelf;
//    _adolescentView.adolescentBlock = ^{
//        wself.adolescentView = nil;
//    };
    return _adolescentView;
}
@end
