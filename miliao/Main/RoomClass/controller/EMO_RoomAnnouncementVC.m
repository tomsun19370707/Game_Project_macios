//
//  EMO_RoomAnnouncementVC.m
//  miliao
//
//  Created by aa on 2019/7/4.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "EMO_RoomAnnouncementVC.h"
#import "Global.h"

@interface EMO_RoomAnnouncementVC () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *bgLabel;
@property (nonatomic, strong) UIButton *sendBtn;

@end

@implementation EMO_RoomAnnouncementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.backgroundColor = RGBA(248, 248, 248, 1);
    [self loadBar:YES needBack:YES needBackground:YES];
    self.titleLabel.text = getLanguage(@"房间公告");
    
    // 1. HUDContainer: 顶部导航栏配置“完成”操作项（永不被软键盘遮挡）
    self.rightTitleLabel.text = getLanguage(@"完成");
    
    // 2. 组装视图与 Masonry 约束布局 (SUAS/CVCS 规范)
    [self setupSubviews];
    
    if (self.announcementStr.length > 0) {
        self.textView.text = self.announcementStr;
        self.bgLabel.hidden = YES;
    }
}

- (void)setupSubviews {
    // ContentContainer: 输入文本框与占位标签
    [self.bgView addSubview:self.textView];
    [self.textView addSubview:self.bgLabel];
    
    // ActionContainer: 底部大操作按钮
    [self.bgView addSubview:self.sendBtn];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.barView.mas_bottom).offset(KAdaptedHeight(12));
        make.left.equalTo(self.bgView.mas_left).offset(KAdaptedWidth(15));
        make.right.equalTo(self.bgView.mas_right).offset(-KAdaptedWidth(15));
        make.height.mas_equalTo(KAdaptedHeight(200));
    }];
    
    [self.bgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_top).offset(KAdaptedHeight(10));
        make.left.equalTo(self.textView.mas_left).offset(KAdaptedWidth(12));
        make.right.lessThanOrEqualTo(self.textView.mas_right).offset(-KAdaptedWidth(12));
    }];
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(KAdaptedWidth(27.5));
        make.right.equalTo(self.bgView.mas_right).offset(-KAdaptedWidth(27.5));
        make.height.mas_equalTo(KAdaptedHeight(45));
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-KAdaptedHeight(36) - KSAFEAREA_BOTTOM_HEIHGHT);
    }];
}

#pragma mark - Actions

- (void)rightButtonClick:(UIButton *)sender {
    [self.view endEditing:YES];
    NSString *notice = self.textView.text ?: @"";
    if (self.announcementStrClickBlock) {
        self.announcementStrClickBlock(notice);
    }
    [self backClick];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    self.bgLabel.hidden = (textView.text.length > 0);
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    self.bgLabel.hidden = (textView.text.length > 0);
}

#pragma mark - Lazy Getters

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.font = Font(14);
        _textView.textColor = mainViceColor;
        _textView.delegate = self;
        _textView.layer.cornerRadius = 8;
        _textView.clipsToBounds = YES;
        _textView.textContainerInset = UIEdgeInsetsMake(10, 8, 10, 8);
        // 关键交互：支持手指在输入框上由上向下滑动时顺畅收起键盘，避免误触系统 Home 横条
        _textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _textView;
}

- (UILabel *)bgLabel {
    if (!_bgLabel) {
        _bgLabel = [[UILabel alloc] init];
        _bgLabel.text = getLanguage(@"写点什么吧...");
        _bgLabel.font = Font(13);
        _bgLabel.textColor = mainQianColor;
        _bgLabel.backgroundColor = [UIColor clearColor];
        _bgLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _bgLabel;
}

- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.backgroundColor = BaseMainColor;
        [_sendBtn setTitle:getLanguage(@"完成") forState:UIControlStateNormal];
        [_sendBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = KFont(15);
        [_sendBtn makeRoundCorner];
        _sendBtn.tag = 500;
        [_sendBtn addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
