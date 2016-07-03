//
//  EditImageCell.m
//  WeiPublicFund
//
//  Created by zhoupushan on 16/3/22.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "EditImageCell.h"
@interface EditImageCell()
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@end
@implementation EditImageCell
#pragma mark -  Actions
- (IBAction)deleteImageAction {
    if ([self.delegate respondsToSelector:@selector(editImage:deleteImage:)])
    {
        [self.delegate editImage:self deleteImage:_imageView.image];
    }
}


- (void)setCellType:(EditImageCellType)cellType
{
    _cellType = cellType;
    
    if (_cellType == EditImageCellTypeAdd)
    {
        _imageView.contentMode = UIViewContentModeCenter;//图片展示
        _deleteButton.hidden = YES;
    }
    else
    {
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _deleteButton.hidden = NO;
    }
}
@end
