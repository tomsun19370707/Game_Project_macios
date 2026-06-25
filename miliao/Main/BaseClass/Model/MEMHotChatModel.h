//
//  MEMHotChatModel.h
//
//  类介绍说明：
//
//

#import <Foundation/Foundation.h>
#import "BaseModelDy.h"
//#import "YXLTagEditorImageView.h"//标签

@class MEMHotChatDataModel;
@class MEMHotChatInfoModel;

@interface MEMHotChatModel : BaseModelDy

@property (nonatomic,strong) NSMutableArray *data;


@end

@interface MEMHotChatDataModel : BaseModelDy

@property (nonatomic,strong) MEMHotChatInfoModel *data;
@property (nonatomic,strong) MEMHotChatInfoModel *goods;
@property (nonatomic,strong) MEMHotChatInfoModel *address;
@property (nonatomic,strong) NSMutableArray *list;
@property (nonatomic,strong) NSDictionary *goodsGroupRecord;//


@end

@interface MEMHotChatInfoModel : BaseModelDy
@property (nonatomic,assign) int isJoin;
@property (nonatomic,strong) NSString *groupName,*user_role,*groupid;
/** 一级评论model*/
@property (nonatomic,strong) MEMHotChatInfoModel *tempFirstLevelModel;
@property (nonatomic,strong) NSMutableDictionary *friendEntity;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,assign) BOOL isEnpmt;//是否展开 默认NO
//@property (nonatomic,assign) int workingTime;
@property (nonatomic,strong) NSString *fenzu_name;
//@property (nonatomic,strong) MEMHotChatInfoModel *project;
@property (nonatomic,strong) NSMutableArray *friendList;
///** 预约人数*/
//@property (nonatomic,assign) int totalServiceNumber;
@property (nonatomic,copy)NSString * feirnd_num;
//@property (nonatomic,copy)NSString * is_shield;
@property (nonatomic,strong) NSString *goodIcon;
@property (nonatomic,strong) NSString *goodTitle;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *detailAddress;
@property (nonatomic,strong) NSString *logisticsCode,*logisticsCompany;
@property (nonatomic,strong) NSString *payTime,*sendTime,*completeTime,*cancelTime;
@property (nonatomic,copy)NSString * is_star;//是否是星标朋友(1:是；2:不是)
@property (nonatomic,copy)NSString * id_card;
@property (nonatomic,copy)NSString * friend_self_name;
@property (nonatomic,copy)NSString * portrait;
@property (nonatomic,copy) NSString *easemobId;//环信ID
@property (nonatomic,copy) NSString *easemobPwd;//环信密码
@property (nonatomic,copy) NSString *capital;//weixinId
@property (nonatomic,copy) NSString *user_id;
@property (nonatomic,copy) NSString *header;
@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,copy) NSString *sex;
@property (nonatomic,copy) NSString *birthday;
@property (nonatomic,copy) NSString *descr;//个性签名
@property (nonatomic,copy) NSString *videoUrl;
@property (nonatomic,copy) NSString *videoImage;
@property (nonatomic,copy) NSString *videoDuration;
@property (nonatomic,copy) NSString *image,*images;
@property (nonatomic,copy) NSString *is_yhjf;//是否阅后即焚(1:是；2:不是)
@property (nonatomic,copy) NSString *focusHeader;
@property (nonatomic,copy) NSString *focusName ,*viewNum;
@property (nonatomic,copy) NSString *remark,*friendRemark;//备注
@property (nonatomic,copy) NSString *target_user_nickname;
//@property (nonatomic,assign) int age;
@property (nonatomic,copy) NSString *sort_num;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *info;
@property (nonatomic,copy) NSString *user_name;
@property (nonatomic,strong) NSDictionary *userInfo;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *group_name;
@property (nonatomic,copy) NSString *administrator_id;//群主id
@property (nonatomic,copy) NSString *number;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *group_type;
@property (nonatomic,copy) NSString *notice;
@property (nonatomic,copy) NSString *ChatUserId;
@property (nonatomic,copy) NSString *ChatToUserNick;
@property (nonatomic,copy) NSString *ChatToUserAvatar;
@property (nonatomic,copy) NSString *group_portrait;
@property (nonatomic,copy) NSString *group_id;//群组id
@property (nonatomic,copy) NSString *is_friend;//是否是好友（1：是，2：不是）
@property (nonatomic,copy) NSString *title;//
@property (nonatomic,copy) NSString *isRead;//
@property (nonatomic,copy) NSString *is_del;// //该用户是否已删除(1:删除；2:不删除)
@property (nonatomic,copy) NSString *itemId;//
@property (nonatomic,copy) NSString *url;//
@property (nonatomic,copy) NSString *is_shield;//是否屏蔽(1:是；2:不是)
@property (nonatomic,copy) NSString *kefuUserId;//
@property (nonatomic,copy) NSString *isDef;//
@property (nonatomic,copy) NSString *fenzu_id;//
@property (nonatomic,copy) NSString *is_administrator;//是否是群主(1:是；2:不是)
@property (nonatomic,copy) NSString *friend_name;//好友昵称
@property (nonatomic,copy) NSString *sort;//
@property (nonatomic,copy) NSString *level;//

