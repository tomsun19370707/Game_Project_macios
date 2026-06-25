//
//  HotTopicTableViewCell.m
//  miliao
//
//  Created by aa on 2019/7/15.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "HotTopicTableViewCell.h"
@interface HotTopicTableViewCell()
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UILabel *talkLabel;
@end
@implementation HotTopicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setFrame:(CGRect)frame
{
    //设置cell之间的间距
    frame.origin.x = 15;//间距
    frame.size.width -= 2 * frame.origin.x;
    //    frame.size.height -= 2 * frame.origin.x;
    
    //设置圆角
    self.layer.cornerRadius = 10.0;
    self.layer.masksToBounds = YES;
    [super setFrame:frame];
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
    }
    return self;
}
- (void)createUI
{
    UIImageView *imageView = [[UIImageView alloc] init];
//    [imageView sd_setImageWithURL:[NSURL URLWithString:@"http://47.92.85.75/upload/dynamic_image\/9c685d32c46bfdaebfe2f35a10f0eff0.jpg"]];
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.equalTo(self.contentView);
    }];
    self.bgImageView = imageView;
    self.talkLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.talkLabel];
    [self.talkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
    self.talkLabel.font = [UIFont systemFontOfSize:14];
    self.talkLabel.textColor = [UIColor whiteColor];
}

-(void)setModel:(TopicModel *)model
{
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.topic_img]];
    self.talkLabel.text = [NSString stringWithFormat:@"%@人参加讨论",model.talk_num];
}
@end
