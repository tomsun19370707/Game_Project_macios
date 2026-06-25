//
//  EMO_AddTalkView.m
//  miliao
//
//  Created by ZhangShiHao on 2023/6/28.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_AddTalkView.h"
#import "CustomAlertViewA.h"
@interface EMO_AddTalkView ()
Strong UIView *bgView;
Strong UIButton *talkBtn;
Strong UIImageView *iconImgView;
Strong UIButton *clickBtn;

Strong UIView *talkBgView;

Strong NSMutableArray *dataArr;
@property(nonatomic,strong)NSMutableArray *arr;

@end

@implementation EMO_AddTalkView

-(NSMutableArray *)arr{
    if(!_arr){
        _arr=[NSMutableArray array];
    }
    return _arr;
}
-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        [self bgView];
        [self talkBtn];
        [self iconImgView];
        [self clickBtn];
        [self talkBgView];
        [self addData];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddTalkNotification:) name:@"AddTalkNotification" object:nil];
        
        
    }
    return self;
}


- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.borderColor=RGBA(241, 241, 241, 1).CGColor;
        _bgView.layer.borderWidth=1;
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(10));
            make.leading.mas_equalTo(-5);
            make.trailing.mas_equalTo(5);
            make.height.mas_equalTo(KAdaptedHeight(45));
        }];
    }
    return _bgView;
}


- (UIButton *)talkBtn{
    if (!_talkBtn) {
        _talkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_talkBtn setTitle:getLanguage(@"添加话题") forState:UIControlStateNormal];
        [_talkBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        _talkBtn.titleLabel.font=KFontA(13);
        [_talkBtn setImage:[UIImage imageNamed:@"talkImg"] forState:UIControlStateNormal];
        _talkBtn.userInteractionEnabled=NO;
        _talkBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [self.bgView addSubview:_talkBtn];
        [_talkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.leading.mas_equalTo(KAdaptedWidth(5));
            make.width.mas_equalTo(150);
        }];
        [_talkBtn setImagePositionWithType:SSImagePositionTypeLeft spacing:5];
    }
    return _talkBtn;
}

- (UIImageView*)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image=KGetImage(@"mineRightImg");
        [self.bgView addSubview:_iconImgView];
        [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(KAdaptedWidth(15));
            make.centerY.mas_equalTo(0);
            make.trailing.mas_equalTo(KAdaptedWidth(-5));
        }];
    }
    return _iconImgView;
}



- (UIButton *)clickBtn{
    if (!_clickBtn) {
        _clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clickBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_clickBtn];
        [_clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.bottom.trailing.mas_equalTo(0);
            
        }];
    }
    return _clickBtn;
}

- (UIView *)talkBgView{
    if (!_talkBgView) {
        _talkBgView = [[UIView alloc] init];
        _talkBgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_talkBgView];
        [_talkBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bgView.mas_bottom).offset(KAdaptedHeight(5));
            make.leading.mas_equalTo(-1);
            make.trailing.mas_equalTo(1);
            make.bottom.mas_equalTo(KAdaptedHeight(0));
        }];
    }
    return _talkBgView;
}


