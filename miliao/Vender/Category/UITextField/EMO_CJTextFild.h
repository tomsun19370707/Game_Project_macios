//
//  EMO_CJTextFild.h
//  miliao
//
//  Created by jkkj on 2023/11/10.
//  Copyright © 2023 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EMO_CJTextFild;
@protocol CJTextFieldDeleteDelegate <NSObject>

- (void)cjTextFieldDeleteBackward:(EMO_CJTextFild *)textField;

@end
NS_ASSUME_NONNULL_BEGIN

@interface EMO_CJTextFild : UITextField

@property (nonatomic,weak)id <CJTextFieldDeleteDelegate>cj_delegate;
@end

NS_ASSUME_NONNULL_END
