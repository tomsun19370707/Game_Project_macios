//
//  CommentInfoModel.h
//  WeChat
//
//  Created by zhengwenming on 2017/9/21.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import "BaseModel.h"

@interface CommentInfoModel : RootModel
@property (nonatomic, assign) BOOL isExpand;

//@property(nonatomic,copy)NSString *commenttype;

@property(nonatomic,copy)NSString *commentId;

@property(nonatomic,copy)NSString *life_id;


@property(nonatomic,copy)NSString *user_id;

@property(nonatomic,copy)NSString *nick_name;

//@property(nonatomic,copy)NSString *commentPhoto;

@property(nonatomic,copy)NSString *comment_text;

@property(nonatomic,copy)NSString *createtime_text;

@property(nonatomic,copy)NSString *createtime;

@property(nonatomic,copy)NSDictionary *user;




@property(nonatomic,copy)NSAttributedString *attributedText;

//@property(nonatomic,copy)NSString *commentByUserId;
//@property(nonatomic,copy)NSString *commentByUserName;
//@property(nonatomic,copy)NSString *commentByPhoto;

@property(nonatomic,copy)NSString *checkStatus;

///评论大图
@property(nonatomic,copy)NSMutableArray *messageBigPicArray;
@property(nonatomic,copy)NSMutableAttributedString *likeUsersAttributedText;

@property(nonatomic,copy)NSMutableArray<CommentInfoModel *> *likeUsersArray;

// 评论数据源
@property (nonatomic,copy) NSMutableArray *commentModelArray;

@property (nonatomic, assign)CGFloat rowHeight;

-(instancetype)initWithDic:(NSDictionary *)dic;
@end
