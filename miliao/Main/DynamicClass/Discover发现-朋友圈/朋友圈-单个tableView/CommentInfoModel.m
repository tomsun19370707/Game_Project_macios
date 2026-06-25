//
//  CommentInfoModel.m
//  WeChat
//
//  Created by zhengwenming on 2017/9/21.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import "CommentInfoModel.h"

#define kGAP 14
#define kAvatar_Size 60

@implementation CommentInfoModel
-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
//        self.commenttype          = dic[@"commenttype"];
        self.commentId          = dic[@"id"];
        self.life_id      = dic[@"life_id"];
        self.user_id    = dic[@"user_id"];
        self.nick_name        = dic[@"nick_name"];
//        self.commentPhoto       = dic[@"commentPhoto"];
        self.comment_text        = dic[@"comment_text"];
//        self.commentByUserId    = dic[@"commentByUserId"];
//        self.commentByUserName  = dic[@"commentByUserName"];
//        self.commentByPhoto     = dic[@"commentByPhoto"];
        self.createtime_text      = dic[@"createtime_text"];
        self.createtime      = dic[@"createtime"];
        self.checkStatus        = dic[@"checkStatus"];
        self.user        = dic[@"user"];


        
        
        
        //开始提前计算rowHeight和attributedText
        NSString *str  = nil;
        NSString *nickName=[Common isNull:self.nick_name];
        if (![nickName isEqualToString:@""]) {
            str= [NSString stringWithFormat:@"%@回复%@：%@",
                  nickName, nickName, self.comment_text];
        }else{
            str= [NSString stringWithFormat:@"%@：%@",
                  nickName, self.comment_text];
        }
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
        [text addAttribute:NSForegroundColorAttributeName
                     value:[UIColor orangeColor]
                     range:NSMakeRange(0, nickName.length)];
        [text addAttribute:NSForegroundColorAttributeName
                     value:[UIColor orangeColor]
                     range:NSMakeRange(nickName.length + 2, nickName.length)];
        UIFont *font = [UIFont systemFontOfSize:13.0];
        [text addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, str.length)];
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        if ([text.string isMoreThanOneLineWithSize:CGSizeMake(kScreenWidth - 2*kGAP-kAvatar_Size-10, CGFLOAT_MAX) font:font lineSpaceing:3.0]) {//margin
            style.lineSpacing = 3;
        }else{
            style.lineSpacing = CGFLOAT_MIN;
        }

        [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.string.length)];
        self.rowHeight = [text.string boundingRectWithSize:CGSizeMake(kScreenWidth - 2*kGAP-kAvatar_Size-10, CGFLOAT_MAX) font:font lineSpacing:3.0].height+0.5+3.0;//5.0为最后一行行间距
        self.attributedText = text;
    }
    return self;
}

- (NSMutableArray *)commentModelArray {
    if (_commentModelArray == nil) {
        _commentModelArray = [[NSMutableArray alloc] init];
    }
    return _commentModelArray;
}
-(NSMutableArray *)messageBigPics{
    if (_messageBigPicArray==nil) {
        _messageBigPicArray = [NSMutableArray array];
    }
    return _messageBigPicArray;
}

@end
