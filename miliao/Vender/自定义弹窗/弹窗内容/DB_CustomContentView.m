//
//  DB_CustomContentView.m
//  CustomAlertView
//
//  Created by mac on 2021/1/23.
//

#import "DB_CustomContentView.h"

#import "UILabel+YBAttributeTextTapAction.h"



@interface DB_CustomContentView()<UIScrollViewDelegate,IApRequestResultsDelegate>

@property (nonatomic ,strong) UIView *bgView;
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UIButton *freshBtn;
@property (nonatomic ,strong) UIButton *backBtn;
@property (nonatomic ,strong) UILabel *blanceLabel;
@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) UILabel *tipLabel;
@property (nonatomic ,strong) UIButton *aliPayBtn;
@property (nonatomic ,strong) UIButton *wxPayBtn;
@property (nonatomic ,strong) UIButton *payBtn;
@property (nonatomic ,strong) NSArray *listArrData;
@property (nonatomic ,strong) NSDictionary *selectDicData;
@property (nonatomic,strong) NSDictionary *dicData;


@end




@implementation DB_CustomContentView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addChildrenViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addChildrenViews];
    }
    return self;
}

-(NSArray *)listArrData{
    if (!_listArrData) {
        _listArrData=[NSArray array];
    }
    return _listArrData;
}
-(NSDictionary *)selectDicData{
    if (!_selectDicData) {
        _selectDicData=[NSDictionary dictionary];
    }
    return _selectDicData;
}
-(NSDictionary *)dicData{
    if (!_dicData) {
        _dicData=[NSDictionary dictionary];
    }
    return _dicData;
}


- (void)filedWithErrorCode:(NSInteger)errorCode andError:(NSString *)error{
    [SVProgressHUD dismiss];
    [SVProgressHUD showImage:[UIImage imageNamed:@""] status:[NSString stringWithFormat:@"充值失败:%ld",errorCode]];
}
- (void)filedWithSuccess{
    [SVProgressHUD dismiss];
    [SVProgressHUD showImage:[UIImage imageNamed:@""] status:[NSString stringWithFormat:@"充值成功"]];
    [self getPriceList:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RechargeCoinNotification" object:self userInfo:nil];
    
}


-(void)BtnClick:(UIButton *)sender{
    if (sender.tag==100) {
        [self getPriceList:YES];
    }else if (sender.tag==200){
        if (self.cancleBtnClick) {
            self.cancleBtnClick(@{@"data":@(self.tag)});
        }
    }else if (sender.tag==300){
        if (self.selectDicData) {
            [SVProgressHUD showWithStatus:@"充值中,请稍后"];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
            [IAPManager shared].delegate=self;
            [[IAPManager shared] requestProductWithId:self.selectDicData[@"ios_id"] payID:self.selectDicData[@"ios_id"]];
        }else{
            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:[NSString stringWithFormat:@"请选择充值金额"]];
        }
        
//        [[IAPManager shared] requestProductWithId:self.selectModel.ios_id payID:self.selectModel.ios_id];
    }
    
}

-(void)SelectBtnClick:(UIButton *)sender{


}


- (void) addChildrenViews{
    [super addChildrenViews];
    
    [self getPriceList:NO];
    
    [self bgView];
    [self titleLabel];
    [self backBtn];
    [self freshBtn];
    [self blanceLabel];

    [self payBtn];
    [self tipLabel];
    [self scrollView];
    

}


