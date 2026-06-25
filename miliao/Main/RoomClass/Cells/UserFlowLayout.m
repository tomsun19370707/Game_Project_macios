//
//  UserFlowLayout.m
//  miliao
//
//  Created by TonyStark on 2020/3/16.
//  Copyright © 2020 miliao. All rights reserved.
//

#import "UserFlowLayout.h"

@implementation UserFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];

    if (attributes.count <= 0) return attributes;


    CGFloat firstCellOriginX = ((UICollectionViewLayoutAttributes *)attributes[0]).frame.origin.x;
CGFloat firstCellOriginY = ((UICollectionViewLayoutAttributes *)attributes[0]).frame.origin.y;
    
    for(int i = 1; i < attributes.count; i++) {

 UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
UICollectionViewLayoutAttributes *prevLayoutAttributes = attributes[i - 1];

// ========横向间距设置
       
        if (currentLayoutAttributes.frame.origin.x == firstCellOriginX) { // The first cell of a new row
            continue;
        }
        CGFloat prevOriginMaxX = CGRectGetMaxX(prevLayoutAttributes.frame);
        if ((currentLayoutAttributes.frame.origin.x - prevOriginMaxX) > self.maxCellSpacing) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = prevOriginMaxX + self.maxCellSpacing;
            currentLayoutAttributes.frame = frame;
        }


//====== 纵向间距设置
        
        if (currentLayoutAttributes.frame.origin.y == firstCellOriginY) { // The first cell of a new row
            continue;
        }
        CGFloat prevOriginMaxY = CGRectGetMaxY(prevLayoutAttributes.frame);
        if ((currentLayoutAttributes.frame.origin.y - prevOriginMaxY) > self.maxCellSpacing) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.y = prevOriginMaxY + self.maxCellSpacing;
            currentLayoutAttributes.frame = frame;
        }

    }
    return attributes;
}

@end
