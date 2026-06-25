//
//  RouletteView.m
//  NTRoulette
//
//  Created by 孙勇 on 2020/3/28.
//  Copyright © 2020 yy. All rights reserved.
//

#import "RouletteView.h"
#import "Masonry.h"
//随机色
#define RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
#define turnScale_W self.bounds.size.width/300
#define turnScale_H self.bounds.size.height/300

@interface RouletteView()


@end


@implementation RouletteView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    
    // 外围装饰背景图
    UIImageView * backImageView = [UIImageView new];
    backImageView.image = [UIImage imageNamed:@"UY_ChouJiangBackImg"];
    [self addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_offset(0);
    }];
    
    self.rotateWheel = [[UIImageView alloc]init];
    self.rotateWheel.image = [UIImage imageNamed:@"UY_CenterBackImg"];
    [self addSubview:self.rotateWheel];
    [self.rotateWheel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
        make.top.mas_offset(20);
        make.bottom.mas_offset(-20);
    }];
    [self.rotateWheel layoutIfNeeded];
    
    UIView *playBtnBackImg = [[UIView alloc] init];
    playBtnBackImg.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    [self addSubview:playBtnBackImg];
    [playBtnBackImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_offset(215);
        make.center.equalTo(self);
    }];
    setViewCorner(playBtnBackImg, 215/2);
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"UY_CenterBtnImg"] forState:0];
    [self addSubview:self.playButton];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(70);
        make.height.mas_offset(80);
        make.center.equalTo(self);
    }];
}
-(void)giftArray:(NSArray *)giftArray{
    self.numberArray = giftArray;
    [self.rotateWheel removeAllSubviews];
    NSDictionary *lastImgDic = giftArray[0];
    for (int i = 0; i < giftArray.count; i ++) {
        NSDictionary *giftDic = giftArray[i];
        UIView *itemView = [[UIView alloc] init];
        itemView.backgroundColor = UIColor.clearColor;
        itemView.frame = CGRectMake(0, 0,M_PI * self.rotateWheel.frame.size.width/giftArray.count,
            self.rotateWheel.frame.size.height/2);
        itemView.layer.anchorPoint = CGPointMake(0.5, 1.0);
        itemView.center = CGPointMake(self.rotateWheel.frame.size.width/2, self.rotateWheel.frame.size.height/2);
        CGFloat angle = i *2 * M_PI / giftArray.count;
        CGFloat danAngle = 2 * M_PI / giftArray.count/2;
        itemView.transform = CGAffineTransformMakeRotation(angle-danAngle);
        [self.rotateWheel addSubview:itemView];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50*turnScale_W, 70, 30, 30)];
        [itemView addSubview:imageView];
        NSDictionary *imgDic = @{};
        if(i==giftArray.count-1){
            imgDic = lastImgDic;
        }else{
            imgDic = giftArray[i+1];
        }
//        if([imgDic[@"type"] integerValue]==0){
//            imgStr = @"giftIconImg2";
//        }else if ([imgDic[@"type"] integerValue]==1){
//            imgStr = @"giftIconImg4";
//        }else
        if ([imgDic[@"type"] integerValue]==2){
            imageView.image = KGetImage(@"giftIconImg6");
        }else if ([imgDic[@"type"] integerValue]==3){
            imageView.image = KGetImage(@"giftIconImg3");
        }else{
            [imageView sd_setImageWithURL:[NSURL URLWithString:[Common isNull:imgDic[@"dress_image"]]] placeholderImage:defaultionPhotoIcon];
        }
        
        
        UILabel *label = [[UILabel alloc]init];
        label.text = [NSString stringWithFormat:@"%@", giftDic[@"type_text"]];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:10];
        CGFloat rotationAngle = M_PI/10;
        label.transform = CGAffineTransformMakeRotation(-rotationAngle);
        [itemView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(-10);
            make.top.mas_offset(37);
            make.height.mas_offset(30);
        }];
    }
}

@end
