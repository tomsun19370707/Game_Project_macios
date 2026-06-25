//
//  EMO_EditUserMsgVC.m
//  miliao
//
//  Created by ZhangShiHao on 2023/6/27.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_EditUserMsgVC.h"

@interface EMO_EditUserMsgVC ()

Strong UIView *bgTopView;
Strong UITextField *textField;


@end

@implementation EMO_EditUserMsgVC




- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBar:YES needBack:YES needBackground:YES];
    self.view.backgroundColor=RGBA(248, 248, 248, 1);
    self.titleLabel.font=KFont(18);
    if(self.type==1){
        self.titleLabel.text=getLanguage(@"我的昵称");
    }else if(self.type==2){
        self.titleLabel.text=getLanguage(@"个性签名");
    }else{
        self.titleLabel.text=getLanguage(@"房间名称");
    }
    
    [self bgTopView];
    [self textField];
    
    
}

-(void)backClick{
    if(self.textField.text.length<1){
        [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"内容不能为空")];
        return;
    }
    if(self.MsgBlock){
        self.MsgBlock(self.textField.text);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (UIView *)bgTopView{
    if (!_bgTopView) {
        _bgTopView = [[UIView alloc] init];
        _bgTopView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_bgTopView];
        [_bgTopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ZJTopNavH+ZJStatusBarH+2);
            make.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.height.mas_equalTo(KAdaptedHeight(60));
            
            
        }];
    }
    return _bgTopView;
}

-(UITextField*)textField{
    if (!_textField) {
        _textField =[[UITextField alloc] init];
        _textField.backgroundColor =RGB(255, 255, 255);
        if(self.type==1){
            _textField.placeholder=getLanguage(@"请输入昵称");
        }else if(self.type==2){
            _textField.placeholder=getLanguage(@"请输入您的个性签名");
        }else {
            _textField.placeholder=getLanguage(@"请输入房间名称");
        }
        _textField.text=self.contentStr;
        [self.bgTopView addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
        }];
    }
    return _textField;
}




@end
