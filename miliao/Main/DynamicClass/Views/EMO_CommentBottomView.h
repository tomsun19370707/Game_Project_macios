//
//  EMO_CommentBottomView.h
//  MeetHer
//
//  Created by 张世浩 on 2023/2/16.
//

#import "BaseView.h"
#import "MessageInfoModel.h"

#import "ZFTableData.h"
#import "ZFTableViewCellLayout.h"
NS_ASSUME_NONNULL_BEGIN

@interface EMO_CommentBottomView : BaseView

Strong UIView *bgView;
Strong UIButton *likeBtn;
Strong UIButton *commentBtn;
Strong UIButton *collectBtn;
@property (nonatomic,strong) CustomeBtn *reportBtn;


@property (nonatomic, strong) ZFTableViewCellLayout *layout;

@property(nonatomic,retain)MessageInfoModel *model;

/** 是否显示做右侧的  举报*/
@property (nonatomic,assign) BOOL showReport;
@end

NS_ASSUME_NONNULL_END
