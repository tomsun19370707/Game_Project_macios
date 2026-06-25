//
//  CSPreMessageModel.h
//  VisitorSDKDemo
//
//  Created by Albert on 2019/11/28.
//  Copyright © 2019 Albert. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger,CSPreMessageType){
    /**
       CSPreMessageTypeCustom: 为图文混排展示方式:
                                1.只含有preText，则显示纯文本
                                2.只含有preImageUrl，则显示纯图片
                                3.二者兼有，则显示图文，默认图片在上，文本在下
     */
    CSPreMessageTypeCustom = 1
};

@interface CSPreMessageModel : NSObject

/** 下面三个参数可实现点击进聊天界面，自动发送设置消息.使用方法如下:
     1. 设置msgType (必要的)
     2. 设置text、imageUrl。
 */
@property (nonatomic, assign) CSPreMessageType msgType;    // 消息类型
@property (nonatomic, copy)   NSString         *text;      // 文本
@property (nonatomic, copy)   NSString         *imageUrl;  // 图片url

@end

