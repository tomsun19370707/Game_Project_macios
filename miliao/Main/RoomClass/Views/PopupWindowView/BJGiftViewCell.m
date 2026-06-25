//
//  BJGiftViewCell.m
//  miliao
//
//  Created by bianruifeng on 2019/12/11.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "BJGiftViewCell.h"
#import "RoomGiftModel.h"
#import "BAButton.h"
#import "RoomFuDaiModel.h"
#import "EMO_DoubleClickView.h"
@interface BJGiftViewCell ()
{
    CAKeyframeAnimation* animation;
}
@property(nonatomic, strong) UIImageView *bkImageView;//边框图

Strong EMO_DoubleClickView *clickView;

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,assign) NSInteger num;

@property (nonatomic,assign) NSInteger currentType;

@end

@implementation BJGiftViewCell
static NSString *ReuseIdentifier = @"BJGiftViewCell";

#pragma mark - 快速创建cell
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath{
    
    BJGiftViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    return cell;
}

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = MHColorFromHexString(@"f8f8f8");
        self.backgroundColor = kClearColor;
        self.num=0;
        self.count=5;
        [self setUpUI];
    }
    return self;
}

-(void)configWithModel:(RoomGiftModel *)giftModel Index:(NSInteger)currentInex andIndexpath:(NSIndexPath *)SelectIndexPath{
     _giftModel = giftModel;
    _SelectIndexPath=SelectIndexPath;
    self.packageGiftCount.text = giftModel.price;
//    if(currentInex == 2){
//        self.packageGiftCount.text = giftModel.num;
//    }else{
//        self.packageGiftCount.text = giftModel.price;
//    }
    [self.giftIcon sd_setImageWithURL:[NSURL URLWithString:giftModel.image] placeholderImage:ImageNamed(@"未加载头像")];
    NSString *str = [giftModel.name stringByReplacingOccurrencesOfString:@".00" withString:@""];
    self.giftPrice.text = NSStringFormat(@"%@",str);
    
//    self.packageGiftCount.hidden = NO;
//    if (currentInex==2) {
//        self.packageGiftCount.hidden = NO;
//    }else{
        self.packageGiftCount.hidden = YES;
//    }
    
    if (currentInex==2) {
        self.giftPrice.text = NSStringFormat(@"%@x%@",giftModel.name,giftModel.num);
        [self.giftName setImage:ImageNamed(@"coinImg") forState:UIControlStateNormal];
        NSString *str = [giftModel.price stringByReplacingOccurrencesOfString:@".00" withString:@""];
        [self.giftName setTitle:[NSString stringWithFormat:@"%@",str] forState:UIControlStateNormal];
    }else{
        [self.giftName setImage:ImageNamed(@"coinImg") forState:UIControlStateNormal];
        NSString *str = [giftModel.price stringByReplacingOccurrencesOfString:@".00" withString:@""];
        [self.giftName setTitle:str forState:UIControlStateNormal];
    }
}

-(void)configWithFuDaiModel:(RoomFuDaiModel *)fuDaiModel Index:(NSInteger)currentInex andIndexpath:(NSIndexPath *)SelectIndexPath{
    
     _fuDaiModel = fuDaiModel;
    _SelectIndexPath=SelectIndexPath;
    NSString *str = [fuDaiModel.price stringByReplacingOccurrencesOfString:@".00" withString:@""];
    self.packageGiftCount.text =[NSString stringWithFormat:@"%ld",[str integerValue]];
    [self.giftIcon sd_setImageWithURL:[NSURL URLWithString:fuDaiModel.image] placeholderImage:ImageNamed(@"未加载头像")];
        [self.giftName setTitle:fuDaiModel.price forState:UIControlStateNormal];
    self.giftPrice.text = NSStringFormat(@"%@",fuDaiModel.name);
    [self.giftName setImage:ImageNamed(@"coinImg") forState:UIControlStateNormal];
//    self.packageGiftCount.hidden = NO;
//    if (currentInex==2) {
//        self.packageGiftCount.hidden = NO;
//    }else{
        self.packageGiftCount.hidden = YES;
//    }
}


-(void)BtnClick{
    NSLog(@"点击");
    if(self.GiftBtnClick){
        self.GiftBtnClick(1,self.SelectIndexPath);
    }
    
}

-(void)showView:(BOOL)hidden{
    
    self.clickView.hidden=hidden;
    self.giftIcon.hidden=!hidden;
    self.giftName.hidden=!hidden;
    self.giftPrice.hidden=!hidden;
    self.sendBtn.hidden=!hidden;
    self.bkImageView.hidden=!hidden;
    
}

