//
//  TrendTableViewCell.m
//  miliao
//
//  Created by aa on 2019/7/5.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "TrendTableViewCell.h"
#import "TrendVoiceView.h"
#import "PhotoContainerView.h"
#import "SDLabTagsView.h"
#import <AVFoundation/AVFoundation.h>
#import "TrendVoiceView.h"
#import "SQBottomView.h"

@interface TrendTableViewCell()<AVAudioPlayerDelegate>
{
    id timeObserve;
}
@property (nonatomic,strong)AVPlayer *player;
/** 声音帖子中间的内容  */

@property(nonatomic,strong) PhotoContainerView *picContainerView;
@property (nonatomic,strong)SDLabTagsView *tagsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLeading; //置顶图标距昵称的距离
@property(nonatomic,strong) TrendVoiceView *voiceView;
@property(nonatomic, strong) SQBottomView *myBottomView;

@end
@implementation TrendTableViewCell


- (instancetype)init{
    if (!self) {
        self = [super init];
        
        
        
        
        
    }
    return self;
}
- (void)stopPlayAVPlayer {
    if (self.player) {
        [self.player pause];
        if (timeObserve) {
            [self.player removeTimeObserver:timeObserve];
            timeObserve = nil;
        }
        self.player = nil;
        self.voiceView.newTimeLabel.text = NSStringFormat(@"    %@s",self.model.audio_time);
//        [songitem removeObserver:self forKeyPath:@"status"];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlayAVPlayer) name:@"kStopAVPlayerNotification" object:nil];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.IconImage.layer.cornerRadius = 20;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
    [self.IconImage addGestureRecognizer:tapGesture];
    self.IconImage.userInteractionEnabled = YES;
    self.AttentionBtn.layer.cornerRadius = 15;
    self.TimeLabel.textColor = MHColorFromHexString(@"#BBBBBB");
    self.TimeLabel.backgroundColor = UIColor.clearColor;
    self.BottomView.backgroundColor = [UIColor whiteColor];
    self.contentLabel = [[YYLabel alloc] init];
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    self.contentLabel.textColor = mainColor;
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.IconImage.mas_bottom).offset(MLTrendCellMargin );
        make.height.mas_offset(0);
        make.left.equalTo(self.IconImage.mas_left);
        make.right.equalTo(self).offset(-15);
    }];
    
    [self.contentView addSubview:self.tagsView];
    self.tagsView.hidden = YES;
//    self.BottomView.hidden = YES;
    self.tagsView.backgroundColor = [UIColor whiteColor];
    [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.BottomView.mas_top).offset(-10);
        make.left.equalTo(self.IconImage.mas_left);
        make.size.mas_offset(CGSizeMake(ScreenWidth - 30, 0));
    }];
    [self.contentView addSubview:self.picContainerView];
    [self.picContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(MLTrendCellMargin);
        make.left.equalTo(self.contentLabel.mas_left);
        make.right.equalTo(self.contentView).offset(-15);
//        make.height.mas_offset(1);
            
    }];
    self.BottomView.hidden = YES;
    self.picContainerView.backgroundColor = UIColor.clearColor;
