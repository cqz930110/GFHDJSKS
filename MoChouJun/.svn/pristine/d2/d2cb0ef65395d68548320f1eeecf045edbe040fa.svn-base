//
//  InitiateProjectViewController.m
//  WeiPublicFund
//
//  Created by zhoupushan on 16/3/21.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "InitiateProjectViewController.h"
#import "PSTextView.h"
#import "OptionResourceView.h"
#import "NSString+Adding.h"
#import "RecordedView.h"
#import "IQKeyboardManager.h"
#import "ELCImagePickerHeader.h"
#import "UIImage-Extensions.h"
//#import "UploadProjectData.h"
static const CGFloat kTextViewTopMargin = 5;
static const CGFloat kTitleTextMaxLength = 60;
static const CGFloat kTitleTextViewDefaultHeight = 45;
static const CGFloat kContentTextViewDefaultHeight = 117;
@interface InitiateProjectViewController ()<UITextViewDelegate,OptionResourceViewDelegate,UIActionSheetDelegate,ELCImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet PSTextView *titleTextView;
@property (weak, nonatomic) IBOutlet PSTextView *contentTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleViewHeightConstraint;//45
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTextViewHeightConstraint;
@property (weak, nonatomic) IBOutlet OptionResourceView *optionResourceView;

@property (weak, nonatomic) IBOutlet RecordedView *recordedView;

@property (assign, nonatomic)CGFloat contentTextVeiwMaxHeight;

@property (nonatomic,strong)UIImagePickerController *imagePicerController;
@property (nonatomic,strong)ELCImagePickerController *elcPicker;
@end

