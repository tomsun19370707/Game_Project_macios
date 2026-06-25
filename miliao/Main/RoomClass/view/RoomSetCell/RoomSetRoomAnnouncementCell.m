//
//  RoomSetRoomAnnouncementCell.m
//  miliao
//
//  Created by aa on 2019/7/4.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "RoomSetRoomAnnouncementCell.h"

#import "Global.h"

@interface RoomSetRoomAnnouncementCell ()

@property (nonatomic, strong) UILabel *roomNameLB;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *arrowIcon;

@end


@implementation RoomSetRoomAnnouncementCell

#pragma mark - 快速创建cell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"RoomSetRoomAnnouncementCell";
    
    RoomSetRoomAnnouncementCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[RoomSetRoomAnnouncementCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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

-(void)setNotice:(NSString *)notice{
    
    
    
}



- (void)addSomeViews{
    [self.contentView addSubview:self.roomNameLB];
    [self.contentView addSubview:self.arrowIcon];
    [self.contentView addSubview:self.contentLabel];
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
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.roomNameLB.mas_right).offset(0);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.arrowIcon.mas_left).offset(-5);
        make.height.mas_equalTo(35);
    }];
   
    
    
}
- (UILabel *)roomNameLB{
    if (!_roomNameLB) {
        _roomNameLB = [ControlCreator createLabel:nil rect:CGRectMake(0, 0, 0, 0) text:@"房间公告" font:Font(14) color:mainViceColor backguoundColor:[UIColor clearColor] align:NSTextAlignmentLeft lines:1];
    }
    return _roomNameLB;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [ControlCreator createLabel:nil rect:CGRectMake(0, 0, 0, 0) text:@"" font:KFontA(13) color:mainViceColor backguoundColor:[UIColor clearColor] align:NSTextAlignmentRight lines:1];
    }
    return _contentLabel;
}

- (UIImageView *)arrowIcon{
    if (!_arrowIcon) {
        _arrowIcon = [ControlCreator createImageView:nil rect:CGRectMake(0, 0, 0, 0) imageName:@"mineRightImg" backguoundColor:[UIColor clearColor]];
    }
    return _arrowIcon;
}



@end
