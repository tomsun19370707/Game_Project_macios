//
//  YMMineFunctionVieCollect.h
//  YunMarket
//
//  Created by 李东阳 on 2021/3/17.
//

#import <UIKit/UIKit.h>

@interface YMMineFunctionVieCollect : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *lab;
@property (weak, nonatomic) IBOutlet UILabel *num;

/** 设置角标数量*/
@property (nonatomic,strong) NSString *numStr;
@end
