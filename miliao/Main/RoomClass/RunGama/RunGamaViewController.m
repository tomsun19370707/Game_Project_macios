//
//  RunGamaViewController.m
//  miliao
//
//  Created by wzd on 2026-04-08.
//  Copyright © 2026 EMO. All rights reserved.
//

#import "RunGamaViewController.h"
#import "SVGAModel.h"
#import "SVGAPlayer+Model.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "RunGamaRuleViewController.h"
#import "CurrentRunGamaViewController.h"
#import "RunGamaRecordViewController.h"
#import "CFMExDiamondAndBagAlert.h"
#import "CFMWalletDiamondExGiftVc.h"
#import "RunGamaResultViewController.h"
@interface RunGamaViewController ()
@property (nonatomic, strong) SVGAPlayer *player;
@property (nonatomic, strong) SVGAParser *parser;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *balanceLabel,*stateLabel;
@property (nonatomic, strong) NSDictionary *roleInfoDic,*gameInfoDic;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) NSInteger countdown;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) NSMutableDictionary *gameButtomItemDic,*gameTopItemDic;
@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, strong) NSArray *resultArray;
@property (nonatomic, assign) BOOL gameIsLock;
@end

@implementation RunGamaViewController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopCountdown];
}

- (instancetype)initWithInfoDic:(NSDictionary *)infoDic{
    if (self = [super init]) {
        self.gameTopItemDic=[NSMutableDictionary dictionary];
        self.gameButtomItemDic=[NSMutableDictionary dictionary];
        self.btnArray=[NSMutableArray array];
        self.gameIsLock=YES;
        _infoDic=infoDic;
        self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self addSubView];
    }
    return self;
}
-(void)addSubView{
    UIControl *control =[[UIControl alloc]initWithFrame:self.view.bounds];
    [control addTarget:self action:@selector(closeVc) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:control];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        //        make.top.mas_equalTo(80);
    }];
    [self loaddingView];
    
    [self fetchBalance];
    [self getRoleInfo];
    [self getCurrentGame];
}
-(void)loaddingView{
    WeakSelf
    // 1️⃣ 创建播放器
    self.player = [[SVGAPlayer alloc] initWithFrame:CGRectZero];
    
    self.player.contentMode=UIViewContentModeScaleToFill;
    self.player.delegate = self;
    [self.contentView addSubview:self.player];
    [self.player mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(self.player.mas_width).multipliedBy(725.0/375.0);
    }];
    self.parser = [[SVGAParser alloc] init];
    SVGAModel *model = [SVGAModel new];
    model.animId = @"anim_001";
    model.type = @"wait";
    model.extra = @"等待动画";
    self.player.svgaModel = model;
    self.player.loops = 0;
    self.player.clearsAfterStop = NO;
    [self playLocalSVGA:@"待机"];
    
    UIView *makeView=[UIView new];
    [self.contentView addSubview:makeView];
    [makeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.player);
    }];
    float totalHeight= SCREENWIDTH*(725.0/375.0);
    UIButton *closeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton addTarget:self action:@selector(closeVc) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    [makeView addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(totalHeight*(134.0/725.0)-23);
        make.width.height.mas_equalTo(46);
        make.right.mas_equalTo(0);
    }];
    
    UIButton *roleButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [roleButton addTarget:self action:@selector(seeRule) forControlEvents:UIControlEventTouchUpInside];
    [roleButton setBackgroundImage:[UIImage imageNamed:@"规则说明"] forState:UIControlStateNormal];
    [makeView addSubview:roleButton];
    [roleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(totalHeight*(198.5/725.0)-27.5);
        make.width.mas_equalTo(108);
        make.height.mas_equalTo(55);
        make.left.mas_equalTo(12);
    }];
    
    UIButton *shishiButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [shishiButton addTarget:self action:@selector(currentGame) forControlEvents:UIControlEventTouchUpInside];
    [shishiButton setBackgroundImage:[UIImage imageNamed:@"实时赛况"] forState:UIControlStateNormal];
    [makeView addSubview:shishiButton];
    [shishiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(totalHeight*(198.5/725.0)-27.5);
        make.width.mas_equalTo(108);
        make.height.mas_equalTo(55);
        make.right.mas_equalTo(-12);
    }];
    
    UIButton *recordButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [recordButton addTarget:self action:@selector(goRecord) forControlEvents:UIControlEventTouchUpInside];
    [recordButton setBackgroundImage:[UIImage imageNamed:@"比赛记录"] forState:UIControlStateNormal];
    [makeView addSubview:recordButton];
    [recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(roleButton.mas_bottom).offset(1);
        make.width.mas_equalTo(108);
        make.height.mas_equalTo(55);
        make.left.mas_equalTo(12);
    }];
    
    UIButton *centerButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [centerButton addTarget:self action:@selector(exchange) forControlEvents:UIControlEventTouchUpInside];
    [centerButton setBackgroundImage:[UIImage imageNamed:@"兑换中心"] forState:UIControlStateNormal];
    [makeView addSubview:centerButton];
    [centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(roleButton.mas_bottom).offset(1);
        make.width.mas_equalTo(108);
        make.height.mas_equalTo(55);
        make.right.mas_equalTo(-12);
    }];
    
    [makeView addSubview:self.stateLabel];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(totalHeight*(267.0/725.0)-15);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *conLabel=[UILabel new];
    conLabel.font=[UIFont systemFontOfSize:12];
    conLabel.textColor=[UIColor blackColor];
    conLabel.textAlignment=NSTextAlignmentCenter;
    [makeView addSubview:conLabel];
    self.balanceLabel=conLabel;
    
    
    
    [conLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(totalHeight*(580.0/725.0)-15);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    
    NSArray *animalArray=@[@"狗狗",@"老虎",@"猪",@"乌龟",@"兔子"];
    NSArray *itemIdArray=@[@"1",@"2",@"3",@"1",@"2"];
    NSArray *postionArray=@[@"top",@"top",@"top",@"bottom",@"bottom"];
    float itemWidth=(SCREENWIDTH-30-40)/animalArray.count;
    float itemHeight=itemWidth*(86.0/76.0);
    RunGameButton *tmpButton =nil;
    [self.btnArray removeAllObjects];
    for (NSInteger index=0; index<animalArray.count; index++) {
        RunGameButton *itemButton=[[RunGameButton alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemHeight)];
        itemButton.type=postionArray[index];
        itemButton.itemId=itemIdArray[index];
        itemButton.amount=@"1";
        [itemButton addTarget:self action:@selector(gameItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [itemButton setBackgroundImage:[UIImage imageNamed:@"没有下注颜色"] forState:UIControlStateNormal];
        [itemButton setBackgroundImage:[UIImage imageNamed:@"下注颜色"] forState:UIControlStateSelected];
        itemButton.imageEdgeInsets=UIEdgeInsetsMake(10, 5, 20, 5);
        itemButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
        itemButton.cancelClick = ^(RunGameButton * _Nonnull btn) {
            if (wself.gameIsLock) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"本轮已锁定下注选择，请等待下一轮"];
                return;
            }
            if ([btn.type isEqualToString:@"top"]) {
                [wself.gameTopItemDic removeObjectForKey:btn.itemId];
            }else{
                [wself.gameButtomItemDic removeObjectForKey:btn.type];
            }
            [wself changeBtnState];
        };
        [itemButton setImage:[UIImage imageNamed:animalArray[index]] forState:UIControlStateNormal];
        [makeView addSubview:itemButton];
        [self.btnArray addObject:itemButton];
        tmpButton=itemButton;
        [itemButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(totalHeight*(650.0/725.0)-itemHeight/2.0);
            make.width.mas_equalTo(itemWidth);
            make.height.mas_equalTo(itemHeight);
            make.left.mas_equalTo(15+(itemWidth+10)*index);
        }];
    }
    /*
    UIButton *sureButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [sureButton setBackgroundImage:[UIImage imageNamed:@"确定按钮"] forState:UIControlStateNormal];
    [makeView addSubview:sureButton];
    self.sureButton=sureButton;
    self.sureButton.enabled=NO;
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tmpButton.mas_bottom).offset(10);
        make.width.mas_equalTo(147);
        make.height.mas_equalTo(41);
        make.centerX.mas_equalTo(0);
    }];
     */
}
-(void)sureClick{
    WeakSelf
    NSArray *btns=[self.gameButtomItemDic allValues];
    NSArray *tbtns=[self.gameTopItemDic allValues];
    if (btns.count==0&&tbtns.count==0) {
//        [SVProgressHUD dismiss];
//        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"请选择要下注的动物"];
        return;
    }
    NSMutableArray *btnArray=[NSMutableArray array];
    [btnArray addObjectsFromArray:btns];
    [btnArray addObjectsFromArray:tbtns];
    NSMutableArray *bets=[NSMutableArray array];
    for (NSInteger index=0; index<btnArray.count; index++) {
        RunGameButton *btn=[btnArray objectAtIndex:index];
        NSString *text =  btn.amount ?: @"1";
        // 去空格
        text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        // 防御 NSAttributedString
        if ([text isKindOfClass:[NSAttributedString class]]) {
            text = [(NSAttributedString *)text string];
        }
        int amount = text.intValue;
        NSString *animal_no = btn.itemId ?: @"1";
        // 去空格
        animal_no = [animal_no stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        // 防御 NSAttributedString
        if ([animal_no isKindOfClass:[NSAttributedString class]]) {
            animal_no = [(NSAttributedString *)animal_no string];
        }
        int animal_nos = animal_no.intValue;
        [bets addObject:@{@"amount":@(amount),@"animal_no":@(animal_nos),@"track":btn.type}];
    }
    self.resultArray=bets.copy;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:UserDefaultsGet(kToken) forKey:@"token"];
    [parameters setObject:[NSString stringWithFormat:@"%@",[wself.gameInfoDic valueForKey:@"game_id"]] forKey:@"game_id"];
    [parameters setObject:self.resultArray forKey:@"bets"];
    [NetworkRequest POSTNewNeW:rungame_placeBet parmeters:parameters success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        if (baseModel.code==1) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"恭喜您，下注成功"];
        }else{
            [SVProgressHUD dismiss];
            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:baseModel.msg];
        }
        
    } failture:^(NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:getLanguage(@"网络连接失败")];
    }];
}