-(void)longPress:(UILongPressGestureRecognizer *)longPressBtn{
    if(self.currentType!=3){//宝箱不执行长按
        NSLog(@"长按");
        self.selectBtn.userInteractionEnabled=NO;
        [self showView:NO];
        if(self.GiftBtnClick){
            self.GiftBtnClick(2,self.SelectIndexPath);
        }
    }
}

-(void)timerEvent{
    _count--;
    if (_count == 0) {
        self.selectBtn.userInteractionEnabled=YES;
        [self.timer invalidate];
        self.timer = nil;
        _count = 5;
        self.clickView.num=0;
        [self showView:YES];
        !self.sendGiftClick?:self.sendGiftClick(self.num);
    }
    
}

- (void)getIsSelected:(BOOL)isSelect andIndex:(NSInteger)currentInex andShow:(BOOL)clickView{
    self.currentType=currentInex;
    if (isSelect) {
//        [self shakeToShow:self.giftIcon];//暂时取消
        self.bkImageView.hidden = NO;
        self.sendBtn.hidden=NO;
        if(currentInex==3){
            self.sendBtn.hidden=YES;
            [self.giftPrice mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.giftIcon.mas_bottom).offset(8);
                make.height.equalTo(@18);
            }];
        }else{
            [self.giftPrice mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.giftIcon.mas_bottom).offset(0);
                make.height.equalTo(@0);
            }];
            
        }
        [self.giftPrice layoutIfNeeded];
        if(self.clickView.hidden==NO){
            self.bkImageView.hidden = YES;
            self.sendBtn.hidden=YES;
        }

    }else{
        if(!clickView){
            self.clickView.num=0;
            [self showView:YES];
            self.selectBtn.userInteractionEnabled=YES;
        }
        self.sendBtn.hidden=YES;
        self.bkImageView.hidden = YES;
//        [self.giftIcon.layer removeAllAnimations];//暂时取消
        if(currentInex==1){
            [self.giftPrice mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.giftIcon.mas_bottom).offset(8);
                make.height.equalTo(@18);
            }];
            [self.giftPrice layoutIfNeeded];
        }
    }
}

/** 设置缩放动画 */
- (void) shakeToShow:(UIView*)aView
{
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];

    animation.duration = 1.5;// 动画时间
    animation.repeatCount = 100000;
    NSMutableArray *values = [NSMutableArray array];

    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];

    // 这三个数字，我只研究了前两个，所以最后一个数字我还是按照它原来写1.0；前两个是控制view的大小的；

    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];

    animation.values = values;

    [aView.layer addAnimation:animation forKey:@"iconAnimation"];

}
- (void)setUpUI{
    
    [self.contentView addSubview:self.bkImageView];
    [self.contentView addSubview:self.giftIcon];
    [self.contentView addSubview:self.giftPrice];
    [self.contentView addSubview:self.giftName];
    [self.contentView addSubview:self.sendBtn];
    [self.contentView addSubview:self.packageGiftCount];
    [self.contentView addSubview:self.selectBtn];
    
    [self.bkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(3);
        make.left.mas_equalTo(self.contentView).offset(3);
        make.right.mas_equalTo(self.contentView).offset(-3);
        make.bottom.mas_equalTo(self.contentView).offset(-5);
    }];
    
    [self.giftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(5);
        make.left.mas_equalTo(self.contentView).offset(ScreenWidth/4.0/2.0-25);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    [self.giftPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.giftIcon.mas_bottom).offset(8);
        make.left.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(-5);
        make.height.equalTo(@18);
//        make.bottom.equalTo(self.giftName.mas_top);
    }];
    
    
//    self.giftName.frame = CGRectMake(0, 0, 70, 15);
    // 2. 关键：设置图片的目标显示尺寸【你只需要改这两个值】
//    CGFloat targetImgW = 12; // 图片要显示的宽度
//    CGFloat targetImgH = 12; // 图片要显示的高度
//    // 3. 计算图片内边距 (向内压缩，让imageView的显示区域变成我们要的尺寸)
//    CGFloat imgEdgeInsetX = (self.giftName.frame.size.width - targetImgW) / 2;
//    CGFloat imgEdgeInsetY = (self.giftName.frame.size.height - targetImgH) / 2;
//    self.giftName.imageEdgeInsets = UIEdgeInsetsMake(imgEdgeInsetY, imgEdgeInsetX, imgEdgeInsetY, imgEdgeInsetX);
//    // 4. 可选：如果需要调整图文间距（必加，否则文字会被挤压）
//    // 方案A - 图文左右排列（默认）：图片在左，文字在右，间距10
//    self.giftName.titleEdgeInsets = UIEdgeInsetsMake(0, 10 - imgEdgeInsetX*2, 0, -imgEdgeInsetX*2- 30);
    [self.giftName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.giftPrice.mas_bottom).offset(5);
