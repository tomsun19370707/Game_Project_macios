//
//  SessageSetTableViewCell.m
//  miliao
//
//  Created by feifei on 2019/8/3.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "SessageSetTableViewCell.h"


@interface SessageSetTableViewCell ()

@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UIButton *topButton;
//@property(nonatomic,strong) UISwitch * switchBtn;
@property(nonatomic,strong) UIButton * switchBtn;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) BOOL addNow;

@property (nonatomic, assign) BOOL btnStatus;

@end


@implementation SessageSetTableViewCell

#pragma mark - 快速创建cell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"SessageSetTableViewCell";
    
    SessageSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[SessageSetTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        //        cell.selectedBackgroundView = cell.seletView ;
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.contentView.userInteractionEnabled=YES;
        cell.userInteractionEnabled=YES;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSomeViews];
        [self setUpLayouts];
    }
    return self;
}
- (void)addSomeViews{
    [self.contentView addSubview:self.titleLB];
//    [self.contentView addSubview:self.topButton];
    [self.contentView addSubview:self.switchBtn];
    [self.contentView addSubview:self.lineView];
}
- (void)setUpLayouts{
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(12);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//    }];
//
//    [self.topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-20);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(50);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self);
        make.centerX.mas_equalTo(self);
    }];
}



//- (void) switchChange:(UISwitch*)sw {
-(void)switchChangeBtn:(UIButton*)sw {
//}
//
//- (void)setConversationToTop:(UIButton *)sender{
    
    
    
    
    
    if ([self.type isEqualToString:@"black"]) {
        
        [NetworkRequest POST:Request_GetfollowOrBlack parmeters:@{@"type":@"1",@"to_uid":self.ryUserID} success:^(id responObject) {
            BaseModel *baseModel = (BaseModel *)responObject;
            [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:baseModel.msg]];
            if (self.addNow) {
                
                [[RCCoreClient sharedCoreClient] removeFromBlacklist:self.ryUserID success:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.switchBtn.layer.contents=(id)KGetImage(@"switchOffImg").CGImage;
//                        self.switchBtn.on=false;
                        self.btnStatus=false;
                        self.addNow=!self.addNow;
                        if (self.addBlock) {
                            self.addBlock(NO);
                        }
                    });
                   
                } error:^(RCErrorCode status) {
                    
                }];

            }else{
                
                [[RCCoreClient sharedCoreClient] addToBlacklist:self.ryUserID success:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.switchBtn.layer.contents=(id)KGetImage(@"switchOnImg").CGImage;
//                        self.switchBtn.on=true;
                        self.btnStatus=YES;
                        self.addNow=!self.addNow;
                        if (self.addBlock) {
                            self.addBlock(YES);
                        }
                    });
                } error:^(RCErrorCode status) {
        
                }];
                        
            }
            
            
            
        } failture:^(NSError *error) {
            
        }];
        
        
//        if (self.addBlock) {
//            self.addBlock(self.addNow);
//        }
//        return;
        
        
  
    }else{
        //获取单个会话数据
        RCConversation *conversation = [[RCCoreClient sharedCoreClient] getConversation:ConversationType_PRIVATE targetId:self.ryUserID];
        if (conversation.isTop) {
//            [self.topButton setImage:[UIImage imageNamed:@"kaiguan_guan"] forState:UIControlStateNormal];
//            self.switchBtn.on=false;
            self.btnStatus=NO;
            self.switchBtn.layer.contents=(id)KGetImage(@"switchOffImg").CGImage;
        }else{
//            [self.topButton setImage:[UIImage imageNamed:@"kaiguan_kai"] forState:UIControlStateNormal];
//            self.switchBtn.on=true;
            self.btnStatus=YES;
            self.switchBtn.layer.contents=(id)KGetImage(@"switchOnImg").CGImage;
        }
        [[RCCoreClient sharedCoreClient] setConversationToTop:ConversationType_PRIVATE targetId:self.ryUserID isTop:!conversation.isTop];
    }
    
    
   
}

