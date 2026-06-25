//
//  EMO_UpLoadCardImgView.m
//  ARINASI
//
//  Created by 张世浩 on 2022/8/11.
//  Copyright © 2022 ZSH. All rights reserved.
//

#import "EMO_UpLoadCardImgView.h"

@interface EMO_UpLoadCardImgView()

@property(nonatomic,strong) UILabel * titleLabel;
@property(nonatomic,strong) UILabel * tipLabel;
@property(nonatomic,strong) UIImageView * zhengImgView;
@property(nonatomic,strong) UIImageView * fanImgView;
@property(nonatomic,strong) UIImageView * tipOneImgView;
@property(nonatomic,strong) UILabel * contentOneLabel;
@property(nonatomic,strong) UIImageView * tipTwoImgView;
@property(nonatomic,strong) UILabel * contentTwoLabel;
@property(nonatomic,strong) UIButton * zhengBtn;
@property(nonatomic,strong) UIButton * fanBtn;
@end


@implementation EMO_UpLoadCardImgView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        
    }
    return self;
}



-(void)initView{
    [self titleLabel];
    [self tipLabel];
    [self zhengImgView];
    [self tipOneImgView];
    [self contentOneLabel];
    [self fanImgView];
    [self tipTwoImgView];
    [self contentTwoLabel];
    [self zhengBtn];
    [self fanBtn];
    
}



- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = getLanguage(@"");
        _titleLabel.textColor = RGBA(51, 51, 51, 1);
        _titleLabel.font=KFont(16);
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_offset(KAdaptedWidth(18));
            make.trailing.mas_offset(KAdaptedWidth(-18));
            make.top.mas_offset(KAdaptedHeight(15));
            make.height.mas_offset(KAdaptedHeight(20));
            
        }];
    }
    return _titleLabel;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = getLanguage(@"");
        _tipLabel.textColor = RGBA(153, 153, 153, 1);
        _tipLabel.font=KFont(12);
        _tipLabel.numberOfLines=0;
        [self addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.titleLabel.mas_leading);
            make.trailing.mas_equalTo(self.titleLabel.mas_trailing);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(KAdaptedHeight(10));
            make.height.mas_equalTo(KAdaptedHeight(20));
            
        }];
    }
    return _tipLabel;
}

- (UIImageView*)zhengImgView{
    if (!_zhengImgView) {
        _zhengImgView = [[UIImageView alloc] init];
        _zhengImgView.backgroundColor=RGBA(246, 246, 246, 1);
        _zhengImgView.image=KGetImage(@"ICCardZImg");
        [self addSubview:_zhengImgView];
        [_zhengImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.titleLabel.mas_leading);
            make.trailing.mas_equalTo(self.titleLabel.mas_trailing);
//            make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(KAdaptedHeight(12));
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(KAdaptedHeight(10));
            make.height.mas_equalTo((200-KAdaptedWidth(18*2))*0.67);
            
        }];
        setViewCorner(_zhengImgView, 10);
    }
    return _zhengImgView;
}

- (UIImageView*)tipOneImgView{
    if (!_tipOneImgView) {
        _tipOneImgView = [[UIImageView alloc] init];
        _tipOneImgView.image=KGetImage(@"defaultUpImg");
        [self addSubview:_tipOneImgView];
        [_tipOneImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(21), KAdaptedHeight(19)));
            make.centerX.mas_offset(0);
            make.bottom.mas_equalTo(self.zhengImgView.mas_centerY);
            
        }];
    }
    return _tipOneImgView;
}


- (UILabel *)contentOneLabel{
    if (!_contentOneLabel) {
        _contentOneLabel = [[UILabel alloc] init];
        _contentOneLabel.text = getLanguage(@"");
        _contentOneLabel.textColor = RGBA(153, 153, 153, 1);
        _contentOneLabel.font=KFont(13);
        _contentOneLabel.numberOfLines=0;
        _contentOneLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_contentOneLabel];
        [_contentOneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.titleLabel.mas_leading);
            make.trailing.mas_equalTo(self.titleLabel.mas_trailing);
            make.top.mas_equalTo(self.tipOneImgView.mas_bottom).offset(KAdaptedHeight(12));
            make.height.mas_equalTo(KAdaptedHeight(40));
            
        }];
    }
    return _contentOneLabel;
}


- (UIButton *)zhengBtn{
    if (!_zhengBtn) {
        _zhengBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _zhengBtn.tag=100;
        [_zhengBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_zhengBtn];
        [_zhengBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.zhengImgView.mas_leading);
            make.trailing.mas_equalTo(self.zhengImgView.mas_trailing);
            make.top.mas_equalTo(self.zhengImgView.mas_top).offset(KAdaptedHeight(0));
            make.height.mas_equalTo(self.zhengImgView.mas_height);
            
        }];
    }
    return _zhengBtn;
}



- (UIImageView*)fanImgView{
    if (!_fanImgView) {
        _fanImgView = [[UIImageView alloc] init];
        _fanImgView.backgroundColor=RGBA(246, 246, 246, 1);
        _fanImgView.image=KGetImage(@"ICCardFImg");
        [self addSubview:_fanImgView];
        [_fanImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.zhengImgView.mas_leading);
            make.trailing.mas_equalTo(self.zhengImgView.mas_trailing);
            make.top.mas_equalTo(self.zhengImgView.mas_bottom).offset(KAdaptedHeight(15));
            make.height.mas_equalTo(self.zhengImgView.mas_height);
        }];
        setViewCorner(_fanImgView, 10);
    }
    return _fanImgView;
}


