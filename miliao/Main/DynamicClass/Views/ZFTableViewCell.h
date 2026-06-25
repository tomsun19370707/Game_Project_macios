//
//  ZFTableViewCell.h
//  ZFPlayer
//
//  Created by 紫枫 on 2018/4/3.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFTableData.h"
#import "ZFTableViewCellLayout.h"

@protocol ZFTableViewCellDelegate <NSObject>

- (void)zf_playTheVideoAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ZFTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *delBtn;

@property (nonatomic, strong) UIButton *followBtn;

@property (nonatomic, strong) ZFTableViewCellLayout *layout;

@property (nonatomic, strong, readonly) UIImageView *coverImageView;

@property (nonatomic, copy) void(^playCallback)(void);

- (void)setDelegate:(id<ZFTableViewCellDelegate>)delegate withIndexPath:(NSIndexPath *)indexPath;


- (void)showMaskView;

- (void)hideMaskView;

- (void)setNormalMode;

/**
 *  头像点击的block
 */
@property (nonatomic, copy)void(^headImgClickBlock)(void);

/**
 *  点赞按钮的block
 */
@property (nonatomic, copy)void(^likeBtnClickBlock)(UIButton *moreBtn,BOOL isExpand,ZFTableViewCellLayout *layot);
/**
 *  评论按钮的block
 */
@property (nonatomic, copy)void(^CommentBtnClickBlock)(UIButton *commentBtn,ZFTableViewCellLayout *layot);
/**
 *  删除按钮的block
 */
@property (nonatomic, copy)void(^delBtnClickBlock)(NSString *life_id);

/**
 *  更多按钮的block
 */
@property (nonatomic, copy)void(^MoreBtnClickBlock)(void);
/**
 *  发消息的block
 */
@property (nonatomic, copy)void(^SendMsgBtnClickBlock)(void);




@end
