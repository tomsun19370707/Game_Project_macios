//
//  EMO_UserReportViewController.m
//  miliao
//
//  Created by feifei on 2019/8/5.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "EMO_UserReportViewController.h"

#import "MLUserReportModel.h"

#import "MLUserReporTypeCell.h"

@interface EMO_UserReportViewController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UILabel                           *reportType;
@property (nonatomic, strong) UITableView                       *tableView;
@property (nonatomic, strong) UILabel                           *iconLB;
@property (nonatomic, strong) UIImageView                       *icon;
@property (nonatomic, strong) UIImageView                       *iconTwo;
@property (nonatomic, strong) UIImageView                       *iconThree;
@property (nonatomic, strong) UIButton                       *iconTwoDelBtn;
@property (nonatomic, strong) UIButton                       *iconThreeDelBtn;
@property (nonatomic, strong) UIButton                          *submitButton;

@property (nonatomic, strong) UIView                            *tableBgView;

@property (nonatomic, strong) NSMutableArray                    *checkArr;

@property (nonatomic, strong) UIImagePickerController           *imagePickerController;
@property (nonatomic, strong) UIImage                           *coverImage;

@property (nonatomic, strong) NSMutableArray   *coverImageArr;
@property (nonatomic, assign) BOOL   coverImageBool;

Strong NSIndexPath *selectIndexPath;

Strong NSString *qiNiuToken;
Strong NSString *imgUrl;

@end

@implementation EMO_UserReportViewController

-(NSMutableArray *)coverImageArr{
    if (!_coverImageArr) {
        _coverImageArr=[NSMutableArray array];
    }
    return _coverImageArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=RGBA(248, 248, 248, 1);
    self.isNeedLine = YES;
    self.coverImageBool=NO;
    [self loadBar:YES needBack:YES needBackground:YES];
    self.leftButtonView.image = ImageNamed(@"xiaoxi_back");
    self.titleLabel.text = getLanguage(@"举报");
    [self setViewUpBgView];
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self getToken];
}

-(void)delButtonClick:(UIButton *)sender{
    if (sender.tag==200) {
        
        if (self.coverImageArr.count==1) {
            self.iconTwo.hidden=YES;
            [self.coverImageArr removeObjectAtIndex:0];
        }else{
            self.iconThree.hidden=YES;
            self.iconTwo.image=self.iconThree.image;
            self.iconThree.image=KGetImage(@"");
            if (self.coverImageArr.count==2){
                if (self.coverImageBool) {
                    self.iconTwo.hidden=YES;
                }
                [self.coverImageArr removeObjectAtIndex:1];
            }else{
                [self.coverImageArr removeObjectAtIndex:2];
            }
        }
        
    }else{
        self.iconThree.image=KGetImage(@"");
        self.iconThree.hidden=YES;
        if (self.coverImageArr.count==2){
            [self.coverImageArr removeObjectAtIndex:1];
        }else{
            [self.coverImageArr removeObjectAtIndex:2];
        }
    }
    
    
}

-(void)getToken{
    [NetworkRequest POST:Request_getQiNiuToken parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        if(baseModel.code==1){
            self.qiNiuToken=[Common isNull:baseModel.data[@"qiniutoken"]];
        }
    } failture:^(NSError *error) {
        
    }];
    
}

#pragma mark 上传图片
-(void)upPictures:(UIImage*)image{
    
    if(self.qiNiuToken.length<1){
        [self getToken];
    }
    
    WeakSelf;
    [SVProgressHUD showWithStatus:@"上传中..."];
    
    [NetworkRequest uploadOneImage:Request_AppUpload parameters:@{@"qiniutoken":self.qiNiuToken} image:image fileName:@"file" progress:^(NSProgress *uploadProgress) {

    } success:^(id responObject) {
        [SVProgressHUD dismiss];
        BaseModel *baseModel = (BaseModel *)responObject;
        self.imgUrl=[Common isNull:baseModel.data[@"fullurl"]];
        self.icon.image=image;
    } error:^(NSError *errors) {
        [SVProgressHUD dismiss];

    }];
    
}



