//
//  MLUserReporTypeCell.m
//  miliao
//
//  Created by feifei on 2019/8/5.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "MLUserReporTypeCell.h"

#import "MLUserReportModel.h"

@interface MLUserReporTypeCell ()
@property (nonatomic, strong) UIView            *bgView;
@property (nonatomic, strong) UIImageView       *is_check;
@property (nonatomic, strong) UILabel           *name;

@end


@implementation MLUserReporTypeCell

#pragma mark - 快速创建cell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"MLUserReporTypeCell";
    
    MLUserReporTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[MLUserReporTypeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        //        cell.selectedBackgroundView = cell.seletView ;
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSomeViews];
        [self setUpLayouts];
    }
    return self;
}
- (void)setModel:(MLUserReportModel *)model{
    self.name.text = model.reason;
    if ([model.is_check integerValue] == 1) {
        self.is_check.image = [UIImage imageNamed:@"gouxuanSelectImg"];
    }else{
        self.is_check.image = [UIImage imageNamed:@"gouxuanImg"];
    }
}
- (void)addSomeViews{
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.is_check];
    [self.bgView addSubview:self.name];

}
- (void)setUpLayouts{
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KAdaptedWidth(5));
        make.leading.trailing.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        
    }];
    
    [self.is_check mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-18);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
    }];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.trailing.mas_equalTo(self.is_check.mas_leading);
        make.centerY.mas_equalTo(self);
    }];

    
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:kWhiteColor];
        _bgView.layer.cornerRadius=KAdaptedHeight(10);
        _bgView.layer.masksToBounds=YES;
    }
    return _bgView;
}

- (UIImageView *)is_check{
    if (!_is_check) {
        _is_check = [ControlCreator createImageView:nil rect:CGRectZero imageName:@"weixuanzhong" backguoundColor:[UIColor clearColor]];
    }
    return _is_check;
}
- (UILabel *)name{
    if (!_name) {
        _name = [ControlCreator createLabel:nil rect:CGRectZero text:@"" font:Font(13) color:mainViceColor backguoundColor:[UIColor clearColor] align:NSTextAlignmentLeft lines:1];
    }
    return _name;
}



@end
