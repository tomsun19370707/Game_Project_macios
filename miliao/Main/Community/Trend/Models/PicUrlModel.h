//
//  PicUrlModel.h
//  miliao
//
//  Created by aa on 2019/7/10.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PicUrlModel : NSObject
//图片url
@property (nonatomic, strong) NSString *image_url;
@property(assign,nonatomic,readonly)CGSize size;

@end

NS_ASSUME_NONNULL_END
