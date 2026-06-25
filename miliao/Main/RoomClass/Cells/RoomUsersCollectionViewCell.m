//
//  RoomUsersCollectionViewCell.m
//  miliao
//
//  Created by TonyStark on 2020/3/16.
//  Copyright © 2020 miliao. All rights reserved.
//

#import "RoomUsersCollectionViewCell.h"

@interface RoomUsersCollectionViewCell ()

@end

@implementation RoomUsersCollectionViewCell

static NSString *ReuseIdentifier = @"RoomUsersCollectionViewCell";

#pragma mark - 快速创建cell
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath{
//    [NSString stringWithFormat:@"%@%ld",ReuseIdentifier,indexPath.row]
    RoomUsersCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    return cell;
}

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = kWhiteColor;
        self.backgroundColor = kClearColor;
        [self setup_UI];
    }
    return self;
}

- (void)setup_UI {
    
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.bkView];
    [self.contentView addSubview:self.nameLabel];
    
    self.iconView.frame = CGRectMake(10,11, 30, 30);
    self.nameLabel.frame = CGRectMake(13, 42-5-4, 24, 12);
    self.bkView.frame = CGRectMake(9, 10, 32, 32);
}

- (void)configWithModel:(MLRoomMSequenceModel *)sequenModel isSelect:(NSInteger)isSelected{
    _sequenModel = sequenModel;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:_sequenModel.avatar] placeholderImage:ImageNamed(@"gift_kong")];
    if ([sequenModel.status isEqualToString:@"2"]) {
       // 麦位有人
        self.nameLabel.backgroundColor = MHColorFromHexString(@"#BD4AFF");
    }else{
        self.nameLabel.backgroundColor = MHColorFromHexString(@"#5C5B6D");
    }
    if (isSelected==1) {
        if ([sequenModel.status isEqualToString:@"2"]) {
            //麦位有人，显示蒙版，没人不显示
             self.bkView.hidden = NO;
        }else{
            self.bkView.hidden = YES;
        }
    }else{
        self.bkView.hidden = YES;
    }
}
#pragma mark ======================  懒加载   ======================
- (UIView *)bkView{
    if (!_bkView) {
        _bkView = [[UIView alloc] init];
        _bkView.layer.cornerRadius = 16;
        _bkView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//        _bkView.layer.borderColor = UIColor.redColor.CGColor;
//        _bkView.layer.borderWidth = 1;
        _bkView.hidden = YES;
//        _bkView.clipsToBounds = YES;
    }
    return _bkView;
}
- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [UIImageView new];
        _iconView.clipsToBounds = YES;
        _iconView.layer.cornerRadius = 15;
    }
    return _iconView;
}
- (UIButton *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nameLabel setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _nameLabel.titleLabel.font = Font(8);
        _nameLabel.layer.cornerRadius = 6;
        _nameLabel.clipsToBounds = YES;
//        [_nameLabel setBackgroundImage:ImageNamed(@"tingZhuImg") forState:UIControlStateNormal];
        _nameLabel.backgroundColor=RGBA(47, 40, 118, 1);
    }
    return _nameLabel;
}
@end
