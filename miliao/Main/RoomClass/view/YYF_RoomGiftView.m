//
//  YYF_RoomGiftView.m
//  miliao
//
//  Created by 张世浩 on 2022/12/6.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "YYF_RoomGiftView.h"
#import "XHInputView.h"
#import "RoomGiftModel.h"
#import "BJGiftViewCell.h"
#import "RoomUsersCollectionViewCell.h"
#import "UserFlowLayout.h"
#import "BAButton.h"
#import "HLHorizontalPageLayout.h"
#import "HorizontallyPageableFlowLayout.h"
#define Room_btn_mainColor MHColorFromHexString(@"#BD4AFF")
#import "RoomFuDaiModel.h"
#import "MLChatRoomThemeGameFourView.h"
#import "CustomAlertViewA.h"
#import "BJGiftViewCell.h"
#import "MLGiftLockManager.h"
static const CGFloat kMaxRowCount = 2.f;
static const CGFloat kItemCountPerRow = 4.f;

@interface YYF_RoomGiftView ()<
UITableViewDelegate, UITableViewDataSource,
SVGAPlayerDelegate,
UICollectionViewDataSource, UICollectionViewDelegate,
UIGestureRecognizerDelegate,XHInputViewDelagete>

@property (nonatomic, strong) UIView            *bgView;
@property (nonatomic, strong) UIView            *maskMyView;
@property (nonatomic, strong) UIView            *bottomBgView;
@property (nonatomic, strong) UIImageView            *bgImgView;
@property (nonatomic, strong) UIImageView       *bgUserImage;
@property (nonatomic, strong) UIImageView       *bgImageView;

@property (nonatomic, strong) NSMutableArray    *userCarouselArray;
@property (nonatomic, strong) NSMutableArray    *giftCarouseArray;
@property (nonatomic, strong) NSArray           *numArray;

@property (nonatomic, strong) RoomFuDaiModel     *fuDaiModel;             ///<  要赠送福袋
@property (nonatomic, strong) RoomGiftModel     *giftModel;             ///<  要赠送礼物
@property (nonatomic, strong) NSString          *giftNum;               ///<  要赠送的数量

@property (nonatomic, strong) SVGAPlayer       *giftSelectedImage;      ///< 赠送大红嘴动画
@property (nonatomic, strong) UIPageControl *pageControl;           ///< 礼物翻页指示器
@property (nonatomic, strong) UICollectionView *collectView;//礼物
@property(nonatomic, strong) UICollectionView *usersCollectionView;//顶部选人
@property(nonatomic, copy) NSArray *usersArray;//麦位数组，包括空麦位

@property (nonatomic, strong) HorizontallyPageableFlowLayout *layout;
//样式修改与 2020.03.16   马方圆

@property(nonatomic,strong) UIView * numBgView;//赠送数量背景
@property(nonatomic, strong) UIView *topView;//
@property(nonatomic, strong) UILabel *backPackLabel;//背包总价
@property(nonatomic, strong) UIButton *senderBackPackBtn;//背包全部送出

@property(nonatomic, strong) UIView *ButtonView;//按钮背景
@property(nonatomic, strong) UIButton *giftButton;//礼物按钮
@property(nonatomic, strong) UIButton *beibaoButton;//背包
@property(nonatomic, strong) UIButton *fudaiButton;//福袋
@property(nonatomic, strong) UIButton *tequanButton;//特权
@property(nonatomic, strong) UIButton *synthesizeGiftButton;//合成礼物
@property(nonatomic, strong) NSArray *tequanArray;//特权本地数据

@property(nonatomic, strong) WZDLayoutButton *chargeButton;//充值按钮
@property(nonatomic, strong) UIButton *selectAllButton;//全麦
@property(nonatomic, strong) NSMutableArray *usersIsSelectedArray;//被选中的数组，麦位没人不能选
@property(nonatomic, strong) NSMutableArray *hasSelectUsers;//已经选中的人的数组
@property(nonatomic, strong) NSIndexPath *lastSeletedIndex;//上次选中的礼物
@property(nonatomic, assign) BOOL isSelectedBeibao;//是否选中了背包礼物
@property(nonatomic, assign) NSInteger allNum;
@property(nonatomic,assign) NSInteger changeHeight;
@property (nonatomic, strong) XHInputView *inputViewStyleDefault;
@end



@implementation YYF_RoomGiftView
static SVGAParser *parser;

- (void)setMyArray:(NSMutableArray *)myArray {
    _myArray = myArray;
    NSString *currentUid = [UserManager userInfo].user_id;
    for (RoomGiftModel *gift in _myArray) {
        if ([gift isKindOfClass:[RoomGiftModel class]]) {
            NSString *gid = [gift realGiftId];
            gift.isLocked = [[MLGiftLockManager sharedManager] isGiftLockedWithUserId:currentUid giftId:gid];
        }
    }
}

#pragma mark -
#pragma mark UICollectionView delegate

// 分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}

- (nonnull UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout
{
    return nil;
}
// 每一分区的单元个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView==self.usersCollectionView) {
           return self.allNum;
    }else if(collectionView==self.collectView){
        return self.giftCarouseArray.count;
    }
    return 0;
}
////每个单元的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==self.collectView) {
        return CGSizeMake(ScreenWidth/4.0, ScreenWidth/4.0+20);
    }
    return CGSizeMake(50, 60);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView==self.collectView) {
        BJGiftViewCell *cell = [BJGiftViewCell cellWithCollectionView:collectionView forIndexPath:indexPath];
        if ( [[self.giftCarouseArray objectAtIndex:indexPath.item] isKindOfClass:[RoomGiftModel class]]) {
            RoomGiftModel *model = [self.giftCarouseArray objectAtIndex:indexPath.item];
            [cell configWithModel:model Index:self.currentType andIndexpath:indexPath];
        }else{
            RoomFuDaiModel *model = [self.giftCarouseArray objectAtIndex:indexPath.item];
            [cell configWithFuDaiModel:model Index:self.currentType andIndexpath:indexPath];
        }
        [cell getIsSelected:NO andIndex:self.currentType andShow:NO];
        WeakSelf;
        cell.sendGiftClick = ^(NSInteger num) {
            self.changeHeight=0;
            self.numBgView.hidden=YES;
            [self upDataView];
            self.giftNum=[NSString stringWithFormat:@"%ld",num];
            [self handselBUttonClick];
        };
        cell.GiftBtnClick = ^(NSInteger type, NSIndexPath * _Nonnull indexPath) {
            [wself songBtnClick:type andIndexPath:indexPath];
            if(type==2){
                self.changeHeight=40;
                self.numBgView.hidden=NO;
                [self upDataView];
            }
        };
        cell.giftLongPressBlock = ^(RoomGiftModel * _Nonnull giftModel, NSIndexPath * _Nonnull indexPath) {
            if (wself.currentType != 2) return;
            BOOL newLockState = !giftModel.isLocked;
            giftModel.isLocked = newLockState;
            NSString *currentUid = [UserManager userInfo].user_id;
            NSString *gid = [giftModel realGiftId];
            [[MLGiftLockManager sharedManager] updateLockStateWithUserId:currentUid giftId:gid isLocked:newLockState];
            [wself.collectView reloadItemsAtIndexPaths:@[indexPath]];
            if (newLockState) {
                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"已锁定【%@】，全部送出时将保留", giftModel.name ?: @"该礼物"]];
            } else {
                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"已解除【%@】的锁定", giftModel.name ?: @"该礼物"]];
            }
        };
        return cell;
    }else if(collectionView ==self.usersCollectionView){
        RoomUsersCollectionViewCell *cell = [RoomUsersCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath];
        MLRoomMSequenceModel *model = [self.usersArray objectAtIndex:indexPath.item];
        [cell configWithModel:model isSelect:[self.usersIsSelectedArray[indexPath.item] integerValue]];
        
        if (indexPath.item==0) {
            [cell.nameLabel setTitle:getLanguage(@"房主") forState:UIControlStateNormal];
//            [cell.nameLabel setBackgroundImage:ImageNamed(@"tingZhuImg") forState:UIControlStateNormal];
                  
        }else{
            [cell.nameLabel setTitle:[NSString stringWithFormat:@"%ld号麦",model.num] forState:UIControlStateNormal];
//            [cell.nameLabel setTitle:[NSString stringWithFormat:@"%ld",indexPath.item] forState:UIControlStateNormal];
          
        }
        cell.nameLabel.backgroundColor=BaseMainColor;
        return cell;
    }

    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.isSelectedBeibao = YES;
    
    if(collectionView==self.usersCollectionView){
        MLRoomMSequenceModel *model = self.usersArray[indexPath.item];
        if ([model.status isEqualToString:@"2"]) {
//            if ([model.uid integerValue] ==[[UserManager userInfo].user_id  integerValue]) {
//                //如果是本人，不能点击
//            }else{
//                //还需要判断当前的选择状态
//                if ([self.usersIsSelectedArray[indexPath.item] integerValue]==1) {
//                    //麦位有人
//                    [self.usersIsSelectedArray replaceObjectAtIndex:indexPath.item withObject:@(2)];
//                }else{
//                    [self.usersIsSelectedArray replaceObjectAtIndex:indexPath.item withObject:@(1)];
//                }
//                [self.usersCollectionView reloadData];
//            }
            //还需要判断当前的选择状态
            if ([self.usersIsSelectedArray[indexPath.item] integerValue]==1) {
                //麦位有人
                [self.usersIsSelectedArray replaceObjectAtIndex:indexPath.item withObject:@(2)];
            }else{
                [self.usersIsSelectedArray replaceObjectAtIndex:indexPath.item withObject:@(1)];
            }
            [self.usersCollectionView reloadData];

        }
    }
    
