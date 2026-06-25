//
//  EMO_HomeHeadView.m
//  miliao
//
//  Created by 张世浩 on 2023/6/16.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_HomeHeadView.h"
#import "UUMarqueeView.h"
#import "EMO_HomeLoopView.h"

@interface EMO_HomeHeadView()<SDCycleScrollViewDelegate,UUMarqueeViewDelegate>

Strong UIImageView *bgImgView;
Strong UIImageView *titleImg;
Strong UIView *searchBgView;
Strong UIButton *searchBtn;

Strong SDCycleScrollView *cycleScrollView;

Strong UIImageView *friendImgView;
Strong UIImageView *womanImgView;
Strong UIImageView *manhImgView;
Strong UIImageView *allroomImgView;

Strong UIImageView *titleIconImg;
Strong UIImageView *titleLabelImg;
//
Strong NSArray *scycleArr;
//Strong NSArray *scrollerArr;

@property (nonatomic, strong) UUMarqueeView *homeLoopView;
@property (nonatomic, strong) NSArray *upwardMultiMarqueeViewData;

@end

@implementation EMO_HomeHeadView

-(NSArray *)scycleArr{
    if(!_scycleArr){
        _scycleArr=[NSArray array];
    }
    return _scycleArr;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor=RGBA(255, 255, 248, 1);
        [self bgImgView];
        [self titleImg];
        [self searchBgView];
        [self searchBtn];
        [self cycleScrollView];
        [self friendImgView];
        [self womanImgView];
        [self manhImgView];
        [self allroomImgView];
        [self titleIconImg];
        [self titleLabelImg];
        
        [self addData:YES];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationConfession) name:@"UpHomeData" object:nil];
       
        
    }
    return self;
}

-(void)InfoNotificationConfession{
    [self addData:NO];
}

-(void)addData:(BOOL)fresh{
    WeakSelf;
    [NetworkRequest POST:Request_GetBanner parmeters:@{@"type":@"0"} success:^(id responObject) {
        BaseModel *baseModel=(BaseModel *)responObject;
        self.scycleArr=baseModel.data;
        NSMutableArray *titleArr=[NSMutableArray array];
        for (NSDictionary *dic in baseModel.data) {
            [titleArr addObject:dic[@"image"]];
        }
        if(titleArr.count>0){
            self.cycleScrollView.imageURLStringsGroup=titleArr;
            [wself.cycleScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(350), KAdaptedHeight(150)));
            }];
            self.height = KAdaptedHeight(600);
        }else{
            [wself.cycleScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(350), KAdaptedHeight(0)));
            }];
            self.height = KAdaptedHeight(450);
        }
    } failture:^(NSError *error) {
        
    }];
    
    
    [NetworkRequest POST:Request_GetHomeRoll parmeters:nil success:^(id responObject) {
        BaseModel *baseModel=(BaseModel *)responObject;
        
        self.upwardMultiMarqueeViewData=baseModel.data;

        if(fresh){
            [self.homeLoopView start];
        }
     [self.homeLoopView reloadData];
    } failture:^(NSError *error) {
        
    }];
}



- (UIImageView*)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.image=KGetImage(@"mineHeadBgImg");
        [self addSubview:_bgImgView];
        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.height.mas_equalTo(KAdaptedHeight(200));
            
        }];
    }
    return _bgImgView;
}

- (UIImageView*)titleImg{
    if (!_titleImg) {
        _titleImg = [[UIImageView alloc] init];
        _titleImg.image=KGetImage(@"homeTitleImg");
        [self addSubview:_titleImg];
        [_titleImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ZJTopNavH);
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.width.mas_equalTo(KAdaptedWidth(50));
            make.height.mas_equalTo(KAdaptedHeight(25));
            
        }];
    }
    return _titleImg;
}

- (UIView *)searchBgView{
    if (!_searchBgView) {
        _searchBgView = [[UIView alloc] init];
        _searchBgView.backgroundColor=RGBA(255, 255, 255, 0.35);
        _searchBgView.layer.cornerRadius=KAdaptedHeight(15);
        _searchBgView.layer.masksToBounds=YES;
        [self addSubview:_searchBgView];
        [_searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.titleImg.mas_trailing).offset(KAdaptedWidth(12));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.top.mas_equalTo(self.titleImg.mas_top);
            make.height.mas_equalTo(KAdaptedHeight(30));
        }];
    }
    return _searchBgView;
}



- (UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_searchBtn setTitle:getLanguage(@"昵称/ID/房间") forState:UIControlStateNormal];
        [_searchBtn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
        _searchBtn.titleLabel.font=KFont(13);
        [_searchBtn setImage:[UIImage imageNamed:@"homeSearchImg"] forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(Btnclick:) forControlEvents:UIControlEventTouchUpInside];
        _searchBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        _searchBtn.tag=100;
        [self.searchBgView addSubview:_searchBtn];
        [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.trailing.mas_equalTo(0);
            make.leading.mas_equalTo(KAdaptedWidth(14));
            
        }];
        [_searchBtn setImagePositionWithType:SSImagePositionTypeLeft spacing:5];
    }
    return _searchBtn;
}


