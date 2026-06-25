//
//  AddTalkCustomView.m
//  miliao
//
//  Created by ZhangShiHao on 2023/6/29.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "AddTalkCustomView.h"

@interface AddTalkCustomView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UIView * bgView;
@property(nonatomic,strong) UIButton * backBtn;
@property(nonatomic,strong) UILabel * tipLabel;
@property(nonatomic,strong) NSMutableArray * dataArr;
@property(nonatomic,strong) UITableView * tableView;




@end

@implementation AddTalkCustomView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addChildrenViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addChildrenViews];
    }
    return self;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
- (void) addChildrenViews{
    [super addChildrenViews];
    [self bgView];
    [self tipLabel];
    [self backBtn];
    [self tableView];
    

    
}


-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    self.dataArr=[NSMutableArray arrayWithArray:dicData[@"data"]];
    [self.tableView reloadData];
    
}



-(void)BtnClick:(UIButton *)sender{
    if (sender.tag==100) {
        if (self.cancleBtnClick) {
            self.cancleBtnClick(@{@"code":@"0"});
        }
    }
    
    
}



- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor=kWhiteColor;
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(self);
            make.height.mas_equalTo(KAdaptedHeight(400)+DBottomDangerArea);
        }];
    }
    return _bgView;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"delImg"] forState:UIControlStateNormal];
        _backBtn.tag=100;
        [_backBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(KAdaptedWidth(35));
            make.centerY.mas_equalTo(self.tipLabel.mas_centerY);
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
        }];
    }
    return _backBtn;
}



- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = getLanguage(@"    推荐话题");
        _tipLabel.textColor = Color(51, 51, 51, 1);
        _tipLabel.textAlignment=NSTextAlignmentLeft;
        _tipLabel.layer.borderColor=RGBA(241, 241, 241, 1).CGColor;
        _tipLabel.layer.borderWidth=1;
        _tipLabel.font=KFontBold(16);
        [self.bgView addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(-5));
            make.height.mas_equalTo(KAdaptedWidth(55));
            make.top.mas_equalTo(KAdaptedHeight(-5));
            make.trailing.mas_equalTo(KAdaptedWidth(5));
        }];
    }
    return _tipLabel;
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = KAdaptedHeight(50);
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.separatorStyle=0;
        _tableView.backgroundColor=Color(237, 227, 255, 0);
        [self.bgView addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(KAdaptedHeight(51));
            make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(KAdaptedHeight(0));
            make.leading.mas_equalTo(KAdaptedWidth(0));
            make.trailing.mas_equalTo(KAdaptedWidth(-0));
            make.bottom.mas_equalTo(KAdaptedHeight(-10));
            
        }];
    }
    return _tableView;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.dataArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    cell.selectionStyle=0;
    NSDictionary *dic=self.dataArr[indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"%@",dic[@"topic"]];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    self.cancleBtnClick(@{@"code":@"1",@"data":self.dataArr[indexPath.row]});
    
    
}




@end