@implementation InitiateProjectViewController

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    _optionResourceView.delegate = self;
//    [self setupNavi];
//    [self setupTextView];
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//
//- (void)dealloc
//{
////    [[UploadProjectData shareInstance] clearData];
//}
//
//#pragma mark - KeyboardNotification
//- (void)keyboardChange:(NSNotification *)noti
//{
//    CGRect rect  = [noti.userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
//    self.contentTextVeiwMaxHeight = SCREEN_HEIGHT - _titleViewHeightConstraint.constant - rect.size.height - 64 - 43 - 43;
//}
//
//#pragma mark - Set Up Init
//- (void)setupNavi
//{
//    self.title = @"发起的项目";
//    [self backBarItem];
//}
//
//- (void)setupTextView
//{
//    _titleTextView.contentInset = UIEdgeInsetsMake(kTextViewTopMargin, 0, 0, 0);
//    _contentTextView.contentInset = UIEdgeInsetsMake(kTextViewTopMargin, 0, 0, 0);
//    _titleTextView.placeholder = @"输入项目标题,60个字符内";
//    _contentTextView.placeholder = @"项目内容介绍，2000个字符内";
//}
//
//#pragma mark - OptionResourceViewDelegate
//- (void)optionResourceClikeImage:(OptionResourceView *)optionResourceView
//{
//    [self.view endEditing:YES];
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选取", nil];
//    sheet.tag = 10000;
//    [sheet showInView:self.view];
//
//}
//
//- (void)optionResourceClikeRecord:(OptionResourceView *)optionResourceView
//{
//    
//}
//
//#pragma mark - UIActionSheetDelegate
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (actionSheet.tag == 10000) {
//        if (buttonIndex==0) {//相机
//            [self cameraAction];
//        }
//        if (buttonIndex==1) {//相册
//            [self photoAlbumAction];
//        }
//    }else if (actionSheet.tag == 20000){
//        
//    }
//}
//
//#pragma mark - Action
//- (void)photoAlbumAction
//{
//    self.elcPicker.maximumImagesCount = 6 - [UploadProjectData shareInstance].images.count;
//    if (_elcPicker.childViewControllers.count > 0)
//    {
//        [_elcPicker popViewControllerAnimated:NO];
//    }
//    [self presentViewController:_elcPicker animated:YES completion:nil];
//}
//
//- (void)cameraAction
//{
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//    {
//        self.imagePicerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//        self.imagePicerController.showsCameraControls = YES;//takePicture
//        [self presentViewController:self.imagePicerController animated:YES completion:nil];
//    }
//    else
//    {
//        ULog(@"设备不支持");
//    }
//}
//
//#pragma mark - UIImagePickerControllerDelegate
//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    // 转换图片
//    UIImage *changeImage = [UIImage fixOrientation:[info objectForKey:UIImagePickerControllerEditedImage]];
//    if ([UploadProjectData shareInstance].images.count < 6) {
//        [[UploadProjectData shareInstance].images addObject:changeImage];
//    }else{
//        [MBProgressHUD showMessag:@"您最多只能选择6张图片!" toView:self.view];
//    }
//    [_optionResourceView reloadData];
//    _recordedView.hidden = NO;
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}
//
//#pragma mark - ELCImagePickerControllerDelegate Methods
//- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//    
//    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
//    for (NSDictionary *dict in info) {
//        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
//            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
//                UIImage* image= [UIImage fixOrientation:[dict objectForKey:UIImagePickerControllerOriginalImage]];
//                [images addObject:image];
//                
//            } else {
//                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
//            }
//        } else {
//            NSLog(@"Uknown asset type");
//        }
//    }
//    [[UploadProjectData shareInstance].images addObjectsFromArray:images];
//    [_optionResourceView reloadData];
//    _recordedView.hidden = NO;
//}
//
//- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//#pragma mark - UITextViewDelegate
//- (void)textViewDidChange:(UITextView *)textView
//{
//    if (textView == _titleTextView)
//    {
//        if (_titleTextView.text.length > kTitleTextMaxLength )
//        {
//            _titleTextView.text = [_titleTextView.text substringToIndex:kTitleTextMaxLength - 1];
//        }
//        else
//        {
//            CGSize size = [_titleTextView.text sizeWithFont:_titleTextView.font constrainedSize:CGSizeMake(SCREEN_WIDTH, 999)];
//            CGFloat sizeHeight = size.height + 25;
//            _titleViewHeightConstraint.constant = sizeHeight > kTitleTextViewDefaultHeight?sizeHeight:kTitleTextViewDefaultHeight;
//        }
//    }
//    else
//    {
//        CGSize size = [_contentTextView.text sizeWithFont:_contentTextView.font constrainedSize:CGSizeMake(SCREEN_WIDTH, 10000)];
//        CGFloat sizeHeight = size.height + 30;
//        if (sizeHeight < kContentTextViewDefaultHeight)
//        {
//            _contentTextViewHeightConstraint.constant = kContentTextViewDefaultHeight;
//        }
//        else
//        {
//            
//            if (sizeHeight < _contentTextVeiwMaxHeight)
//            {
//                _contentTextViewHeightConstraint.constant =  sizeHeight;
//            }
//            else
//            {
//                _contentTextViewHeightConstraint.constant =  _contentTextVeiwMaxHeight;
//            }
//        }
//    }
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView.contentOffset.y > -kTextViewTopMargin)
//    {
//        if (scrollView == _contentTextView)
//        {
//            // 216是键盘的高度  64 navi 43*2 下面的view
//            CGFloat contentTextViewHeight = _contentTextViewHeightConstraint.constant;
//            if (contentTextViewHeight < _contentTextVeiwMaxHeight)
//            {
//                scrollView.contentOffset = CGPointMake(0, -kTextViewTopMargin);
//            }
//        }
//        else
//        {
//            scrollView.contentOffset = CGPointMake(0, -kTextViewTopMargin);
//        }
//    }
//}
//
//#pragma mark - Setter
//- (UIImagePickerController *)imagePicerController
//{
//    if (!_imagePicerController)
//    {
//        _imagePicerController = [[UIImagePickerController alloc]init];
//        _imagePicerController.navigationBar.tintColor = [UIColor colorWithHexString:@"#2B2B2B"];
//        _imagePicerController.navigationBar.barTintColor = NaviColor;
//        _imagePicerController.delegate = self;
//        [_imagePicerController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#2B2B2B"]}];
//        _imagePicerController.allowsEditing = YES;
//        
//    }
//    return _imagePicerController;
//}
//
//- (ELCImagePickerController *)elcPicker
//{
//    if (!_elcPicker)
//    {
//        _elcPicker = [[ELCImagePickerController alloc] initImagePicker];
//        _elcPicker.navigationBar.tintColor = [UIColor whiteColor];
//        _elcPicker.navigationBar.barTintColor = NaviColor;
////        _elcPicker.maximumImagesCount = 6; //Set the maximum number of images to select to 100
//        _elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
//        _elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
//        _elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
//        _elcPicker.mediaTypes = @[(NSString *)kUTTypeImage]; //Supports image and movie types
//        
//        _elcPicker.imagePickerDelegate = self;
//    }
//    return _elcPicker;
//}
@end
