//
//  RoomMusicView.m
//  miliao
//
//  Created by aa on 2019/7/9.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "RoomMusicView.h"

#import "RoomMusicModel.h"

@interface RoomMusicCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UILabel               *soundName;
@property (nonatomic, strong) RoomMusicModel        *musicModel;

@end

@implementation RoomMusicCollectionCell
#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self addSomeViews];
    }
    return self;
}
- (void)setMusicModel:(RoomMusicModel *)musicModel{
    _musicModel = musicModel;
    self.soundName.text = musicModel.music_name;
}
- (void)addSomeViews{
    [self addSubview:self.soundName];
    [self.soundName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(5);
        make.left.mas_equalTo(self).offset(10);
        make.right.mas_equalTo(self).offset(-10);
        make.bottom.mas_equalTo(self).offset(-10);
    }];
    [self layoutIfNeeded];
    self.soundName.layer.cornerRadius = self.soundName.height / 2;
}

- (UILabel *)soundName{
    if (!_soundName) {
        _soundName = [ControlCreator createLabel:nil rect:CGRectZero text:getLanguage(@"音效") font:Font(12) color:mainViceColor backguoundColor:[UIColor whiteColor] align:NSTextAlignmentCenter lines:1];
        _soundName.layer.masksToBounds = YES;
        
    }
    return _soundName;
}

@end


@interface RoomMusicView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView                *maskTopView;
@property (nonatomic, strong) UIView                *bgTopView;
@property (nonatomic, strong) UIView                *maskBottonView;
@property (nonatomic, strong) UIView                *bgBottonView;

@property (nonatomic, strong) UILabel               *titleLB;
@property (nonatomic, strong) UILabel               *musicName;
@property (nonatomic, strong) UIButton              *orderButton;
@property (nonatomic, strong) UIButton              *musicFile;
@property (nonatomic, strong) UIButton              *onAButton;
@property (nonatomic, strong) UIButton              *nextBtn;

@property (nonatomic, strong) UIView                *lianView;

@property (nonatomic, strong) UILabel               *titleBottonLB;
@property (nonatomic, strong) UICollectionView      *collectionView;
@property (nonatomic, strong) UIPageControl         *pageControl;

@property (nonatomic, strong) NSString              *circular;



@end

@implementation RoomMusicView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.circular = @"list";
        self.isPlay = YES;
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    [self addSubview:self.maskBottonView];
    [self addSubview:self.maskTopView];
    [self addSubview:self.bgTopView];
    [self addSubview:self.bgBottonView];
    
    [self.bgBottonView addSubview:self.titleLB];
    [self.bgBottonView addSubview:self.musicFile];
    [self.bgBottonView addSubview:self.orderButton];
    [self.bgBottonView addSubview:self.musicName];
    [self.bgBottonView addSubview:self.sliderView];
    [self.bgBottonView addSubview:self.playAndPauseBtn];
    [self.bgBottonView addSubview:self.onAButton];
    [self.bgBottonView addSubview:self.nextBtn];
    
//    [self.bgBottonView addSubview:self.volumeImgageView];
//    [self.bgBottonView addSubview:self.volumeSliderView];
    
    
    
    [self.bgBottonView addSubview:self.lianView];
    
    [self.bgBottonView addSubview:self.titleBottonLB];
    [self.bgBottonView addSubview:self.collectionView];
    [self.bgBottonView addSubview:self.pageControl];
    
    [self.maskBottonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(273);
    }];
    [self.maskTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self.maskBottonView.mas_top);
    }];
    [self.bgBottonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.maskBottonView.mas_top);
        make.left.mas_equalTo(self.maskBottonView.mas_left);
        make.bottom.mas_equalTo(self.maskBottonView.mas_bottom);
        make.right.mas_equalTo(self.maskBottonView.mas_right);
    }];
    [self.bgTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.maskTopView.mas_top);
        make.left.mas_equalTo(self.maskTopView.mas_left);
        make.bottom.mas_equalTo(self.maskTopView.mas_bottom);
        make.right.mas_equalTo(self.maskTopView.mas_right);
    }];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgBottonView).offset(15);
        make.centerX.mas_equalTo(self.bgBottonView);
    }];
    [self.musicFile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgBottonView.mas_right).offset(-25);
        make.top.mas_equalTo(self.bgBottonView.mas_top).offset(32);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    [self.orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.musicFile.mas_left).offset(-10);
        make.top.mas_equalTo(self.musicFile.mas_top);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    [self.musicName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgBottonView).offset(29);
        make.top.mas_equalTo(self.bgBottonView).offset(57);
    }];
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgBottonView).offset(29);
        make.top.mas_equalTo(self.musicName.mas_bottom).offset(10);
