//
//  EMO_TaskHeadView.m
//  miliao
//
//  Created by ZhangShiHao on 2023/6/30.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_TaskHeadView.h"
#import "EMO_SignDayView.h"
@interface EMO_TaskHeadView()
Strong UIImageView *bgImgView;
Strong UIView *contentView;
Strong UIView *shadowView;
Strong UILabel *dayLabel;
Strong UIView *lineView;

Strong UIView *dayView;

Strong UIView *topView;
Strong UILabel *titleLabel;
Strong UILabel *contentLabel;
Strong UIImageView *tipImgView;
Strong UIView *lineTwoView;

Strong NSMutableArray *listArr;

@end


@implementation EMO_TaskHeadView

-(NSMutableArray *)listArr{
    if(!_listArr){
        _listArr=[NSMutableArray array];
    }
    return _listArr;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self bgImgView];
        [self shadowView];
        [self contentView];
        [self dayLabel];
        [self lineView];
        [self dayView];
        [self topView];
        [self titleLabel];
        [self contentLabel];
        [self tipImgView];
        [self lineTwoView];

        WeakSelf;
        //每个Item宽高
        CGFloat W = KAdaptedWidth(40);
        CGFloat H = KAdaptedHeight(70);
        //每行列数
        NSInteger rank = 7;
        //每列间距
        CGFloat rankMargin = 5;
        //每行间距
        CGFloat rowMargin = 20;
        //Item索引 ->根据需求改变索引
        NSUInteger index = 7;
        for (int i = 0 ; i< index; i++) {
            //Item X轴
            CGFloat X = (i % rank) * (W + rankMargin);
            //Item Y轴
            NSUInteger Y = (i / rank) * (H +rowMargin);
            //Item top
            CGFloat top = 10;
            
            EMO_SignDayView *view=[[EMO_SignDayView alloc] init];
            view.frame = CGRectMake(X, Y+top, W, H);
            
            view.SignBlock = ^(NSDictionary * _Nonnull dic) {
                [wself signData:dic];
            };
            [self.dayView addSubview:view];

        }
        
        [self addData];
        
    }
    return self;
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    
}


- (UIImageView*)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.image=KGetImage(@"taskBgImg");
        [self addSubview:_bgImgView];
        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(0);
            make.height.mas_equalTo(KAdaptedHeight(170));
            
        }];
    }
    return _bgImgView;
}

- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.layer.cornerRadius=KAdaptedHeight(10);
        _shadowView.layer.shadowColor = RGBA(188, 188, 188, 0.16).CGColor;
        _shadowView.layer.shadowOffset = CGSizeMake(0,0);
        _shadowView.layer.shadowOpacity = 1;
        _shadowView.layer.shadowRadius = 4;
        [self addSubview:_shadowView];
        [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(90));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedHeight(150));
            
        }];

    }
    return _shadowView;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = RGBA(255, 255, 255, 1);
//        _contentView.backgroundColor = RGBA(248, 248, 248, 0.5);
        [self addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(90));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedHeight(150));
            
        }];
        setViewCorner(_contentView, KAdaptedHeight(10));
    }
    return _contentView;
}

- (UILabel *)dayLabel{
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.text = getLanguage(@"已签到0天");
        _dayLabel.textColor = RGBA(0, 0, 0, 1);
        _dayLabel.font=KFontA(14);
        _dayLabel.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:_dayLabel];
        [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(14));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedHeight(30));

        }];
    }
    return _dayLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGBA(241, 241, 241, 1);
        [self.contentView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.dayLabel.mas_bottom).offset(KAdaptedHeight(10));
            make.leading.mas_equalTo(self.dayLabel.mas_leading);
            make.trailing.mas_equalTo(self.dayLabel.mas_trailing);
            make.height.mas_equalTo(1);
            
        }];
    }
    return _lineView;
}


- (UIView *)dayView{
    if (!_dayView) {
        _dayView = [[UIView alloc] init];
        _dayView.backgroundColor = RGBA(255, 255, 255, 1);
        [self.contentView addSubview:_dayView];
        [_dayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.lineView.mas_bottom).offset(KAdaptedHeight(10));
            make.leading.mas_equalTo(self.dayLabel.mas_leading);
            make.trailing.mas_equalTo(self.dayLabel.mas_trailing);
            make.height.mas_equalTo(KAdaptedHeight(80));
            
        }];
    }
    return _dayView;
}


- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor=RGBA(255, 255, 255, 1);
        [self addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_bottom).offset(KAdaptedHeight(15));
            make.leading.mas_equalTo(self.contentView.mas_leading);
            make.trailing.mas_equalTo(self.contentView.mas_trailing);
            make.height.mas_equalTo(KAdaptedHeight(75));
            
        }];
    }
    return _topView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = getLanguage(@"新手任务");
        _titleLabel.textColor = RGBA(0, 0, 0, 1);
        _titleLabel.font=KFontA(16);
        _titleLabel.textAlignment=NSTextAlignmentLeft;
        [self.topView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(14));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.width.mas_equalTo(KAdaptedWidth(200));
            make.height.mas_equalTo(KAdaptedHeight(30));

        }];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.text = getLanguage(@"完成所有新手任务可领取礼物哦~");
        _contentLabel.textColor = RGBA(153, 153, 153, 1);
        _contentLabel.font=KFontA(12);
        _contentLabel.textAlignment=NSTextAlignmentLeft;
        [self.topView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom);
            make.leading.mas_equalTo(self.titleLabel.mas_leading);
            make.height.mas_equalTo(self.titleLabel.mas_height);
            make.trailing.mas_equalTo(KAdaptedWidth(-80));

        }];
    }
    return _contentLabel;
}

- (UIImageView*)tipImgView{
    if (!_tipImgView) {
        _tipImgView = [[UIImageView alloc] init];
        _tipImgView.image=KGetImage(@"taskTipImg");
        [self.topView addSubview:_tipImgView];
        [_tipImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(66), KAdaptedHeight(62)));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.top.mas_equalTo(KAdaptedHeight(5));
        }];
    }
    return _tipImgView;
}

- (UIView *)lineTwoView{
    if (!_lineTwoView) {
        _lineTwoView = [[UIView alloc] init];
        _lineTwoView.backgroundColor = RGBA(241, 241, 241, 1);
        [self.topView addSubview:_lineTwoView];
        [_lineTwoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tipImgView.mas_bottom).offset(KAdaptedHeight(5));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(15));
            make.height.mas_equalTo(1);
            
        }];
    }
    return _lineTwoView;
}



-(void)addData{

    WeakSelf;
    [NetworkRequest POST:Request_SigninList parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        [wself.listArr removeAllObjects];
        wself.listArr=nil;
        [wself.listArr addObjectsFromArray:baseModel.data];
        NSInteger i=0;
        NSInteger signDay=0;
        for(EMO_SignDayView *view in self.dayView.subviews) {
            if([view isKindOfClass:[EMO_SignDayView class]]){
                NSDictionary *dic=self.listArr[i];
                view.dicData=dic;
                i++;
                if([dic[@"is_sign"] integerValue]!=0){
                    signDay++;
                }
            }
        }
        self.dayLabel.text =[NSString stringWithFormat:@"已签到%ld天",signDay];

    } failture:^(NSError *error) {
        
    }];
    
}

-(void)signData:(NSDictionary *)dic{
    [NetworkRequest POST:Request_signIn parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:baseModel.msg]];
        
        [self addData];

    } failture:^(NSError *error) {
        
    }];
    
    
}




@end
