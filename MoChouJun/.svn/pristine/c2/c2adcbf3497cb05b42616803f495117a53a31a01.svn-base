//
//  GroupListsTableViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/14.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "GroupListsTableViewCell.h"
#import "PSGroup.h"
#import "UIImageView+HeadImage.h"
#import "StitchingImage.h"
#import "UIImage+Addtions.h"

@interface GroupListsTableViewCell ()

@end

@implementation GroupListsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _imageView1.layer.cornerRadius = 12.5f;
    _imageView1.layer.masksToBounds = YES;
    _imageView2.layer.cornerRadius = 12.5f;
    _imageView2.layer.masksToBounds = YES;
    _imageView3.layer.cornerRadius = 12.5f;
    _imageView3.layer.masksToBounds = YES;
    _imageView4.layer.cornerRadius = 12.5f;
    _imageView4.layer.masksToBounds = YES;
}

- (void)setGroup:(PSGroup *)group
{
    _group = group;
    [_groupNameLab setTextWithUsername:_group.groupName];

    if (_group.headImg.count == 1) {
        [NetWorkingUtil setImage:_imageView1 url:_group.headImg[0] defaultIconName:@"comment_默认"];
        _imageView2.image = [UIImage imageNamed:@"comment_默认"];
        _imageView3.image = [UIImage imageNamed:@"comment_默认"];
        _imageView4.image = [UIImage imageNamed:@"comment_默认"];
    }else if (_group.headImg.count == 2){
        [NetWorkingUtil setImage:_imageView1 url:_group.headImg[0] defaultIconName:@"comment_默认"];
        [NetWorkingUtil setImage:_imageView2 url:_group.headImg[1] defaultIconName:@"comment_默认"];
        _imageView3.image = [UIImage imageNamed:@"comment_默认"];
        _imageView4.image = [UIImage imageNamed:@"comment_默认"];
    }else if (_group.headImg.count == 3){
        [NetWorkingUtil setImage:_imageView1 url:_group.headImg[0] defaultIconName:@"comment_默认"];
        [NetWorkingUtil setImage:_imageView2 url:_group.headImg[1] defaultIconName:@"comment_默认"];
        [NetWorkingUtil setImage:_imageView3 url:_group.headImg[2] defaultIconName:@"comment_默认"];
        _imageView4.image = [UIImage imageNamed:@"comment_默认"];
    }else if (_group.headImg.count == 4){
        [NetWorkingUtil setImage:_imageView1 url:_group.headImg[0] defaultIconName:@"comment_默认"];
        [NetWorkingUtil setImage:_imageView2 url:_group.headImg[1] defaultIconName:@"comment_默认"];
        [NetWorkingUtil setImage:_imageView3 url:_group.headImg[2] defaultIconName:@"comment_默认"];
        [NetWorkingUtil setImage:_imageView4 url:_group.headImg[3] defaultIconName:@"comment_默认"];
    }
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path = [paths objectAtIndex:0];
//    NSData *_decodedImageData = [[NSData alloc]initWithBase64EncodedString:path options:0];
//    _groupImageView.image = [UIImage imageWithData:_decodedImageData];
//    NSLog(@"-------%@",path);
//    if (_group.headImg.count == 1) {
//        if (IsStrEmpty(_group.headImg[0])) {
//            _groupImageView.image = [UIImage imageNamed:@"comment_默认"];
//        }else{
//            [NetWorkingUtil setImage:_groupImageView url:_group.headImg[0] defaultIconName:@"comment_默认"];
//        }
//        NSArray *arr = @[@"comment_默认",@"comment_默认",@"comment_默认",@"comment_默认"];
//        _groupImageView.image = [UIImage groupIconWith:arr];
//    }else{
//        NSArray *arr = @[@"comment_默认",@"comment_默认",@"comment_默认",@"comment_默认"];
//        _groupImageView.image = [UIImage groupIconWith:_group.headImg];
//    }

//    UIImageView *canvasView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 50, 50)];
//    canvasView.layer.cornerRadius = 25.0f;
//    canvasView.layer.masksToBounds = YES;
//    UIImageView *exampleView = [self createImageViewWithCanvasView:canvasView withImageViewsCount:_group.headImg.count imageArr:_group.headImg];
//    [self addSubview:exampleView];
}

- (UIImageView *)createImageViewWithCanvasView:(UIImageView *)canvasView withImageViewsCount:(NSInteger)count imageArr:(NSArray *)arr {
    NSMutableArray *imageViews = [[NSMutableArray alloc] init];
    
    for (int index = 0; index < count; index++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        imageView.layer.cornerRadius = 12.5f;
        imageView.layer.masksToBounds = YES;
        imageView.image = [UIImage imageNamed:@" "];
        if (IsStrEmpty(arr[index])) {
            imageView.image = [UIImage imageNamed:@"comment_默认"];
        }else{
            [NetWorkingUtil setImage:imageView url:arr[index] defaultIconName:@"comment_默认"];
        }
        
        [imageViews addObject:imageView];
    }
    
    // also can use:
//     return [[StitchingImage alloc] stitchingOnImageView:canvasView withImageViews:imageViews marginValue:12.5f];
    return [[StitchingImage alloc] stitchingOnImageView:canvasView withImageViews:imageViews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
