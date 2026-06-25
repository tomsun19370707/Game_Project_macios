//
//  CFMRateRewardVc.m
//
//  类介绍说明：
//
//

#import "CFMRateRewardVc.h"
// DTO

// View
#import "CFMRateRewardHis.h"
#import "CFMRateRewardInput.h"
// 下级控制器

@interface CFMRateRewardVc ()<SDCycleScrollViewDelegate>
/** DTO */
//@property (nonatomic,strong) <#DTOHandle#> *handle;
/** 底部背景*/
@property (nonatomic,strong) UIImageView *bg;
/** 记录*/
@property (nonatomic,strong) CFMRateRewardHis *ruleVie;
/** 底部兑换*/
@property (nonatomic,strong) CFMRateRewardInput *inputVie;
/** 记录键盘高度*/
@property (nonatomic,assign) CGFloat keyboardHeight;
/** 盘详情*/
@property (nonatomic,strong) NSDictionary *panLook;
/** lunbo*/
@property (nonatomic,strong) SDCycleScrollView *cycleImageView;
/**轮播图列表*/
@property (nonatomic,strong) NSMutableArray<NSString *> *lunboStrArr;
/** 当前选择的选项index*/
@property (nonatomic,assign) NSUInteger selIndex;
/** 左右侧按钮切换*/
@property (nonatomic,strong) UIButton *leftSwBtn,*rightSwBtn;
@end

@implementation CFMRateRewardVc

#pragma mark -
#pragma mark 加载控制器
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /** 获取余额等*/
    [self fetchBalance];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // NavBar
    [self initNavBar];
    // 布局视图
    [self initContentView];
    // Rac
    [self initRacChain];
    // 网络请求
    [self initRequestData];
}

#pragma mark -
#pragma mark --- init nav
- (void)initNavBar {
    self.navigationBar.type = BaseNavBarTypeDarkMode ;
    self.navigationBar.backgroundColor = UIColor.clearColor ;
}

#pragma mark -
#pragma mark --- 创建控件
- (void)initContentView {
    self.selIndex = 0 ;
    [self.view addSubview:self.bg];
    [self.view  addSubview:self.cycleImageView];
    if (self.vcType!=2) {
        [self.view addSubview:self.leftSwBtn];
        [self.view addSubview:self.rightSwBtn];
    }
    [self.view addSubview:self.ruleVie];
    [self.view addSubview:self.inputVie];
}

#pragma mark -
#pragma mark --- Rac方法
- (void)initRacChain {
    @weakify(self);
    /** 键盘的弹出*/
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        //获取键盘的高度
        NSDictionary *userInfo = [x userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        CGFloat height = keyboardRect.size.height;
        if (self.keyboardHeight != height) {
            [self.inputVie setBottom:(SCREEN_HEIGHT_dy - height)];
            self.keyboardHeight = height ;
            DLog(@"\n+++++++++%f",height);
        }
    }];
    
    /** 键盘消失*/
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        self.keyboardHeight = 0.0 ;
        [self.inputVie setBottom:SCREEN_HEIGHT_dy];
    }];
    
    /** 下注*/
    [[self.inputVie.sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (!self.panLook) {
            return;
        }
        if (self.inputVie.tf.text.floatValue <= 0) {
            [SVProgressHUD showTextHUDWithMessage:@"请输入下注金额"];
            return;
        }
        /** 下注的选项*/
        /** 轮播图*/
        NSArray *options = self.panLook[@"options"];
        NSDictionary *tarOption = options[self.selIndex];
        /** para*/
        NSMutableDictionary *parameter =[NSMutableDictionary dictionary];
        parameter[@"id"] = self.rewardId;
        parameter[@"amount"] = self.inputVie.tf.text ;
        parameter[@"option_id"] = FORMAT(tarOption[@"id"]);
        
        [NetworkRequest POST:ratio_bet parmeters:parameter success:^(id responObject) {
            @strongify(self);
            [SVProgressHUD showTextHUDWithMessage:@"下注成功"];
            /** 获取余额等*/
            [self fetchBalance];
        } failture:^(NSError *error) {
            
        }];
    }];
    
    /** 刷新余额*/
    self.inputVie.fetchRefresh = ^{
        @strongify(self);
        /** 获取余额等*/
        [self fetchBalance];
    };
    
    /** 左右的滚动*/
    [[self.leftSwBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (self.selIndex > 0) {
        }else{
            return;
        }
        self.selIndex -- ;
        [self.cycleImageView makeScrollViewScrollToIndex:self.selIndex];
    }];
    
    [[self.rightSwBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (self.selIndex == self.lunboStrArr.count - 1) {
            return;
        }
        self.selIndex ++ ;
        [self.cycleImageView makeScrollViewScrollToIndex:self.selIndex];
    }];
}

#pragma mark -
#pragma mark --- 网络请求
- (void)initRequestData {
    /** 获取固定或者随机倍率盘详情*/
    [self fetchPanInfo];
}

