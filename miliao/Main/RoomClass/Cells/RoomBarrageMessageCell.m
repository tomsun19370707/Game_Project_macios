//
//  RoomBarrageMessageCell.m
//  miliao
//
//  Created by aa on 2019/6/20.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "RoomBarrageMessageCell.h"

#import "MLRoomMessageModel.h"
#import "Global.h"

@interface RoomBarrageMessageCell ()
@property (nonatomic, strong)  YYLabel              *messageLB;

@property (nonatomic, strong) UIView                *bgViewW;

@property (nonatomic, strong) UIImageView           *vipImage;
//@property (nonatomic, strong) UIImageView           *vipBadgeImage;
@property (nonatomic, strong) UIButton           *vipBadgeImage;
@property (nonatomic, strong) UIButton           *charmImage;

@property (nonatomic, strong) UIImageView           *leftTopMessageBox;
@property (nonatomic, strong) UIImageView           *messageBox;
@property (nonatomic, strong) UIImageView           *rightBottomMessageBox;
@property (nonatomic, strong) UIImageView           *bgImageV;

@end



@implementation RoomBarrageMessageCell


#pragma mark - 快速创建cell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"RoomBarrageMessageCell";
    RoomBarrageMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[RoomBarrageMessageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
    [self.contentView addSubview:self.bgImageV];
    
    [self.contentView addSubview:self.messageBox];
    [self.contentView addSubview:self.leftTopMessageBox];
    [self.contentView addSubview:self.rightBottomMessageBox];
    
    [self.contentView addSubview:self.messageLB];
    
    [self.contentView addSubview:self.vipImage];
    [self.contentView addSubview:self.vipBadgeImage];
    [self.contentView addSubview:self.charmImage];
    
    [self.messageLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(5);
        make.left.mas_equalTo(self.mas_left).offset(20);
        make.width.mas_equalTo(200-50);
        make.bottom.mas_equalTo(-0);
    }];
    [self.bgViewW mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.messageLB.mas_top).offset(3);
        make.bottom.mas_equalTo(self.messageLB.mas_bottom).offset(0);
        make.left.mas_equalTo(self.messageLB.mas_left).offset(-7);
        make.right.mas_equalTo(self.messageLB.mas_right).offset(4);
    }];
    
    [self.bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.mas_equalTo(self.messageLB.mas_top).offset(3);
           make.bottom.mas_equalTo(self.messageLB.mas_bottom).offset(0);
           make.left.mas_equalTo(self.messageLB.mas_left).offset(-7);
           make.right.mas_equalTo(self.messageLB.mas_right).offset(4);
       }];
    
    [self.messageBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgViewW.mas_top).offset(-5);
        make.bottom.mas_equalTo(self.bgViewW.mas_bottom);
        make.left.mas_equalTo(self.bgViewW.mas_left).offset(-3);
        make.right.mas_equalTo(self.messageLB.mas_right).offset(6);
    }];
    [self.leftTopMessageBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.messageBox.mas_top).offset(4);
        make.left.mas_equalTo(self.messageBox.mas_left);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(20);
    }];
    [self.rightBottomMessageBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.messageBox.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.messageBox.mas_right).offset(-5);
        make.height.mas_equalTo(31);
        make.width.mas_equalTo(43);
    }];
    
    [self.vipImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgViewW.mas_top).offset(5);
        make.left.mas_equalTo(self.mas_left).offset(20);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(0);
    }];
    [self.vipBadgeImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.vipImage);
        make.top.mas_equalTo(self.bgViewW.mas_top).offset(8);
        make.left.mas_equalTo(self.vipImage.mas_right).offset(5);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(0);
    }];
    [self.charmImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.vipBadgeImage.mas_centerY);
        make.left.mas_equalTo(self.vipBadgeImage.mas_right).offset(5);
        make.height.mas_equalTo(self.vipBadgeImage.mas_height);
        make.width.mas_equalTo(0);
    }];
    
    
   
}
- (void)setSystemInforms:(MLRoomMessageModel *)model{
    self.vipImage.hidden=YES;
    self.vipBadgeImage.hidden=YES;
    self.charmImage.hidden=YES;
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    {
        NSMutableAttributedString *one;
        one = [[NSMutableAttributedString alloc] initWithString:NSStringFormat(@"%@:",model.nickName)];
        if ([model.user_id integerValue] == 0) {
            one.color = MHColorFromHexString(@"#FF3E6D");
        }else{
            one.color = MHColorFromHexString(@"#FF3E6D");
        }
        
        [text appendAttributedString:one];
    }
    {
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:model.message];
        if ([model.user_id integerValue] == 0) {
            one.color = MHColorFromHexString(@"FF3E6D");
        }else{
            one.color = MHColorFromHexString(@"FF3E6D");
        }
        [text appendAttributedString:one];
    }
    [self.messageLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(model.cellWeight);
    }];
    self.messageLB.attributedText = text;
    if ([model.user_id integerValue] == 0) {
        self.messageLB.textColor = MHColorFromHexString(@"#61DFBD");
    }else{
        self.messageLB.textColor = MHColorFromHexString(@"FF3E6D");
    }
    self.bgViewW.hidden = NO;
}
- (void)setModel:(MLRoomMessageModel *)model{
    _model = model;
    
    NSInteger NumImg=0;
    
    if ([[Common isNull:model.peerage_image] isEqualToString:@""]) {
        self.vipImage.image = nil;
        [self.vipImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }else{
        NumImg=NumImg+20;
        [self.vipImage sd_setImageWithURL:[NSURL URLWithString:model.peerage_image]];
        [self.vipImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(20);
        }];
    }
    
    if ([model.contribute_level integerValue]<1) {
//        self.vipBadgeImage.image = nil;
        self.vipBadgeImage.hidden=YES;
        [self.vipBadgeImage setTitle:@"" forState:UIControlStateNormal];
        [self.vipBadgeImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }else{
        NumImg=NumImg+35;
        self.vipBadgeImage.hidden=NO;
//        self.vipBadgeImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"GXImg-%@",model.contribute_level]];
//        [self.vipBadgeImage sd_setImageWithURL:[NSURL URLWithString:model.contribute_level]];
        [self.vipBadgeImage setTitle:model.contribute_level forState:UIControlStateNormal];
        [self.vipBadgeImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(35);
        }];
        [self.vipBadgeImage setImagePositionWithType:SSImagePositionTypeLeft spacing:3];
    }
    
    if ([model.charm_level integerValue]<1) {
//        self.charmImage.image = nil;
        self.charmImage.hidden=YES;
        [self.charmImage setTitle:@"" forState:UIControlStateNormal];
        [self.charmImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }else{
        NumImg=NumImg+35;
        self.charmImage.hidden=NO;
        [self.charmImage setTitle:model.charm_level forState:UIControlStateNormal];
        [self.charmImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(35);
        }];
        [self.charmImage setImagePositionWithType:SSImagePositionTypeLeft spacing:3];
    }
    
    CGFloat laW;
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    {
        NSMutableAttributedString *one;
        if ([model.messageType isEqualToString:@"2"]) {
            laW = model.cellWeight;
            one = [[NSMutableAttributedString alloc] initWithString:NSStringFormat(@"  %@",model.nickName)];
            self.bgViewW.hidden = NO;
//            self.bgImageV.image = [self resizableImage:ImageNamed(@"erterroom")];

        }else{
            if ([model.ltk_left isEqualToString:@""]) {
                laW = model.cellWeight;
                self.messageBox.image = nil;
                self.leftTopMessageBox.image = nil;
                self.rightBottomMessageBox.image = nil;
            }else{
                [self.messageBox sd_setImageWithURL:[NSURL URLWithString:model.ltk]];
                [self.leftTopMessageBox sd_setImageWithURL:[NSURL URLWithString:model.ltk_left]];
                [self.rightBottomMessageBox sd_setImageWithURL:[NSURL URLWithString:model.ltk_right]];
                laW = model.cellWeight + 10 ;
            }
            one = [[NSMutableAttributedString alloc] initWithString:NSStringFormat(@"  %@:",model.nickName)];
//            self.bgImageV.image = ImageNamed(@"liaotian");
//            self.bgImageV.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.25];
        }
        
        [one setTextHighlightRange:one.rangeOfAll
                                color:MHColorFromHexString(@"#51C8FF")
                      backgroundColor:nil
                            tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                ! self.nickNameClickBlock ?: self.nickNameClickBlock(containerView, text, range, rect, model);
                            }];
        [text appendAttributedString:one];
    }
    {
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:[Common isNull:model.message]];
        one.color = [UIColor whiteColor];
        [text appendAttributedString:one];
    }
   