-(void)gameItemClick:(RunGameButton *)button{
    WeakSelf
    if (wself.gameIsLock) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"本轮已锁定下注选择，请等待下一轮"];
        return;
    }
    if ([button.type isEqualToString:@"top"]) {
        NSArray *all=wself.gameTopItemDic.allValues;
        if (all.count>=2) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:getLanguage(@"狗/老虎/猪最多选择2个")];
        }else{
            [wself.gameTopItemDic setObject:button forKey:button.itemId];
        }
    }else{
        [wself.gameButtomItemDic setObject:button forKey:button.type];
    }
   
    [wself changeBtnState];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入下注数量"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType=UIKeyboardTypeNumberPad;
        textField.placeholder = @"1";
    }];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alert.textFields.firstObject;
        NSString *inputText = textField.text;
        button.countLabel.text=[NSString stringWithFormat:@"%ld",(long)(inputText.integerValue==0?1:inputText.integerValue)];
        button.amount=[NSString stringWithFormat:@"%ld",(long)(inputText.integerValue==0?1:inputText.integerValue)];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alert.textFields.firstObject;
        NSString *inputText = textField.text;
        button.countLabel.text=[NSString stringWithFormat:@"%ld",(long)(inputText.integerValue==0?1:inputText.integerValue)];
        button.amount=[NSString stringWithFormat:@"%ld",(long)(inputText.integerValue==0?1:inputText.integerValue)];
    }];
    // 添加 action
    [alert addAction:saveAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)changeBtnState{
    for (RunGameButton *btn in self.btnArray) {
        btn.selected=NO;
    }
    NSArray *btns=[self.gameTopItemDic allValues];
    for (RunGameButton *btn in btns) {
        btn.selected=YES;
    }
    NSArray *bbtns=[self.gameButtomItemDic allValues];
    for (RunGameButton *bbtn in bbtns) {
        bbtn.selected=YES;
    }
}
-(void)goRecord{
    RunGamaRecordViewController *vc=[[RunGamaRecordViewController alloc] initWithInfoDic:@{}];
    vc.modalPresentationStyle =UIModalPresentationOverCurrentContext;
    vc.finish = ^(NSDictionary * _Nonnull infoDic) {
        
    };
    [self presentViewController:vc animated:NO completion:nil];
}
-(void)exchange{
    //    CFMExDiamondAndBagAlert *al = [[NSBundle mainBundle] loadNibNamed:@"CFMExDiamondAndBagAlert" owner:self options:nil][0];
    ////    al.fetchRefresh = @"88888";//self.fetchRefresh;
    //    [al showOnview:self.view];
    //
    /** 兑换礼物*/
    CFMWalletDiamondExGiftVc *re = [[CFMWalletDiamondExGiftVc alloc]init];
    //    [self.navigationController pushViewController:re  animated:YES];
    re.modalPresentationStyle =UIModalPresentationOverCurrentContext;
    [self presentViewController:re animated:NO completion:nil];
}
-(void)currentGame{
    CurrentRunGamaViewController *vc=[[CurrentRunGamaViewController alloc] initWithInfoDic:@{}];
    vc.modalPresentationStyle =UIModalPresentationOverCurrentContext;
    vc.finish = ^(NSDictionary * _Nonnull infoDic) {
        
    };
    [self presentViewController:vc animated:NO completion:nil];
}
-(void)seeRule{
    if (self.roleInfoDic) {
        RunGamaRuleViewController *vc=[[RunGamaRuleViewController alloc] initWithInfoDic:self.roleInfoDic];
        vc.modalPresentationStyle =UIModalPresentationOverCurrentContext;
        vc.finish = ^(NSDictionary * _Nonnull infoDic) {
            
        };
        [self presentViewController:vc animated:NO completion:nil];
    }else{
        [SVProgressHUD dismiss];
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"数据获取中..."];
    }
    
}
-(void)closeVc{
    [self dismissViewControllerAnimated:NO completion:^{
        if(self.cancel){
            self.cancel();
        }
    }];
}

