//
//  EMO_WMTimeLineHeaderView.h
//  WeChat
//
//  Created by zhengwenming on 2017/9/18.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGGView.h"
#import "MessageInfoModel.h"


@interface EMO_WMTimeLineHeaderView : UITableViewHeaderFooterView


@property (nonatomic, strong, readonly) UIImageView *coverImageView;

@property (nonatomic, copy) void(^playCallback)(UIImageView *coverImgView);


@property(nonatomic,retain)MessageInfoModel *model;
///**
// *  点击图片的block
// */
@property (nonatomic, copy)TapBlcok tapImageBlock;

/**
 *  头像点击的block
 */
@property (nonatomic, copy)void(^headImgClickBlock)(void);

/**
 *  点赞按钮的block
 */
@property (nonatomic, copy)void(^likeBtnClickBlock)(UIButton *moreBtn,BOOL isExpand);
/**
 *  评论按钮的block
 */
@property (nonatomic, copy)void(^CommentBtnClickBlock)(UIButton *commentBtn);

/**
 *  更多按钮的block
 */
@property (nonatomic, copy)void(^MoreBtnClickBlock)(void);
/**
 *  发消息的block
 */
@property (nonatomic, copy)void(^SendMsgBtnClickBlock)(void);





@end