-(void)listView:(NSArray *)listArr{
    //每个Item宽高
    CGFloat W = KAdaptedWidth(104);
    CGFloat H = KAdaptedHeight(95);
    //每行列数
    NSInteger rank = 3;
    //每列间距
    CGFloat rankMargin = 15;
    //每行间距
    CGFloat rowMargin = 12;
    //Item索引 ->根据需求改变索引
//    NSUInteger index = 12;
    
//    for (int i = 0 ; i< listArr.count; i++) {
//        //Item X轴
//        CGFloat X = (i % rank) * (W + rankMargin);
//        //Item Y轴
//        NSUInteger Y = (i / rank) * (H +rowMargin);
//        //Item top
//        CGFloat top = 10;
//        RechargeCoinView *burtton = [[RechargeCoinView alloc] init];
//        burtton.frame = CGRectMake(X+rowMargin, Y+top, W, H);
//        burtton.layer.borderWidth=KAdaptedWidth(1);
//        burtton.layer.borderColor=Color(242, 242, 242, 0).CGColor;
//        burtton.layer.cornerRadius=KAdaptedHeight(10);
//        burtton.layer.masksToBounds=YES;
//        burtton.tag=burtton.selectBtn.tag=10000+i;
//        burtton.dicData=listArr[i];
//        [burtton.selectBtn addTarget:self action:@selector(SelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.scrollView addSubview:burtton];
//
//    }
//    self.scrollView.contentSize = CGSizeMake(kWidth,(H+rowMargin)*(listArr.count/ rank) );
    
}


- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor =kWhiteColor;
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(self);
            make.height.mas_equalTo(KAdaptedHeight(500)+DBottomDangerArea);
        }];
    }
    return _bgView;
}


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"金币充值";
        _titleLabel.textColor = Color(51, 51, 51, 1);
        _titleLabel.textAlignment=NSTextAlignmentLeft;
        _titleLabel.font=KFontBold(15);
        [self.bgView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.bgView.mas_leading).offset(KAdaptedHeight(18));
            make.width.mas_equalTo(KAdaptedWidth(70));
            make.height.mas_equalTo(KAdaptedWidth(20));
            make.top.mas_equalTo(self.bgView.mas_top).offset(KAdaptedHeight(17));
        }];
    }
    return _titleLabel;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.backgroundColor=Color(242, 242, 242, 1);
        [_backBtn setImage:[UIImage imageNamed:@"jianTouImg"] forState:UIControlStateNormal];
        _backBtn.tag=200;
        _backBtn.layer.cornerRadius=KAdaptedWidth(25/2);
        _backBtn.layer.masksToBounds=YES;
        [_backBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(KAdaptedWidth(25));
            make.top.mas_equalTo(KAdaptedHeight(13));
            make.trailing.mas_equalTo(KAdaptedWidth(-18));
        }];
    }
    return _backBtn;
}


- (UIButton *)freshBtn{
    if (!_freshBtn) {
        _freshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _freshBtn.backgroundColor=Color(242, 242, 242, 1);
        _freshBtn.layer.cornerRadius=KAdaptedWidth(25/2);
        _freshBtn.layer.masksToBounds=YES;
        [_freshBtn setImage:[UIImage imageNamed:@"refreshImg"] forState:UIControlStateNormal];
        _freshBtn.tag=100;
        [_freshBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_freshBtn];
        [_freshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(self.backBtn.mas_width);
            make.top.mas_equalTo(self.backBtn.mas_top);
            make.trailing.mas_equalTo(self.backBtn.mas_leading).offset(KAdaptedWidth(-12));
            
        }];
    }
    return _freshBtn;
}

- (UILabel *)blanceLabel{
    if (!_blanceLabel) {
        _blanceLabel = [[UILabel alloc] init];
        _blanceLabel.backgroundColor=Color(244, 238, 255, 1);
        _blanceLabel.layer.cornerRadius=KAdaptedHeight(10);
        _blanceLabel.layer.masksToBounds=YES;
        _blanceLabel.text = @"   当前余额:0";
        _blanceLabel.textColor = Color(149, 108, 255, 1);
        _blanceLabel.textAlignment=NSTextAlignmentLeft;
        _blanceLabel.font=KFont(14);
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_blanceLabel.text];
        NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
        attchment.bounds=CGRectMake(13,-2,15,15);//设置frame
            attchment.image=[UIImage imageNamed:@"coinImg"];//设置图片
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(attchment)];
        [attributedString insertAttributedString:string atIndex:2];
//        [attributedString appendAttributedString:string]; //添加到尾部
        _blanceLabel.attributedText = attributedString;
        [self.bgView addSubview:_blanceLabel];
        [_blanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.titleLabel.mas_leading).offset(KAdaptedHeight(0));
            make.trailing.mas_equalTo(self.bgView.mas_trailing).offset(KAdaptedHeight(-18));
            make.height.mas_equalTo(KAdaptedWidth(35));
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(KAdaptedHeight(15));
        }];
    }
    return _blanceLabel;
}