//        make.width.mas_equalTo(self.giftPrice.mas_width);
//        make.left.mas_equalTo(self.giftPrice.mas_left);
//        make.width.mas_equalTo(KAdaptedWidth(60));
//        make.left.mas_offset(10);
//        make.right.mas_offset(-10);
        make.width.mas_equalTo(70);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(15);
        
    }];
    
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(KAdaptedWidth(70));
        make.height.mas_equalTo(KAdaptedHeight(25));
        make.centerX.mas_equalTo(KAdaptedHeight(0));
        make.bottom.mas_equalTo(KAdaptedHeight(-11));
        
        
    }];
    
    
    [self.packageGiftCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-5);
        make.top.mas_equalTo(self.contentView);
        make.width.mas_equalTo(self.contentView);
        make.height.mas_equalTo(20);
    }];
    
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.mas_equalTo(KAdaptedHeight(0));
    }];
//
    
    
    self.sendBtn.hidden=YES;
    self.clickView.hidden=YES;
    
}

- (EMO_DoubleClickView *)clickView{
    if (!_clickView) {
        _clickView = [[EMO_DoubleClickView alloc] init];
        _clickView.backgroundColor = RGBA(253, 2, 142, 1);
        WeakSelf;
        _clickView.numBlock = ^(NSInteger num) {
            wself.num=num;
            if(num==1){
                wself.timer =[NSTimer scheduledTimerWithTimeInterval:1 target:wself selector:@selector(timerEvent) userInfo:nil repeats:YES];
            }
        };
        [self.contentView addSubview:_clickView];
        [_clickView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.centerX.mas_equalTo(0);
            make.width.height.mas_equalTo(KAdaptedWidth(85));
        }];
        setViewCorner(_clickView, KAdaptedWidth(85)/2);
    }
    return _clickView;
}

- (UIImageView *)bkImageView{
    if (!_bkImageView) {
        _bkImageView = [UIImageView new];
//        _bkImageView.image = ImageNamed(@"bk_forGift");
        _bkImageView.image = ImageNamed(@"giftSelectImg");
    }
    return _bkImageView;
}
- (UILabel *)packageGiftCount{
    if (!_packageGiftCount) {
        _packageGiftCount = [UILabel new];
        _packageGiftCount.text = @"10";
        _packageGiftCount.textColor = MHColorFromHexString(@"81D8CF");
        _packageGiftCount.font = FONT_12;
        _packageGiftCount.hidden = YES;
        _packageGiftCount.textAlignment = NSTextAlignmentRight;
        
    }
    return _packageGiftCount;
}
- (UIImageView *)giftIcon{
    if (!_giftIcon) {
        _giftIcon = [ControlCreator createImageView:nil rect:CGRectZero imageName:@"coinImg" backguoundColor:[UIColor clearColor]];
    }
    return _giftIcon;
}
- (WZDLayoutButton *)giftName{
    if (!_giftName) {
        _giftName = [WZDLayoutButton buttonWithType:UIButtonTypeCustom];
//        [_giftName setTitleColor:COLOR_666666 forState:UIControlStateNormal];
        _giftName.layoutStyle=WZDLayoutButtonStyleLeftImageRightTitle;
        _giftName.midSpacing=5;
        _giftName.backgroundColor=RGBA(227, 227, 227, 0.35);
        _giftName.layer.cornerRadius=15/2;
        _giftName.layer.masksToBounds=YES;
        [_giftName setTitleColor:RGBA(207, 221, 248, 1) forState:UIControlStateNormal];
        _giftName.titleLabel.font = FONT_12;
        [_giftName setTitle:@"" forState:UIControlStateNormal];
        [_giftName setImage:ImageNamed(@"coinImg") forState:UIControlStateNormal];
        _giftName.imageSize=CGSizeMake(12, 12);
//        _giftName.ba_buttonLayoutType = BAKit_ButtonLayoutTypeNormal;
//        _giftName.ba_padding = 3;
        // 6. 设置图片填充模式
        _giftName.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    return _giftName;
}
//- (UILabel *)giftName{
//    if (!_giftName) {
//        _giftName = [ControlCreator createLabel:nil rect:CGRectZero text:@"Mylove" font:Font(11) color:[UIColor whiteColor] backguoundColor:[UIColor clearColor] align:NSTextAlignmentCenter lines:1];
//    }
//    return _giftName;
//}
- (UILabel *)giftPrice{
    if (!_giftPrice) {
        _giftPrice = [ControlCreator createLabel:nil rect:CGRectZero text:@"一毛钱五个" font:Font(12) color:kWhiteColor backguoundColor:[UIColor clearColor] align:NSTextAlignmentCenter lines:0];
    }
    return _giftPrice;
}

- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setBackgroundImage:KGetImage(@"giveGiftBtnImg") forState:UIControlStateNormal];
        [_sendBtn setTitleColor:RGBA(255, 255, 255, 0.8) forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = FONT_12;
        [_sendBtn setTitle:@"投喂" forState:UIControlStateNormal];
       
    }
    return _sendBtn;
}

- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn addTarget:self action:@selector(BtnClick) forControlEvents:UIControlEventTouchUpInside];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
          //长按时间
           longPress.minimumPressDuration = 1;
           [_selectBtn addGestureRecognizer:longPress];
  
    }
    return _selectBtn;
}





@end

@implementation WZDLayoutButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.midSpacing = 0;
        self.imageSize = CGSizeMake(30, 30);
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    
}

- (void)setLayoutStyle:(WZDLayoutButtonStyle)layoutStyle {
    _layoutStyle = layoutStyle;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imageView sizeToFit];
    [self.titleLabel sizeToFit];
    
    switch (self.layoutStyle) {
        case WZDLayoutButtonStyleLeftImageRightTitle:
            [self layoutHorizontalWithLeftView:self.imageView rightView:self.titleLabel];
            break;
        case WZDLayoutButtonStyleLeftTitleRightImage:
            [self layoutHorizontalWithLeftView:self.titleLabel rightView:self.imageView];
            break;
        case WZDLayoutButtonStyleUpImageDownTitle:
            [self layoutVerticalWithUpView:self.imageView downView:self.titleLabel];
            break;
        case WZDLayoutButtonStyleUpTitleDownImage:
            [self layoutVerticalWithUpView:self.titleLabel downView:self.imageView];
            break;
        default:
            break;
    }
}

- (void)layoutHorizontalWithLeftView:(UIView *)leftView rightView:(UIView *)rightView {
    CGRect leftViewFrame = leftView.frame;
    CGRect rightViewFrame = rightView.frame;
    if ([leftView isKindOfClass:[UIImageView class]]) {
        leftViewFrame.size = self.imageSize;
        leftView.contentMode = UIViewContentModeScaleAspectFit;
    }else {
        rightViewFrame.size = self.imageSize;
        rightView.contentMode = UIViewContentModeScaleAspectFit;
    }
    CGFloat totalWidth = CGRectGetWidth(leftViewFrame) + self.midSpacing + CGRectGetWidth(rightViewFrame);
    
    leftViewFrame.origin.x = (CGRectGetWidth(self.frame) - totalWidth) / 2.0;
    leftViewFrame.origin.y = (CGRectGetHeight(self.frame) - CGRectGetHeight(leftViewFrame)) / 2.0;
    
    leftView.frame = leftViewFrame;
    
    rightViewFrame.origin.x = CGRectGetMaxX(leftViewFrame) + self.midSpacing;
    rightViewFrame.origin.y = (CGRectGetHeight(self.frame) - CGRectGetHeight(rightViewFrame)) / 2.0;
    rightView.frame = rightViewFrame;
}

- (void)layoutVerticalWithUpView:(UIView *)upView downView:(UIView *)downView {
    CGRect upViewFrame = upView.frame;
    CGRect downViewFrame = downView.frame;
    
    if ([upView isKindOfClass:[UIImageView class]]) {
        upViewFrame.size = self.imageSize;
        upView.contentMode = UIViewContentModeScaleAspectFit;
    }else {
        downViewFrame.size = self.imageSize;
        downView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    CGFloat totalHeight = CGRectGetHeight(upViewFrame) + self.midSpacing + CGRectGetHeight(downViewFrame);
    
    upViewFrame.origin.y = (CGRectGetHeight(self.frame) - totalHeight) / 2.0;
    upViewFrame.origin.x = (CGRectGetWidth(self.frame) - CGRectGetWidth(upViewFrame)) / 2.0;
    upView.frame = upViewFrame;
    
    downViewFrame.origin.y = CGRectGetMaxY(upViewFrame) + self.midSpacing;
    downViewFrame.origin.x = (CGRectGetWidth(self.frame) - CGRectGetWidth(downViewFrame)) / 2.0;
    downView.frame = downViewFrame;
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    [super setImage:image forState:state];
    [self setNeedsLayout];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    [self setNeedsLayout];
}

@end
