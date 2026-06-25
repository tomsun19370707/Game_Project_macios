//
//  EMO_NobilityView.m
//  miliao
//
//  Created by ZhangShiHao on 2023/6/28.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_NobilityView.h"
#import "TYCyclePagerViewCell.h"
#import "EMO_NobilityDescriptionVC.h"//等级说明

@interface EMO_NobilityView()<UIScrollViewDelegate,TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>
Strong UIScrollView *scrollView;

Strong TYCyclePagerView *cycleView;
Strong NSMutableArray *arrData;
Strong NSMutableDictionary *dicData;
Strong UIView *topView;
Strong UIImageView *bgImgView;
Strong UIImageView *iconImgView;
Strong UILabel *titleOneLabel;
Strong UIView *progressBGView;
Strong UIView *progressView;
Strong UIButton *gradeBtn;

Strong UIView *cententView;
Strong UILabel *titleTwoLabel;

Strong UIView *bottomView;
Strong UILabel *titleThreeLabel;
Strong UILabel *contentLabel;

@end

@implementation EMO_NobilityView

-(NSMutableArray *)arrData{
    if(!_arrData){
        _arrData=[NSMutableArray array];
    }
    return _arrData;
}

-(NSMutableDictionary *)dicData{
    if(!_dicData){
        _dicData=[NSMutableDictionary dictionary];
    }
    return _dicData;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor= RGBA(248, 248, 248, 1);
        [self scrollView];
        [self topView];
        [self bgImgView];
        [self iconImgView];
        [self titleOneLabel];
        [self progressBGView];
        [self progressView];
        [self gradeBtn];
        [self cententView];
        [self titleTwoLabel];
        [self bottomView];
        [self titleThreeLabel];
        [self contentLabel];
        
        [self addData];
        
        _cycleView = [[TYCyclePagerView alloc] initWithFrame:CGRectMake(0, KAdaptedHeight(10), kWidth, KAdaptedHeight(160))];
        _cycleView.isInfiniteLoop = YES;
        _cycleView.autoScrollInterval = 0;
        _cycleView.dataSource = self;
        _cycleView.delegate = self;
        [_cycleView registerClass:[TYCyclePagerViewCell class] forCellWithReuseIdentifier:@"cellId"];
        [self.scrollView addSubview:_cycleView];
        
        //每个Item宽高
        CGFloat W = (kWidth-KAdaptedWidth(30))/4;
        CGFloat H = 100;
        //每行列数
        NSInteger rank = 4;
        //每列间距
        CGFloat rankMargin = 0;
        //每行间距
        CGFloat rowMargin = 15;
        //Item索引 ->根据需求改变索引
    //    NSUInteger index = 8;
        NSArray *titleArr=@[getLanguage(@"专属名牌"),getLanguage(@"专属礼物"),getLanguage(@"进场特效"),getLanguage(@"专属头像框"),getLanguage(@"专属坐骑"),getLanguage(@"热度加成"),getLanguage(@"防下麦"),getLanguage(@"隐身进退房")];
        
        for (int i = 0 ; i< titleArr.count; i++) {
            //Item X轴
            CGFloat X = (i % rank) * (W + rankMargin);
            //Item Y轴
            NSUInteger Y = (i / rank) * (H +rowMargin);
            //Item top
            CGFloat top = 55;
            UIButton *burtton = [UIButton buttonWithType:UIButtonTypeCustom];
            burtton.frame = CGRectMake(X, Y+top, W, H);
            [burtton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"privilegeImgG%d",i+1]] forState:UIControlStateNormal];
            [burtton setTitle:titleArr[i] forState:UIControlStateNormal];
            [burtton setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
            burtton.titleLabel.font=KFontA(12);
            
            [burtton setImagePositionWithType:SSImagePositionTypeTop spacing:3];
            burtton.userInteractionEnabled=NO;
            [self.cententView addSubview:burtton];
        }
        
        
        
    }
    return self;
}


