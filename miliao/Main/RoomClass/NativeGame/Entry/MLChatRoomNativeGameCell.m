#import "MLChatRoomNativeGameCell.h"
#import "Global.h"

@interface MLChatRoomNativeGameCell ()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subLabel;

@end

@implementation MLChatRoomNativeGameCell

+ (NSString *)cellIdentifier {
    return @"MLChatRoomNativeGameCell";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImageView.clipsToBounds = YES;
    setViewCorner(_bgImageView, 12);
    [self.contentView addSubview:_bgImageView];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6);
        make.bottom.mas_equalTo(-6);
        make.leading.mas_equalTo(16);
        make.trailing.mas_equalTo(-16);
    }];
    
    _logoImageView = [[UIImageView alloc] init];
    _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_bgImageView addSubview:_logoImageView];
    
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.centerY.mas_equalTo(_bgImageView);
        make.size.mas_equalTo(CGSizeMake(48, 48));
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = kWhiteColor;
    _titleLabel.font = KFontBoldA(16);
    [_bgImageView addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_logoImageView.mas_trailing).offset(12);
        make.top.mas_equalTo(_logoImageView.mas_top).offset(2);
        make.trailing.mas_equalTo(-16);
    }];
    
    _subLabel = [[UILabel alloc] init];
    _subLabel.textColor = [UIColor colorWithWhite:1 alpha:0.7];
    _subLabel.font = KFontA(12);
    [_bgImageView addSubview:_subLabel];
    
    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_titleLabel);
        make.bottom.mas_equalTo(_logoImageView.mas_bottom).offset(-2);
        make.trailing.mas_equalTo(-16);
    }];
}

- (void)configureWithTitle:(NSString *)title 
                  subtitle:(NSString *)subtitle 
                 bgImgName:(NSString *)bgImgName 
               logoImgName:(NSString *)logoImgName {
    self.titleLabel.text = title;
    self.subLabel.text = subtitle;
    self.bgImageView.image = [UIImage imageNamed:bgImgName];
    self.logoImageView.image = [UIImage imageNamed:logoImgName];
}

@end
