//
//  EMO_RoomClickUserView.m
//  miliao
//
//  Created by aa on 2019/6/24.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "EMO_RoomClickUserView.h"
#import "MLRoomMSequenceModel.h"

@interface EMO_RoomClickUserView ()

@property (weak, nonatomic) IBOutlet UIButton *holdingMButton;
@property (weak, nonatomic) IBOutlet UIButton *suoMButtton;
@property (weak, nonatomic) IBOutlet UIButton *shangmaiButton;
@property (weak, nonatomic) IBOutlet UIView *shnagmaiView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *holdingMButtonY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userViewH;

Strong MLRoomMSequenceModel *model;
@end


@implementation EMO_RoomClickUserView

- (void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
    [self addGestureRecognizer:singleTap];
    
}


- (void)setUpViewWithModel:(MLRoomMSequenceModel *)model{
    
    self.model=model;
    
    if ([[MLRoomInformationModel currentAccount].uuid integerValue] == [[UserManager userInfo].user_id integerValue]) {
        self.shangmaiButton.hidden = NO;
        self.shnagmaiView.hidden = NO;
        self.holdingMButtonY.constant = 60;
        self.userViewH.constant = 150;
    }else{
        self.shangmaiButton.hidden = YES;
        self.shnagmaiView.hidden = YES;
        self.holdingMButtonY.constant = 10;
        self.userViewH.constant = 100;
    }
    [self.shangmaiButton setTitle:getLanguage(@"上麦") forState:UIControlStateNormal];
    [self.holdingMButton setTitle:getLanguage(@"报麦") forState:UIControlStateNormal];
    
    if ([model.status integerValue] == 0) {
        [self.suoMButtton setTitle:getLanguage(@"锁麦") forState:UIControlStateNormal];
    }else if([model.status integerValue] == 1){
        [self.suoMButtton setTitle:getLanguage(@"开麦") forState:UIControlStateNormal];
    }
    [self layoutIfNeeded];
}
//上麦
- (IBAction)clickUserViewClick:(UIButton *)sender {
    [self removeFromSuperview];
    
    !self.listClickBlock ?: self.listClickBlock(sender.tag,self.model);
    
}
- (void)singleTapGesture:(UITapGestureRecognizer *)tap{
    [self removeFromSuperview];
}




@end
