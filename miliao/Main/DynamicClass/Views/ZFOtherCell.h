//
//  ZFOtherCell.h
//  ZFPlayer_Example
//
//  Created by 任子丰 on 2018/6/21.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGGView.h"
#import "MessageInfoModel.h"

//#import "ZFTableData.h"
//#import "ZFTableViewCellLayout.h"

@interface ZFOtherCell : UITableViewCell

@property (nonatomic, strong) UIButton *delBtn;

@property (nonatomic, strong) UIButton *followBtn;

//@property (nonatomic, strong) ZFTableViewCellLayout *layout;

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
@property (nonatomic, copy)void(^likeBtnClickBlock)(UIButton *moreBtn,BOOL isExpand,MessageInfoModel *model);
/**
 *  评论按钮的block
 */
@property (nonatomic, copy)void(^CommentBtnClickBlock)(UIButton *commentBtn,MessageInfoModel *model);
/**
 *  删除按钮的block
 */
@property (nonatomic, copy)void(^delBtnClickBlock)(MessageInfoModel *model);

/**
 *  关注按钮的block
 */
@property (nonatomic, copy)void(^FollowBtnClickBlock)(UIButton *commentBtn,MessageInfoModel *model);
/**
 *  收藏按钮的block
 */
@property (nonatomic, copy)void(^CollectBtnClickBlock)(UIButton *moreBtn,BOOL isExpand,MessageInfoModel *model);

/**
 *  更多按钮的block
 */
@property (nonatomic, copy)void(^MoreBtnClickBlock)(void);
/**
 *  发消息的block
 */
@property (nonatomic, copy)void(^SendMsgBtnClickBlock)(void);


@end
