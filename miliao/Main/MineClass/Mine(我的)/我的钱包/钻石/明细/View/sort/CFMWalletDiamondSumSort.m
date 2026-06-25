//
//  CFMWalletDiamondSumSort.m
//  miliao
//
//  Created by Dylan Lee on 2025/12/9.
//  Copyright © 2025 EMO. All rights reserved.
//

#import "CFMWalletDiamondSumSort.h"
@interface CFMWalletDiamondSumSort ()
/** View */

@end

@implementation CFMWalletDiamondSumSort

#pragma mark -
#pragma mark --- init
-(instancetype)init
{
    self = [super init];
    if (self) {
        /** 初始化*/
        [self initContentview];
        /** RAC*/
        [self initRacChain];
    }
    return self ;
}

#pragma mark -
#pragma mark --- init frame
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /** 初始化*/
        [self initContentview];
        /** RAC*/
        [self initRacChain];
    }
    return self ;
}

#pragma mark -
#pragma mark --- 初始化view
- (void)initContentview
{
    [self.bg makeRoundCorner];
    
    self.date.text = [self getCurrentTime] ;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    /** 初始化*/
    [self initContentview];
    /** RAC*/
    [self initRacChain];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -
#pragma mark --- Rac
- (void)initRacChain {
    
}

#pragma mark -
#pragma mark --- Getter

#pragma mark --
#pragma mark --- Setter

#pragma mark --
#pragma mark --- ibaction
- (IBAction)ac:(id)sender {
    // 1.创建日期选择器
    BRDatePickerView *datePickerView = [[BRDatePickerView alloc]init];
    // 2.设置属性
    datePickerView.pickerMode = BRDatePickerModeYM; 
    datePickerView.title = @"选择时间";
    datePickerView.selectDate = [NSDate date];
    datePickerView.minDate = [NSDate br_setYear:1971 month:1 day:1];
    datePickerView.maxDate = [NSDate date];
    datePickerView.isAutoSelect = YES;
    @weakify(self);
    datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
        DLog(@"选择的值：%@", selectValue);
        NSArray *arr = [selectValue componentsSeparatedByString:@"-"];
        @strongify(self);
        if (arr.count >=2) {
            NSString *year = arr[0];
            NSString *month = arr[1];
            NSString *tarStr = [NSString stringWithFormat:@"%@年%@月",year,month];
            self.date.text = tarStr ;
            
            if (self.fetchDate) {
                self.fetchDate(tarStr);
            }
        }
    };
    // 设置自定义样式
    BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
    customStyle.pickerColor = BR_RGB_HEX(0xd9dbdf, 1.0f);
    customStyle.pickerTextColor = HexColorDy(@"333333");
    customStyle.separatorColor = LineColor;
    datePickerView.pickerStyle = customStyle;

    // 3.显示
    [datePickerView show];
}
#pragma mark --
#pragma mark --- Method

/** 获取当前时间字符串*/
- (NSString *)getCurrentTime
{
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    [formater setDateFormat:@"yyyy年MM月"];
    
    NSString *dataTime = [formater stringFromDate:[NSDate date]];
    
    return dataTime;
}

@end
