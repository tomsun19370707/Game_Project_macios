//
//  SDLabTagsView.m
//  SDTagsView
//
//  Created by apple on 2017/2/22.
//  Copyright © 2017年 slowdony. All rights reserved.
//

#import "SDLabTagsView.h"
#import "SDTagsModel.h"
#import "SDHelper.h"
@interface SDLabTagsView ()
{
    UIView *sdTagsView;
}
@property (nonatomic,strong)UILabel *tagsLab;
@end
@implementation SDLabTagsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUP];
      
    }
    return self;
}

-(void)setUP{
    // 创建标签容器
    sdTagsView = [[UIView alloc] init];
    sdTagsView.frame  = CGRectMake(0, 64, ScreenWidth, 300);
    
    sdTagsView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:sdTagsView];
}

//+(instancetype)sdLabTagsViewWithTagsArr:(NSArray *)tagsArr{
//    SDLabTagsView *sdLabTagsView =[[SDLabTagsView alloc]init];
//    sdLabTagsView.tagsArr =tagsArr;
//    [sdLabTagsView setUItags:tagsArr];
//    return sdLabTagsView;
//}
-(void)setTagsArr:(NSArray *)tagsArr
{
    [self setUItags:tagsArr];
}

-(void)setUItags:(NSArray *)arr{
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *la = (UILabel *)obj;
        [la removeFromSuperview];
    }];
    
    int width = 0;
    
    int j = 0;
    
    int row = 0;
    
    
    for (int i = 0 ; i < arr.count; i++) {
        
        NSString *string =arr[i];

        int labWidth = [SDHelper widthForLabel:string fontSize:14]+20;
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(5*j + width,row * 20, labWidth, 18);
        label.text = string;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.numberOfLines = 1;
        label.clipsToBounds = YES;
        label.layer.cornerRadius = 2;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = MHColorFromHexString(@"#21D1FD");
        [self addSubview:label];
        
        width = width + labWidth;
        
        j++;
        
        if (width > ScreenWidth - 30) {
            
            j = 0;
            
            width = 10;
            
            row++;
            
            label.frame = CGRectMake(5*j + width, row *20, labWidth, 18);
            
            width = width + labWidth;
            
            j++;
            
        }
        
    }
    
}



@end