- (void)submitButtonClick:(UIButton *)sender{
    
    if (self.checkArr.count ==0||(self.imgUrl.length<1)) {
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:getLanguage(@"请选择举报类型并上传截图")];
    }else{
        
        NSMutableArray *arr = [NSMutableArray array];
        [self.checkArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MLUserReportModel *model = obj;
            [arr addObject:model.reportID];
        }];
        NSString *reportStr = [arr componentsJoinedByString:@","];

        NSDictionary *dic=[NSDictionary dictionary];
        if([self.type isEqualToString:@"1"]){
            dic=@{@"reason_id":reportStr,@"type":self.type,@"images":self.imgUrl,@"room_id":self.ryUserID};
        }else if ([self.type isEqualToString:@"2"]){
            dic=@{@"reason_id":reportStr,@"type":self.type,@"images":self.imgUrl,@"to_uid":self.ryUserID};
        }
        
        [NetworkRequest POST:Request_AddReport parmeters:dic success:^(id responObject) {
            BaseModel *baseModel = (BaseModel *)responObject;
            [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:baseModel.msg]];
            [self.navigationController popViewControllerAnimated:YES];
        } failture:^(NSError *error) {
            
        }];
        
    }
}
- (void)singleTapGesture:(UITapGestureRecognizer *)tap{
    [self selectImageFromAlbum];
}
#pragma mark 从相册获取图片或视频
- (void)selectImageFromAlbum {
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePickerController.modalPresentationStyle = 0;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate
//该代理方法仅适用于只选取图片时
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    _coverImage = info[@"UIImagePickerControllerOriginalImage"];
    
    [self upPictures:_coverImage];
//    if (self.coverImageArr.count==0) {
//        self.iconTwo.image = _coverImage;
//        self.iconTwo.hidden=NO;
//        [self.coverImageArr addObject:_coverImage];
//    }else if (self.coverImageArr.count==1){
//        if (self.coverImageBool) {
//            self.iconTwo.image = self.icon.image;
//            self.icon.image = _coverImage;
//        }else{
//            self.iconThree.image = self.iconTwo.image;
//            self.iconTwo.image = _coverImage;
//            self.iconThree.hidden=NO;
//        }
//        self.iconTwo.hidden=NO;
//        [self.coverImageArr insertObject:_coverImage atIndex:0];
//    }else if (self.coverImageArr.count==2){
//        if (self.coverImageBool) {
//            self.iconThree.image = self.iconTwo.image;
//            self.iconTwo.image = self.icon.image;
//            self.iconThree.hidden=NO;
//        }
//        self.coverImageBool=YES;
//        self.icon.image = _coverImage;
//        [self.coverImageArr insertObject:_coverImage atIndex:0];
//    }else{
//        self.coverImageBool=YES;
//        self.icon.image = _coverImage;
//        [self.coverImageArr replaceObjectAtIndex:0 withObject:_coverImage];
//    }
       
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.reportTypeArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLUserReporTypeCell *cell = [MLUserReporTypeCell cellWithTableView:tableView];
    cell.model = self.reportTypeArr[indexPath.row];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

#pragma mark -
#pragma mark Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.selectIndexPath){
        MLUserReportModel *model = self.reportTypeArr[self.selectIndexPath.row];
        model.is_check = @"0";
        [self.checkArr removeObject:model];
    }
    self.selectIndexPath=indexPath;
    MLUserReportModel *model = self.reportTypeArr[indexPath.row];
    if ([model.is_check integerValue] == 1) {
        model.is_check = @"0";
        [self.checkArr removeObject:model];
    }else{
        model.is_check = @"1";
        [self.checkArr addObject:model];
    }
    [self.tableView reloadData];
}


