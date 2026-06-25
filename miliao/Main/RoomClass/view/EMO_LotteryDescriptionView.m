//
//  EMO_LotteryDescriptionView.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/26.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_LotteryDescriptionView.h"
#import "EMO_LotteryCollectionViewCell.h"

@interface EMO_LotteryDescriptionView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong) UIView * bgView;
@property(nonatomic,strong) UIButton * backBtn;
@property(nonatomic,strong) UILabel * tipLabel;
@property(nonatomic,strong) UILabel * contentLabel;
@property(nonatomic,strong) NSMutableArray * listArr;
@property(nonatomic,strong) UICollectionView * collectionView;

@end


@implementation EMO_LotteryDescriptionView

-(NSMutableArray *)listArr{
    if (!_listArr) {
        _listArr=[NSMutableArray array];
    }
    return _listArr;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.backgroundColor=[UIColor clearColor];
        self.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture)];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

- (void)singleTapGesture{
    self.hidden=YES;

}

-(void)setContenStr:(NSString *)contenStr{
    _contenStr=contenStr;
    self.contentLabel.text=contenStr;
    [self.collectionView reloadData];
    
    
}


-(void)initView{
    [self bgView];
    [self backBtn];
    [self tipLabel];
    [self collectionView];
    
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = kWhiteColor;
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.bottom.mas_equalTo(KAdaptedHeight(20));
            make.height.mas_equalTo(KAdaptedHeight(530));
        }];
        setViewCorner(_bgView, KAdaptedHeight(20));
    }
    return _bgView;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
        _backBtn.tag=100;
        _backBtn.layer.cornerRadius=KAdaptedWidth(25/2);
        _backBtn.layer.masksToBounds=YES;
        [_backBtn addTarget:self action:@selector(singleTapGesture) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(KAdaptedWidth(25));
            make.top.mas_equalTo(KAdaptedHeight(10));
            make.leading.mas_equalTo(KAdaptedWidth(17));
        }];
    }
    return _backBtn;
}


- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
//        _tipLabel.backgroundColor=kRedColor;
        _tipLabel.text = getLanguage(@"礼物说明");
        _tipLabel.textColor = Color(51, 51, 51, 1);
        _tipLabel.textAlignment=NSTextAlignmentCenter;
        _tipLabel.font=KFont(14);
        [self.bgView addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedHeight(40));
            make.trailing.mas_equalTo(KAdaptedHeight(-40));
            make.height.mas_equalTo(KAdaptedWidth(25));
            make.top.mas_equalTo(KAdaptedHeight(10));
        }];
    }
    return _tipLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.text =self.contenStr;
        _contentLabel.textColor = Color(51, 51, 51, 0.8);
        _contentLabel.textAlignment=NSTextAlignmentCenter;
        _contentLabel.font=KFont(13);
        _contentLabel.numberOfLines=0;

    }
    return _contentLabel;
}

#pragma mark - 懒加载UIcollectionCell
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
         _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.scrollsToTop = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces=YES;
        _collectionView.showsVerticalScrollIndicator=NO;
        _collectionView.backgroundColor=[UIColor clearColor];
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [_collectionView registerClass:[EMO_LotteryCollectionViewCell class] forCellWithReuseIdentifier:@"EMO_LotteryCollectionViewCell"];
            [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerA"];
        [self.bgView addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(KAdaptedHeight(5));
            make.leading.mas_equalTo(KAdaptedWidth(0));
            make.trailing.mas_equalTo(KAdaptedWidth(-0));
            make.bottom.mas_equalTo(-KSAFEAREA_BOTTOM_HEIHGHT-KAdaptedHeight(10));
        }];
    }
    return _collectionView;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
         UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerA" forIndexPath:indexPath];
            [header addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedHeight(13));
            make.trailing.mas_equalTo(KAdaptedWidth(-13));
            make.bottom.mas_equalTo(KAdaptedHeight(-10));
            make.top.mas_equalTo(KAdaptedHeight(10));
        }];

        return header;
    
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
   
        CGSize textWidth = [self.contenStr sizeWithFont:KFontA(13) maxSize:CGSizeMake(kWidth-KAdaptedWidth(30), CGFLOAT_MAX)];
    return CGSizeMake(kWidth,textWidth.height+KAdaptedHeight(50));
//        return CGSizeMake(kWidth,KAdaptedHeight(130));
        
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, KAdaptedWidth(10), 0, KAdaptedWidth(10));
 
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake(KAdaptedWidth(80), KAdaptedHeight(90));

   
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.listArr.count;

    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EMO_LotteryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EMO_LotteryCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *dic=self.listArr[indexPath.row];
    cell.dicData=dic;

    return cell;
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
  
    
}


-(void)setType:(NSInteger)type{
    _type=type;
    
//    [self addData:type];
    [self addData:1];
}

-(void)addData:(NSInteger)type{
    
    [NetworkRequest POST:Request_GetDrawProbability parmeters:@{@"draw_id":@(self.type)} success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        [self.listArr addObjectsFromArray:baseModel.data];
        [self.collectionView reloadData];

    } failture:^(NSError *error) {


    }];
    
    
    
}




@end