@property (nonatomic,copy) NSString *is_top;//是否置顶（1：是，2：不是）
@property (nonatomic,copy) NSString *is_pingbi;//该群是否屏蔽自己
@property (nonatomic,copy) NSString *is_manager;//是否是管理员(1:是，2：不是）
@property (nonatomic,copy) NSString *is_admin;//是否群主(1:是；2:不是)
@property (nonatomic,strong) NSArray *focusList;//该群关注我的用户
@property (nonatomic,copy) NSString *myName;//我在群的昵称
@property (nonatomic,copy) NSString *is_all_banned;//是否全员禁言(1:是；2:不是)
@property (nonatomic,copy) NSString *groupUserSum;//群成员数量
@property (nonatomic,strong) NSDictionary *group;
@property (nonatomic,copy) NSString *group_user_nickname;//
@property (nonatomic,copy) NSString *inv_name;//
@property (nonatomic,strong) NSArray *inviteGradList;//
@property (nonatomic,copy) NSString *is_collect_select;//是否选中
@property (nonatomic,copy) NSString *target_user_id;//
@property (nonatomic,copy) NSString *isOnLine;//是否在线(1:是；2:不是)
@property (nonatomic,copy) NSString *voiceUrl;//
@property (nonatomic,copy) NSString *voiceDuration;//
@property (nonatomic,copy) NSString *imageHeight;//
@property (nonatomic,copy) NSString *time;//
@property (nonatomic,assign) BOOL lastIndex;//
@property (nonatomic,copy) NSString *target_id;//会话id
@property (nonatomic,copy) NSString *chattop_id;//置顶会话id
@property (nonatomic, copy) NSString *onLine;//是否在线(1是 2不是)
@property (nonatomic,copy) NSString *create_time;//
@property (nonatomic,strong) UIImage *iconImage;//
@property (nonatomic,copy) NSString *operatelog_id;//
@property (nonatomic,copy) NSString *device;//
@property (nonatomic,copy) NSString *ipadd;//
@property (nonatomic,copy) NSString *phiz_url;//
@property (nonatomic,copy) NSString *phiz_id;//
@property (nonatomic,copy) NSString *width;//
//@property (nonatomic,assign) BOOL contentExpand;//
//@property (nonatomic,strong) NSDictionary *friendApply;//
@property (nonatomic,copy) NSString *isAdmin;//是否是群主 （0否1是）
@property (nonatomic,strong) NSDictionary *friendApply;//
@property (nonatomic,copy) NSString *categoryName;//
@property (nonatomic,copy) NSString *high;//
@property (nonatomic,copy) NSString *EMReceiveID;//
@property (nonatomic,copy) NSString *EMReceiveNikeName;//
@property (nonatomic,copy) NSString *EMReceivePortrait;//
@property (nonatomic,copy) NSString *EMUserID;//
@property (nonatomic,copy) NSString *EMUserNikeName;
@property (nonatomic,copy) NSString *EMUserPortrait;//
@property (nonatomic,copy) NSString *EMIsFrom;//
@property (nonatomic,copy) NSString *num;//
//@property (nonatomic,strong) NSArray *orderGoods;//
@property (nonatomic,copy) NSString *now_time;//
@property (nonatomic,copy) NSString *jinyan_time_end;//
@property (nonatomic,copy) NSString *jinyan_time_start;//
@property (nonatomic,strong) NSDictionary *Friend;//
@property (nonatomic,strong) NSDictionary *beFriend;//
@property (nonatomic,copy) NSString *receive_user_ids;//
@property (nonatomic,copy) NSString *isLimit;//
@property (nonatomic,copy) NSString *limitNum;//
@property (nonatomic,copy) NSString *firstCommentNum;//
@property (nonatomic,copy) NSString *userHeader;//
@property (nonatomic,copy) NSString *pageIndex2;//
@property (nonatomic,copy) NSString *pageCount;//
@property (nonatomic,copy) NSString *pageIndex;//
@property (nonatomic,copy) NSString *laterLevel2;//
@property (nonatomic,strong) NSArray *beforeFriendApplyList;//
@property (nonatomic,strong) NSArray *friendApplyList;//
//@property (nonatomic,strong) NSArray *projectPrices;//
@property (nonatomic,copy) NSString *friendStatus;//添加好友状态：1.等待对方同意，2.等待你同意3.已添加好友4.未添加5.已过期
@property (nonatomic,copy) NSString *bibiCode;//
@property (nonatomic,copy) NSString *countryCode;//国家代码
@property (nonatomic,copy) NSString *backImage;//
@property (nonatomic,copy) NSString *country;//
@property (nonatomic,copy) NSString *cityName;//
@property (nonatomic,copy) NSString *provinceName;//
@property (nonatomic,copy) NSString *provinceId;//

