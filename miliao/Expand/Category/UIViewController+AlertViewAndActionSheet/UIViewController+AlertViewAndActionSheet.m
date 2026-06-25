//
//  UIViewController+AlertViewAndActionSheet.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/6/1.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "UIViewController+AlertViewAndActionSheet.h"
#import "SPAlertController.h"

static NSMutableArray *fields = nil;

@implementation UIViewController (AlertViewAndActionSheet)

- (void)AlertWithTitle:(NSString *)title
               messageAlignmentLeft:(NSString *)message
             andOthers:(NSArray<NSString *> *)others
              animated:(BOOL)animated
                action:(click)click
{
    SPAlertController *alertController = [SPAlertController alertControllerWithTitle:title message:message preferredStyle:SPAlertControllerStyleAlert];
    alertController.textAlignment = NSTextAlignmentCenter;
    alertController.textTitleAlignment = NSTextAlignmentCenter;
    UIView *subView1 = alertController.view.subviews[0];
    UIView *subView2 = subView1.subviews[0];
    UIView *subView3 = subView2.subviews[0];
    UIView *subView4 = subView3.subviews[0];
    UIView *subView5 = subView4.subviews[0];
    //分别拿到title 和 message 可以分别设置他们的对齐属性
    //    UILabel *titleLabel = subView5.subviews[0];
    if (message.length>0) {
        UILabel *msgeLabel = subView5.subviews[1];
        msgeLabel.textAlignment = NSTextAlignmentLeft;
    }
    [others enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0)
        {
            [alertController addAction:[SPAlertAction actionWithTitle:obj style:SPAlertActionStyleCancel handler:^(SPAlertAction * _Nonnull action) {
                if (action && click)
                {
                    click(idx);
                }
            }]];
        }
        else
        {
            [alertController addAction:[SPAlertAction actionWithTitle:obj style:SPAlertActionStyleDestructive handler:^(SPAlertAction * _Nonnull action) {
                if (action && click)
                {
                    click(idx);
                }
            }]];
        }
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - *****  alert view
- (void)AlertWithTitle:(NSString *)title
               message:(NSString *)message
             andOthers:(NSArray<NSString *> *)others
              animated:(BOOL)animated
                action:(click)click
{
    SPAlertController *alertController = [SPAlertController alertControllerWithTitle:title message:message preferredStyle:SPAlertControllerStyleAlert];
    alertController.textAlignment = NSTextAlignmentCenter;
    alertController.textTitleAlignment = NSTextAlignmentCenter;
    [others enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0)
        {
            [alertController addAction:[SPAlertAction actionWithTitle:obj style:SPAlertActionStyleCancel handler:^(SPAlertAction * _Nonnull action) {
                if (action && click)
                {
                    click(idx);
                }
            }]];
        }
        else {
            [alertController addAction:[SPAlertAction actionWithTitle:obj style:SPAlertActionStyleDefault handler:^(SPAlertAction * _Nonnull action) {
                
                if (action && click)
                {
                    click(idx);
                }
            }]];
        }
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - *****  sheet
- (void)ActionSheetWithTitle:(NSString *)title
                     message:(NSString *)message
                 destructive:(NSString *)destructive
           destructiveAction:(click )destructiveAction
                   andOthers:(NSArray <NSString *> *)others
                    animated:(BOOL )animated
                      action:(click )click
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (destructive)
    {
        [alertController addAction:[UIAlertAction actionWithTitle:destructive style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (action){
                destructiveAction(NO_USE);
            }
        }]];
    }
    
    [others enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0)
        {
            [alertController addAction:[UIAlertAction actionWithTitle:obj style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (action && click)
                {
                    click(idx);
                }
            }]];
        }
        else
        {
            [alertController addAction:[UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (action && click)
                {
                    click(idx);
                }
            }]];
        }
        
    }];
    
    [self presentViewController:alertController animated:animated completion:nil];
    

}


#pragma mark - *****  textField
- (void)AlertWithTitle:(NSString *)title
               message:(NSString *)message
               buttons:(NSArray<NSString *> *)buttons
       textFieldNumber:(NSInteger )number
         configuration:(configuration )configuration
              animated:(BOOL )animated
                action:(clickHaveField )click
{
    if (fields == nil)
    {
        fields = [NSMutableArray array];
    }
    else
    {
        [fields removeAllObjects];
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    // textfield
    for (NSInteger i = 0; i < number; i++)
    {
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            [fields addObject:textField];
            configuration(textField,i);
        }];
    }
    
    // button
    [buttons enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0)
        {
            [alertController addAction:[UIAlertAction actionWithTitle:obj style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (action && click)
                {
                    click(fields,idx);
                }
            }]];
        }
        else
        {
            [alertController addAction:[UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (action && click)
                {
                    click(fields,idx);
                }
            }]];
        }
    }];
    [self presentViewController:alertController animated:animated completion:nil];

}

@end
