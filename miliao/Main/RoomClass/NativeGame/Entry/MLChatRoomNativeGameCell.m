#import "MLChatRoomNativeGameCell.h"
#import "Global.h"

@interface MLChatRoomNativeGameCell ()

@property (nonatomic, strong) UIImageView *cellBgView;
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
    _cellBgView = [[UIImageView alloc] init];
    _cellBgView.image = [UIImage imageNamed:@"mgame_alertview_cellbg"];
    _cellBgView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:_cellBgView];
    
    [_cellBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(72), KAdaptedWidth(85)));
    }];
    
    _logoImageView = [[UIImageView alloc] init];
    _logoImageView.contentMode = UIViewContentModeScaleAspectFill;
    _logoImageView.clipsToBounds = YES;
    setViewCorner(_logoImageView, KAdaptedWidth(4));
    [self.contentView addSubview:_logoImageView];
    
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(72), KAdaptedWidth(85)));
    }];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:10];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_nameLabel];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_cellBgView.mas_bottom).offset(-KAdaptedWidth(2));
        make.leading.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(KAdaptedWidth(15));
    }];
}

- (void)configureWithTitle:(NSString *)title 
                  logoName:(NSString *)logoName 
                 textColor:(UIColor *)textColor {
    self.nameLabel.text = title;
    self.nameLabel.textColor = textColor;
    self.logoImageView.image = [UIImage imageNamed:logoName];
    
    if ([logoName isEqualToString:@"chat_room_plate_draw"]) {
        // 占位图：隐藏边框底板，logoImageView 撑满 (72 * 85 pt)
        self.cellBgView.hidden = YES;
        setViewCorner(self.logoImageView, 0);
        [self.logoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.centerX.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(72), KAdaptedWidth(85)));
        }];
    } else {
        // 活跃游戏：显示边框底板，logoImageView 缩放嵌套在中心 (58 * 58 pt)
        self.cellBgView.hidden = NO;
        setViewCorner(self.logoImageView, KAdaptedWidth(4));
        [self.logoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.cellBgView);
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(58), KAdaptedWidth(58)));
        }];
    }
}

@end
