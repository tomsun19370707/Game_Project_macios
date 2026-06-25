//
//  TrendTableViewCell.h
//  miliao
//
//  Created by aa on 2019/7/5.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendModel.h"


NS_ASSUME_NONNULL_BEGIN
@class TrendTableViewCell;
@protocol TrendCellDelegate <NSObject>

- (void)trendTableViewCell:(TrendTableViewCell*)cell likeBtnClick:(id)sender;
- (void)trendTableViewCell:(TrendTableViewCell*)cell collectionBtnClick:(id)sender;
- (void)trendTableViewCell:(TrendTableViewCell*)cell forwardBtnClick:(id)sender;
- (void)trendTableViewCell:(TrendTableViewCell*)cell commentBtnClick:(id)sender;
- (void)trendTableViewCell:(TrendTableViewCell*)cell detailClick:(id)sender;
- (void)trendTableViewCell:(TrendTableViewCell*)cell cellRightBtnClick:(id)sender;
- (void)trendTableViewCell:(TrendTableViewCell*)cell attentationBtnClick:(id)sender;
- (void)trendTableViewCell:(TrendTableViewCell*)cell IconClick:(id)sender;
@end
@interface TrendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *IconImage;

@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *VIPImageView;
@property (weak, nonatomic) IBOutlet UIImageView *TopImageView;
@property (weak, nonatomic) IBOutlet UIImageView *GenderImageView;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *CollectionBtn;
@property (weak, nonatomic) IBOutlet UIButton *CommentBtn;
@property (weak, nonatomic) IBOutlet UILabel *CommentLabel;
@property (weak, nonatomic) IBOutlet UIButton *LikeBtn;
@property (weak, nonatomic) IBOutlet UILabel *LikeLabel;
@property (weak, nonatomic) IBOutlet UIButton *ForwardBtn;
@property (weak, nonatomic) IBOutlet UILabel *ForwardLabel;
@property (weak, nonatomic) IBOutlet UIButton *MoreBtn;
@property (strong, nonatomic)  YYLabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *BottomView;
@property (weak, nonatomic) IBOutlet UIButton *AttentionBtn;
@property (weak,nonatomic)id<TrendCellDelegate>delegate;
@property(nonatomic, strong) UIView *grayBottomView;//灰色底部10高度


@property (strong,nonatomic)TrendModel *model;
@property (nonatomic,assign) BOOL isBigPicture;//是否为详情页面显示大图

@property (nonatomic , copy) void(^playBtnActionBlock)(BOOL btnSelected, TrendModel *model);


@end

NS_ASSUME_NONNULL_END
