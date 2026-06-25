//
//  EMO_RechargeViewController.m
//  miliao
//
//  Created by 张世浩 on 2022/10/15.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_RechargeViewController.h"
#import "EMO_RechargeCollectionCell.h"
#import "EMO_PaymentView.h"
#import "EMO_RechargeRecordVC.h"//充值记录

@interface EMO_RechargeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,IApRequestResultsDelegate>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) UIView * headViewB;
@property (nonatomic,strong) UIView * topView;
@property (nonatomic,strong) UILabel * moneyLabel;
@property (nonatomic,strong) EMO_PaymentView * payTypeView;
@property (nonatomic,strong) UIButton * payBtn;
@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,strong) NSDictionary * selectDic;
@property (nonatomic,assign) BOOL firstSelect;

Strong NSString *payType;

@end

@implementation EMO_RechargeViewController

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}

-(NSDictionary *)selectDic{
    if (!_selectDic) {
        _selectDic=[NSDictionary dictionary];
    }
    return _selectDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(255, 255, 255, 1);
    [self loadBar:YES needBack:YES needBackground:YES];
    self.barView.backgroundColor=kClearColor;
    self.titleLabel.text=getLanguage(@"充值");
    self.titleLabel.font=KFont(18);
    self.rightTitleLabel.text=getLanguage(@"明细");
    self.rightTitleLabel.textColor=RGBA(0, 0, 0, 1);
    self.rightTitleLabel.font=KFont(14);
    
    self.selectIndex=0;
    [self getPriceList:1];
    [self topView];
    [self moneyLabel];
    
    [self collectionView];
    [self payBtn];
    [IAPManager shared].delegate=self;
    
    [self.view sendSubviewToBack:self.topView];

        self.payTypeView.hidden=YES;
    
    self.payType=@"";
    
}

-(void)rightButtonClick:(UIButton *)sender{
    EMO_RechargeRecordVC *vc=[EMO_RechargeRecordVC new];
    vc.type=1;
    [self.navigationController pushViewController:vc animated:YES];
    
}



#pragma mark - 懒加载UIcollectionCell
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
         _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.scrollsToTop = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces=NO;
        _collectionView.allowsMultipleSelection = YES;
        _collectionView.showsVerticalScrollIndicator=NO;
        _collectionView.backgroundColor=RGBA(255, 255, 255, 1);
        [_collectionView registerClass:[EMO_RechargeCollectionCell class] forCellWithReuseIdentifier:@"EMO_RechargeCollectionCell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FootA"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerA"];
        
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.topView.mas_bottom).offset(KAdaptedHeight(-30));
            make.leading.mas_equalTo(KAdaptedWidth(0));
            make.trailing.mas_equalTo(KAdaptedWidth(-0));
            make.bottom.mas_equalTo(KAdaptedHeight(-100));
        }];
        setViewCorner(_collectionView, KAdaptedHeight(10));
    }
    return _collectionView;
}
-(UIView *)headViewB{
    if (!_headViewB) {
        _headViewB=[[UIView alloc] init];
        _headViewB.backgroundColor=RGBA(255, 255, 255, 1);
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(KAdaptedWidth(24.5), KAdaptedHeight(20), kWidth, KAdaptedHeight(25))];
        label.font=KFontBold(14);
        label.text=getLanguage(@"我要充值");
        label.textColor=RGBA(0,0,0,1);
        label.textAlignment=NSTextAlignmentLeft;
        [_headViewB addSubview:label];

    }
    return _headViewB;
}

