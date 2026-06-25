//
//  EMO_FriendsModel.h
//  miliao
//
//  Created by aa on 2019/7/24.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EMO_FriendsModel : NSObject

@property (nonatomic, strong) NSString *friendID;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *nickname;
@property(nonatomic, copy) NSString *uuid;//靓号




@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *ry_uid;
@property (nonatomic, strong) NSString *is_follow;



@end

