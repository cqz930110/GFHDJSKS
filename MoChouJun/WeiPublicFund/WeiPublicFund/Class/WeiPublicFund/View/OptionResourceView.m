//
//  OptionResourceView.m
//  WeiPublicFund
//
//  Created by zhoupushan on 16/3/21.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "OptionResourceView.h"
#import "EditImageCell.h"
//#import "UploadProjectData.h"
@interface OptionResourceView()<UICollectionViewDataSource,UICollectionViewDelegate,EditImageCellDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *optionView;

@property (strong, nonatomic) UIImage *addImage;

@property (assign, nonatomic) BOOL canAddImage;
@end
static NSString *const cellIdentifier = @"EditImageCell";
@implementation OptionResourceView

- (void)awakeFromNib
{
    // setup
    [self setup];
}

- (void)setup
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(53, 53);
    layout.sectionInset = UIEdgeInsetsMake(1, 15, 1, 0);
    layout.minimumInteritemSpacing = 5.0;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    
    _canAddImage = YES;
}

- (void)reloadData
{
//    NSArray *projectImages = [UploadProjectData shareInstance].images;
//    _collectionView.hidden = !projectImages.count;
//    _optionView.hidden = !_collectionView.hidden;
//    
//    _canAddImage = projectImages.count <= 5;
//    
//    [_collectionView reloadData];
}

#pragma mark - Actions
//- (IBAction)optionImageAction
//{
//    if ([self.delegate respondsToSelector:@selector(optionResourceClikeImage:)])
//    {
//        [self.delegate optionResourceClikeImage:self];
//    }
//}
//
//- (IBAction)optionRecordAction
//{
//    if ([self.delegate respondsToSelector:@selector(optionResourceClikeRecord:)])
//    {
//        [self.delegate optionResourceClikeRecord:self];
//    }
//}
//
//#pragma mark - EditImageCellDelegate
//- (void)editImage:(EditImageCell *)cell deleteImage:(UIImage *)deleteImage
//{
//    [[UploadProjectData shareInstance].images removeObject:deleteImage];
//    [self reloadData];
//}
//
//#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    if ([UploadProjectData shareInstance].images.count)
//    {
//        return _canAddImage?[UploadProjectData shareInstance].images.count+1:[UploadProjectData shareInstance].images.count;
//    }
//    return 0;
//    
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    EditImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
//    cell.delegate = self;
//    if (_canAddImage && indexPath.row == [UploadProjectData shareInstance].images.count)
//    {
//        cell.imageView.image = self.addImage;
//        cell.cellType = EditImageCellTypeAdd;
//    }
//    else
//    {
//        cell.imageView.image = [UploadProjectData shareInstance].images[indexPath.row];
//        cell.cellType = EditImageCellTypeDelete;
//
//    }
//    return  cell;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (_canAddImage && indexPath.row == [UploadProjectData shareInstance].images.count)
//    {
//        // 添加图片
//        if([self.delegate respondsToSelector:@selector(optionResourceClikeImage:)])
//        {
//            [self.delegate optionResourceClikeImage:self];
//        }
//    }
//}
//
//#pragma mark - Setter & Getter
//- (UIImage *)addImage
//{
//    if (!_addImage)
//    {
//        _addImage = [UIImage imageNamed:@"add_image"];
//    }
//    return _addImage;
//}
@end
