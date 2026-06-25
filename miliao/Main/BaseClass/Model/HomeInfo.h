//
//  CityInfo.h
//  ChinaFuel
//
//  Created by 李东阳 on 2019/5/9.
//  Copyright © 2019 锤子科技. All rights reserved.
//

#import "BaseModelDy.h"
@class ShopInfoModel;

@interface HomeInfo : BaseModelDy
/** data*/
@property (nonatomic,strong) NSMutableArray *data;
@end

@interface HomeInfoModel : BaseModelDy
@property (nonatomic,strong) NSString *capital;
@property (nonatomic,strong) NSString *fatherId;
@property (nonatomic,strong) NSString *freight;
@property (nonatomic,assign) int isHot;
@property (nonatomic,assign) int open;
@property (nonatomic,strong) NSString *name;
/** 用户记录里返回的信息*/
@property (nonatomic,strong) NSString *cityId;
@property (nonatomic,strong) NSString *cityName;
@property (nonatomic,strong) NSString *provinceId;
@property (nonatomic,strong) NSString *provinceName;
@end

/** lunbo*/
@interface LunboInfo : BaseModelDy
/** data*/
@property (nonatomic,strong) NSMutableArray *data;
@end

@interface LunboInfoModel : BaseModelDy
@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSString *itemName;
@property (nonatomic,assign) int itemId;
@property (nonatomic,assign) int position;
@property (nonatomic,assign) int sort;
@property (nonatomic,assign) int type;
/** 新闻详情*/
@property (nonatomic,strong) NSString *content;
/** 新闻标题*/
@property (nonatomic,strong) NSString *title;
/** 如果指向为url的话*/
@property (nonatomic,strong) NSString *url;
@end

/** 商品列表*/
@interface GoodListInfo : BaseModelDy
@property (nonatomic,strong) NSMutableArray *data;
@end

@interface GoodListInfoModel : BaseModelDy
@property (nonatomic,strong) NSString *partition_name,*heat_text,*memo,*duration;
@property (nonatomic,assign) int exchange_num,num,gift_num;
@property (nonatomic,strong) NSString *charm_diff,*total_gift_charm,*gift_name,*gift_image,*contribute_diff;
@property (nonatomic,strong) NSString *total_cost,*draw_times,*bet_amount,*prize_coin;
@property (nonatomic,assign) int change_type;
@property (nonatomic,strong) NSString *change_type_text,*money,*diamond,*price;
@property (nonatomic,strong) NSString *avatar,*nickname,*role;
@property (nonatomic,strong) NSString *groupid,*owner_user_id,*group_name;
@property (nonatomic,assign) int tempSelectMark;
@property (nonatomic,strong) NSString *inventUserHeader,*friendArr,*itemCode,*inventUserName,*user_id;
@property (nonatomic,assign) float change;
@property (nonatomic,assign) float changePercent;
@property (nonatomic,strong) NSString *companyName;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *music_file,*lyric_file;
@property (nonatomic,strong) NSDecimalNumber *currentPrice;
@property (nonatomic,assign) int goodCategoryId;
@property (nonatomic,strong) NSString *images;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *updateTime;
@property (nonatomic,strong) NSString *standard;
@property (nonatomic,strong) NSString *goodCategtoryName;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *logo;
/** 商品分类*/
@property (nonatomic,assign) int level;
@property (nonatomic,assign) int shopId;
@property (nonatomic,strong) NSString *fatherId;
@property (nonatomic,strong) NSString *icon;
/** 产品参数*/
@property (nonatomic,strong) NSString *parameter;
/** 六机头条*/
@property (nonatomic,strong) NSString *author;
@property (nonatomic,strong) NSString *provinceId;
@property (nonatomic,assign) int supportNum;
@property (nonatomic,assign) int readNum;
/** 首页三张活动分类图*/
@property (nonatomic,strong) NSString *itemId;
/** 1宽屏图2半屏图*/
@property (nonatomic,assign) int position;
/** 分类  1店铺2商品*/
@property (nonatomic,assign) int type;

/** 商品*/
@property (nonatomic,assign) int browseNum;
@property (nonatomic,assign) int callNum;
/** 一级分类id*/
@property (nonatomic,assign) int categoryId;
/** 三级分类商品id*/
@property (nonatomic,assign) int threeCategoryId;
@property (nonatomic,strong) NSString *cityId;
@property (nonatomic,strong) NSString *cityName;
@property (nonatomic,strong) NSString *descr;
@property (nonatomic,assign) int favorableRate;
@property (nonatomic,strong) NSString *firstCategoryName;
@property (nonatomic,strong) NSString *flushTime;
@property (nonatomic,strong) NSString *goodMarketName;
@property (nonatomic,strong) NSString *goodTradeName;
@property (nonatomic,assign) int isRecommend;
@property (nonatomic,assign) int isShelf;
@property (nonatomic,strong) NSString *limitBeginTime;
@property (nonatomic,strong) NSString *limitEndTime;
@property (nonatomic,strong) NSString *provinceName;
@property (nonatomic,assign) int recommendSort;
@property (nonatomic,assign) int sold;
@property (nonatomic,strong) NSString *tags;
@property (nonatomic,strong) NSString *thirdCategoryName;
/** 是否置顶 0否1是*/
@property (nonatomic,assign) int isLimit;
/** 是否收藏 0否1是*/
@property (nonatomic,assign) int isCollect;

