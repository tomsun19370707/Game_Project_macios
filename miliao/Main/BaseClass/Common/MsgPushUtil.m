//
//  MsgPushUtil.m
//  enjoyfun
//
//  Created by 李东阳 on 2020/4/16.
//  Copyright © 2020 锤子科技. All rights reserved.
//

#import "MsgPushUtil.h"

@implementation MsgPushUtil
/**
 消息推送跳转
 平台推送消息：
1.纯文字内容（无跳转）
2.文字+商品（跳转商品详情）

用户版
福利卡券红包：
3.预约福利提前30分钟提醒
4任务福利成功提醒 （是否需要每次有人通过福利注册都提醒？）
5.任务福利已参与（时间到期提醒 任务未达标状态）
6.卡券核销提醒
7.卡券到期提醒
8.分享链接被有效点击提醒
9.参与的红包活动 时间到期提醒

补贴：
10.用户提交补贴申请后，有商家接受申请
11．用户上传补贴资料后，商家同意补贴
12.用户上传补贴资料后，商家拒绝补贴
13.后台已发放补贴金额至用户账户，待用户评价提醒

评价回复类提醒：
14.补贴评论被回复提醒
15.福利评论被回复提醒
16.红包评论被回复提醒
17.用户发布的朋友圈被评论提醒
18.朋友圈评论被回复提醒
19.商品评价被商家回复提醒

周边朋友圈：
20．用户发布的周边朋友圈审核通过提醒
21. 用户发布的周边朋友圈审核被驳回提醒

订单消息：
22.，您有新的订单已发货，请及时确认收货
23.您的xxx订单未支付，订单已取消（未支付30分钟自动取消）
24.您的xxx订单已确认收货，请及时进行评价
25.您的xxx订单商家已备货完成，请及时上门提货（自提订单）
26.您的xxx退款订单已退款成功，请点击查看
27. 您的xxx退款订单已退款失败，请点击查看


商家版：
28.用户通过任务福利领取卡券提醒
29.用户抢购福利领取卡券提醒
30.领取卡券提醒
31.红包有人参与提醒
32.红包有效点击提醒
33.红包到期提醒

补贴：
34.您收到一条新的补贴申请，请点击查看
35.您有一条待确认补贴订单，请点击查看用户上传的补贴资料
36.您有一条补贴订单，用户已评价完成，请点击查看

商品订单：
37.您有一条待发货订单，请及时查看
38.您有一条订单需要备货，请及时查看
39.您有一条订单，用户申请了退款，请及时处理
40.您有一条订单，用户已评价完成，请点击查看
41.您有一条订单，用户已取消，请点击查看
 
提现：
 42.用户申请提现成功  跳转钱包
 43.用户申请提现失败  跳转钱包
 
 44.您上传的卡券已审核通过，请点击查看
 45.您上传的卡券审核被驳回，请点击查看
 46.您上传的红包已审核通过，请点击查看
 47.您上传的红包审核被驳回，请点击查看
 48.抽奖次数获取通知
*/
/** 消息推送跳转*/
+ (void)messagePush:(NSDictionary *)userInfo
{
    NSString *type = userInfo[@"pushType"];
    int pushType = type.intValue ;
    NSString *itemId = userInfo[@"itemId"];
    NSString *url = userInfo[@"url"];
    
//    if (pushType == 2 || pushType == 19) {
//        /** 商品详情*/
//        EFGoodVc *good = [[EFGoodVc alloc]init];
//        good.goodId = itemId ;
//        [[ObjectTool SharedSettings].currentVC.navigationController pushViewController:good animated:YES];
//    }else if (pushType == 3 || pushType == 4 || pushType == 5 ) {
//        /** 福利详情*/
//        EFFreeBenefitsDetailVC *good = [[EFFreeBenefitsDetailVC alloc]init];
//        good.ids = itemId ;
//        [[ObjectTool SharedSettings].currentVC.navigationController pushViewController:good animated:YES];
//    }else if (pushType == 6 || pushType == 7  ) {
//        /** 用户版卡券详情*/
//        EFCouponDetailVc *good = [[EFCouponDetailVc alloc]init];
//        good.ids = itemId ;
//        good.type = EFCouponDetailVcUserCard ;
//        [[ObjectTool SharedSettings].currentVC.navigationController pushViewController:good animated:YES];
//    }else if (pushType == 8 || pushType == 9  || pushType == 31 || pushType == 32 || pushType == 33 || pushType == 46 || pushType == 47) {
//        if (![DUserClient isLogin]) {
//            [DUserClient askToLoginVc];
//            return;
//        }
//
//        /** 红包详情*/
//        EFProfitDetailVC *good = [[EFProfitDetailVC alloc]init];
//        good.ids = itemId ;
//        [[ObjectTool SharedSettings].currentVC.navigationController pushViewController:good animated:YES];
//    }else if (pushType == 10 || pushType == 11 || pushType == 12 || pushType == 13) {
//        /** 补贴详情*/
//        EFAllowanceDetailVc *good = [[EFAllowanceDetailVc alloc]init];
//        good.orderId = itemId ;
//        [[ObjectTool SharedSettings].currentVC.navigationController pushViewController:good animated:YES];
//    }else if (pushType == 14 || pushType == 15 || pushType == 16 || pushType == 18  ) {
//        /** 评论详情*/
//        EFCommentDetailVc *good = [[EFCommentDetailVc alloc]init];
//        good.commentId = itemId ;
//        [[ObjectTool SharedSettings].currentVC.navigationController pushViewController:good animated:YES];
//    }else if (pushType == 17  || pushType == 20 || pushType == 21 ) {
//        /** 朋友圈详情*/
//        /** 先获取详情，判断是图文还是视频*/
//        /** para*/
//        NSMutableDictionary *parameter =[NSMutableDictionary dictionary];
//        parameter[@"id"] = itemId;
//        if ([DUserClient isLogin]) {
//            parameter[@"userId"] = [DUserClient userID];
//        }
//        [EFHomeHandle requestNearByDetail:parameter success:^(OrderInfoLook *order,NSMutableArray *lunStrAry) {
//            if (order.data.homeType == 2 || order.data.videoUrl.length > 10){
//                /** 视频*/
//                EFNearByVideoVc *good = [[EFNearByVideoVc alloc]init];
//                good.nearById = itemId;
//                [[ObjectTool SharedSettings].currentVC.navigationController pushViewController:good animated:YES];
//            }else{
//                EFNearByContentVc *good = [[EFNearByContentVc alloc]init];
//                good.nearById = itemId;
//                [[ObjectTool SharedSettings].currentVC.navigationController pushViewController:good animated:YES];
//            }
//        } failure:^{
//
//        }];
//
//    }else if (pushType == 28 || pushType == 29 || pushType == 30 || pushType == 44 || pushType == 45 ) {
//        /** 商家版卡券领取详情*/
//        NSString *shopId = [DUserClient shopId];
//        if (shopId) {
//            EFCardDetailVC *good = [[EFCardDetailVC alloc]init];
//            good.orderId = itemId ;
//            good.shopId = shopId ;
//            [[ObjectTool SharedSettings].currentVC.navigationController pushViewController:good animated:YES];
//        }
//    }else if (pushType == 22 || pushType == 23  || pushType == 24 || pushType == 25) {
//        /** 普通订单详情*/
//        EFOrderDetailVc *good = [[EFOrderDetailVc alloc]init];
//        good.orderId = itemId ;
//        [[ObjectTool SharedSettings].currentVC.navigationController pushViewController:good animated:YES];
//    }else if (pushType == 26 || pushType == 27) {
//        /** 退款订单详情*/
//        EFReturnOrderDetailVc *good = [[EFReturnOrderDetailVc alloc]init];
//        good.orderId = itemId ;
//        [[ObjectTool SharedSettings].currentVC.navigationController pushViewController:good animated:YES];
//    }else if (pushType == 34 || pushType == 35 || pushType == 36  ) {
//        /** 商家版补贴详情*/
//        NSString *shopId = [DUserClient shopId];
//        if (shopId) {
//            EFSubsidyManageDetailVC *good = [[EFSubsidyManageDetailVC alloc]init];
//            AllowData *model = [[AllowData alloc]init];
//            model.ID = itemId ;
//            good.orderId = model.ID ;
//            good.shopId = shopId ;
//            [[ObjectTool SharedSettings].currentVC.navigationController pushViewController:good animated:YES];
//        }
//    }else if (pushType == 37 || pushType == 38 || pushType == 40 || pushType == 41) {
//        /** 商家版订单详情*/
//        EFOrderDetailVc *detail = [[EFOrderDetailVc alloc]init];
//        detail.type = EFOrderDetailVcTypeMerchant ;
//        detail.orderId = itemId;
//        [[ObjectTool SharedSettings].currentVC.navigationController pushViewController:detail animated:YES];
//    }else if (pushType == 39) {
//        /** 商家版退款订单详情*/
//        EFReturnOrderDetailVc *or = [[EFReturnOrderDetailVc alloc]init];
//        or.type = EFReturnOrderDetailVcTypeMerchant ;
//        or.orderId = itemId;
//        [[ObjectTool SharedSettings].currentVC.navigationController pushViewController:or animated:YES];
//    }else if (pushType == 42 || pushType == 43) {
//        /** 钱包*/
//        NSString *shopId = [DUserClient shopId];
//        if (shopId) {
//            EFWalletVc *or = [[EFWalletVc alloc]init];
//            or.type = EFWalletVcTypeShop ;
//            or.shopId = shopId;
//            [[ObjectTool SharedSettings].currentVC.navigationController pushViewController:or animated:YES];
//        }
//
//    }else if (pushType == 48) {
//        /** 抽奖页面*/
//        HGLDrawAlotteryViewController *or = [[HGLDrawAlotteryViewController alloc]init];
//        [[ObjectTool SharedSettings].currentVC.navigationController pushViewController:or animated:YES];
//
//    }
    
}

/** 远程推送，点击系统消息弹框后，消息跳转*/
+ (void)remoteNotificationMessagePush:(NSDictionary *)userInfo
{
    NSString *type = userInfo[@"pushType"];
    if (!type) {
        type = userInfo[@"type"];
    }
    NSString *cusId = userInfo[@"itemId"];
    if (!cusId) {
        cusId = userInfo[@"id"];
    }
    NSString *url = userInfo[@"url"];
    /** 消息详情，跳转id*/
    NSString *initiativeId = userInfo[@"initiativeId"];
    
    /** skip*/
    /** para*/
    NSMutableDictionary *parameter =[NSMutableDictionary dictionary];
    parameter[@"pushType"] = FORMAT(type);
    parameter[@"itemId"] = FORMAT(cusId);
    if (url.length > 0) {
        parameter[@"url"] = url ;
    }
    if (initiativeId.intValue > 0) {
        parameter[@"initiativeId"] = FORMAT(initiativeId);
    }
    [MsgPushUtil messagePush:parameter];
}
@end