////    新增发送聊天消息时名称前边加等级图标
        if (NumImg>0) {
                YYAnimatedImageView *imageView=[[YYAnimatedImageView alloc] init];
    //            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.peerage_image]]];
            
                imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"GXImg-A%@",model.vip_num]];
                imageView.frame=CGRectMake(0,0,NumImg+5,15);
                NSMutableAttributedString *string=[NSMutableAttributedString attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:Font(13) alignment:YYTextVerticalAlignmentCenter];
                [text insertAttributedString:string atIndex:0];
        }
    
    
    
    
    
//    if (![Common isEmptyString:model.peerage_image]) {
//        if ([model.peerage_image hasPrefix:@"http"]) {
//            YYAnimatedImageView *imageView=[[YYAnimatedImageView alloc] init];
////            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.peerage_image]]];
//    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://img0.baidu.com/it/u=3834908638,635499117&fm=253&fmt=auto&app=120&f=JPEG?w=1422&h=800"]]];
////            imageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.peerage_image]]]];
////            imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"GXImg-%@",model.vip_num]];
//            imageView.frame=CGRectMake(0,0,34,15);
//            NSMutableAttributedString *string=[NSMutableAttributedString attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:Font(13) alignment:YYTextVerticalAlignmentCenter];
//            [text insertAttributedString:string atIndex:0];
//        }
//    }
//    if (![Common isEmptyString:model.contribute_level]) {
//        YYAnimatedImageView *imageView1=[[YYAnimatedImageView alloc] init];
////        imageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.peerage_image]]]];
//            imageView1.image=[UIImage imageNamed:[NSString stringWithFormat:@"GXImg-%@",model.contribute_level]];
////    imageView1.image=[UIImage imageNamed:[NSString stringWithFormat:@"GXImg-2"]];
//        imageView1.frame=CGRectMake(34,0,34,15);
//        NSMutableAttributedString *string1=[NSMutableAttributedString attachmentStringWithContent:imageView1 contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView1.frame.size alignToFont:Font(13) alignment:YYTextVerticalAlignmentCenter];
//        [text insertAttributedString:string1 atIndex:1];
//
//    }
        
    [self.messageLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(laW+20);
    }];
    self.messageLB.attributedText = text;
    self.messageLB.font = Font(13);
}
- (YYLabel *)messageLB{
    if (!_messageLB) {
        _messageLB = [[YYLabel alloc] init];
        _messageLB.textAlignment = NSTextAlignmentLeft;
        _messageLB.textColor = [UIColor whiteColor];
        _messageLB.numberOfLines = 0;
        _messageLB.backgroundColor = [UIColor clearColor];
        _messageLB.font = Font(20);
    }
    return _messageLB;
}
- (UIView *)bgViewW{
    if (!_bgViewW) {
        _bgViewW = [[UIView alloc] init];
        _bgViewW.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        _bgViewW.layer.masksToBounds = YES;
        _bgViewW.layer.cornerRadius = 5;
        _bgViewW.alpha = 0.7;
    }
    return _bgViewW;
}

