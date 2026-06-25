//
//  RoomSetRoomPWCell.m
//  miliao
//
//  Created by aa on 2019/7/3.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "RoomSetRoomPWCell.h"

#import "Global.h"

@interface RoomSetRoomPWCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *roomNameLB;

@property (nonatomic, strong) UITextField *roomNameTF;
@property (nonatomic, strong) UIView *bgView;



@end


@implementation RoomSetRoomPWCell

#pragma mark - 快速创建cell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"RoomSetRoomPWCell";
    
    RoomSetRoomPWCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[RoomSetRoomPWCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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

- (void)setPasswordTX:(NSString *)passwordTX{
    _passwordTX = passwordTX;
    self.roomNameTF.text = passwordTX;
}

- (void)addSomeViews{
    [self.contentView addSubview:self.roomNameLB];
    [self.contentView addSubview:self.roomNameTF];
    [self.contentView addSubview:self.bgView];
    [self.roomNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(14);
    }];
    [self.roomNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.roomNameLB.mas_right).offset(0);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-15);
        make.height.mas_equalTo(35);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(11);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(self).offset(-11);
        make.bottom.mas_equalTo(self);
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{  //string就是此时输入的那个字符 textField就是此时正在输入的那个输入框 返回YES就是可以改变输入框的值 NO相反
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if (self.roomNameTF == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 4) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:4];
            return NO;
        }
    }
    ! self.passwordTXClickBlock ?: self.passwordTXClickBlock(toBeString);
    return YES;
}

- (UILabel *)roomNameLB{
    if (!_roomNameLB) {
        _roomNameLB = [ControlCreator createLabel:nil rect:CGRectMake(0, 0, 0, 0) text:@"房间密码" font:Font(14) color:mainViceColor backguoundColor:[UIColor clearColor] align:NSTextAlignmentLeft lines:1];
    }
    return _roomNameLB;
}
- (UITextField *)roomNameTF{
    if (!_roomNameTF) {
        _roomNameTF = [ControlCreator createTextField:nil rect:CGRectMake(0, 0, 0, 0) placeholder:@"非必填，填写后房间会被上锁,密码为4位数字" placeholderColor:nil text:@"" font:Font(12) color:mainViceColor backguoundColor:kClearColor];
        _roomNameTF.textAlignment=NSTextAlignmentRight;
        _roomNameTF.delegate = self;
        _roomNameTF.layer.masksToBounds = YES;
        _roomNameTF.layer.cornerRadius = 17.5;
        _roomNameTF.keyboardType = UIKeyboardTypeNumberPad;
        UIView *leftTFView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 35)];
        leftTFView.backgroundColor = [UIColor clearColor];
        _roomNameTF.leftView = leftTFView;
        _roomNameTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _roomNameTF;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [ControlCreator createView:nil rect:CGRectMake(0, 0, 0, 0) backguoundColor:MLControlsHuiColor];
    }
    return _bgView;
}

@end
