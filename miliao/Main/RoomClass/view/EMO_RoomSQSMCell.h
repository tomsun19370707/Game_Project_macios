//
//  EMO_RoomSQSMCell.h
//  miliao
//
//  Created by jkkj on 2021/7/6.
//  Copyright © 2021 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface EMO_RoomSQSMCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *model;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,weak)IBOutlet UIImageView *icon;
@property (nonatomic,weak)IBOutlet UILabel *name;
@property (nonatomic,weak)IBOutlet UIButton *RefusedBtn;
@property (nonatomic,weak)IBOutlet UIButton *determineBtn;
@property (nonatomic , copy) void(^cellClickBlock)(NSDictionary *model,NSInteger index,NSInteger tag);
- (void)cellModel:(NSDictionary *)model index:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
