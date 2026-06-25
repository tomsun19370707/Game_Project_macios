//
//  RoomSetRoomTypeCell.m
//  miliao
//
//  Created by aa on 2019/7/3.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "RoomSetRoomTypeCell.h"


@interface RoomSetRoomTypeCell ()
@property (nonatomic, strong) YYLabel *roomNameLB;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *iconImageView;

@end
//
@implementation RoomSetRoomTypeCell
//
#pragma mark - 快速创建cell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"RoomSetRoomTypeCell";

    RoomSetRoomTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

    if (cell == nil) {
        cell = [[RoomSetRoomTypeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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


-(void)setTypeName:(NSString *)typeName{
    _typeName=typeName;
    self.contentLabel.text=typeName;
    
}


#pragma mark - setUI
- (void)addSomeViews{
    
    [self.contentView addSubview:self.roomNameLB];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.contentLabel];
    [self.roomNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.top.mas_equalTo(self).offset(20);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(14);
    }];

    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(KAdaptedWidth(-15));
        make.centerY.mas_equalTo(KAdaptedWidth(0));
        make.width.mas_equalTo(KAdaptedWidth(15));
        make.height.mas_equalTo(KAdaptedWidth(15));
        
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.iconImageView.mas_leading).offset(KAdaptedWidth(-5));
        make.top.bottom.mas_equalTo(0);
        make.leading.mas_equalTo(self.roomNameLB.mas_trailing).offset(KAdaptedWidth(5));
        
    }];
}

- (YYLabel *)roomNameLB{
    if (!_roomNameLB) {
        _roomNameLB = [[YYLabel alloc] init];
        _roomNameLB.textAlignment = NSTextAlignmentLeft;
        _roomNameLB.textColor = mainViceColor;
        _roomNameLB.numberOfLines = 0;
        _roomNameLB.backgroundColor = [UIColor clearColor];
        NSMutableAttributedString *text = [NSMutableAttributedString new];
        {
            NSMutableAttributedString *one;
            one = [[NSMutableAttributedString alloc] initWithString:@"房间分类"];
            one.font = Font(14);
            one.color = mainViceColor;
            [text appendAttributedString:one];
        }
//        {
//            NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"*"];
//            one.color = [UIColor redColor];
//            one.font = Font(12);
//            [text appendAttributedString:one];
//        }
        _roomNameLB.attributedText = text;
        
    }
    return _roomNameLB;
}





- (UIImageView*)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image=KGetImage(@"mineRightImg");
    }
    return _iconImageView;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = RGBA(51, 51, 51, 1);
        _contentLabel.font=KFontA(13);
        _contentLabel.text=[Common isNull:[MLRoomInformationModel currentAccount].partition_name];
        _contentLabel.textAlignment=NSTextAlignmentRight;
        _contentLabel.numberOfLines=0;
        [_contentLabel sizeToFit];
    }
    return _contentLabel;
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
