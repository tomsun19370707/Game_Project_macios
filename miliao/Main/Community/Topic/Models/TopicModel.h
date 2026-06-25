//
//  TopicModel.h
//  miliao
//
//  Created by aa on 2019/7/6.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TopicModel : NSObject
//话题图片
@property (nonatomic, strong) NSString *topic_img;
//话题ID
@property (nonatomic, strong) NSString *tags;
//话题名称
@property (nonatomic, strong) NSString *tag_name;
//话题下动态条数
@property (nonatomic, strong) NSString *num;
//参与话题讨论数量
@property (nonatomic, strong) NSString *talk_num;
//参与话题讨论数量
@property (nonatomic, strong) NSString *reads;

@end

NS_ASSUME_NONNULL_END
