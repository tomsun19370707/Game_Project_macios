//
//  YJT_CommentModel.m
//  MeetHer
//
//  Created by 张世浩 on 2023/2/17.
//

#import "YJT_CommentModel.h"

@implementation YJT_CommentModel



- (CGFloat)height {
    
    if (_height == 0) {
        
        CGSize size = [self.content boundingRectWithSize:CGSizeMake(kWidth - 75, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KFont(14)} context:nil].size;
        
        _height = size.height + 55.f + self.commentHeight;
        
        if (self.commentArray.count > 3) _height += 25;
    }
    return _height;
}

- (CGFloat)commentHeight {
    
    if (_commentHeight == 0) {
        
        CGFloat rowHeight = 0;
        for (int i = 0; i < self.commentArray.count; i ++) {
            
             if (i == 3) break;
            
            CGSize size = [self.commentArray[i] boundingRectWithSize:CGSizeMake(kWidth - 80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KFont(14)} context:nil].size;
            
            rowHeight = rowHeight + size.height + 10.f;
        }
        
        _commentHeight = rowHeight;
    }
    return _commentHeight;
}

@end