@property (nonatomic,copy) NSString *province;//
@property (nonatomic,copy) NSString *cityId;//
@property (nonatomic,copy) NSString *isAnnoy;//
@property (nonatomic,copy) NSString *labelName;//
@property (nonatomic,copy) NSString *labelId;//
@property (nonatomic,copy) NSString *city;//
@property (nonatomic,strong) NSMutableArray *provinceList;//
@property (nonatomic,strong) NSMutableArray *cityList;//
@property (nonatomic,copy) NSString *imageWeight;//
@property (nonatomic,copy) NSString *EMReceiveRemark;//
@property (nonatomic,copy) NSString *haveNum;//
@property (nonatomic,copy) NSString *appointUserIds;//
@property (nonatomic,copy) NSString *appointUserNames;//
@property (nonatomic,copy) NSString *blackId;//
@property (nonatomic,copy) NSString *groupEwm;//
@property (nonatomic,copy) NSString *needNum;//
@property (nonatomic,copy) NSString *inviteNum;//
@property (nonatomic,copy) NSString *rewardCredits;//
@property (nonatomic,copy) NSString *exist;//
@property (nonatomic,copy) NSString *isCanLook;//
@property (nonatomic,copy) NSString *isLook;//
@property (nonatomic,copy) NSString *verifyFriend;//
@property (nonatomic,copy) NSString *unVisibleUserIds;//
@property (nonatomic,copy) NSString *unVisibleUserNames;//
@property (nonatomic,copy) NSString *EMReceiveUserId;//
@property (nonatomic,copy) NSString *isBlocked;//
@property (nonatomic,copy) NSString *age;//
@property (nonatomic,copy) NSString *missionIds;//
@property (nonatomic,copy) NSString *applyUserId;//
@property (nonatomic,strong) UIImage *currentImage;//
@property (nonatomic,copy) NSString *replyUserName;//
@property (nonatomic,copy) NSString *coerceUpgrade;//
@property (nonatomic,copy) NSString *coerceVersion;//
@property (nonatomic,copy) NSString *intro;//
@property (nonatomic,copy) NSString *version;//
@property (nonatomic,copy) NSString *downUrl;//
@property (nonatomic,copy) NSString *categoryId;//
@property (nonatomic,copy) NSString *isEffect;//
@property (nonatomic,copy) NSString *missionCategoryId;//
@property (nonatomic,assign) CGFloat flowHeight;//
@property (nonatomic,assign) CGFloat againLoding;//
@property (nonatomic,copy) NSString *sysTime;//
@property (nonatomic,copy) NSString *startTime;//
@property (nonatomic,copy) NSString *areaName;//
@property (nonatomic,copy) NSString *areaId;//
@property (nonatomic,copy) NSString *languageTitle;//
@property (nonatomic,strong) NSMutableArray *kids;//
@property (nonatomic,copy) NSString *iconUrl;//
@property (nonatomic,copy) NSString *languageIconUrl;//
@property (nonatomic,copy) NSString *parentId;//
@property (nonatomic,copy) NSString *goodsGroupPrice;//
@property (nonatomic,copy) NSString *logoUrl;//
@property (nonatomic,strong) NSMutableArray *flowViewArray;//
@property (nonatomic,copy) NSString *isRush;//
@property (nonatomic,copy) NSString *isOneBuy;//
@property (nonatomic,copy) NSString *isGroup;//
@property (nonatomic,copy) NSString *languageLogoUrl;//
@property (nonatomic,copy) NSString *descriptionStr;//
@property (nonatomic,copy) NSString *imgUrl;//
@property (nonatomic,strong) NSMutableArray *descImgList;//
@property (nonatomic,strong) NSMutableArray *bannerList;//
@property (nonatomic,copy) NSString *merchantName;//
@property (nonatomic,copy) NSString *merchantFaceImg;//
@property (nonatomic,copy) NSString *merchantBibiCode;//
@property (nonatomic,copy) NSString *area;//
@property (nonatomic,copy) NSString *isDefault;//
@property (nonatomic,copy) NSString *payMoney;//
@property (nonatomic,copy) NSString *award;//
@property (nonatomic,copy) NSString *userFaceImg;//
@property (nonatomic,copy) NSString *stillNeed;//
@property (nonatomic,copy) NSString *userNum;//

