//
//  EMO_RoomChatHeaderView.m
//  miliao
//
//  Created by jkkj on 2023/11/6.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_RoomChatHeaderView.h"

@implementation EMO_RoomChatHeaderView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.height = 76;
        self.width  = kScreenWidth;
        [self createUI];
    }
    return self;
}

-(void)createUI{
    UIImageView *icon = [[UIImageView alloc] init];
    icon.image = KGetImage(@"sysMsgImg");
    [self addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_offset(56);
        make.top.mas_offset(10);
        make.left.mas_offset(14);
        make.bottom.mas_offset(-10);
    }];
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.textColor = [UIColor colorWithHexString:@"000000"];
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.textAlignment = NSTextAlignmentLeft;
    topLabel.font = KCFont(15);
    topLabel.text = @"系统消息";
    [self addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon.mas_right).offset(10);
        make.right.mas_offset(0);
        make.top.equalTo(icon.mas_top).offset(5);
        make.height.mas_offset(15);
    }];
    
    UILabel *downLabel = [[UILabel alloc] init];
    downLabel.textColor = [UIColor colorWithHexString:@"999999"];
    downLabel.backgroundColor = [UIColor clearColor];
    downLabel.textAlignment = NSTextAlignmentLeft;
    downLabel.font = KFont(13);
    downLabel.text = @"您有一条未读消息";
    [self addSubview:downLabel];
    [downLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon.mas_right).offset(10);
        make.right.mas_offset(0);
        make.bottom.equalTo(icon.mas_bottom).offset(-5);
        make.height.mas_offset(15);
    }];
}

@end
