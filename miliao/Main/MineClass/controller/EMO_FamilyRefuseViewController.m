//
//  EMO_FamilyRefuseViewController.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/4.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_FamilyRefuseViewController.h"

@interface EMO_FamilyRefuseViewController ()<UITextViewDelegate>
Strong UIView *textBgView;
Strong UITextView *textView;
Strong UIButton *submitButton;


@end

@implementation EMO_FamilyRefuseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(248, 248, 248, 1);
    [self loadBar:YES needBack:YES needBackground:YES];
    self.titleLabel.text=getLanguage(@"拒绝理由");
    self.titleLabel.font=KFont(18);
    
    [self textBgView];
    [self textView];
    [self submitButton];
    
}

- (UIView *)textBgView{
    if (!_textBgView) {
        _textBgView = [[UIView alloc] init];
        _textBgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_textBgView];
        [_textBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ZJTopNavH+ZJStatusBarH+KAdaptedHeight(15));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedHeight(200));
        }];
        setViewCorner(_textBgView, KAdaptedHeight(10));
    }
    return _textBgView;
}

-(UITextView*)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.font = KFontA(14);
        _textView.delegate=self;
        _textView.textColor=RGBA(102, 102, 102, 1);
        _textView.text=getLanguage(@"请输入您的拒绝理由");
        [self.textBgView addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.mas_equalTo(KAdaptedHeight(10));
            make.trailing.bottom.mas_equalTo(KAdaptedHeight(-10));
            
        }];
    }
    return _textView;
}



- (UIButton *)submitButton{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0,0,kWidth-KAdaptedWidth(20),KAdaptedHeight(45));
        gl.startPoint = CGPointMake(0.5, 0);
        gl.endPoint = CGPointMake(0.5, 1);
        gl.colors = @[(__bridge id)BaseMainColor.CGColor,(__bridge id)RGBA(255, 238, 1, 1).CGColor];
        gl.locations = @[@(0.0),@(1.0f)];

        [self.submitButton.layer addSublayer:gl];
        _submitButton.layer.cornerRadius = KAdaptedHeight(45)/2;
        _submitButton.layer.masksToBounds=YES;
        [_submitButton setTitle:getLanguage(@"提交") forState:UIControlStateNormal];
        [_submitButton setTitleColor:RGBA(34, 34, 34, 1) forState:UIControlStateNormal];
        _submitButton.titleLabel.font=KFont(15);
        _submitButton.tag=500;
        [_submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_submitButton];
        [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.textBgView.mas_leading);
            make.trailing.mas_equalTo(self.textBgView.mas_trailing);
            make.bottom.mas_equalTo(-KSAFEAREA_BOTTOM_HEIHGHT-KAdaptedHeight(47));
            make.height.mas_equalTo(KAdaptedHeight(45));
        }];
    }
    return _submitButton;
}



-(void)submitButtonClick{
    [NetworkRequest POST:Request_OperateFamilyUserApply parmeters:@{@"family_id":self.dicData[@"familyID"],@"status":@"2",@"id":self.dicData[@"id"],@"type":self.dicData[@"index"]} success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:baseModel.msg]];
        [self.navigationController popViewControllerAnimated:YES];

    } failture:^(NSError *error) {

    }];
    
}











// 将要开始编辑
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if([textView.text isEqualToString:@"请输入您的拒绝理由"]){
        textView.text=@"";
    }
    textView.textColor=kBlackColor;
    return YES;
}
// 将要结束编辑
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{

    if (textView.text.length<1) {
        textView.text=getLanguage(@"请输入您的拒绝理由");
//        self.numLabel.text=@"0/200";
    }
    
    _textView.textColor=RGBA(102, 102, 102, 1);
    return YES;
}

// 开始编辑
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
}
// 结束编辑
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length>0&&(![textView.text isEqualToString:getLanguage(@"请输入您的拒绝理由")])) {
        _textView.textColor=kBlackColor;
    }else{
        _textView.textColor=RGBA(102, 102, 102, 1);
    }
 
}

// 文本将要改变
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}
// 文本发生改变
- (void)textViewDidChange:(UITextView *)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    NSUInteger count = textView.text.length;
//    self.numLabel.text = [NSString stringWithFormat:@"%ld/200", (unsigned long)count];
}
// 焦点发生改变
- (void)textViewDidChangeSelection:(UITextView *)textView{
    
}








@end
