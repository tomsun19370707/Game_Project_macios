//
//  TagsModel.m
//  miliao
//
//  Created by aa on 2019/7/10.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "TagsModel.h"

@implementation TagsModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"tags_id": @"id"};
}
- (CGFloat)cellWidth
{
    if (!_cellWidth) {
         _cellWidth = [SDHelper widthForLabel:[NSString stringWithFormat:@"%@",self.name] fontSize:12];
    }
    return _cellWidth;
}
@end
