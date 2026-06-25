//
//  detailTrendTableViewCell.h
//  miliao
//
//  Created by aa on 2019/7/23.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendModel.h"
@class detailTrendTableViewCell;
NS_ASSUME_NONNULL_BEGIN
@protocol detailTrendCellDelegate <NSObject>
- (void)detailTrendTableViewCell:(detailTrendTableViewCell*)cell likeBtnClick:(id)sender;
- (void)detailTrendTableViewCell:(detailTrendTableViewCell*)cell collectionBtnClick:(id)sender;
- (void)detailTrendTableViewCell:(detailTrendTableViewCell*)cell forwardBtnClick:(id)sender;
- (void)detailTrendTableViewCell:(detailTrendTableViewCell*)cell commentBtnClick:(id)sender;
- (void)detailTrendTableViewCell:(detailTrendTableViewCell*)cell detailClick:(id)sender;
- (void)detailTrendTableViewCell:(detailTrendTableViewCell*)cell cellRightBtnClick:(id)sender;
- (void)detailTrendTableViewCell:(detailTrendTableViewCell*)cell attentationBtnClick:(id)sender;
@end


@interface detailTrendTableViewCell : UITableViewCell
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
@property (strong, nonatomic)  YYLabel *ContentLabel;
@property (weak, nonatomic) IBOutlet UIView *BottomView;
@property (weak, nonatomic) IBOutlet UIButton *AttentionBtn;
@property (weak,nonatomic)id<detailTrendCellDelegate>delegate;
@property (strong,nonatomic)TrendModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLeading;
@end

NS_ASSUME_NONNULL_END
