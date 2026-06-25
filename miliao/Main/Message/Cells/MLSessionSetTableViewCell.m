//
//  MLSessionSetTableViewCell.m
//  miliao
//
//  Created by feifei on 2019/8/3.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "MLSessionSetTableViewCell.h"


@interface MLSessionSetTableViewCell ()

@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation MLSessionSetTableViewCell

#pragma mark - 快速创建cell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"MLSessionSetTableViewCell";
    
    MLSessionSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[MLSessionSetTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        //        cell.selectedBackgroundView = cell.seletView ;
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
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
- (void)addSomeViews{
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.imageV];
    [self.contentView addSubview:self.lineView];
}
- (void)setUpLayouts{
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(12);
        make.centerY.mas_equalTo(self);
    }];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-20);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(8);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self).offset(-24);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self);
        make.centerX.mas_equalTo(self);
    }];
}
- (void)setFocusOn:(NSString *)focusOn{
    _focusOn = focusOn;
    self.titleLB.text = focusOn;
}


#pragma mark get
- (UILabel *)titleLB{
    if (!_titleLB) {
        _titleLB = [ControlCreator createLabel:nil rect:CGRectZero text:@"" font:Font(14) color:mainViceColor backguoundColor:[UIColor clearColor] align:NSTextAlignmentLeft lines:1];
    }
    return _titleLB;
}
- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [ControlCreator createImageView:nil rect:CGRectZero imageName:@"mineRightImg" backguoundColor:[UIColor clearColor]];
    }
    return _imageV;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:MLControlsHuiColor];
    }
    return _lineView;
}



@end