- (EMO_PaymentView *)payTypeView{
    if (!_payTypeView) {
        _payTypeView = [[EMO_PaymentView alloc] init];
        WeakSelf;
        _payTypeView.payTypeBlock = ^(NSInteger type) {
            if (type==1000) {
                wself.payType=@"wechat";
            }else if (type==2000){
                wself.payType=@"alipay";
            }else{
                wself.payType=@"otherPay";
            }
//            [wself PayBtnClick];
        };
    }
    return _payTypeView;
}


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerA" forIndexPath:indexPath];
             [header addSubview:self.headViewB];
           [self.headViewB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.trailing.leading.mas_equalTo(0);
               make.bottom.mas_equalTo(KAdaptedHeight(-0));

            }];

       return header;
    }else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        UICollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter                                                                           withReuseIdentifier:@"FootA"                                                                              forIndexPath:indexPath];
        [headerView addSubview:self.payTypeView];
      [self.payTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.mas_equalTo(0);
           make.trailing.leading.mas_equalTo(0);
          make.bottom.mas_equalTo(KAdaptedHeight(-0));

       }];
        
        
        return headerView;
    }else{
        return nil;
    }
        


}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
        return CGSizeMake(kWidth,KAdaptedHeight(52));

}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(kWidth,KAdaptedHeight(200));
}



-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, KAdaptedWidth(11), 0, KAdaptedWidth(11));
 
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake(KAdaptedWidth(111), KAdaptedHeight(80));

   
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
//    return 8;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EMO_RechargeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EMO_RechargeCollectionCell" forIndexPath:indexPath];
    NSDictionary *dic=self.dataArr[indexPath.row];
    cell.dicData=dic;

    
    if (indexPath.row == self.selectIndex) {
        cell.showBorder = YES;
    }else{
        cell.showBorder = NO;
    }
    
    
    return cell;
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectIndex = indexPath.row;
    self.selectDic=self.dataArr[self.selectIndex];
    [self.collectionView reloadData];
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = RGBA(255, 235, 220, 1);
        [self.view addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.leading.trailing.mas_equalTo(0);
            make.height.mas_equalTo(220);
        }];
        
       UIImageView *_bgImageView = [[UIImageView alloc] init];
        _bgImageView.image=KGetImage(@"coinIconImg");
        [self.topView addSubview:_bgImageView];
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(190), KAdaptedHeight(190)));
            make.trailing.mas_equalTo(KAdaptedWidth(10));
            make.bottom.mas_equalTo(KAdaptedHeight(20));
            
        }];
        
        
//        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(KAdaptedWidth(24.5), KAdaptedHeight(20), kWidth, KAdaptedHeight(25))];
        UILabel *label=[[UILabel alloc] init];
        label.font=KFont(13);
        label.text=getLanguage(@"金币钱包");
        label.textColor=RGBA(34,34,4,1);
        label.textAlignment=NSTextAlignmentLeft;
        [_topView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(_topView.mas_top);
            make.bottom.mas_equalTo(_topView.mas_bottom).offset(KAdaptedHeight(-100));
            make.leading.mas_equalTo(KAdaptedWidth(38));
            make.width.mas_equalTo(KAdaptedWidth(120));
            make.height.mas_equalTo(KAdaptedHeight(25));
        }];
        
        
    }
    return _topView;
}

- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.text =[UserManager userInfo].money;
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_moneyLabel.text];
//        NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
//        attchment.bounds=CGRectMake(5,-2,17,17);//设置frame
//            attchment.image=[UIImage imageNamed:@"coinImg"];//设置图片
//        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(attchment)];
//        [attributedString appendAttributedString:string]; //添加到尾部
//        _moneyLabel.attributedText = attributedString;
        _moneyLabel.textColor = RGBA(91, 61, 32, 1);
        _moneyLabel.font=KFontBold(22);
//        _moneyLabel.textAlignment=NSTextAlignmentRight;
        [self.topView addSubview:_moneyLabel];
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_topView.mas_bottom).offset(KAdaptedHeight(-50));
            make.leading.mas_equalTo(KAdaptedWidth(38));
            make.width.mas_equalTo(KAdaptedWidth(200));
            make.height.mas_equalTo(KAdaptedHeight(40));
        }];
    }
    return _moneyLabel;
}

