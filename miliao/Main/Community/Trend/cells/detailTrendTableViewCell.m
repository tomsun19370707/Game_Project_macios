//
//  detailTrendTableViewCell.m
//  miliao
//
//  Created by aa on 2019/7/23.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "detailTrendTableViewCell.h"
#import "TrendVoiceView.h"
#import "PhotoContainerView.h"
#import "SDLabTagsView.h"
@interface detailTrendTableViewCell()
@property(nonatomic,strong) TrendVoiceView * voiceView;
@property(nonatomic,strong) PhotoContainerView *picContainerView;
@property (nonatomic,strong)SDLabTagsView *tagsView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLeading; //置顶图标距昵称的距离
@end
@implementation detailTrendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews
{
    self.IconImage.layer.cornerRadius = 20;
    self.AttentionBtn.layer.cornerRadius = 15;

        self.picContainerView.isBigPicture = YES;
    
}
-(void)setContentLabel:(YYLabel *)ContentLabel
{
    if (!_ContentLabel) {
        _ContentLabel = [YYLabel new];
        //        [self.contentView addSubview:_ContentLabel];
    }
    
}
-(TrendVoiceView *)voiceView
{
    if (!_voiceView) {
        TrendVoiceView * voiceView = [TrendVoiceView voiceView];
        
        _voiceView = voiceView;
    }
    return _voiceView;
}
-(PhotoContainerView *)picContainerView
{
    if (!_picContainerView) {
        PhotoContainerView *picView = [[PhotoContainerView alloc] init];
        picView.backgroundColor = [UIColor whiteColor];
        
        
        _picContainerView = picView;
    }
    return _picContainerView;
}


-(SDLabTagsView *)tagsView
{
    if (!_tagsView) {
        SDLabTagsView *tagsView = [[SDLabTagsView alloc] init];
        [self.contentView addSubview:tagsView];
        _tagsView = tagsView;
    }
    return _tagsView;
}
-(void)setModel:(TrendModel *)model
{
    _model = model;
    //    model.image_urList = @[@"http://47.92.85.75/upload//dynamic_image/1563434040.jpg",@"http://47.92.85.75/upload//dynamic_image/20190722/15637967924980.jpg",@"http://47.92.85.75/upload/\/dynamic_image\/20190618\/25220_133944_9041.jpg",@"http://47.92.85.75/upload//dynamic_image/20190722/15637967926891.jpg"];
    //    model.content = @"东方噶但是噶都很舒服；阿迪舒服；安德森；发到你身边 v；家啊点上班水淀粉和绿咖啡发送到你发快递费卡上的女啊丹江口市分你发了沙发上粉嫩的 v 那费迪南德撒那点事法律事件多发；司法滥发可是对方拿到阿三开的房间咖喱adsasfasfvj都是客服哈瞌睡；豆腐哈瞌睡；你那时大家发的少女们法拉第开始减肥；";
    [self addAllContentLabel:model];
   
    
    [_IconImage sd_setImageWithURL:[NSURL URLWithString:model.headimgurl]];
    self.NameLabel.text = model.nickname;
    if ([model.sex isEqualToString:@"1"]) {
        [self.GenderImageView setImage:[UIImage imageNamed:@"Gender_boy"]];
    }
    else [self.GenderImageView setImage:[UIImage imageNamed:@"Gender_girl"]];
    self.CommentLabel.text = model.talk_num;
    self.LikeLabel.text = model.praise;
    self.ForwardLabel.text = model.forward_num;
    self.TimeLabel.text = model.addtime;
    self.ContentLabel.text = model.content;
    if (model.image_urList.count>0) {
        [self.contentView addSubview:self.picContainerView];
        [self.picContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.ContentLabel.mas_bottom).offset(MLTrendCellMargin);
            make.left.equalTo(self.ContentLabel.mas_left);
            make.right.equalTo(self).offset(-15);
            
        }];
        self.picContainerView.picPathStringsArray = model.image_urList;
        
    }
    
    if (model.audio.length > 0) {
        self.voiceView.hidden = NO;
        [self.contentView addSubview:self.voiceView];
        [self.voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.ContentLabel.mas_left);
            make.height.mas_offset(50);
            make.top.equalTo(self.ContentLabel.mas_bottom).offset(MLTrendCellMargin);
            //            make.width.mas_offset(230);
        }];
    }
    else
    {
        self.voiceView.hidden = YES;
    }
    
    if (model.tags_nameList.count > 0) {
        self.tagsView.tagsArr = model.tags_nameList;
        [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.BottomView.mas_top).offset(-MLTrendCellMargin);
            make.left.equalTo(self.ContentLabel.mas_left);
            make.size.mas_offset(CGSizeMake(ScreenWidth - 30, model.tagsViewHeight));
        }];
        [self.picContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.tagsView.mas_top).offset(-10);
        }];
        [self layoutIfNeeded];
    }
    else
    {
        [self.picContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.BottomView.mas_top).offset(-10);
        }];
    }
    NSString *imageName = NSStringFormat(@"GXImg-%@",model.vip_level);
    [self.VIPImageView setImage:[UIImage imageNamed:imageName]];
    if ([model.vip_level isEqualToString:@"0"]) {
        self.VIPImageView.hidden = YES;
    }
    
    if([model.is_collect isEqualToString:@"1"])
    {
        [self.CollectionBtn setSelected:YES];
    }
    else{
        [self.CollectionBtn setSelected:NO];
    }
    if ([model.is_praise  isEqualToString:@"1"]) {
        [self.LikeBtn setSelected:YES];
    }
    else{
        [self.LikeBtn setSelected:NO];
    }
    if ([model.is_top isEqualToString:@"1"]) {
        self.TopImageView.hidden = NO;
    }
    else{
        self.TopImageView.hidden = YES;
    }
    if (self.VIPImageView.hidden  && self.TopImageView.hidden == NO) {
        self.leftLeading.constant = 5;
    }
    else self.leftLeading.constant = 45;
    if ([model.is_follow isEqualToString:@"1"]) {
        
        self.AttentionBtn.selected = YES;
    }
    else self.AttentionBtn.selected = NO;
    
    
}

- (void)addAllContentLabel:(TrendModel *)model
{
    self.ContentLabel = [YYLabel new];
    self.userInteractionEnabled = YES;
    self.ContentLabel.font = [UIFont systemFontOfSize:15];
    self.ContentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.ContentLabel];
    [self.ContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.IconImage.mas_bottom).offset(MLTrendCellMargin);
        make.height.mas_offset(model.contentLabelHeight);
        make.left.equalTo(self.IconImage.mas_left);
        make.right.equalTo(self).offset(-15);
    }];
}


@end
