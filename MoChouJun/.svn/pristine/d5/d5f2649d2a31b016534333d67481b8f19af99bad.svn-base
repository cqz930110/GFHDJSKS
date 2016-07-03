//
//  ImageEditingViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/3.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "ImageEditingViewController.h"
#import <MWPhotoBrowser.h>
#import "ImageEditCollectionViewCell.h"
#import "BaseNavigationController.h"
#import "UIImage-Extensions.h"
#import "PSActionSheet.h"

@interface UIImage (Seleced)
@property (nonatomic,assign) BOOL isSelected;
@end

@implementation UIImage (Seleced)

- (void)setIsSelected:(BOOL)isSelected
{
    NSNumber *boolNumber = [NSNumber numberWithBool:isSelected];
    objc_setAssociatedObject(self, @selector(isSelected), boolNumber, OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isSelected
{
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    return [number boolValue];
}

@end

@interface ImageEditingViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,MWPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *imageEditCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (nonatomic , strong) NSMutableArray *unSelectedImages;
@property (nonatomic , assign) BOOL isOptionAllImage;
@property (nonatomic , strong) UIImage *deleteImage;

@property (nonatomic , strong) UIImagePickerController *imagePicerController;
@end

@implementation ImageEditingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"图片编辑";
    [self setCollectionViewInfo];
    [self setNaviInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)backUp
{
//    if([_sign isEqualToString:@"show"] && _isOptionAllImage == NO){
//        NSDictionary *dic = [NSDictionary dictionaryWithObject:_haveImages forKey:@"Info"];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"Clicks" object:nil userInfo:dic];
//    }else{
//        NSDictionary *dic = [NSDictionary dictionaryWithObject:_haveImages forKey:@"Info"];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"Click" object:nil userInfo:dic];
//    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setNaviInfo
{
    [self setupBarButtomItemWithImageName:@"nav_back_normal" highLightImageName:nil selectedImageName:nil target:self action:@selector(backUp) leftOrRight:YES];
}

- (void)setCollectionViewInfo
{
    [_imageEditCollectionView registerNib:[UINib nibWithNibName:@"ImageEditCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageEditCollectionViewCell"];
    _layout.itemSize = CGSizeMake(70, 70);
    _layout.minimumInteritemSpacing = (SCREEN_WIDTH - 70*4 - 10*2)/3;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)
    {
        // 判断是否能拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            self.imagePicerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePicerController.showsCameraControls = YES;//takePicture
            [self presentViewController:self.imagePicerController animated:YES completion:nil];
        }
        else
        {
            ULog(@"设备不支持");
        }
    }
    else if (buttonIndex == 1)
    {
        // 相册
        self.imagePicerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePicerController animated:YES completion:nil];
    }

}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _haveImages.count == 6?6:_haveImages.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageEditCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageEditCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.row == _haveImages.count && !_isOptionAllImage)
    {
        cell.imageEditImageView.contentMode = UIViewContentModeCenter;
        cell.imageEditImageView.image = self.deleteImage;
    }
    else
    {
        cell.imageEditImageView.contentMode = UIViewContentModeScaleToFill;
        cell.imageEditImageView.image = _haveImages[indexPath.row];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isOptionAllImage && indexPath.row == _haveImages.count)
    {
        PSActionSheet *actionSheet = [[PSActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选择",nil];
        [actionSheet showInView:self.view];
    }
    else
    {
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        
        // Set options
        browser.displayActionButton = YES;
        browser.displayNavArrows = YES;
        browser.displaySelectionButtons = YES;
        browser.zoomPhotosToFill = YES;
        browser.enableGrid = YES;
        browser.startOnGrid = YES;
        browser.autoPlayOnAppear = NO;
        // Manipulate
        [browser showNextPhotoAnimated:YES];
        [browser showPreviousPhotoAnimated:YES];
        [browser setCurrentPhotoIndex:indexPath.row];
        // Present
        BaseNavigationController *nc = [[BaseNavigationController alloc] initWithRootViewController:browser];
        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nc animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate & UINavigationControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *optionImage = [UIImage fixOrientation:[info objectForKey:@"UIImagePickerControllerEditedImage"]];
    optionImage.isSelected = YES;
    [_haveImages insertObject:optionImage atIndex:_haveImages.count];
    _isOptionAllImage = (_haveImages.count == 6);
    [_imageEditCollectionView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return _haveImages.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    MWPhoto *photo = [MWPhoto photoWithImage:_haveImages[index]];
    return photo;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index
{
    UIImage *image = _haveImages[index];
    image.isSelected = YES;
    MWPhoto *photo = [MWPhoto photoWithImage:_haveImages[index]];
    return photo;
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index
{
    return YES;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected
{
    UIImage *image = _haveImages[index];
    image.isSelected = selected;
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser
{
    [_haveImages enumerateObjectsUsingBlock:^(UIImage *  _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if (!image.isSelected)
         {
             [self.unSelectedImages addObject:image];
         }
     }];
    
    // 更新数据
    if (_unSelectedImages.count != 0)
    {
        [_haveImages removeObjectsInArray:_unSelectedImages];
        // 添加删除
        _isOptionAllImage = NO;
        [_imageEditCollectionView reloadData];
    }
    [_unSelectedImages removeAllObjects];
    [photoBrowser dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Setter & Getter

- (void)setHaveImages:(NSMutableArray *)haveImages
{
    _haveImages = haveImages;
    if (_haveImages.count == 6) {
        _isOptionAllImage = YES;
    }
    else
    {
        _isOptionAllImage = NO;
    }
    
}

- (NSMutableArray *)unSelectedImages
{
    if (!_unSelectedImages)
    {
        _unSelectedImages = [NSMutableArray arrayWithCapacity:6];
    }
    return _unSelectedImages;
}

- (UIImage *)deleteImage
{
    if (!_deleteImage)
    {
        _deleteImage  = [UIImage imageNamed:@"+"];
    }
    return _deleteImage;
}

- (UIImagePickerController *)imagePicerController
{
    if (!_imagePicerController)
    {
        _imagePicerController = [[UIImagePickerController alloc]init];
        _imagePicerController.navigationBar.tintColor = [UIColor colorWithHexString:@"#2B2B2B"];
        _imagePicerController.navigationBar.barTintColor = NaviColor;
        [_imagePicerController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#2B2B2B"]}];
        _imagePicerController.delegate = self;
        _imagePicerController.allowsEditing = YES;
    }
    return _imagePicerController;
}


@end