//    if (collectionView==self.collectView) {
////        [self resignResponder];
//        if ([self.giftCarouseArray[0] isKindOfClass:[RoomGiftModel class]]) {
//            [self.giftCarouseArray enumerateObjectsUsingBlock:^(RoomGiftModel  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                obj.is_check = @"0";
//            }];
//        }
//        //上次选中的礼物cell
//        BJGiftViewCell *lastCell = (BJGiftViewCell *)[collectionView cellForItemAtIndexPath:self.lastSeletedIndex];
//        if(self.lastSeletedIndex ==indexPath){
//            [lastCell getIsSelected:NO andIndex:self.currentType andShow:YES];
//            self.changeHeight=0;
//            self.numBgView.hidden=YES;
//            [self upDataView];
//        }else{
//            [lastCell getIsSelected:NO andIndex:self.currentType andShow:NO];
//        }
//        //当前选中的礼物cell，覆盖掉之前的
//        if ([self.giftCarouseArray[0] isKindOfClass:[RoomGiftModel class]]) {
//            RoomGiftModel *model = self.giftCarouseArray[indexPath.item];
//            BJGiftViewCell *cell = (BJGiftViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//            [cell getIsSelected:YES andIndex:self.currentType andShow:NO];
//            self.giftModel = model;
////            if (self.currentType==2&&[self.giftNumButton.titleLabel.text isEqualToString:getLanguage(@"全部")]) {
////                self.giftNum = self.giftModel.num;
////            }
//            self.lastSeletedIndex = indexPath;
//
////            [self handselBUttonClick];
//
//        }else{
////            self.fuDaiView.hidden=NO;
//            RoomFuDaiModel *model = self.giftCarouseArray[indexPath.item];
////            self.fuDaiView.DicModel=model;
//            BJGiftViewCell *cell = (BJGiftViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//            [cell getIsSelected:YES andIndex:self.currentType andShow:NO];
//            self.fuDaiModel = model;
////            if (self.currentType==2&&[self.giftNumButton.titleLabel.text isEqualToString:getLanguage(@"全部")]) {
////                self.giftNum = self.fuDaiModel.num;
////            }
//            self.lastSeletedIndex = indexPath;
//
//            [CustomAlertViewA showAlertView_Type:AlertType_Bottom ContentType:BlessingBagCustomCententViewTag andData:@{@"data":self.fudaiArray}];
//
//        }
//
//    }
//        else{
//
//        MLRoomMSequenceModel *model = self.usersArray[indexPath.item];
//        if ([model.status isEqualToString:@"2"]) {
//                //还需要判断当前的选择状态
//                if ([self.usersIsSelectedArray[indexPath.item] integerValue]==1) {
//                    //麦位有人
//                    [self.usersIsSelectedArray replaceObjectAtIndex:indexPath.item withObject:@(2)];
//                }else{
//                    [self.usersIsSelectedArray replaceObjectAtIndex:indexPath.item withObject:@(1)];
//                }
//                [self.usersCollectionView reloadData];
//
//
//        }
//    }
}

#pragma mark 礼物选择 cell点击事件
-(void)songBtnClick:(NSInteger )type andIndexPath:(NSIndexPath *)indexPath{
    self.isSelectedBeibao = YES;
    if (self.giftCarouseArray.count == 0 || indexPath.item >= self.giftCarouseArray.count) {
        return;
    }
    id firstObj = self.giftCarouseArray.firstObject;
    if ([firstObj isKindOfClass:[RoomGiftModel class]]) {
        [self.giftCarouseArray enumerateObjectsUsingBlock:^(RoomGiftModel  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[RoomGiftModel class]]) {
                obj.is_check = @"0";
            }
        }];
    }
    
    // 如果点击的是另一个cell，取消上次选中的cell状态
    if (self.lastSeletedIndex && self.lastSeletedIndex != indexPath) {
        BJGiftViewCell *lastCell = (BJGiftViewCell *)[self.collectView cellForItemAtIndexPath:self.lastSeletedIndex];
        [lastCell getIsSelected:NO andIndex:self.currentType andShow:NO];
    }
    
    // 当前选中的礼物cell
    if ([firstObj isKindOfClass:[RoomGiftModel class]]) {
        RoomGiftModel *model = self.giftCarouseArray[indexPath.item];
        BJGiftViewCell *cell = (BJGiftViewCell *)[self.collectView cellForItemAtIndexPath:indexPath];
        [cell getIsSelected:YES andIndex:self.currentType andShow:NO];
        self.giftModel = model;
        self.lastSeletedIndex = indexPath;
        
        // 只有点击“投喂”按钮 (type == 1) 时才真正送出
        if (type == 1) {
            [self handselBUttonClick];
        }
    } else {
        RoomFuDaiModel *model = self.giftCarouseArray[indexPath.item];
        BJGiftViewCell *cell = (BJGiftViewCell *)[self.collectView cellForItemAtIndexPath:indexPath];
        [cell getIsSelected:YES andIndex:self.currentType andShow:NO];
        self.fuDaiModel = model;
        self.lastSeletedIndex = indexPath;
        
        if (self.currentType == 4) {
            UIView *parentView = self.superview;
            [self removeFromSuperview];
            [MLChatRoomThemeGameFourView showInView:parentView typeId:[model.fuDaiID integerValue]];
        } else {
            [CustomAlertViewA showAlertView_Type:AlertType_Bottom ContentType:BlessingBagCustomCententViewTag andData:@{@"data":self.fudaiArray}];
        }
    }
}



