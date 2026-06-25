//
//  SingleSwitchView.h
//  NormalProject
//
//  Created by 大靠山Mac mini on 2021/10/18.
//  Copyright © 2021 WYL. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SingleSwitchView : UIView

// 设置左标题
@property (nonatomic,strong)NSString *nameStr;
//左边标题的Label,外部可控制其相关属性。
@property (nonatomic,strong)UILabel *nameLabel;
//显示提示label,默认隐藏
@property (nonatomic,strong)UILabel *tipLabel;

@property (nonatomic,strong)NSString *tipStr;
//右边switch开关。
@property (nonatomic,strong)UISwitch *switchBtn;
//是否显示提示label,
@property (nonatomic,assign)BOOL showTipLabel;
//是否显示提示label,
@property (nonatomic,assign)BOOL showIcon;
//是否为必填项的图标，默认隐藏，在部分场景下需要将其显示
@property (nonatomic,strong)UIImageView *icon;

//底部线
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic,copy)void (^SwitchClick)(BOOL Open);

@end

NS_ASSUME_NONNULL_END
