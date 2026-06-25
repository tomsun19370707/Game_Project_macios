//
//  RoomSetRoomIconCell.m
//  miliao
//
//  Created by aa on 2019/7/4.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "RoomSetRoomIconCell.h"

#import "Global.h"

@interface RoomSetRoomIconCell ()

@property (nonatomic, strong) UILabel *roomNameLB;


@property (nonatomic, strong) UIImageView *arrowIcon;

@property (nonatomic, strong) UIView *bgView;

@end

@implementation RoomSetRoomIconCell

#pragma mark - 快速创建cell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"RoomSetRoomIconCell";
    
    RoomSetRoomIconCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[RoomSetRoomIconCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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

- (void)addSomeViews{
    
    [self.contentView addSubview:self.roomNameLB];
    [self.contentView addSubview:self.roomIcon];
    [self.contentView addSubview:self.arrowIcon];
    [self.contentView addSubview:self.bgView];
    
    [self.roomNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(14);
    }];
    [self.arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-15);
        make.height.mas_equalTo(34);
        make.width.mas_equalTo(15);
    }];
    [self.roomIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
//        make.right.mas_equalTo(self.arrowIcon.mas_left).offset(-5);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(11);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(self).offset(-11);
        make.bottom.mas_equalTo(self);
    }];
}
- (UILabel *)roomNameLB{
    if (!_roomNameLB) {
        _roomNameLB = [ControlCreator createLabel:nil rect:CGRectMake(0, 0, 0, 0) text:@"房间封面" font:Font(14) color:mainViceColor backguoundColor:[UIColor clearColor] align:NSTextAlignmentLeft lines:1];
    }
    return _roomNameLB;
}
- (UIImageView *)roomIcon{
    if (!_roomIcon) {
        _roomIcon = [ControlCreator createImageView:nil rect:CGRectMake(0, 0, 0, 0) imageName:@"" backguoundColor:[UIColor clearColor]];
        _roomIcon.contentMode = UIViewContentModeScaleAspectFill;
        _roomIcon.layer.masksToBounds = YES;
        _roomIcon.layer.cornerRadius = 25;
    }
    return _roomIcon;
}
- (UIImageView *)arrowIcon{
    if (!_arrowIcon) {
//        _arrowIcon = [ControlCreator createImageView:nil rect:CGRectMake(0, 0, 0, 0) imageName:@"mineRightImg" backguoundColor:[UIColor clearColor]];
        _arrowIcon = [ControlCreator createImageView:nil rect:CGRectMake(0, 0, 0, 0) imageName:@"" backguoundColor:[UIColor clearColor]];
    }
    return _arrowIcon;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [ControlCreator createView:nil rect:CGRectMake(0, 0, 0, 0) backguoundColor:MLControlsHuiColor];
    }
    return _bgView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