- (void)setViewUpBgView{
    [self.bgView addSubview:self.reportType];
    [self.bgView addSubview:self.tableBgView];
    [self.tableBgView addSubview:self.tableView];
    [self.bgView addSubview:self.iconLB];
    [self.bgView addSubview:self.icon];
    [self.bgView addSubview:self.iconTwo];
    [self.bgView addSubview:self.iconThree];
    [self.iconTwo addSubview:self.iconTwoDelBtn];
    [self.iconThree addSubview:self.iconThreeDelBtn];
//
    [self.bgView addSubview:self.submitButton];
    CGFloat tableViewH = self.reportTypeArr.count * 55;
    
    [self.reportType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.barView.mas_bottom).offset(15);
        make.left.mas_equalTo(13);
    }];
    [self.tableBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.reportType.mas_bottom).offset(20);
        make.left.mas_equalTo(self.reportType);
        make.right.mas_equalTo(-13);
        make.height.mas_equalTo(tableViewH);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableBgView);
        make.left.mas_equalTo(self.tableBgView);
        make.right.mas_equalTo(self.tableBgView);
        make.bottom.mas_equalTo(self.tableBgView);
    }];
    [self.iconLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(20);
        make.left.mas_equalTo(13);
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconLB.mas_bottom).offset(15);
        make.left.mas_equalTo(13);
        make.height.mas_equalTo(80);
        make.width.mas_equalTo(80);
    }];
    [self.iconTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.icon.mas_top).offset(0);
        make.left.mas_equalTo(self.icon.mas_right).offset(KAdaptedWidth(10));
        make.height.mas_equalTo(self.icon.mas_height);
        make.width.mas_equalTo(self.icon.mas_width);
    }];
    
    [self.iconTwoDelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconTwo.mas_top).offset(0);
        make.trailing.mas_equalTo(self.iconTwo.mas_trailing).offset(KAdaptedWidth(0));
        make.height.width.mas_equalTo(KAdaptedWidth(25));

    }];
    [self.iconThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.icon.mas_top).offset(0);
        make.left.mas_equalTo(self.iconTwo.mas_right).offset(KAdaptedWidth(10));
        make.height.mas_equalTo(self.icon.mas_height);
        make.width.mas_equalTo(self.icon.mas_width);
    }];
    
    [self.iconThreeDelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconThree.mas_top).offset(0);
        make.trailing.mas_equalTo(self.iconThree.mas_trailing).offset(KAdaptedWidth(0));
        make.height.mas_equalTo(self.iconTwoDelBtn.mas_height);
        make.width.mas_equalTo(self.iconTwoDelBtn.mas_width);

    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(kWidth-30);
        make.bottom.mas_equalTo(-50);
    }];
    [self.bgView layoutIfNeeded];

    self.iconTwo.hidden=YES;
    self.iconThree.hidden=YES;
    
}

#pragma make getViewData
- (UILabel *)reportType{
    if (!_reportType) {
        _reportType = [ControlCreator createLabel:nil rect:CGRectZero text:getLanguage(@"请选择举报原因:") font:Font(15) color:mainViceColor backguoundColor:[UIColor clearColor] align:NSTextAlignmentLeft lines:1];
    }
    return _reportType;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundView = nil;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor =[UIColor clearColor];
        _tableView.bounces = NO;
    }
    return _tableView;
}
- (UIView *)tableBgView{
    if (!_tableBgView) {
        _tableBgView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:[UIColor clearColor]];
    }
    return _tableBgView;
}
- (UILabel *)iconLB{
    if (!_iconLB) {
        _iconLB = [ControlCreator createLabel:nil rect:CGRectZero text:[NSString stringWithFormat:@"%@",getLanguage(@"上传截图")] font:Font(15) color:mainViceColor backguoundColor:[UIColor clearColor] align:NSTextAlignmentLeft lines:1];
//        NSString *str1 = @"(最多上传3张)";
        NSString *str1 = @" ";
        NSString *str = NSStringFormat(@"%@%@",getLanguage(@"上传截图"),str1);
        NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrDescribeStr addAttribute:NSFontAttributeName value:KFont(15) range:NSMakeRange(0,attrDescribeStr.length-str1.length)];
        [attrDescribeStr addAttribute:NSFontAttributeName value:KFont(12) range:NSMakeRange(attrDescribeStr.length-str1.length,str1.length)];
        [attrDescribeStr addAttribute:NSForegroundColorAttributeName value:RGBA(34, 34, 34, 1) range:NSMakeRange(0,attrDescribeStr.length-str1.length)];
        [attrDescribeStr addAttribute:NSForegroundColorAttributeName value:RGBA(102, 102, 102, 1) range:NSMakeRange(attrDescribeStr.length-str1.length,str1.length)];
        
        _iconLB.attributedText = attrDescribeStr;
    }
    return _iconLB;
}
- (UIImageView *)icon{
    if (!_icon) {
        _icon = [ControlCreator createImageView:nil rect:CGRectZero imageName:@"reportAddPictureImg" backguoundColor:[UIColor whiteColor]];
        _icon.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
        [_icon addGestureRecognizer:singleTap];
        _icon.layer.cornerRadius=KAdaptedHeight(10);
        _icon.layer.masksToBounds=YES;
    }
    return _icon;
}
- (UIImageView *)iconTwo{
    if (!_iconTwo) {
        _iconTwo = [ControlCreator createImageView:nil rect:CGRectZero imageName:@"" backguoundColor:[UIColor clearColor]];
        _iconTwo.userInteractionEnabled = YES;
        _iconTwo.layer.cornerRadius=KAdaptedHeight(10);
        _iconTwo.layer.masksToBounds=YES;
    }
    return _iconTwo;
}
- (UIButton *)iconTwoDelBtn{
    if (!_iconTwoDelBtn) {
        _iconTwoDelBtn = [ControlCreator createButton:nil rect:CGRectZero text:@"" font:Font(18) color:RGBA(34, 34, 34, 1) backguoundColor:kClearColor imageName:@"delImg" target:self action:@selector(delButtonClick:)];
        _iconTwoDelBtn.tag=200;
    }
    return _iconTwoDelBtn;
}



