#import "MLThemeGameSixRecordDateHeader.h"
#import "Global.h"
#import <Masonry/Masonry.h>

@implementation MLThemeGameSixRecordDateHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.textColor = [UIColor colorWithRed:0xE0/255.0 green:0x38/255.0 blue:0x75/255.0 alpha:1.0];
    _dateLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(13)];
    [self addSubview:_dateLabel];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self).offset(KDialogAdaptedWidth(4));
        make.centerY.mas_equalTo(self);
    }];
}

@end
