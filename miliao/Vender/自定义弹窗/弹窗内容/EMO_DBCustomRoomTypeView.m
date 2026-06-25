//
//  EMO_DBCustomRoomTypeView.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/19.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_DBCustomRoomTypeView.h"
#import "EMO_BtnView.h"
@interface EMO_DBCustomRoomTypeView()

Strong NSMutableArray *dataArr;

@property (nonatomic ,strong) UIView *bgView;
@property (nonatomic ,strong) UIView *typeView;
@property (nonatomic ,strong) UIView *lineView;

Strong NSArray *SelectArr;

@end

@implementation EMO_DBCustomRoomTypeView

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

- (void) addChildrenViews{
    [super addChildrenViews];
    [self bgView];
    [self lineView];
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    self.dataArr=[NSMutableArray arrayWithArray:dicData[@"data"]];
    [self addView];
}


-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
-(NSArray *)SelectArr{
    if(!_SelectArr){
        _SelectArr=[NSArray array];
    }
    return _SelectArr;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor =kWhiteColor;
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(self);
            make.height.mas_equalTo(KAdaptedHeight(200)+KSAFEAREA_BOTTOM_HEIHGHT);
        }];
    }
    return _bgView;
}

- (UIView *)typeView{
    if (!_typeView) {
        _typeView = [[UIView alloc] init];
        _typeView.backgroundColor =kWhiteColor;
        [self.bgView addSubview:_typeView];
        [_typeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self);
            make.height.mas_equalTo(KAdaptedHeight(100)+KSAFEAREA_BOTTOM_HEIHGHT);
            make.bottom.mas_equalTo(KAdaptedHeight(-20));
        }];
    }
    return _typeView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(KAdaptedWidth(30), KAdaptedHeight(40), KAdaptedWidth(35), KAdaptedHeight(6))];
        _lineView.backgroundColor =RGBA(255, 198, 0, 1);
        [self.bgView addSubview:_lineView];
        setViewCorner(_lineView, KAdaptedHeight(3));
//        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(KAdaptedHeight(6));
//            make.leading.mas_equalTo(KAdaptedWidth(30));
//            make.width.mas_equalTo(KAdaptedWidth(35));
//            make.top.mas_equalTo(KAdaptedHeight(45));
//        }];
    }
    return _lineView;
    
}

-(void)addView{
    
    int i=0;
    for (NSDictionary *dic in self.dataArr) {
        UIButton *btn=[[UIButton alloc] init];
        [btn setTitle:dic[@"name"] forState:UIControlStateNormal];
        [btn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateSelected];
        [btn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
        btn.titleLabel.font=KFontA(14);
        btn.tag=10+i;
        [btn addTarget:self action:@selector(oneBtnCLick:) forControlEvents:UIControlEventTouchUpInside];
        if(i==0){
            btn.titleLabel.font=KFontA(16);
            btn.selected=YES;
            int y=0;
            self.SelectArr=dic[@"children"];
            for (NSDictionary *childrenDic in dic[@"children"]) {
                EMO_BtnView *  gamrBtn = [[EMO_BtnView alloc] init];
                gamrBtn.frame = CGRectMake(KAdaptedWidth(20)+KAdaptedWidth(80)*y, KAdaptedHeight(10), KAdaptedWidth(70), KAdaptedHeight(75));
                [gamrBtn.iconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",childrenDic[@"image"]]]];
                gamrBtn.nameLabel.text=[NSString stringWithFormat:@"%@",childrenDic[@"name"]];
                gamrBtn.ClickBtn.tag=100+y;
                WeakSelf;
                gamrBtn.BtnBlock = ^(NSInteger tag) {
                    [wself SettingBtnClick:tag];
                };
                [self.typeView addSubview:gamrBtn];
                y++;
            }
            
        }
        [self.bgView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(50), KAdaptedHeight(30)));
            make.leading.mas_equalTo(KAdaptedWidth(20)+KAdaptedWidth(60)*i);
            make.top.mas_equalTo(KAdaptedHeight(20));
            
        }];
        
        i++;
        
    }
    
}

-(void)oneBtnCLick:(UIButton *)sender{
    
    for (UIButton *btn in self.bgView.subviews) {
        if([btn isKindOfClass:[UIButton class]]){
            if(btn.tag==sender.tag){
                btn.selected=YES;
                btn.titleLabel.font=KFontA(16);
                [UIView animateWithDuration:0.3 animations:^{
                    self.lineView.frame=CGRectMake(KAdaptedWidth(30)+KAdaptedWidth(60)*(btn.tag-10), KAdaptedHeight(40), KAdaptedWidth(35), KAdaptedHeight(6));
                }];
                
            }else{
                btn.selected=NO;
                btn.titleLabel.font=KFontA(14);
            }
               
        }
    }
   
    
    [self.typeView removeAllSubviews];
    self.SelectArr=self.dataArr[sender.tag-10][@"children"];
    int y=0;
    for (NSDictionary *childrenDic in self.SelectArr) {
        EMO_BtnView *  gamrBtn = [[EMO_BtnView alloc] init];
        gamrBtn.frame = CGRectMake(KAdaptedWidth(20)+KAdaptedWidth(80)*y, KAdaptedHeight(10), KAdaptedWidth(70), KAdaptedHeight(75));
        [gamrBtn.iconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",childrenDic[@"image"]]]];
        gamrBtn.nameLabel.text=[NSString stringWithFormat:@"%@",childrenDic[@"name"]];
        gamrBtn.ClickBtn.tag=[childrenDic[@"id"] integerValue];
        WeakSelf;
        gamrBtn.BtnBlock = ^(NSInteger tag) {
            [wself SettingBtnClick:tag];
        };
        [self.typeView addSubview:gamrBtn];
        y++;
    }
 
}

-(void)SettingBtnClick:(NSInteger)tag{
    for (NSDictionary *dic in self.SelectArr) {
        if([dic[@"id"] integerValue]==tag){
            if(self.cancleBtnClick){
                self.cancleBtnClick(dic);
            }
        }
    }
    
   
    
}






@end