-(SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:nil];
        _cycleScrollView.autoScrollTimeInterval = 5;
        _cycleScrollView.tag=200;
        _cycleScrollView.showPageControl=YES;
        _cycleScrollView.backgroundColor=kClearColor;
        _cycleScrollView.placeholderImage=KGetImage(@"未加载图片");
        [self addSubview:_cycleScrollView];
        [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleImg.mas_bottom).offset(KAdaptedHeight(15));
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(350), KAdaptedHeight(150)));
            make.centerX.mas_equalTo(KAdaptedWidth(0));
        }];
        setViewCorner(_cycleScrollView, 10);
    }
    
    return _cycleScrollView;
}


- (UIImageView*)friendImgView{
    if (!_friendImgView) {
        _friendImgView = [[UIImageView alloc] init];
        _friendImgView.image=KGetImage(@"homeFriendImg");
        _friendImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(concernAction:)];
        _friendImgView.tag=1000;
        [_friendImgView addGestureRecognizer:tap];
        [self addSubview:_friendImgView];
        [_friendImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.cycleScrollView.mas_bottom).offset(KAdaptedHeight(15));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.width.mas_equalTo(KAdaptedWidth(170));
            make.height.mas_equalTo(KAdaptedHeight(140));
            
        }];
    }
    return _friendImgView;
}

- (UIImageView*)womanImgView{
    if (!_womanImgView) {
        _womanImgView = [[UIImageView alloc] init];
        _womanImgView.image=KGetImage(@"homeWomanImg");
        _womanImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(concernAction:)];
        _womanImgView.tag=2000;
        [_womanImgView addGestureRecognizer:tap];
        [self addSubview:_womanImgView];
        [_womanImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.friendImgView.mas_top).offset(KAdaptedHeight(0));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.width.mas_equalTo(KAdaptedWidth(170));
            make.height.mas_equalTo(KAdaptedHeight(120));
            
        }];
    }
    return _womanImgView;
}

- (UIImageView*)manhImgView{
    if (!_manhImgView) {
        _manhImgView = [[UIImageView alloc] init];
        _manhImgView.image=KGetImage(@"homeManImg");
        _manhImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(concernAction:)];
        _manhImgView.tag=3000;
        [_manhImgView addGestureRecognizer:tap];
        [self addSubview:_manhImgView];
        [_manhImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.friendImgView.mas_bottom).offset(KAdaptedHeight(0));
            make.leading.mas_equalTo(self.friendImgView.mas_leading);
            make.width.mas_equalTo(self.friendImgView.mas_width);
            make.height.mas_equalTo(self.womanImgView.mas_height);
            
        }];
    }
    return _manhImgView;
}

- (UIImageView*)allroomImgView{
    if (!_allroomImgView) {
        _allroomImgView = [[UIImageView alloc] init];
        _allroomImgView.image=KGetImage(@"homeAllRoomImg");
        _allroomImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(concernAction:)];
        _allroomImgView.tag=4000;
        [_allroomImgView addGestureRecognizer:tap];
        [self addSubview:_allroomImgView];
        [_allroomImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.womanImgView.mas_bottom).offset(KAdaptedHeight(0));
            make.trailing.mas_equalTo(self.womanImgView.mas_trailing);
            make.width.mas_equalTo(self.womanImgView.mas_width);
            make.height.mas_equalTo(self.friendImgView.mas_height);
            
        }];
    }
    return _allroomImgView;
}


- (UIImageView*)titleIconImg{
    if (!_titleIconImg) {
        _titleIconImg = [[UIImageView alloc] init];
        _titleIconImg.image=KGetImage(@"homeTipIconImg");
        [self addSubview:_titleIconImg];
        [_titleIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.manhImgView.mas_bottom).offset(KAdaptedHeight(11));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.width.height.mas_equalTo(KAdaptedWidth(20));
            
        }];
    }
    return _titleIconImg;
}

- (UIImageView*)titleLabelImg{
    if (!_titleLabelImg) {
        _titleLabelImg = [[UIImageView alloc] init];
        _titleLabelImg.image=KGetImage(@"homeTipImg");
        [self addSubview:_titleLabelImg];
        [_titleLabelImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.titleIconImg.mas_centerY).offset(KAdaptedHeight(0));
            make.leading.mas_equalTo(self.titleIconImg.mas_trailing).offset(KAdaptedWidth(8));
            make.width.mas_equalTo(KAdaptedWidth(32));
            make.height.mas_equalTo(KAdaptedHeight(16));
        }];
    }
    return _titleLabelImg;
}



