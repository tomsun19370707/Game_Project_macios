//
//  RoomPasswordView.m
//  miliao
//
//  Created by aa on 2019/7/1.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "RoomPasswordView.h"

//#import "MLRoomModel.h"
#import "CRBoxInputView.h"
@interface RoomPasswordView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *promptView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *promptLB;

@property (nonatomic, strong) CRBoxInputView *passWordView;

@end


@implementation RoomPasswordView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setUpUI];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

//- (void)setModel:(MLRoomModel *)model{
//    _model = model;
//    WEAK_SELF
//    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.room_cover]];
//    self.promptLB.text = @"房间已上锁，请输入密码";
//    self.passWordView.textDidChangeblock = ^(NSString *text, BOOL isFinished) {
//        MYLog(@"%ld",text.length);
//        if (text.length == 4) {
//            [weakSelf removeFromSuperview];
//            ! weakSelf.sendSeBlock ?: weakSelf.sendSeBlock(model, text);
//            [weakSelf.passWordView clearAll];
//        }
//    };
//}

-(void)setDicModel:(NSDictionary *)dicModel{
    _dicModel = dicModel;
    WEAK_SELF
    [self.icon sd_setImageWithURL:[NSURL URLWithString:dicModel[@"room_cover"]]];
    self.promptLB.text = @"房间已上锁，请输入密码";
    self.passWordView.textDidChangeblock = ^(NSString *text, BOOL isFinished) {
        MYLog(@"%ld",text.length);
        if (text.length == 4) {
            [weakSelf removeFromSuperview];
            ! weakSelf.sendDicSeBlock ?: weakSelf.sendDicSeBlock(dicModel, text);
            [weakSelf.passWordView clearAll];
        }
    };
    
}


- (void)singleTapGesture:(UITapGestureRecognizer *)tap{
    [self removeFromSuperview];
}
- (void)setUpUI{
    [self addSubview:self.bgView];
    [self addSubview:self.promptView];
    [self.promptView addSubview:self.icon];
    [self.promptView addSubview:self.promptLB];
    [self.promptView addSubview:self.passWordView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
    }];
    [self.promptView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(38);
        make.right.mas_equalTo(self).offset(-38);
        make.height.mas_equalTo(210);
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(29);
        make.centerX.mas_equalTo(self.promptView);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(55);
    }];
    [self.promptLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.icon.mas_bottom).offset(15);
        make.centerX.mas_equalTo(self.promptView);
    }];
    [self.passWordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.promptLB.mas_bottom).offset(15);
//        make.centerX.mas_equalTo(self.promptView);
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-35);
        make.height.mas_equalTo(50);
    }];
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.5;
    }
    return _bgView;
}
- (UIView *)promptView{
    if (!_promptView) {
        _promptView = [[UIView alloc] init];
        _promptView.backgroundColor = [UIColor whiteColor];
        _promptView.layer.masksToBounds = YES;
        _promptView.layer.cornerRadius = 7;
    }
    return _promptView;
}
- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.layer.masksToBounds = YES;
        _icon.layer.cornerRadius = 27.5;
    }
    return _icon;
}
- (UILabel *)promptLB{
    if (!_promptLB) {
        _promptLB = [ControlCreator createLabel:nil rect:CGRectMake(0, 0, 0, 0) text:@"" font:Font(15) color:MHColorFromHexString(@"#000000") backguoundColor:[UIColor whiteColor] align:NSTextAlignmentCenter lines:1];
    }
    return _promptLB;
}

- (CRBoxInputView *)passWordView{
    if (!_passWordView) {
        _passWordView = [[CRBoxInputView alloc] init];
        CRBoxInputCellProperty *cellProperty = [CRBoxInputCellProperty new];
        cellProperty.cellCursorColor = MLControlsHuiColor;;
        cellProperty.cellCursorWidth = 2;
        cellProperty.cellCursorHeight = 27;
        cellProperty.cornerRadius = 0;
        cellProperty.borderWidth = 0;
        cellProperty.cellFont = [UIFont boldSystemFontOfSize:24];
        cellProperty.cellTextColor = [UIColor redColor];
        cellProperty.ifShowSecurity = YES;
        cellProperty.showLine = YES;
        cellProperty.customLineViewBlock = ^CRLineView * _Nonnull{
            CRLineView *lineView = [CRLineView new];
            lineView.lineView.backgroundColor = MLControlsHuiColor;
            [lineView.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(1);
                make.left.right.bottom.offset(0);
            }];
            
            return lineView;
        };
        cellProperty.securitySymbol = @"*";
        _passWordView.customCellProperty = cellProperty;
        _passWordView.ifNeedSecurity = YES;
        [_passWordView loadAndPrepareViewWithBeginEdit:YES];
    }
    return _passWordView;
}



@end
