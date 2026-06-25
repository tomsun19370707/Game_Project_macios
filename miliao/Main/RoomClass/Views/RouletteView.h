//
//  RouletteView.h
//  NTRoulette
//
//  Created by 孙勇 on 2020/3/28.
//  Copyright © 2020 yy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RouletteViewDelegate <NSObject>

@optional
- (void)turnTableViewDidFinishWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface RouletteView : UIView

@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) UIImageView *rotateWheel;
@property (strong, nonatomic) NSArray *numberArray;
@property (assign, nonatomic) NSInteger numberIndex;
@property (assign, nonatomic) id<RouletteViewDelegate> delegate;
-(void)giftArray:(NSArray *)giftArray;
@end

NS_ASSUME_NONNULL_END
