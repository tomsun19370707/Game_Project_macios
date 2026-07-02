#import "MLChatRoomMarqueeLabel.h"
#import <Masonry/Masonry.h>

@interface MLChatRoomMarqueeLabel ()

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) NSArray<NSAttributedString *> *items;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation MLChatRoomMarqueeLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.textColor = [UIColor whiteColor];
    _contentLabel.font = [UIFont systemFontOfSize:11];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(12);
        make.trailing.mas_equalTo(-12);
        make.top.bottom.mas_equalTo(0);
    }];
}

- (void)setMarqueeItems:(NSArray<NSAttributedString *> *)items {
    self.items = items;
    self.currentIndex = 0;
    [self stopScroll];
    
    if (items.count > 0) {
        self.contentLabel.attributedText = items.firstObject;
        if (items.count > 1) {
            [self startScroll];
        }
    } else {
        self.contentLabel.attributedText = nil;
    }
}

- (void)startScroll {
    [self stopScroll];
    if (self.items.count <= 1) return;
    
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf scrollNext];
    }];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopScroll {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)scrollNext {
    if (self.items.count <= 1) return;
    
    self.currentIndex = (self.currentIndex + 1) % self.items.count;
    NSAttributedString *nextText = self.items[self.currentIndex];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop; // vertical roll up
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.contentLabel.layer addAnimation:transition forKey:@"rollText"];
    
    self.contentLabel.attributedText = nextText;
}

- (void)dealloc {
    [self stopScroll];
}

@end
