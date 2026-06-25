//
//  RoomMusicTableViewCell.m
//  miliao
//
//  Created by aa on 2019/7/16.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "RoomMusicTableViewCell.h"

#import "RoomMusicModel.h"

@interface RoomMusicTableViewCell ()

@property (nonatomic, strong) UIImageView               *icon;
@property (nonatomic, strong) UILabel                   *musicName;
@property (nonatomic, strong) UILabel                   *singer;
@property (nonatomic, strong) UIButton                  *playAndSuspended;
@property (nonatomic, strong) UILabel                   *upload_user;
@property (nonatomic, strong) UILabel                   *musicSize;

@property (nonatomic, strong) UIView                    *lineView;

@property (nonatomic, strong) UIView                    *playIng;
@property (nonatomic, strong) UILongPressGestureRecognizer *singleTap;



@end


@implementation RoomMusicTableViewCell

#pragma mark - 快速创建cell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"RoomMusicTableViewCell";
    
    RoomMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[RoomMusicTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        //        cell.selectedBackgroundView = cell.seletView ;
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSomeViews];
    }
    return self;
}
 -(void)singleTapGesture:(UILongPressGestureRecognizer*)sender{
      if (sender.state == UIGestureRecognizerStateBegan) {
         ! self.singleTapGestureClickBlock ?: self.singleTapGestureClickBlock(self.model);
      }
 }
- (void)playAndSuspendedClick:(UIButton *)sender{
//    if ([self.model.isPlay integerValue] == 1) {
//        [self.playAndSuspended setBackgroundImage:[UIImage imageNamed:@"music_yinyueku_zanting"] forState:UIControlStateNormal];
//    }else{
//
//    }
    
    ! self.playAndSuspendedClickBlock ?: self.playAndSuspendedClickBlock(self.model);
}
- (void)setModel:(RoomMusicModel *)model{
    _model = model;
    _singleTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapGesture:)];//初始化一个长按手势
    [_singleTap setMinimumPressDuration:1.5];//设置按多久之后触发事件
    [self addGestureRecognizer:_singleTap];
    
    if ([model.is_mymusic integerValue] == 1) {
        if ([model.myMusic isEqualToString:@"1"]) {
            if ([model.isPlay integerValue] == 1) {
                [self.playAndSuspended setBackgroundImage:[UIImage imageNamed:@"music_yinyueku_zanting"] forState:UIControlStateNormal];
                self.playIng.hidden = NO;
            }else if([model.isPlay integerValue] == 2){
                [self.playAndSuspended setBackgroundImage:[UIImage imageNamed:@"music_yinyueku_bofang"] forState:UIControlStateNormal];
                self.playIng.hidden = YES;
            }else{
                [self.playAndSuspended setBackgroundImage:[UIImage imageNamed:@"music_yinyueku_bofang"] forState:UIControlStateNormal];
                self.playIng.hidden = NO;
            }
        }else{
            self.playAndSuspended.hidden = YES;
            self.playIng.hidden = YES;
            [self removeGestureRecognizer:_singleTap];
        }
    }else{
        [self.playAndSuspended setBackgroundImage:[UIImage imageNamed:@"music_tianjia"] forState:UIControlStateNormal];
        self.playAndSuspended.hidden = NO;
        self.playIng.hidden = YES;
        [self removeGestureRecognizer:_singleTap];
    }
    self.musicName.text = model.music_name;
    self.musicSize.text = model.music_size;
    self.singer.text = model.singer;
    self.upload_user.text = model.upload_user;
}

- (void)addSomeViews{
    
    [self.contentView addSubview:self.musicName];
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.singer];
    [self.contentView addSubview:self.upload_user];
    [self.contentView addSubview:self.musicSize];
    [self.contentView addSubview:self.playAndSuspended];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.playIng];
    
    [self.musicName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(10);
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.musicName.mas_left);
        make.top.mas_equalTo(self.musicName.mas_bottom).offset(5);
        make.height.mas_equalTo(11);
        make.width.mas_equalTo(11);
    }];
    [self.singer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).offset(10);
        make.centerY.mas_equalTo(self.icon.mas_centerY);
    }];
    [self.upload_user mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.musicName.mas_left);
        make.top.mas_equalTo(self.icon.mas_bottom).offset(4);
    }];
    [self.musicSize mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.upload_user.mas_right).offset(20);
        make.centerY.mas_equalTo(self.upload_user.mas_centerY);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(1);
    }];
    [self.playAndSuspended mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-20);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(23);
        make.width.mas_equalTo(23);
    }];
    [self.playIng mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(35);
    }];
}


- (UILabel *)musicName{
    if (!_musicName) {
        _musicName = [ControlCreator createLabel:nil rect:CGRectZero text:@"" font:Font(14) color:mainViceColor backguoundColor:[UIColor clearColor] align:NSTextAlignmentLeft lines:1];
    }
    return _musicName;
}
- (UIImageView *)icon{
    if (!_icon) {
        _icon = [ControlCreator createImageView:nil rect:CGRectZero imageName:@"music_yinyueku" backguoundColor:[UIColor clearColor]];
    }
    return _icon;
}

- (UILabel *)singer{
    if (!_singer) {
        _singer = [ControlCreator createLabel:nil rect:CGRectZero text:@"" font:Font(11) color:mainQianColor backguoundColor:[UIColor clearColor] align:NSTextAlignmentLeft lines:1];
    }
    return _singer;
}
- (UILabel *)upload_user{
    if (!_upload_user) {
        _upload_user = [ControlCreator createLabel:nil rect:CGRectZero text:@"" font:Font(11) color:mainQianColor backguoundColor:[UIColor clearColor] align:NSTextAlignmentLeft lines:1];
    }
    return _upload_user;
}
- (UILabel *)musicSize{
    if (!_musicSize) {
        _musicSize = [ControlCreator createLabel:nil rect:CGRectZero text:@"" font:Font(11) color:mainQianColor backguoundColor:[UIColor clearColor] align:NSTextAlignmentLeft lines:1];
    }
    return _musicSize;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:MLControlsHuiColor];
    }
    return _lineView;
}
- (UIButton *)playAndSuspended{
    if (!_playAndSuspended) {
        _playAndSuspended = [ControlCreator createButton:nil rect:CGRectZero text:@"" font:Font(11) color:[UIColor clearColor] backguoundColor:[UIColor clearColor] imageName:@"music_yinyueku_bofang" target:self action:@selector(playAndSuspendedClick:)];
    }
    return _playAndSuspended;
}
- (UIView *)playIng{
    if (!_playIng) {
        _playIng = [ControlCreator createView:nil rect:CGRectZero backguoundColor:MLControlsColor];
    }
    return _playIng;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (BOOL)canBecomeFirstResponder{
    
    return YES;
    
}
@end
