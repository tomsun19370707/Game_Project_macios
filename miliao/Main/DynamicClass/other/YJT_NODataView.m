//
//  YJT_NODataView.m
//  MeetHer
//
//  Created by 张世浩 on 2023/4/10.
//

#import "YJT_NODataView.h"

@interface YJT_NODataView()
@property (nonatomic,strong)UIView *BGView;
@property (nonatomic,strong)UIImageView *ImageViewA;
@property (nonatomic,strong)UIButton *ContentBtn;

@end

@implementation YJT_NODataView


-(void)initView{
//    [self BGView];
    [self ImageViewA];
    [self ContentBtn];
    self.ContentBtn.hidden=YES;
    
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    
    self.ImageViewA.image=[UIImage imageNamed:dicData[@"img"]];
    [self.ContentBtn setTitle:dicData[@"tip"] forState:UIControlStateNormal];
    
    
    
}



-(UIView *)BGView{
    if (!_BGView) {
        _BGView = [[UIView alloc] init];
        _BGView.backgroundColor = kClearColor;
        [self addSubview:_BGView];
        [_BGView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.centerX.mas_equalTo(0);
            make.leading.mas_equalTo(KAdaptedWidth(80));
            make.trailing.mas_equalTo(KAdaptedWidth(-80));
            make.height.mas_equalTo(KAdaptedHeight(280));
        }];
    }
    return _BGView;
}

- (UIImageView*)ImageViewA{
    if (!_ImageViewA) {
        _ImageViewA = [[UIImageView alloc] init];
        _ImageViewA.image=KGetImage(@"noDataImg");
        [self addSubview:_ImageViewA];
        [_ImageViewA mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
//            make.bottom.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(152), KAdaptedWidth(105)));

        }];
    }
    return _ImageViewA;
}

- (UIButton *)ContentBtn{
    if (!_ContentBtn) {
        _ContentBtn = [[UIButton alloc] init];
        _ContentBtn.tag=200;
        [_ContentBtn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
        _ContentBtn.titleLabel.font=KFontBold(10);
//        _ContentBtn.backgroundColor=RGBA(254, 123, 120, 1);
        _ContentBtn.layer.cornerRadius=KAdaptedHeight(27/2);
        [self addSubview:_ContentBtn];
        [_ContentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(KAdaptedWidth(156));
            make.height.mas_equalTo(KAdaptedHeight(27));
            make.centerX.mas_equalTo(KAdaptedWidth(0));
            make.top.mas_equalTo(self.ImageViewA.mas_bottom).offset(KAdaptedWidth(20));
 
        }];
    }
    return _ContentBtn;
}

@end