//        make.right.mas_equalTo(self.orderButton.mas_left).offset(-10);
        make.right.mas_equalTo(self.orderButton.mas_left).offset(-30);
        make.height.mas_equalTo(10);
    }];
    [self.playAndPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.sliderView);
        make.top.mas_equalTo(self.sliderView.mas_bottom).offset(10);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(25);
    }];
    [self.onAButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.sliderView).multipliedBy(0.5);
        make.top.mas_equalTo(self.sliderView.mas_bottom).offset(10);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(25);
    }];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.sliderView).multipliedBy(1.5);
        make.top.mas_equalTo(self.sliderView.mas_bottom).offset(10);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(25);
    }];
    
    
//    [self.volumeSliderView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.sliderView.mas_right).offset(10);
//        make.top.mas_equalTo(self.musicName.mas_bottom).offset(10);
//        make.right.mas_equalTo(-10);
//        make.height.mas_equalTo(10);
//    }];
//
//    [self.volumeImgageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.volumeSliderView);
//        make.top.mas_equalTo(self.volumeSliderView.mas_bottom).offset(10);
//        make.height.mas_equalTo(25);
//        make.width.mas_equalTo(25);
//    }];
    
    
    
    [self.lianView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.playAndPauseBtn.mas_bottom).offset(15);
        make.left.mas_equalTo(self.bgBottonView).offset(13);
        make.right.mas_equalTo(self.bgBottonView).offset(-13);
        make.height.mas_equalTo(0.5);
    }];
    [self.titleBottonLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lianView.mas_bottom).offset(15);
        make.left.mas_equalTo(self.bgBottonView.mas_left).offset(20);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleBottonLB.mas_bottom).offset(10);
        make.left.mas_equalTo(self.bgBottonView).offset(10);
        make.right.mas_equalTo(self.bgBottonView).offset(-10);
        make.bottom.mas_equalTo(self.bgBottonView).offset(-15);
    }];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(5);
        [make.right.mas_equalTo(self)setOffset:-5];
        [make.bottom.mas_equalTo(self.mas_bottom)setOffset:-10];
        make.height.equalTo(@(5));
    }];
    
    
    
}
- (void)singleTapGesture:(UITapGestureRecognizer *)tap{
    [self removeFromSuperview];
}
//歌单
- (void)musicFileClick:(UIButton *)sender{
    [self removeFromSuperview];
    ! self.musicFileClickBlock ?: self.musicFileClickBlock();
}
//循环方式
- (void)orderButtonClick:(UIButton *)sender{
    if ([self.circular isEqualToString:@"list"]) {
        [self.orderButton setBackgroundImage:[UIImage imageNamed:@"room_music_suiji"] forState:UIControlStateNormal];
        self.circular = @"rand";
    }else{
        [self.orderButton setBackgroundImage:[UIImage imageNamed:@"room_music_xunhuan"] forState:UIControlStateNormal];
        self.circular = @"list";
    }
    ! self.orderButtonClickBlock ?: self.orderButtonClickBlock(self.circular);
}
//上一曲
- (void)onAButtonClick:(UIButton *)sender{
    ! self.onAButtonClickBlock ?: self.onAButtonClickBlock();
}
//下一曲
- (void)nextButtonClick:(UIButton *)sender{
    ! self.nextButtonClickBlock ?: self.nextButtonClickBlock();
}
//播放暂停
- (void)playAndPauseButonClick:(UIButton *)sender{
    if ([self.model.is_music integerValue] != 1) {
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:getLanguage(@"暂无可播放歌曲请去添加")];
        return;
    }
    if (self.isPlay) {
        [self.playAndPauseBtn setBackgroundImage:[UIImage imageNamed:@"room_music_zanting"] forState:UIControlStateNormal];
        self.isPlay = NO;
    }else{
        [self.playAndPauseBtn setBackgroundImage:[UIImage imageNamed:@"room_music_bofang"] forState:UIControlStateNormal];
        self.isPlay = YES;
    }
    ! self.playAndPauseButonClickBlock ?: self.playAndPauseButonClickBlock(self.model, self.isPlay);
}
- (void)setSliderCurrentValue:(CGFloat )currentValue maximumValue:(CGFloat)maximumValue{
    
    self.sliderView.value = currentValue;
    self.sliderView.maximumValue = maximumValue;
}
- (void)setSliderPlay{
    [self.playAndPauseBtn setBackgroundImage:[UIImage imageNamed:@"room_music_bofang"] forState:UIControlStateNormal];
    self.isPlay = YES;
    self.sliderView.value = 0;
}

