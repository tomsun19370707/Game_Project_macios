//
//  EMO_NobilityDescriptionVC.m
//  miliao
//
//  Created by ZhangShiHao on 2023/6/28.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_NobilityDescriptionVC.h"
#import "EMO_NobilityView.h"

@interface EMO_NobilityDescriptionVC ()
Strong EMO_NobilityView *contentView;


@end

@implementation EMO_NobilityDescriptionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(255, 255, 255, 1);
    [self loadBar:YES needBack:YES needBackground:YES];
    self.titleLabel.text=getLanguage(@"爵位");
    self.titleLabel.font=KFont(18);
    [self contentView];
    
    [self.contentView vcType:2 andData:[NSMutableArray arrayWithArray:self.dataArr]];
//    [NetworkRequest POST:Request_GetPeerageList parmeters:nil success:^(id responObject) {
//        BaseModel *model=(BaseModel *)responObject;
//        [self.contentView vcType:2 andData:[NSMutableArray arrayWithArray:model.data]];
//
//    } failture:^(NSError *error) {
//
//    }];
    
   
}

- (EMO_NobilityView *)contentView{
    if (!_contentView) {
        _contentView = [[EMO_NobilityView alloc] init];
        _contentView.backgroundColor =RGBA(248, 248, 248, 1);
        [self.view addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.mas_equalTo(0);
            make.top.mas_equalTo(ZJTopNavH+ZJStatusBarH);
            
        }];
    }
    return _contentView;
}

@end
