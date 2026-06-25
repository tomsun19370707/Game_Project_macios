//
//  CFMChatRoomSkipManager.m
//  miliao
//
//  Created by Dylan Lee on 2026/1/9.
//  Copyright © 2026 EMO. All rights reserved.
//

#import "CFMChatRoomSkipManager.h"

@implementation CFMChatRoomSkipManager
static  dispatch_once_t  oneToken;
static  CFMChatRoomSkipManager *set = nil;

+ (CFMChatRoomSkipManager *)shared
{
    dispatch_once(&oneToken, ^{
        set = [[CFMChatRoomSkipManager alloc]init];
    });
    return set;
}
- (RoomPasswordView *)passWordView{
    if (!_passWordView) {
        _passWordView = [[RoomPasswordView alloc] initWithFrame:CGRectMake(0, 0, ScreenViewWidth, ScreenViewHeight)];
    }
    return _passWordView;
}

/** 点击房间的判断逻辑*/
-(void)getRoomInfo:(NSDictionary *)roomInfo
{
    NSDictionary *dic = roomInfo ;

    if([dic[@"status"] integerValue]==0){
        if([[UserManager userInfo].user_id integerValue]==[dic[@"uid"] integerValue]){
//            EMO_StartPlayViewController*vc=[EMO_StartPlayViewController new];
//            vc.dicData = [NSMutableDictionary dictionaryWithDictionary:dic];
//            [Dn_NAVPUSH pushViewController:vc animated:YES];
            
            /** 2026-01-24 不在进入准备开播页面*/
            if([dic[@"type"] integerValue]==0){
                [self getIntoTheRoom:dic passWord:@""];
            }else{
                if([[UserManager userInfo].user_id integerValue]==[dic[@"uid"] integerValue]){
                    [self getIntoTheRoom:dic passWord:@""];
                }else{
                    [[UIApplication sharedApplication].delegate.window addSubview:self.passWordView];
                    [self.passWordView setDicModel:dic];
                    WeakSelf;
                    self.passWordView.sendDicSeBlock = ^(NSDictionary *model, NSString *text) {
                        [wself getIntoTheRoom:model passWord:text];
                    };
                }
            }
            
            
        }else{
            EMO_EndPlayViewController*vc=[EMO_EndPlayViewController new];
            vc.dicData = [NSMutableDictionary dictionaryWithDictionary:dic];
            [Dn_NAVPUSH pushViewController:vc animated:YES];
        }
        
    }else if ([dic[@"status"] integerValue]==1){
        NSLog(@"禁播");
        [SVProgressHUD showImage:KGetImage(@"") status:@"该房间已被禁播"];
    }else{
        if([dic[@"type"] integerValue]==0){
            [self getIntoTheRoom:dic passWord:@""];
        }else{
            if([[UserManager userInfo].user_id integerValue]==[dic[@"uid"] integerValue]){
                [self getIntoTheRoom:dic passWord:@""];
            }else{
                [[UIApplication sharedApplication].delegate.window addSubview:self.passWordView];
                [self.passWordView setDicModel:dic];
                WeakSelf;
                self.passWordView.sendDicSeBlock = ^(NSDictionary *model, NSString *text) {
                    [wself getIntoTheRoom:model passWord:text];
                };
            }
        }
      
    }
    
    
//    [NetworkRequest POST:Request_GetRoomInfo parmeters:@{@"room_id":roomInfo[@"id"]} success:^(id responObject) {
//        
//        BaseModel *basemodel=(BaseModel *)responObject;
//        NSDictionary *dic=basemodel.data[@"room_info"];
//
//        if([dic[@"status"] integerValue]==0){
//            if([[UserManager userInfo].user_id integerValue]==[dic[@"uid"] integerValue]){
//                EMO_StartPlayViewController*vc=[EMO_StartPlayViewController new];
//                vc.dicData = [NSMutableDictionary dictionaryWithDictionary:dic];
//                [Dn_NAVPUSH pushViewController:vc animated:YES];
//            }else{
//                EMO_EndPlayViewController*vc=[EMO_EndPlayViewController new];
//                vc.dicData = [NSMutableDictionary dictionaryWithDictionary:dic];
//                [Dn_NAVPUSH pushViewController:vc animated:YES];
//                
//            }
//            
//        }else if ([dic[@"status"] integerValue]==1){
//            NSLog(@"禁播");
//            [SVProgressHUD showImage:KGetImage(@"") status:@"该房间已被禁播"];
//        }else{
//            if([dic[@"type"] integerValue]==0){
//                [self getIntoTheRoom:dic passWord:@""];
//            }else{
//                if([[UserManager userInfo].user_id integerValue]==[dic[@"uid"] integerValue]){
//                    [self getIntoTheRoom:dic passWord:@""];
//                }else{
//                    [[UIApplication sharedApplication].delegate.window addSubview:self.passWordView];
//                    [self.passWordView setDicModel:dic];
//                    WeakSelf;
//                    self.passWordView.sendDicSeBlock = ^(NSDictionary *model, NSString *text) {
//                        [wself getIntoTheRoom:model passWord:text];
//                    };
//                }
//            }
//          
//        }
//        
//    } failture:^(NSError *error) {
//        
//    }];
}


#pragma  mark 进入房间前获取RTCtoken

-(void)getIntoTheRoom:(NSDictionary *)dic passWord:(NSString *)passWord{
    WeakSelf;
    
    [NetworkRequest POST:Request_Get_rtc_token parmeters:@{@"room_id":dic[@"id"]} success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        UserDefaultsSave(basemodel.data,@"ShengWangRTCToken");
        [wself getRoomInformationWithModel:dic passWord:passWord];
        
    } failture:^(NSError *error) {
        
    }];
    
    
}


#pragma mark 进入房间
- (void)getRoomInformationWithModel:(NSDictionary *)model passWord:(NSString *)passWord{
    WeakSelf;
    [NetworkRequest POST:Request_EnterRoom parmeters:passWord.length<1?@{@"room_id":model[@"id"]}:@{@"room_id":model[@"id"],@"password":passWord} success:^(id responObject) {
        BaseModel *basemolde=(BaseModel *)responObject;
        if(basemolde.code==1){
            EMO_MLRoomNewVC *vc=[EMO_MLRoomNewVC new];
            MLRoomInformationModel *mode=[MLRoomInformationModel mj_objectWithKeyValues:basemolde.data[@"room_info"]];
            mode.microphone_position=basemolde.data[@"microphone_position"];
            NSDictionary *userDic=[NSDictionary dictionary];
            userDic=basemolde.data[@"userinfo"];
            mode.userinfo=userDic;
            mode.is_muted=[userDic[@"is_muted"] boolValue];
            mode.user_type=[Common isNullNumber:userDic[@"type"]];
                MLRoomInformationModel *model1 = [MLRoomInformationModel currentAccount];
            [model1 mj_setKeyValues:mode];
            
            [Dn_NAVPUSH pushViewController:vc animated:YES];
        }else{
            [[UIApplication sharedApplication].delegate.window addSubview:self.passWordView];
            [self.passWordView setDicModel:model];
            WeakSelf;
            self.passWordView.sendDicSeBlock = ^(NSDictionary *model, NSString *text) {
                [wself getIntoTheRoom:model passWord:text];
            };
        }

    } failture:^(NSError *error) {
        
    }];

}
@end
