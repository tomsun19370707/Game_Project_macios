//
//  EMO_APPCustomMessageCell.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/29.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_APPCustomMessageCell.h"
#import "EMO_APPCustomMessage.h"


@interface EMO_APPCustomMessageCell ()
Strong UIImageView *headImgView;
Strong UILabel *titleLabel1;
Strong UIImageView *iconImgView;
Strong UILabel *IDLabel;


@property (nonatomic,assign)BOOL sendMe;

@end

@implementation EMO_APPCustomMessageCell

+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {
    
    return CGSizeMake(kWidth, KAdaptedHeight(140));
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self showBubbleBackgroundView:YES];

        [self headImgView];
        [self titleLabel1];
        [self iconImgView];
        [self IDLabel];
        
//        [self IconImageView];
//        [self seeGiftBtn];
//        [self nameLabel];
        

    }
    return self;
}


- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    EMO_APPCustomMessage *MessageModel = (EMO_APPCustomMessage *)self.model.content;
    
    
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",MessageModel.familyImage]] placeholderImage:KGetImage(@"未加载头像")];
    self.IDLabel.text=[NSString stringWithFormat:@"ID:%@",MessageModel.familyId];
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",MessageModel.familyLevel]] placeholderImage:KGetImage(@"familyGradeImg1")];
   
    
    self.titleLabel1.text = [NSString stringWithFormat:@"%@  ",MessageModel.familyName];
    CGSize textWidth = [self.titleLabel1.text sizeWithFont:KFont(15) maxSize:CGSizeMake(kWidth-KAdaptedWidth(100), CGFLOAT_MAX)];
    [self.titleLabel1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(textWidth.width+5);

    }];
    [self.titleLabel1 layoutIfNeeded];
    
    
    
    CGSize textLabelSize = [[self class] getTextLabelSize:self.titleLabel1.text];
    CGSize bubbleBackgroundViewSize = [[self class] getBubbleSize:CGSizeMake(textLabelSize.width+KAdaptedWidth(165), KAdaptedHeight(70))];
    self.messageContentView.contentSize = bubbleBackgroundViewSize;


    
    
}

- (UIImageView*)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        _headImgView.image=KGetImage(@"未加载头像");
        _headImgView.layer.borderColor=kWhiteColor.CGColor;
        _headImgView.layer.borderWidth=1;
        _headImgView.layer.cornerRadius=KAdaptedWidth(50)/2;
        _headImgView.layer.masksToBounds=YES;
        [self.messageContentView addSubview:_headImgView];
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(50), KAdaptedWidth(50)));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.centerY.mas_equalTo(KAdaptedHeight(-0));
        }];
    }
    return _headImgView;
}


- (UILabel *)titleLabel1{
    if (!_titleLabel1) {
        _titleLabel1 = [[UILabel alloc] init];
        _titleLabel1.text = getLanguage(@"昵称");
        _titleLabel1.textColor = RGBA(0, 0, 0, 1);
        _titleLabel1.font=KFont(15);
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_titleLabel1.text];
//        NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
//        attchment.bounds=CGRectMake(5,-2,67,20);//设置frame
//            attchment.image=[UIImage imageNamed:@"familyGradeImg1"];//设置图片
//        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(attchment)];
//        [attributedString appendAttributedString:string]; //添加到尾部
//        _titleLabel1.attributedText = attributedString;
        [self.messageContentView addSubview:_titleLabel1];
        [_titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.headImgView.mas_centerY);
            make.height.mas_equalTo(KAdaptedHeight(20));
            make.leading.mas_equalTo(self.headImgView.mas_trailing).offset(KAdaptedWidth(15));
            make.width.mas_equalTo(KAdaptedWidth(50));
            
        }];
    }
    return _titleLabel1;
}

- (UIImageView*)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image=KGetImage(@"familyGradeImg1");
        [self.messageContentView addSubview:_iconImgView];
        [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.titleLabel1.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(65), KAdaptedWidth(20)));
            make.leading.mas_equalTo(self.titleLabel1.mas_trailing).offset(KAdaptedWidth(5));
            
        }];
    }
    return _iconImgView;
}


- (UILabel *)IDLabel{
    if (!_IDLabel) {
        _IDLabel = [[UILabel alloc] init];
        _IDLabel.text = getLanguage(@"ID：0");
        _IDLabel.textColor = RGBA(153, 153, 153, 1);
        _IDLabel.font=KFont(13);
        [self.messageContentView addSubview:_IDLabel];
        [_IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel1.mas_bottom).offset(KAdaptedHeight(0));
            make.height.mas_equalTo(KAdaptedHeight(20));
            make.leading.mas_equalTo(self.titleLabel1.mas_leading).offset(KAdaptedWidth(0));
            make.trailing.mas_equalTo(self.messageContentView.mas_trailing);
            
            
        }];
    }
    return _IDLabel;
}



-(void)CheckClick:(UIButton *)sender{
    NSLog(@"查看礼物:%ld",(long)sender.tag);
  
    
}



//+ (CGSize)getTextLabelSize:(YJRGiftMessage *)message {
+ (CGSize)getTextLabelSize:(NSString *)message {
    if (message.length > 0) {
        CGRect textRect = [message
            boundingRectWithSize:CGSizeMake([RCMessageCellTool getMessageContentViewMaxWidth], 8000)
                         options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin |
                                  NSStringDrawingUsesFontLeading)
                      attributes:@{
                          NSFontAttributeName :KFont(13)
                      }
                         context:nil];
        textRect.size.height = ceilf(textRect.size.height);
        textRect.size.width = ceilf(textRect.size.width);
        return CGSizeMake(textRect.size.width + 5, textRect.size.height + 5);
    } else {
        return CGSizeZero;
    }
}


+ (CGSize)getBubbleSize:(CGSize)textLabelSize {
    CGSize bubbleSize = CGSizeMake(textLabelSize.width, textLabelSize.height);

    if (bubbleSize.width + 12 + 12 > 50) {
        bubbleSize.width = bubbleSize.width + 12 + 12;
    } else {
        bubbleSize.width = 50;
    }
    if (bubbleSize.height + 7 + 7 > 40) {
        bubbleSize.height = bubbleSize.height + 7 + 7;
    } else {
        bubbleSize.height = 40;
    }

    return bubbleSize;
}









@end
