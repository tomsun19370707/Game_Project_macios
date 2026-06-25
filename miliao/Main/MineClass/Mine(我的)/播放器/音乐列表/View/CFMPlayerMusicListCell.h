//
//  CFMPlayerMusicListCell.h
//  miliao
//
//  Created by Dylan Lee on 2025/12/29.
//  Copyright © 2025 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFMPlayerMusicListCell : UITableViewCell
/** 是否在播放的标识*/
@property (weak, nonatomic) IBOutlet UIImageView *mark;

@property (nonatomic,strong) GoodListInfoModel *model;
@end
