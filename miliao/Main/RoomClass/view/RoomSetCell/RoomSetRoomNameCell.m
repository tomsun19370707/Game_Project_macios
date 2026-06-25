//
//  RoomSetRoomNameCell.m
//  miliao
//
//  Created by aa on 2019/7/3.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "RoomSetRoomNameCell.h"
#import "Global.h"

@interface RoomSetRoomNameCell ()<UITextFieldDelegate>

@property (nonatomic, strong) YYLabel *roomNameLB;

@property (nonatomic, strong) UITextField *roomNameTF;
@property (nonatomic, strong) UILabel *numLB;
@property (nonatomic, strong) UIView *bgView;


@end

@implementation RoomSetRoomNameCell

#pragma mark - 快速创建cell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"RoomSetRoomNameCell";
    
    RoomSetRoomNameCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[RoomSetRoomNameCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
- (void)setTextTF:(NSString *)textTF{
    _textTF = textTF;
    self.roomNameTF.text = textTF;
    self.numLB.text = NSStringFormat(@"%ld/12",textTF.length);
}


- (void)addSomeViews{
    [self.contentView addSubview:self.roomNameLB];
    [self.contentView addSubview:self.roomNameTF];
    [self.contentView addSubview:self.numLB];
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
    [self.numLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.roomNameTF.right).offset(-30);
        make.centerY.mas_equalTo(self);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(11);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(self).offset(-11);
        make.bottom.mas_equalTo(self);
    }];
    self.numLB.hidden=YES;
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
        if ([toBeString length] > 12) { //如果输入框内容大于12则弹出警告
            textField.text = [toBeString substringToIndex:12];
            self.numLB.text = NSStringFormat(@"%ld/12",textField.text.length);
            
            return NO;
        }
            self.numLB.text = NSStringFormat(@"%ld/12",textField.text.length);
    }
    ! self.nickNameClickBlock ?: self.nickNameClickBlock(toBeString);
    
    return YES;
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
            one = [[NSMutableAttributedString alloc] initWithString:@"房间名称"];
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
- (UITextField *)roomNameTF{
    if (!_roomNameTF) {
        _roomNameTF = [ControlCreator createTextField:nil rect:CGRectMake(0, 0, 0, 0) placeholder:@"请输入房间名称" placeholderColor:nil text:@"" font:KFontA(13) color:mainViceColor backguoundColor:kClearColor];
        _roomNameTF.textAlignment=NSTextAlignmentRight;
        _roomNameTF.delegate = self;
        _roomNameTF.layer.masksToBounds = YES;
        _roomNameTF.layer.cornerRadius = 17.5;
        UIView *leftTFView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 35)];
        leftTFView.backgroundColor = [UIColor clearColor];
        _roomNameTF.leftView = leftTFView;
        _roomNameTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _roomNameTF;
}
- (UILabel *)numLB{
    if (!_numLB) {
        _numLB = [ControlCreator createLabel:nil rect:CGRectMake(0, 0, 0, 0) text:@"0/12" font:Font(11) color:MHColorFromHexString(@"#DDDDDD") backguoundColor:[UIColor clearColor] align:NSTextAlignmentRight lines:1];
    }
    return _numLB;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [ControlCreator createView:nil rect:CGRectMake(0, 0, 0, 0) backguoundColor:MLControlsHuiColor];
    }
    return _bgView;
}


@end
