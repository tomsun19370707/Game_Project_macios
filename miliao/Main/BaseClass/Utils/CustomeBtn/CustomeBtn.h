//
//  CustomeBtn.h
//  GroupPurchaseProject
//
//  Created by 锤子科技 on 2017/8/12.
//  Copyright © 2017年 锤子科技. All rights reserved.
//

/*
 自定义button，可以同时展示图片和文字
 */


#import <UIKit/UIKit.h>
typedef enum {
    CustomeBtnTypeDefault,     // 左字右图
    CustomeBtnTypeLeftImageAndRightTitle,  // 左图右字
    CustomeBtnTypeTopImageAndBottomTitle,  // 上图下字
    CustomeBtnTypeTopTitleAndBottomImage,  // 上字下图
    CustomeBtnTypeTopTitleAndBottomTitle,  // 上字下字
}CustomeBtnType;

@interface CustomeBtn : UIView
@property (nonatomic,strong)UIImage *image;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *topTitle;//仅仅用于 上字下字 类型中
@property (nonatomic,assign)CustomeBtnType type;
@property (nonatomic,strong)UIColor *textColor;
@property (nonatomic,strong)UIFont *font;
@property (nonatomic,assign)CGFloat iconWidth;    //图片宽度
@property (nonatomic,assign)CGFloat lableHeight;    //文字高度
//仅仅用于 上字下字 类型中
@property (nonatomic,strong)UILabel *topLab;
/** 点击事件*/
- (void)actionHandle:(void(^)(void))actionHandle;

//最后手动调用
- (void)sizeToFitForCurrentSetting;
@end