-(UIView *)contentView{
    if(!_contentView){
        _contentView=[[UIView alloc] initWithFrame:CGRectZero];
    }
    return _contentView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden=YES;
    
}

- (void)playLocalSVGA:(NSString *)svgaNme {
    NSString *path = [[NSBundle mainBundle] pathForResource:svgaNme ofType:@"svga"];
    
    if (!path) {
        NSLog(@"❌ 本地文件不存在");
        return;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    __weak typeof(self) weakSelf = self;
    
    [self.parser parseWithData:data cacheKey:@"local_svga" completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
        
        __strong typeof(weakSelf) self = weakSelf;
        
        self.player.videoItem = videoItem;
        [self.player startAnimation];
        
        
        
    } failureBlock:^(NSError * _Nonnull error) {
        NSLog(@"❌ 解析失败: %@", error);
    }];
}
#pragma mark - 播放结束回调
- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player {
    NSLog(@"✅ 播放结束");
    SVGAModel *model = player.svgaModel;
    NSLog(@"🎯 animId: %@", model.animId);
    NSLog(@"🎯 type: %@", model.type);
    NSLog(@"🎯 extra: %@", model.extra);
    //    if ([model.type isEqualToString:@"run"]) {
    //        SVGAModel *model = [SVGAModel new];
    //        model.animId = @"anim_001";
    //        model.type = @"wait";
    //        model.extra = @"等待动画";
    //        self.player.svgaModel = model;
    //        self.player.loops = 0;
    //        [self playLocalSVGA:@"待机"];
    //    }
}
-(void)changeGameState{
    NSInteger gameSate=[[self.gameInfoDic valueForKey:@"status"] integerValue];//0 押宝期 1比赛期 2结果期
    switch (gameSate) {
        case 0:
        {
            SVGAModel *model = [SVGAModel new];
            model.animId = @"anim_001";
            model.type = @"wait";
            model.extra = @"等待动画";
            self.player.svgaModel = model;
            self.player.loops = 0;
            [self playLocalSVGA:@"待机"];
            // 👉 押宝期：开启倒计时
            NSInteger countdown=[[self.gameInfoDic valueForKey:@"countdown"] integerValue];
            [self startCountdown:countdown];
            self.sureButton.enabled=YES;
        }
            break;
        case 1:
        {
            self.gameIsLock=YES;
            self.stateLabel.text=@"比赛中";
            self.sureButton.enabled=NO;
            [self playRunGame];
        }
            break;
        default:
        {
            self.gameIsLock=YES;
            SVGAModel *model = [SVGAModel new];
            model.animId = @"anim_001";
            model.type = @"wait";
            model.extra = @"等待动画";
            self.player.svgaModel = model;
            self.player.loops = 0;
            [self playLocalSVGA:@"待机"];
            self.stateLabel.text=@"结算中";
            self.sureButton.enabled=NO;
            [self showResult];
            
        }
            break;
    }
}
-(void)showResult{
    if (self.resultArray) {
        [SVProgressHUD dismiss];
        NSMutableArray *resultArray=[NSMutableArray array];
        for (NSDictionary *dic in self.resultArray) {
            if ([[NSString stringWithFormat:@"%@",[dic valueForKey:@"track"]] isEqualToString:@"top"]) {
                if ([[self.gameInfoDic valueForKey:@"winner_top"] integerValue]==[[dic valueForKey:@"animal_no"] integerValue]) {
                    NSMutableDictionary *tmpDic=[[NSMutableDictionary alloc] initWithDictionary:dic];
                    [tmpDic setObject:[NSString stringWithFormat:@"%@",[dic valueForKey:@"winner_top_name"]] forKey:@"winner_name"];
                }
            }else{
                if ([[self.gameInfoDic valueForKey:@"winner_bottom"] integerValue]==[[dic valueForKey:@"animal_no"] integerValue]) {
                    NSMutableDictionary *tmpDic=[[NSMutableDictionary alloc] initWithDictionary:dic];
                    [tmpDic setObject:[NSString stringWithFormat:@"%@",[dic valueForKey:@"winner_bottom_name"]] forKey:@"winner_name"];
                }
            }
        }
        
        RunGamaResultViewController *vc=[[RunGamaResultViewController alloc] initWithInfoDic:[resultArray copy]];
        vc.modalPresentationStyle =UIModalPresentationOverCurrentContext;
        vc.finish = ^(NSDictionary * _Nonnull infoDic) {
            
        };
        [self presentViewController:vc animated:NO completion:nil];
        self.resultArray=nil;
    }
}
-(void)playRunGame{
    SVGAModel *model = [SVGAModel new];
    model.animId = @"anim_002";
    model.type = @"run";
    model.extra = @"比赛动画";
    self.player.svgaModel = model;
    self.player.loops = 1;
    NSString *svgaName=[NSString stringWithFormat:@"%@和%@胜利",[self getInconName:[NSString stringWithFormat:@"%@",[self.gameInfoDic valueForKey:@"winner_bottom_name"]]],[self getInconName:[NSString stringWithFormat:@"%@",[self.gameInfoDic valueForKey:@"winner_top_name"]]]];
    NSLog(@"播放动画的名字是====%@",svgaName);
    [self playLocalSVGA:svgaName];
}
- (void)startCountdown:(NSInteger)seconds {
    
    // 防止重复创建
    [self stopCountdown];
    
    self.countdown = seconds;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(self.timer,
                              dispatch_walltime(NULL, 0),
                              1.0 * NSEC_PER_SEC,
                              0);
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_source_set_event_handler(self.timer, ^{
        
        __strong typeof(weakSelf) self = weakSelf;
        if (!self) return;
        
        if (self.countdown <= 0) {
            self.gameIsLock=YES;
            [self stopCountdown];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.stateLabel.text = @"比赛中";
                [self getCurrentGame];
            });
            
        } else {
            NSInteger time = self.countdown;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (time>7) {
                    self.gameIsLock=NO;
                }else{
                    self.gameIsLock=YES;
                }
                if (time==7) {
                    [self sureClick];
                }
                self.stateLabel.text = [NSString stringWithFormat:@"%.2ld", (long)time];
            });
            self.countdown--;
        }
    });
    
    dispatch_resume(self.timer);
}
- (void)stopCountdown {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}
#pragma mark - 释放（重要）
- (void)dealloc {
    [self.player stopAnimation];
    self.player.videoItem = nil;
    [self stopCountdown]; // 👈 必加
}
/** 获取余额等*/
- (void)fetchBalance
{
    WeakSelf
    [NetworkRequest POST:user_getMoney parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        NSDictionary *balanceInfo = baseModel.data ;
        /** 黑曜石*/
        NSString *ratio_coin = balanceInfo[@"ratio_coin"];
        NSMutableAttributedString *totalAttri = [[NSMutableAttributedString alloc] initWithString:@""];
        UIImage *totalag=[UIImage imageNamed:@"钥匙"];
        NSTextAttachment *totalAttch = [[NSTextAttachment alloc] init];
        totalAttch.image = totalag;
        totalAttch.bounds = CGRectMake(0, -2, 11.5, 14);
        NSAttributedString *sexString = [NSAttributedString attributedStringWithAttachment:totalAttch];
        [totalAttri appendAttributedString:sexString];
        [totalAttri appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        [totalAttri appendAttributedString:[[NSAttributedString alloc] initWithString:ratio_coin]];
        wself.balanceLabel.attributedText=totalAttri;
        
    } failture:^(NSError *error) {
        
    }];
}
-(void)getRoleInfo{
    WeakSelf
    [NetworkRequest requestGET:rungame_role parameters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        NSDictionary *roleInfoDic = baseModel.data;
        wself.roleInfoDic=roleInfoDic;
    } error:^(NSError *errors) {
        
    }];
}
-(void)getCurrentGame{
    WeakSelf
    [NetworkRequest requestGET:rungame_getCurrentGame parameters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        wself.gameInfoDic= baseModel.data;
        NSInteger gameSate=[[self.gameInfoDic valueForKey:@"status"] integerValue];//0 押宝期 1比赛期 2结果期
        if (gameSate==0) {
            
        }else{
            NSInteger countdown=[[self.gameInfoDic valueForKey:@"countdown"] integerValue];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(countdown * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [wself getCurrentGame];
            });
        }
        [self changeGameState];
        //        [self getMyBet];
    } error:^(NSError *errors) {
        
    }];
}
-(void)getMyBet{
    WeakSelf
    [NetworkRequest requestGET:[NSString stringWithFormat:@"%@?game_id=%@", rungame_getMyBet,[wself.gameInfoDic valueForKey:@"game_id"]] parameters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
    } error:^(NSError *errors) {
        
    }];
}

