//
//  YYF_ChatListTableViewCell.m
//  miliao
//
//  Created by 张世浩 on 2022/11/14.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "YYF_ChatListTableViewCell.h"

@interface YYF_ChatListTableViewCell ()
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UILabel *numLabel;
@property (nonatomic,strong)UIImageView *IconImageView;

@end



@implementation YYF_ChatListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self IconImageView];
        [self lineView];
        [self nameLabel];
        [self contentLabel];
        [self timeLabel];
        [self numLabel];
        self.numLabel.hidden=YES;
        self.backgroundColor=kWhiteColor;
        [self addData];
    }
    return self;
}

-(void)setModel:(RCConversationModel *)model{
    [super setModel:model];
    NSLog(@"%@",model);

    
    
//    [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:userId completion:^(RCUserInfo *userInfo) {
//        NSString *displayName = [RCKitUtility getDisplayName:userInfo];
//        if (displayName.length) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [wselfrealTimeLocationStatusView updateText:[NSString stringWithFormat:RTLLocalizedString(@"someone_location_sharing"), displayName]];
//            });
//        }
//    }];

    
}





-(UIImageView *)IconImageView{
    if (!_IconImageView) {
        _IconImageView=[[UIImageView alloc] init];
        _IconImageView.image=KGetImage(@"messageLettersImmg");
        _IconImageView.layer.cornerRadius=KAdaptedWidth(45/2);
        _IconImageView.layer.masksToBounds=YES;
        [self.contentView addSubview:_IconImageView];
        [_IconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(KAdaptedWidth(45));
//            make.leading.mas_equalTo(KAdaptedWidth(25));
//            make.leading.mas_equalTo(KAdaptedWidth(10));
            make.leading.mas_equalTo(10);
            make.centerY.mas_equalTo(0);
            
        }];
    }
    return _IconImageView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGBA(23, 232, 0, 1);
        [self.contentView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.IconImageView.mas_bottom).offset(KAdaptedHeight(3));
            make.trailing.mas_equalTo(self.IconImageView.mas_trailing).offset(KAdaptedHeight(-10));
            make.width.height.mas_equalTo(KAdaptedWidth(8));
        }];
        setViewCorner(_lineView, KAdaptedWidth(4));
    }
    return _lineView;
}


-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[[UILabel alloc] init];
        _nameLabel.textColor=RGBA(254, 123, 120, 1); //  RGBA(51, 51, 51, 1);
        _nameLabel.font=KFontBold(14);
        _nameLabel.text=getLanguage(@"我的信件");
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.IconImageView.mas_top).offset(KAdaptedHeight(0));
            make.leading.mas_equalTo(self.IconImageView.mas_trailing).offset(KAdaptedWidth(9));
            make.trailing.mas_equalTo(KAdaptedWidth(-kWidth/4));
            make.bottom.mas_equalTo(self.IconImageView.mas_centerY);
            
        }];
    }
    return _nameLabel;
}

-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel=[[UILabel alloc] init];
        _contentLabel.textColor=RGBA(102, 102, 102, 1);
        _contentLabel.font=KFont(12);
        _contentLabel.text=getLanguage(@"暂无未读信件");
        [self.contentView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(KAdaptedHeight(0));
            make.leading.mas_equalTo(self.nameLabel.mas_leading).offset(KAdaptedWidth(0));
            make.trailing.mas_equalTo(self.nameLabel.mas_trailing);
            make.bottom.mas_equalTo(self.IconImageView.mas_bottom);
            
        }];
    }
    return _contentLabel;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel=[[UILabel alloc] init];
        _timeLabel.textColor=RGBA(153, 153, 153, 1);
        _timeLabel.font=KFont(10);
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM-dd"];
//        NSString *dateTime=[formatter stringFromDate:[NSDate date]];
        _timeLabel.text=[formatter stringFromDate:[NSDate date]];
        _timeLabel.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_top).offset(KAdaptedHeight(0));
            make.leading.mas_equalTo(self.nameLabel.mas_trailing).offset(KAdaptedWidth(0));
//            make.trailing.mas_equalTo(KAdaptedWidth(-25));
            make.trailing.mas_equalTo(-10);
            make.bottom.mas_equalTo(self.nameLabel.mas_bottom);
            
        }];
    }
    return _timeLabel;
}

-(UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel=[[UILabel alloc] init];
        _numLabel.textColor=RGBA(102, 102, 102, 1);
        _numLabel.font=KFontBold(10);
//        _numLabel.backgroundColor=Kred_color;
//        _numLabel.layer.cornerRadius=KAdaptedWidth(15/2);
//        _numLabel.layer.masksToBounds=YES;
        _numLabel.text=@"0";
        _numLabel.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:_numLabel];
        [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.timeLabel.mas_trailing);
            make.centerY.mas_equalTo(self.contentLabel.mas_centerY);
            make.height.mas_equalTo(KAdaptedHeight(15));
            make.width.mas_equalTo(KAdaptedWidth(20));
//            make.top.mas_equalTo(self.contentLabel.mas_top).offset(KAdaptedHeight(0));
//            make.leading.mas_equalTo(self.contentLabel.mas_trailing).offset(KAdaptedWidth(0));
//            make.bottom.mas_equalTo(self.nameLabel.mas_bottom);
            
        }];
    }
    return _numLabel;
}

-(void)addData{
//    
//    [[[ZWW_AFNetworking alloc] init] getWithUrlAAA:@"app/letter/selectUnreadCount" dict:nil succed:^(id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//        if ([responseObject[@"code"] intValue]==0) {
//            if ([responseObject[@"data"] integerValue]>0) {
//                self->_contentLabel.text=[NSString stringWithFormat:@"%@条未读信件",responseObject[@"data"]];
//                self.numLabel.hidden=NO;
//                self->_numLabel.text=[NSString stringWithFormat:@"%@",responseObject[@"data"]];
//            }else{
//                self.numLabel.hidden=YES;
//                self->_contentLabel.text=getLanguage(@"暂无未读信件");
//            }
//  
//        }else{
//            [ToolsObject addPopVieToText:[NSString stringWithFormat:@"%@",responseObject[@"message"]]];
//        }
//    } errorBlock:^(NSError * _Nullable error) {
//        NSLog(@"%@",error);
//        [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"网络不可用")];
//        
//    }];
//    
//    
    
    
}




@end
