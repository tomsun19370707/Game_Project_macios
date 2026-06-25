//
//  EMO_RoomFluctuationOfWheatView.m
//  miliao
//
//  Created by feifei on 2019/9/2.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "EMO_RoomFluctuationOfWheatView.h"

#import "MLRoomAdminModel.h"

@interface RoomFluctuationOfWheatCell : UITableViewCell

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *nickName;
//@property (nonatomic, strong) UILabel *uid;
@property (nonatomic, strong) UIButton *quDingButton;
//@property (nonatomic, strong) UIView *lineView;

@property (nonatomic , copy) void(^quDingButtonClickBlock)(MLRoomAdminModel *model);

@property (nonatomic, strong) MLRoomAdminModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;



@end

@implementation RoomFluctuationOfWheatCell

#pragma mark - 快速创建cell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"RoomFluctuationOfWheatCell";
    
    RoomFluctuationOfWheatCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[RoomFluctuationOfWheatCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        //        cell.selectedBackgroundView = cell.seletView ;
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSomeViews];
    }
    return self;
}

- (void)quDingButtonClick:(UIButton *)sender{
    ! self.quDingButtonClickBlock ?: self.quDingButtonClickBlock(self.model);
}
- (void)setModel:(MLRoomAdminModel *)model{
    _model = model;
//    if ([model.is_mic integerValue] == 1) {
//        self.bgView.hidden = YES;
//        [self.quDingButton setTitle:getLanguage(@"下麦") forState:UIControlStateNormal];
//    }else{
//        self.bgView.hidden = YES;
//        [self.quDingButton setTitle:getLanguage(@"上麦") forState:UIControlStateNormal];
//    }
    
    [self.quDingButton.titleLabel setFont:Font(13)];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"未加载头像"]];
    self.nickName.text = model.nickname;
//    self.uid.text = NSStringFormat(@"ID %@",model.userID);
}


- (void)addSomeViews{
    
    [self.contentView addSubview:self.bgView];
    
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.nickName];
//    [self.contentView addSubview:self.uid];
    [self.contentView addSubview:self.quDingButton];
//    [self.contentView addSubview:self.lineView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(5);
        make.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(12);
        make.right.mas_equalTo(self).offset(-12);
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
        make.height.mas_equalTo(50);
        make.left.mas_equalTo(self.bgView.mas_left).offset(10);
        make.width.mas_equalTo(50);
    }];
    [self.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).offset(10);
        make.centerY.mas_equalTo(self.icon.mas_centerY);
//        make.centerY.mas_equalTo(self.icon.mas_centerY).multipliedBy(0.7);
        
    }];
//    [self.uid mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.icon.mas_right).offset(10);
//        make.centerY.mas_equalTo(self.icon.mas_centerY).multipliedBy(1.2);
//    }];
    [self.quDingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-15);
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(75);
    }];
//    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self);
//        make.left.mas_equalTo(self.bgView).offset(13);
//        make.right.mas_equalTo(self).offset(-13);
//        make.height.mas_equalTo(1);
//    }];
}


- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:[UIColor whiteColor]];
        _bgView.layer.cornerRadius = 7;
        _bgView.layer.shadowOffset = CGSizeMake(0,1);
        _bgView.layer.masksToBounds = NO;
        _bgView.layer.shadowColor = mainQianColor.CGColor;
        _bgView.layer.shadowOpacity = 0.5f;
        _bgView.hidden = YES;
    }
    return _bgView;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [ControlCreator createImageView:self rect:CGRectMake(0, 0, 0, 0) imageName:@"未加载头像" backguoundColor:MLControlsHuiColor];
        _icon.layer.masksToBounds = YES;
        _icon.layer.cornerRadius = 25;
    }
    return _icon;
}
- (UILabel *)nickName{
    if (!_nickName) {
        _nickName = [ControlCreator createLabel:self rect:CGRectZero text:@"" font:Font(14)  color:mainViceColor backguoundColor:[UIColor clearColor] align:NSTextAlignmentLeft lines:1];
    }
    return _nickName;
}
//- (UILabel *)uid{
//    if (!_uid) {
//        _uid = [ControlCreator createLabel:self rect:CGRectZero text:@"ID:" font:Font(12) color:mainQianColor backguoundColor:[UIColor clearColor] align:NSTextAlignmentLeft lines:1];
//    }
//    return _uid;
//}
- (UIButton *)quDingButton{
    if (!_quDingButton) {
        _quDingButton = [ControlCreator createButton:self rect:CGRectZero text:getLanguage(@"邀请上麦") font:Font1(13) color:RGBA(51, 51, 51, 1) backguoundColor:nil imageName:@"" target:self action:@selector(quDingButtonClick:)];
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0,0,KAdaptedWidth(75),KAdaptedHeight(30));
        gl.startPoint = CGPointMake(0.5, 0);
        gl.endPoint = CGPointMake(0.5, 1);
        gl.colors = @[(__bridge id)RGBA(247, 212, 91, 0.59).CGColor,(__bridge id)RGBA(255, 238, 1, 1).CGColor];
        gl.locations = @[@(0.0),@(1.0f)];
        [_quDingButton.layer addSublayer:gl];
        _quDingButton.layer.masksToBounds = YES;
        _quDingButton.layer.cornerRadius = 15;
        [_quDingButton.layer insertSublayer:gl atIndex:0];
    }
    return _quDingButton;
}
//- (UIView *)lineView{
//    if (!_lineView) {
//        _lineView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:MLControlsHuiColor];
//    }
//    return _lineView;
//}


@end




