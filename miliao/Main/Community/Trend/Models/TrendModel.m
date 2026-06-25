//
//  TrendModel.m
//  miliao
//
//  Created by aa on 2019/7/6.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "TrendModel.h"
#import "SDHelper.h"

@implementation TrendModel
{
    CGFloat _cellHeight;
    CGFloat _tagsViewHeight;
    CGFloat _contentLabelHeight;
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"uid": @"id"};
}
-(BOOL)isPlay
{
    if (!_isPlay) {
        _isPlay = NO;
    }
    return _isPlay;
}
-(NSString *)addtime
{
    NSDate *timeDate = [NSDate timeStringToDate:_addtime];
    NSString *requiredString = [timeDate dateToRequiredString];
    return requiredString;
}
-(NSString *)like_time
{
    NSDate *timeDate = [NSDate timeStringToDate:_like_time];
    NSString *requiredString = [timeDate dateToRequiredString];
    return requiredString;
}
-(NSString *)created_at
{
    NSDate *timeDate = [NSDate timeStringToDate:_created_at];
    NSString *requiredString = [timeDate dateToRequiredString];
    return requiredString;
}
- (CGFloat)contentLabelHeight
{
    if (!_contentLabelHeight) {
        CGSize size = [self.content sizeWithFont:Font(15) With:ScreenWidth - 30];
        _contentLabelHeight = size.height + 35;
    }
    if (self.content.length > 0) {
        return _contentLabelHeight;
    }
    else
        return 0;
    
}
-(CGFloat)imageHeight
{
    if (!_imageHeight) {
         CGFloat g =  MoreThanOnePicWidth;
        if (self.image_urList.count > 0) {
            if (self.image_urList.count == 1) {
                NSString *url = self.image_urList.firstObject;
                //在拿到需要请求的url数组的时候，就将每个链接的尺寸顺便就给获取出来，然后本地化存储该图片的尺寸，然后再到cell里面根据链接直接在本地取到图片的尺寸，那样在cell里面浏览的时候就不会有卡顿了。
                if (![[NSUserDefaults standardUserDefaults] objectForKey:url]) {
                    CGSize imageSize = [UIImage getImageSizeWithURL:url];
                    if (imageSize.width) {
                        _imageHeight = imageSize.height / imageSize.width * MLTrendCellOnePicWidth + MLTrendCellMargin;
                    }
                    //将最终的自适应的高度 本地化处理
                    [[NSUserDefaults standardUserDefaults] setObject:@(imageSize.height / imageSize.width * MLTrendCellOnePicWidth) forKey:url];
                }
                else
                {
                    NSString * height = [[NSUserDefaults standardUserDefaults] objectForKey:url];
                    _imageHeight = [height intValue] + MLTrendCellMargin;
                }
            }
            else if(self.image_urList.count > 3)
            {
                CGFloat h = g * 2 + MLTrendCellMargin;
                _imageHeight = h + 5 ;//5:两行图片之间的margin
            }
            else
            {
                _imageHeight = g + MLTrendCellMargin;
            }
        }
        else _imageHeight = 0;
    }
    return _imageHeight;
}
- (CGFloat)cellHeight
{
    if (!_cellHeight) {
        //p文字帖子的高度
        if (self.contentLabelHeight < MLTrendCellTextMaxY) {
             _cellHeight = (self.contentLabelHeight) + 2 * MLTrendCellMargin + MLTrendCellBottomBarH + 50 ;
        }
        else  _cellHeight = (MLTrendCellTextMaxY + 20) + 2 * MLTrendCellMargin + MLTrendCellBottomBarH + 50 ;

        _cellHeight += self.imageHeight;
        if (self.audio.length > 0) {
            _cellHeight += MLTrendCellMargin + MLTrendCellVoiceH + MLTrendCellMargin;
        }
        if (self.tags_nameList.count > 0) {
            _cellHeight += self.tagsViewHeight  + MLTrendCellMargin * 2 ;
        }   
    }
    return _cellHeight;
}

