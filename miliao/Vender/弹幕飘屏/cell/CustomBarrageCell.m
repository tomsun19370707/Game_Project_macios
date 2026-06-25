//
//  CustomBarrageCell.m
//  BarrageDemo
//
//  Created by liuliang on 2019/7/28.
//  Copyright © 2019 liu. All rights reserved.
//

#import "CustomBarrageCell.h"
//#import "CustomBarrageModel.h"
#import "MLRoomMessageModel.h"
#import "UIView+LLAdd.h"
#import "NSString+LLAdd.h"
@implementation CustomBarrageCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    {
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:NSStringFormat(@"  %@",dicData[@"nickName"])];
        [one setTextHighlightRange:one.rangeOfAll
                                color:MHColorFromHexString(@"#FFD452")
                      backgroundColor:nil
                            tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
    
                            }];
        [text appendAttributedString:one];
        
    }
    if ([dicData[@"messageType"] integerValue]==7772) {
        {
            NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:getLanguage(@"在塔罗牌中抽中")];
            [one setTextHighlightRange:one.rangeOfAll
                                    color:[UIColor whiteColor]
                          backgroundColor:nil
                                tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){

                                }];
            [text appendAttributedString:one];
        }
    }else{
        {
            NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:getLanguage(@"在大胃王中获得")];
            [one setTextHighlightRange:one.rangeOfAll
                                    color:[UIColor whiteColor]
                          backgroundColor:nil
                                tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){

                                }];
            [text appendAttributedString:one];
        }
    }
    
    
    {
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:NSStringFormat(@"%@",dicData[@"coin"])];
        [one setTextHighlightRange:one.rangeOfAll
                                color:MHColorFromHexString(@"#FFD452")
                      backgroundColor:nil
                            tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){

                            }];
        [text appendAttributedString:one];
    }
    {
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:getLanguage(@"金币")];
        [one setTextHighlightRange:one.rangeOfAll
                                color:[UIColor whiteColor]
                      backgroundColor:nil
                            tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){

                            }];
        [text appendAttributedString:one];
    }
    self.contentLab.attributedText= text;
    NSString *text1=[NSString stringWithFormat:@"%@%@%@%@",dicData[@"nickName"],getLanguage(@"在塔罗牌中抽中"),dicData[@"coin"],getLanguage(@"金币")];
    CGFloat contentWidth = [text1 widthForFont:KFont(12)];
    self.bgBlackView.frame = CGRectMake(0, 4.0, 130.0 + contentWidth, 50.0);
    self.contentLab.frame = CGRectMake(55.0, 8, 55.0+contentWidth, 50.0);
    self.contentView.size =  CGSizeMake(130.0 + contentWidth, 60.0);
    self.bgIconImgView.frame=self.contentView.frame;

[self.iconImgView sd_setImageWithURL:[NSURL URLWithString:@""]];


    
    
}

- (void)setModel:(MLRoomMessageModel *)model{
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    {
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:NSStringFormat(@"  %@",model.nickName)];
        [one setTextHighlightRange:one.rangeOfAll
                                color:RGBA(217, 91, 22, 1)
                      backgroundColor:nil
                            tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
    
                            }];
        [text appendAttributedString:one];
        
    }
    {
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:NSStringFormat(@" 送给")];
        [one setTextHighlightRange:one.rangeOfAll
                                color:RGBA(217, 91, 22, 1)
                      backgroundColor:nil
                            tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){

                            }];
        [text appendAttributedString:one];
    }
    {
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:NSStringFormat(@" %@",model.toNickName)];
        [one setTextHighlightRange:one.rangeOfAll
                                color:RGBA(217, 91, 22, 1)
                      backgroundColor:nil
                            tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){

                            }];
        [text appendAttributedString:one];
    }
    {
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:NSStringFormat(@" %@个",model.giftNum)];
        [one setTextHighlightRange:one.rangeOfAll
                                color:RGBA(217, 91, 22, 1)
                      backgroundColor:nil
                            tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){

                            }];
        [text appendAttributedString:one];
    }
    {
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:NSStringFormat(@"%@",model.gift_name)];
        [one setTextHighlightRange:one.rangeOfAll
                                color:RGBA(217, 91, 22, 1)
                      backgroundColor:nil
                            tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){

                            }];
        [text appendAttributedString:one];
    }
//        self.contentLab.attributedText= text;
    
    
    NSString *text1=[NSString stringWithFormat:@"%@ 抽中 %@*%@",model.nickName,model.gift_name,model.giftNum];
        CGFloat contentWidth = [text1 widthForFont:KFont(12)];
    self.contentLab.text = text1 ;
    self.contentLab.textColor = RGB(217, 91, 25);
    
        self.bgBlackView.frame = CGRectMake(0, 4.0, 130.0 + contentWidth, 50.0);
//        self.contentLab.frame = CGRectMake(55.0, 8, 55.0+contentWidth, 50.0);
    self.contentLab.frame = CGRectMake(55.0, 30, 55.0+contentWidth, 30.0);
        self.contentView.size =  CGSizeMake(130.0 + contentWidth, 60.0);
//        self.bgIconImgView.frame=self.contentView.frame;
    self.bgIconImgView.frame=CGRectMake(0, self.contentView.size.height-30, self.contentView.size.width, 30);
    
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:model.show_img]];
    
    
    
    
    
}

//- (void)setModel:(CustomBarrageModel *)model{
//    _model = model;
//    self.contentLab.text= model.content;
//    CGFloat contentWidth = [model.content widthForFont:self.contentLab.font];
//    self.bgBlackView.frame = CGRectMake(0, 4.0, 35.0 + contentWidth, 24.0);
//    self.contentLab.frame = CGRectMake(26.0, 0, contentWidth, 24.0);
//    self.contentView.size =  CGSizeMake(35.0 + contentWidth, 32.0);
//    self.bgIconImgView.frame=self.contentView.frame;
//}

- (void)configUI{
    [self.contentView addSubview:self.bgBlackView];
    [self.bgBlackView addSubview:self.bgIconImgView];
    [self.bgBlackView addSubview:self.iconImgView];
    [self.bgBlackView addSubview:self.contentLab];
    self.iconImgView.frame = CGRectMake(3.0, 2.0, 50.0, 50.0);
    [self.iconImgView clipAllRoundCorner:10.0];
   
}

- (UIImageView *)iconImgView{
    if(!_iconImgView){
        UIImageView *imgView = [UIImageView new];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = [UIImage imageNamed:@"未加载图片"];
        _iconImgView = imgView;
    }
    return _iconImgView;
}

- (UILabel *)contentLab{
    if(!_contentLab){
        UILabel *lab = [UILabel new];
        lab.textColor = [UIColor whiteColor];
        lab.font = KFont(12);
        _contentLab = lab;
    }
    return _contentLab;
}


- (UIImageView *)bgIconImgView{
    if(!_bgIconImgView){
        UIImageView *imgView = [UIImageView new];
        imgView.contentMode = UIViewContentModeScaleToFill;
        imgView.image = [UIImage imageNamed:@"giftBgFourImg"];
        _bgIconImgView = imgView;
    }
    return _bgIconImgView;
}

- (UIView *)bgBlackView{
    if(!_bgBlackView){
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        view.layer.cornerRadius = 13.0;
        _bgBlackView = view;
        
    }
    return _bgBlackView;
}


@end
