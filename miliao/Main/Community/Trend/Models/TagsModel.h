//
//  TagsModel.h
//  miliao
//
//  Created by aa on 2019/7/10.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TagsModel : NSObject
//标签名
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *tags_id;
//cell高度
@property(assign,nonatomic) CGFloat cellWidth;
@property (nonatomic, assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