- (UIImageView *)iconThree{
    if (!_iconThree) {
        _iconThree = [ControlCreator createImageView:nil rect:CGRectZero imageName:@"" backguoundColor:[UIColor clearColor]];
        _iconThree.userInteractionEnabled = YES;
        _iconThree.layer.cornerRadius=KAdaptedHeight(10);
        _iconThree.layer.masksToBounds=YES;
    }
    return _iconThree;
}
- (UIButton *)iconThreeDelBtn{
    if (!_iconThreeDelBtn) {
        _iconThreeDelBtn = [ControlCreator createButton:nil rect:CGRectZero text:@"" font:Font(18) color:RGBA(34, 34, 34, 1) backguoundColor:kClearColor imageName:@"delImg" target:self action:@selector(delButtonClick:)];
        _iconThreeDelBtn.tag=300;
    }
    return _iconThreeDelBtn;
}



- (UIButton *)submitButton{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0,0,kWidth-30,50);
        gl.startPoint = CGPointMake(0.5, 0);
        gl.endPoint = CGPointMake(0.5, 1);
        gl.colors = @[(__bridge id)BaseMainColor.CGColor,(__bridge id)RGBA(255, 238, 1, 1).CGColor];
        gl.locations = @[@(0.0),@(1.0f)];
        [_submitButton.layer addSublayer:gl];
        _submitButton.layer.cornerRadius = 25;
        _submitButton.layer.masksToBounds=YES;
        [_submitButton setTitle:getLanguage(@"提交") forState:UIControlStateNormal];
        [_submitButton setTitleColor:RGBA(34, 34, 34, 1) forState:UIControlStateNormal];
        _submitButton.titleLabel.font=KFont(15);
        _submitButton.tag=500;
        [_submitButton addTarget:self action:@selector(submitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}




//- (UIButton *)submitButton{
//    if (!_submitButton) {
//        _submitButton = [ControlCreator createButton:nil rect:CGRectZero text:getLanguage(@"提交") font:Font(18) color:RGBA(34, 34, 34, 1) backguoundColor:MLControlsColor imageName:nil target:self action:@selector(submitButtonClick:)];
//        CAGradientLayer *gl = [CAGradientLayer layer];
//        gl.frame = CGRectMake(0,0,300,50);
//        gl.startPoint = CGPointMake(0, 0);
//        gl.endPoint = CGPointMake(1, 1);
//        gl.colors = @[(__bridge id)[UIColor colorWithRed:73/255.0 green:174/255.0 blue:252/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:2/255.0 green:237/255.0 blue:252/255.0 alpha:1.0].CGColor];
//        gl.locations = @[@(0.0),@(1.0f)];
//        [_submitButton.layer addSublayer:gl];
//        _submitButton.layer.cornerRadius = 22.5;
//        _submitButton.layer.masksToBounds = YES;
//    }
//    return _submitButton;
//}

- (NSMutableArray *)reportTypeArr{
    if (!_reportTypeArr) {
        _reportTypeArr = [NSMutableArray array];
    }
    return _reportTypeArr;
}
- (NSMutableArray *)checkArr{
    if (!_checkArr) {
        _checkArr = [NSMutableArray array];
    }
    return _checkArr;
}

@end
