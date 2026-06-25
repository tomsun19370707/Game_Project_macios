//
//  SearchHistoryHeaderView.m
//  miliao
//
//  Created by aa on 2019/8/7.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "SearchHistoryHeaderView.h"
@interface SearchHistoryHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeftLeading;

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIButton *delete;

@end
@implementation SearchHistoryHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)deleteHistoryClick:(id)sender {
     !self.deleteHistoryBlock ?: self.deleteHistoryBlock();
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    self.titlelabel.text = title;
    if ([title isEqualToString:@"历史搜索"]) {
        self.icon.hidden = YES;
        self.titleLeftLeading.constant = 15;
        self.titlelabel.textColor = mainViceColor;
        self.delete.hidden = NO;
    }
    else
    {
        self.titlelabel.textColor = MHColorFromHexString(@"#EE3535");
        self.delete.hidden = YES;
        self.icon.hidden = NO;
        self.titleLeftLeading.constant = 35;
    }
}
@end
