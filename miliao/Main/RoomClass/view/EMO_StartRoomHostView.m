//
//  EMO_StartRoomHostView.m
//  miliao
//
//  Created by aa on 2019/6/14.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "EMO_StartRoomHostView.h"
#import "EMO_RoomHostUserView.h"
@interface EMO_StartRoomHostView ()

@property (nonatomic, strong) UIImageView    *hostIcon;
@property (nonatomic, strong) UILabel        *hostName;//房主名字
@property (strong, nonatomic) EMO_RoomHostUserView   *roomHostView1;
@property (strong, nonatomic) EMO_RoomHostUserView   *roomHostView2;
@property (strong, nonatomic) EMO_RoomHostUserView   *roomHostView3;
@property (strong, nonatomic) EMO_RoomHostUserView   *roomHostView4;
@property (strong, nonatomic)  EMO_RoomHostUserView   *roomHostView5;
@property (strong, nonatomic)  EMO_RoomHostUserView   *roomHostView6;
@property (strong, nonatomic)  EMO_RoomHostUserView   *roomHostView7;
@property (strong, nonatomic) EMO_RoomHostUserView *roomHostView8;
@property (weak, nonatomic) IBOutlet UIStackView *stackView1;
@property (weak, nonatomic) IBOutlet UIStackView *stackView2;
@property (nonatomic, strong) NSArray               *roomHostViews;


@end

@implementation EMO_StartRoomHostView


- (void)awakeFromNib{
    [super awakeFromNib];
    ///主播麦位
    UIView *container = [[UIView alloc] init];
    [self addSubview:container];
    
    self.hostIcon = [[UIImageView alloc] init];
    self.hostIcon.backgroundColor = [UIColor clearColor];
    self.hostIcon.userInteractionEnabled = YES;
    self.hostIcon.image=KGetImage(@"shangMaiImg1");
    [container addSubview:self.hostIcon];
    ///主播名字
    self.hostName = [[UILabel alloc] init];
    self.hostName.textColor = [UIColor whiteColor];
    self.hostName.font = FONT_14;
    self.hostName.text=getLanguage(@"0号麦");
    self.hostName.textAlignment = NSTextAlignmentCenter;
    [container addSubview:self.hostName];

    container.mas_key = @"asdfr";
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(@90);
        make.height.equalTo(@100);
    }];
    
    [self.hostIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container).offset(12.5);
        make.top.equalTo(container).offset(8);
        make.right.equalTo(container).offset(-12.5);
        make.height.equalTo(self.hostIcon.mas_width);
    }];
    
  
    [self.hostName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.hostIcon);
        make.top.equalTo(self.hostIcon.mas_bottom).offset(KAdaptedHeight(5));
        make.height.equalTo(@14);
    }];
    
    
    [self layoutIfNeeded];

    [self bringSubviewToFront:self.hostIcon];

    
    self.stackView1.axis = UILayoutConstraintAxisHorizontal;
    self.stackView1.distribution = UIStackViewDistributionFillEqually;
    self.stackView1.spacing = 0;
    self.stackView1.alignment = UIStackViewAlignmentFill;
    
    [self.stackView1 addArrangedSubview:self.roomHostView1];
    [self.stackView1 addArrangedSubview:self.roomHostView2];
    [self.stackView1 addArrangedSubview:self.roomHostView3];
    [self.stackView1 addArrangedSubview:self.roomHostView4];
    
    self.stackView2.axis = UILayoutConstraintAxisHorizontal;
    self.stackView2.distribution = UIStackViewDistributionFillEqually;
    self.stackView2.spacing = 0;
    self.stackView2.alignment = UIStackViewAlignmentFill;
    
    [self.stackView2 addArrangedSubview:self.roomHostView5];
    [self.stackView2 addArrangedSubview:self.roomHostView6];
    [self.stackView2 addArrangedSubview:self.roomHostView7];
    [self.stackView2 addArrangedSubview:self.roomHostView8];
    
    [self.stackView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.equalTo(@102);
        make.bottom.equalTo(self.stackView2.mas_top);
    }];
    
    [self.stackView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stackView1.mas_bottom);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.equalTo(@102);
        make.bottom.equalTo(self);
    }];
    
    [self layoutIfNeeded];
    [self.roomHostViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EMO_RoomHostUserView *roomHostView = obj;
        roomHostView.hostIcon.layer.cornerRadius = CGRectGetWidth(roomHostView.hostIcon.frame)/2.0;
        roomHostView.hostIcon.layer.masksToBounds = YES;
        roomHostView.hostIcon.layer.borderWidth = 2.f;
        roomHostView.hostIcon.layer.borderColor = [UIColor clearColor].CGColor;
        roomHostView.tag = idx + 1;
        roomHostView.closeIcon.hidden = YES;
        roomHostView.bottomLabel.hidden=YES;
        if(idx==0){
            roomHostView.hostName.text=@"老板麦";
            roomHostView.hostIcon.image=KGetImage(@"shangMaiImg2");
        }else{
            roomHostView.hostName.text=[NSString stringWithFormat:@"%ld号麦",idx+1];
        }
//        roomHostView.mALB.text =[NSString stringWithFormat:@"%ld",idx+1];
        roomHostView.waveLayer.hidden=YES;
    }];
    
    
    
}