#pragma mark 创建标签视图
- (void)createUI{
   
    CGFloat tagBtnX = KAdaptedWidth(3);
    CGFloat tagBtnY = KAdaptedHeight(10);
    for (int i= 0; i<self.arr.count; i++) {
        NSDictionary *dic=self.arr[i];
        CGSize tagTextSize = [dic[@"topic"] sizeWithFont:KFont(14) maxSize:CGSizeMake(kWidth-KAdaptedWidth(32)-KAdaptedWidth(32), KAdaptedHeight(30))];
        if (tagBtnX+tagTextSize.width+KAdaptedWidth(30) > kWidth-KAdaptedWidth(32)) {
            
            tagBtnX = KAdaptedWidth(16);
            tagBtnY += KAdaptedHeight(30+15);
        }
        UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tagBtn.tag = 100+i;
        tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+KAdaptedWidth(50), KAdaptedHeight(30));
        
        [tagBtn setTitle:[NSString stringWithFormat:@"%@",dic[@"topic"]] forState:UIControlStateNormal];
        [tagBtn setImage:KGetImage(@"delImg") forState:UIControlStateNormal];
        [tagBtn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
        [tagBtn setTitleColor:RGBA(199, 15, 255, 1) forState:UIControlStateSelected];
        tagBtn.titleLabel.font = KFont(14);
        tagBtn.layer.cornerRadius =  KAdaptedHeight(15);
        tagBtn.layer.masksToBounds = YES;
        tagBtn.backgroundColor=RGBA(153, 153, 153, 0.1);
//        tagBtn.layer.borderWidth = 1;
//        tagBtn.layer.borderColor = [UIColor orangeColor].CGColor;
//        [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        //按钮长按
//        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
//       //长按时间
//        longPress.minimumPressDuration = 0.5;
//        [tagBtn addGestureRecognizer:longPress];
        //按钮点击
        UITapGestureRecognizer *longPress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
        [tagBtn addGestureRecognizer:longPress];
        
        [self.talkBgView addSubview:tagBtn];
        tagBtnX = CGRectGetMaxX(tagBtn.frame)+KAdaptedWidth(10);
        [tagBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5];
    }
}
#pragma mark 删除
-(void)tapPress:(UITapGestureRecognizer *)tap{
    [self.arr removeObjectAtIndex:tap.view.tag-100];
    [self FreshBtnView];
}
#pragma mark 长按删除
-(void)longPress:(UILongPressGestureRecognizer *)tap{
    if (tap.state == UIGestureRecognizerStateBegan){
        [self.arr removeObjectAtIndex:tap.view.tag-100];
        [self FreshBtnView];
    }
   
}

-(void)setSelectDataArr:(NSMutableArray *)selectDataArr{
    _selectDataArr=selectDataArr;
    self.arr=selectDataArr;
    [self FreshBtnView];
    
}

-(void)FreshBtnView{
    if(self.talkBlock){
        self.talkBlock(self.arr);
    }
    for (UIButton *btn in self.talkBgView.subviews) {
        if (btn.tag>=100) {
            [btn removeFromSuperview];
        }
    }
    [self createUI];
}

//#pragma mark 选中
- (void)tagBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) [btn setBackgroundColor:RGBA(240, 226, 249, 1)];
    if (!btn.selected) [btn setBackgroundColor:RGBA(153, 153, 153, 0.1)];

}




-(void)btnClick{
    
    [CustomAlertViewA showAlertView_Type:AlertType_Bottom ContentType:AddTalkCustomViewTag andData:@{@"data":self.dataArr}];
    
//        [CustomAlertViewA showAlertView_Type:AlertType_Bottom ContentType:AddTalkCustomViewTag andData:@{@"data":@[@"# 灌篮高手",@"# 有点钱全炫嘴里了",@"# 我好无聊啊",@"# 这辈子都没这么无语过",@"# 这件事情泰酷辣",@"# 一天天的",@"# 分手快乐"]}];
    
}


#pragma mark 通知
-(void)AddTalkNotification:(NSNotification *)content{
    NSDictionary *dic=content.userInfo;
    if([dic[@"code"] integerValue]==1){
        if (self.arr.count<5) {
                [self.arr addObject:dic[@"data"]];
                [self FreshBtnView];
        }else{
            [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"最多添加5个")];

        }
    }
    
}

-(void)addData{

    [NetworkRequest POST:Request_GetDynamicTopic parmeters:nil success:^(id responObject) {
        
        BaseModel *mode=(BaseModel *)responObject;
        [self.dataArr addObjectsFromArray:mode.data];
        
    } failture:^(NSError *error) {

        
        
    }];

    
    
    
    
}




@end
