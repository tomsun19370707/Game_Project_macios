//
//  EMO_RoomTopView.m
//  miliao
//
//  Created by 张世浩 on 2022/10/19.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_RoomTopView.h"

@interface EMO_RoomTopView()

Strong UIButton *backBtn;
Strong UILabel *nameLabel;
Strong UILabel *typeLabel;
Strong UILabel *IDLabel;

Strong UIButton *collectionBtn;

Strong UIButton *moreBtn;


@end


@implementation EMO_RoomTopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

-(void)initView{
    [self backBtn];
    [self nameLabel];
    [self typeLabel];
    [self IDLabel];
    [self hotBtn];
    [self moreBtn];
    [self collectionBtn];
    
 
    
    self.nameLabel.text = [MLRoomInformationModel currentAccount].name;
    if ([[MLRoomInformationModel currentAccount].is_collect integerValue] == 1) {
        self.collectionBtn.selected = YES;
    }else{
        self.collectionBtn.selected = NO;
    }

    ///观众
    if ([[MLRoomInformationModel currentAccount].user_type integerValue] == 0) {
        
        [self.hotBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(70), KAdaptedHeight(25)));
            make.leading.mas_equalTo(self.IDLabel.mas_trailing).offset(KAdaptedWidth(0));
            make.centerY.mas_equalTo(self.IDLabel.mas_centerY);
        }];
        [self.hotBtn layoutIfNeeded];
    }
    
    [_hotBtn setTitle:[NSString stringWithFormat:@" %@",[MLRoomInformationModel currentAccount].heat] forState:UIControlStateNormal];
    
//    CGSize aaa=[NSStringFormat(@"%@", [MLRoomInformationModel currentAccount].room_name) sizeWithFont:Font(15) With:KAdaptedWidth(90)];
//    NSLog(@"%ld",aaa);
    
    [self.backBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0);
    }];
    
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([NSStringFormat(@"%@", [MLRoomInformationModel currentAccount].name) sizeWithFont:Font(15) With:KAdaptedWidth(90)].width+KAdaptedWidth(15));
        make.leading.mas_equalTo(self.backBtn.mas_trailing).offset(KAdaptedWidth(0));
    
    }];
    [self.nameLabel layoutIfNeeded];
    
    self.backBtn.hidden=YES;
    
    
}
- (void)loadData{
    self.nameLabel.text = [MLRoomInformationModel currentAccount].name;
    
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([NSStringFormat(@"%@", [MLRoomInformationModel currentAccount].name) sizeWithFont:Font(15) With:KAdaptedWidth(90)].width+KAdaptedWidth(15));
    }];
    [self.nameLabel layoutIfNeeded];
    
    ///观众
    if ([[MLRoomInformationModel currentAccount].user_type integerValue] == 0) {
        [self.hotBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(70), KAdaptedHeight(25)));
            make.leading.mas_equalTo(self.IDLabel.mas_trailing).offset(KAdaptedWidth(0));
            make.centerY.mas_equalTo(self.IDLabel.mas_centerY);
        }];
        [self.hotBtn layoutIfNeeded];
        
    }
    ///管理员
    if ([[MLRoomInformationModel currentAccount].user_type integerValue] == 2) {
        [self.hotBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(70), KAdaptedHeight(25)));
            make.leading.mas_equalTo(self.IDLabel.mas_trailing).offset(KAdaptedWidth(0));
            make.centerY.mas_equalTo(self.IDLabel.mas_centerY);
        }];
        [self.hotBtn layoutIfNeeded];
    }
}



-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_backBtn setImage:KGetImage(@"backWhiteImg") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
            make.centerY.mas_equalTo(self.mas_centerY);
            
        }];
    }
    return _backBtn;
}
-(void)backClick{
    [[Common getCurrentVC].navigationController popToRootViewControllerAnimated:YES];
}




- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = getLanguage(@"~昵称~");
        _nameLabel.textColor = kWhiteColor;
        _nameLabel.font=KFont(15);
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(KAdaptedHeight(25));
            make.leading.mas_equalTo(self.backBtn.mas_trailing).offset(KAdaptedWidth(10));
            make.bottom.mas_equalTo(self.backBtn.mas_centerY);
            make.width.mas_equalTo(KAdaptedWidth(90));
        }];
    }
    return _nameLabel;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.backgroundColor=RGBA(0, 0, 0, 0.2);
        _typeLabel.text = [Common isNull:[MLRoomInformationModel currentAccount].partition_name];
        _typeLabel.textColor = RGBA(199, 201, 223, 1);
        _typeLabel.font=KFont(12);
        _typeLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_typeLabel];
        [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(KAdaptedHeight(0));
            make.leading.mas_equalTo(self.nameLabel.mas_leading).offset(KAdaptedWidth(0)).offset(KAdaptedWidth(-5));
            make.height.mas_equalTo(KAdaptedHeight(20));
            make.width.mas_equalTo(KAdaptedWidth(45));
        }];
        setViewCorner(_typeLabel, KAdaptedHeight(20)/2);
    }
    return _typeLabel;
}


