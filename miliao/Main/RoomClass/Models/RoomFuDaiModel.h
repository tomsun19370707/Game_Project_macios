//
//  RoomFuDaiModel.h
//  miliao
//
//  Created by 张世浩 on 2022/6/2.
//  Copyright © 2022 miliao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RoomFuDaiModel : NSObject
@property (nonatomic, strong) NSString *fuDaiID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *image;



@property (nonatomic, strong) NSString *other;
@property (nonatomic, strong) NSString *oneimage;
@property (nonatomic, strong) NSString *weigh;
@property (nonatomic, strong) NSString *addtime;
@property (nonatomic, strong) NSArray *sp;
@property(nonatomic, copy) NSString *num;


@end

NS_ASSUME_NONNULL_END
