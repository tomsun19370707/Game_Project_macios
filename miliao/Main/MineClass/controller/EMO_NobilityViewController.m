//
//  EMO_NobilityViewController.m
//  miliao
//
//  Created by ZhangShiHao on 2023/6/28.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_NobilityViewController.h"
#import "EMO_NobilityView.h"

@interface EMO_NobilityViewController ()

Strong EMO_NobilityView *contentView;

Strong NSMutableArray *arrData;

@end

@implementation EMO_NobilityViewController

-(NSMutableArray *)arrData{
    if(!_arrData){
        _arrData=[NSMutableArray array];
    }
    return _arrData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(255, 255, 255, 1);
    [self loadBar:YES needBack:YES needBackground:YES];
    self.titleLabel.text=getLanguage(@"爵位");
    self.titleLabel.font=KFont(18);
    [self addData];
    [self contentView];
    
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


-(void)addData{
    
    
    [NetworkRequest POST:Request_GetPeerageList parmeters:nil success:^(id responObject) {
        BaseModel *model=(BaseModel *)responObject;
        self.arrData=[NSMutableArray arrayWithArray:model.data];
        [self.contentView vcType:1 andData:self.arrData];
        
    } failture:^(NSError *error) {
        
    }];
    
    
    
    
    
}




@end