- (UIImageView*)tipTwoImgView{
    if (!_tipTwoImgView) {
        _tipTwoImgView = [[UIImageView alloc] init];
        _tipTwoImgView.image=KGetImage(@"defaultUpImg");
        [self addSubview:_tipTwoImgView];
        [_tipTwoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.tipOneImgView.mas_leading);
            make.trailing.mas_equalTo(self.tipOneImgView.mas_trailing);
            make.bottom.mas_equalTo(self.fanImgView.mas_centerY).offset(KAdaptedHeight(0));
            make.height.mas_equalTo(self.tipOneImgView.mas_height);
        }];
    }
    return _tipTwoImgView;
}


- (UILabel *)contentTwoLabel{
    if (!_contentTwoLabel) {
        _contentTwoLabel = [[UILabel alloc] init];
        _contentTwoLabel.text = getLanguage(@"");
        _contentTwoLabel.textColor = RGBA(153, 153, 153, 1);
        _contentTwoLabel.font=KFont(13);
        _contentTwoLabel.numberOfLines=0;
        _contentTwoLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_contentTwoLabel];
        [_contentTwoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.contentOneLabel.mas_leading);
            make.trailing.mas_equalTo(self.contentOneLabel.mas_trailing);
            make.top.mas_equalTo(self.tipTwoImgView.mas_bottom).offset(KAdaptedHeight(12));
            make.height.mas_equalTo(self.contentOneLabel.mas_height);
        }];
    }
    return _contentTwoLabel;
}



- (UIButton *)fanBtn{
    if (!_fanBtn) {
        _fanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _fanBtn.tag=200;
        [_fanBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_fanBtn];
        [_fanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.fanImgView.mas_leading);
            make.trailing.mas_equalTo(self.fanImgView.mas_trailing);
            make.top.mas_equalTo(self.fanImgView.mas_top).offset(KAdaptedHeight(0));
            make.height.mas_equalTo(self.fanImgView.mas_height);
        }];
    }
    return _fanBtn;
}


-(void)setTipDic:(NSDictionary *)tipDic{
    _tipDic=tipDic;
    self.titleLabel.text=[NSString stringWithFormat:@"%@",tipDic[@"title"]];
    self.tipLabel.text=[NSString stringWithFormat:@"%@",tipDic[@"tip"]];
    self.contentOneLabel.text=[NSString stringWithFormat:@"%@",tipDic[@"zhengTip"]];
    self.contentTwoLabel.text=[NSString stringWithFormat:@"%@",tipDic[@"fanTip"]];
    
}


-(void)setZMStr:(NSString *)ZMStr{
    _ZMStr=ZMStr;
    [self.zhengImgView sd_setImageWithURL:[NSURL URLWithString:ZMStr]];
    self.tipOneImgView.hidden=YES;
    self.contentOneLabel.hidden=YES;
    
}

-(void)setFMStr:(NSString *)FMStr{
    _FMStr=FMStr;
    [self.fanImgView sd_setImageWithURL:[NSURL URLWithString:FMStr]];
    self.tipTwoImgView.hidden=YES;
    self.contentTwoLabel.hidden=YES;
    
}

-(void)setStatus:(NSInteger)status{
    _status=status;
    if(status==1||status==2){
        self.zhengBtn.userInteractionEnabled=NO;
        self.fanBtn.userInteractionEnabled=NO;
    }else{
        self.zhengBtn.userInteractionEnabled=YES;
        self.fanBtn.userInteractionEnabled=YES;
    }
    
}

-(void)setSettleStatus:(NSInteger)settleStatus{
    _settleStatus=settleStatus;
    
    if(settleStatus==1||settleStatus==0||settleStatus==3||settleStatus==5){
        self.zhengBtn.userInteractionEnabled=NO;
        self.fanBtn.userInteractionEnabled=NO;
    }else{
        self.zhengBtn.userInteractionEnabled=YES;
        self.fanBtn.userInteractionEnabled=YES;
    }
    
    
}



-(void)BtnClick:(UIButton *)sender{
        WeakSelf;
    if (wself.SelectPhotoBlock) {
        wself.SelectPhotoBlock(sender.tag);
    }
    
//    WeakSelf(wself);
//    UIAlertController *alert=[UIAlertController alertControllerWithTitle:getLanguage(@"") message:getLanguage(@"") preferredStyle:UIAlertControllerStyleActionSheet];
//
//    [alert addAction:[UIAlertAction actionWithTitle:getLanguage(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//    }]];
//    [alert addAction:[UIAlertAction actionWithTitle:getLanguage(@"拍一张") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        if (wself.SelectPhotoBlock) {
//            wself.SelectPhotoBlock(sender.tag,YES);
//        }
//    }]];
//
//    [alert addAction:[UIAlertAction actionWithTitle:getLanguage(@"从相册选择") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        if (wself.SelectPhotoBlock) {
//            wself.SelectPhotoBlock(sender.tag,NO);
//        }
//    }]];
//    [[ToolsObject getCurrentViewController] presentViewController:alert animated:YES completion:nil];
//
}




@end