- (void)setRyUserID:(NSString *)ryUserID{
    _ryUserID = ryUserID;
  
    if ([self.type isEqualToString:@"black"]) {
        
        [[RCCoreClient sharedCoreClient] getBlacklistStatus:self.ryUserID success:^(int bizStatus) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (bizStatus==101) {
//                    self.switchBtn.on=false;
                    self.btnStatus=NO;
                    self.switchBtn.layer.contents=(id)KGetImage(@"switchOffImg").CGImage;
    //                [self.topButton setImage:[UIImage imageNamed:@"kaiguan_guan"] forState:UIControlStateNormal];
                    self.addNow=NO;
                }else{
//                    self.switchBtn.on=true;
                    self.btnStatus=YES;
                    self.switchBtn.layer.contents=(id)KGetImage(@"switchOnImg").CGImage;
    //                [self.topButton setImage:[UIImage imageNamed:@"kaiguan_kai"] forState:UIControlStateNormal];
                    self.addNow=YES;
                }
            });
           
        } error:^(RCErrorCode status) {
            
        }];
    }else{
        RCConversation *conversation = [[RCCoreClient sharedCoreClient] getConversation:ConversationType_PRIVATE targetId:ryUserID];
        if (conversation.isTop) {
//            [self.topButton setImage:[UIImage imageNamed:@"kaiguan_kai"] forState:UIControlStateNormal];
//            self.switchBtn.on=true;
            self.btnStatus=YES;
            self.switchBtn.layer.contents=(id)KGetImage(@"switchOnImg").CGImage;
        }else{
//            [self.topButton setImage:[UIImage imageNamed:@"kaiguan_guan"] forState:UIControlStateNormal];
//            self.switchBtn.on=false;
            self.btnStatus=NO;
            self.switchBtn.layer.contents=(id)KGetImage(@"switchOffImg").CGImage;
        }
        
    }
    
    
}

-(void)setType:(NSString *)type{
    _type=type;
    
    if ([self.type isEqualToString:@"black"]) {
        self.titleLB.text=getLanguage(@"加入黑名单");
    }
    
}


- (UILabel *)titleLB{
    if (!_titleLB) {
        _titleLB = [ControlCreator createLabel:nil rect:CGRectZero text:getLanguage(@"置顶聊天") font:Font(14) color:mainViceColor backguoundColor:[UIColor clearColor] align:NSTextAlignmentLeft lines:1];
    }
    return _titleLB;
}


- (UIButton *)switchBtn{
    if (!_switchBtn) {
        _switchBtn = [ControlCreator createButton:nil rect:CGRectZero text:@"" font:Font(12) color:[UIColor clearColor] backguoundColor:[UIColor clearColor] imageName:@"" target:self action:@selector(switchChangeBtn:)];
        _switchBtn.layer.contents=(id)KGetImage(@"switchOnImg").CGImage;
        
        
    }
    return _switchBtn;
}

//- (UISwitch *)switchBtn{
//    if (!_switchBtn) {
//        _switchBtn = [[UISwitch alloc] init];
//        _switchBtn.backgroundColor =RGBA(255, 255, 255, 0);
////        [_switchBtn setOnTintColor: RGBA(55, 171, 255, 1)];
//        [_switchBtn setOnTintColor: RGBA(255, 255, 255, 0)];
//        [_switchBtn setTintColor: RGBA(255, 255, 255, 0)];
//        [_switchBtn setThumbTintColor:RGBA(255, 255, 255, 0)];
//        _switchBtn.layer.contents=(id)KGetImage(@"switchOnImg").CGImage;
//        [_switchBtn addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
//
//    }
//    return _switchBtn;
//}

    
    
    
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:MLControlsHuiColor];
    }
    return _lineView;
}

@end
