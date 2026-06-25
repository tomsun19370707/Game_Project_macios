//
//  EMO_ChatCollectionHeadView.m
//  miliao
//
//  Created by 张世浩 on 2022/10/12.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_ChatCollectionHeadView.h"


@interface EMO_ChatCollectionHeadView()<SDCycleScrollViewDelegate>
@property(nonatomic,strong) SDCycleScrollView *cycleScrollView;


@end

@implementation EMO_ChatCollectionHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}



-(void)initView{
   
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(KAdaptedWidth(10), KAdaptedHeight(0), ScreenWidth-KAdaptedWidth(20),KAdaptedHeight(120)) delegate:self placeholderImage:nil];
    _cycleScrollView.autoScrollTimeInterval = 5;
    _cycleScrollView.backgroundColor=kClearColor;
    [self addSubview:_cycleScrollView];
    setViewCorner(_cycleScrollView, KAdaptedHeight(10));
    
    self.cycleScrollView.hidden=YES;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
//    self.sureClickBlock ? : self.sureClickBlock(index);
    if(self.sureClickBlock){
        self.sureClickBlock(index);
    }
}

#pragma mark - Setter Getter Methods
- (void)setShufflingArray:(NSMutableArray *)shufflingArray{
    _shufflingArray = shufflingArray;
    self.cycleScrollView.hidden=NO;
    NSMutableArray *arr = [NSMutableArray array];
    [shufflingArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arr addObject:obj];
    }];

    self.cycleScrollView.imageURLStringsGroup = arr;
}

-(void)setTitleArray:(NSMutableArray *)titleArray{
    _titleArray=titleArray;
    
    for (int i=0; i<titleArray.count; i++) {
        UIButton *btn=[[UIButton alloc] init];
        if(i==0){
            btn.backgroundColor=RGBA(255, 255, 255, 0.4);
            btn.selected=YES;
        }else{
            btn.backgroundColor=RGBA(255, 255, 255, 0);
        }
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
        [btn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateSelected];
        btn.titleLabel.font=KFont(13);
        btn.layer.cornerRadius=KAdaptedHeight(11);
        btn.layer.masksToBounds=YES;
        btn.tag=1000+i;
        [btn addTarget:self action:@selector(btnCLick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo([Common getStringWidthWithText:titleArray[i] font:KFont(13) viewHeight:KAdaptedHeight(22)]);
            make.width.mas_equalTo(KAdaptedWidth(60));
            make.height.mas_equalTo(KAdaptedHeight(22));
            make.leading.mas_equalTo(KAdaptedWidth(0)+KAdaptedWidth((60+10)*i));
            make.top.mas_equalTo(KAdaptedHeight(10));
        }];
        
    }

}



-(void)btnCLick:(UIButton *)sender{
    for (UIButton *senderBtn in self.subviews) {
        if([senderBtn isKindOfClass:[UIButton class]]){
            if(sender.tag==senderBtn.tag){
                sender.selected=YES;
                sender.backgroundColor=RGBA(255, 255, 255, 0.4);
            }else{
                senderBtn.selected=NO;
                senderBtn.backgroundColor=RGBA(255, 255, 255, 0);
            }
            if(self.BtnClickBlock){
                self.BtnClickBlock(sender.tag);
            }
        }
    }
    
    
    
    
    
}






@end
