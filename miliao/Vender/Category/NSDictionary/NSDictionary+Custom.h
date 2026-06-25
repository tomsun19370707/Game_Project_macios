//
//  NSDictionary+Custom.h
//  FaceShow
//
//  Created by skyz on 2018/2/6.
//  Copyright © 2018年 GChao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Custom)
/**字典转data*/
- (NSData*)dictionaryToJson;
/**字典转json串*/
-(NSString *)convertToJsonData;
@end
