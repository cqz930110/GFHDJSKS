//
//  AddProjectDetailsViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/8.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "AddProjectDetailsViewController.h"
#import "PSActionSheet.h"
#import "UIImage-Extensions.h"
#import "UpYun.h"
#import "SeeProjectDetailsViewController.h"
#import "ELCImagePickerHeader.h"
#import "NSDate+Helper.h"
#import "SuccessProjectViewController.h"

@interface AddProjectDetailsViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,ELCImagePickerControllerDelegate>
@property (nonatomic , strong) UIImagePickerController *imagePicerController;

@property (nonatomic,strong)NSMutableArray *imageUrlArr;
@property (nonatomic,strong)NSMutableArray *addImageArr;
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

- (void)setAssetUrl:(NSString *)assetUrl
{
    objc_setAssociatedObject(self, @selector(assetUrl), assetUrl, OBJC_ASSOCIATION_COPY);
}

- (NSString *)assetUrl
{
    return objc_getAssociatedObject(self, _cmd);
}

@end

@implementation AddProjectDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加项目详情";
    [self setupBarInfo];
    
    if (_uploadCount == 6) {
        _addProjectImageBtn.hidden = YES;
    }else{
        _addProjectImageBtn.hidden = NO;
    }
}

- (NSMutableArray *)addImageArr
{
    if (!_addImageArr) {
        _addImageArr = [NSMutableArray array];
    }
    return _addImageArr;
}

- (NSMutableArray *)imageUrlArr
{
    if (!_imageUrlArr) {
        _imageUrlArr = [NSMutableArray array];
    }
    return _imageUrlArr;
}

- (void)setupBarInfo
{
    [self setupBarButtomItemWithTitle:@"保存" target:self action:@selector(saveBtnClick) leftOrRight:NO];
    [self setupBarButtomItemWithTitle:@" 取消" target:self action:@selector(backBtnClick) leftOrRight:YES];
}
//   取消
- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveBtnClick
{
    if (_addProjectTextView.text.length < 10) {
        [MBProgressHUD showMessag:@"项目介绍过于简短,请输入至少10个字" toView:self.view];
        return;
    }
    
    [MBProgressHUD showStatus:nil toView:self.view];
    [self uploadPhoto];
}

- (void)saveProjectClick
{
    NSString *imagesUrlStr = @"[]";
    if (_imageUrlArr) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:_imageUrlArr options:NSJSONWritingPrettyPrinted error:nil];
        imagesUrlStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
    [self.httpUtil requestDic4MethodName:@"CrowdFund/AddContent" parameters:@{@"CrowdFundId":@(_projectId),@"Content":_addProjectTextView.text,@"Images":imagesUrlStr} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            [MBProgressHUD dismissHUDForView:self.view];
            [MBProgressHUD dismissHUDForView:self.view withSuccess:msg];
//             [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateDetailDataSource" object:nil];
            SuccessProjectViewController *successProjectVC = [SuccessProjectViewController new];
            successProjectVC.showStr = @"您已成功添加项目详情,快去分享给小伙伴们吧";
            successProjectVC.projectId = _projectId;
            successProjectVC.projectStr = _titleStr;
            successProjectVC.contentStr = [NSString stringWithFormat:@"%@\n%@",_projectContentStr,_addProjectTextView.text];
            successProjectVC.type = @"start";
            successProjectVC.myTitle = @"成功添加项目详情";
            successProjectVC.projectArr = _projectImageArr;
            successProjectVC.editType = _editType;
            successProjectVC.uploadCount = _uploadCount + _addImageArr.count;
            successProjectVC.repayCount = _repayCount;
            [self.navigationController pushViewController:successProjectVC animated:YES];
        }else{
            [MBProgressHUD dismissHUDForView:self.view];
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
    }];
}

//  上传照片
- (IBAction)uploadImageBtnClick:(id)sender {
    PSActionSheet *actionSheet = [[PSActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄照片",@"选择照片",nil];
    [actionSheet showInView:self.view];
}
- (IBAction)seeProjectDetailsBtnClick:(id)sender {
    SeeProjectDetailsViewController *seeProjectDetailsVC = [SeeProjectDetailsViewController new];
    seeProjectDetailsVC.contentStr = _projectContentStr;
    [self.navigationController pushViewController:seeProjectDetailsVC animated:YES];
}

//   TextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (IsStrEmpty(textView.text)) {
        _addProjectLab.hidden = NO;
    }else{
        _addProjectLab.hidden = YES;
    }
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
    }else if (buttonIndex == 1)
    {
        // 相册
        ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
        //            elcPicker.navigationBar.titleTextAttributes
        elcPicker.navigationBar.tintColor = [UIColor whiteColor];
        elcPicker.navigationBar.barTintColor = NaviColor;
        elcPicker.maximumImagesCount = 6 - _uploadCount - self.addImageArr.count; //Set the maximum number of images to select to 100
        elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
        elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
        elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
        elcPicker.mediaTypes = @[(NSString *)kUTTypeImage]; //Supports image and movie types
        
        elcPicker.imagePickerDelegate = self;
        
        [self presentViewController:elcPicker animated:YES completion:nil];
    }
}

