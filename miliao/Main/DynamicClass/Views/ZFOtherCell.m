//
//  ZFOtherCell.m
//  ZFPlayer_Example
//
//  Created by 任子丰 on 2018/6/21.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import "ZFOtherCell.h"
#import "CopyAbleLabel.h"
#import "EMO_CommentBottomView.h"
#import "EMO_DynamicXQViewController.h"
#import "BWShareView.h"
@interface ZFOtherCell (){
    CGFloat commentBtnWidth;
    CGFloat commentBtnHeight;
    CGFloat MaxLabelHeight;
}

@property(nonatomic,retain)UIView *bgView;

@property(nonatomic,retain)UIImageView *avatarIV;
@property(nonatomic,retain)UIView *onLineView;
@property(nonatomic,retain)UILabel *userNameLabel;
//@property(nonatomic,retain)UIButton *ageBtn;

@property(nonatomic,retain)UILabel *timeStampLabel;
@property(nonatomic,strong)CopyAbleLabel *messageTextLabel;
@property(nonatomic,retain)UIButton *commentBtn;
@property(nonatomic,retain)UIButton *moreBtn;
@property(nonatomic,assign)BOOL isExpandNow;
@property(nonatomic,assign)NSInteger headerSection;
@property(nonatomic,strong)JGGView *jggView;

@property(nonatomic,strong)EMO_CommentBottomView *commentView;

@property(nonatomic,retain)UIView *lineView;



@end


@implementation ZFOtherCell




- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = kClearColor;
        self.backgroundColor=kClearColor;
        self.bgView=[[UIView alloc] init];
//        self.bgView.backgroundColor=kWhiteColor;
        self.bgView.layer.cornerRadius=KAdaptedHeight(10);
        self.bgView.layer.masksToBounds=YES;
        [self addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(KAdaptedHeight(0));
            make.bottom.mas_equalTo(KAdaptedHeight(-10));
        }];
        
        self.avatarIV = [[UIImageView alloc]initWithFrame:CGRectMake(kGAP, kGAP, kAvatar_Size, kAvatar_Size)];
        [self.bgView addSubview:self.avatarIV];
        self.avatarIV.layer.cornerRadius =kAvatar_Size/2;
        self.avatarIV.clipsToBounds = YES;
        self.avatarIV.userInteractionEnabled=YES;
        [self.avatarIV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapPush)]];
        self.onLineView=[[UIView alloc] initWithFrame:CGRectMake(kAvatar_Size+kGAP-KAdaptedWidth(14), kAvatar_Size+kGAP-KAdaptedWidth(10), KAdaptedWidth(8), KAdaptedWidth(8))];
        self.onLineView.backgroundColor=[UIColor colorWithRed:0.72 green:0.72 blue:0.73 alpha:1.00];
        self.onLineView.layer.cornerRadius=KAdaptedWidth(8)/2;
        self.onLineView.layer.masksToBounds=YES;
        [self.bgView addSubview:self.onLineView];
        self.onLineView.hidden=YES;
        
        self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.avatarIV.frame)+kGAP, kGAP,KAdaptedWidth(60), kAvatar_Size/2)];
        self.userNameLabel.font = KFontBold(15);
        self.userNameLabel.textColor = RGBA(34, 34, 34, 1);
        [self.bgView addSubview:self.userNameLabel];
        
//        self.ageBtn=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userNameLabel.frame)+kGAP, kGAP+KAdaptedHeight(7),KAdaptedWidth(45), KAdaptedHeight(16))];
//        self.ageBtn.layer.contents=(id)KGetImage(@"womanIconBgImg").CGImage;
//        [self.ageBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
//        [self.ageBtn setTitle:@"0" forState:UIControlStateNormal];
//        self.ageBtn.titleLabel.font=KFont(12);
//        [self.ageBtn setImage:KGetImage(@"womanIconImg") forState:UIControlStateNormal];
//        [self.bgView addSubview:self.ageBtn];
        

        self.delBtn=[[UIButton alloc] initWithFrame:CGRectMake(kWidth-KAdaptedWidth(45+14+14), kGAP,KAdaptedWidth(45), KAdaptedHeight(45))];
//        [self.delBtn setImage:KGetImage(@"delegateImg") forState:UIControlStateNormal];
        [self.delBtn setImage:KGetImage(@"commentMoreImg") forState:UIControlStateNormal];
        [self.delBtn addTarget:self action:@selector(delDynamicBolck) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:self.delBtn];

        
        self.followBtn=[[UIButton alloc] initWithFrame:CGRectMake(kWidth-KAdaptedWidth(70+14+14), kGAP,KAdaptedWidth(70), KAdaptedHeight(30))];
