//
//  SingleInputView.m

//
//  Created by 张世浩 on 2017/12/2.
//  Copyright © 2017年 张世浩. All rights reserved.
//

#import "SingleInputView.h"

#define PLACEHOLDER _placeholderStr?_placeholderStr:@"请输入"

@interface SingleInputView()

@end
@implementation SingleInputView

-(instancetype)initWithType:(NSInteger)type{
    if (self = [super init]) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = KFont(12);
        _nameLabel.textColor=[UIColor blackColor];
        [self addSubview:_nameLabel];
        
        _icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bitian"]];
        [self addSubview:_icon];
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.leading.mas_equalTo(0);
            make.width.mas_equalTo(KAdaptedWidth(15));
            make.height.mas_equalTo(KAdaptedWidth(15));
        }];
        _icon.hidden = YES;
        
        _iTextField = [[UITextField alloc] init];
        _iTextField.placeholder = PLACEHOLDER;
//        [_iTextField setValue:[UIColor lightGrayColor]forKeyPath:@"_placeholderLabel.textColor"];
        _iTextField.borderStyle = UITextBorderStyleNone;
        _iTextField.font = KFont(10);
        _iTextField.textAlignment=NSTextAlignmentRight;
        if (type == 1) {
            _iTextField.keyboardType = UIKeyboardTypeNumberPad;
        }
        if (type == 2) {
            _iTextField.keyboardType = UIKeyboardTypeDecimalPad;
        }
        if (type == 3) {
            _iTextField.keyboardType = UIKeyboardTypePhonePad;
        }
        if (type == 5) {
            _iTextField.keyboardType = UIKeyboardTypeEmailAddress;
        }
        [self addSubview:_iTextField];
        
        _lineView = [[UIView alloc] init];
        _lineView.alpha = 0.2;
        _lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_lineView];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_icon.mas_trailing);
            make.centerY.mas_equalTo(0);
        }];
        
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_nameLabel.mas_leading).offset(-1);
            make.trailing.mas_equalTo(-8);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        _imageView1=[[UIImageView alloc]init];
//        _imageView1.image=[[UIImage imageNamed:@"arrowRightImg"] hal_imageFlippedForRightToLeftLayoutDirection];
        _imageView1.image=[UIImage imageNamed:@"arrowRightImg"];
        [self addSubview:_imageView1];
        [_imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.trailing.mas_equalTo(KAdaptedWidth(-10));
            make.width.mas_equalTo(KAdaptedWidth(4));
            make.height.mas_equalTo(KAdaptedWidth(4));
            
        }];
        
        
        
    }
    return self;
}
-(void)layoutSubviews{
    [_iTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_nameLabel.mas_trailing).offset(5);
        make.centerY.mas_equalTo(0);
        make.bottom.mas_equalTo(-8);
        make.trailing.mas_equalTo(-23);
    }];
}



-(void)setDic:(NSDictionary *)dic{
    _dic=dic;
    if ([dic[@"iconShow"]intValue]==1) {
        _icon.hidden=NO;
        [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_icon.mas_leading).offset(0);
            make.trailing.mas_equalTo(-8);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        [_lineView layoutIfNeeded];
    }
    if ([dic[@"imageBig"] intValue]==1) {
        [_imageView1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.trailing.mas_equalTo(KAdaptedWidth(-10));
            make.width.mas_equalTo(KAdaptedWidth(15));
            make.height.mas_equalTo(KAdaptedWidth(15));
            
        }];
        [_imageView1 layoutIfNeeded];
    }
    
}

#pragma mark ---- set get 方法
-(NSString *)reusltStr{
    return _iTextField.text;
}
//设置属性
-(void)setNameStr:(NSString *)nameStr{
      _nameLabel.text = [NSString stringWithFormat:@"%@",nameStr];
    
}
-(void)setNameFont:(NSInteger)nameFont{
    _nameLabel.font=KFont(nameFont);
}


//-(void)setModel:(BillDefineChild *)model{
//    _nameLabel.text = [NSString stringWithFormat:@"%@:",model.label];
//    _nameLabel.textColor = [self hexStringToColor:model.labelColor];
//
//    _icon.hidden = !model.necessary;
//
//    _iTextField.placeholder = model.hint;
//    if (![model.text isEqualToString:@""]) {
//        _iTextField.text = model.text;
//
//    }
//    if (![model.data isEqualToString:@""]) {
//        _iTextField.text = model.data;
//    }
//    _iTextField.textColor = [self hexStringToColor:model.textColor];
//
//    if (![model.ediTable boolValue]) {
//        _iTextField.enabled = NO;
//    }else{
//        _iTextField.enabled = YES;
//    }
//}

//字符串转化为颜色
-(UIColor *) hexStringToColor: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
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

@end
