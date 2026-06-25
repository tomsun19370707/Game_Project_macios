//
//  CommentModel.m
//  miliao
//
//  Created by aa on 2019/7/18.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "CommentModel.h"
#import "NSDate+Category.h"
#import "NSString+String.h"
#import "SDHelper.h"
@implementation CommentModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Tid": @"id"};
}
-(NSString *)created_at
{
    NSDate *timeDate = [NSDate timeStringToDate:_created_at];
//    MYLog(@"--%@",timeDate);
    NSString *requiredString = [timeDate dateToRequiredString];
    return requiredString;
}

- (CGFloat)cellHeight
{
    if (!_cellHeight) {
        if (self.reply.length >0) {
            NSString *string = [NSString stringWithFormat:@"回复%@:%@",self.reply,self.content];
            CGSize contentSize = [string sizeWithFont:[UIFont systemFontOfSize:14] With:ScreenWidth - 110];
            _cellHeight = contentSize.height + 50 + 15;
            return _cellHeight;
        }
        CGSize contentSize = [self.content sizeWithFont:[UIFont systemFontOfSize:14] With:ScreenWidth - 110];
        _cellHeight = contentSize.height + 50 +15;
    }
    return  _cellHeight;
}
@end
