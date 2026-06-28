#import "MLChatRoomNativeGameCell.h"
#import "Global.h"

@interface MLChatRoomNativeGameCell ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation MLChatRoomNativeGameCell

+ (NSString *)cellIdentifier {
    return @"MLChatRoomNativeGameCell";
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _logoImageView = [[UIImageView alloc] init];
    _logoImageView.contentMode = UIViewContentModeScaleAspectFill;
    _logoImageView.clipsToBounds = YES;
    setViewCorner(_logoImageView, 4);
    [self.contentView addSubview:_logoImageView];
    
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(72, 72));
    }];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:11];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_nameLabel];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_logoImageView.mas_bottom).offset(6);
        make.leading.trailing.mas_equalTo(self.contentView);
    }];
}

- (void)configureWithTitle:(NSString *)title 
                 logoName:(NSString *)logoName 
                textColor:(UIColor *)textColor {
    self.nameLabel.text = title;
    self.nameLabel.textColor = textColor;
    self.logoImageView.image = [UIImage imageNamed:logoName];
}

@end
