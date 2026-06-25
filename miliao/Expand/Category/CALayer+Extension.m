//
//  CALayer+Extension.m
//  miliao
//
//  Created by aa on 2019/5/28.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "CALayer+Extension.h"



@implementation CALayer (Extension)



- (void)setBorderColorFromUIColor:(UIColor *)color {
    
    self.borderColor = color.CGColor;
    
}
@end