#pragma mark - ELCImagePickerControllerDelegate Methods
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto)
        {
            UIImage *originalImage = [dict objectForKey:UIImagePickerControllerOriginalImage];
            if (originalImage)
            {
                UIImage* image= [UIImage fixOrientation:originalImage];
                NSURL *imageUrl = [dict objectForKey:UIImagePickerControllerReferenceURL];
                image.assetUrl = imageUrl.absoluteString;
                //                [self.haveImages addObject:image];
                [self.addImageArr addObject:image];
                
                if (_addImageArr.count == 1) {
                    _addProjectImageView.image = _addImageArr[0];
                    _deleteImageBtn.hidden = NO;
                    if (_uploadCount == 4) {
                        _addProjectImageBtn.frame = CGRectMake(110, 308, 85, 85);
                    }else{
                        _addProjectImageBtn.hidden = YES;
                    }
                }else{
                    _addProjectImageView.image = _addImageArr[0];
                    _addProjectImageView2.image = _addImageArr[1];
                    _deleteImageBtn2.hidden = NO;
                    _deleteImageBtn.hidden = NO;
                    _addProjectImageBtn.hidden = YES;
                }
                
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else {
            NSLog(@"Uknown asset type");
        }
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    }
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate & UINavigationControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    UIImage *optionImage = [UIImage fixOrientation:[info objectForKey:@"UIImagePickerControllerEditedImage"]];
    optionImage.isSelected = YES;
    [self.addImageArr addObject:optionImage];
    if (6 - _uploadCount - _addImageArr.count == 0)
    {
        if (_addImageArr.count == 1) {
            _addProjectImageView.image = _addImageArr[0];
            _deleteImageBtn.hidden = NO;
            _addProjectImageBtn.hidden = YES;
        }else if (_addImageArr.count == 2){
            _addProjectImageView2.image = _addImageArr[1];
            _deleteImageBtn2.hidden = NO;
            _addProjectImageBtn.hidden = YES;
        }
    }else
    {
        _addProjectImageView.image = _addImageArr[0];
        _deleteImageBtn.hidden = NO;
        _addProjectImageBtn.frame = CGRectMake(110, 308, 85, 85);
        _addProjectImageBtn.hidden = NO;
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadPhoto{
    [UPYUNConfig sharedInstance].DEFAULT_BUCKET = @"ndzphoto";
    [UPYUNConfig sharedInstance].DEFAULT_PASSCODE = @"T+uMJhbKzocOvPRzLWs2DlqNJOI=";
    __block UpYun *uy = [[UpYun alloc] init];
    
    if (_addImageArr.count == 0) {
        [self saveProjectClick];
        return;
    }else{
        for (int i = 0; i < _addImageArr.count; i ++) {
            dispatch_queue_t urls_queue = dispatch_queue_create("app.mochoujun.com", NULL);
            dispatch_async(urls_queue, ^{
                uy.successBlocker = ^(NSURLResponse *response, id responseData) {
                    NSDictionary *dic = (NSDictionary *)responseData;
                    
                    NSString *imageUrl = [NSString stringWithFormat:@"%@%@", @"http://img.niuduz.com/", dic[@"url"]];
                    [self.imageUrlArr addObject:imageUrl];
                    if (_imageUrlArr.count == _addImageArr.count) {
                        [self saveProjectClick];
                    }
                };
                uy.failBlocker = ^(NSError * error) {
                    NSString *message = [error.userInfo objectForKey:@"message"];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"操作失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    NSLog(@"error %@", message);
                };
                uy.progressBlocker = ^(CGFloat percent, int64_t requestDidSendBytes) {
                };
                NSString *keyStr = [NSString stringWithFormat:@"%@/addProjectImage%d.jpg",[NSDate getNowDateString],i];
                [uy uploadImage:_addImageArr[i] savekey:keyStr];
            });
        }
    }
}
- (IBAction)deleteImageBtnClick:(id)sender {
    
    if (_addImageArr.count == 1) {
        _addProjectImageBtn.hidden = NO;
        _deleteImageBtn.hidden = YES;
        [_addImageArr removeAllObjects];
        _addProjectImageView.image = [UIImage imageNamed:@""];
        _addProjectImageBtn.frame = CGRectMake(17, 308, 85, 85);
    }else{
        _addProjectImageBtn.hidden = NO;
        _deleteImageBtn2.hidden = YES;
        [_addImageArr removeObjectAtIndex:0];
        _addProjectImageView.image = _addImageArr[0];
        _addProjectImageView2.image = [UIImage imageNamed:@""];
        _addProjectImageBtn.frame = CGRectMake(110, 308, 85, 85);
    }
}

- (IBAction)deleteImage2BtnClick:(id)sender {
    _addProjectImageBtn.hidden = NO;
    _deleteImageBtn2.hidden = YES;
    [_addImageArr removeObjectAtIndex:1];
    _addProjectImageView.image = _addImageArr[0];
    _addProjectImageView2.image = [UIImage imageNamed:@""];
    _addProjectImageBtn.frame = CGRectMake(110, 308, 85, 85);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
