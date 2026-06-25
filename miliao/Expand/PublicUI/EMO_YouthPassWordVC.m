//
//  EMO_YouthPassWordVC.m
//  miliao
//
//  Created by jkkj on 2023/11/1.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_YouthPassWordVC.h"
#import "EMO_CJTextFild.h"
@interface EMO_YouthPassWordVC ()<UITextFieldDelegate,CJTextFieldDeleteDelegate>
Strong NSMutableArray *textArray;
@end

@implementation EMO_YouthPassWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBar:YES needBack:YES needBackground:YES];
    self.view.backgroundColor=[UIColor colorWithHexString:@"#FFFFF8"];
    self.titleLabel.text=self.isON?@"输入密码":@"设置密码";
    self.titleLabel.font=KFont(18);
    self.textArray = [[NSMutableArray alloc] init];
    [self createUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)createUI{
    UIView *textConentView = [[UIView alloc] init];
    textConentView.frame = CGRectMake(0, [UIDevice vg_navigationFullHeight]+80, kScreenWidth, 30);
    textConentView.backgroundColor = UIColor.clearColor;
    [self.view addSubview:textConentView];
    
    UITextField *curText = [[UITextField alloc] init];
    CGFloat spacing = (kScreenWidth - 48*2 - 22*4)/3;
    for (int i=0; i<4; i++) {
        EMO_CJTextFild *textFile = [[EMO_CJTextFild alloc] init];
        textFile.cj_delegate = self;
        textFile.secureTextEntry = YES;
        textFile.textAlignment = NSTextAlignmentCenter;
        textFile.tag = i;
        textFile.frame = CGRectMake(48+(22+spacing)*i, 5, 22, 22);
//        [textFile addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        textFile.delegate = self;
        [textConentView addSubview:textFile];
        setViewCorner(textFile, 22/2);
        setViewBorderAndColor(textFile, 1, [UIColor colorWithHexString:@"#E3E3E3"].CGColor);
        [self.textArray addObject:textFile];
        curText = textFile;
    }
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.textColor = [UIColor colorWithHexString:@"333333"];
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.font = BOLDSYSTEMFONT(18);
    topLabel.numberOfLines = 0;
    topLabel.text = self.isON?@"输入密码":@"设置密码";
    [self.view addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(17);
        make.right.mas_offset(-17);
        make.top.mas_offset(textConentView.bottom+55);
    }];
    
    UILabel *centerLabel = [[UILabel alloc] init];
    centerLabel.textColor = [UIColor colorWithHexString:@"333333"];
    centerLabel.backgroundColor = [UIColor clearColor];
    centerLabel.textAlignment = NSTextAlignmentCenter;
    centerLabel.font = KFont(14);
    centerLabel.numberOfLines = 0;
    centerLabel.text =  self.isON?@"关闭青少年模式,需要输入独立密码":@"开启青少年模式,需要设置独立密码";
    [self.view addSubview:centerLabel];
    [centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(17);
        make.right.mas_offset(-17);
        make.top.equalTo(topLabel.mas_bottom).offset(20);
    }];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setTitle:@"确认" forState:0];
    [doneBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:0];
    doneBtn.titleLabel.font = BOLDSYSTEMFONT(15);
    [doneBtn addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
    [doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.right.mas_offset(-15);
        make.height.mas_offset(50);
        make.bottom.mas_offset(-([UIDevice vg_safeDistanceBottom]+15));
    }];
    [doneBtn layoutIfNeeded];
    [doneBtn gradientButtonWithSize:CGSizeMake(doneBtn.width, doneBtn.height) colorArray:@[[UIColor colorWithHexString:@"#F7D45B"],[UIColor colorWithHexString:@"#FFEE01"]] percentageArray:@[@0,@1.0] gradientType:GradientFromLeftToRight];
    setViewCorner(doneBtn, doneBtn.height/2);
}
#pragma mark -- 设定可输入12位数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([Common isEmptyString:string]){
        UITextField * cutText  = self.textArray[textField.tag];
        cutText.text = @"";
        UITextField *nextText = nil;
        if(textField.tag !=0){
            nextText  = self.textArray[textField.tag-1];
        }
        [nextText becomeFirstResponder];
        return NO;
    }else{
        UITextField *fristText = self.textArray[textField.tag];
        fristText.text = string;
        if(textField.tag<self.textArray.count){
            UITextField *nextText = nil;
            if(textField.tag < 3){
                nextText  = self.textArray[textField.tag+1];
            }
            [nextText becomeFirstResponder];
        }
        NSInteger maxNumber = 1;//字数 放空为全局属性
        NSString * IndexString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (IndexString.length > maxNumber && range.length!=1){
            textField.text = [IndexString substringToIndex: maxNumber];
            return NO;
        }
    }
    return YES;
}

- (void)cjTextFieldDeleteBackward:(EMO_CJTextFild *)textField{
    UITextField * cutText  = self.textArray[textField.tag];
    cutText.text = @"";
    UITextField *nextText = nil;
    if(textField.tag !=0){
        nextText  = self.textArray[textField.tag-1];
    }
    [nextText becomeFirstResponder];
}

-(void)doneClick{
    NSMutableString *string = [NSMutableString string];
    for (UITextField *tf in self.textArray) {
       [string appendString:tf.text];
    }
    if(string.length !=4){
        return [SVProgressHUD showInfoWithStatus:getLanguage(@"请填写完整密码")];
    }else{
        if([Common isEmptyString:UserDefaultsGet(@"APPPassWord")]){
            //未开启
            UserDefaultsSave(string, @"APPPassWord");
        }else{
            //关闭了青少年模式
            UserDefaultsSave(@"", @"APPPassWord");
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}



@end
