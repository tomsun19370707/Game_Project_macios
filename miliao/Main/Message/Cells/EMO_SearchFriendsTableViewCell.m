//
//  EMO_SearchFriendsTableViewCell.m
//  miliao
//
//  Created by aa on 2019/7/24.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "EMO_SearchFriendsTableViewCell.h"

//#import "EMO_FriendsModel.h"

@interface EMO_SearchFriendsTableViewCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView           *icon;
@property (nonatomic, strong) UILabel               *nickName;
@property (nonatomic, strong) UIButton               *idLB;
@property (nonatomic, strong) UIImageView           *genderIcon;
//@property (nonatomic, strong) UIButton              *quDingButton;

@property (nonatomic, strong) UIView                *lineView;


@end


@implementation EMO_SearchFriendsTableViewCell
#pragma mark - 快速创建cell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"EMO_SearchFriendsTableViewCell";
    
    EMO_SearchFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[EMO_SearchFriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        //        cell.selectedBackgroundView = cell.seletView ;
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSomeViews];
    }
    return self;
}
- (void)quDingButtonClick:(UIButton *)sender{
    ! self.quDingButtonClickBlock ?: self.quDingButtonClickBlock(self.model,sender);
}


-(void)setModel:(NSDictionary *)model{
    _model = model;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model[@"avatar"]] placeholderImage:[UIImage imageNamed:@"未加载头像"]];
    self.nickName.text = [Common isNull:model[@"nickname"]];
    
    if ([model[@"uuid"] integerValue]>0) {
        [self.idLB setTitle:[NSString stringWithFormat:@"ID:%@",model[@"uuid"]] forState:UIControlStateNormal];
//        [self.idLB setTitleColor:ML_BrightIDColor forState:UIControlStateNormal];
//        self.idLB.ba_padding = 5;
    }else{
        [self.idLB setTitle:[NSString stringWithFormat:@"ID:%@",model[@"id"]] forState:UIControlStateNormal];
//        [self.idLB setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
//        [self.idLB setImage:nil forState:UIControlStateNormal];
//        self.idLB.ba_padding = 0;
    }
    
    [self.idLB setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
    [self.idLB setImage:nil forState:UIControlStateNormal];
    self.idLB.ba_padding = 0;
    
    self.idLB.ba_buttonLayoutType = BAKit_ButtonLayoutTypeLeftImageLeft;
//    if ([model.sex integerValue] == 1) {
//        self.genderIcon.image = [UIImage imageNamed:@"manImg1"];
//    }else{
//        self.genderIcon.image = [UIImage imageNamed:@"womanImg1"];
//    }
//    if ([model.type integerValue] == 1) {
//        self.quDingButton.hidden = YES;
//    }else{
//        if ([model.is_follow integerValue] == 1) {
//            self.quDingButton.hidden = NO;
//            self.quDingButton.selected = YES;
//            self.quDingButton.layer.borderColor = RGBA(0, 0, 0, 1).CGColor;
//        }
//        else
//        {
//            self.quDingButton.hidden = NO;
//            self.quDingButton.selected = NO;
//            self.quDingButton.layer.borderColor = RGBA(55, 171, 255, 1).CGColor;
//        }
//    }
//    self.quDingButton.titleLabel.font = Font(11);
}



- (void)singleTapGesture:(UITapGestureRecognizer *)tap{
    ! self.iconImageClickBlock ?: self.iconImageClickBlock(self.model);
}

- (void)addSomeViews{
    
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.nickName];
    [self.contentView addSubview:self.genderIcon];
    [self.contentView addSubview:self.idLB];
//    [self.contentView addSubview:self.quDingButton];
    [self.contentView addSubview:self.lineView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(5);
        make.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(12);
        make.right.mas_equalTo(self).offset(-12);
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
        make.height.mas_equalTo(50);
        make.left.mas_equalTo(self.bgView.mas_left).offset(10);
        make.width.mas_equalTo(50);
    }];
    [self.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).offset(10);
        make.centerY.mas_equalTo(self.icon.mas_centerY).multipliedBy(0.7);
    }];
    [self.genderIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nickName.mas_right).offset(10);
        make.centerY.mas_equalTo(self.nickName.mas_centerY).multipliedBy(1);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(14);
    }];
    [self.idLB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.genderIcon.mas_right).offset(10-3);
        make.left.mas_equalTo(self.icon.mas_right).offset(10);
        make.centerY.mas_equalTo(self.icon.mas_centerY).multipliedBy(1.2);
        make.width.mas_equalTo(150);
    }];
//    [self.quDingButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self).offset(-15);
//        make.centerY.mas_equalTo(self.bgView.mas_centerY);
//        make.height.mas_equalTo(25);
//        make.width.mas_equalTo(60);
//    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self.bgView).offset(13);
        make.right.mas_equalTo(self).offset(-13);
        make.height.mas_equalTo(1);
    }];
}


- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:[UIColor whiteColor]];
    }
    return _bgView;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [ControlCreator createImageView:self rect:CGRectMake(0, 0, 0, 0) imageName:nil backguoundColor:MLControlsHuiColor];
        _icon.layer.masksToBounds = YES;
        _icon.layer.cornerRadius = 25;
        _icon.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
        [_icon addGestureRecognizer:singleTap];
        
    }
    return _icon;
}
- (UILabel *)nickName{
    if (!_nickName) {
        _nickName = [ControlCreator createLabel:self rect:CGRectZero text:@"" font:Font(14) color:mainViceColor backguoundColor:[UIColor clearColor] align:NSTextAlignmentLeft lines:1];
    }
    return _nickName;
}
- (UIImageView *)genderIcon{
    if (!_genderIcon) {
        _genderIcon = [ControlCreator createImageView:nil rect:CGRectZero imageName:@"Gender_boy" backguoundColor:[UIColor clearColor]];
    }
    return _genderIcon;
}
- (UIButton *)idLB{
    if (!_idLB) {
        _idLB = [UIButton buttonWithType:UIButtonTypeCustom];
        _idLB.titleLabel.font = FONT_12;
        [_idLB setTitleColor:COLOR_666666 forState:UIControlStateNormal];
    }
    return _idLB;
}
//- (UIButton *)quDingButton{
//    if (!_quDingButton) {
//        _quDingButton = [ControlCreator createButton:self rect:CGRectZero text:@"" font:Font1(11) color:RGBA(55, 171, 255, 1) backguoundColor:nil imageName:@"" target:self action:@selector(quDingButtonClick:)];
//        _quDingButton.layer.borderWidth = 0.5;
//        _quDingButton.layer.borderColor = RGBA(55, 171, 255, 1).CGColor;
//        _quDingButton.layer.masksToBounds = YES;
//        _quDingButton.layer.cornerRadius = 12.5;
//        [_quDingButton setTitle:getLanguage(@"已关注") forState:UIControlStateSelected];
//
//        [_quDingButton setTitleColor:RGBA(34, 34, 34, 1) forState:UIControlStateSelected];
//        [_quDingButton setTitle:getLanguage(@"关注") forState:UIControlStateNormal];
//
//        [_quDingButton setTitleColor:RGBA(55, 171, 255, 1) forState:UIControlStateNormal];
//    }
//    return _quDingButton;
//}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:MLControlsHuiColor];
    }
    return _lineView;
}

@end