//        [self.followBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
//        [self.followBtn setTitle:getLanguage(@"关注") forState:UIControlStateNormal];
//        self.followBtn.titleLabel.font=KFontA(13);
//        [self.followBtn makeRoundCornerAndLayerColor:HexColorDy(@"#9B9B9B")];
        [self.followBtn addTarget:self action:@selector(followDynamicBolck) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:self.followBtn];
        
        
        
        self.timeStampLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.avatarIV.frame)+kGAP, kGAP+self.avatarIV.frame.size.height/2,kScreenWidth-kAvatar_Size-2*kGAP-kGAP, self.avatarIV.frame.size.height/2)];
        self.timeStampLabel.font = KFont(13);
        self.timeStampLabel.textColor =RGBA(102, 102, 102, 1);
        [self.bgView addSubview:self.timeStampLabel];
        
        self.messageTextLabel = [[CopyAbleLabel alloc]init];
        self.messageTextLabel.numberOfLines = 0;
        self.messageTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.messageTextLabel.textColor=RGBA(34, 34, 34, 1);
        self.messageTextLabel.font = KFont(14);
        [self.bgView addSubview:self.messageTextLabel];
        
        commentBtnWidth = 60;
        commentBtnHeight = 22;
        MaxLabelHeight = 75.0;
        self.commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.commentBtn.backgroundColor = [UIColor whiteColor];
        [self.commentBtn setTitle:@"评论" forState:UIControlStateNormal];
        [self.commentBtn setTitle:@"评论" forState:UIControlStateSelected];
        [self.commentBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.commentBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.commentBtn.layer.borderWidth = 1;
        self.commentBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [self.commentBtn setImage:[UIImage imageNamed:@"commentBtn"] forState:UIControlStateNormal];
        [self.commentBtn setImage:[UIImage imageNamed:@"commentBtn"] forState:UIControlStateSelected];
        
        [self.commentBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:self.commentBtn];
        
        
        self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.moreBtn setTitle:@"全文" forState:UIControlStateNormal];
        [self.moreBtn setTitle:@"收起" forState:UIControlStateSelected];
        [self.moreBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.moreBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        self.moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [self.moreBtn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:self.moreBtn];
        self.isExpandNow = NO;
        self.jggView = [[JGGView alloc] init];
        [self.bgView addSubview:self.jggView];
        
        self.commentView=[[EMO_CommentBottomView alloc] init];
        [self.commentView.likeBtn addTarget:self action:@selector(likeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.commentView.commentBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.commentView.collectBtn addTarget:self action:@selector(collectBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.commentView.reportBtn actionHandle:^{
            [self reportBtnClick];
        }];

        [self.bgView addSubview:self.commentView];
        [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(KAdaptedHeight(0));
            make.height.mas_equalTo(KAdaptedHeight(50));
            make.bottom.mas_equalTo(KAdaptedHeight(-15));
        }];
        
        
        self.lineView=[[UIView alloc] init];
        self.lineView.backgroundColor=RGBA(241, 241, 241, 1);
        [self.bgView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(KAdaptedHeight(0));
            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(KAdaptedHeight(0));
        }];
        
        
        [RACObserve(self,self.model.is_attention) subscribeNext:^(id  _Nullable x) {
            
            /** 关注按钮的 样式*/
            [self focusBtnState];

        }];
        
        
        
        
    }
    return self;
}


-(void)TapPush{
    if(self.headImgClickBlock){
        self.headImgClickBlock();
    }
}



