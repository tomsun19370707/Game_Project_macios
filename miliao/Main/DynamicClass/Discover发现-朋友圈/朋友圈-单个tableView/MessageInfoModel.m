//
//  MessageInfoModel.m
//  MeetHer
//
//  Created by 张世浩 on 2023/3/6.
//

#import "MessageInfoModel.h"
#define kGAP 14
#define kAvatar_Size 60

@implementation MessageInfoModel


-(NSMutableArray *)image_arr{
    if (_image_arr==nil) {
        _image_arr = [NSMutableArray array];
    }
    return _image_arr;
}


-(Layout *)textLayout{
    if (_textLayout==nil) {
        _textLayout = [Layout new];
    }
    return _textLayout;
}
-(Layout *)jggLayout{
    if (_jggLayout==nil) {
        _jggLayout = [Layout new];
    }
    return _jggLayout;
}
-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {

        self.message_id     = dic[@"id"];
        self.uid              = dic[@"uid"];
        self.content         = dic[@"content"];
        self.topic_id        = dic[@"topic_id"];
        self.images          = dic[@"images"];
        self.collect_num    = [dic[@"collect_num"] integerValue];
        self.like_num        = [dic[@"like_num"] integerValue];
        self.comment_num   =[dic[@"comment_num"]integerValue];
        self.topic_list     = dic[@"topic_list"];
        self.image_arr      = dic[@"image_arr"];
        self.is_collect     = [dic[@"is_collect"] boolValue];
        self.is_attention   = [dic[@"is_attention"] boolValue];
        self.is_my_dynamic  = [dic[@"is_my_dynamic"] boolValue];
        self.is_like         = [dic[@"is_like"] boolValue];
        self.updatetime         = dic[@"updatetime"];
        self.createtime         = dic[@"createtime"];
        self.createtime_text   = dic[@"createtime_text"];
        self.updatetime_text   = dic[@"updatetime_text"];
        self.type             = dic[@"type"];
        self.user             = dic[@"user"];

        NSMutableParagraphStyle *muStyle = [[NSMutableParagraphStyle alloc]init];
        muStyle.alignment = NSTextAlignmentLeft;//对齐方式
        NSString *contentText=[Common isNull:self.content];
        NSString *topicTitleText=[Common isNull:self.topic_list];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %@",contentText,topicTitleText]];
        [attrString addAttribute:NSFontAttributeName value:KFontA(14) range:NSMakeRange(0, attrString.length)];
        [attrString addAttribute:NSParagraphStyleAttributeName value:muStyle range:NSMakeRange(0, attrString.length)];
        [attrString addAttribute:NSForegroundColorAttributeName value:RGBA(51, 51, 51, 1) range:NSMakeRange(0,contentText.length)];
        [attrString addAttribute:NSForegroundColorAttributeName value:BaseMainColor range:NSMakeRange(contentText.length+2,topicTitleText.length)];

        if ([attrString.string isMoreThanOneLineWithSize:CGSizeMake(kScreenWidth-kGAP-kAvatar_Size-2*kGAP, CGFLOAT_MAX) font:KFontA(14) lineSpaceing:3.0]) {//margin
            muStyle.lineSpacing = 3.0;//设置行间距离
        }else{
            muStyle.lineSpacing = CGFLOAT_MIN;//设置行间距离
        }

        
        self.mutablAttrStr = attrString;
        
        //算text的layout
        CGFloat textHeight = [attrString.string boundingRectWithSize:CGSizeMake(kScreenWidth-2*kGAP-KAdaptedWidth(28), CGFLOAT_MAX) font:KFontA(14) lineSpacing:3.0].height+0.5;
        
        self.textLayout.frameLayout = CGRectMake(kGAP, kGAP+kAvatar_Size+5, kScreenWidth-2*kGAP-KAdaptedWidth(28), textHeight);
        
        //算九宫格的layout

        CGFloat jgg_Width = kScreenWidth-2*kGAP-kAvatar_Size-50;
        CGFloat image_Width = (jgg_Width-2*kGAP)/3;
        CGFloat jgg_height = 0;
        if (self.image_arr.count==0) {
            jgg_height = 0;
        }
        else if (self.image_arr.count<=3) {
            jgg_height = image_Width=(jgg_Width-2*kGAP)/self.image_arr.count;
        }else if (self.image_arr.count>3&&self.image_arr.count<=6){
            jgg_height = 2*image_Width+kGAP;
        }else  if (self.image_arr.count>6&&self.image_arr.count<=9){
            jgg_height = 3*image_Width+2*kGAP;
        }
        
        NSString *imgName=[Common isNull:self.images];
        if(imgName.length<1){
            jgg_height=0;
        }
        
        
        self.jggLayout.frameLayout =  CGRectMake(self.textLayout.frameLayout.origin.x, CGRectGetMaxY(self.textLayout.frameLayout)+kGAP, jgg_Width, jgg_height);
        
        self.headerHeight = CGRectGetMaxY(self.jggLayout.frameLayout)+((self.image_arr.count==0)?0.f:kGAP);
    }
    return self;
}

@end

