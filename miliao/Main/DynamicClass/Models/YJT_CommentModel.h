//
//  YJT_CommentModel.h
//  MeetHer
//
//  Created by 张世浩 on 2023/2/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YJT_CommentModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) NSArray *commentArray;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat commentHeight;

@end

NS_ASSUME_NONNULL_END
