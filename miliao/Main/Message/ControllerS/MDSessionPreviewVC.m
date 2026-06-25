//
//  MDSessionPreviewVC.m
//  miliao
//
//  Created by apple on 2020/4/20.
//  Copyright © 2020 miliao. All rights reserved.
//

#import "MDSessionPreviewVC.h"

@interface MDSessionPreviewVC ()

@end

@implementation MDSessionPreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.backgroundColor = [UIColor whiteColor];
    UIImageView *image = [UIImageView new];
    image.userInteractionEnabled = YES;
    RCImageMessage *content = (RCImageMessage *)self.model.content;
    image.image = content.thumbnailImage;
    [self.view addSubview:image];
    image.contentMode = UIViewContentModeScaleAspectFit;
    image.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMethod)];
    [image addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}
- (void)tapMethod {
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
