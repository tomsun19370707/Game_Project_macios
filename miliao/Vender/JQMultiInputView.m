//
//  MultiInputView.m
//  test
//
//  Created by 张世浩 on 16/11/15.
//  Copyright © 2016年 张世浩. All rights reserved.
//

#import "JQMultiInputView.h"
#import "Masonry.h"
@interface JQMultiInputView ()<UITextViewDelegate>
@property(nonatomic,strong)UIImageView *icon;
@end
@implementation JQMultiInputView

-(instancetype)init{
    if (self = [super init]) {
        
        _icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bitian"]];
        [self addSubview:_icon];
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(16);
            make.leading.mas_equalTo(0);
            make.width.mas_equalTo(16);
            make.height.mas_equalTo(16);
        }];
        _icon.hidden = YES;
        
        _nameLabel = [[UILabel alloc] init];
        _iTextView = [[UITextView alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _iTextView.font = [UIFont systemFontOfSize:15];
        _iTextView.layer.borderWidth = 1;
        _iTextView.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor;
        
        _iTextView.layer.cornerRadius = 5;
        _iTextView.layer.masksToBounds = YES;
        
        [self addSubview:_nameLabel];
        [self addSubview:_iTextView];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(16);
            make.leading.mas_equalTo(_icon.mas_trailing);
        }];
        [_iTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_nameLabel.mas_trailing).offset(10);
            make.top.mas_equalTo(8);
            make.bottom.mas_equalTo(-8);
            make.trailing.mas_equalTo(-20);
        }];
        _iTextView.delegate = self;
        _placeholderLabel = [[UILabel alloc] init];
        [_iTextView addSubview:_placeholderLabel];
        [_placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(8);
            make.leading.mas_equalTo(5);
        }];
        _placeholderLabel.textColor = [UIColor lightGrayColor];
        _placeholderLabel.font = _iTextView.font;
        
        _lineView = [[UIView alloc] init];
        
        _lineView.backgroundColor = [UIColor lightGrayColor];
        _lineView.alpha = 0.2;
        [self addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_nameLabel.mas_leading).offset(-1);
            make.trailing.mas_equalTo(-8);
            make.bottom.mas_equalTo(-1);
            make.height.mas_equalTo(1);
        }];
        
        [self layoutIfNeeded];
    }
    return self;
}

#pragma mark ---- set get 方法
-(void)setNameStr:(NSString *)nameStr{
    _nameLabel.text =[NSString stringWithFormat:@"%@:",nameStr];
}
-(NSString *)resultStr{
    return _iTextView.text;
}

-(void)setPlaceholder:(NSString *)placeholder{
    _placeholderLabel.text = placeholder;
}
//-(void)setModel:(BillDefineChild *)model{
//    _nameLabel.text = [NSString stringWithFormat:@"%@:",model.label];
//    _nameLabel.textColor = [self hexStringToColor:model.labelColor];
//    _icon.hidden = !model.necessary;
//    _iTextView.text = model.text;
//
//    self.placeholder = model.hint;
//    if (![model.data isEqualToString:@""]) {
//        _iTextView.text = model.data;
//    }
//    if (model.inputType == 1) {
//        _iTextView.keyboardType = UIKeyboardTypeNumberPad;
//    }
//    if (model.inputType2 == 2) {
//        _iTextView.keyboardType = UIKeyboardTypeDecimalPad;
//    }
//    if (![model.ediTable boolValue]) {
//        _iTextView.editable = NO;
//    }
//    _iTextView.textColor = [self hexStringToColor:model.textColor];
//}

//字符串转化为颜色
-(UIColor *) hexStringToColor: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 charactersif ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appearsif ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
//UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    if ([_iTextView.text isEqualToString:@""]) {
        _placeholderLabel.hidden = NO;
    }else{
        _placeholderLabel.hidden = YES;
    }
}
@end
