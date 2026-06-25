//
//  EMO_DoubleClickView.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/28.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_DoubleClickView.h"

@interface EMO_DoubleClickView ()
Strong UILabel *numLabel;
Strong UILabel *tipLabel;
Strong UIButton *clickBtn;


@end

@implementation EMO_DoubleClickView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.userInteractionEnabled=YES;
    }
    return self;
}


-(void)initView{
    self.num=0;
    [self numLabel];
    [self tipLabel];
    [self clickBtn];
    
}
- (UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.text = @"0";
        _numLabel.font=KFont(12);
        _numLabel.textColor = RGBA(255, 255, 255, 1);
        _numLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_numLabel];
        [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(KAdaptedWidth(60));
            make.top.mas_equalTo(KAdaptedWidth(0));
            make.height.mas_equalTo(KAdaptedHeight(30));
        }];
    }
    return _numLabel;
}


- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"连击";
        _tipLabel.font=KFontBold(22);
        _tipLabel.textColor = RGBA(255, 255, 255, 1);
        _tipLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(0);
            make.width.mas_equalTo(KAdaptedWidth(60));
            make.height.mas_equalTo(KAdaptedWidth(40));
        }];
    }
    return _tipLabel;
}



- (UIButton *)clickBtn{
    if (!_clickBtn) {
        _clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clickBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_clickBtn];
        [_clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(0);
        }];
    }
    return _clickBtn;
}

-(void)setNum:(NSInteger)num{
    _num=num;
    self.numLabel.text=@"0";
}

-(void)btnClick{
    self.num++;
    self.numLabel.text=[NSString stringWithFormat:@"%ld",self.num];
    if(self.numBlock){
        self.numBlock(self.num);
    }
}






@end
