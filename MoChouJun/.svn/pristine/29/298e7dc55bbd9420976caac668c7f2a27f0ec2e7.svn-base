//
//  StartProjectViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/2.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "StartProjectViewController.h"
#import "UploadTableViewCell.h"
#import "ReturnDetailsViewController.h"
#import "PSActionSheet.h"
#import "ImageEditingViewController.h"

#import "AudioView.h"
#import <JSONKit.h>
#import "NSString+DocumentPath.h"
#import "ELCImagePickerHeader.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "WeiProjectDetailsViewController.h"
#import "User.h"
#import "UIImage-Extensions.h"
#import "AddReturnViewController.h"
#import "JPUSHService.h"

#import "ReflectUtil.h"
#import "SupportReturn.h"

#import "NSString+Adding.h"
#import "EMAudioRecorderUtil.h"
#import "IQTextView.h"
#import "ProjectDetailsObj.h"

@interface StartProjectViewController ()<UITableViewDataSource,UITableViewDelegate,ELCImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,EMCDDeviceManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *startProjectTableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong, nonatomic) IBOutlet UIView *tableFooterView;

@property (weak, nonatomic) IBOutlet UITextField *projectNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *FinancingTextField;
@property (weak, nonatomic) IBOutlet UITextField *InvestmentTextField;
@property (weak, nonatomic) IBOutlet UITextField *introductionTextField;
@property (weak, nonatomic) IBOutlet IQTextView *projectIntroductTextView;
@property (weak, nonatomic) IBOutlet IQTextView *fundUseTextView;
@property (weak, nonatomic) IBOutlet IQTextView *prosentYouTextView;
@property (nonatomic,strong)NSString *saveClick;
@property (nonatomic,strong)NSMutableArray *returnDetailMutableArr;
@property (nonatomic,strong)NSMutableArray *selectArr;
@property (nonatomic,strong)NSData *recodeData;
@property (nonatomic,strong)NSString *audioPath;

@property (weak, nonatomic) IBOutlet UIButton *previewBtn;
@property (weak, nonatomic) IBOutlet UIButton *publicBtn;
@property (nonatomic,strong)AudioView *audioView;

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong)UIImagePickerController *imagePicerController;
@end

@implementation StartProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.title = @"发起的项目";
    
