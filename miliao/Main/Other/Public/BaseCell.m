//
//  BaseCell.m
//  君分时代
//
//  Created by 贠小飞 on 2018/4/10.
//  Copyright © 2018年 贠小飞. All rights reserved.
//

#import "BaseCell.h"

@implementation BaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _uiStyle = [[BaseUIStyle alloc] init];
        
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
//        self.backgroundColor = _uiStyle.bgColor;
        self.contentView.backgroundColor = _uiStyle.tableCellBgColor;
        CGRect rect = CGRectMake(0.0f, self.height - 1, ScreenViewWidth, 1.0f);
        [ControlCreator createView:self rect:rect backguoundColor:_uiStyle.tableSeparatorColor];
        self.parentVC = nil;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

- (void)loadData:(id)obj{
    
}

+ (NSInteger)heightForCell:(id)obj{
    return 44;
}

- (void)dealloc{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}

@end
