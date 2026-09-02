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
    _SelectIndexPath = SelectIndexPath;
    
    NSString *nameStr = giftModel.name ? [NSString stringWithFormat:@"%@", giftModel.name] : @"";
    NSString *priceStr = giftModel.price ? [NSString stringWithFormat:@"%@", giftModel.price] : @"";
    NSString *numStr = giftModel.num ? [NSString stringWithFormat:@"%@", giftModel.num] : @"1";
    NSString *cleanName = [nameStr stringByReplacingOccurrencesOfString:@".00" withString:@""];
    NSString *cleanPrice = [priceStr stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
    self.packageGiftCount.text = cleanPrice;
    [self.giftIcon sd_setImageWithURL:[NSURL URLWithString:[Common isNull:giftModel.image]] placeholderImage:ImageNamed(@"未加载头像")];
    self.giftPrice.text = cleanName;
    self.packageGiftCount.hidden = YES;
    
    if (currentInex == 2) {
        self.giftPrice.text = [NSString stringWithFormat:@"%@x%@", cleanName, numStr];
        [self.giftName setImage:ImageNamed(@"coinImg") forState:UIControlStateNormal];
        [self.giftName setTitle:cleanPrice forState:UIControlStateNormal];
        self.lockIconImageView.hidden = !giftModel.isLocked;
    } else {
        [self.giftName setImage:ImageNamed(@"coinImg") forState:UIControlStateNormal];
        [self.giftName setTitle:cleanPrice forState:UIControlStateNormal];
        self.lockIconImageView.hidden = YES;
    }
}

-(void)configWithFuDaiModel:(RoomFuDaiModel *)fuDaiModel Index:(NSInteger)currentInex andIndexpath:(NSIndexPath *)SelectIndexPath{
    _fuDaiModel = fuDaiModel;
    _SelectIndexPath = SelectIndexPath;
    
    NSString *priceStr = fuDaiModel.price ? [NSString stringWithFormat:@"%@", fuDaiModel.price] : @"0";
    NSString *cleanPrice = [priceStr stringByReplacingOccurrencesOfString:@".00" withString:@""];
    NSString *nameStr = fuDaiModel.name ? [NSString stringWithFormat:@"%@", fuDaiModel.name] : @"";
    
    self.packageGiftCount.text = [NSString stringWithFormat:@"%ld", (long)[cleanPrice integerValue]];
    if ([fuDaiModel.image hasPrefix:@"http"]) {
        [self.giftIcon sd_setImageWithURL:[NSURL URLWithString:fuDaiModel.image] placeholderImage:ImageNamed(@"未加载头像")];
    } else {
        self.giftIcon.image = ImageNamed([Common isNull:fuDaiModel.image]);
    }
    [self.giftName setTitle:cleanPrice forState:UIControlStateNormal];
    self.giftPrice.text = nameStr;
    [self.giftName setImage:ImageNamed(@"coinImg") forState:UIControlStateNormal];
    self.packageGiftCount.hidden = YES;
    self.lockIconImageView.hidden = YES;
}


-(void)BtnClick{
    NSLog(@"点击Cell主体 - 选中礼物");
    if(self.GiftBtnClick){
        self.GiftBtnClick(0, self.SelectIndexPath); // 0: 仅选中
    }
}

