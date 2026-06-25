//
//  TSMusicPlayerOpr.h
//  TreasureUser
//
//  Created by Dylan on 2024/12/20.
//

#import <UIKit/UIKit.h>

@interface TSMusicPlayerOpr : UITableViewCell
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *time1;
@property (weak, nonatomic) IBOutlet UILabel *time2;
@property (weak, nonatomic) IBOutlet UIButton *frontBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *oprBtn;
@property (weak, nonatomic) IBOutlet UIButton *modeBtn;

/** 是否有间隔*/
@property (nonatomic,assign) BOOL hasMargin;
/** 模式切换 1列表循环 2随机 3单曲 */
@property (nonatomic,assign) int playMode;

/** 点击音乐，外界决定是否跳转到播放详情里去*/
@property (nonatomic,copy) void (^fetchClickMusicLook)(void);
/** 音乐信息*/
@property (nonatomic,strong) GoodListInfoModel *model;

/** 0上一首 1下一首 2开始/暂停*/
@property (nonatomic,copy) void (^fetchClick)(int opr);
@end