-(void)setModel:(MessageInfoModel *)model{
    _model=model;
    WeakSelf;
    
    self.jggView.tapBlock = ^(NSInteger index, NSArray *dataSource) {
        if (wself.tapImageBlock) {
            wself.tapImageBlock(index, dataSource);
        }
    };
    NSString *headImgStr=[Common isNull:model.user[@"avatar"]];
    if(![headImgStr hasPrefix:@"http"]){
        headImgStr=[headImgStr stringByAppendingString:VERSION_HTTPS_SERVER];
    }
    [self.avatarIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",headImgStr]] placeholderImage:[UIImage imageNamed:@"未加载头像"]];
    self.userNameLabel.text = [Common isNull:model.user[@"nickname"]];
    
    CGSize textWidth = [self.userNameLabel.text sizeWithFont:KFontBold(15) maxSize:CGSizeMake(kWidth-kAvatar_Size-kGAP*2-KAdaptedWidth(50), CGFLOAT_MAX)];
    
    self.userNameLabel.frame=CGRectMake(CGRectGetMaxX(self.avatarIV.frame)+kGAP, kGAP,textWidth.width, kAvatar_Size/2);
//    self.ageBtn.frame=CGRectMake(CGRectGetMaxX(self.userNameLabel.frame)+kGAP, kGAP+KAdaptedHeight(7),KAdaptedWidth(45), KAdaptedHeight(16));
    
//    if ([model.user[@"is_show_online"] integerValue]==0) {
//        self.onLineView.hidden=NO;
//        if([model.user[@"is_line"] integerValue]==1){
//            self.onLineView.backgroundColor=RGBA(8, 214, 139, 1);
//        }else{
//            self.onLineView.backgroundColor=[UIColor colorWithRed:0.72 green:0.72 blue:0.73 alpha:1.00];
//        }
//    }else{
//        self.onLineView.hidden=YES;
//    }
    
   
    if([model.uid integerValue]==[[UserManager userInfo].user_id integerValue]){
        self.delBtn.hidden=NO;
        self.followBtn.hidden=YES;
        self.onLineView.backgroundColor=RGBA(8, 214, 139, 1);
    }else{
        self.delBtn.hidden=YES;
        self.followBtn.hidden=NO;
    }
    
//    if ([model.user[@"gender"] integerValue]==0) {
//        self.ageBtn.layer.contents=(id)KGetImage(@"womanIconBgImg").CGImage;
//        [self.ageBtn setImage:KGetImage(@"womanIconImg") forState:UIControlStateNormal];
//    }else{
//        self.ageBtn.layer.contents=(id)KGetImage(@"manIconBgImg").CGImage;
//        [self.ageBtn setImage:KGetImage(@"manIconImg") forState:UIControlStateNormal];
//    }
//    [self.ageBtn setTitle:[NSString stringWithFormat:@" %@",model.user[@"age"]] forState:UIControlStateNormal];
    
    self.timeStampLabel.text=model.createtime_text;
    
    self.messageTextLabel.attributedText = model.mutablAttrStr;
    self.messageTextLabel.frame = model.textLayout.frameLayout;
    ///解决图片复用问题
    [self.jggView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSString *imgName=[Common isNull:model.images];
    
    NSMutableArray *imgArr=[NSMutableArray array];
    if(imgName.length>0){
        for (NSString *ingUrl in model.image_arr) {
           
            [imgArr addObject:[NSString stringWithFormat:@"%@",ingUrl]];
    //        [imgArr addObject:[NSString stringWithFormat:@"%@%@",VERSION_HTTPS_SERVER,ingUrl]];
        }
    }

        self.jggView.dataSource =imgArr;
    self.jggView.frame = model.jggLayout.frameLayout;
    
    
    self.commentView.model=model;

    
}


-(void)commentAction:(UIButton *)sender{
//    if (self.CommentBtnClickBlock) {
//        self.CommentBtnClickBlock(sender,self.headerSection);
//    }
}
-(void)moreAction:(UIButton *)sender{
//    if (self.MoreBtnClickBlock) {
//        self.MoreBtnClickBlock(sender,_isExpandNow);
//    }
}




-(void)likeBtnClick{
    if (self.likeBtnClickBlock) {
//        self.likeBtnClickBlock(self.commentView.likeBtn, self.commentView.likeBtn.selected);
        self.likeBtnClickBlock(self.commentView.likeBtn, self.commentView.likeBtn.selected,self.model);
    }
}

-(void)commentBtnClick{
    
    /** 带标题的分享弹窗*/
//    [self showShareViewWithTitle];
    
        EMO_DynamicXQViewController *vc=[EMO_DynamicXQViewController new];
        vc.model=self.model;
        [[Common getCurrentVC].navigationController pushViewController:vc animated:YES];
    
    
//    if (self.CommentBtnClickBlock) {
////        self.CommentBtnClickBlock(self.commentView.commentBtn);
//        self.CommentBtnClickBlock(self.commentView.commentBtn,self.model);
//
//    }
}

-(void)collectBtnClick{
    if (self.CollectBtnClickBlock) {
//        self.likeBtnClickBlock(self.commentView.likeBtn, self.commentView.likeBtn.selected);
        self.CollectBtnClickBlock(self.commentView.collectBtn, self.commentView.collectBtn.selected,self.model);
    }
    
}

-(void)sendMsgBtnClick{
    

    
}

-(void)commentMoreClick{
//    [SVProgressHUD showImage:KGetImage(@"") status:@"更多"];
    
//    EMO_DynamicXQViewController *vc=[EMO_DynamicXQViewController new];
//    vc.messageId=self.model.message_id;
//    [[Common getCurrentVC].navigationController pushViewController:vc animated:YES];

    
//    if (self.MoreBtnClickBlock) {
//        self.MoreBtnClickBlock();
//    }
}

-(void)delDynamicBolck{
    if (self.delBtnClickBlock) {
        self.delBtnClickBlock(self.model);
    }
}

-(void)followDynamicBolck{
    if(self.FollowBtnClickBlock){
        self.FollowBtnClickBlock(self.followBtn, self.model);
    }
}


- (void)reportBtnClick
{
    //获取举报类型
    [self getReportWithParameters];
}

-(void)reportReasonId:(NSString *)reportID{
    
    NSDictionary *parameter = @{@"reason_id":reportID,@"dynamic_id":FORMAT(_model.message_id),@"type":@"0"};
    
//type类型:0=动态,1=房间,2=会员，3=评论
    [NetworkRequest POST:Request_AddReport parmeters:parameter success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:baseModel.msg]];
        
    } failture:^(NSError *error) {
        
    }];
    
    
}

