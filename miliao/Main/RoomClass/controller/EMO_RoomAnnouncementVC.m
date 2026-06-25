//
//  EMO_RoomAnnouncementVC.m
//  miliao
//
//  Created by aa on 2019/7/4.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "EMO_RoomAnnouncementVC.h"

#import "Global.h"

@interface EMO_RoomAnnouncementVC ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *bgLabel;

Strong UIButton *sendBtn;

@end

@implementation EMO_RoomAnnouncementVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor=RGBA(248, 248, 248, 1);
    self.bgView.backgroundColor=RGBA(248, 248, 248, 1);
    [self loadBar:YES needBack:YES needBackground:YES];
    self.titleLabel.text = getLanguage(@"房间公告");
    [self.bgView addSubview:self.textView];
    [self.textView addSubview:self.bgLabel];
    self.textView.text = self.announcementStr;
    
    [self sendBtn];
}

- (void)rightButtonClick:(UIButton *)sender{
    ! self.announcementStrClickBlock ?: self.announcementStrClickBlock(self.textView.text);
    [self backClick];
}
- (void)textViewDidChangeSelection:(UITextView *)textView{
    if (textView.text.length > 0) {
        self.bgLabel.hidden = YES;
    }else{
        self.bgLabel.hidden = NO;
    }
}


- (UITextView *)textView{
    if (!_textView) {
        _textView = [ControlCreator createTextView:self.bgView rect:CGRectMake(12, self.barView.bottom + 10, ScreenViewWidth - 24, 250) text:@"" font:Font(14) color:mainViceColor backguoundColor:[UIColor whiteColor]];
        _textView.delegate = self;
//        _textView.layer.shadowOffset = CGSizeMake(0,1);
//        _textView.layer.masksToBounds = NO;
//        _textView.layer.shadowColor = mainQianColor.CGColor;
//        _textView.layer.shadowOpacity = 0.5f;
//        _textView.layer.cornerRadius = 7;
    }
    return _textView;
}
- (UILabel *)bgLabel{
    if (!_bgLabel) {
        _bgLabel = [ControlCreator createLabel:self.textView rect:CGRectMake(8, 8, 100, 15) text:getLanguage(@"写点什么吧...") font:Font(13) color:mainQianColor backguoundColor:[UIColor whiteColor] align:NSTextAlignmentLeft lines:1];
    }
    return _bgLabel;
}



- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _sendBtn.frame=CGRectMake(KAdaptedWidth(27.5), kHeight-KAdaptedHeight(36+50)-KSAFEAREA_BOTTOM_HEIHGHT, kWidth-KAdaptedWidth(55), KAdaptedHeight(45));
        
        _sendBtn.backgroundColor = BaseMainColor ;
        [_sendBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_sendBtn makeRoundCorner];
        
            [_sendBtn setTitle:getLanguage(@"完成") forState:UIControlStateNormal];
        _sendBtn.titleLabel.font=KFont(15);
        _sendBtn.tag=500;
        [_sendBtn addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_sendBtn];
    }
    return _sendBtn;
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
