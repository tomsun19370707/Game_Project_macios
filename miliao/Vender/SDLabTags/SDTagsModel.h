//
//  SDTagsModel.h
//  miliao
//
//  Created by aa on 2019/7/10.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDTagsModel : NSObject
<NSCoding>

/**
 标签标题
 */
@property (nonatomic,strong)NSString *title;

/**
 标签颜色
 */
//@property (nonatomic,strong)NSString *color;

-(instancetype )initWithTagsDict:(NSDictionary *)dict;
+(instancetype)tagsModelWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