//    self.picContainerView.hidden = YES;
    self.voiceView.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.myBottomView];
    [self.contentView addSubview:self.grayBottomView];
    [self.myBottomView.shoucangBtn addTarget:self action:@selector(collectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.myBottomView.pinglunBtn  addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.myBottomView.dianzanBtn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.myBottomView.fenxiangBtn addTarget:self action:@selector(forwardBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    self.BottomView.frame = CGRectMake(self.contentLabel.left, self.tagsView.bottom+5, ScreenWidth-self.contentLabel.left, 30);
//    CGFloat height = CGRectGetHeight(self.contentView.frame);
//    MYLog(@"--%@--%.2f",NSStringFromCGRect(self.contentView.frame),height);
//    self.myBottomView.frame = CGRectMake(0, height-40, ScreenWidth, 40);
}
- (void)setFrame:(CGRect)frame{
    frame.size.height -= 5;
    
    [super setFrame:frame];
}
- (UIView *)grayBottomView{
    if (!_grayBottomView) {
        _grayBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _grayBottomView.backgroundColor = mainViceColor;
    }
    return _grayBottomView;
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
- (SQBottomView *)myBottomView{
    if (!_myBottomView) {
        _myBottomView = [[SQBottomView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        
    }
    return _myBottomView;
}

-(SDLabTagsView *)tagsView
{
    if (!_tagsView) {
      _tagsView = [[SDLabTagsView alloc] init];
        
    }
    return _tagsView;
}
//收藏

- (void)collectionBtnClick:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(trendTableViewCell:collectionBtnClick:)]) {
        [self.delegate trendTableViewCell:self collectionBtnClick:sender];
    }
}
//评论
- (void)commentBtnClick:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(trendTableViewCell:commentBtnClick:)]) {
        [self.delegate trendTableViewCell:self commentBtnClick:sender];
    }
}
//点赞
- (void)likeBtnClick:(id)sender {
    
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(trendTableViewCell:likeBtnClick:)]) {
        [self.delegate trendTableViewCell:self likeBtnClick:sender ];
    }
}
//转发
- (void)forwardBtnClick:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(trendTableViewCell:forwardBtnClick:)]) {
        [self.delegate trendTableViewCell:self forwardBtnClick:sender ];
    }
}
//右上角更多
- (IBAction)moreBtnClick:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(trendTableViewCell:cellRightBtnClick:)]) {
        [self.delegate trendTableViewCell:self cellRightBtnClick:sender ];
    }
}
- (IBAction)attentationBtnClick:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(trendTableViewCell:attentationBtnClick:)]) {
        [self.delegate trendTableViewCell:self attentationBtnClick:sender ];
    }
}
- (void)clickImage
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(trendTableViewCell:IconClick:)]) {
        [self.delegate trendTableViewCell:self IconClick:nil];
    }
}
-(void)setModel:(TrendModel *)model
{
    
    _model = model;
    [self addControllerViewWithModel:model];
    if (model.image_urList.count>0) {
        self.picContainerView.hidden = NO;
    }
    else
    {
        self.picContainerView.hidden = YES;
    }
    if (self.isBigPicture) {
         [self addAllContentLabel:model];
        self.picContainerView.isBigPicture = YES;
        [self.picContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(model.detailImageHeight);
        }];
    }
    else
    {
        [self addContentLabel:model];
        self.picContainerView.isBigPicture = NO;
        [self.picContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(model.imageHeight);
        }];
    }
    self.picContainerView.picPathStringsArray = model.image_urList;
   
    if (model.audio.length > 0) {
        self.voiceView.hidden = NO;
        self.voiceView.newTimeLabel.text = NSStringFormat(@"    %@s",model.audio_time);
//        self.voiceView.playTime = NSStringFormat(@"%@s",model.audio_time);
        self.voiceView.audioUrl = model.audio;
        WEAK_SELF
        self.voiceView.playBtnActionBlock = ^(BOOL btnSelected) {
//            [weakSelf playWithUrl:btnSelect];
            ! weakSelf.playBtnActionBlock ?: weakSelf.playBtnActionBlock(btnSelected, weakSelf.model);
        };
        [self.contentView addSubview:self.voiceView];
        [self.voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.IconImage.mas_left);
            make.height.mas_offset(MLTrendCellVoiceH);
            make.width.mas_equalTo(200);
            make.top.equalTo(self.contentLabel.mas_bottom).offset(MLTrendCellMargin);
        }];
    }
    else
    {
        self.voiceView.hidden = YES;
    }
    
    if (model.tags_nameList.count > 0) {
        self.tagsView.hidden = NO;
        self.tagsView.tagsArr = model.tags_nameList;
        [self.tagsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.BottomView.mas_top).offset(-10);
            make.left.equalTo(self.IconImage.mas_left);
            make.size.mas_offset(CGSizeMake(ScreenWidth - 30, model.tagsViewHeight));
        }];

        [self layoutIfNeeded];

        }
    else
    {
        self.tagsView.hidden = YES;
//        if (model.image_urList.count > 0) {
//            [self.picContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.bottom.equalTo(self.BottomView.mas_top).offset(-10);
//            }];
//        }

    }
    if (!model.isPlay) {
        self.voiceView.myPlayBtn.selected = NO;
        [self playWithUrl:NO];
    }else{
        self.voiceView.myPlayBtn.selected = YES;
        [self playWithUrl:YES];
    }
    MYLog(@"----%.2f",model.cellHeight);
    self.tagsView.hidden = YES;
    self.myBottomView.frame = CGRectMake(0, model.cellHeight-50, ScreenWidth, 40);
    if ([model.is_collect isEqualToString:@"1"]) {
        self.myBottomView.shoucangBtn.selected = YES;
    }else{
        self.myBottomView.shoucangBtn.selected = NO;
    }
    [self.myBottomView.pinglunBtn setTitle:model.talk_num forState:UIControlStateNormal];
    [self.myBottomView.dianzanBtn setTitle:model.praise forState:UIControlStateNormal];
    [self.myBottomView.fenxiangBtn setTitle:model.forward_num forState:UIControlStateNormal];
    if ([model.is_praise isEqualToString:@"1"]) {
        self.myBottomView.dianzanBtn.selected = YES;
    }else{
        self.myBottomView.dianzanBtn.selected = NO;
    }
    self.grayBottomView.frame = CGRectMake(0, model.cellHeight-10, ScreenWidth, 10);
    
}
- (void)addControllerViewWithModel:(TrendModel *)model
{
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
    self.contentLabel.text = model.content;
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
//    self.userInteractionEnabled = YES;
    self.contentLabel.font = [UIFont systemFontOfSize:15];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.text = model.content;
    [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.IconImage.mas_bottom).offset(MLTrendCellMargin);
        make.height.mas_offset(model.contentLabelHeight);
        make.left.equalTo(self.IconImage.mas_left);
        make.right.equalTo(self).offset(-15);
    }];
}

