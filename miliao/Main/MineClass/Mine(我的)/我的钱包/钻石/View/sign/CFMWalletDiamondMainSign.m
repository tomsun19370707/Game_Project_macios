//
//  CFMWalletDiamondMainSign.m
//  miliao
//
//  Created by Dylan Lee on 2025/12/9.
//  Copyright © 2025 EMO. All rights reserved.
//

#import "CFMWalletDiamondMainSign.h"
#import "EMO_RenZhengViewController.h"
@interface CFMWalletDiamondMainSign ()
/** View */
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UIButton *sign;

@end

@implementation CFMWalletDiamondMainSign

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
//首先给让cell左右偏移一点的距离，通过重写cell的setframe方法来实现   
- (void)setFrame:(CGRect)frame{
    CGFloat margin = 12;
    frame.origin.x = margin;
    frame.size.width = SCREEN_WIDTH - margin*2;
    [super setFrame:frame];
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
    [self.sign makeRoundCorner];
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
    
}

#pragma mark -
#pragma mark --- Getter

#pragma mark --
#pragma mark --- Setter
-(void)setCansSign:(BOOL)cansSign
{
    if (cansSign) {
        self.sign.backgroundColor = HexColorDy(@"8E4BF9");
        self.sign.enabled = YES ;
        [self.sign setTitle:@"签到" forState:UIControlStateNormal];
    }else{
        self.sign.backgroundColor = HexColorDy(@"999999");
        self.sign.enabled = NO ;
        [self.sign setTitle:@"已签到" forState:UIControlStateNormal];
    }
}
#pragma mark --
#pragma mark --- ibaction
- (IBAction)ac:(id)sender {
    //如果没有实名认证、不可以发送评论
    if([[UserManager userInfo].real_name_status intValue] != 2){
        /** 是否实名认证 0.待提交,1.审核中,2.审核通过,3.审核拒绝*/
        if ([UserManager userInfo].real_name_status.intValue==1) {
            [SVProgressHUD showTextHUDWithMessage:@"实名认证审核中！"];
            return;
        }
        //未实名
        DYAlertView *alert = [[DYAlertView alloc] initWithTitle:@"温馨提示" content:@"请先完成实名认证！" construct:@"确定" completion:^{
            
            EMO_RenZhengViewController *vc=[EMO_RenZhengViewController new];
            [Dn_NAVPUSH pushViewController:vc animated:YES];
        }];
        [alert addButtonTitle:@"取消" completion:^{
            
        }];
        [alert show];
        return;
    }
    
    /** 去签到*/
    NSString *url = [NSString stringWithFormat:@"%@?token=%@&type=sign",lottery_lottery_h5,UserDefaultsGet(kToken)];
    
    WebJSVc *load = [[WebJSVc alloc]init];
    load.webUrl = url;
    [Dn_NAVPUSH pushViewController:load animated:YES];
}
#pragma mark --
#pragma mark --- Method
@end
