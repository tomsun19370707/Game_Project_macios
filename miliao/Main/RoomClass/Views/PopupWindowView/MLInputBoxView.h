//
//  MLInputBoxView.h
//  miliao
//
//  Created by aa on 2019/6/27.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "BaseView.h"

@interface MLInputBoxView : BaseView


@property (nonatomic , copy) void(^sendSeBlock)(void);

@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UILabel *beiJingLB;

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;


@end