//获取举报类型
- (void)getReportWithParameters
{
    WeakSelf;
    [NetworkRequest POST:Request_GetReportReason parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:getLanguage(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        for (NSDictionary *dic in baseModel.data) {
            [alert addAction:[UIAlertAction actionWithTitle:[Common isNull:dic[@"reason"]] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                for (NSDictionary *dic in baseModel.data) {
                    if([dic[@"reason"] isEqualToString:action.title]){
                        [self reportReasonId:dic[@"id"]];
                        break;;
                    }
                }
            }]];
        }
        [[ObjectTool SharedSettings].currentVC presentViewController:alert animated:YES completion:nil];
        
    } failture:^(NSError *error) {
        
    }];
    
}


#pragma mark 带标题的分享弹窗
- (void)showShareViewWithTitle
{
    WeakSelf;
// [[BWItemModel alloc] initWithImg:@"shareFriendImg" text:getLanguage(@"emo好友")]
    BWShareView *shareView = [[BWShareView alloc] initWithFrame:[ObjectTool SharedSettings].currentVC.view.bounds shareTitle:getLanguage(@"分享至") shareArray:[NSMutableArray arrayWithObjects:[[BWItemModel alloc] initWithImg:@"wechatImg" text:getLanguage(@"微信好友")],[[BWItemModel alloc] initWithImg:@"pengyouquanImg" text:getLanguage(@"朋友圈")], nil]];
    [shareView show];
    shareView.shareItemClick = ^(BWItemModel * _Nonnull model) {
        NSLog(@"name1 = %@", model.text);
        if ([model.text isEqualToString:getLanguage(@"微信好友")]) {
//            [wself shareWeChat:WXSceneSession];
            [wself shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
        }else if ([model.text isEqualToString:getLanguage(@"朋友圈")]){
//            [wself shareWeChat:WXSceneTimeline];
            [wself shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
        }else if ([model.text isEqualToString:getLanguage(@"复制链接")]){
            UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
            pastboard.string = [NSString stringWithFormat:@"https://www.baidu.com"];
            [SVProgressHUD showSuccessWithStatus:getLanguage(@"已复制")];
        }else{
            
//            EMO_ShareFirendListViewController *vc=[EMO_ShareFirendListViewController new];
//            vc.type=1;
//            vc.dicData=self.dicData;
//            [self.navigationController pushViewController:vc animated:YES];
        
        }
        
    };
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType{
    if (![[UMSocialManager defaultManager] isInstall:platformType]) {
        [SVProgressHUD showErrorWithStatus:@"未安装此应用"];
        return;
    }
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:[Common isNull:[MLRoomInformationModel currentAccount].name] descr:[Common isNull:[MLRoomInformationModel currentAccount].notice] thumImage:[MLRoomInformationModel currentAccount].image];
    shareObject.webpageUrl = [Common isNull:[UserManager userInfo].invite_url];
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if(error)
        {
            MYLog(@"分享 error %@",error);
            [SVProgressHUD showErrorWithStatus:error.userInfo[@"message"]];
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

/** 关注按钮的 样式*/
- (void)focusBtnState
{
    self.followBtn.frame = CGRectMake(0, 13, 66, 21);
    self.followBtn.right = SCREENWIDTH - 16 * 2 - 6 ;
    self.followBtn.titleLabel.font = PingFangFONT(11);
    [self.followBtn makeRoundCornerAndLayerColor:BaseMainColor];
    if (self.model.is_attention) {
        self.followBtn.backgroundColor = UIColor.whiteColor ;
        self.followBtn.layer.borderColor = LineColor.CGColor ;
        [self.followBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        [self.followBtn setTitleColor:HexColorDy(@"666666") forState:UIControlStateNormal];
    }else{
        self.followBtn.backgroundColor = BaseMainColor ;
        self.followBtn.layer.borderColor = BaseMainColor.CGColor ;
        [self.followBtn setTitle:@"关注" forState:UIControlStateNormal];
        [self.followBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    }
}
@end