//#pragma mark Table view delegate
//
//- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//
//    return self.numArray.count;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
//        cell.backgroundColor = kClearColor;
//        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
//        cell.textLabel.textAlignment = NSTextAlignmentCenter;
//        cell.textLabel.textColor = RGBA(222, 237, 255, 1);
//        cell.textLabel.font = Font(12);
//    }
//    cell.textLabel.text = NSStringFormat(@"x%@",self.numArray[indexPath.row]);
//    if (self.numArray.count==7&&indexPath.row==0) {
//        cell.textLabel.text = NSStringFormat(@"%@",self.numArray[indexPath.row]);
//    }
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [self.tableBgView removeFromSuperview];
//    self.isTableBgView = YES;
//    if (tableView == self.tableView) {//选赠送倍率
//        self.giftNum = self.numArray[indexPath.row];
//        [self.giftNumButton setTitle:NSStringFormat(@"x%@",self.numArray[indexPath.row]) forState:UIControlStateNormal];
//        if (self.numArray.count==7&&indexPath.row==0) {
//            [self.giftNumButton setTitle:NSStringFormat(@"%@",self.numArray[indexPath.row]) forState:UIControlStateNormal];
//        }
//    }
//}
///**
// * 使选择框失去响应
// */
//-(void)resignResponder
//{
//    [self.tableBgView removeFromSuperview];
//    self.isTableBgView = YES;
//}
#pragma mark ======================  赠送礼物按钮事件   ======================
- (void)handselBUttonClick{
    [self.hasSelectUsers removeAllObjects];
    @autoreleasepool {
        for (int i=0; i<self.usersIsSelectedArray.count; i++) {
            if ([self.usersIsSelectedArray[i] isEqualToNumber:@(2)]) {
                MLRoomMSequenceModel *model = self.usersArray[i];

                    [self.hasSelectUsers addObject:model];
            }
        }
    }
    if (self.hasSelectUsers.count==0) {
        [SVProgressHUD showImage:ImageNamed(@"") status:getLanguage(@"请选择送给谁")];
        return;
    }

//    if (self.currentType==2&&self.isSelectedBeibao==NO&&[self.giftNumButton.titleLabel.text isEqualToString:getLanguage(@"全部")]) {
//        [SVProgressHUD showImage:ImageNamed(@"") status:getLanguage(@"请选择要送出的礼物")];
//        return;
//    }
    if (self.currentType==2&&self.isSelectedBeibao==NO) {
        [SVProgressHUD showImage:ImageNamed(@"") status:getLanguage(@"请选择要送出的礼物")];
        return;
    }
    if ([self.giftNum isEqualToString:getLanguage(@"全部")]) {
        
        self.giftNum = self.giftModel.num;
        if (self.hasSelectUsers.count>1) {
            [SVProgressHUD showImage:ImageNamed(@"") status:getLanguage(@"全部送出礼物只能选择一个人")];
            return;
        }
    }
    
    
    if (self.currentType==3) {
        ! self.handselFuDaiBUttonClickBlock ?: self.handselFuDaiBUttonClickBlock(self.hasSelectUsers, self.fuDaiModel, self.giftNum,[NSString stringWithFormat:@"%ld",(long)self.currentType]);
    }else{
        ! self.handselBUttonClickBlock ?: self.handselBUttonClickBlock(self.hasSelectUsers, self.giftModel, self.giftNum,[NSString stringWithFormat:@"%ld",(long)self.currentType]);
    }
    
//    [self.tableBgView removeFromSuperview];
//    self.isTableBgView = YES;
    if (self.currentType==2) {
        [self performSelector:@selector(getGift_listWithParameters) withObject:nil afterDelay:1.0f];
    }
    else{
        [self performSelector:@selector(fudaiList) withObject:nil afterDelay:1.0f];
        [self performSelector:@selector(loadWalletData) withObject:nil afterDelay:0.2];
    }
    self.isSelectedBeibao = NO;
}


#pragma mark 获取余额，
- (void)loadWalletData{
    WeakSelf;
    [NetworkRequest POST:Request_GetMyMoney parmeters:nil success:^(id responObject) {
        BaseModel *model = (BaseModel *)responObject;
        id diamondVal = model.data[@"diamond"];
        [wself.chargeButton setTitle:[NSString stringWithFormat:@"%lld", (long long)[diamondVal longLongValue]] forState:UIControlStateNormal];
    } failture:^(NSError *error) {
        
    }];
    
}
#pragma mark ======================  赠送礼物倍率   ======================
//- (void)giftNumButtonClick:(UIButton *)sender{
//    if (self.currentType==2) {
//        self.numArray = @[getLanguage(@"全部"),@"1314", @"520", @"188", @"66", @"10", @"1"];
//    }else{
//        self.numArray = @[@"1314", @"520", @"188", @"66", @"10", @"1"];
//    }
//    self.tableView.height = self.numArray.count*35+6.5;
//    [self.tableView reloadData];
//    [self.bottomBgView addSubview:self.tableBgView];
//    [self.tableBgView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.giftNumButton).offset(0);
//        make.bottom.mas_equalTo(self.giftNumButton.mas_top).offset(0);
//        make.height.mas_equalTo(self.numArray.count*35+6.5);
//    }];
//}

- (void)setGiftCarouse:(NSMutableArray *)giftCarouseArray userCarousel:(NSMutableArray *)userCarouselArray userMiZuan:(NSString *)miZuan allUsers:(NSArray *)allUsers andUserNum:(NSInteger)allNum{
    [self handleGiftTypeButtonClick:self.giftButton];
//    [self.giftNumButton setTitle:@"x1" forState:UIControlStateNormal];
    [self.usersIsSelectedArray removeAllObjects];
    self.allNum=allNum;
    for (int i=0; i<self.allNum; i++) {
        [self.usersIsSelectedArray addObject:@(1)];
    }
    NSMutableArray *ary = [NSMutableArray array];
    ary = allUsers.mutableCopy;
    [parser parseWithNamed:@"guangquan" inBundle:nil completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
        if (videoItem != nil) {
            self.giftSelectedImage.videoItem = videoItem;
            [self.giftSelectedImage startAnimation];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        MYLog(@">>>>>>>>>>>>%@",error);
    }];
    [self.userCarouselArray removeAllObjects];
    
    if (userCarouselArray.count != 1) {
        [userCarouselArray enumerateObjectsUsingBlock:^(MLRoomMSequenceModel  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *uidStr = obj.uid ? [NSString stringWithFormat:@"%@", obj.uid] : @"";
            if (uidStr.length > 0) {
                [self.userCarouselArray addObject:obj];
            }
        }];
        //插入房主
//        MLRoomMSequenceModel *model = [[MLRoomMSequenceModel alloc] init];
//        model.uid = [MLRoomInformationModel currentAccount].uuid;
//        
//        model.avatar = [MLRoomInformationModel currentAccount].avatar;
////        model.sex = [MLRoomInformationModel currentAccount].sex;
//        model.status = @"2";
//        model.nickname = [MLRoomInformationModel currentAccount].nickname;
//        [ary insertObject:model atIndex:0];
//        [ary removeLastObject];
        self.usersArray = ary.mutableCopy;
//        [self.userCarouselArray insertObject:model atIndex:0];
//        [self.userCarouselArray insertObject:self.userCarouselArray.lastObject atIndex:1];
//        [self.userCarouselArray removeLastObject];
        [self.userCarouselArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MLRoomMSequenceModel *sequenceModel = obj;
            sequenceModel.isSelected = @"0";
//            sequenceModel.MSequence = NSStringFormat(@"%ld",idx);
            if ([sequenceModel.uid integerValue] != [[UserManager userInfo].user_id integerValue] && [sequenceModel.status integerValue] == 2) {
                [self.usersCollectionView reloadData];
            }
        }];
    }else{

//        MLRoomMSequenceModel *model = [[MLRoomMSequenceModel alloc] init];
//        model.uid = [MLRoomInformationModel currentAccount].uuid;
//        model.avatar = [MLRoomInformationModel currentAccount].avatar;
////        model.sex = [MLRoomInformationModel currentAccount].sex;
//        model.status = @"2";
//        model.nickname = [MLRoomInformationModel currentAccount].nickname;
//        [ary insertObject:model atIndex:0];
//        [ary removeLastObject];
        self.usersArray = ary.mutableCopy;
//        [self.userCarouselArray insertObject:model atIndex:0];
//        [self.userCarouselArray insertObject:self.userCarouselArray.lastObject atIndex:1];
//        [self.userCarouselArray removeLastObject];
        [self.userCarouselArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MLRoomMSequenceModel *sequenceModel = obj;
            sequenceModel.isSelected = @"0";
//            sequenceModel.MSequence = NSStringFormat(@"%ld",idx);
            if ([sequenceModel.uid integerValue] != [[UserManager userInfo].user_id integerValue] && [sequenceModel.status integerValue] == 2) {
            }
            
        }];
        [self.usersCollectionView reloadData];
    }
    self.giftCarouseArray = giftCarouseArray;
    [self.chargeButton setTitle:[NSString stringWithFormat:@"%lld", (long long)[miZuan longLongValue]] forState:UIControlStateNormal];
    [self.collectView reloadData];
    if (self.giftCarouseArray.count > 0) {
        if (self.giftCarouseArray.count % 8 == 0) {
            self.pageControl.numberOfPages = self.giftCarouseArray.count/8;
        }
        else{
            self.pageControl.numberOfPages = self.giftCarouseArray.count/8 + 1;
        }
    }
}

