//
//  AddReturnViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/2.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//
#define TEXT_MAXLENGTH           @"200"
#import "AddReturnViewController.h"
#import "ImageEditingViewController.h"
#import <MWPhotoBrowser.h>
#import "ImageEditCollectionViewCell.h"
#import "BaseNavigationController.h"
#import "UIImage-Extensions.h"
#import "PSActionSheet.h"
#import "NSString+Adding.h"


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

@interface AddReturnViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDataSource,UIBarPositioningDelegate,MWPhotoBrowserDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *returnNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *returnIntroduceTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *addReturnCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@property (nonatomic,strong)NSMutableArray *selectArr;
@property (nonatomic , assign) BOOL isOptionAllImage;
@property (nonatomic , strong) UIImage *deleteImage;

@property (nonatomic , strong) UIImagePickerController *imagePicerController;
@property (nonatomic,strong)NSMutableArray *unSelectedImages;
@end

@implementation AddReturnViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加回报";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setCollectionViewInfo];
    [self setNaviInfo];
    
    _returnIntroduceTextView.delegate = self;
    
    [_returnNameTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setCollectionViewInfo
{
    [_addReturnCollectionView registerNib:[UINib nibWithNibName:@"ImageEditCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageEditCollectionViewCell"];
    _layout.itemSize = CGSizeMake(70, 70);
    _layout.minimumInteritemSpacing = (SCREEN_WIDTH - 70*4 - 10*2)/3;
}

- (void)setNaviInfo
{
    [self setupBarButtomItemWithTitle:@"保存" target:self action:@selector(saveClick) leftOrRight:NO];
    [self setupBarButtomItemWithImageName:@"nav_back_normal.png" highLightImageName:@"nav_back_select.png" selectedImageName:nil target:self action:@selector(backClick) leftOrRight:YES];
}


- (void)textFieldChange:(UITextField *)textField
{
    if (_returnNameTextField.text.length >= 6) {
        _returnNameTextField.text = [_returnNameTextField.text substringToIndex:6];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *new = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger res = TEXT_MAXLENGTH.intValue -[new length];
    NSLog(@"%ld    %ld",(long)res,[text length]);
    if ([text length] > (TEXT_MAXLENGTH.intValue - textView.text.length)) {
        [MBProgressHUD showMessag:@"已经超过最大字数"  toView:self.view];
        return NO;
    }else{
        if(res >= 0){
            return YES;
        }else{
            NSRange rg = {0,[text length]+res};
            NSLog(@"---%lu",[text length]+res);
            NSLog(@"==%lu",(unsigned long)rg.length);
            if (rg.length > 0) {
                NSRange rgs = {0,TEXT_MAXLENGTH.intValue};
                NSString *s = [textView.text substringWithRange:rgs];
                [textView setText:[textView.text stringByReplacingOccurrencesOfString:textView.text withString:s]];
                return NO;
            }
            return NO;
        }
    }
    
    return YES;
}

- (void)backClick
{
    if (_editReturnDic)
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)saveClick
{
    if (IsStrEmpty(_returnNameTextField.text)) {
        [MBProgressHUD showMessag:@"你想支持多少，要实打实的写上哦" toView:self.view];
        return;
    }
    if (IsStrEmpty(_returnIntroduceTextView.text)) {
        [MBProgressHUD showMessag:@"回报介绍不能为空" toView:self.view];
        return;
    }
    if (_returnIntroduceTextView.text.length > 200) {
         [MBProgressHUD showMessag:@"已经超过最大字数" toView:self.view];
        return;
    }

    NSDictionary *saveDic;
    if (_selectArr.count)
    {
        saveDic = @{@"SupportAmount":_returnNameTextField.text,
                    @"Description":_returnIntroduceTextView.text,
                    @"Images":_selectArr};
        
    }else
    {
        saveDic = @{@"SupportAmount":_returnNameTextField.text,
                    @"Description":_returnIntroduceTextView.text,
                    @"Images":@""};
    }
    
    if ([self.delegate respondsToSelector:@selector(addReturnSavedReturnUserInfo:isEdit:)]) {
        [self.delegate addReturnSavedReturnUserInfo:saveDic isEdit:_editReturnDic];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
//
//- (IBAction)uploadImageClick:(id)sender {
//    ImageEditingViewController *imageEditingVC = [ImageEditingViewalloc] init];
//
//    [self.navigationController pushViewController:imageEditingVC animated:YES];
//}

#pragma mark - Setter & Getter

- (NSMutableArray *)unSelectedImages
{
    if (!_unSelectedImages)
    {
        _unSelectedImages = [NSMutableArray array];
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

- (void)setEditReturnDic:(NSDictionary *)editReturnDic
{
    _editReturnDic = editReturnDic;
    
    if (_editReturnDic.count > 0) {
        _returnNameTextField.text = [_editReturnDic objectForKey:@"SupportAmount"];
        _returnIntroduceTextView.text = [_editReturnDic objectForKey:@"Description"];
        id images = [_editReturnDic objectForKey:@"Images"];
        if ([images isKindOfClass:[NSArray class]])
        {
            [self.selectArr addObjectsFromArray:images];
        }
    }
}

- (NSMutableArray *)selectArr
{
    if (!_selectArr)
    {
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
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

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1)
    {
        if (buttonIndex == 0)
        {
            // 拍照
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
}

#pragma mark - UIImagePickerControllerDelegate & UINavigationControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *optionImage = [UIImage fixOrientation:[info objectForKey:@"UIImagePickerControllerEditedImage"]];
    optionImage.isSelected = YES;
    [_selectArr insertObject:optionImage atIndex:_selectArr.count];
    _isOptionAllImage = (_selectArr.count == 6);
    [_addReturnCollectionView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (self.selectArr.count == 6)?6:self.selectArr.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageEditCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageEditCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.row == _selectArr.count && !_isOptionAllImage)
    {
        cell.imageEditImageView.contentMode = UIViewContentModeCenter;
        cell.imageEditImageView.image = self.deleteImage;
    }
    else
    {
        cell.imageEditImageView.contentMode = UIViewContentModeScaleToFill;
        cell.imageEditImageView.image = _selectArr[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isOptionAllImage && indexPath.row == _selectArr.count)
    {
        PSActionSheet *actionSheet = [[PSActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选择",nil];
        actionSheet.tag = 1;
        [actionSheet showInView:self.view];
    }
    else
    {
        // 查看图片 //删除功能
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        
        // Set options
        browser.displayActionButton = YES;
        browser.displayNavArrows = YES;
        browser.displaySelectionButtons = YES;
        browser.zoomPhotosToFill = YES;
        browser.enableGrid = YES;
        browser.startOnGrid = YES;
        browser.autoPlayOnAppear = NO;
        [browser setCurrentPhotoIndex:indexPath.row];
        // Manipulate
        [browser showNextPhotoAnimated:YES];
        [browser showPreviousPhotoAnimated:YES];
        
        // Present
        BaseNavigationController *nc = [[BaseNavigationController alloc] initWithRootViewController:browser];
        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nc animated:YES completion:nil];
    }
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return _selectArr.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    MWPhoto *photo = [MWPhoto photoWithImage:_selectArr[index]];
    return photo;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index
{
    MWPhoto *photo = [MWPhoto photoWithImage:_selectArr[index]];
    return photo;
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index
{
    return YES;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected
{
    UIImage *image = _selectArr[index];
    image.isSelected = selected;
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser
{
    [_selectArr enumerateObjectsUsingBlock:^(UIImage *  _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if (!image.isSelected)
         {
             [self.unSelectedImages addObject:image];
         }
     }];
    
    // 更新数据
    if (_unSelectedImages.count != 0)
    {
        [_selectArr removeObjectsInArray:_unSelectedImages];
        // 添加删除
        _isOptionAllImage = NO;
        [_addReturnCollectionView reloadData];
    }
    [_unSelectedImages removeAllObjects];
    [photoBrowser dismissViewControllerAnimated:YES completion:nil];
}

@end