//Assign NSInteger grade;
-(void)vcType:(NSInteger)type andData:(NSMutableArray *)arrData{
    self.arrData=arrData;
    if(type==1){
        self.cycleView.hidden=YES;
        self.topView.hidden=NO;
        NSInteger i=1;
        for (NSDictionary *dic in self.arrData) {
            if([dic[@"is_my_level"] integerValue]==1){
                self.dicData=[NSMutableDictionary dictionaryWithDictionary:dic];
                break;
            }
            i++;
        }
        CGFloat widthA=[self.dicData[@"my_exp"] floatValue]/[self.dicData[@"exp"]floatValue];
        [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(KAdaptedWidth(150)*widthA);
        }];
        
        [self upViewData:self.dicData];
    }else{
        self.cycleView.hidden=NO;
        self.topView.hidden=YES;
        [self.cycleView reloadData];
        self.cycleView.layout.layoutType=TYCyclePagerTransformLayoutLinear;
        self.cycleView.layout.itemSize=CGSizeMake(kWidth-KAdaptedWidth(50), KAdaptedHeight(150));
        self.cycleView.layout.itemSpacing=10;
        [self.cycleView setNeedUpdateLayout];
    }
    
}

-(void)upViewData:(NSDictionary *)dic{
    NSArray *arr=dic[@"peerage_benefits"];
    NSString *nameStrimg=[NSString string];
    if([dic[@"name"] isEqualToString:@"公爵"]){
        nameStrimg=@"G";
        self.titleOneLabel.text = getLanguage(@"公爵等级");
        self.titleOneLabel.textColor = RGBA(206, 60, 1, 1);
    }else if ([dic[@"name"] isEqualToString:@"伯爵"]){
        nameStrimg=@"B";
        self.titleOneLabel.text = getLanguage(@"伯爵等级");
        self.titleOneLabel.textColor = RGBA(255, 13, 187, 1);
    }else if ([dic[@"name"] isEqualToString:@"国王"]){
        nameStrimg=@"W";
        self.titleOneLabel.text = getLanguage(@"国王等级");
        self.titleOneLabel.textColor = RGBA(155, 45, 0, 1);
    }else if ([dic[@"name"] isEqualToString:@"帝王"]){
        nameStrimg=@"D";
        self.titleOneLabel.text = getLanguage(@"帝王等级");
        self.titleOneLabel.textColor = RGBA(208, 48, 219, 1);
    }else if ([dic[@"name"] isEqualToString:@"侯爵"]){
        nameStrimg=@"H";
        self.titleOneLabel.text = getLanguage(@"侯爵等级");
        self.titleOneLabel.textColor = RGBA(206, 60, 1, 1);
    }else if ([dic[@"name"] isEqualToString:@"子爵"]){
        nameStrimg=@"Z";
        self.titleOneLabel.text = getLanguage(@"子爵等级");
        self.titleOneLabel.textColor = RGBA(110, 50, 220, 1);
    }
    
    [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"bg_image"]]]placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"privilegeBGImg%@",nameStrimg]]];
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"image"]]]placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"privilegeIcomImg%@",nameStrimg]]];
    
    int i=0;
    for (UIButton *burtton in self.cententView.subviews) {
        if([burtton isKindOfClass:[UIButton class]]){
            [burtton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"privilegeImg%@%d",nameStrimg,i+1]] forState:UIControlStateNormal];
            [burtton setTitle:arr[i][@"name"] forState:UIControlStateNormal];
            i++;
        }
    }
    

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
        _scrollView.contentSize=CGSizeMake(kWidth, KAdaptedHeight(180+260+290));
        [self addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(0));
            make.width.mas_equalTo(kWidth);
            make.leading.mas_equalTo(0);
            make.bottom.mas_equalTo(0);

        }];
    }
    return _scrollView;
}

- (TYCyclePagerView *)cycleView{
    if (!_cycleView) {
        _cycleView = [[TYCyclePagerView alloc] init];
        _cycleView.isInfiniteLoop = YES;
        _cycleView.autoScrollInterval = 0;
        _cycleView.layout.layoutType=TYCyclePagerTransformLayoutLinear;
        _cycleView.layout.itemSize=CGSizeMake(kWidth-KAdaptedWidth(30), KAdaptedHeight(150));
        _cycleView.layout.itemSpacing=20;
        _cycleView.dataSource = self;
        _cycleView.delegate = self;
        [_cycleView registerClass:[TYCyclePagerViewCell class] forCellWithReuseIdentifier:@"cellId"];
        [self.scrollView addSubview:_cycleView];
        [_cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(10));
            make.leading.mas_equalTo(KAdaptedWidth(0));
            make.width.mas_equalTo(kWidth);
            make.height.mas_equalTo(KAdaptedHeight(160));
        }];
    }
    return _cycleView;
}






- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
//        _topView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(10));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.width.mas_equalTo(kWidth-KAdaptedWidth(30));
            make.height.mas_equalTo(KAdaptedHeight(160));
            
        }];
    }
    return _topView;
}

- (UIImageView*)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.image=KGetImage(@"privilegeBGImgG");
        [self.topView addSubview:_bgImgView];
        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(0);
        }];
    }
    return _bgImgView;
}

- (UIImageView*)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image=KGetImage(@"jueweiBgImg");
        [self.topView addSubview:_iconImgView];
        [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(KAdaptedWidth(0));
            make.width.height.mas_equalTo(KAdaptedWidth(100));
            make.top.mas_equalTo(KAdaptedHeight(10));
        }];
    }
    return _iconImgView;
}

- (UILabel *)titleOneLabel{
    if (!_titleOneLabel) {
        _titleOneLabel = [[UILabel alloc] init];
        _titleOneLabel.text = getLanguage(@"公爵等级");
        _titleOneLabel.textColor = RGBA(206, 60, 1, 1);
        _titleOneLabel.font=KFontA(18);
        [self.topView addSubview:_titleOneLabel];
        [_titleOneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(30));
            make.leading.mas_equalTo(KAdaptedWidth(18));
            make.width.mas_equalTo(KAdaptedWidth(120));
            make.height.mas_equalTo(KAdaptedHeight(30));
        }];
    }
    return _titleOneLabel;
}

- (UIView *)progressBGView{
    if (!_progressBGView) {
        _progressBGView = [[UIView alloc] init];
        _progressBGView.backgroundColor = [UIColor clearColor];
        _progressBGView.layer.borderColor=RGBA(230, 167, 141, 1).CGColor;
        _progressBGView.layer.borderWidth=0.5;
        _progressBGView.layer.cornerRadius=KAdaptedHeight(4);
        _progressBGView.layer.masksToBounds=YES;
        [self.topView addSubview:_progressBGView];
        [_progressBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.titleOneLabel.mas_leading);
            make.height.mas_equalTo(KAdaptedHeight(8));
            make.top.mas_equalTo(self.titleOneLabel.mas_bottom).offset(KAdaptedHeight(25));
            make.width.mas_equalTo(KAdaptedWidth(150));
        }];
    }
    return _progressBGView;
}
- (UIView *)progressView{
    if (!_progressView) {
        _progressView = [[UIView alloc] init];
        _progressView.backgroundColor = RGBA(230, 167, 141, 1);
        _progressView.layer.cornerRadius=KAdaptedHeight(4);
        _progressView.layer.masksToBounds=YES;
        [self.progressBGView addSubview:_progressView];
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.bottom.mas_equalTo(KAdaptedHeight(0));
            make.width.mas_equalTo(0);
        }];
    }
    return _progressView;
}



- (UIButton *)gradeBtn{
    if (!_gradeBtn) {
        _gradeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _gradeBtn.backgroundColor=RGBA(230, 167, 141, 1);
        [_gradeBtn setTitle:getLanguage(@"等级说明") forState:UIControlStateNormal];
        [_gradeBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _gradeBtn.titleLabel.font=KFontA(12);
        [_gradeBtn addTarget:self action:@selector(BtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:_gradeBtn];
        [_gradeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(70), KAdaptedHeight(30)));
            make.top.mas_equalTo(self.progressBGView.mas_bottom).offset(KAdaptedHeight(14));
            make.leading.mas_equalTo(self.titleOneLabel.mas_leading);
            
        }];
        setViewCorner(_gradeBtn, KAdaptedHeight(15));
    }
    return _gradeBtn;
}