-(UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.font = [UIFont boldSystemFontOfSize:26];
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.backgroundColor=[UIColor clearColor];
    }
    return _stateLabel;
}
-(NSString *)getInconName:(NSString *)name{
    if ([name containsString:@"猪"]) {
        return @"猪";
    }else if ([name containsString:@"狗"]) {
        return @"狗狗";
    }else if ([name containsString:@"虎"]) {
        return @"老虎";
    }else if ([name containsString:@"龟"]) {
        return @"乌龟";
    }else if ([name containsString:@"兔"]) {
        return @"兔子";
    }else{
        return @"兔子";
    }
}
@end

@implementation RunGameButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.countLabel];
        [self addSubview:self.closeButton];
    }
    return self;
}
-(void)closeClick{
    self.selected=NO;
    if (self.cancelClick) {
        self.cancelClick(self);
    }
}
-(UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 0, self.width-6, self.height)];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.font = [UIFont boldSystemFontOfSize:16];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.backgroundColor=[UIColor clearColor];
        _countLabel.text=@"1";
    }
    return _countLabel;
}
-(UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame=CGRectMake(self.width-30, 0, 30, 30);
        [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setImage:[UIImage imageNamed:@"不选择按钮"] forState:UIControlStateNormal];
        _closeButton.imageEdgeInsets=UIEdgeInsetsMake(0, 16, 16, 0);
        _closeButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return _closeButton;
}
@end