- (UIButton *)payBtn{
    if (!_payBtn) {
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payBtn setTitle:@"去支付" forState:UIControlStateNormal];
        [_payBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _payBtn.backgroundColor=Color(6, 180, 253, 1);
        _payBtn.layer.cornerRadius=KAdaptedHeight(20);
        _payBtn.layer.masksToBounds=YES;
        _payBtn.tag=300;
        [_payBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_payBtn];
        [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(KAdaptedHeight(40));
            make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-(DBottomDangerArea+KAdaptedHeight(30)));
            make.trailing.mas_equalTo(self.bgView.mas_trailing).offset(KAdaptedWidth(-30));
            make.leading.mas_equalTo(self.bgView.mas_leading).offset(KAdaptedWidth(30));

        }];
    }
    return _payBtn;
}


- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"充值即代表同意 充值服务协议";
        _tipLabel.textColor = Color(153, 153, 153, 1);
        _tipLabel.font=KFont(12);
        _tipLabel.textAlignment=NSTextAlignmentCenter;
        NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithString:_tipLabel.text];
        [mutableStr addAttribute:NSForegroundColorAttributeName value:Color(153, 153, 153, 1) range:NSMakeRange(0, _tipLabel.text.length-6)];
        [mutableStr addAttribute:NSForegroundColorAttributeName value:Color(96, 65, 255, 1) range:NSMakeRange(_tipLabel.text.length-6, 6)];
        _tipLabel.attributedText = mutableStr;
        [_tipLabel yb_addAttributeTapActionWithStrings:@[@"充值服务协议"] tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
            if (self.cancleBtnClick) {
                self.cancleBtnClick(@{@"data":@"100"});
            }
     
            
        }];
        [self.bgView addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(KAdaptedWidth(180));
            make.centerX.mas_equalTo(self.bgView.mas_centerX);
            make.height.mas_equalTo(KAdaptedHeight(15));
            make.bottom.mas_equalTo(self.payBtn.mas_top).offset(KAdaptedHeight(-15));;
        }];
    }
    return _tipLabel;
}


-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView=[[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.delegate=self;
        if (@available(iOS 11.0, *)) {//顶部留白
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _scrollView.showsVerticalScrollIndicator=NO;
        _scrollView.showsHorizontalScrollIndicator=NO;
        _scrollView.scrollEnabled=YES;
        _scrollView.bounces=NO;
        [self.bgView addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.blanceLabel.mas_bottom).offset(KAdaptedHeight(5));
            make.width.mas_equalTo(self.bgView.mas_width);
            make.leading.mas_equalTo(self.bgView.mas_leading).offset(0);
            make.bottom.mas_equalTo(self.tipLabel.mas_top).offset(-10);


        }];
    }
    return _scrollView;
}


///充值列表
- (void)getPriceList:(BOOL)show{
    NSDictionary *dic = @{@"uid":[UserManager userInfo].user_id,
                          @"newtoken":[Common isNull:UserDefaultsGet(kToken)]
    };
    WeakSelf;
    [HttpTool getIosNewGoodsListWithParameters:dic success:^(id response) {
        if ([response[@"code"] intValue] == 1) {
            if (show) {
                [SVProgressHUD showImage:[UIImage imageNamed:@""] status:[NSString stringWithFormat:@"刷新成功"]];
            }
//            self.gameView.moneyListDic=response[@"data"];
            wself.blanceLabel.text =[NSString stringWithFormat: @"   当前余额:%@",response[@"data"][@"balance"]];
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:wself.blanceLabel.text];
                NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
                attchment.bounds=CGRectMake(13,-2,15,15);//设置frame
                    attchment.image=[UIImage imageNamed:@"coinImg"];//设置图片
                NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(attchment)];
                [attributedString insertAttributedString:string atIndex:2];
            //        [attributedString appendAttributedString:string]; //添加到尾部
            wself.blanceLabel.attributedText = attributedString;
            wself.listArrData=response[@"data"][@"goodslist"];
                [wself listView:wself.listArrData];
        }
    } failure:^(NSError *error) {
        
    }];
}



@end