- (UIView *)cententView{
    if (!_cententView) {
        _cententView = [[UIView alloc] init];
        _cententView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:_cententView];
        [_cententView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.topView.mas_bottom).offset(KAdaptedHeight(10));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.width.mas_equalTo(kWidth-KAdaptedWidth(30));
            make.height.mas_equalTo(KAdaptedHeight(250));
            
        }];
        setViewCorner(_cententView, KAdaptedHeight(10));
    }
    return _cententView;
}

- (UILabel *)titleTwoLabel{
    if (!_titleTwoLabel) {
        _titleTwoLabel = [[UILabel alloc] init];
        _titleTwoLabel.text = getLanguage(@"专属特权");
        _titleTwoLabel.textColor = RGBA(0, 0, 0, 1);
        _titleTwoLabel.font=KFontA(16);
        _titleTwoLabel.textAlignment=NSTextAlignmentCenter;
        [self.cententView addSubview:_titleTwoLabel];
        [_titleTwoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(15));
            make.centerX.mas_equalTo(KAdaptedWidth(18));
            make.width.mas_equalTo(KAdaptedWidth(120));
            make.height.mas_equalTo(KAdaptedHeight(30));
        }];
    }
    return _titleTwoLabel;
}


- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.cententView.mas_bottom).offset(KAdaptedHeight(10));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.width.mas_equalTo(kWidth-KAdaptedWidth(30));
            make.height.mas_equalTo(KAdaptedHeight(250));
            
        }];
        setViewCorner(_bottomView, KAdaptedHeight(10));
    }
    return _bottomView;
}

- (UILabel *)titleThreeLabel{
    if (!_titleThreeLabel) {
        _titleThreeLabel = [[UILabel alloc] init];
        _titleThreeLabel.text = getLanguage(@"如何提成等级");
        _titleThreeLabel.textColor = RGBA(0, 0, 0, 1);
        _titleThreeLabel.font=KFontA(16);
        _titleThreeLabel.textAlignment=NSTextAlignmentCenter;
        [self.bottomView addSubview:_titleThreeLabel];
        [_titleThreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(15));
            make.centerX.mas_equalTo(KAdaptedWidth(18));
            make.width.mas_equalTo(KAdaptedWidth(120));
            make.height.mas_equalTo(KAdaptedHeight(30));
        }];
    }
    return _titleThreeLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.text = getLanguage(@"1.消费2.做新手任务3.阿巴阿巴阿巴4.这里说的任务包括主线任务、修真任务、传奇任务等，这是最直接的升级渠道。每个不同的任务给的经验值不同，一般来说任务耗时不会太长，具体奖励的可以在“任务”界面中选定某一任务后查看。5.每个不同的任务给的经验值不同，一般来说任务耗时不会太长.");
        _contentLabel.textColor = RGBA(102, 102, 102, 1);
        _contentLabel.font=KFontA(12);
        _contentLabel.numberOfLines=0;
        _contentLabel.textAlignment=NSTextAlignmentCenter;
        [_contentLabel sizeToFit];
        [self.bottomView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleThreeLabel.mas_bottom).offset(KAdaptedHeight(15));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.bottom.mas_equalTo(KAdaptedHeight(-30));
        }];
    }
    return _contentLabel;
}

#pragma mark - TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.arrData.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    TYCyclePagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndex:index];
    cell.dicData=self.arrData[index];
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame)*0.8, CGRectGetHeight(pageView.frame)*0.8);
    layout.itemSpacing = 15;
    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    //[_pageControl setCurrentPage:newIndex animate:YES];
    NSLog(@"%ld ->  %ld",fromIndex,toIndex);
//    [self UpView:toIndex+1];
    
    [self upViewData:self.arrData[toIndex]];
}






-(void)BtnClick{
    
    EMO_NobilityDescriptionVC *vc=[EMO_NobilityDescriptionVC new];
    vc.dataArr=self.arrData;
    [[Common getCurrentVC].navigationController pushViewController:vc animated:YES];
    
    
}



-(void)addData{
    
    
        [NetworkRequest POST:Request_AppText parmeters:nil success:^(id responObject) {
            BaseModel *model=(BaseModel *)responObject;
            NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[model.data[3][@"content"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            self.contentLabel.attributedText = attrStr;
        
        } failture:^(NSError *error) {
    
        }];
    
    
    
    
}







@end