@interface EMO_RoomFluctuationOfWheatView ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *maskBgView;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *titelLB;
@property (nonatomic, strong) UITextField *searchTF;


@end

@implementation EMO_RoomFluctuationOfWheatView

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    ! self.searchButtonClickBlock ?: self.searchButtonClickBlock(toBeString);
    return YES;
}

#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    if (_isSearch) {
        return 1;
//    }
//    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (_isSearch) {
//        return self.searchArry.count;
//    }else{
//        if (section == 0) {
//            return self.mic_user.count;
//        }
        return self.room_user.count;
//    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RoomFluctuationOfWheatCell *cell = [RoomFluctuationOfWheatCell cellWithTableView:tableView];
//    if (_isSearch) {
//        cell.model = self.searchArry[indexPath.row];
//    }else{
//        if (indexPath.section == 0) {
//            cell.model = self.mic_user[indexPath.row];
//        }else{
            cell.model = self.room_user[indexPath.row];
//        }
//    }
    
    cell.quDingButtonClickBlock = ^(MLRoomAdminModel *model) {
        [self removeFromSuperview];
        ! self.quDingButtonClickBlock ?: self.quDingButtonClickBlock(model);
    };
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *headerView = [ControlCreator createView:nil rect:CGRectMake(0, 0, ScreenViewWidth, 40) backguoundColor:[UIColor whiteColor]];
//    UILabel *headerLB = [ControlCreator createLabel:headerView rect:CGRectMake(12, 10, ScreenViewWidth, 20) text:@"" font:Font(14) color:mainViceColor backguoundColor:[UIColor clearColor] align:NSTextAlignmentLeft lines:1];
//    if (_isSearch) {
//        return nil;
//    }
//    if (section == 0) {
//        headerLB.text = NSStringFormat(@"%@%lu/8",getLanguage(@"麦上用户"),(unsigned long)self.mic_user.count);
//    }else{
//        headerLB.text = NSStringFormat(@"%@%lu%@",getLanguage(@"麦下用户"),(unsigned long)self.room_user.count,getLanguage(@"人"));
//    }
    UIView *headerView = [ControlCreator createView:nil rect:CGRectMake(0, 0, ScreenViewWidth, 1) backguoundColor:[UIColor clearColor]];
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
}

#pragma mark -
#pragma mark Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (_isSearch) {
        return 0.001;
//    }
//    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (void)singleTapGesture:(UITapGestureRecognizer *)tap{
    [self removeFromSuperview];
}

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self setUpUI];
    }
    return self;
}
- (void)setUpUI{
    
    [self addSubview:self.maskView];
    [self addSubview:self.bgView];
    [self addSubview:self.maskBgView];
    [self.bgView addSubview:self.titelLB];
//    [self.bgView addSubview:self.searchTF];
    [self.bgView addSubview:self.tableView];
    
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(400);
    }];
    [self.maskBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bgView.mas_top);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(self);
    }];
    [self.titelLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_top).offset(15);
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
    }];
//    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.titelLB.mas_bottom).offset(14);
//        make.left.mas_equalTo(self.bgView).offset(22);
//        make.right.mas_equalTo(self.bgView).offset(-22);
//        make.height.mas_equalTo(35);
//    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.searchTF.mas_bottom).offset(10);
        make.top.mas_equalTo(self.titelLB.mas_bottom).offset(14);
        make.left.mas_equalTo(self.bgView);
        make.right.mas_equalTo(self.bgView);
        make.bottom.mas_equalTo(self.bgView);
    }];
}

#pragma mark - getter methodsb
- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:[UIColor blackColor]];
        _maskView.alpha = 0.6;
    }
    return _maskView;
}
- (UIView *)maskBgView{
    if (!_maskBgView) {
        _maskBgView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:[UIColor clearColor]];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
        [_maskBgView addGestureRecognizer:singleTap];
    }
    return _maskBgView;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:RGBA(255, 255, 255, 0.95)];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 15;
    }
    return _bgView;
}
- (UILabel *)titelLB{
    if (!_titelLB) {
        _titelLB = [ControlCreator createLabel:nil rect:CGRectZero text:@"邀请上麦" font:Font(15) color:[UIColor blackColor] backguoundColor:[UIColor clearColor] align:NSTextAlignmentCenter lines:1];
    }
    return _titelLB;
}

- (UITextField *)searchTF{
    if (!_searchTF) {
        _searchTF = [ControlCreator createTextField:nil rect:CGRectMake(0, 0, 0, 0) placeholder:@"输入用户ID" placeholderColor:nil text:@"" font:Font(12) color:mainViceColor backguoundColor:MHColorFromHexString(@"#F8F8F8")];
        _searchTF.delegate = self;
        _searchTF.layer.masksToBounds = YES;
        _searchTF.layer.cornerRadius = 17.5;
        _searchTF.keyboardType = UIKeyboardTypeNumberPad;
        UIView *leftTFView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 35)];
        leftTFView.backgroundColor = [UIColor clearColor];
        _searchTF.leftView = leftTFView;
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _searchTF;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundView = nil;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = RGBA(255, 255, 255, 0.95);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor=[UIColor clearColor];
    }
    return _tableView;
}
- (void)setMic_user:(NSArray *)mic_user{
    _mic_user = mic_user;
    [self.tableView reloadData];
}
- (void)setRoom_user:(NSArray *)room_user{
    _room_user = room_user;
    [self.tableView reloadData];
}
- (void)setSearchArry:(NSArray *)searchArry{
    _searchArry = searchArry;
    [self.tableView reloadData];
}

@end