@property (nonatomic,copy) NSString *logistics;//
@property (nonatomic,copy) NSString *goodsId;//
@property (nonatomic,copy) NSString *orderCode;//
@property (nonatomic,copy) NSString *quantity;//
@property (nonatomic,copy) NSString *amount;//
@property (nonatomic,copy) NSString *receiverName;//
@property (nonatomic,copy) NSString *receiverPhone;//
@property (nonatomic,copy) NSString *receiverProvince;//
@property (nonatomic,copy) NSString *receiverCity;//
@property (nonatomic,copy) NSString *receiverArea;//
@property (nonatomic,copy) NSString *receiverAddress;//
@property (nonatomic,strong) NSMutableArray *goodsGroupRecordDetailsList;//
@property (nonatomic,copy) NSString *balance;//
@property (nonatomic,copy) NSString *accountName;//
@property (nonatomic,copy) NSString *accountNumber;//
@property (nonatomic,copy) NSString *paymentId;//
@property (nonatomic,copy) NSString *paymentName;//
@property (nonatomic,copy) NSString *desc;//
@property (nonatomic,copy) NSString *nextLevel;//
@property (nonatomic,copy) NSString *nextLeveLNeedsPay;//
@property (nonatomic,copy) NSString *nextLeveLNeedsInviteUserNum;//
@property (nonatomic,copy) NSString *nextLeveLNeedsCredits;//
@property (nonatomic,copy) NSString *isCreatedGroup;//
@property (nonatomic,copy) NSString *isInvitedUser;//
@property (nonatomic,copy) NSString *isSentVideo;//
@property (nonatomic,copy) NSString *isSigned;//
@property (nonatomic,copy) NSString *directCount;//
@property (nonatomic,copy) NSString *fissionCount;//
@property (nonatomic,copy) NSString *totalCommission;//
@property (nonatomic,copy) NSString *merchantId;//
@property (nonatomic,copy) NSString *linkType;//
@property (nonatomic,copy) NSString *linkUrl;//
@property (nonatomic,copy) NSString *period;//
@property (nonatomic,copy) NSString *awardNum;//
@property (nonatomic,copy) NSString *expireTime;//
@property (nonatomic,copy) NSString *stock;//
@property (nonatomic,copy) NSString *isRebate;//
@property (nonatomic,copy) NSString *rebateMoneyTotal;//
@property (nonatomic,strong) NSDictionary *shopGoodsRebate;//
@property (nonatomic,copy) NSString *rebateCycleMoney;//
@property (nonatomic,copy) NSString *rebateCycleTotal;//
@property (nonatomic,copy) NSString *rebateType;//
@property (nonatomic,strong) NSMutableArray *shopGoodsRebateRecordList;//
@property (nonatomic,copy) NSString *allreadyRebateMoney;//
@property (nonatomic,copy) NSString *allreadyRebateRecord;//
//@property (nonatomic,copy) NSString *rebateCycleMoney;//
@property (nonatomic,copy) NSString *rebateCycleIndex;//
@property (nonatomic,copy) NSString *rebateCycleTime;//
@property (nonatomic,copy) NSString *endTime;//
@property (nonatomic,copy) NSString *income;//
@property (nonatomic,copy) NSString *pendingIncome;//
@property (nonatomic,copy) NSString *isFavorite;//
@property (nonatomic,copy) NSString *periodTime;//
//@property (nonatomic,copy) NSString *lowPrice;//
//@property (nonatomic,copy) NSString *lowPrice;//
//@property (nonatomic,copy) NSString *lowPrice;//
//@property (nonatomic,copy) NSString *lowPrice;//
//@property (nonatomic,copy) NSString *lowPrice;//
//@property (nonatomic,copy) NSString *lowPrice;//
//@property (nonatomic,copy) NSString *lowPrice;//
//@property (nonatomic,copy) NSString *lowPrice;//
//@property (nonatomic,copy) NSString *lowPrice;//
//@property (nonatomic,copy) NSString *lowPrice;//
//@property (nonatomic,copy) NSString *lowPrice;//
//@property (nonatomic,copy) NSString *lowPrice;//
//@property (nonatomic,copy) NSString *lowPrice;//
//@property (nonatomic,copy) NSString *lowPrice;//
//@property (nonatomic,copy) NSString *lowPrice;//
//@property (nonatomic,copy) NSString *lowPrice;//
//@property (nonatomic,copy) NSString *lowPrice;//
//@property (nonatomic,copy) NSString *lowPrice;//
//@property (nonatomic,copy) NSString *lowPrice;//
//@property (nonatomic,copy) NSString *lowPrice;//
//@property (nonatomic,copy) NSString *lowPrice;//
//@property (nonatomic,copy) NSString *lowPrice;//