- (UIImageView *)bgImageV{
    if (!_bgImageV) {
        _bgImageV = [ControlCreator createImageView:nil rect:CGRectZero imageName:@"" backguoundColor:[UIColor clearColor]];
        _bgImageV.contentMode = UIViewContentModeScaleToFill;
    }
    return _bgImageV;
}
- (UIImageView *)vipImage{
    if (!_vipImage) {
        _vipImage = [ControlCreator createImageView:nil rect:CGRectZero imageName:@"" backguoundColor:[UIColor clearColor]];
//        _vipImage.hidden = YES;
        _vipImage.contentMode = UIViewContentModeRedraw;
    }
    return _vipImage;
}
//- (UIImageView *)vipBadgeImage{
//    if (!_vipBadgeImage) {
//        _vipBadgeImage = [ControlCreator createImageView:nil rect:CGRectZero imageName:@"" backguoundColor:[UIColor clearColor]];
////        _vipBadgeImage.hidden = YES;
//        _vipBadgeImage.contentMode = UIViewContentModeRedraw;
//    }
//    return _vipBadgeImage;
//}
- (UIButton *)vipBadgeImage{
    if (!_vipBadgeImage) {
        _vipBadgeImage = [UIButton buttonWithType:UIButtonTypeCustom];
        _vipBadgeImage.layer.contents=(id)KGetImage(@"vipBgOneImg").CGImage;
        [_vipBadgeImage setImage:[UIImage imageNamed:@"vipIconImg"] forState:UIControlStateNormal];
        [_vipBadgeImage setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _vipBadgeImage.titleLabel.font=KFontA(12);
    }
    return _vipBadgeImage;
}

- (UIButton *)charmImage{
    if (!_charmImage) {
        _charmImage = [UIButton buttonWithType:UIButtonTypeCustom];
        _charmImage.layer.contents=(id)KGetImage(@"vipBgTwoImg").CGImage;
        [_charmImage setImage:[UIImage imageNamed:@"vipIconImg"] forState:UIControlStateNormal];
        [_charmImage setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _charmImage.titleLabel.font=KFontA(12);
    }
    return _charmImage;
}




- (UIImageView *)leftTopMessageBox{
    if (!_leftTopMessageBox) {
        _leftTopMessageBox = [ControlCreator createImageView:nil rect:CGRectZero imageName:@"" backguoundColor:[UIColor clearColor]];
        _leftTopMessageBox.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _leftTopMessageBox;
}
- (UIImageView *)messageBox{
    if (!_messageBox) {
        _messageBox = [ControlCreator createImageView:nil rect:CGRectZero imageName:@"" backguoundColor:[UIColor clearColor]];
        _messageBox.contentMode = UIViewContentModeScaleToFill;
    }
    return _messageBox;
}
- (UIImageView *)rightBottomMessageBox{
    if (!_rightBottomMessageBox) {
        _rightBottomMessageBox = [ControlCreator createImageView:nil rect:CGRectZero imageName:@"" backguoundColor:[UIColor clearColor]];
        _rightBottomMessageBox.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _rightBottomMessageBox;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIImage*)resizableImage:(UIImage *)image

{
    //图片拉伸区域
    CGFloat top = 0;
    CGFloat left = 10;
    CGFloat right = 10;
    CGFloat bottom = 0;
    //重点 进行图片拉伸
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right) resizingMode:UIImageResizingModeStretch];
}

@end
