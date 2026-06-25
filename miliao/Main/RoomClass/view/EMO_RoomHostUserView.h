//
//  EMO_RoomHostView.h
//  miliao
//
//  Created by aa on 2019/6/15.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "BaseView.h"

#import "XLKWavePulsLayer.h"

@interface EMO_RoomHostUserView : BaseView

@property (nonatomic, strong) SVGAImageView    *headSvgaImg;//头像框
@property (strong, nonatomic) UIImageView *hostIcon;
@property (strong, nonatomic) UIImageView *headIconImg;
@property (strong, nonatomic) UILabel *hostName;
//@property (strong, nonatomic) UIImageView *hostNameVipImg;
@property (strong, nonatomic) UIImageView *gradeImgView;
@property (strong, nonatomic) UIImageView *closeIcon;
@property (strong, nonatomic) UIImageView *genderIcon;
@property (strong, nonatomic) UILabel *mALB;            ///< 编号
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) XLKWavePulsLayer *waveLayer;
@property (nonatomic, strong) UIImageView *expreImage;          ///< 显示发送表情
@property(nonatomic, strong) UIButton *bottomLabel;//显示魅力值
@property (nonatomic, strong) UIImageView *hostIconBox;
@property(nonatomic, strong) NSString *meiLiString;//魅力值


@end