-(UUMarqueeView *)homeLoopView{
    if (!_homeLoopView) {
        _homeLoopView= [[UUMarqueeView alloc] init];
        _homeLoopView.backgroundColor=kWhiteColor;
        _homeLoopView.delegate = self;
        _homeLoopView.timeIntervalPerScroll = 2.0f;//滚动间隔
        _homeLoopView.timeDurationPerScroll = 0.5f;//滚动速度
        _homeLoopView.touchEnabled = YES;
        [_homeLoopView reloadData];
//        _homeLoopView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1].CGColor;
//        _homeLoopView.layer.shadowOffset = CGSizeMake(0,0);
//        _homeLoopView.layer.shadowOpacity = 1;
//        _homeLoopView.layer.shadowRadius = KAdaptedHeight(10);
        _homeLoopView.layer.cornerRadius = KAdaptedHeight(10);
        _homeLoopView.layer.masksToBounds=YES;
        [self addSubview:self.homeLoopView];
        
        [_homeLoopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleIconImg.mas_bottom).offset(KAdaptedHeight(10));
            make.leading.mas_equalTo(KAdaptedWidth(0));
            make.trailing.mas_equalTo(KAdaptedWidth(-0));
            make.height.mas_equalTo(KAdaptedHeight(50));
        }];
        
        
    }
    return _homeLoopView;

}




-(void)Btnclick:(UIButton *)sender{
    
    if(self.SenderBlock){
        self.SenderBlock(sender.tag);
    }

}

-(void)concernAction:(UITapGestureRecognizer *)tapView{
    
    if(self.SenderBlock){
        self.SenderBlock(tapView.view.tag);
    }
    
}


- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    NSLog(@"AAA=%ld",index);
    EMO_WebViewController *vc=[EMO_WebViewController new];
    NSDictionary *dic= self.scycleArr[index];
    vc.titleType=getLanguage(@"详情");
    vc.strUrl=dic[@"url"];
    [[Common getCurrentVC].navigationController pushViewController:vc animated:YES];
    
    
}


#pragma mark - UUMarqueeViewDelegate
- (NSUInteger)numberOfVisibleItemsForMarqueeView:(UUMarqueeView*)marqueeView {
    return 1;
}

- (NSUInteger)numberOfDataForMarqueeView:(UUMarqueeView*)marqueeView {
    return _upwardMultiMarqueeViewData ? _upwardMultiMarqueeViewData.count : 0;

}

- (void)createItemView:(UIView*)itemView forMarqueeView:(UUMarqueeView*)marqueeView {
    
    EMO_HomeLoopView *view=[[EMO_HomeLoopView alloc] init];
    view.tag=1000;
    view.layer.shadowColor = RGBA(162, 162, 162, 0.16).CGColor;
    view.layer.shadowOffset = CGSizeMake(0,0);
    view.layer.shadowOpacity = 1;
    view.layer.shadowRadius = 3;
    [itemView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KAdaptedWidth(15));
        make.trailing.mas_equalTo(KAdaptedWidth(-15));
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        
    }];
//        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, (CGRectGetHeight(itemView.bounds) - 45.0f) / 2.0f, 45.0f, 45.0f)];
//        icon.tag = 1003;
//        icon.layer.cornerRadius=22;
//        icon.clipsToBounds=YES;
//        [itemView addSubview:icon];
//
//         UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(20.0f + 45.0f, 0.0f, CGRectGetWidth(itemView.bounds) - 20.0f - 45.0f-90, CGRectGetHeight(itemView.bounds))];
//
//        content.font = [UIFont systemFontOfSize:15.0f];
//        content.tag = 1001;
//        content.numberOfLines=0;
//        [itemView addSubview:content];
   
}

- (void)updateItemView:(UIView*)itemView atIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {

       
    NSDictionary *dicData=_upwardMultiMarqueeViewData[index];
    
    EMO_HomeLoopView *view= [itemView viewWithTag:1000];
    view.dicData=dicData;
    
    
//    UILabel *content = [itemView viewWithTag:1001];
//    NSString *tonickName=[NSString stringWithFormat:@"%@",dicData[@"toname1"]];
//    content.text =[NSString stringWithFormat:@"%@成为%@的守护之星",dicData[@"name1"],tonickName];
//    NSMutableAttributedString *attributedString=[[NSMutableAttributedString alloc] initWithString:content.text];
//    [attributedString addAttribute:NSForegroundColorAttributeName value:RGBA(255, 36, 62, 1) range:NSMakeRange(0,4)];
//    [attributedString addAttribute:NSForegroundColorAttributeName value:RGBA(34, 34, 34, 1) range:NSMakeRange(4,2)];
//    [attributedString addAttribute:NSForegroundColorAttributeName value:RGBA(255, 36, 62, 1) range:NSMakeRange(6,tonickName.length)];
//    [attributedString addAttribute:NSForegroundColorAttributeName value:RGBA(34, 34, 34, 1) range:NSMakeRange(content.text.length-5,5)];
//    content.attributedText=attributedString;
//        UIImageView *icon = [itemView viewWithTag:1003];
//        [icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"headimg1"]]] placeholderImage:KGetImage(@"未加载头像")];
    

  
}

- (void)didTouchItemViewAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
    NSLog(@"Touch at index %lu - \"%@\"", (unsigned long)index, [_upwardMultiMarqueeViewData[index] objectForKey:@"content"]);
        NSLog(@"%@",_upwardMultiMarqueeViewData[index]);
    
//    if (self.selectLoopBlock) {
//        self.selectLoopBlock(_upwardMultiMarqueeViewData[index]);
//    }

}





@end
