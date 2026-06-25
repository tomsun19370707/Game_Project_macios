//
//  DPlaceholder.h
//  MXRobot
//
//  Created by Dylan on 2025/8/4.
//

#import <UIKit/UIKit.h>

@interface DPlaceholder : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tip;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
/** 加载占位图*/
+ (DPlaceholder *)loadPlaceholder;
/** 附加到的列表 ,可选*/
@property (nonatomic,strong) UIScrollView *delegate;
@end


/**
 
 -(DPlaceholder *)place
 {
     if (!_place) {
         _place = [DPlaceholder loadPlaceholder];
         _place.delegate = self.listTableview;
     }
     return _place;
 }
 
 */
