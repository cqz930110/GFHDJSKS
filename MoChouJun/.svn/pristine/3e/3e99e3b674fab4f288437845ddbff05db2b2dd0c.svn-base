//
//  EditImageCell.h
//  WeiPublicFund
//
//  Created by zhoupushan on 16/3/22.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,EditImageCellType)
{
    EditImageCellTypeAdd,
    EditImageCellTypeDelete
};

@class EditImageCell;
@protocol EditImageCellDelegate<NSObject>
- (void)editImage:(EditImageCell *)cell deleteImage:(UIImage *)deleteImage;
@end

@interface EditImageCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) id<EditImageCellDelegate> delegate;
@property (assign, nonatomic) EditImageCellType cellType;
@end