- (void)loadData:(id)obj{
    [super loadData:obj];
}


- (NSArray *)roomHostViews{
    if (!_roomHostViews) {
        _roomHostViews = @[self.roomHostView1, self.roomHostView2, self.roomHostView3, self.roomHostView4, self.roomHostView5, self.roomHostView6, self.roomHostView7,self.roomHostView8];
    }
    return _roomHostViews;
}


- (EMO_RoomHostUserView *)roomHostView1
{
    if (!_roomHostView1) {
        _roomHostView1 = [[NSBundle mainBundle] loadNibNamed:@"EMO_RoomHostUserView" owner:nil options:nil].lastObject;
        
    }
    return _roomHostView1;
}
- (EMO_RoomHostUserView *)roomHostView2
{
    if (!_roomHostView2) {
        _roomHostView2 = [[NSBundle mainBundle] loadNibNamed:@"EMO_RoomHostUserView" owner:nil options:nil].lastObject;
    }
    return _roomHostView2;
}
- (EMO_RoomHostUserView *)roomHostView3
{
    if (!_roomHostView3) {
        _roomHostView3 = [[NSBundle mainBundle] loadNibNamed:@"EMO_RoomHostUserView" owner:nil options:nil].lastObject;
    }
    return _roomHostView3;
}
- (EMO_RoomHostUserView *)roomHostView4
{
    if (!_roomHostView4) {
        _roomHostView4 = [[NSBundle mainBundle] loadNibNamed:@"EMO_RoomHostUserView" owner:nil options:nil].lastObject;
    }
    return _roomHostView4;
}
- (EMO_RoomHostUserView *)roomHostView5
{
    if (!_roomHostView5) {
        _roomHostView5 = [[NSBundle mainBundle] loadNibNamed:@"EMO_RoomHostUserView" owner:nil options:nil].lastObject;
    }
    return _roomHostView5;
}
- (EMO_RoomHostUserView *)roomHostView6
{
    if (!_roomHostView6) {
        _roomHostView6 = [[NSBundle mainBundle] loadNibNamed:@"EMO_RoomHostUserView" owner:nil options:nil].lastObject;
    }
    return _roomHostView6;
}
- (EMO_RoomHostUserView *)roomHostView7
{
    if (!_roomHostView7) {
        _roomHostView7 = [[NSBundle mainBundle] loadNibNamed:@"EMO_RoomHostUserView" owner:nil options:nil].lastObject;
    }
    return _roomHostView7;
}
- (EMO_RoomHostUserView *)roomHostView8
{
    if (!_roomHostView8) {
        _roomHostView8 = [[NSBundle mainBundle] loadNibNamed:@"EMO_RoomHostUserView" owner:nil options:nil].lastObject;
    }
    return _roomHostView8;
}
@end
