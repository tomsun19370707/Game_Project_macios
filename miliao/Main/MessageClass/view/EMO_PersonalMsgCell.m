//
//  EMO_PersonalMsgCell.m
//  miliao
//
//  Created by ZhangShiHao on 2023/6/26.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_PersonalMsgCell.h"

@interface EMO_PersonalMsgCell()

Strong UIView *bgView;
Strong UIImageView *headImgView;
Strong UILabel *nameLabel;
Strong UIButton *typeBtn;
Strong UIButton *hotBtn;


@end

@implementation EMO_PersonalMsgCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        
    }
    return self;
}

@end
