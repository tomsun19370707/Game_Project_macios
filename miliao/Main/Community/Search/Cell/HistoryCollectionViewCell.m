//
//  HistoryCollectionViewCell.m
//  miliao
//
//  Created by aa on 2019/8/7.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "HistoryCollectionViewCell.h"

@implementation HistoryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.tagLabel = [[EdgeInsetsLabel alloc] init];
        self.tagLabel.textAlignment = NSTextAlignmentCenter;
        self.tagLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 14];
        self.tagLabel.textColor = mainQianColor;
        self.tagLabel.backgroundColor = MHColorFromHexString(@"#F1F1F1");
        [self.contentView addSubview:self.tagLabel];
        self.tagLabel.contentInset = UIEdgeInsetsMake(2, 4, 2, 4);
        self.tagLabel.layer.cornerRadius = 8;
        self.tagLabel.clipsToBounds = YES;
        [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

-(void)setModel:(SearchModel *)model
{
    _model = model;
    self.tagLabel.text = model.search;
}
@end