- (void)singleTapGesture:(UITapGestureRecognizer *)tap{
//    [self.tableBgView removeFromSuperview];
//    self.isTableBgView = YES;
    [self removeFromSuperview];
    self.giftButton.selected = YES;
    [self.giftButton setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
    [self.giftButton setBackgroundImage:KGetImage(@"giftBgImg") forState:UIControlStateNormal];
    
    self.beibaoButton.selected = NO;
    [self.beibaoButton setTitleColor:RGBA(207, 221, 248, 0.8) forState:UIControlStateNormal];
    [self.beibaoButton setBackgroundImage:KGetImage(@"") forState:UIControlStateNormal];
    
    self.fudaiButton.selected = NO;
    [self.fudaiButton setTitleColor:RGBA(207, 221, 248, 0.8) forState:UIControlStateNormal];
    [self.fudaiButton setBackgroundImage:KGetImage(@"") forState:UIControlStateNormal];
//    self.fuDaiView.hidden=YES;
    
}


#pragma mark 福袋
-(void)fudaiList{
//    WeakSelf;
//    [NetworkRequest POST:Request_GetBoxList parmeters:nil success:^(id responObject) {
//        BaseModel *basemodel=(BaseModel *)responObject;
//        wself.fudaiArray=[RoomFuDaiModel mj_objectArrayWithKeyValuesArray:basemodel.data];
//        if (wself.currentType==3) {
//            wself.giftCarouseArray = self.fudaiArray;
//            [wself.collectView reloadData];
//        }
//    } failture:^(NSError *error) {
//        
//    }];
}



#pragma mark 获取礼物列表
// 获取礼物列表
- (void)getGift_listWithParameters{
    [self fudaiList];

    /** 原来的接口   2026-01-17替换 为 gift_giftList
     Request_GetGiftList
     */
    
    WeakSelf;
    [NetworkRequest POST:gift_giftList parmeters:nil success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        NSMutableArray *arry = [RoomGiftModel mj_objectArrayWithKeyValuesArray:basemodel.data[@"data"]];
            wself.giftArray =arry;
             if (self.currentType==1) {
                    self.giftCarouseArray = self.giftArray;
                    if ([[[UIDevice currentDevice] systemVersion] floatValue]<13) {
                        [self refreshLayout];
                    }
                 /** 刷新*/
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self.collectView reloadData];
                 });
                }else if (self.currentType==2) {
                    if (self.myArray.count == 0) {
                        self.isSelectedBeibao=NO;
                        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"我的背包暂无可发送物品"];
                        self.giftCarouseArray = self.giftArray;
                        self.currentType = 1;
                        [self.giftButton setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
                        [self.beibaoButton setTitleColor:RGBA(207, 221, 248, 0.8) forState:UIControlStateNormal];
                        [self.fudaiButton setTitleColor:RGBA(207, 221, 248, 0.8) forState:UIControlStateNormal];
                        if ([[[UIDevice currentDevice] systemVersion] floatValue]<13) {
                            [self refreshLayout];
                        }
                        [self.collectView reloadData];
                        return;
                    }else{
                        self.giftCarouseArray = self.myArray;
                        if ([[[UIDevice currentDevice] systemVersion] floatValue]<13) {
                            [self refreshLayout];
                        }
                        [self.collectView reloadData];
                    }
                }
//                NSString *mizuanStr = [NSString stringWithFormat:@"%@",response[@"data"][@"mizuan"]];
//                [self.chargeButton setTitle:[NSString stringWithFormat:@"%@ >",[Common isNullNumber:mizuanStr]] forState:UIControlStateNormal];
                [self.usersCollectionView reloadData];

        
    } failture:^(NSError *error) {
        
    }];
    
    
    
}
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    
    //获得页码
    CGFloat doublePage = scrollView.contentOffset.x/ScreenWidth;
    int intPage = (int)(doublePage +0.5);
    //设置页码
    self.pageControl.currentPage= intPage;
}


#pragma mark - XHInputViewDelagete
/**XHInputView 将要显示 */
-(void)xhInputViewWillShow:(XHInputView *)inputView{
//    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
//    [IQKeyboardManager sharedManager].enable = NO;
    
    
}

/** XHInputView 将要隐藏*/
-(void)xhInputViewWillHide:(XHInputView *)inputView{
//    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
//    [IQKeyboardManager sharedManager].enable = YES;

    NSLog(@"%@",inputView);
    
    
    
}


#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
//        self.isTableBgView = YES;
        self.giftNum = @"1";
        self.currentType = 1;
        self.allNum=0;
        self.lastSeletedIndex = [NSIndexPath indexPathForItem:0 inSection:0];
        self.changeHeight=0;
        [self setUpUI];
        //样式一
        self.inputViewStyleDefault=[self inputViewWithStyle:InputViewStyleDefault];;
        self.inputViewStyleDefault.delegate = self;
        WeakSelf;
        [self addSubview:self.inputViewStyleDefault];
        /** 发送按钮点击事件 */
        self.inputViewStyleDefault.sendBlcok = ^(NSString *text) {
            [wself.inputViewStyleDefault hide];//隐藏输入框
            wself.giftNum=text;
            [wself handselBUttonClick];
        };
    }
    return self;
}
- (void)setUpUI{
    //1表示未选中，2表示选中，不能选空麦位，不能选自己
    self.usersIsSelectedArray = [NSMutableArray array];
    self.hasSelectUsers = [NSMutableArray array];
    
    CGFloat bottomBGHeight = 160+ScreenWidth/2.0+100;
    
//    CGFloat tableBottomImgH = 6.5;
//    CGFloat tableBGViewH = self.numArray.count * 35 + tableBottomImgH;
    [self addSubview:self.maskMyView];
    [self addSubview:self.bottomBgView];
    [self addSubview:self.bgView];
//    [self.bgView addSubview:self.fuDaiView];
    [self.bottomBgView addSubview:self.bgImgView];
    [self.bottomBgView addSubview:self.selectAllButton];
    [self createBackPackTopView];
    self.selectAllButton.frame = CGRectMake(ScreenWidth-50-10, 15+self.topView.bottom, 50, 30);
//    [self.bottomBgView addSubview:self.yuELabel];
//    self.yuELabel.frame = CGRectMake(10, bottomBGHeight-30-10, 50, 30);
//    [self.bottomBgView addSubview:self.chargeButton];
//    self.chargeButton.frame = CGRectMake(60, bottomBGHeight-30-10, 200, 30);
//
    
    self.bottomBgView.backgroundColor=RGBA(0, 0, 0, 0);
    self.bottomBgView.layer.cornerRadius = 20;
    self.bottomBgView.clipsToBounds = YES;
    
    [self.bottomBgView addSubview:self.pageControl];
        
    
//    self.btnBgView= [[UIView alloc] init];
//    self.btnBgView.backgroundColor=RGBA(37, 41, 52, 1);
//    [self.bottomBgView addSubview:self.btnBgView];
//    self.btnBgView.layer.cornerRadius = 35.0/2.0;
//    self.btnBgView.layer.masksToBounds = YES;
//    [self.btnBgView addSubview:self.giftNumButton];//赠送倍率
//    [self.btnBgView addSubview:self.handselBUtton];//赠送按钮
    
//    [self.bottomBgView addSubview:self.tableBgView];
//    [self.tableBgView addSubview:self.tableBottomImg];
//    [self.tableBgView addSubview:self.tableView];
    
    [self.bottomBgView addSubview:self.giftSelectedImage];///< 赠送大红嘴动画
    UIView *line = [[UIView alloc] init];
    [self.bottomBgView addSubview:line];
    line.hidden = YES;
    line.backgroundColor = [UIColor grayColor];
    
    [self.bottomBgView addSubview:self.collectView];
    [self.bottomBgView addSubview:self.usersCollectionView];
    self.collectView.frame = CGRectMake(0, 95+self.topView.bottom, ScreenWidth, ScreenWidth/2.0+40);
    
    UILabel *tipLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 5+self.topView.bottom, 40, KAdaptedHeight(40))];
    tipLabel.text=getLanguage(@"投喂");
    tipLabel.textColor=RGBA(255, 255, 255, 0.8);
    tipLabel.font=KFontA(13);
    tipLabel.textAlignment=NSTextAlignmentCenter;
    [self.bottomBgView addSubview:tipLabel];
    
    
    self.usersCollectionView.frame = CGRectMake(50, 5+self.topView.bottom, ScreenWidth-50-60, 60);
    [self.collectView registerClass:[BJGiftViewCell class] forCellWithReuseIdentifier:@"BJGiftViewCell"];
    [self.usersCollectionView registerClass:[RoomUsersCollectionViewCell class] forCellWithReuseIdentifier:@"RoomUsersCollectionViewCell"];
    
    
    self.pageControl.frame = CGRectMake(0, bottomBGHeight-70+36, ScreenWidth, 20);
    
    [self.maskMyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(0);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
    }];

    self.bottomBgView.frame = CGRectMake(0, ScreenHeight-bottomBGHeight-SAFE_AREA_INSERTS_BOTTOM, ScreenWidth, bottomBGHeight+SAFE_AREA_INSERTS_BOTTOM+10);
    
    
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.trailing.mas_equalTo(KAdaptedHeight(0));
    }];
    
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bottomBgView.mas_top);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(self);
    }];