- (void)addContentLabel:(TrendModel*)model
{
    
    self.userInteractionEnabled = YES;
    self.contentLabel.font = [UIFont systemFontOfSize:15];
    self.contentLabel.numberOfLines = 0;
    
    if (model.contentLabelHeight > MLTrendCellTextMaxY) {
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.IconImage.mas_bottom).offset(MLTrendCellMargin );
            make.height.mas_offset(MLTrendCellTextMaxY);
            make.left.equalTo(self.IconImage.mas_left);
            make.right.equalTo(self.contentView).offset(-15);
        }];
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"...全文"];
        YYTextHighlight *hi = [YYTextHighlight new];
        [hi setColor:[UIColor colorWithRed:0.578 green:0.790 blue:1.000 alpha:1.000]];
        hi.tapAction = ^(UIView *containerView,NSAttributedString *text,NSRange range, CGRect rect) {
            
            if (self.delegate&&[self.delegate respondsToSelector:@selector(trendTableViewCell:detailClick:)]) {
                //text 传值无意义
                [self.delegate trendTableViewCell:self detailClick:text];
            }
            
        };
        [text setColor:[UIColor colorWithRed:0.000 green:0.449 blue:1.000 alpha:1.000] range:[text.string rangeOfString:@"全文"]];
        [text setTextHighlight: hi range:[text.string rangeOfString:@"全文"]];
        
        text.font = self.contentLabel.font;
         text.lineSpacing = 15;
        YYLabel *seeMore = [YYLabel new];
        seeMore.attributedText = text;
        [seeMore sizeToFit];
        NSAttributedString *truncationToken = [NSAttributedString attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize: text.size  alignToFont:text.font alignment:YYTextVerticalAlignmentCenter];
        self.contentLabel.truncationToken = truncationToken;
    }
    else
    {
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.IconImage.mas_bottom).offset(MLTrendCellMargin);
            make.height.mas_offset(model.contentLabelHeight);
            make.left.equalTo(self.IconImage.mas_left);
            make.right.equalTo(self.contentView).offset(-15);
        }];
    }
    [self layoutIfNeeded];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)playWithUrl:(BOOL)btnSelect
{
    AVPlayerItem *songitem;
    if (btnSelect) {
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:self.model.audio] options:nil];
        songitem = [[AVPlayerItem alloc] initWithAsset:asset];
        
        self.player = [[AVPlayer alloc] initWithPlayerItem:songitem];
        AVAudioSession * session  = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [session setActive:YES error:nil];
        [songitem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        
        WeakSelf;
        timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            float current = CMTimeGetSeconds(time);
            float total = CMTimeGetSeconds(songitem.duration);
            //            MYLog(@"current %f    total %f",current,total);
            if (current) {
                wself.voiceView.newTimeLabel.text = [NSString stringWithFormat:@"    %.fs",total - current];
            }
            if(current == total)
            {
                [wself.player removeTimeObserver:timeObserve];
                wself.player = nil;
                self.voiceView.newTimeLabel.text = NSStringFormat(@"    %@s",wself.model.audio_time);
                self.voiceView.myPlayBtn.selected = NO;
                [self playWithUrl:NO];
            }
        }];
    }
    else
    {
        [self.player pause];
        if (timeObserve) {
            [self.player removeTimeObserver:timeObserve];
            timeObserve = nil;
        }
        self.player = nil;
        self.voiceView.newTimeLabel.text = NSStringFormat(@"    %@s",self.model.audio_time);
        [songitem removeObserver:self forKeyPath:@"status"];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItem *item = (AVPlayerItem *)object;
        //AVPlayerItemStatus *status = item.status;
        if (item.status == AVPlayerItemStatusReadyToPlay) {
            [self.player play];
            //对播放界面的一些操作，时间、进度等
        }
    }
}
@end
