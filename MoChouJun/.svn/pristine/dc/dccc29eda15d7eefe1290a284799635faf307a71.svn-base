//
//  ImageEditCollectionViewCell.h
//  WeiPublicFund
//
//  Created by liuyong on 15/12/3.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageEditCollectionViewCell;
@protocol ImageEditCollectionViewCellDelegate <NSObject>

- (void) deleteUploadImageSssetCertificationCell:(ImageEditCollectionViewCell *)cell;

@end
@interface ImageEditCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageEditImageView;
@property (nonatomic , weak) id<ImageEditCollectionViewCellDelegate> delegate;
@end
