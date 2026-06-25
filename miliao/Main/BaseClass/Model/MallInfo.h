//
//  MallInfo.h
//  enjoyfun
//
//  Created by 李东阳 on 2019/10/23.
//  Copyright © 2019 锤子科技. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OrderInfoPreSubmit ;

@interface MallInfo : BaseModelDy
@property (nonatomic,strong) NSMutableArray *data;
@end

/** 购物车*/
@interface CarInfo : BaseModelDy
@property (nonatomic,strong) NSMutableArray *goods;
@property (nonatomic,strong) NSString *shopId;
@property (nonatomic,strong) NSString *shopName;
@end

/** 购物车商品*/
@interface CarInfoGood : BaseModelDy
@property (nonatomic,strong) NSString *goodId;
@property (nonatomic,strong) NSString *icon;
@property (nonatomic,strong) NSString *property;
@property (nonatomic,strong) NSString *shopId;
@property (nonatomic,strong) NSString *shopName;
@property (nonatomic,strong) NSString *standardDetailId;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,assign) int isVaild;
@property (nonatomic,assign) int num;
@property (nonatomic,strong) NSDecimalNumber *price;
@property (nonatomic,strong) NSString *propertyName;
@end

/** 失效商品*/
@interface CarValidGood : BaseModelDy
@property (nonatomic,strong) NSMutableArray *data;
@end

/** 收货地址*/
@interface AddressInfo : BaseModelDy
@property (nonatomic,strong) NSMutableArray *data;
@end

@interface AddressInfoModel : BaseModelDy
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *areaId;
@property (nonatomic,strong) NSString *areaName;
@property (nonatomic,strong) NSString *cityId;
@property (nonatomic,strong) NSString *cityName;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *provinceId;
@property (nonatomic,strong) NSString *provinceName;
@property (nonatomic,strong) NSString *detailAddress;
@property (nonatomic,strong) NSString *lable;

@property (nonatomic,strong) NSString *sex;
@property (nonatomic,strong) NSString *userId;

@property (nonatomic,assign) int isDef;
@property (nonatomic,strong) NSString *latitude;
@property (nonatomic,strong) NSString *longitude;
@end

@interface AddressInfoSave : BaseModelDy
@property (nonatomic,strong) AddressInfoModel *data;
@end


/** 订单*/
@interface OrderInfo : BaseModelDy
@property (nonatomic,strong) NSMutableArray *data;
@end

@interface OrderInfoModel : BaseModelDy
@property (nonatomic,strong) NSString *addressId;
@property (nonatomic,strong) AddressInfoModel *appUserAddress;
/** 店铺信息*/
@property (nonatomic,strong) ShopInfoModel *shop;
@property (nonatomic,strong) NSString *code;
@property (nonatomic,strong) NSString *freight;
@property (nonatomic,strong) NSMutableArray *orderGoodList;
@property (nonatomic,strong) NSMutableArray *userCoupons;
@property (nonatomic,strong) NSString *logisticsCode;
@property (nonatomic,strong) NSString *logisticsCompany;
/** 积分订单信息*/
@property (nonatomic,strong) NSString *goodIcon;
@property (nonatomic,strong) NSString *goodTitle;
@property (nonatomic,assign) int goodType;
@property (nonatomic,assign) int payCredits;
/** 规格*/
@property (nonatomic,strong) NSString *propertyNames;
@property (nonatomic,strong) NSString *time;
/** 满减*/
@property (nonatomic,strong) NSMutableArray *farmCuts;
@property (nonatomic,assign) int total;
@property (nonatomic,assign) int totalNum;
/** 满减或优惠券类型 ： 0不选择1满减2优惠券*/
@property (nonatomic,assign) int discountType;
/** 平台满减活动id*/
@property (nonatomic,assign) int farmCutId;
@property (nonatomic,strong) NSDecimalNumber *cutMoney;
@property (nonatomic,strong) NSDecimalNumber *limitMoney;
@property (nonatomic,strong) NSDecimalNumber *littlePay;
/** 优惠券减免金额*/
@property (nonatomic,strong) NSDecimalNumber *couponMoney;

/** 代金券金额*/
@property (nonatomic,strong) NSDecimalNumber *voucherMoney;
/** 赠送健康宝石数量*/
@property (nonatomic,strong) NSString *giveHealthStoneNum;
/** 报单商品赠送积分*/
@property (nonatomic,strong) NSString *giveCredits;

