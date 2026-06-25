//
//  SDTagsModel.m
//  miliao
//
//  Created by aa on 2019/7/10.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "SDTagsModel.h"

@implementation SDTagsModel
-(instancetype )initWithTagsDict:(NSDictionary *)dict{
    self =[super init];
    if(self ){
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(instancetype)tagsModelWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithTagsDict:dict];
}
//解档
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.title = [coder decodeObjectForKey:@"title"];
//        self.color = [coder decodeObjectForKey:@"color"];
    }
    return self;
}
//归档
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.title forKey:@"title"];
//    [aCoder encodeObject:self.color forKey:@"color"];
    
}

@end