- (void)sliderValueChanged:(UISlider *)slider{
    ! self.sliderValueChangedBlock ?: self.sliderValueChangedBlock(slider.value);
}

- (void)volumeSliderValueChanged:(UISlider *)slider{
    ! self.volumeSliderValueChangedBlock ?: self.volumeSliderValueChangedBlock(slider.value);
}

- (void)setModel:(RoomMusicModel *)model{
    _model = model;
    if ([model.is_music integerValue] == 1) {
        self.musicName.text = model.music_name;
    }else{
        self.musicName.text = getLanguage(@"暂无可播放歌曲请去添加");
    }
}
- (void)setSoundArray:(NSMutableArray *)soundArray{
    _soundArray = soundArray;
    self.pageControl.numberOfPages = soundArray.count / 6;
    
    [self.collectionView reloadData];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.soundArray.count;
}

- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    RoomMusicCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RoomMusicCollectionCell" forIndexPath:indexPath];
    cell.musicModel = self.soundArray[indexPath.row];
    
    return cell;
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger Page = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    self.pageControl.currentPage = Page;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MYLog(@"点击了第%zd个推荐的商品",indexPath.row);
    ! self.playSoundClickBlock ?: self.playSoundClickBlock(self.soundArray[indexPath.row]);
    [self removeFromSuperview];
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(_collectionView.width / 3, _collectionView.height / 2);
}

