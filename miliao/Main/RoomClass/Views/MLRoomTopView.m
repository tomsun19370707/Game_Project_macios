//
//  MLRoomTopView.m
//  miliao
//
//  Created by aa on 2019/6/14.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "MLRoomTopView.h"
#import "BAButton.h"
#import "NSString+category.h"

@interface MLRoomTopView ()

@property (weak, nonatomic) IBOutlet UILabel *roomName;
@property (weak, nonatomic) IBOutlet UILabel *labelType;
@property(nonatomic, strong) UIButton *huoLB;//活力值
@property (weak, nonatomic) IBOutlet UILabel *heatNum;
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;
@property (weak, nonatomic) IBOutlet UIButton *publickBtn;

@end


@implementation MLRoomTopView
- (UIButton *)idLB{
    if (!_idLB) {
        _idLB = [UIButton buttonWithType:UIButtonTypeCustom];
        _idLB.titleLabel.font = FONT_12;
        [_idLB setTitleColor:COLOR_666666 forState:UIControlStateNormal];
    }
    return _idLB;
}

- (UIButton *)huoLB{
    if (!_huoLB) {
        _huoLB = [UIButton buttonWithType:UIButtonTypeCustom];
        _huoLB.titleLabel.font = FONT_11;
        [_huoLB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_huoLB setImage:[UIImage imageNamed:@"火力值"] forState:0];
        _huoLB.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        _huoLB.backgroundColor = [UIColor clearColor];
        [self addSubview:_huoLB];
        [_huoLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(34);
            make.top.mas_offset(self.idLB.bottom+23);
            make.height.mas_offset(22);
        }];
    }
    return _huoLB;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self addSubview:self.idLB];

    self.UID.hidden = YES;
    self.idLB.frame = CGRectMake(47-3, 60, 130, 20);
    self.labelType.layer.borderColor = [MLControlsBaiColor CGColor];
    self.labelType.clipsToBounds = YES;
    _labelType.text = [MLRoomInformationModel currentAccount].name;
    _roomName.text = [MLRoomInformationModel currentAccount].room_name;
    [self.idLB setTitleColor:kWhiteColor forState:UIControlStateNormal];
    self.idLB.titleLabel.font = FONT_11;
    self.idLB.titleLabel.adjustsFontSizeToFitWidth = YES;

    if ([MLRoomInformationModel currentAccount].bright_num.length>0) {
        NSString *IDStr = [NSString stringWithFormat:@"ID:%@",[MLRoomInformationModel currentAccount].bright_num];
        [self.idLB setTitle:IDStr forState:UIControlStateNormal];
        [self.idLB setTitleColor:ML_BrightIDColor forState:UIControlStateNormal];
        [self.idLB setImage:ImageNamed(@"方我的靓号") forState:UIControlStateNormal];
        self.idLB.ba_padding = 5;
    }else{
        NSString *IDStr = [NSString stringWithFormat:@"ID:%@",[MLRoomInformationModel currentAccount].uid];
        [self.idLB setTitle:IDStr forState:UIControlStateNormal];
        [self.idLB setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [self.idLB setImage:ImageNamed(@"") forState:UIControlStateNormal];
        self.idLB.ba_padding = 0;
    }
    
    ///总钻石
    NSString *hotStr = [NSString stringWithFormat:@"  %@w  ",[MLRoomInformationModel currentAccount].hot];
    [self.huoLB setTitle:hotStr forState:UIControlStateNormal];
    
    self.idLB.ba_buttonLayoutType = BAKit_ButtonLayoutTypeLeftImageLeft;
    _heatNum.text = [MLRoomInformationModel currentAccount].hot;
    
    if ([[MLRoomInformationModel currentAccount].is_mykeep integerValue] == 1) {
        [self.collectionButton setImage:[UIImage imageNamed:@"room_shoucang"] forState:UIControlStateNormal];
    }else{
        [self.collectionButton setImage:[UIImage imageNamed:@"room_shoucang-1"] forState:UIControlStateNormal];
    }
    [self.publickBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [self.publickBtn setTitle:@"公告" forState:UIControlStateNormal];
    [self.publickBtn setImage:ImageNamed(@"room_laba") forState:UIControlStateNormal];
    self.publickBtn.titleLabel.font = FONT_14;
    self.publickBtn.ba_padding = 5;
    self.publickBtn.ba_buttonLayoutType = BAKit_ButtonLayoutTypeNormal;
    
    [self.labelType mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(16);
    }];
}

- (void)loadData:(id)obj{
    [super loadData:obj];
    _labelType.text = [MLRoomInformationModel currentAccount].name;
    _roomName.text = [MLRoomInformationModel currentAccount].room_name;
    NSLog(@"ssssss==%@",[MLRoomInformationModel currentAccount].roomAdmin);
}
- (IBAction)backClick:(UIButton *)sender {
    !self.blackClickBlock ? : self.blackClickBlock();
}
- (IBAction)announcementClick:(UIButton *)sender {
    !self.announcementClickBlock ?: self.announcementClickBlock();
}
- (IBAction)listClick:(UIButton *)sender {
    !self.listClickBlock ? : self.listClickBlock();
}
- (IBAction)collectionClick:(UIButton *)sender {
    if ([[MLRoomInformationModel currentAccount].is_mykeep integerValue] == 1) {
        [self.collectionButton setImage:[UIImage imageNamed:@"room_shoucang-1"] forState:UIControlStateNormal];
    }else{
        [self.collectionButton setImage:[UIImage imageNamed:@"room_shoucang"] forState:UIControlStateNormal];
    }
    !self.collectionClickBlock ?: self.collectionClickBlock();
}
- (IBAction)MoreAndMoreClick:(UIButton *)sender {
    !self.moreAndMoreClickBlock ? : self.moreAndMoreClickBlock();
}



@end
