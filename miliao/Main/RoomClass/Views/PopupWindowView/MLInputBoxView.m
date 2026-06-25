//
//  MLInputBoxView.m
//  miliao
//
//  Created by aa on 2019/6/27.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "MLInputBoxView.h"

@implementation MLInputBoxView

- (IBAction)sendClick:(UIButton *)sender {
    ! self.sendSeBlock ?: self.sendSeBlock();
    
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.sendBtn.backgroundColor = BaseMainColor ;
}

@end