-(CGFloat)tagsViewHeight
{
    if (!_tagsViewHeight) {
        CGFloat tagsViewW = 0;
        for (NSString *model in self.tags_nameList) {
            int labWidth = [SDHelper widthForLabel:model fontSize:14]+20;
            tagsViewW += labWidth + 10;
        }
        int count;
//        MYLog(@" %f ",ScreenWidth);
        if (tagsViewW > ScreenWidth) {
            count = 2;
        }
        else count = 1;
        
        _tagsViewHeight = MLTrendCellTagsH *count;
    }
    return _tagsViewHeight;
}
- (CGFloat)detailImageHeight
{
    if (!_detailImageHeight) {
        long perRowItemCount = [self perRowItemCountForPicPathArray:self.image_urList];
        long marginCount = perRowItemCount - 1;
        CGFloat g =  (ScreenWidth - 30 * marginCount)/perRowItemCount;
        if (self.image_urList.count > 0) {
            if (self.image_urList.count == 1) {
                NSString *url = self.image_urList.firstObject;
                //在拿到需要请求的url数组的时候，就将每个链接的尺寸顺便就给获取出来，然后本地化存储该图片的尺寸，然后再到cell里面根据链接直接在本地取到图片的尺寸，那样在cell里面浏览的时候就不会有卡顿了。
                NSString *str = [NSString stringWithFormat:@"%@+detail",url];
                if (![[NSUserDefaults standardUserDefaults] objectForKey:str]) {
                    CGSize imageSize = [UIImage getImageSizeWithURL:url];
                    if (imageSize.width) {
                        _detailImageHeight = imageSize.height / imageSize.width * (ScreenWidth-30) + MLTrendCellMargin;
                    }
                    //将最终的自适应的高度 本地化处理
                    [[NSUserDefaults standardUserDefaults] setObject:@(imageSize.height / imageSize.width * ScreenWidth-30) forKey:str];
                }
                else
                {
                    NSString * height = [[NSUserDefaults standardUserDefaults] objectForKey:str];
                    _detailImageHeight = [height intValue] + MLTrendCellMargin;
                }
            }
            else if(self.image_urList.count > 3)
            {
                CGFloat h = g * 2 + MLTrendCellMargin;
                _detailImageHeight = h + 5 ;//5:两行图片之间的margin
            }
            else
            {
                _detailImageHeight = g + MLTrendCellMargin;
                
            }
        }
        else _detailImageHeight = 0;
    }
    return _detailImageHeight;
}
- (CGFloat)detailcellHeight
{
    if (!_detailcellHeight) {
         _detailcellHeight = (self.contentLabelHeight) + 2 * MLTrendCellMargin + MLTrendCellBottomBarH + 60 ;//文字高度
        _detailcellHeight += self.detailImageHeight;
        if (self.audio.length > 0) {
            _detailcellHeight += MLTrendCellMargin + MLTrendCellVoiceH + MLTrendCellMargin;
        }
        if (self.tags_nameList.count > 0) {
            _detailcellHeight += self.tagsViewHeight  + MLTrendCellMargin ;
        }
    }
    
    return _detailcellHeight;
}
//返回多少行，列
- (NSInteger )perRowItemCountForPicPathArray:(NSArray *)array{
    
    if (array.count <=3) {
        return array.count;
        
    }else if (array.count <= 4){
        
        return 2;
    }else{
        
        return 3;
    }
}
- (NSArray *)image_urList
{
    if (!_image_urList) {
        _image_urList = [self.image componentsSeparatedByString:@","];
    }
//    return @[@"http://47.92.85.75/upload//dynamic_image/20190729/15643808361668.jpg",@"http://47.92.85.75/upload//dynamic_image/20190729/15643808367525.jpg",@"http://47.92.85.75/upload//dynamic_image/20190729/15643808364527.jpg"];
    return _image_urList;
}
- (NSArray *)tags_nameList
{
    if (!_tags_nameList) {
        if (self.tags_str.length > 0) {
            _tags_nameList = [self.tags_str componentsSeparatedByString:@","];
        }
    }
    return _tags_nameList;
}
@end