#pragma mark -
#pragma mark --- Getter
-(UIImageView *)bg
{
    if (!_bg) {
        _bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
//        _bg.image = IMAGE(@"rate_reward_bg");
        _bg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bg;
}
-(CFMRateRewardHis *)ruleVie
{
    if (!_ruleVie) {
        _ruleVie = [[[NSBundle mainBundle] loadNibNamed:@"CFMRateRewardHis" owner:self options:nil]lastObject];
        _ruleVie.selectionStyle = UITableViewCellSelectionStyleNone ;
        [_ruleVie setFrame:CGRectMake(0, NavBarHeight + 16, _ruleVie.contentView.width, _ruleVie.contentView.height)];
        _ruleVie.right = SCREENWIDTH - 10 ;
    }
    return _ruleVie;
}
-(CFMRateRewardInput *)inputVie
{
    if (!_inputVie) {
        _inputVie = [[[NSBundle mainBundle] loadNibNamed:@"CFMRateRewardInput" owner:self options:nil]lastObject];
        _inputVie.selectionStyle = UITableViewCellSelectionStyleNone ;
        [_inputVie setFrame:CGRectMake(0, 0, SCREEN_WIDTH, _inputVie.contentView.height)];
        _inputVie.bottom = SCREEN_HEIGHT_dy;
        if (self.vcType==2) {
            [_inputVie.sureBtn setBackgroundColor:HexColorDy(@"#FFE68B") forState:UIControlStateNormal];
            [_inputVie.sureBtn setTitleColor:HexColorDy(@"#684084") forState:UIControlStateNormal];
            _inputVie.title.textColor = HexColorDy(@"#E5C8FF");
        }
    }
    return _inputVie;
}
- (SDCycleScrollView *)cycleImageView
{
    if (!_cycleImageView) {
        CGFloat temp = 0.9 ;
        CGFloat width = SCREENWIDTH - 45 * 2;
        _cycleImageView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, width, width * temp)];
        _cycleImageView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
//        _cycleImageView.autoScrollTimeInterval = 5.0;
        _cycleImageView.autoScroll = NO ;
        _cycleImageView.delegate = self;
        _cycleImageView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter ;
        _cycleImageView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill ;
        _cycleImageView.backgroundColor = UIColor.clearColor;
        _cycleImageView.showPageControl = YES;/** 是否显示分页控件 */
        _cycleImageView.placeholderImage = nil;
        _cycleImageView.currentPageDotColor = BaseMainColor ;
        _cycleImageView.pageDotColor = UIColorFromRGB(0xE6E6E6) ;
        _cycleImageView.layer.masksToBounds = YES;
        _cycleImageView.layer.cornerRadius = 10 ;
        _cycleImageView.centerY = SCREEN_HEIGHT_dy / 2.0 ;
        _cycleImageView.centerX = SCREENWIDTH / 2.0 ;
    }
    return _cycleImageView ;
}
-(UIButton *)leftSwBtn
{
    if (!_leftSwBtn) {
        _leftSwBtn = [UIButton racButtonWithTitle:nil BGImage:IMAGE(@"bei_pan_change_left") frame:CGRectMake(0, 0, 70, 120) fontSize:1 titleColor:nil];
        _leftSwBtn.centerY = self.cycleImageView.centerY;
    }
    return _leftSwBtn;
}
-(UIButton *)rightSwBtn
{
    if (!_rightSwBtn) {
        _rightSwBtn = [UIButton racButtonWithTitle:nil BGImage:IMAGE(@"bei_pan_change_right") frame:CGRectMake(0, 0, 70, 120) fontSize:1 titleColor:nil];
        _rightSwBtn.right = SCREENWIDTH ;
        _rightSwBtn.centerY = self.cycleImageView.centerY;
    }
    return _rightSwBtn;
}
#pragma mark --
#pragma mark --- Method
/** 获取余额等*/
- (void)fetchBalance
{
    WeakSelf
    [NetworkRequest POST:user_getMoney parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        NSDictionary *balanceInfo = baseModel.data ;
        
        /** 黑曜石*/
        NSString *ratio_coin = balanceInfo[@"ratio_coin"];
        wself.inputVie.balance.text = [NSString stringWithFormat:@"当前黑曜石：%.2f",ratio_coin.floatValue];
        wself.inputVie.balanceWid.constant = [NSString widthForContent:wself.inputVie.balance.text font:wself.inputVie.balance.font] + 3 ;
        
    } failture:^(NSError *error) {
        
    }];
}

/** 获取固定或者随机倍率盘详情*/
- (void)fetchPanInfo
{
    /** para*/
    NSMutableDictionary *parameter =[NSMutableDictionary dictionary];
    parameter[@"id"] = self.rewardId;
    WeakSelf
    [NetworkRequest POST:ratio_room_detail parmeters:parameter success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        wself.panLook = baseModel.data ;
        
        /** 背景*/
        NSString *image = baseModel.data[@"room_info"][@"image"];
        [wself.bg sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:nil];
        
        /** 轮播图*/
        NSArray *options = wself.panLook[@"options"];
        NSMutableArray *images = [NSMutableArray array];
        [options enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            [images addObject:dic[@"image"]];
        }];
        wself.cycleImageView.imageURLStringsGroup = images ;
        /** 记录*/
        wself.lunboStrArr = images ;
        
        /** 规则*/
//        wself.ruleVie.model = wself.panLook ;
        
    } failture:^(NSError *error) {
        
    }];
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    self.selIndex = index ;
}
@end