@property (nonatomic,strong) NSString *memberProtection;
@property (nonatomic,copy) NSString *isPhoneAddFriend;//
@property (nonatomic,copy) NSString *isBiBiCodeAddFriend;//
@property (nonatomic,copy) NSString *isGroupAddFriend;//
@property (nonatomic,copy) NSString *isECodeAddFriend;//
@property (nonatomic,copy) NSString *missionName;//
@property (nonatomic,copy) NSString *missionId;//
@property (nonatomic,copy) NSString *missionIcon;//
@property (nonatomic,copy) NSString *bak;//
@property (nonatomic,copy) NSString *qrCode;//
@property (nonatomic,copy) NSString *firstImage;//
@property (nonatomic,copy) NSString *isShow;//
@property (nonatomic,copy) NSString *supportNum;//
@property (nonatomic,copy) NSString *isReward;//
@property (nonatomic,copy) NSString *signature;//
@property (nonatomic,copy) NSString *isBlack;//
@property (nonatomic,copy) NSString *isFriend;//
//@property (nonatomic,copy) NSString *isPhoneAddFriend;//
@property (nonatomic,copy) NSString *ownerUserId;//
@property (nonatomic,copy) NSString *ownerEasemobId;//
@property (nonatomic,copy) NSString *inviteCode;//
@property (nonatomic,copy) NSString * incomeCredits;
@property (nonatomic,copy) NSString *language;
@property (nonatomic,copy) NSString *skinColor;//
@property (nonatomic,copy) NSString *isApprove;//
@property (nonatomic,copy) NSString *maxAge;//
@property (nonatomic,copy) NSString *minAge;//
@property (nonatomic,strong) NSDictionary *level2Comment;//
@property (nonatomic,copy) NSString *isSupport;//
@property (nonatomic,copy) NSString *rewardName;//
@property (nonatomic,copy) NSString *itemNames;//
@property (nonatomic,copy) NSString *itemIds;//
//@property (nonatomic,copy) NSString *middleCommengtCount;//
@property (nonatomic,copy) NSString *commentNum;//
@property (nonatomic,copy) NSString *location;//
@property (nonatomic,copy) NSString *userIcon,*userRole;
@property (nonatomic,copy) NSString *IsFriend;
@property (nonatomic,copy) NSString *userHeard;
@property (nonatomic,copy) NSString *groupCode;
@property (nonatomic,copy) NSString *groupId;
@property (nonatomic,copy) NSString *isSilent;
@property (nonatomic,copy) NSString *role;
@property (nonatomic,copy) NSString *isEachFriend;

/** 当前积分*/
@property (nonatomic,strong) NSDecimalNumber *credits;
@property (nonatomic,strong) NSDecimalNumber *goodCredits;
/** 商品多图拆分*/
@property (nonatomic,strong) NSMutableArray *tempImagesArr;
/** 品名*/
@property (nonatomic,strong) NSString *tradeName;
/** 保存方式*/
@property (nonatomic,strong) NSString *storeMethod;
/** 产地*/
@property (nonatomic,strong) NSString *productPlace;
@end