/** 用户选择的优惠券*/
@property (nonatomic,strong) CouponInfoModel *appUserCoupon;
@property (nonatomic,strong) NSString *startTime;
@property (nonatomic,assign) NSString *cusEndTime;
@property (nonatomic,assign) int eggNumber;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *signUrl;
@property (nonatomic,strong) NSString *icon;
@property (nonatomic,strong) NSString *num;
@property (nonatomic,strong) NSString *orderId;
@property (nonatomic,strong) NSString *levelHeader;
@property (nonatomic,strong) NSString *levelName;
@property (nonatomic,strong) NSString *levelPhone;
@property (nonatomic,strong) NSDecimalNumber *price;
@property (nonatomic,strong) NSString *propertyGroup;
@property (nonatomic,strong) NSString *standardId;
@property (nonatomic,strong) NSDecimalNumber *payMoney;
@property (nonatomic,strong) NSDecimalNumber *money;
@property (nonatomic,strong) NSString *projectId;
@property (nonatomic,strong) NSDecimalNumber *sum;
@property (nonatomic,strong) NSString *remark;
@property (nonatomic,strong) NSString *shopId;
@property (nonatomic,strong) NSString *shopName;
@property (nonatomic,strong) NSString *shopPhone;
@property (nonatomic,strong) NSString *takeNum;
@property (nonatomic,strong) NSString *unionCode;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *imgUrl;
@property (nonatomic,strong) NSString *goodId;
@property (nonatomic,assign) int number;
@property (nonatomic,assign) int isLocked;
@property (nonatomic,strong) NSString *ranchId;
/** 退款订单手动标识*/
@property (nonatomic,assign) int tempIsReturnOrder;
/** 订单时间*/
@property (nonatomic,strong) NSString *payTime;
@property (nonatomic,strong) NSString *commentTime;
@property (nonatomic,strong) NSString *cancelTime;
@property (nonatomic,strong) NSString *shipTime;
@property (nonatomic,strong) NSString *receiptTime;
/** 牧场*/
@property (nonatomic,strong) OrderInfoModel *ranch;
/** 商家退款拒绝原因*/
@property (nonatomic,strong) NSString *refuseReason;
@property (nonatomic,strong) NSString *returnReason;
@property (nonatomic,strong) NSString *images;
/** 收货地址*/
@property (nonatomic,strong) AddressInfoModel *orderAddressInfo;
/** 退款订单下包含的原订单信息*/
@property (nonatomic,strong) OrderInfoModel *order;
/** 地址信息*/
@property (nonatomic,strong) NSString *receiveAddress;
@property (nonatomic,strong) NSString *receiveName;
@property (nonatomic,strong) NSString *receivePhone;

@property (nonatomic,assign) int isReturn;
@property (nonatomic,assign) int isLimit;
@property (nonatomic,assign) int pickupType;
@property (nonatomic,assign) int payType;
/** 1图文2视频*/
@property (nonatomic,assign) int homeType;
@property (nonatomic,assign) int support;
@property (nonatomic,assign) int focus;
@property (nonatomic,assign) int isComment;
@property (nonatomic,assign) int isSupport;
@property (nonatomic,strong) NSString *videoImage;
@property (nonatomic,strong) NSString *videoUrl;
@property (nonatomic,strong) NSString *videoGif;
@property (nonatomic,strong) NSString *issuerHeader;
@property (nonatomic,strong) NSString *issuer;
@property (nonatomic,strong) NSString *issuerName;
@property (nonatomic,strong) NSString *supportNum;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *commentNum;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *categoryIcon;
@property (nonatomic,strong) NSString *categoryName;
@property (nonatomic,strong) NSString *userHeader;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *userPhone;
@property (nonatomic,strong) NSString *header;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *bindTime;
/** 手动添加，是否商家版订单管理*/
@property (nonatomic,assign) int isMerchantOrderTemp;
/** 订单里用户评价的图片处理成 strAry*/
@property (nonatomic,strong) NSMutableArray *imagesUrlAry;
/** 是否显示删除按钮，只有个人主页的展示删除按钮*/
@property (nonatomic,assign) int whetherShowDeleteTemp;
/** 预计算*/
@property (nonatomic,strong) NSDecimalNumber *oldPrice;
@property (nonatomic,strong) NSString *goodName;
@property (nonatomic,assign) int sellNum;
/** 订单里的商品*/
@property (nonatomic,strong) NSMutableArray *orderGoods;
@end

@interface OrderInfoLook : BaseModelDy
@property (nonatomic,strong) OrderInfoModel *data;
@end


/** 订单预计算*/
@interface OrderInfoPreSubmitData : BaseModelDy
@property (nonatomic,strong) OrderInfoPreSubmit *data;
@end

@interface OrderInfoPreSubmit : BaseModelDy
@property (nonatomic,assign) int eggNumber;
@property (nonatomic,strong) NSDecimalNumber *freight;
@property (nonatomic,strong) NSDecimalNumber *payMoney;
@property (nonatomic,strong) NSDecimalNumber *sum;
@property (nonatomic,assign) int total;
@property (nonatomic,strong) NSMutableArray *details;
@property (nonatomic,assign) int totalStatus;
/** 订单标号*/
@property (nonatomic,strong) NSString *code;
@property (nonatomic,strong) NSString *unionCode;
/** 小计金额*/
@property (nonatomic,strong) NSDecimalNumber *littlePay;
/** 总订单活动扣减金额*/
@property (nonatomic,strong) NSDecimalNumber *totalCut;
/** 总订单运费金额*/
@property (nonatomic,strong) NSDecimalNumber *totalFreight;
/** 总订单实际支付金额*/
@property (nonatomic,strong) NSDecimalNumber *totalPay;
/** 积分商品type*/
@property (nonatomic,assign) int goodType;
@property (nonatomic,assign) int payCredits;
@property (nonatomic,assign) int goodCredits;
@property (nonatomic,assign) int userCredits;
/** 积分商品信息*/
@property (nonatomic,strong) NSString *goodIcon;
@property (nonatomic,strong) NSString *goodTitle;
@property (nonatomic,strong) NSDecimalNumber *goodPrice;
@end