//    [self.fuDaiView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.mas_equalTo(KAdaptedWidth(15));
//        make.trailing.mas_equalTo(KAdaptedWidth(-15));
//        make.height.mas_equalTo(KAdaptedHeight(77));
//        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(KAdaptedWidth(-20));
//    }];
//
//    self.fuDaiView.hidden=YES;
    
//    //赠送按钮,倍率按钮
//    [self.btnBgView.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
//    [self.btnBgView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.btnBgView);
//        make.height.equalTo(self.btnBgView);
//        make.width.equalTo(self.btnBgView).multipliedBy(0.5);
//    }];
//    [self.btnBgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.bottomBgView).offset(-15);
//        make.bottom.mas_equalTo(self.bottomBgView.mas_bottom).offset(-10-SAFE_AREA_INSERTS_BOTTOM-10);
//        make.width.mas_equalTo(120);
//        make.height.mas_equalTo(35);
//    }];
//
    
//    [self.tableBgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.giftNumButton).offset(10);
//        make.bottom.mas_equalTo(self.giftNumButton.mas_top).offset(10);
//        make.width.mas_equalTo(95);
//        make.height.mas_equalTo(tableBGViewH);
//    }];
//    [self.tableBottomImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.bottom.mas_equalTo(KAdaptedWidth(0));
//    }];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.tableBgView);
//        make.left.mas_equalTo(self.tableBgView);
//        make.right.mas_equalTo(self.tableBgView);
//        make.bottom.mas_equalTo(self.tableBottomImg.mas_bottom);
//    }];
//
//    [self.tableBgView removeFromSuperview];
    
    
    self.numBgView.frame=CGRectMake(10, 65+self.topView.bottom, kWidth-20, 30);
    
    self.ButtonView.frame = CGRectMake(10, 65+self.topView.bottom, 192, 30);
    self.giftButton.frame = CGRectMake(1, 1, 60, 28);
    self.beibaoButton.frame = CGRectMake(66, 1, 60, 28);
    self.tequanButton.frame = CGRectMake(131, 1, 60, 28);
    
    
    
    
    CGFloat chargeBtnW = KAdaptedWidth(110);
    self.chargeButton.frame = CGRectMake(kWidth - chargeBtnW - 10, 65+self.topView.bottom, chargeBtnW, 30);
    setViewCorner(self.chargeButton, 15);
    
    
    [self.bottomBgView addSubview:self.numBgView];
    [self.bottomBgView addSubview:self.chargeButton];
    [self.bottomBgView addSubview:self.synthesizeGiftButton];
    self.synthesizeGiftButton.frame = CGRectMake(kWidth-KAdaptedWidth(100+10), 65+self.topView.bottom, 100, 30);
    self.synthesizeGiftButton.hidden = YES;
    [self.bottomBgView addSubview:self.ButtonView];
    [self.ButtonView addSubview:self.giftButton];
    [self.ButtonView addSubview:self.beibaoButton];
    [self.ButtonView addSubview:self.tequanButton];

    
    self.numArray = @[@"1", @"10", @"66", @"自定义"];
    for (int i=0; i<self.numArray.count; i++) {
        UIButton *numBtn=[[UIButton alloc] init];
        numBtn.frame=CGRectMake(KAdaptedWidth((80+10)*i), 0, KAdaptedWidth(80), KAdaptedHeight(30));
        [numBtn setBackgroundImage:KGetImage(@"giveGiftBtnImg") forState:UIControlStateNormal];
        if(i==3){
            [numBtn setTitle:[NSString stringWithFormat:@"%@",self.numArray[i]] forState:UIControlStateNormal];
        }else{
            [numBtn setTitle:[NSString stringWithFormat:@"送%@个",self.numArray[i]] forState:UIControlStateNormal];
        }
        
        [numBtn setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
        numBtn.titleLabel.font=KFontA(13);
        [numBtn addTarget:self action:@selector(giveNumBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        numBtn.tag=100+i;
        [self.numBgView addSubview:numBtn];
    }
    
    self.numBgView.hidden=YES;
}

#pragma mark 更新视图
-(void)upDataView{
    
    CGFloat bottomBGHeight = 160+ScreenWidth/2.0+self.topView.bottom;
    self.bottomBgView.frame= CGRectMake(0, ScreenHeight-bottomBGHeight-SAFE_AREA_INSERTS_BOTTOM-self.changeHeight, ScreenWidth, bottomBGHeight+SAFE_AREA_INSERTS_BOTTOM+10+self.changeHeight);
    self.ButtonView.frame = CGRectMake(10, 65+self.topView.bottom+self.changeHeight, 192, 30);
    self.collectView.frame = CGRectMake(0, 95+self.topView.bottom+self.changeHeight, ScreenWidth, ScreenWidth/2.0+40);
    self.pageControl.frame = CGRectMake(0, bottomBGHeight-70+36+self.changeHeight, ScreenWidth, 20);
    CGFloat chargeBtnW = KAdaptedWidth(110);
    self.chargeButton.frame = CGRectMake(kWidth - chargeBtnW - 10, 65+self.topView.bottom+self.changeHeight, chargeBtnW, 30);
    self.synthesizeGiftButton.frame = CGRectMake(kWidth - chargeBtnW - 10, 65+self.topView.bottom+self.changeHeight, chargeBtnW, 30);

}

#pragma mark 选择赠送数量
-(void)giveNumBtnClick:(UIButton *)sender{
    if(sender.tag==103){
        [self.inputViewStyleDefault show];//显示样式一
    }else{
        self.giftNum=self.numArray[sender.tag-100];
        [self handselBUttonClick];
    }
    
}


#pragma mark ======================  礼物，钻石，我的 按钮点击事件   ======================
- (void)handleGiftTypeButtonClick:(UIButton *)sender {
    [self uploadType:sender.tag];
    NSArray *buttons = @[self.giftButton, self.beibaoButton, self.tequanButton];
    for (UIButton *button in buttons) {
        if (button.tag == sender.tag) {
            [button setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
            [button setBackgroundImage:KGetImage(@"giftBgImg") forState:UIControlStateNormal];
            button.titleLabel.font = KFontBold(13);
        } else {
            button.titleLabel.font = KFontA(13);
            [button setBackgroundImage:KGetImage(@"") forState:UIControlStateNormal];
            [button setTitleColor:RGBA(207, 221, 248, 1) forState:UIControlStateNormal];
        }
    }
}
-(void)uploadType:(NSInteger)tag{
    if (tag == 1003) {
        self.chargeButton.hidden = YES;
        self.synthesizeGiftButton.hidden = NO;
    } else {
        self.chargeButton.hidden = NO;
        self.synthesizeGiftButton.hidden = YES;
    }
    self.changeHeight=0;
    self.numBgView.hidden=YES;
    [self upDataView];
    if (self.myArray.count == 0) {
        if (tag==1001) {
            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:getLanguage(@"我的背包暂无可发送物品")];
            return;
        }
    }
    self.currentType = tag-1000+1;
    if (tag == 1000) {
        [self.fudaiButton setBackgroundImage:KGetImage(@"") forState:0];
        [self.beibaoButton setBackgroundImage:KGetImage(@"") forState:0];
        [self.tequanButton setBackgroundImage:KGetImage(@"") forState:0];
        [self.giftButton setBackgroundImage:KGetImage(@"giftBgImg") forState:0];
        self.giftNum = @"1";
        self.giftCarouseArray = self.giftArray;
        [self.collectView reloadData];
    }else if(tag == 1001){
        [self.fudaiButton setBackgroundImage:KGetImage(@"") forState:0];
        [self.giftButton setBackgroundImage:KGetImage(@"") forState:0];
        [self.tequanButton setBackgroundImage:KGetImage(@"") forState:0];
        [self.beibaoButton setBackgroundImage:KGetImage(@"giftBgImg") forState:0];
        self.giftNum = @"1";
        self.giftCarouseArray = self.myArray;
        if ([[[UIDevice currentDevice] systemVersion] floatValue]<13) {
            [self refreshLayout];
        }
        [self.collectView reloadData];
    }else if(tag == 1002){
        [self.beibaoButton setBackgroundImage:KGetImage(@"") forState:0];
        [self.giftButton setBackgroundImage:KGetImage(@"") forState:0];
        [self.tequanButton setBackgroundImage:KGetImage(@"") forState:0];
        [self.fudaiButton setBackgroundImage:KGetImage(@"giftBgImg") forState:0];
        self.giftNum = @"1";
        self.giftCarouseArray = self.fudaiArray;
        if ([[[UIDevice currentDevice] systemVersion] floatValue]<13) {
            [self refreshLayout];
        }
        
        [self.collectView reloadData];

        [self.usersCollectionView reloadData];
    }else if(tag == 1003){
        [self.beibaoButton setBackgroundImage:KGetImage(@"") forState:0];
        [self.giftButton setBackgroundImage:KGetImage(@"") forState:0];
        [self.fudaiButton setBackgroundImage:KGetImage(@"") forState:0];
        [self.tequanButton setBackgroundImage:KGetImage(@"giftBgImg") forState:0];
        self.giftNum = @"1";
        
        if (self.tequanArray.count == 0) {
            RoomFuDaiModel *green = [[RoomFuDaiModel alloc] init];
            green.fuDaiID = @"8";
            green.name = @"青玉福袋";
            green.price = @"200";
            green.image = @"theme_game_four_bag_green";
            
            RoomFuDaiModel *blue = [[RoomFuDaiModel alloc] init];
            blue.fuDaiID = @"9";
            blue.name = @"碧海福袋";
            blue.price = @"1000";
            blue.image = @"theme_game_four_bag_blue";
            
            RoomFuDaiModel *yellow = [[RoomFuDaiModel alloc] init];
            yellow.fuDaiID = @"10";
            yellow.name = @"鎏金福袋";
            yellow.price = @"5000";
            yellow.image = @"theme_game_four_bag_yellow";
            
            self.tequanArray = @[green, blue, yellow];
        }
        
        self.giftCarouseArray = [self.tequanArray mutableCopy];
        if ([[[UIDevice currentDevice] systemVersion] floatValue]<13) {
            [self refreshLayout];
        }
        
        [self.collectView reloadData];
    }
    
    self.pageControl.currentPage = 0;
        if (self.giftCarouseArray.count % 8 == 0) {
            self.pageControl.numberOfPages = self.giftCarouseArray.count/8;
        }
        else{
            self.pageControl.numberOfPages = self.giftCarouseArray.count/8 + 1;
        }
}

- (void)refreshLayout {
    HLHorizontalPageLayout *pageLayout = [[HLHorizontalPageLayout alloc] init];
    pageLayout.itemSize = CGSizeMake(ScreenWidth/4.0, ScreenWidth/4.0+20);
    self.collectView.collectionViewLayout = pageLayout;
}
#pragma mark ======================  全麦点击方法   ======================
- (void)hanleSelectAllMethod:(UIButton *)sender {
    
    [self.hasSelectUsers removeAllObjects];
    if (sender.selected==NO) {
        sender.alpha = 1.0f;
        for (int i=0; i<self.allNum; i++) {
            
            MLRoomMSequenceModel *model = self.usersArray[i];
            if ([model.status isEqualToString:@"2"]) {
                if ([model.uid integerValue] == [[UserManager userInfo].user_id integerValue]) {
                    [self.usersIsSelectedArray replaceObjectAtIndex:i withObject:@(1)];
//                    如果是自己就不添加到hasSelectUsers数组里边
                }else{
                    [self.usersIsSelectedArray replaceObjectAtIndex:i withObject:@(2)];
                }
                if ([self.usersIsSelectedArray[i] isEqualToNumber:@(2)]) {
                    [self.hasSelectUsers addObject:model];
                }
                
            }else{
                [self.usersIsSelectedArray replaceObjectAtIndex:i withObject:@(1)];
            }
        }
    }else{
        sender.alpha = 0.4;
        for (int i=0; i<self.allNum; i++) {
            [self.usersIsSelectedArray replaceObjectAtIndex:i withObject:@(1)];
            [self.hasSelectUsers removeAllObjects];
        }
    }
    
    [self.usersCollectionView reloadData];
    sender.selected = !sender.selected;
}
#pragma mark ======================  充值   ======================
- (void)topUpButtonClick:(UIButton *)sender{
    ! self.topUpButtonClickBlock ?: self.topUpButtonClickBlock();
    [self removeFromSuperview];
//    [self.tableBgView removeFromSuperview];
//    self.isTableBgView = YES;
}


#pragma mark ======================  懒加载   ======================

- (HorizontallyPageableFlowLayout *)layout {
    if (_layout == nil) {
        _layout = [[HorizontallyPageableFlowLayout alloc] initWithItemCountPerRow:kItemCountPerRow maxRowCount:kMaxRowCount];
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 0;
        _layout.itemSize = CGSizeMake(ScreenWidth / kItemCountPerRow, ScreenWidth / kItemCountPerRow+20);
    }
    return _layout;
}

//- (UILabel *)yuELabel{
//    if (!_yuELabel) {
//        _yuELabel = [[UILabel alloc] init];
//        _yuELabel.text =getLanguage(@"余额");
//        _yuELabel.textColor = RGBA(132, 141, 169, 1);
//        _yuELabel.font=KFont(14);
//        _yuELabel.textAlignment=NSTextAlignmentCenter;
//    }
//    return _yuELabel;
//}

- (WZDLayoutButton *)chargeButton{
    if (!_chargeButton) {
        _chargeButton = [WZDLayoutButton buttonWithType:UIButtonTypeCustom];
        _chargeButton.layoutStyle = WZDLayoutButtonStyleLeftImageRightTitle;
        _chargeButton.midSpacing = 4;
        _chargeButton.backgroundColor = RGBA(227, 227, 227, 0.35);
        _chargeButton.layer.cornerRadius = 15.0;
        _chargeButton.layer.masksToBounds = YES;
        _chargeButton.imageSize = CGSizeMake(14, 14);
        [_chargeButton setTitleColor:RGBA(207, 221, 248, 1) forState:UIControlStateNormal];
        _chargeButton.titleLabel.font = Font(12);
        _chargeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        _chargeButton.titleLabel.minimumScaleFactor = 0.65;
        [_chargeButton setImage:ImageNamed(@"coinImg") forState:UIControlStateNormal];
        [_chargeButton setTitle:@"0" forState:UIControlStateNormal];
        [_chargeButton addTarget:self action:@selector(topUpButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _chargeButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _chargeButton;
}
//- (UIButton *)chargeButton{
//    if (!_chargeButton) {
//        _chargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _chargeButton.backgroundColor=RGBA(227, 227, 227, 0.35);
//        [_chargeButton setTitleColor:RGBA(207, 221, 248, 1) forState:UIControlStateNormal];
//        _chargeButton.titleLabel.font = FONT_13;
//        [_chargeButton setImage:ImageNamed(@"coinImg") forState:UIControlStateNormal];
//        [_chargeButton setTitle:@"0" forState:UIControlStateNormal];
////        _chargeButton.ba_buttonLayoutType = BAKit_ButtonLayoutTypeLeftImageLeft;
//        _chargeButton.ba_padding = 25;
//        [_chargeButton addTarget:self action:@selector(topUpButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _chargeButton;
//}
- (UIButton *)selectAllButton{
    if (!_selectAllButton) {
        _selectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectAllButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
//        _selectAllButton.alpha = 0.4;
        _selectAllButton.titleLabel.font = KFontA(12);
        _selectAllButton.layer.cornerRadius = 15;
        _selectAllButton.clipsToBounds = YES;
//        _selectAllButton.backgroundColor = RGBA(73, 128, 108, 1);
        [_selectAllButton setImage:KGetImage(@"UserNoSelectImg") forState:UIControlStateNormal];
        [_selectAllButton setImage:KGetImage(@"gouxuanSelectImg") forState:UIControlStateSelected];
        [_selectAllButton setTitle:getLanguage(@"全选") forState:UIControlStateNormal];
        [_selectAllButton addTarget:self action:@selector(hanleSelectAllMethod:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectAllButton;
}

- (UIView *)numBgView{
    if (!_numBgView) {
        _numBgView = [[UIView alloc] init];
    }
    return _numBgView;
}

- (UIView *)ButtonView{
    if (!_ButtonView) {
        _ButtonView = [[UIView alloc] init];
        _ButtonView.backgroundColor =RGBA(227, 227, 227, 0.35);
        _ButtonView.layer.cornerRadius=15;
        _ButtonView.layer.masksToBounds=YES;
    }
    return _ButtonView;
}


- (UIButton *)giftButton{
    if (!_giftButton) {
        _giftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_giftButton setBackgroundImage:KGetImage(@"giftBgImg") forState:0];
        [_giftButton setTitle:getLanguage(@"礼物") forState:UIControlStateNormal];
        [_giftButton setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
//        _giftButton.selected = YES;
        _giftButton.titleLabel.font = FONT_14;
        _giftButton.tag = 1000;
        [_giftButton addTarget:self action:@selector(handleGiftTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _giftButton;
}

- (UIButton *)beibaoButton{
    if (!_beibaoButton) {
        _beibaoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_beibaoButton setTitle:getLanguage(@"背包") forState:UIControlStateNormal];
        [_beibaoButton setTitleColor:RGBA(207, 221, 248, 1) forState:UIControlStateNormal];
        _beibaoButton.titleLabel.font = FONT_14;
        [_beibaoButton setBackgroundImage:KGetImage(@"") forState:0];
        _beibaoButton.tag = 1001;
        [_beibaoButton addTarget:self action:@selector(handleGiftTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _beibaoButton;
}

- (UIButton *)fudaiButton{
    if (!_fudaiButton) {
        _fudaiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fudaiButton setTitle:getLanguage(@"宝箱") forState:UIControlStateNormal];
        [_fudaiButton setTitleColor:RGBA(207, 221, 248, 1) forState:UIControlStateNormal];
        [_fudaiButton setBackgroundImage:KGetImage(@"") forState:0];
        _fudaiButton.titleLabel.font = FONT_14;
        _fudaiButton.tag = 1002;
        [_fudaiButton addTarget:self action:@selector(handleGiftTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fudaiButton;
}

- (UIButton *)tequanButton {
    if (!_tequanButton) {
        _tequanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tequanButton setTitle:getLanguage(@"特权") forState:UIControlStateNormal];
        [_tequanButton setTitleColor:RGBA(207, 221, 248, 1) forState:UIControlStateNormal];
        [_tequanButton setBackgroundImage:KGetImage(@"") forState:0];
        _tequanButton.titleLabel.font = FONT_14;
        _tequanButton.tag = 1003;
        [_tequanButton addTarget:self action:@selector(handleGiftTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tequanButton;
}

- (UIButton *)synthesizeGiftButton {
    if (!_synthesizeGiftButton) {
        _synthesizeGiftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_synthesizeGiftButton setTitle:getLanguage(@"合成礼物") forState:UIControlStateNormal];
        [_synthesizeGiftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _synthesizeGiftButton.titleLabel.font = FONT_12;
        
        // Resize mission_gift_icon to 15x14 to avoid distortion and text truncation
        UIImage *originalImage = ImageNamed(@"mission_gift_icon");
        CGSize targetSize = CGSizeMake(15, 14);
        UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
        [originalImage drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
        UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [_synthesizeGiftButton setImage:resizedImage forState:UIControlStateNormal];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[
            (__bridge id)[UIColor colorWithHexString:@"#E028B3"].CGColor,
            (__bridge id)[UIColor colorWithHexString:@"#8002EC"].CGColor
        ];
        gradientLayer.startPoint = CGPointMake(0, 0.5);
        gradientLayer.endPoint = CGPointMake(1, 0.5);
        gradientLayer.frame = CGRectMake(0, 0, 100, 30);
        gradientLayer.cornerRadius = 15;
        
        UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, NO, 0.0);
        [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [_synthesizeGiftButton setBackgroundImage:gradientImage forState:UIControlStateNormal];
        
        _synthesizeGiftButton.layer.cornerRadius = 15;
        _synthesizeGiftButton.layer.masksToBounds = YES;
        
        _synthesizeGiftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 4);
        _synthesizeGiftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4);
    }
    return _synthesizeGiftButton;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:[UIColor clearColor]];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
        [_bgView addGestureRecognizer:singleTap];
    }
    return _bgView;
}

- (UIView *)maskMyView{
    if (!_maskMyView) {
        _maskMyView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:[UIColor blackColor]];
        _maskMyView.alpha = 0.22;
    }
    return _maskMyView;
}

//- (FuDaiXQTipView *)fuDaiView{
//    if (!_fuDaiView) {
//        WeakSelf;
//        _fuDaiView=[FuDaiXQTipView new];
//        _fuDaiView.layer.cornerRadius = KAdaptedHeight(10);
//        _fuDaiView.layer.borderWidth=KAdaptedHeight(1);
//        _fuDaiView.layer.borderColor=Color(194, 130, 255, 1).CGColor;
//        _fuDaiView.layer.masksToBounds=YES;
//        _fuDaiView.checkXQBlock = ^{
//            [CustomAlertViewA showAlertView_Type:AlertType_Bottom ContentType:BlessingBagCustomCententViewTag andData:@{@"data":wself.fudaiArray}];
//        };
//
//
//    }
//    return _fuDaiView;
//}

- (UIView *)bottomBgView{
    if (!_bottomBgView) {
        _bottomBgView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:[UIColor clearColor]];
    }
    return _bottomBgView;
}

- (UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.image=KGetImage(@"giftViewBgImg");
    }
    return _bgImgView;
}

-(UICollectionView *)collectView
{
    if (!_collectView) {
        HLHorizontalPageLayout *pageLayout = [[HLHorizontalPageLayout alloc] init];
        pageLayout.itemSize = CGSizeMake(ScreenWidth/4.0, ScreenWidth/4.0+20);
        pageLayout.minimumInteritemSpacing = 0;
        pageLayout.minimumLineSpacing = 0;
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:pageLayout];
        _collectView.dataSource=self;
        _collectView.delegate=self;
        _collectView.showsHorizontalScrollIndicator = NO;
        _collectView.pagingEnabled = YES;
        _collectView.multipleTouchEnabled = NO;
        _collectView.backgroundColor =RGBA(0, 0, 0, 0);
//        _collectView.backgroundColor =RandomColor;
    }
    return _collectView;
}
-(UICollectionView *)usersCollectionView
{
    if (!_usersCollectionView) {
        UserFlowLayout *pageLayout = [[UserFlowLayout alloc] init];
        pageLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        pageLayout.itemSize = CGSizeMake(50,60);
        _usersCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:pageLayout];
        _usersCollectionView.dataSource=self;
        _usersCollectionView.delegate=self;
        _usersCollectionView.showsHorizontalScrollIndicator = NO;
        _usersCollectionView.backgroundColor = RGBA(0, 0, 0, 0);
    }
    return _usersCollectionView;
}
-(UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];

        _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1.0 alpha:0.35];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:255/255.0 green:230/255.0 blue:111/255.0 alpha:1.0];
        
        _pageControl.enabled = NO;
    }
    return _pageControl;
}
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [ControlCreator createImageView:nil rect:CGRectZero imageName:@"room_gift_bg-1" backguoundColor:[UIColor clearColor]];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImageView;
}
- (UIImageView *)bgUserImage{
    if (!_bgUserImage) {
        _bgUserImage = [ControlCreator createImageView:nil rect:CGRectZero imageName:@"room_user_bg" backguoundColor:[UIColor clearColor]];
        _bgUserImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgUserImage;
}

-(XHInputView *)inputViewWithStyle:(InputViewStyle)style{
    
    XHInputView *inputView = [[XHInputView alloc] initWithStyle:style];
    inputView.keyboardType=UIKeyboardTypeNumberPad;
    //设置最大输入字数
    inputView.maxCount = 50;
    //输入框颜色
    inputView.textViewBackgroundColor = [UIColor groupTableViewBackgroundColor];
    inputView.sendButtonColor=BaseMainColor;
    //占位符
    inputView.placeholder = @"请输入赠送数量";
    return inputView;
    
}

- (NSMutableArray *)userCarouselArray{
    if (!_userCarouselArray) {
        _userCarouselArray = [NSMutableArray array];
    }
    return _userCarouselArray;
}

///// 赠送
//- (UIButton *)handselBUtton{
//    if (!_handselBUtton) {
//        _handselBUtton = [ControlCreator createButton:nil rect:CGRectZero text:getLanguage(@"赠送") font:Font(12) color:[UIColor whiteColor] backguoundColor:RGBA(0, 0, 0, 0) imageName:@"" target:self action:@selector(handselBUttonClick)];
//        [_handselBUtton setBackgroundImage:KGetImage(@"numImg") forState:0];
//    }
//    return _handselBUtton;
//}
//- (UIButton *)giftNumButton{
//    if (!_giftNumButton) {
//        _giftNumButton = [ControlCreator createButton:nil rect:CGRectZero text:@"x1" font:Font(12) color:kWhiteColor backguoundColor:RGBA(0, 0, 0, 0) imageName:@"" target:self action:@selector(giftNumButtonClick:)];
//
//    }
//    return _giftNumButton;
//}
//
//- (UIView *)tableBgView{
//    if (!_tableBgView) {
//        _tableBgView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:[UIColor clearColor]];
//
//    }
//    return _tableBgView;
//}
//- (UIImageView *)tableBottomImg{
//    if (!_tableBottomImg) {
////        _tableBottomImg = [ControlCreator createImageView:nil rect:CGRectZero imageName:@"room_gift_sanjiao" backguoundColor:[UIColor clearColor]];
//        _tableBottomImg = [ControlCreator createImageView:nil rect:CGRectZero imageName:@"numSelectImg" backguoundColor:[UIColor clearColor]];
//        _tableBottomImg.contentMode=UIViewContentModeScaleToFill;
//    }
//    return _tableBottomImg;
//}
//
//- (UITableView *)tableView {
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        _tableView.dataSource = self;
//        _tableView.delegate = self;
//        _tableView.backgroundView = nil;
//
//        _tableView.rowHeight = 35;
//        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.backgroundColor = kClearColor;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.layer.shadowOffset = CGSizeMake(0,1);
//        _tableView.layer.masksToBounds = YES;
//        _tableView.layer.cornerRadius = 7;
//        _tableView.bounces = NO;
//    }
//    return _tableView;
//}

///< 赠送大红嘴动画
- (SVGAPlayer *)giftSelectedImage{
    if (!_giftSelectedImage) {
        _giftSelectedImage = [[SVGAPlayer alloc] initWithFrame:CGRectZero];
        _giftSelectedImage.delegate = self;
        _giftSelectedImage.loops = 0;
        _giftSelectedImage.clearsAfterStop = YES;
        parser = [[SVGAParser alloc] init];
    }
    return _giftSelectedImage;
}

- (NSArray *)numArray{
    if (!_numArray) {
        _numArray = @[@"1", @"10",@"66"];
    }
    return _numArray;
}

-(void)createBackPackTopView{
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = UIColor.clearColor;
        self.topView.frame = CGRectMake(0, 0, kScreenWidth, 60);
        [self.bottomBgView addSubview:_topView];
        
        self.backPackPriceLabel = [[UILabel alloc] init];
        self.backPackPriceLabel.text = @"   背包总价值:0   ";
        self.backPackPriceLabel.font = Font(13);
        self.backPackPriceLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.backPackPriceLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
        self.backPackPriceLabel.textAlignment = NSTextAlignmentCenter;
        [self.topView addSubview:self.backPackPriceLabel];
        [self.backPackPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(18);
            make.top.mas_offset(10);
            make.height.mas_offset(35);
        }];
        setViewCorner(self.backPackPriceLabel, 35/2);
        
        _senderBackPackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_senderBackPackBtn setTitle:getLanguage(@"全部送出") forState:UIControlStateNormal];
        [_senderBackPackBtn setTitleColor:[UIColor colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
        [_senderBackPackBtn setBackgroundImage:[UIImage imageNamed:@"giveGiftBtnImg"] forState:0];
        _senderBackPackBtn.titleLabel.font = FONT_13;
        [_senderBackPackBtn addTarget:self action:@selector(senderBackPackClick) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:self.senderBackPackBtn];
        [self.senderBackPackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-10);
            make.top.mas_offset(10);
            make.height.mas_offset(35);
            make.width.mas_offset(70);
        }];
}

-(void)senderBackPackClick{
    [self.hasSelectUsers removeAllObjects];
    @autoreleasepool {
        for (int i=0; i<self.usersIsSelectedArray.count; i++) {
            if ([self.usersIsSelectedArray[i] isEqualToNumber:@(2)]) {
                MLRoomMSequenceModel *model = self.usersArray[i];
                    [self.hasSelectUsers addObject:model];
            }
        }
    }
    if (self.hasSelectUsers.count==0) {
        [SVProgressHUD showImage:ImageNamed(@"") status:getLanguage(@"请选择送给谁")];
        return;
    }else if (self.hasSelectUsers.count>1){
        [SVProgressHUD showImage:ImageNamed(@"") status:getLanguage(@"只能选择一位")];
        return;
    }else{
        MLRoomMSequenceModel *model = self.hasSelectUsers[0];
        if([model.uid isEqualToString:[UserManager userInfo].user_id]){
            [SVProgressHUD showImage:ImageNamed(@"") status:getLanguage(@"背包礼物不能送给自己")];
            return;
        }
    }
    if (self.myArray.count > 0) {
        NSMutableArray<RoomGiftModel *> *unlockedList = [NSMutableArray array];
        NSMutableArray<RoomGiftModel *> *lockedList = [NSMutableArray array];
        for (RoomGiftModel *gift in self.myArray) {
            if (gift.isLocked) {
                [lockedList addObject:gift];
            } else {
                [unlockedList addObject:gift];
            }
        }
        
        // 场景 1: 全部已锁定
        if (unlockedList.count == 0) {
            [SVProgressHUD showErrorWithStatus:getLanguage(@"当前背包所有礼物均已锁定，无法送出！")];
            return;
        }
        
        // 场景 2 & 场景 3: 送出未锁定的礼物列表
        if (self.senderBackPackBlock) {
            MLRoomMSequenceModel *model = self.hasSelectUsers[0];
            self.senderBackPackBlock(model, unlockedList);
        }
    } else {
        [SVProgressHUD showImage:ImageNamed(@"") status:getLanguage(@"背包无礼物")];
        return;
    }
}

@end
