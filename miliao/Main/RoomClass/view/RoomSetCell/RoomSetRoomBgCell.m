//
//  RoomSetRoomBgCell.m
//  miliao
//
//  Created by aa on 2019/7/4.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "RoomSetRoomBgCell.h"
#import "Global.h"

@interface RoomBgViewCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *checkImage;

@property (nonatomic, strong) NSDictionary *model;

@end

@implementation RoomBgViewCollectionCell

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self addSomeViews];
    }
    return self;
}
- (void)addSomeViews{
    [self.contentView addSubview:self.bgImageView];
    [self.contentView addSubview:self.checkImage];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(3);
        make.right.mas_equalTo(self).offset(-3);
    }];
    [self.checkImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgImageView.mas_top).offset(2);
        make.right.mas_equalTo(self.bgImageView).offset(-2);
        make.height.mas_equalTo(13);
        make.width.mas_equalTo(13);
    }];
}

- (void)setModel:(NSDictionary *)model{
    _model = model;
    
    if ([model[@"is_choose"] integerValue] == 1) {
        self.checkImage.hidden = NO;
    }else{
        self.checkImage.hidden = YES;
    }
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model[@"image"]]];
    
}

- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [ControlCreator createImageView:nil rect:CGRectZero imageName:@"" backguoundColor:[UIColor clearColor]];
        _bgImageView.layer.masksToBounds = YES;
        _bgImageView.layer.cornerRadius = 7;
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImageView;
}
- (UIImageView *)checkImage{
    if (!_checkImage) {
        _checkImage = [ControlCreator createImageView:nil rect:CGRectZero imageName:@"room_set" backguoundColor:[UIColor clearColor]];
    }
    return _checkImage;
}


@end


@interface RoomSetRoomBgCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel *roomNameLB;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *bgView;

@end

@implementation RoomSetRoomBgCell

#pragma mark - 快速创建cell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"RoomSetRoomBgCell";
    
    RoomSetRoomBgCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[RoomSetRoomBgCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        //        cell.selectedBackgroundView = cell.seletView ;
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSomeViews];
    }
    return self;
}

- (void)setBgViewArray:(NSMutableArray *)bgViewArray{
    _bgViewArray = bgViewArray;
    [self.collectionView reloadData];
}

- (void)addSomeViews{
    [self.contentView addSubview:self.roomNameLB];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.bgView];
    [self.roomNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.top.mas_equalTo(self).offset(20);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(14);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.roomNameLB.mas_bottom).offset(10);
        make.left.mas_equalTo(self).offset(10);
        make.right.mas_equalTo(self).offset(-10);
        make.bottom.mas_equalTo(self).offset(-10);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(11);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(self).offset(-11);
        make.bottom.mas_equalTo(self);
    }];
    
}

- (UILabel *)roomNameLB{
    if (!_roomNameLB) {
        _roomNameLB = [ControlCreator createLabel:nil rect:CGRectMake(0, 0, 0, 0) text:@"房间背景" font:Font(14) color:mainViceColor backguoundColor:[UIColor clearColor] align:NSTextAlignmentLeft lines:1];
    }
    return _roomNameLB;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [ControlCreator createView:nil rect:CGRectMake(0, 0, 0, 0) backguoundColor:MLControlsHuiColor];
    }
    return _bgView;
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
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[RoomBgViewCollectionCell class] forCellWithReuseIdentifier:@"RoomBgViewCollectionCell"];
        [self.contentView addSubview:_collectionView];
        
    }
    return _collectionView;
}
#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.bgViewArray.count;
}

- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RoomBgViewCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RoomBgViewCollectionCell" forIndexPath:indexPath];
    cell.model = self.bgViewArray[indexPath.row];
    return cell;
}


#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *model = [NSMutableDictionary dictionaryWithDictionary:self.bgViewArray[indexPath.row]];
    [model setObject:@"1" forKey:@"is_choose"];
    
    NSInteger i=0;
    NSMutableArray *arr=self.bgViewArray.mutableCopy;
    for (NSDictionary *dic in self.bgViewArray) {
        NSMutableDictionary *dicD=[NSMutableDictionary dictionaryWithDictionary:dic];
        if ([dicD[@"id"] integerValue] != [model[@"id"] integerValue] ) {
            [dicD setObject:@"0" forKey:@"is_choose"];
        }else{
            [dicD setObject:@"1" forKey:@"is_choose"];
        }
        [arr replaceObjectAtIndex:i withObject:dicD];
        i++;
    }
    self.bgViewArray=arr;
    
    ! self.roomBgViewClickBlock ?: self.roomBgViewClickBlock(model);
    [self.collectionView reloadData];
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(90, _collectionView.height);
}


@end
