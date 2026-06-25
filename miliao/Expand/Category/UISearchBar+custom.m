//
//  UISearchBar+custom.m
//  miliao
//
//  Created by aa on 2019/7/27.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "UISearchBar+custom.h"

@implementation UISearchBar (custom)
- (void)fm_setCancelButtonTitle:(NSString *)title {
   
        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:title];
    
}
- (void)fm_setTextColor:(UIColor *)textColor {
   
        [UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]].textColor = textColor;
   
}
- (void)fm_setTextFont:(UIFont *)font {
    
    [UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]].font = font;
    
}

@end