-(void)sendBtnClicked{
    NSLog(@"点击投喂按钮 - 确认赠送");
    if(self.GiftBtnClick){
        self.GiftBtnClick(1, self.SelectIndexPath); // 1: 确认赠送
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
    if (longPressBtn.state != UIGestureRecognizerStateBegan) return;
    if (self.currentType == 2) {
        if (self.giftLongPressBlock) {
            self.giftLongPressBlock(self.giftModel, self.SelectIndexPath);
        }
        return;
    }
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
    self.currentType = currentInex;
    if (isSelect) {
        self.bkImageView.hidden = NO;
        if (currentInex == 3 || currentInex == 4) {
            self.sendBtn.hidden = YES;
            self.giftName.hidden = NO;
        } else {
            self.sendBtn.hidden = NO;
            self.giftName.hidden = YES;
        }
        if (self.clickView.hidden == NO) {
            self.bkImageView.hidden = YES;
            self.sendBtn.hidden = YES;
        }
    } else {
        if (!clickView) {
            self.clickView.num = 0;
            [self showView:YES];
            self.selectBtn.userInteractionEnabled = YES;
        }
        self.sendBtn.hidden = YES;
        self.bkImageView.hidden = YES;
        self.giftName.hidden = NO;
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
    [self.contentView addSubview:self.packageGiftCount];
    [self.contentView addSubview:self.selectBtn];
    [self.contentView addSubview:self.sendBtn];
    [self.contentView addSubview:self.lockIconImageView];
    
    [self.lockIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(3);
        make.right.mas_equalTo(self.contentView).offset(-3);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
    
    [self.bkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(3);
        make.left.mas_equalTo(self.contentView).offset(3);
        make.right.mas_equalTo(self.contentView).offset(-3);
        make.bottom.mas_equalTo(self.contentView).offset(-5);
    }];
    
    [self.giftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(5);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(48);
    }];
    
    [self.giftPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.giftIcon.mas_bottom).offset(3);
        make.left.equalTo(self.contentView).offset(2);
        make.right.equalTo(self.contentView).offset(-2);
        make.height.equalTo(@16);
    }];
    
    [self.giftName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.giftPrice.mas_bottom).offset(2);
        make.width.mas_equalTo(70);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(15);
    }];
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(KAdaptedWidth(68));
        make.height.mas_equalTo(KAdaptedHeight(22));
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-6);
    }];
    
    [self.packageGiftCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-5);
        make.top.mas_equalTo(self.contentView);
        make.width.mas_equalTo(self.contentView);
        make.height.mas_equalTo(20);
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    self.sendBtn.hidden = YES;
    self.clickView.hidden = YES;
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
        [_sendBtn setTitleColor:RGBA(255, 255, 255, 0.95) forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = Font(11);
        [_sendBtn setTitle:@"投喂" forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn addTarget:self action:@selector(BtnClick) forControlEvents:UIControlEventTouchUpInside];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
          //长按时间 0.5s
           longPress.minimumPressDuration = 0.5;
           [_selectBtn addGestureRecognizer:longPress];
  
    }
    return _selectBtn;
}

- (UIImageView *)lockIconImageView {
    if (!_lockIconImageView) {
        _lockIconImageView = [[UIImageView alloc] init];
        _lockIconImageView.contentMode = UIViewContentModeScaleAspectFit;
        _lockIconImageView.image = [[self class] giftLockedBadgeImage];
        _lockIconImageView.hidden = YES;
    }
    return _lockIconImageView;
}

+ (UIImage *)giftLockedBadgeImage {
    static UIImage *badgeImg = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGSize size = CGSizeMake(16, 16);
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        if (ctx) {
            UIColor *goldColor = [UIColor colorWithRed:255/255.0 green:230/255.0 blue:111/255.0 alpha:1.0];
            [goldColor setFill];
            [goldColor setStroke];
            
            UIBezierPath *shackle = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(4.5, 1.5, 7, 7) cornerRadius:3.5];
            shackle.lineWidth = 1.6;
            [shackle stroke];
            
            UIBezierPath *body = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(2.5, 6.0, 11, 8.5) cornerRadius:2.0];
            [body fill];
            
            UIColor *holeColor = [UIColor colorWithWhite:0 alpha:0.65];
            [holeColor setFill];
            UIBezierPath *hole = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(7.0, 8.8, 2.0, 2.0)];
            [hole fill];
            UIBezierPath *stem = [UIBezierPath bezierPathWithRect:CGRectMake(7.4, 10.2, 1.2, 2.2)];
            [stem fill];
            
            badgeImg = UIGraphicsGetImageFromCurrentImageContext();
        }
        UIGraphicsEndImageContext();
    });
    return badgeImg;
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
