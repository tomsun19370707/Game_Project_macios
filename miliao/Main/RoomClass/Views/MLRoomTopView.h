//
//  MLRoomTopView.h
//  miliao
//
//  Created by aa on 2019/6/14.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "BaseView.h"

@interface MLRoomTopView : BaseView

@property (nonatomic , copy) void(^blackClickBlock)(void);
@property (nonatomic , copy) void(^listClickBlock)(void);
@property (nonatomic , copy) void(^announcementClickBlock)(void);
@property (nonatomic , copy) void(^moreAndMoreClickBlock)(void);
@property (nonatomic , copy) void(^collectionClickBlock)(void);
@property (weak, nonatomic) IBOutlet UILabel *UID;
@property(nonatomic, strong) UIButton *idLB;
@end