/** shop*/
@property (nonatomic,strong) ShopInfoModel *shop;
/** 店铺广告位*/
@property (nonatomic,strong) NSString *image;
/** 二三级分类*/
@property (nonatomic,strong) NSArray *ecCategories;
@end

/** 商品详情*/
@interface GoodDetailModel : BaseModelDy
@property (nonatomic,strong) GoodListInfoModel *data;
@end

/** 商品分类*/
@interface GoodCateInfo : BaseModelDy
@property (nonatomic,strong) NSMutableArray *data;
@end

/** 头条详情*/
@interface NewsLookModel : BaseModelDy
@property (nonatomic,strong) GoodListInfoModel *data;
@end


/** 店铺详情*/
@interface ShopInfo : BaseModelDy
@property (nonatomic,strong) ShopInfoModel *data;
@end

@interface ShopInfoModel : BaseModelDy
/** 店铺*/
@property (nonatomic,strong) NSString *aboutUs;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *calendarDate;
@property (nonatomic,strong) NSDecimalNumber *balance;
@property (nonatomic,strong) NSString *background;
@property (nonatomic,assign) int approveNum;
@property (nonatomic,assign) int collectNum;
@property (nonatomic,strong) NSString *companyCategory;
@property (nonatomic,strong) NSString *creditCode;
@property (nonatomic,strong) NSString *mainProduct;
@property (nonatomic,strong) NSString *doorAddress;
@property (nonatomic,strong) NSString *failReason;
@property (nonatomic,strong) NSString *manageScope;
@property (nonatomic,strong) NSString *notice;
@property (nonatomic,assign) int focus;
@property (nonatomic,assign) int goodNum;
@property (nonatomic,assign) int isApprove;
@property (nonatomic,strong) NSString *latitude;
@property (nonatomic,strong) NSString *longitude;
@property (nonatomic,strong) NSString *regAptitude;
@property (nonatomic,strong) NSString *saleBrand;
@property (nonatomic,strong) NSString *shopImages;
@property (nonatomic,strong) NSString *shopKeeperName;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *wareHouseAddress;
@property (nonatomic,strong) NSString *wechatId;
@property (nonatomic,assign) int sellNumber;
@property (nonatomic,assign) int userId;
@property (nonatomic,assign) int sixMachineMoney;
@property (nonatomic,strong) NSString *icon;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *descr;
@property (nonatomic,strong) NSString *telephone;
/** 行业*/
@property (nonatomic,strong) NSString *shopTradeName;
@property (nonatomic,assign) int shopTradeId;
/** 种类*/
@property (nonatomic,strong) NSString *shopCategoryName;
@property (nonatomic,assign) int categoryId;
/** 市场*/
@property (nonatomic,strong) NSString *shopMarketName;
@property (nonatomic,assign) int shopMarketId;
/** 城市信息*/
@property (nonatomic,strong) NSString *cityId;
@property (nonatomic,strong) NSString *cityName;
@property (nonatomic,strong) NSString *provinceId;
@property (nonatomic,strong) NSString *provinceName;
/** 是否收藏 0否1是*/
@property (nonatomic,assign) int isCollect;
/** 是否点赞 0否1是*/
@property (nonatomic,assign) int isSupport;
@property (nonatomic,strong) NSString *images;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *wechatName;
@property (nonatomic,strong) NSString *companyName;
@end

/** 店铺列表*/
@interface ShopInfoList : BaseModelDy
/** list*/
@property (nonatomic,strong) NSMutableArray *data;
@end

/** 商品规格*/
@interface GoodStanderModel : BaseModelDy
@property (nonatomic,strong)NSArray * goodStandProperties;
@property (nonatomic,strong)NSString *propertyIds;
@property (nonatomic,strong)NSString * propertyNames;
@property (nonatomic,strong)NSString *nowPrice;
@property (nonatomic,strong)NSString * icon;
@property (nonatomic,strong)NSString * title;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString * store;
@property (nonatomic,strong)NSString *price;
@property (nonatomic,strong)NSString * isLimit;
@property (nonatomic,strong)NSString *limitStore;
@property (nonatomic,strong)NSString * limitPrice;

@end

/** 商品评价列表*/
@interface GoodCommet : BaseModelDy
@property (nonatomic,strong) NSMutableArray *data;
@end

@interface GoodCommentModel : BaseModelDy
@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSString *itemName;
@property (nonatomic,strong) NSString *itemId;
@property (nonatomic,strong) NSString *userHeader;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,assign) int userId;
@property (nonatomic,assign) int orderId;
@property (nonatomic,assign) int goodId;
@property (nonatomic,assign) int  star;
/** 文字*/
@property (nonatomic,strong) NSString *content;
/** 多图*/
@property (nonatomic,strong) NSString *images;
/** 商品多图的strAry*/
@property (nonatomic,strong) NSMutableArray *imagesStrAry;
/** 服务描述*/
@property (nonatomic,strong) NSString *depict;
/** 服务名称*/
@property (nonatomic,strong) NSString *name;
@end


/** 优惠券列表*/
@interface CouponInfo : BaseModelDy
@property (nonatomic,strong) NSMutableArray *data;
@end

@interface CouponInfoModel : BaseModelDy
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSDecimalNumber *limitMoney;
@property (nonatomic,strong) NSDecimalNumber *cutMoney;
@property (nonatomic,strong) NSString *expireTime;

@end


