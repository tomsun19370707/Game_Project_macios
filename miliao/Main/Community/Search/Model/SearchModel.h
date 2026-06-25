//
//  SearchModel.h
//  miliao
//
//  Created by aa on 2019/8/7.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchModel : NSObject
//id
@property (nonatomic, strong) NSString *search_id;
//内容
@property (nonatomic, strong) NSString *search;
@end

NS_ASSUME_NONNULL_END
