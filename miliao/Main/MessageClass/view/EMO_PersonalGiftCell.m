//
//  EMO_PersonalGiftCell.m
//  miliao
//
//  Created by ZhangShiHao on 2023/6/26.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_PersonalGiftCell.h"
#import "EMO_PersonalGiftView.h"


@interface EMO_PersonalGiftCell()

//Strong UIButton *giftBtn;

Strong EMO_PersonalGiftView *giftView;


@end

@implementation EMO_PersonalGiftCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
//        [self giftBtn];
     
       
        
        
    }
    return self;
}

-(void)setArrData:(NSArray *)arrData{
    _arrData=arrData;
    
    
    //每个Item宽高
    CGFloat W = KAdaptedWidth(80);
    CGFloat H = KAdaptedHeight(95);
    //每行列数
    NSInteger rank = 4;
    //每列间距
    CGFloat rankMargin = 10;
    //每行间距
    CGFloat rowMargin = 10;
    //Item索引 ->根据需求改变索引
    NSUInteger index = arrData.count>4?4:arrData.count;
    for (int i = 0 ; i< index; i++) {
        //Item X轴
        CGFloat X = (i % rank) * (W + rankMargin);
        //Item Y轴
        NSUInteger Y = (i / rank) * (H +rowMargin);
        //Item top
        CGFloat top = 10;
        
        EMO_PersonalGiftView *view=[[EMO_PersonalGiftView alloc] init];
        view.frame= CGRectMake(X, Y+top, W, H);
        view.dicData=arrData[i];
        [self addSubview:view];
        

    }
    
    
    
    
    
    
    
    
    
    
    
}













//- (UIButton *)giftBtn{
//    if (!_giftBtn) {
//        _giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_giftBtn setTitle:@"魅力等级\n56" forState:UIControlStateNormal];
//        [_giftBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
//        _giftBtn.titleLabel.font=KFontA(13);
//        [_giftBtn setImage:[UIImage imageNamed:@"level4Img"] forState:UIControlStateNormal];
//        [self.contentView addSubview:_giftBtn];
//        [_giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(KAdaptedHeight(0));
//            make.leading.mas_equalTo(KAdaptedWidth(24));
//            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(35), KAdaptedHeight(85)));
//        }];
//        [_giftBtn setImagePositionWithType:SSImagePositionTypeTop spacing:6];
//    }
//    return _giftBtn;
//}


@end
