//
//  EMO_PersonalSkillCell.h
//  miliao
//
//  Created by ZhangShiHao on 2023/6/26.
//  Copyright © 2023 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EMO_PersonalSkillCell : UITableViewCell

-(void)cellDicData:(NSDictionary *)dicData andIndex:(NSIndexPath *)indexPath;

Assign BOOL play;

Copy void(^PlayVoiceBlock)(NSDictionary *dic,BOOL playStatus,NSIndexPath *index);


@end

NS_ASSUME_NONNULL_END