- (UIView *)maskTopView{
    if (!_maskTopView) {
        _maskTopView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:[UIColor blackColor]];
        _maskTopView.alpha = 0.1;
    }
    return _maskTopView;
}
- (UIView *)bgTopView{
    if (!_bgTopView) {
        _bgTopView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:[UIColor clearColor]];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
        [_bgTopView addGestureRecognizer:singleTap];
    }
    return _bgTopView;
}
- (UIView *)maskBottonView{
    if (!_maskBottonView) {
        _maskBottonView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:[UIColor blackColor]];
        _maskBottonView.alpha = 0.7;
    }
    return _maskBottonView;
}
- (UIView *)bgBottonView{
    if (!_bgBottonView) {
        _bgBottonView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:[UIColor clearColor]];
    }
    return _bgBottonView;
}
- (UILabel *)titleLB{
    if (!_titleLB) {
        _titleLB = [ControlCreator createLabel:nil rect:CGRectZero text:getLanguage(@" 音乐") font:Font(16) color:[UIColor whiteColor] backguoundColor:[UIColor clearColor] align:NSTextAlignmentCenter lines:1];
    }
    return _titleLB;
}
- (UILabel *)musicName{
    if (!_musicName) {
        _musicName = [ControlCreator createLabel:nil rect:CGRectZero text:getLanguage(@"暂无可播放歌曲") font:Font(14) color:[UIColor whiteColor] backguoundColor:[UIColor clearColor] align:NSTextAlignmentCenter lines:1];
    }
    return _musicName;
}
- (UIButton *)musicFile{
    if (!_musicFile) {
        _musicFile = [ControlCreator createButton:nil rect:CGRectZero text:@"" font:nil color:[UIColor clearColor] backguoundColor:[UIColor clearColor] imageName:@"room_music_gedan" target:self action:@selector(musicFileClick:)];
    }
    return _musicFile;
}
- (UIButton *)orderButton{
    if (!_orderButton) {
        _orderButton = [ControlCreator createButton:nil rect:CGRectZero text:@"" font:Font(15) color:[UIColor clearColor] backguoundColor:[UIColor clearColor] imageName:@"room_music_xunhuan" target:self action:@selector(orderButtonClick:)];
    }
    return _orderButton;
}
- (UISlider *)sliderView{
    if (!_sliderView) {
        _sliderView = [[UISlider alloc] init];
        _sliderView.maximumTrackTintColor = MHColorFromHexString(@"#B7AEAE");
        _sliderView.minimumTrackTintColor = MLControlsColor;
        _sliderView.value = 0;
        _sliderView.continuous = NO;
        [_sliderView setThumbImage:[UIImage imageNamed:@"room_music_jindu"] forState:UIControlStateNormal];
        [_sliderView addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _sliderView;
}
- (UIButton *)onAButton{
    if (!_onAButton) {
        _onAButton = [ControlCreator createButton:nil rect:CGRectZero text:@"" font:Font(15) color:[UIColor clearColor] backguoundColor:[UIColor clearColor] imageName:@"room_music_shang" target:self action:@selector(onAButtonClick:)];
    }
    return _onAButton;
}
- (UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [ControlCreator createButton:nil rect:CGRectZero text:@"" font:Font(15) color:[UIColor clearColor] backguoundColor:[UIColor clearColor] imageName:@"room_music_xia" target:self action:@selector(nextButtonClick:)];
    }
    return _nextBtn;
}
- (UIButton *)playAndPauseBtn{
    if (!_playAndPauseBtn) {
        _playAndPauseBtn = [ControlCreator createButton:nil rect:CGRectZero text:@"" font:Font(15) color:[UIColor clearColor] backguoundColor:[UIColor clearColor] imageName:@"room_music_bofang" target:self action:@selector(playAndPauseButonClick:)];
    }
    return _playAndPauseBtn;
}


-(UIImageView *)volumeImgageView{
    if (!_volumeImgageView) {
        _volumeImgageView=[[UIImageView alloc] init];
        _volumeImgageView.image=KGetImage(@"room_music_volume");
    }
    return _volumeImgageView;
}


- (UISlider *)volumeSliderView{
    if (!_volumeSliderView) {
        _volumeSliderView = [[UISlider alloc] init];
        _volumeSliderView.maximumTrackTintColor = MHColorFromHexString(@"#B7AEAE");
        _volumeSliderView.minimumTrackTintColor = MLControlsColor;
        _volumeSliderView.minimumValue = 0.0;// 设置最小值
        _volumeSliderView.maximumValue = 100.0;// 设置最大值
        _volumeSliderView.value = 60.0;
        _volumeSliderView.continuous = NO;
        [_volumeSliderView setThumbImage:[UIImage imageNamed:@"room_music_jindu"] forState:UIControlStateNormal];
        [_volumeSliderView addTarget:self action:@selector(volumeSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _volumeSliderView;
}


- (UIView *)lianView{
    if (!_lianView) {
        _lianView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:[UIColor whiteColor]];
    }
    return _lianView;
}
- (UILabel *)titleBottonLB{
    if (!_titleBottonLB) {
        _titleBottonLB = [ControlCreator createLabel:nil rect:CGRectZero text:getLanguage(@"音效") font:Font(14) color:[UIColor whiteColor] backguoundColor:[UIColor clearColor] align:NSTextAlignmentLeft lines:1];
    }
    return _titleBottonLB;
}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *dcFlowLayout = [UICollectionViewFlowLayout new];
        dcFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        dcFlowLayout.minimumLineSpacing = dcFlowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:dcFlowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[RoomMusicCollectionCell class] forCellWithReuseIdentifier:@"RoomMusicCollectionCell"];
        [self addSubview:_collectionView];
        
    }
    return _collectionView;
}
- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.hidesForSinglePage = YES;
        _pageControl.numberOfPages = 2;
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    }
    return _pageControl;
}

@end