//    [self backBarItem];
//    duration = 0;
    [self setTableView];
    _selectArr = [NSMutableArray array];
    _saveClick = nil;
    _previewBtn.layer.cornerRadius = 5.0f;
    _publicBtn.layer.cornerRadius = 5.0f;
    _projectIntroductTextView.placeholder = @"详细描述下发起这个项目的目的、项目内容等";
    _fundUseTextView.placeholder = @"众筹的资金在这个项目中如何使用";
    _prosentYouTextView.placeholder = @"我是做什么的，我的联系方式是什么";
    [_projectNameTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [_FinancingTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [_InvestmentTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [_introductionTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
   
    [EMCDDeviceManager sharedInstance].delegate = self;
    
    [self setupBarButtomItemWithImageName:@"nav_back_normal" highLightImageName:nil selectedImageName:nil target:self action:@selector(backUp) leftOrRight:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_startProjectTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[EMCDDeviceManager sharedInstance] disableProximitySensor];// 关闭传感器
}

- (void)dealloc
{
     [EMCDDeviceManager sharedInstance].delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setTableView
{
    _startProjectTableView.tableHeaderView = _tableHeaderView;
    _startProjectTableView.tableFooterView = _tableFooterView;
    
    [_startProjectTableView registerNib:[UINib nibWithNibName:@"UploadTableViewCell" bundle:nil] forCellReuseIdentifier:@"UploadTableViewCell"];
}

#pragma mark - Actions
- (void)Actiondo
{
    [_audioView removeFromSuperview];
}

- (void)textFieldChange:(UITextField *)textField
{
    if (_projectNameTextField.text.length >= 20) {
        _projectNameTextField.text = [_projectNameTextField.text substringToIndex:20];
    }else if (_FinancingTextField.text.length >= 6){
        _FinancingTextField.text = [_FinancingTextField.text substringToIndex:6];
    }else if ([_InvestmentTextField.text intValue] > 60){
        [MBProgressHUD showMessag:@"筹资期限不能超过60天" toView:self.view];
    }else if (_introductionTextField.text.length >= 50){
        _introductionTextField.text = [_introductionTextField.text substringToIndex:50];
    }
}

- (void)backUp
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您所编辑的内容还未发布，确定离开？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 40000;
    [alert show];
}

- (IBAction)addProjectIntroduceClick:(id)sender {
    if (self.returnDetailMutableArr.count == 0) {
        ReturnDetailsViewController *returnDetailsVC = [[ReturnDetailsViewController alloc] init];
        returnDetailsVC.detailArr = _returnDetailMutableArr;
        [self.navigationController pushViewController:returnDetailsVC animated:NO];
        AddReturnViewController *addReturnVC = [[AddReturnViewController alloc] init];
        addReturnVC.delegate = returnDetailsVC;
        [self.navigationController pushViewController:addReturnVC animated:YES];
    }else{
        ReturnDetailsViewController *returnDetailsVC = [[ReturnDetailsViewController alloc] init];
        returnDetailsVC.detailArr = self.returnDetailMutableArr;
        [self.navigationController pushViewController:returnDetailsVC animated:YES];
    }
}

- (IBAction)PreviewClick:(id)sender {
    NSLog(@"----预览");
    if (IsStrEmpty(_projectNameTextField.text) || IsStrEmpty(_FinancingTextField.text) || IsStrEmpty(_InvestmentTextField.text) || IsStrEmpty(_InvestmentTextField.text) || IsStrEmpty(_projectIntroductTextView.text) || IsStrEmpty(_prosentYouTextView.text)|| IsStrEmpty(_fundUseTextView.text)) {
        [MBProgressHUD showMessag:@"填写的信息不完整，请填写完整" toView:self.view];
        return;
    }
    if (_selectArr.count == 0) {
        [MBProgressHUD showMessag:@"您还没有上传项目图片，请上传" toView:self.view];
        return;
    }
    
    if ([_InvestmentTextField.text intValue] > 60) {
        [MBProgressHUD showMessag:@"筹资期限不能超过60天" toView:self.view];
        return;
    }
    
    WeiProjectDetailsViewController *projectDetailsVC = [[WeiProjectDetailsViewController alloc] init];
    [self.navigationController pushViewController:projectDetailsVC animated:YES];
    [projectDetailsVC reviewProjectDetail:[self detailProject] supportReturns:[ReflectUtil reflectDataWithClassName:@"SupportReturn" otherObject:_returnDetailMutableArr isList:YES]];
}

- (IBAction)ReleaseClick:(id)sender {
    NSLog(@"----发布");
    if (IsStrEmpty(_projectNameTextField.text) || IsStrEmpty(_FinancingTextField.text) || IsStrEmpty(_InvestmentTextField.text) || IsStrEmpty(_InvestmentTextField.text) || IsStrEmpty(_projectIntroductTextView.text) || IsStrEmpty(_prosentYouTextView.text)|| IsStrEmpty(_fundUseTextView.text)) {
        [MBProgressHUD showMessag:@"填写的信息不完整，请填写完整" toView:self.view];
        return;
    }
    
    if ([_FinancingTextField.text doubleValue] <= 0.0)
    {
        [MBProgressHUD showMessag:@"融资金额不能为0元" toView:self.view];
        return;
    }
    
    if ([_InvestmentTextField.text integerValue] == 0)
    {
        [MBProgressHUD showMessag:@"筹资期限不能为0天" toView:self.view];
        return;
    }
    
    if ([_FinancingTextField.text doubleValue] < 0.0)
    {
        [MBProgressHUD showMessag:@"请输入正确金额！" toView:self.view];
        return;
    }
    
    if (_selectArr.count == 0) {
        [MBProgressHUD showMessag:@"您还没有上传项目图片，请上传" toView:self.view];
        return;
    }
    
    if ([_InvestmentTextField.text intValue] > 60) {
        [MBProgressHUD showMessag:@"筹资期限不能超过60天" toView:self.view];
        return;
    }

    [self startProjectDataInfo];
}

// 录音方面
- (void)audioBeginBtnClick
{
    //  按住录音
    NSString *recodeFile = [NSString documentPathWith:@"Audio"];
    [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:recodeFile completion:^(NSError *error) {
        //设置定时检测
        _timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
        
        // 设置录音时间
        //        duration = 0;
        //        _timerDuration = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(recordVedioTime) userInfo:nil repeats:YES];
        
    }];
    //
    //    [EMAudioRecorderUtil asyncStartRecordingWithPreparePath:recodeFile completion:^(NSError *error) {
    //        NSLog(@"正在录音");
    //
    //        //设置定时检测
    //        _timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
    //
    //        // 设置录音时间
    //        duration = 0;
    //        _timerDuration = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(recordVedioTime) userInfo:nil repeats:YES];
    //
    //
    //        //设置参数
    //        NSDictionary *settings=[NSDictionary dictionaryWithObjectsAndKeys:
    //                                [NSNumber numberWithFloat:8000],AVSampleRateKey,    //音乐采样率
    //                                [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
    //                                [NSNumber numberWithInt:1],AVNumberOfChannelsKey,//通道的数目
    //                                [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
    //                                [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端 是内存的组织方式
    //                                [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,//采样信号是整数还是浮点
    //                                nil];
    //        NSURL *fileUrl=[NSURL fileURLWithPath:recodeFile];
    //
    //        AVAudioSession *session = [AVAudioSession sharedInstance];
    //        NSError *setCategoryError = nil;
    //        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&setCategoryError];
    //
    //        self.recorder=[[AVAudioRecorder alloc]initWithURL:fileUrl settings:settings error:&error];
    //        [self.recorder prepareToRecord];
    //        [self.recorder setMeteringEnabled:YES];
    //        [self.recorder peakPowerForChannel:0];
    //        [self.recorder record];
    //    }];
}

- (void)detectionVoice
{
    [[EMAudioRecorderUtil recorder] updateMeters];//刷新音量数据
    //    [self.recorder updateMeters];
    //获取音量的平均值  [recorder averagePowerForChannel:0];
    //音量的最大值  [recorder peakPowerForChannel:0];
    
    double lowPassResults = pow(10, (0.05 * [[EMAudioRecorderUtil recorder] peakPowerForChannel:0]));
    //最大50  0
    //图片 小-》大
    [self configRecordingHUDImageWithPeakPower:lowPassResults];
    
}

//- (void)recordVedioTime
//{
//    duration ++;
//}

- (void)configRecordingHUDImageWithPeakPower:(CGFloat)peakPower {
    NSString *imageName = @"Audio-";
    
    if (peakPower >= 0 && peakPower <= 0.1) {
        imageName = [imageName stringByAppendingString:@"1"];
    } else if (peakPower > 0.1 && peakPower <= 0.2) {
        imageName = [imageName stringByAppendingString:@"2"];
    } else if (peakPower > 0.3 && peakPower <= 0.4) {
        imageName = [imageName stringByAppendingString:@"3"];
    } else if (peakPower > 0.4 && peakPower <= 0.5) {
        imageName = [imageName stringByAppendingString:@"4"];
    } else if (peakPower > 0.5 && peakPower <= 0.6) {
        imageName = [imageName stringByAppendingString:@"5"];
    } else if (peakPower > 0.7 && peakPower <= 0.8) {
        imageName = [imageName stringByAppendingString:@"6"];
    } else if (peakPower > 0.8 && peakPower <= 0.9) {
        imageName = [imageName stringByAppendingString:@"7"];
    } else if (peakPower > 0.9 && peakPower <= 1.0) {
        imageName = [imageName stringByAppendingString:@"8"];
    } else if (peakPower > 1.0) {
        imageName = [imageName stringByAppendingString:@"9"];
    }
    self.audioView.audioRecoderImageView.image = [UIImage imageNamed:imageName];
    self.audioView.audioRecoderImageView1.image = [UIImage imageNamed:imageName];
}

- (void)audioFinishBtnClick
{
    [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        if (!error) {
            [_timer invalidate];
            //            [_timerDuration invalidate];
            _audioPath = recordPath;
            UIAlertView *audioShow = [[UIAlertView alloc]initWithTitle:nil message:@"是否要上传" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            audioShow.tag = 10000;
            [audioShow show];
        }
        else {
            [_timer invalidate];
            //            [_timerDuration invalidate];
            //            duration = 0;
            _audioPath = nil;
            [MBProgressHUD showMessag:@"亲，你的录音时间太短了。。" toView:self.view];
            self.audioView.audioRecoderImageView.image = [UIImage imageNamed:@"Audio-0"];
            self.audioView.audioRecoderImageView1.image = [UIImage imageNamed:@"Audio-0"];
            [_startProjectTableView reloadData];
        }
    }];
    
    //    if (duration < 10) {
    //        [EMAudioRecorderUtil asyncStopRecordingWithCompletion:^(NSString *recordPath) {
    //            [_timer invalidate];
    //            [_timerDuration invalidate];
    //            duration = 0;
    //            _audioPath = nil;
    //            [MBProgressHUD showMessag:@"亲，你的录音时间太短了。。" toView:self.view];
    //            self.audioView.audioRecoderImageView.image = [UIImage imageNamed:@"Audio-0"];
    //            self.audioView.audioRecoderImageView1.image = [UIImage imageNamed:@"Audio-0"];
    //            [_startProjectTableView reloadData];
    //        }];
    //    }else{
    //        [EMAudioRecorderUtil asyncStopRecordingWithCompletion:^(NSString *recordPath) {
    //            [_timer invalidate];
    //            [_timerDuration invalidate];
    //            _audioPath = recordPath;
    //            UIAlertView *audioShow = [[UIAlertView alloc]initWithTitle:nil message:@"是否要上传" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    //            audioShow.tag = 10000;
    //            [audioShow show];
    //        }];
    //    }
}

- (NSString *)repayListStr
{
    NSMutableArray *repayList = [NSMutableArray array];
    for (NSDictionary *dic in _returnDetailMutableArr) {
        NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        id images = muDic[@"Images"];
        if ([images isKindOfClass:[NSArray class]])
        {
            muDic[@"Images"] = @([(NSArray *)images count]);
        }
        else
        {
            muDic[@"Images"] = @"0";
        }
        [repayList addObject:muDic];
    }
    
    NSString *repayListStr = @"";
    if (repayList.count)
    {
        NSData *data = [NSJSONSerialization dataWithJSONObject:repayList options:NSJSONWritingPrettyPrinted error:nil];
        repayListStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return repayListStr;
}

#pragma mark - Request
- (void)startProjectDataInfo
{
    
    NSArray *images = [self setImageList];
    
    NSInteger auidoCount;
    if (_recodeData != nil) {
        auidoCount = 1;
    }else{
        auidoCount = 0;
    }

    [MBProgressHUD showStatus:nil toView:self.view];
    NSString *content = [[self contentText] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.httpUtil requestDataMethodName:@"CrowdFund/Post" parameters:@{@"Name":[_projectNameTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"TargetAmount":_FinancingTextField.text,@"DueDays":_InvestmentTextField.text,@"Profile":[_introductionTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"Content":content,@"Images":@(_selectArr.count),@"Audios":@(auidoCount),@"RepayList":[self repayListStr]} datas:images result:^(NSDictionary *obj, int status, NSString *msg) {
        if (status == 1 || status == 2)
        {
            [MBProgressHUD dismissHUDForView:self.view withSuccess:@"发布成功"];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
            
            // 设置 推送别名
            User *userInfo = [User shareUser];
            NSString *crowdFundIdStr = [NSString stringWithFormat:@"%@",[obj valueForKey:@"CrowdFundId"]];
            NSString *tagStr = [NSString stringWithFormat:@"mochoujun_%@",crowdFundIdStr];// mochoujun_项目ID
            [JPUSHService setTags:[NSSet setWithObject:tagStr] aliasInbackground:userInfo.userName];
            
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
    }];
}

- (void)delayMethod{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDeleagte & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"UploadTableViewCell";
    UploadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UploadTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    if (_selectArr.count > 0) {
        // 是否保存&&是否数组个数
        [cell.imageBtn setImage:_selectArr[0] forState:UIControlStateNormal];
        cell.showState = NO;
    }else{
        [cell.imageBtn setImage:nil forState:UIControlStateNormal];
        cell.showState = YES;
    }
    if (_recodeData != nil) {
        [cell.audioBtn setImage:[UIImage imageNamed:@"wifi-3"] forState:UIControlStateNormal];
        cell.showAudioState = NO;
//        cell.showTimeLab.text = [NSString stringWithFormat:@"%ld%@",(long)duration,@"”"];
    }else{
        [cell.audioBtn setImage:nil forState:UIControlStateNormal];
        cell.showAudioState = YES;
    }
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - Image delegate
- (void)uploadImageTableViewCell:(UploadTableViewCell *)cell supportProject:(id)project
{
    [self.view endEditing:YES];
    if (_selectArr.count > 0) {
        ImageEditingViewController *imageEditingVC = [[ImageEditingViewController alloc] init];
        imageEditingVC.sign = @"show";
        imageEditingVC.haveImages = _selectArr;
        [self.navigationController pushViewController:imageEditingVC animated:YES];
    }else{
        PSActionSheet *sheet = [[PSActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选取", nil];
        sheet.tag = 10000;
        [sheet showInView:self.view];
    }
}

#pragma mark -  Audio delegate
- (void)uploadAudioTableViewCell:(UploadTableViewCell *)cell supportProject:(id)project
{
    [self.view endEditing:YES];
    if (_recodeData == nil) {
        _audioView =  [[[NSBundle mainBundle] loadNibNamed:@"AudioView" owner:self options:nil] firstObject];
        [_audioView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo)];
        [_audioView.cancelView addGestureRecognizer:tapGesture];
        
//        [_audioView.audioBtn addTarget:self action:@selector(audioBeginBtnClick) forControlEvents:UIControlEventTouchDown];
//        [_audioView.audioBtn addTarget:self action:@selector(audioFinishBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_audioView];
    }else{
        PSActionSheet *sheet = [[PSActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"上传",@"删除", nil];
        sheet.tag = 20000;
        [sheet showInView:self.view];
    }
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 10000) {
        if (buttonIndex==0) {//相机
            [self showPicSelect];
        }
        if (buttonIndex==1) {//相册
            ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
//            elcPicker.navigationBar.titleTextAttributes
            elcPicker.navigationBar.tintColor = [UIColor whiteColor];
            elcPicker.navigationBar.barTintColor = NaviColor;
            elcPicker.maximumImagesCount = 6; //Set the maximum number of images to select to 100
            elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
            elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
            elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
            elcPicker.mediaTypes = @[(NSString *)kUTTypeImage]; //Supports image and movie types
            
            elcPicker.imagePickerDelegate = self;
            
            [self presentViewController:elcPicker animated:YES completion:nil];
        }
    }else if (actionSheet.tag == 20000){
        if (buttonIndex==0) {//上传
            _audioView =  [[[NSBundle mainBundle] loadNibNamed:@"AudioView" owner:self options:nil] firstObject];
            [_audioView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo)];
            [_audioView.cancelView addGestureRecognizer:tapGesture];
            
//            [_audioView.audioBtn addTarget:self action:@selector(audioBeginBtnClick) forControlEvents:UIControlEventTouchDown];
//            [_audioView.audioBtn addTarget:self action:@selector(audioFinishBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_audioView];
        }
        if (buttonIndex==1) {//删除
            _recodeData = nil;
            [_startProjectTableView reloadData];
        }
    }
}

-(void)showPicSelect{
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

#pragma mark - EMCDDeviceManagerProximitySensorDelegate
- (void)proximitySensorChanged:(BOOL)isCloseToUser
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if (isCloseToUser)
    {
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    } else {
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
    [audioSession setActive:YES error:nil];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10000) {
        if (buttonIndex == 1) {
            _recodeData = [NSData dataWithContentsOfFile:_audioPath];
            NSLog(@"%zd",_recodeData.length);
            [_audioView removeFromSuperview];
        }
        else
        {
            _audioPath = nil;
        }
        
        self.audioView.audioRecoderImageView.image = [UIImage imageNamed:@"Audio-0"];
        self.audioView.audioRecoderImageView1.image = [UIImage imageNamed:@"Audio-0"];
        [_startProjectTableView reloadData];
    }else if (alertView.tag == 40000){
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark -  选取图片后的回调
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    UIImageView *Imageview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0,320, 320)];
//    Imageview.image=[info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *changeImage = [UIImage fixOrientation:[info objectForKey:UIImagePickerControllerEditedImage]];
    
    if (_selectArr.count < 6) {
        [_selectArr addObject:changeImage];
    }else{
        [MBProgressHUD showMessag:@"您最多只能选择6张图片!" toView:self.view];
    }
    [_startProjectTableView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ELCImagePickerControllerDelegate Methods
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];

    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image= [UIImage fixOrientation:[dict objectForKey:UIImagePickerControllerOriginalImage]];
                [images addObject:image];
                
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else {
            NSLog(@"Uknown asset type");
        }
    }
    
    _selectArr = images;
    [_startProjectTableView reloadData];
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

- (NSString *)contentText
{
    ;
    NSMutableString *content = [NSMutableString stringWithFormat:@"【项目介绍】|||%@###===",[_projectIntroductTextView.text stringByReplacingOccurrencesOfString:@"\n" withString:@"###"]];
    [content appendFormat:@"【筹款用途】|||%@###===",[_fundUseTextView.text stringByReplacingOccurrencesOfString:@"\n" withString:@"###"]];
    [content appendFormat:@"【介绍自己】|||%@",[_prosentYouTextView.text stringByReplacingOccurrencesOfString:@"\n" withString:@"###"]];
    return content;
}

#pragma mark - Setter & Getter

- (NSMutableArray *)returnDetailMutableArr
{
    if (!_returnDetailMutableArr)
    {
        _returnDetailMutableArr = [NSMutableArray array];
    }
    return _returnDetailMutableArr;
}

- (ProjectDetailsObj *)detailProject
{
   return [ReflectUtil reflectDataWithClassName:@"ProjectDetailsObj" otherObject:[self setImageDic]];
}

- (NSDictionary *)setImageDic
{
    NSString *content = [self contentText];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"Name"] = _projectNameTextField.text;
    dic[@"TargetAmount"] = _FinancingTextField.text;
    dic[@"RaisedAmount"] = @"0";
    dic[@"NickName"] = [User shareUser].userName;
    dic[@"Avatar"] = [User shareUser].avatar;
    dic[@"RemainDays"] = _InvestmentTextField.text;
    dic[@"Profile"] = _introductionTextField.text;
    dic[@"Content"] = content;
    dic[@"Images"] = @"";
    dic[@"StatusId"] = @"-1";
    dic[@"ShowStatus"] = [NSString stringWithFormat:@"剩余%@天",_InvestmentTextField.text];
    
    if (_recodeData != nil)
    {
        dic[@"Audios"] = _audioPath;
        dic[@"FilePath"] = _audioPath;
    }
    else
    {
        dic[@"Audios"] = @"";
    }
   
    if (_selectArr.count)
    {
        dic[@"ReviewImages"] = _selectArr;
    }
    
    return dic;
}

- (NSMutableArray *)setImageList
{
    NSMutableArray *allImage = [NSMutableArray array];
    //  判断音频
    if (_recodeData != nil) {
        [allImage addObject:_recodeData];
    }
    //  判断项目图片
    if (_selectArr.count > 0) {
        for (int i = 0; i < _selectArr.count; i ++) {
            [allImage addObject:_selectArr[i]];
        }
    }
    //  判断回报图片
    if (_returnDetailMutableArr.count > 0) {
        for (int j = 0; j < _returnDetailMutableArr.count; j ++) {
            NSDictionary *support = _returnDetailMutableArr[j];
            id images = [support valueForKey:@"Images"];
            if ([images isKindOfClass:[NSArray class]]) {
                NSUInteger count = [(NSArray *)images count];
                if (count) {
                    for (int k = 0; k < count; k ++) {
                        [allImage addObject:(NSArray *)images[k]];
                    }
                }
            }
        }
    }
    return allImage;
}

- (UIImagePickerController *)imagePicerController
{
    if (!_imagePicerController)
    {
        _imagePicerController = [[UIImagePickerController alloc]init];
        _imagePicerController.navigationBar.tintColor = [UIColor colorWithHexString:@"#2B2B2B"];
        _imagePicerController.navigationBar.barTintColor = NaviColor;
        _imagePicerController.delegate = self;
        [_imagePicerController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#2B2B2B"]}];
        _imagePicerController.allowsEditing = YES;
        
    }
    return _imagePicerController;
}

//修改照片尺寸
-(UIImage *)changeImageviewSize:(UIImageView *)Imageview{
    UIGraphicsBeginImageContext(Imageview.bounds.size);
    [Imageview.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
