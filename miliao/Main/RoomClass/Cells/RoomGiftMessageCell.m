//
//  RoomGiftMessageCell.m
//  miliao
//
//  Created by aa on 2019/7/22.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "RoomGiftMessageCell.h"

#import "MLRoomMessageModel.h"

@interface RoomGiftMessageCell ()

@property (nonatomic, strong)  YYLabel                  *messageLB;
@property (nonatomic, strong) UIImageView               *giftIcon;
@property (nonatomic, strong) UILabel                   *giftNum;

@property (nonatomic, strong) UIView                    *bgViewW;



@end



@implementation RoomGiftMessageCell

#pragma mark - 快速创建cell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"RoomGiftMessageCell";
    
    RoomGiftMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[RoomGiftMessageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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



- (void)addSomeViews {
    [self.contentView addSubview:self.bgViewW];
    [self.contentView addSubview:self.messageLB];
//    self.giftIcon.backgroundColor = kGreenColor;
    
    [self.contentView addSubview:self.giftIcon];
    [self.contentView addSubview:self.giftNum];
    [self.messageLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(2);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.width.mas_equalTo(200);
        make.bottom.mas_equalTo(-2);
    }];
    [self.giftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.messageLB.mas_right).offset(2);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
    }];
    [self.giftNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.giftIcon.mas_right).offset(2);
//        make.right.mas_equalTo(self.mas_right).offset(5);
    }];
    
    [self.bgViewW mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.right.mas_equalTo(self.giftNum.mas_right).offset(10);
    }];
}
- (void)setModel:(MLRoomMessageModel *)model{
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    {
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:NSStringFormat(@"  %@",model.nickName)];
        [one setTextHighlightRange:one.rangeOfAll
                                color:MHColorFromHexString(model.nick_color)
                      backgroundColor:nil
                            tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                ! self.nickNameClickBlock ?: self.nickNameClickBlock(containerView, @"1", range, rect, model);
                            }];
        [text appendAttributedString:one];
        
    }
    {
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:NSStringFormat(@" 送给 %@",model.toNickName)];
        [one setTextHighlightRange:one.rangeOfAll
                                color:[UIColor whiteColor]
                      backgroundColor:nil
                            tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                ! self.nickNameClickBlock ?: self.nickNameClickBlock(containerView, @"2", range, rect, model);
                            }];
        [text appendAttributedString:one];
    }
    {
//        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:model.message];
//        one.color = [UIColor whiteColor];
//        [text appendAttributedString:one];
    }
    
    
//    if (![Common isEmptyString:model.peerage_image]) {
//////        新增发送聊天消息时名称前边加等级图标
//            if ([model.peerage_image hasPrefix:@"http"]) {
//                YYAnimatedImageView *imageView=[[YYAnimatedImageView alloc] init];
////                imageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.vip_img]]]];
//                imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"GXImg-%@",model.vip_num]];
//                imageView.frame=CGRectMake(0,0,34,15);
//                NSMutableAttributedString *string=[NSMutableAttributedString attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:Font(13) alignment:YYTextVerticalAlignmentCenter];
//                [text insertAttributedString:string atIndex:0];
//            }
//
//    }
    
    
    
    [self.giftIcon sd_setImageWithURL:[NSURL URLWithString:model.show_img]];
    self.giftNum.text = NSStringFormat(@"x%@",model.giftNum);
    self.messageLB.attributedText = text;
    [self.messageLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(model.messageWidth+10);
    }];
    
}
- (YYLabel *)messageLB{
    if (!_messageLB) {
        _messageLB = [[YYLabel alloc] init];
        _messageLB.textAlignment = NSTextAlignmentLeft;
        _messageLB.textColor = [UIColor whiteColor];
        _messageLB.numberOfLines = 0;
        _messageLB.backgroundColor = [UIColor clearColor];
        _messageLB.font = Font(13);
    }
    return _messageLB;
}

- (UIView *)bgViewW{
    if (!_bgViewW) {
        _bgViewW = [[UIView alloc] init];
        _bgViewW.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        _bgViewW.alpha = 0.5;
        _bgViewW.layer.masksToBounds = YES;
        _bgViewW.layer.cornerRadius = 5;
    }
    return _bgViewW;
}

- (UILabel *)giftNum{
    if (!_giftNum) {
        _giftNum = [ControlCreator createLabel:nil rect:CGRectZero text:@"" font:Font(15) color:MHColorFromHexString(@"#FFD452") backguoundColor:[UIColor clearColor] align:NSTextAlignmentCenter lines:1];
    }
    return _giftNum;
}

- (UIImageView *)giftIcon{
    if (!_giftIcon) {
        _giftIcon = [ControlCreator createImageView:nil rect:CGRectZero imageName:@"" backguoundColor:[UIColor clearColor]];
    }
    return _giftIcon;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
