//
//  EMO_PersonalGradeCell.m
//  miliao
//
//  Created by ZhangShiHao on 2023/6/26.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_PersonalGradeCell.h"
#import "EMO_PersonalGradeView.h"

@interface EMO_PersonalGradeCell()
//Strong UIView *showBgView;
//Strong UIView *bgView;
//Strong UIButton *gradeBtn;

Strong EMO_PersonalGradeView *gradeView;

@end

@implementation EMO_PersonalGradeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){

//        [self gradeView];
        
            
//            UIButton *burtton = [UIButton buttonWithType:UIButtonTypeCustom];
//            burtton.frame = CGRectMake(X, Y+top, W, H);
//            [burtton setImage:[UIImage imageNamed:@"huati_录像"] forState:UIControlStateNormal];
//            [burtton setTitle:@"0" forState:UIControlStateNormal];
//            [burtton setImagePositionWithType:SSImagePositionTypeTop spacing:0];
//            [burtton addTarget:self action:@selector(otherButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//            [self addSubview:burtton];
        
        
        
    }
    return self;
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    
    NSMutableArray *arrDara=[NSMutableArray array];
    if (![Common isBlankDictionary:dicData[@"family_info"]]) {
//        [arrDara addObject:@{@"image":dicData[@"family_info"][@"level_image"],@"name":dicData[@"family_info"][@"level"]}];
        [arrDara addObject:@{@"image":@"level1Img",@"name":dicData[@"family_info"][@"level"]}];
    }
    
    [arrDara addObject:@{@"image":@"level3Img",@"name":[NSString stringWithFormat:@"贡献等级\n%@",[Common isNull:dicData[@"user_info"][@"contribute_level"]]]}];
    [arrDara addObject:@{@"image":@"level4Img",@"name":[NSString stringWithFormat:@"魅力等级\n%@",[Common isNull:dicData[@"user_info"][@"charm_level"]]]}];
//    [arrDara addObject:@{@"image":@"level2Img",@"name":[Common isNull:dicData[@"user_info"][@"peerage_name"]]}];
    
//    [arrDara addObject:@{@"image":dicData[@"user_info"][@"peerage_image"],@"name":dicData[@"user_info"][@"peerage_name"]}];
    //每个Item宽高
    CGFloat W = KAdaptedWidth(112);
    CGFloat H = KAdaptedHeight(90);
    //每行列数
    NSInteger rank = 3;
    //每列间距
    CGFloat rankMargin = 10;
    //每行间距
    CGFloat rowMargin = 5;
    //Item索引 ->根据需求改变索引
    NSUInteger index = arrDara.count;
    EMO_PersonalGradeView *curView = nil;
    for (int i = 0 ; i< index; i++) {
        //Item X轴
        CGFloat X = (i % rank) * (W + rankMargin);
        //Item Y轴
        NSUInteger Y = (i / rank) * (H +rowMargin);
        //Item top
        CGFloat top = 10;
        EMO_PersonalGradeView *view=[[EMO_PersonalGradeView alloc] init];
        view.frame= CGRectMake(X, Y+top, W, H);
        view.dicData=arrDara[i];
        [self addSubview:view];
        curView = view;
    }
    self.cellHeight = curView.bottom+5;
}


















- (EMO_PersonalGradeView *)gradeView{
    if (!_gradeView) {
        _gradeView = [[EMO_PersonalGradeView alloc] init];
        [self.contentView addSubview:_gradeView];
        [_gradeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(KAdaptedWidth(110));
            make.height.mas_equalTo(KAdaptedHeight(50));
            make.top.mas_equalTo(KAdaptedHeight(0));
            make.leading.mas_equalTo(KAdaptedWidth(10));
            
        }];
    }
    return _gradeView;
}






@end
