//
//  ZFTableViewCellLayout.m
//  ZFPlayer
//
//  Created by 紫枫 on 2018/5/22.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import "ZFTableViewCellLayout.h"
#import "NSString+Size.h"

@interface ZFTableViewCellLayout ()

@property (nonatomic, assign) CGRect headerRect;
@property (nonatomic, assign) CGRect nickNameRect;
@property (nonatomic, assign) CGRect timeRect;
@property (nonatomic, assign) CGRect ageRect;
@property (nonatomic, assign) CGRect videoRect;
@property (nonatomic, assign) CGRect playBtnRect;
@property (nonatomic, assign) CGRect titleLabelRect;
@property (nonatomic, assign) CGRect maskViewRect;
@property (nonatomic, assign) BOOL isVerticalVideo;
@property (nonatomic, assign) CGFloat height;

@end

@implementation ZFTableViewCellLayout

- (instancetype)initWithData:(ZFTableData *)data {
    self = [super init];
    if (self) {
        _data = data;
        
        CGFloat min_x = 0;
        CGFloat min_y = 0;
        CGFloat min_w = 0;
        CGFloat min_h = 0;
        CGFloat min_view_w = [UIScreen mainScreen].bounds.size.width-KAdaptedWidth(28);
        CGFloat margin = 10;
        
        min_x = 10;
        min_y = 10;
        min_w = KAdaptedHeight(60);
        min_h = min_w;
        self.headerRect = CGRectMake(min_x, min_y, min_w, min_h);
        
        min_x = CGRectGetMaxX(self.headerRect) + 10;
        min_y = 10;
        min_w = [[Common isNull:data.user[@"nickname"]] textSizeWithFont:KFontBold(15) limitWidth:min_view_w-2*margin-min_x].width;
        min_h = KAdaptedHeight(30);
        self.nickNameRect = CGRectMake(min_x, min_y, min_w, min_h);
        
        min_x = CGRectGetMaxX(self.nickNameRect) + 10;
        min_y = 10+KAdaptedHeight(7);
        min_w = KAdaptedWidth(50);
        min_h = KAdaptedHeight(16);
        self.ageRect = CGRectMake(min_x, min_y, min_w, min_h);
        
    
        
        min_x = CGRectGetMaxX(self.headerRect) + 10;
        min_y = 10+KAdaptedHeight(30);
        min_w = KAdaptedWidth(150);
        min_h = KAdaptedHeight(30);
        self.timeRect = CGRectMake(min_x, min_y, min_w, min_h);
        
        
        
        min_x = 10;
        min_y = CGRectGetMaxY(self.headerRect) + margin;
        min_w = min_view_w - 2*margin;
        min_h = [data.text textSizeWithFont:KFont(14) numberOfLines:0 constrainedWidth:min_w].height;
        self.titleLabelRect = CGRectMake(min_x, min_y, min_w, min_h);
        
        min_x = 10;
        min_y = CGRectGetMaxY(self.titleLabelRect)+margin;
//        min_w = min_view_w- 2*margin;
        min_w = KAdaptedWidth(210);
//        min_h = self.videoHeight;
        min_h = KAdaptedHeight(255);
        self.videoRect = CGRectMake(min_x, min_y, min_w, min_h);
        
        min_w = 44;
        min_h = min_w;
        min_x = (CGRectGetWidth(self.videoRect)-min_w)/2;
        min_y = (CGRectGetHeight(self.videoRect)-min_h)/2;
        self.playBtnRect = CGRectMake(min_x, min_y, min_w, min_h);
        
//        min_x = margin;
//        min_y = CGRectGetMaxY(self.videoRect) + margin;
//        min_w = CGRectGetWidth(self.videoRect) - 2*margin;
//        min_h = [data.title textSizeWithFont:[UIFont systemFontOfSize:15] numberOfLines:0 constrainedWidth:min_w].height;
//        self.titleLabelRect = CGRectMake(min_x, min_y, min_w, min_h);
        
//        self.height = CGRectGetMaxY(self.titleLabelRect)+margin;
        
        self.height = CGRectGetMaxY(self.videoRect)+margin;
        
        min_x = 0;
        min_y = 0;
        min_w = min_view_w;
        min_h = self.height;
        self.maskViewRect = CGRectMake(min_x, min_y, min_w, min_h);
        
    }
    return self;
}

- (instancetype)initWXData:(ZFTableData *)data {
    if (self) {
        _data = data;
        CGFloat min_x = 0;
        CGFloat min_y = 0;
        CGFloat min_w = 0;
        CGFloat min_h = 0;
        CGFloat min_view_w = [UIScreen mainScreen].bounds.size.width;
        CGFloat margin = 10;
        
        min_x = 10;
        min_y = 10;
        min_w = KAdaptedHeight(60);
        min_h = min_w;
        self.headerRect = CGRectMake(min_x, min_y, min_w, min_h);
        
        min_x = CGRectGetMaxX(self.headerRect) + 10;
        min_y = 10;
        min_w = [data.user[@"nickname"] textSizeWithFont:KFontBold(15) limitWidth:min_view_w-2*margin-min_x].width;
        min_h = KAdaptedHeight(30);
        self.nickNameRect = CGRectMake(min_x, min_y, min_w, min_h);
        
        min_x = CGRectGetMaxX(self.nickNameRect) + 10;
        min_y = 10;
        min_w = KAdaptedWidth(50);
        min_h = KAdaptedHeight(20);
        self.ageRect = CGRectMake(min_x, min_y, min_w, min_h);
        
    
        
        min_x = CGRectGetMaxX(self.headerRect) + 10;
        min_y = 10+KAdaptedHeight(30);
        min_w = KAdaptedWidth(150);
        min_h = KAdaptedHeight(30);
        self.timeRect = CGRectMake(min_x, min_y, min_w, min_h);
        
        
        
        
        min_x = 20;
        min_y = CGRectGetMaxY(self.headerRect)+margin;
        min_w = KAdaptedWidth(210);
        min_h = KAdaptedHeight(255);
        self.videoRect = CGRectMake(min_x, min_y, min_w, min_h);
        
        min_w = 44;
        min_h = min_w;
        min_x = (CGRectGetWidth(self.videoRect)-min_w)/2;
        min_y = (CGRectGetHeight(self.videoRect)-min_h)/2;
        self.playBtnRect = CGRectMake(min_x, min_y, min_w, min_h);
        
        min_x = margin;
        min_y = CGRectGetMaxY(self.videoRect) + margin;
        min_w = min_view_w - 2*margin;
        min_h = [data.text textSizeWithFont:[UIFont systemFontOfSize:15] numberOfLines:0 constrainedWidth:min_w].height;
        self.titleLabelRect = CGRectMake(min_x, min_y, min_w, min_h);
        
        self.height = CGRectGetMaxY(self.titleLabelRect)+margin;
        
        min_x = 0;
        min_y = 0;
        min_w = min_view_w;
        min_h = self.height;
        self.maskViewRect = CGRectMake(min_x, min_y, min_w, min_h);
        
    }
    return self;
}

- (BOOL)isVerticalVideo {
    return _data.video_width < _data.video_height;
}

- (CGFloat)videoHeight {
    CGFloat videoHeight;
    if (self.isVerticalVideo) {
        videoHeight = [UIScreen mainScreen].bounds.size.width * 0.6 * self.data.video_height/self.data.video_width;
    } else {
        videoHeight = [UIScreen mainScreen].bounds.size.width * self.data.video_height/self.data.video_width;
    }
    return videoHeight;
}

@end