- (UILabel *)IDLabel{
    if (!_IDLabel) {
        _IDLabel = [[UILabel alloc] init];
        _IDLabel.text = getLanguage(@"ID:");
        _IDLabel.textColor = RGBA(255, 255, 255, 1);
        _IDLabel.font=KFont(12);
        [self addSubview:_IDLabel];
        [_IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.typeLabel.mas_top).offset(KAdaptedHeight(0));
            make.leading.mas_equalTo(self.typeLabel.mas_trailing).offset(KAdaptedWidth(3));
            make.bottom.mas_equalTo(self.typeLabel.mas_bottom).offset(KAdaptedHeight(0));
            make.width.mas_equalTo(KAdaptedWidth(55));
        }];
    }
    return _IDLabel;
}

- (UIButton *)hotBtn{
    if (!_hotBtn) {
        _hotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hotBtn setImage:[UIImage imageNamed:@"hotIconImg"] forState:UIControlStateNormal];
        [_hotBtn setTitle:@" 0" forState:UIControlStateNormal];
        _hotBtn.titleLabel.font=KFont(12);
//        _hotBtn.layer.contents = (id) KGetImage(@"hotBgImg").CGImage;    // 如果需要背景透明加上下面这句
//        _hotBtn.layer.backgroundColor = [UIColor clearColor].CGColor;
        
//        _hotBtn.tag=666;
//        [_hotBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _hotBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [self addSubview:_hotBtn];
        [_hotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(70), KAdaptedHeight(20)));
            make.leading.mas_equalTo(self.IDLabel.mas_trailing).offset(KAdaptedWidth(3));
            make.centerY.mas_equalTo(self.IDLabel.mas_centerY);
        }];
    }
    return _hotBtn;
}


- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setImage:[UIImage imageNamed:@"moreImg"] forState:UIControlStateNormal];
        _moreBtn.tag=300;
        [_moreBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_moreBtn];
        [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(30), KAdaptedHeight(25)));
            make.trailing.mas_equalTo(KAdaptedWidth(-8));
            make.centerY.mas_equalTo(self.backBtn.mas_centerY);
            
        }];
    }
    return _moreBtn;
}

- (UIButton *)collectionBtn{
    if (!_collectionBtn) {
        _collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectionBtn setImage:[UIImage imageNamed:@"collectionImg"] forState:UIControlStateNormal];
        [_collectionBtn setImage:[UIImage imageNamed:@"selectCollectionImg"] forState:UIControlStateSelected];
        _collectionBtn.tag=100;
        [_collectionBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_collectionBtn];
        [_collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(25), KAdaptedHeight(18)));
            make.trailing.mas_equalTo(self.moreBtn.mas_leading).offset(KAdaptedWidth(-8));
            make.centerY.mas_equalTo(self.moreBtn.mas_centerY);
            
        }];
    }
    return _collectionBtn;
}



-(void)BtnClick:(UIButton *)sender{
    if(sender.tag==100){
        if ([[MLRoomInformationModel currentAccount].is_collect intValue] == 1) {
            [self collectionClick:1];
        }else{
            [self collectionClick:0];
        }
        return;
    }
    
    
    if(self.BtnClickBlock){
        self.BtnClickBlock(sender.tag);
    }
    
}

//收藏
- (void)collectionClick:(NSInteger)A{
    
    
    [NetworkRequest POST:Request_CollectRoom parmeters:@{@"room_id":[MLRoomInformationModel currentAccount].room_id} success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        if(A==0){
            [MLRoomInformationModel currentAccount].is_collect = @"1";
            self.collectionBtn.selected=YES;
        }else{
            [MLRoomInformationModel currentAccount].is_collect = @"2";
            self.collectionBtn.selected=NO;
        }
       
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:basemodel.msg];
    } failture:^(NSError *error) {
        
    }];

}


-(void)setUidSet:(NSString *)uidSet
{
//    NSString *IDStr = [NSString stringWithFormat:@"ID:%@",[MLRoomInformationModel currentAccount].uuid];
//    self.IDLabel.text=IDStr;
//    
//    /** 更改为显示用户的id*/
//    MLRoomInformationModel *currentRoom=[MLRoomInformationModel currentAccount];
//    self.IDLabel.text = [NSString stringWithFormat:@"ID:%@",currentRoom.userinfo[@"id"]];
//    if ([NSString NotNull:currentRoom.uid]) {
//        self.IDLabel.text = [NSString stringWithFormat:@"ID:%@",currentRoom.uid];
//    }
    
    self.IDLabel.text = [NSString stringWithFormat:@"ID:%@",uidSet];
    
    CGFloat idWid = [NSString widthForContent:self.IDLabel.text font:self.IDLabel.font] + 5;
    [self.IDLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(idWid);
    }];
}

@end
