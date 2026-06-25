//
//  DYSingleListPicker.m
//  YingPu
//
//  Created by 李东阳 on 2018/10/19.
//  Copyright © 2018年 锤子科技. All rights reserved.
//

#import "DYSingleListPicker.h"
/** 控件整体高度*/
#define   alertHeight     240.0f
/** 行高*/
#define   singleRowHeight    30.0f
/** 背景颜色*/
#define   alertBGColor      RGBCOLOR(246, 246, 246)
@interface DYSingleListPicker ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong) UIPickerView *pickerView;
/** 遮罩图*/
@property (nonatomic,strong) UIView *maskView;
/** 操作栏*/
@property (nonatomic,strong) UIView *operationBar;
/** title*/
@property (nonatomic,strong) UILabel *titleLab;
/** 记录选择的row*/
@property (nonatomic,assign) NSUInteger dnSelectRow;
/** 异形屏，底部tab不可控区域*/
@property (nonatomic,strong)UIView *specia_screen_view;
@end

@implementation DYSingleListPicker

-(instancetype)init
{
    self = [super init];
    [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, alertHeight)];
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES ;
    if (self) {
        [self setUI];
    }
    return self ;
}
- (void)setUI
{
    /** 初始化*/
    self.dnSelectRow = 0 ;
    [self addSubview:self.operationBar];
    [self addSubview:self.pickerView];
    self.backgroundColor = UIColor.clearColor ;
    
}
- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.operationBar.bottom, SCREEN_WIDTH, alertHeight - self.operationBar.bottom)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        [_pickerView reloadAllComponents];//刷新UIPickerView
    }
    return _pickerView ;
}
- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _maskView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
        _maskView.userInteractionEnabled = YES;
        _maskView.multipleTouchEnabled = YES ;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        @weakify(self);
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            @strongify(self);
            [self hide];
        }];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView ;
}
- (UIView *)operationBar
{
    if (!_operationBar) {
        _operationBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        _operationBar.backgroundColor = UIColor.whiteColor ;
        _operationBar.userInteractionEnabled = YES ;
        _operationBar.multipleTouchEnabled = YES ;
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 15 * 2, 0.5)];
        line.backgroundColor = LineColor ;
        [_operationBar addSubview:line];
        [line setBottom:_operationBar.height];
        
        /** 指定圆角*/
        CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, _operationBar.height) ;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = rect;
        maskLayer.path = maskPath.CGPath;
        _operationBar.layer.mask = maskLayer;
        
        @weakify(self);
        UIButton *btn = [UIButton racButtonWithTitle:@"确定" BGImage:nil frame:CGRectMake(15, 0, 50, _operationBar.height) fontSize:15 titleColor:BaseMainColor];
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if (self.pickerSelectHandle) {
                if (self.dataArr.count > 0) {
                    self.pickerSelectHandle(self.dnSelectRow, self.dataArr[self.dnSelectRow]);
                }
            }
            [self hide];
        }];
        [btn setRight:SCREEN_WIDTH - 15];
        [_operationBar addSubview:btn];
        
        
        /** 取消*/
        UIButton *btn2 = [UIButton racButtonWithTitle:@"取消" BGImage:nil frame:CGRectMake(15, 0, 50, _operationBar.height) fontSize:15 titleColor:UIColorFromRGB(0x999999)];
        [[btn2 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self hide];
        }];
        [btn2 setLeft:15];
        [_operationBar addSubview:btn2];
        
        /** title*/
        [_operationBar addSubview:self.titleLab];
        [self.titleLab setCenterX:_operationBar.width / 2];
        [self.titleLab setCenterY:_operationBar.height / 2];
    }
    return _operationBar ;
}
-(UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [UILabel LabelWithFrame:CGRectMake(0, 0, SCREEN_WIDTH -  60 * 2, 25) fontSize:16 textColor:[UIColor blackColor] textAlient:NSTextAlignmentCenter numberLines:1];
        _titleLab.backgroundColor = [UIColor clearColor];
    }
    return _titleLab ;
}
//返回有几列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//返回指定列的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.dataArr count];
}

//返回指定列，行的高度，就是自定义行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return singleRowHeight;
}

//返回指定列的宽度
- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return  SCREEN_WIDTH ;
}

#pragma mark --- 自定义指定列的每行的视图，即指定列的每行的视图行为一致
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (!view){
        view = [[UIView alloc]init];
    }
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, singleRowHeight)];
    text.textAlignment = NSTextAlignmentCenter;
    text.font = [UIFont systemFontOfSize:18];
    text.text = [self.dataArr objectAtIndex:row];
    text.textColor = UIColor.blackColor ;
    [view addSubview:text];
    //上下直线  隐藏的时候就是 clearColor
    if (self.pickerView.subviews.count >= 2) {
        [self.pickerView.subviews objectAtIndex:1].backgroundColor = UIColor.clearColor;
    }
    if (self.pickerView.subviews.count >= 3) {
        [self.pickerView.subviews objectAtIndex:2].backgroundColor = LineColor;
    }
    return view;
}

#pragma mark --- 系统自带样式
////显示的标题
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    NSString *str = [_nameArray objectAtIndex:row];
//    return str;
//}
//
////显示的标题字体、颜色等属性
//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    NSString *str = [_nameArray objectAtIndex:row];
//    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc]initWithString:str];
//    [AttributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, [AttributedString  length])];
//    return AttributedString;
//}//NS_AVAILABLE_IOS(6_0);


//被选择的行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    DLog(@"HANG%@",[self.dataArr objectAtIndex:row]);
    self.dnSelectRow = row ;
}

#pragma mark --
#pragma mark --- Setter
- (void)setActionTitle:(NSString *)actionTitle
{
    self.titleLab.text = actionTitle ;
}

#pragma mark --
#pragma mark --- Getter
-(UIView *)specia_screen_view
{
    if (!_specia_screen_view) {
        _specia_screen_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH, 60)];
        _specia_screen_view.backgroundColor = [UIColor whiteColor];
        _specia_screen_view.bottom = SCREEN_HEIGHT_FULL ;
    }
    return _specia_screen_view ;
}

#pragma mark --
#pragma mark --- Method
- (void)show
{
    AppDelegate *app = AppDelegateInstance ;
    [app.window addSubview:self.maskView];
    [app.window addSubview:self];
    [self setTop:SCREEN_HEIGHT_FULL + 60];
    if (IS_iPhoneX) {
        [app.window addSubview:self.specia_screen_view];
        [app.window insertSubview:self.specia_screen_view belowSubview:self];
    }
    
    if(self.defIndex > 0 && self.defIndex < self.dataArr.count){
        self.dnSelectRow = self.defIndex ;
        [self.pickerView selectRow:self.defIndex inComponent:0 animated:NO];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        [self setBottom:SCREEN_HEIGHT];
    } completion:^(BOOL finished) {
       
    }];
}
- (void)hide
{
    [self.maskView removeFromSuperview];
    [self.operationBar removeFromSuperview];
    [self.specia_screen_view removeFromSuperview];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self setTop:SCREEN_HEIGHT + 100];
    } completion:^(BOOL finished) {
        [self deallocSubview];
    }];
}
/** 销毁view*/
- (void)deallocSubview
{
    [_specia_screen_view removeFromSuperview];
    [_pickerView removeFromSuperview];
    [_maskView removeFromSuperview];
    [_operationBar removeFromSuperview];
    [_titleLab removeFromSuperview];
    [self removeFromSuperview];
    _maskView.hidden = YES ;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end






