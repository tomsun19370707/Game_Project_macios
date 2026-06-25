//
//  EMO_CommentXQTableCell.h
//  MeetHer
//
//  Created by 张世浩 on 2023/2/17.
//

#import <UIKit/UIKit.h>

#import "CommentInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface EMO_CommentXQTableCell : UITableViewCell

@property (nonatomic, strong) NSMutableDictionary *modelDic;

Copy void(^BtnClick)(NSMutableDictionary *dic, NSInteger tag);


@end

NS_ASSUME_NONNULL_END