- (UIButton *)payBtn{
    if (!_payBtn) {
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _payBtn.frame=CGRectMake(KAdaptedWidth(27.5), kHeight-KAdaptedHeight(36+50)-KSAFEAREA_BOTTOM_HEIHGHT, kWidth-KAdaptedWidth(55), KAdaptedHeight(45));
        
        _payBtn.backgroundColor = BaseMainColor ;
        [_payBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_payBtn makeRoundCorner];
        
            [_payBtn setTitle:getLanguage(@"立即购买") forState:UIControlStateNormal];

        _payBtn.titleLabel.font=KFont(15);
        _payBtn.tag=500;
        [_payBtn addTarget:self action:@selector(PayBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_payBtn];
    }
    return _payBtn;
}

///确认充值
/**
 paytype    是    string    1支付宝 2微信
 price    是    string    金额 选择商品时可不传该参数
 goodsid    否    string    商品列表的ID   手输金额时可不传该参数
 uid    否    string    用户ID
 */
-(void)PayBtnClick{

    if (self.selectDic ==nil) {
        return [SVProgressHUD showImage:[UIImage imageNamed:@""] status:getLanguage(@"请选择充值金额")];
    }
//    if(self.payType.length<1){
//        return [SVProgressHUD showImage:[UIImage imageNamed:@""] status:getLanguage(@"请选择支付方式")];
//    }
    [SVProgressHUD showWithStatus:getLanguage(@"充值中")];
    [NetworkRequest POST:Request_RechangeOrder parmeters:@{@"type":@"ios",@"rechange_id":self.selectDic[@"id"]} success:^(id responObject) {
        [SVProgressHUD dismiss];
        BaseModel *model=(BaseModel *)responObject;
        NSLog(@"%@",model.data);
        [self iosPay:model.data[@"out_trade_no"]];
    } failture:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(void)iosPay:(NSString *)orderID{
    [SVProgressHUD showWithStatus:getLanguage(@"充值中")];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [[IAPManager shared] requestProductWithId:self.selectDic[@"ios_id"] payID:orderID];
}



-(void)filedWithSuccess{
    [SVProgressHUD dismiss];
    [SVProgressHUD showImage:[UIImage imageNamed:@""] status:getLanguage(@"充值成功")];
    [self getPriceList:2];
}

-(void)filedWithErrorCode:(NSInteger)errorCode andError:(NSString *)error{
    
    [SVProgressHUD dismiss];
    [SVProgressHUD showImage:[UIImage imageNamed:@""] status:[NSString stringWithFormat:@"%@:%ld",getLanguage(@"充值失败"),errorCode]];
    
}

///充值列表
- (void)getPriceList:(NSInteger)A{
    
    [NetworkRequest POST:Request_RechangeList parmeters:@{@"device":@"ios"} success:^(id responObject) {
        BaseModel *model=(BaseModel *)responObject;
        NSArray *Array = [[NSArray alloc] initWithArray:model.data];
        [self.dataArr removeAllObjects];
        if([[UserManager userInfo].real_name_status isEqual:@"2"]){
            [self.dataArr addObjectsFromArray:model.data];
        }else{
            for (NSDictionary *dic  in Array) {
                if([dic[@"is_show_text"] isEqualToString:@"显示"]){
                    [self.dataArr addObject:dic];
                }
            }
        }
        if(self.dataArr.count>0){
            self.selectDic=self.dataArr[0];
        }
        [self.collectionView reloadData];
    } failture:^(NSError *error) {
        
    }];
    
    if(A==2){
        [NetworkRequest POST:Request_GetMyMoney parmeters:nil success:^(id responObject) {
            BaseModel *model=(BaseModel *)responObject;
            self.moneyLabel.text=[Common isNull:model.data[@"money"]];
        } failture:^(NSError *error) {
            
        }];
    }
   
    
}




@end
