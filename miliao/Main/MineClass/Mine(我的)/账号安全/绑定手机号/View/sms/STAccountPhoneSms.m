//
//  STAccountPhoneSms.m
//  miliao
//
//  Created by Dylan Lee on 2025/12/8.
//  Copyright © 2025 EMO. All rights reserved.
//

#import "STAccountPhoneSms.h"
@interface STAccountPhoneSms ()
/** View */

@end

@implementation STAccountPhoneSms

#pragma mark -
#pragma mark --- init
-(instancetype)init
{
    self = [super init];
    if (self) {
        /** 初始化*/
        [self initContentview];
        /** RAC*/
        [self initRacChain];
    }
    return self ;
}

#pragma mark -
#pragma mark --- init frame
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /** 初始化*/
        [self initContentview];
        /** RAC*/
        [self initRacChain];
    }
    return self ;
}

#pragma mark -
#pragma mark --- 初始化view
- (void)initContentview
{
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(15, self.contentView.height - 1, SCREEN_WIDTH - 15 * 2, 0.5)];
    line.backgroundColor = LineColor ;
    [self.contentView addSubview:line];  
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    /** 初始化*/
    [self initContentview];
    /** RAC*/
    [self initRacChain];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -
#pragma mark --- Rac
- (void)initRacChain {
    @weakify(self);
    /** 验证码获取*/
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [self.codeLab addGestureRecognizer:tap];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        /** 判断手机号的输入是否正确*/
        NSString *phoneNum = [self.tf text];
        if ([NSString NotNull:phoneNum]) {
            /** request*/
            /** para*/
            NSMutableDictionary *parameter =[NSMutableDictionary dictionary];
            parameter[@"mobile"] = phoneNum;
//            [DUGeneralApiService getSMSCode:parameter success:^(NSString *content) {
//                @strongify(self);
//                /** 成功后，执行倒计时*/
//                [self.getCodeLab smsCodeCountingDownIntervall:60];
//                [self.codeTf becomeFirstResponder];
//                self.codeTf.text = content ;
//            } failure:^{
//
//            }];
            
        }else{
            [SVProgressHUD showTextHUDWithMessage:@"手机号不正确！"];
        }
        
    }];
}

#pragma mark -
#pragma mark --- Getter

#pragma mark --
#pragma mark --- Setter

#pragma mark --
#pragma mark --- ibaction

#pragma mark --
#pragma mark --- Method
@end
