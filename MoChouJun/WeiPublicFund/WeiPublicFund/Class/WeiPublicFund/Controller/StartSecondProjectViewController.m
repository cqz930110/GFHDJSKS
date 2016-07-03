//
//  StartSecondProjectViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 16/4/6.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "StartSecondProjectViewController.h"
#import "AddProjectReturnViewController.h"
#import "ProjectReturnViewController.h"
#import "User.h"
#import "JPUSHService.h"
#import "WeiProjectDetailsViewController.h"
#import "ReflectUtil.h"
#import "SupportReturn.h"
#import "ProjectDetailsObj.h"
#import "MMAlertView.h"
#import "MMPopupItem.h"
#import "NSDate+Helper.h"
#import "ZHBPickerView.h"
#import "UpYun.h"
#import "SuccessProjectViewController.h"
#import "NSDate+Helper.h"


@interface StartSecondProjectViewController ()<UITextViewDelegate,ProjectReturnViewControllerDelegate,UITextFieldDelegate,ZHBPickerViewDataSource,ZHBPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UILabel *dataLab;

@property (weak, nonatomic) IBOutlet UILabel *addStateLab;
@property (weak, nonatomic) IBOutlet UIButton *startProjectBtn;

@property (nonatomic,strong)NSMutableArray *returnDetailsArr;

@property (nonatomic,assign)BOOL deleteLastImage;
@property (nonatomic,strong)ZHBPickerView *zhBPickerView;
@property (nonatomic,strong)NSMutableArray *dateArr;
@property (nonatomic,assign)BOOL zhBPickBool;
@property (nonatomic,strong)UIWindow *window;

@property (nonatomic,strong)UIBarButtonItem *myButton2;
@property (nonatomic,assign)NSInteger returnNum;
@property (nonatomic,strong)NSMutableArray *returnImageUrlArr;

@property (nonatomic,strong)NSMutableArray *startImageArr;
@property (nonatomic,strong)NSMutableArray *startImageUrlArr;

@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSDictionary *successProjectDic;

@property (nonatomic,strong)NSMutableArray *returnImgMutableArr;

@end

@implementation StartSecondProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarItem];
    self.title = @"筹款设置";
    _returnNum = 0;
    _deleteLastImage = NO;
    _zhBPickBool = NO;
    _dateArr = [NSMutableArray array];
    _successProjectDic = [NSDictionary dictionary];
    _window = [[[UIApplication sharedApplication] windows] lastObject];
    [self setInfo];
    
    _startProjectBtn.layer.cornerRadius = 5.0f;
    [_amountTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self getDateInfo];
    
    self.startImageArr = [_startProjectDic objectForKey:@"ProjectImages"];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_returnDetailsArr.count == 0) {
        _addStateLab.text = @"未添加";
        _addStateLab.textColor = [UIColor colorWithHexString:@"#6E6E6E"];
    }
}

- (NSMutableArray *)startImageArr
{
    if (!_startImageArr) {
        _startImageArr = [[NSMutableArray alloc]init];
    }
    return _startImageArr;
}

- (NSMutableArray *)returnImgMutableArr
{
    if (!_returnImgMutableArr) {
        _returnImgMutableArr = [[NSMutableArray alloc]init];
    }
    return _returnImgMutableArr;
}

- (NSMutableArray *)startImageUrlArr
{
    if (!_startImageUrlArr) {
        _startImageUrlArr = [[NSMutableArray alloc]init];
    }
    return _startImageUrlArr;
}

- (NSMutableArray *)returnImageUrlArr
{
    if (!_returnImageUrlArr) {
        _returnImageUrlArr = [[NSMutableArray alloc]init];
    }
    return _returnImageUrlArr;
}

- (NSMutableArray *)returnDetailsArr
{
    if (!_returnDetailsArr)
    {
        _returnDetailsArr = [NSMutableArray arrayWithCapacity:7];
    }
    return _returnDetailsArr;
}

- (ProjectDetailsObj *)detailProject
{
    return [ReflectUtil reflectDataWithClassName:@"ProjectDetailsObj" otherObject:[self setImageDic]];
}

- (void)textFieldChange:(UITextField *)textField
{
    if (textField == _amountTextField)
    {
        if ([_amountTextField.text intValue] > 100000)
        {
            _amountTextField.text = @"100000";
            [MBProgressHUD showMessag:@"融资金额不要大于100000元" toView:self.view];
        }
        else if ([_amountTextField.text intValue] <= 0)
        {
            _amountTextField.text = @"";
        }
        
        if ([_amountTextField.text intValue] > 0) {
            [_myButton2 setTintColor:[UIColor colorWithHexString:@"#2B2B2B"]];
            _myButton2.enabled = YES;
        }else{
            if ([_amountTextField.text intValue] <= 0 && [_dataLab.text isEqual:@"请选择"] && [_addStateLab.text isEqual:@"未添加"]) {
                [_myButton2 setTintColor:[UIColor colorWithHexString:@"#AAAAAA"]];
                _myButton2.enabled = NO;
            }
        }
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [_zhBPickerView removeFromSuperview];
}

- (void)setInfo
{
    [self setBarButtonItems];
    [self setBarLeftButtonItems];
    
    [_amountTextField setValue:[UIColor colorWithHexString:@"#DEDFE0"] forKeyPath:@"_placeholderLabel.textColor"];
    
    if (_returnAllDic) {
        if ([[_returnAllDic objectForKey:@"TargetAmount"] intValue] == 0) {
            _amountTextField.text = @"";
        }else{
            _amountTextField.text = [NSString stringWithFormat:@"%@",[_returnAllDic objectForKey:@"TargetAmount"]];
        }
        
        _dataLab.text = [_returnAllDic objectForKey:@"DueDays"];
        if (![_dataLab.text isEqual:@"请选择"]) {
            _dataLab.textColor = [UIColor colorWithHexString:@"#2B2B2B"];
        }
        _addStateLab.text = [_returnAllDic objectForKey:@"ReturnCount"];
        if (![_addStateLab.text isEqual:@"请选择"]) {
            _addStateLab.textColor = [UIColor colorWithHexString:@"#2B2B2B"];
        }
        
        if ([[_returnAllDic objectForKey:@"Return"] isKindOfClass:[NSMutableArray class]]) {
            [_returnDetailsArr removeAllObjects];
            
            _returnDetailsArr = [_returnAllDic objectForKey:@"Return"];
        }
    }

}

- (void)setBarLeftButtonItems{
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, 0, 44, 44);
//    [button setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(backNext) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    [self setupBarButtomItemWithImageName:@"fanhui" highLightImageName:nil selectedImageName:nil target:self action:@selector(backNext) leftOrRight:YES];
}

- (void)setBarButtonItems
{
    UIBarButtonItem *myButton1 = [[UIBarButtonItem alloc] initWithTitle:@"预览" style:UIBarButtonItemStyleBordered target:self action:@selector(yulanBtnClick)];
    myButton1.width = 40;
    [myButton1 setTintColor:[UIColor colorWithHexString:@"#2B2B2B"]];
    
    _myButton2 = [[UIBarButtonItem alloc]initWithTitle:@"草稿" style:UIBarButtonItemStyleBordered
        target:self action:@selector(draftBtnClick)];
    _myButton2.width = 60;
    [_myButton2 setTintColor:[UIColor colorWithHexString:@"#AAAAAA"]];
    _myButton2.enabled = NO;
    
    self.navigationItem.rightBarButtonItems = @[myButton1,_myButton2];
}
//    more预览
- (void)yulanBtnClick
{
    if ([_amountTextField.text intValue] <= 0) {
        [MBProgressHUD showMessag:@"请填写目标金额" toView:self.view];
        return;
    }
    
    if ([_amountTextField.text intValue] > 100000) {
        [MBProgressHUD showMessag:@"融资金额不要大于100000元" toView:self.view];
        return;
    }
    if ([_dataLab.text isEqual:@"请选择"]){
        [MBProgressHUD showMessag:@"您还没有选择截止日期哦" toView:self.view];
        return;
    }
    
    WeiProjectDetailsViewController *projectDetailsVC = [[WeiProjectDetailsViewController alloc] init];
    [self.navigationController pushViewController:projectDetailsVC animated:YES];
    [projectDetailsVC reviewProjectDetail:[self detailProject] supportReturns:[ReflectUtil reflectDataWithClassName:@"SupportReturn" otherObject:_returnDetailsArr isList:YES]];
}

//  草稿
- (void)draftBtnClick
{
    _type = @"草稿";
    [MBProgressHUD showStatus:nil toView:self.view];

    if (_draftProjectDic) {
        [self repayListStr];
    }else{
        [self uploadPhoto];
    }
}

- (void)draftUpload
{
    NSString *imageUrl = @"";
    NSLog(@"-----%@",_draftProjectDic);
    if (_draftProjectDic) {
        //   第一步保存草稿的图片链接
        NSMutableArray *imageUrlArr = [_draftProjectDic objectForKey:@"ProjectImages"];
        NSData *data = [NSJSONSerialization dataWithJSONObject:imageUrlArr options:NSJSONWritingPrettyPrinted error:nil];
        imageUrl = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }else{
        NSData *data = [NSJSONSerialization dataWithJSONObject:_startImageUrlArr options:NSJSONWritingPrettyPrinted error:nil];
        imageUrl = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
    NSString *dateStr;
    if ([_dataLab.text isEqual:@"请选择"]) {
        dateStr = @"";
    }else{
        dateStr = [_dataLab.text substringFromIndex:14];
        dateStr = [dateStr substringToIndex:dateStr.length - 1];
    }
    
    NSString *returnListStr = @"";
    if (_returnImageUrlArr) {
        NSData *returnData = [NSJSONSerialization dataWithJSONObject:_returnImageUrlArr options:NSJSONWritingPrettyPrinted error:nil];
        returnListStr = [[NSString alloc]initWithData:returnData encoding:NSUTF8StringEncoding];
    }

    [self.httpUtil requestDic4MethodName:@"Draft/Save" parameters:@{@"DraftId":@(_draftId),@"Name":[_startProjectDic objectForKey:@"Title"],@"Content":[_startProjectDic objectForKey:@"Introduct"],@"Images":imageUrl,@"TargetAmount":_amountTextField.text,@"DueDays":dateStr,@"RepayList":returnListStr} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {

            [MBProgressHUD dismissHUDForView:self.view];
            if (_draftId) {
                [MBProgressHUD showMessag:@"已保存草稿" toView:self.view];
            }else{
//                MMAlertViewConfig *config = [MMAlertViewConfig globalConfig];
//                config.splitColor = [UIColor colorWithHexString:@"E5E5E5"];
//                config.itemHighlightColor = [UIColor colorWithHexString:@"#3194FF"];
//                NSArray *items = @[MMItemMake(@"我知道了", MMItemTypeHighlight, nil)];
//                
//                MMAlertView *alertView = [[MMAlertView alloc]initWithTitle:@"已保存草稿" detail:@"注：您可至“我的”－“我的草稿”中查看项目草稿，如该项目成功发布，将不保留该项目的草稿" items:items];
//                alertView.attachedView = self.view;
//                [alertView show];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"已保存草稿" message:@"注：您可至“我的”－“我的草稿”中查看项目草稿，如该项目成功发布，将不保留该项目的草稿" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                [alert show];
            }

            _myButton2.enabled = NO;
            [_myButton2 setTintColor:[UIColor colorWithHexString:@"#AAAAAA"]];
        }else{
            [MBProgressHUD showError:msg toView:self.view];
            _myButton2.enabled = YES;
            [_myButton2 setTintColor:[UIColor colorWithHexString:@"#2B2B2B"]];
        }
    }];
}

//   返回上一步
- (void)backNext
{
    [_zhBPickerView removeFromSuperview];
    
    NSDictionary *dic;
    
    if (_returnDetailsArr) {
        dic = @{@"TargetAmount":_amountTextField.text,
                @"DueDays":_dataLab.text,
                @"ReturnCount":_addStateLab.text,
                @"Return":_returnDetailsArr};
    }else{
        dic = @{@"TargetAmount":_amountTextField.text,
                @"DueDays":_dataLab.text,
                @"ReturnCount":_addStateLab.text,
                @"Return":@""};
    }
    
    
    if ([self.delegate respondsToSelector:@selector(startSecondProjectViewInfo:)]) {
        [self.delegate startSecondProjectViewInfo:dic];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//  选择截止日期
- (IBAction)dataClickEvent:(id)sender {
    [_amountTextField resignFirstResponder];
    if (_zhBPickBool == NO) {
        _zhBPickBool = YES;
        _zhBPickerView =  [[[NSBundle mainBundle] loadNibNamed:@"ZHBPickerView" owner:self options:nil] firstObject];
        
        _zhBPickerView.dataSource = self;
        _zhBPickerView.delegate = self;
        _zhBPickerView.frame = CGRectMake(0, SCREEN_HEIGHT - 200, SCREEN_WIDTH, 200);
        [_window addSubview:_zhBPickerView];
    }else{
        _zhBPickBool = NO;
        [_zhBPickerView removeFromSuperview];
    }
    
}

//  跳转到添加众筹
- (IBAction)raisePeriodClick:(id)sender {
    
    [_zhBPickerView removeFromSuperview];
    
    ProjectReturnViewController *projectVC = [ProjectReturnViewController new];
    projectVC.delegate = self;
    projectVC.detailArr = self.returnDetailsArr;
    [self.navigationController pushViewController:projectVC animated:YES];
    
}

//   条约
- (IBAction)treatyBtnClick:(id)sender {
    
    NSLog(@"-----链接");
}

//  发起众筹
- (IBAction)startProjectClick:(id)sender
{
    if (IsStrEmpty(_amountTextField.text)) {
        [MBProgressHUD showMessag:@"请填写目标金额" toView:self.view];
        return;
    }

    if ([_amountTextField.text intValue] > 100000) {
        [MBProgressHUD showMessag:@"融资金额不要大于100000元" toView:self.view];
        return;
    }
    if ([_dataLab.text isEqual:@"请选择"]){
        [MBProgressHUD showMessag:@"您还没有选择截止日期哦" toView:self.view];
        return;
    }
    _type = @"发布";
    [self startProjectDataInfo];
}

- (void)startProjectDataInfo
{
    [MBProgressHUD showStatus:nil toView:self.view];
    
    if (_draftProjectDic) {
        [self repayListStr];
    }else{
        [self uploadPhoto];
    }
}

//  发布没有保存到草稿箱项目
- (void)noDraftUploadProject
{
    NSString *imageUrl = @"";
    if (_draftProjectDic) {
        //   第一步保存草稿的图片链接
        NSMutableArray *imageUrlArr = [_draftProjectDic objectForKey:@"ProjectImages"];
        NSData *data = [NSJSONSerialization dataWithJSONObject:imageUrlArr options:NSJSONWritingPrettyPrinted error:nil];
        imageUrl = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }else{
        NSData *data = [NSJSONSerialization dataWithJSONObject:_startImageUrlArr options:NSJSONWritingPrettyPrinted error:nil];
        imageUrl = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    
    NSString *dateStr;
    if ([_dataLab.text isEqual:@"请选择"]) {
        dateStr = @"";
    }else{
        dateStr = [_dataLab.text substringFromIndex:14];
        dateStr = [dateStr substringToIndex:dateStr.length - 1];
    }
    NSString *returnListStr = @"";
    if (_returnImageUrlArr) {
        NSData *returnData = [NSJSONSerialization dataWithJSONObject:_returnImageUrlArr options:NSJSONWritingPrettyPrinted error:nil];
        returnListStr = [[NSString alloc]initWithData:returnData encoding:NSUTF8StringEncoding];
    }
    
    
    [self.httpUtil requestDic4MethodName:@"CrowdFund/Publish" parameters:@{@"DraftId":@(_draftId),@"Name":[_startProjectDic objectForKey:@"Title"],@"Content":[_startProjectDic objectForKey:@"Introduct"],@"Images":imageUrl,@"TargetAmount":_amountTextField.text,@"DueDays":dateStr,@"RepayList":returnListStr} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            _successProjectDic = dic;
            [MBProgressHUD dismissHUDForView:self.view];

            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
            
            // 设置 推送别名
            User *userInfo = [User shareUser];
            NSString *crowdFundIdStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"CrowdFundId"]];
            NSString *tagStr = [NSString stringWithFormat:@"mochoujun_%@",crowdFundIdStr];// mochoujun_项目ID
            [JPUSHService setTags:[NSSet setWithObject:tagStr] aliasInbackground:userInfo.userName];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateStartProject" object:nil];
        }else{
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
    }];
}

- (void)delayMethod{
    // 刷新微众筹列表
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateWeiProject" object:nil];
    SuccessProjectViewController *successProjectVC = [SuccessProjectViewController new];
    successProjectVC.projectId = [[_successProjectDic objectForKey:@"CrowdFundId"] integerValue];
    successProjectVC.projectStr = [_startProjectDic objectForKey:@"Title"];
    successProjectVC.type = @"start";
    if (_draftProjectDic) {
        successProjectVC.projectArr = [_draftProjectDic objectForKey:@"ProjectImages"];
    }else{
        successProjectVC.projectArr = _startImageUrlArr;
    }
    [self.navigationController pushViewController:successProjectVC animated:YES];
}

//- (NSString *)contentText
//{
//    NSMutableString *content = [NSMutableString stringWithFormat:@"%@",[[_startProjectDic objectForKey:@"Introduct"] stringByReplacingOccurrencesOfString:@"\n" withString:@"###"]];
//    return content;
//}

//   回报数据处理
- (void)repayListStr
{
    _returnNum ++;
    [UPYUNConfig sharedInstance].DEFAULT_BUCKET = @"ndzphoto";
    [UPYUNConfig sharedInstance].DEFAULT_PASSCODE = @"T+uMJhbKzocOvPRzLWs2DlqNJOI=";
    __block UpYun *uy = [[UpYun alloc] init];
    
    if (_returnDetailsArr.count == 0) {
        if ([_type isEqual:@"草稿"]) {
            [self draftUpload];
        }else if ([_type isEqual:@"发布"]){
            [self noDraftUploadProject];
        }
    }else{
        for (int i = 0;i < _returnDetailsArr.count;i ++) {
            NSDictionary *dic1 = _returnDetailsArr[i];
            NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:dic1];
            id images = muDic[@"ImgList"];
            if ([images isKindOfClass:[NSString class]]) {
                [self.returnImgMutableArr addObject:images];
            }else{
                NSString *imageKey = [NSString stringWithFormat:@"%@/returnImage%ld.jpg",[NSDate getNowDateString],(long)_returnNum];
                [uy uploadImage:images[0] savekey:imageKey];
                
                dispatch_queue_t urls_queue = dispatch_queue_create("app.mochoujun.com", NULL);
                dispatch_async(urls_queue, ^{
                    uy.successBlocker = ^(NSURLResponse *response, id responseData) {
                        
                        NSDictionary *dic = (NSDictionary *)responseData;
                        NSString *returnImageUrl = [NSString stringWithFormat:@"%@%@", @"http://img.niuduz.com/", dic[@"url"]];
                        [self.returnImgMutableArr addObject:returnImageUrl];
                        
                        
                        if (_returnImgMutableArr.count == _returnDetailsArr.count){
                            for (int i = 0 ; i < _returnDetailsArr.count ;i ++) {
                                NSDictionary *dic2 = _returnDetailsArr[i];
                                NSMutableDictionary *muDic1 = [NSMutableDictionary dictionaryWithDictionary:dic2];
                                NSArray *arr = @[_returnImgMutableArr[i]];
                                muDic1[@"ImgList"] = arr;
                                [self.returnImageUrlArr addObject:muDic1];
                            }
                            if ([_type isEqual:@"草稿"]) {
                                [self draftUpload];
                            }else if ([_type isEqual:@"发布"]){
                                [self noDraftUploadProject];
                            }
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
                    
                });
            }
        }
    }
}

- (NSDictionary *)setImageDic
{
    NSString *dateStr = [_dataLab.text substringFromIndex:14];
    dateStr = [dateStr substringToIndex:dateStr.length - 1];
    NSString *content = [_startProjectDic objectForKey:@"Introduct"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"Name"] = [_startProjectDic objectForKey:@"Title"];
    dic[@"TargetAmount"] = _amountTextField.text;
    dic[@"RaisedAmount"] = @"0";
    dic[@"NickName"] = [User shareUser].nickName;
    dic[@"Avatar"] = [User shareUser].avatar;
    dic[@"RemainDays"] = dateStr;
    dic[@"Profile"] = nil;
    dic[@"Content"] = content;
    dic[@"ImgList"] = @"";
    dic[@"StatusId"] = @"-1";
    dic[@"ShowStatus"] = [NSString stringWithFormat:@"剩余%@天",dateStr];

    NSArray *imageArr = [_startProjectDic objectForKey:@"ProjectImages"];
    NSMutableArray *imagesArr = [NSMutableArray array];
    for (int i = 0; i < imageArr.count - 1; i ++) {
        [imagesArr addObject:imageArr[i]];
    }
    if (imageArr.count > 1)
    {
        dic[@"ReviewImages"] = imagesArr;
    }
    return dic;
}

- (void)returnSavedReturnUserInfo:(NSMutableArray *)userArr
{
    _returnDetailsArr = userArr;
    NSLog(@"------%@=====%lu",userArr,(unsigned long)userArr.count);
    if (userArr.count == 0) {
        _addStateLab.text = @"未添加";
        _addStateLab.textColor = [UIColor colorWithHexString:@"#6E6E6E"];
        if ([_amountTextField.text intValue] <= 0 && [_dataLab.text isEqual:@"请选择"]) {
            _myButton2.enabled = YES;
            [_myButton2 setTintColor:[UIColor colorWithHexString:@"#2B2B2B"]];
        }
    }else{
        _addStateLab.text = [NSString stringWithFormat:@"%lu条回报",(unsigned long)userArr.count];
        _addStateLab.textColor = [UIColor colorWithHexString:@"#2B2B2B"];
        _myButton2.enabled = YES;
        [_myButton2 setTintColor:[UIColor colorWithHexString:@"#2B2B2B"]];
    }
}

//  键盘return键
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    int textValue = [textField.text intValue];
    if (textValue == 0)
    {
        textField.text = @"";
    }
    else
    {
        textField.text = [NSString stringWithFormat:@"%zd",[textField.text intValue]];
    }
}

//   组织截止日期
- (void)getDateInfo
{
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        for (NSInteger i = 1; i <= 60; i ++) {
            NSString *dateStr = [NSDate GetTomorrowDay:[NSDate date] abort:i];
            dateStr = [NSString stringWithFormat:@"%@   共%ld天",dateStr,(long)i];
            [_dateArr addObject:dateStr];
        }
    });
}

//   zhBPickerView  delegate
- (NSInteger)numberOfComponentsInPickerView:(ZHBPickerView *)pickerView
{
    return 1;
}

- (NSArray *)pickerView:(ZHBPickerView *)pickerView titlesForComponent:(NSInteger)component
{
    if (component == 0) {
        return _dateArr;
    }
    return nil;
}

- (void)pickerView:(ZHBPickerView *)pickerView didSelectContent:(NSString *)content
{
    _zhBPickBool = NO;
    _dataLab.text = content;
    [_dataLab setTextColor:[UIColor colorWithHexString:@"#2B2B2B"]];
    if ([content isEqual:@""]) {
        _dataLab.text = _dateArr[6];
    }
    _myButton2.enabled = YES;
    [_myButton2 setTintColor:[UIColor colorWithHexString:@"#2B2B2B"]];
}

- (void)cancelSelectPickerView:(ZHBPickerView *)pickerView
{
    _zhBPickBool = NO;
    [_zhBPickerView removeFromSuperview];
}

//  保存到草稿箱以及发布项目对项目图片的处理
- (void)uploadPhoto
{
    [UPYUNConfig sharedInstance].DEFAULT_BUCKET = @"ndzphoto";
    [UPYUNConfig sharedInstance].DEFAULT_PASSCODE = @"T+uMJhbKzocOvPRzLWs2DlqNJOI=";
    __block UpYun *uy = [[UpYun alloc] init];
    
    for (int i = 0; i < _startImageArr.count - 1; i ++) {
        if ([_startImageArr[i] isKindOfClass:[NSString class]]) {
            [self.startImageUrlArr addObject:_startImageArr[i]];
        }else{
            dispatch_queue_t urls_queue = dispatch_queue_create("app.mochoujun.com", NULL);
            dispatch_async(urls_queue, ^{
                NSLog(@"------=====%@",[NSThread currentThread]);
                uy.successBlocker = ^(NSURLResponse *response, id responseData) {
                    NSDictionary *dic = (NSDictionary *)responseData;
                    
                    if (_startImageArr.count - 1 == 1) {
                        NSString *imageUrl = [NSString stringWithFormat:@"%@%@", @"http://img.niuduz.com/", dic[@"url"]];
                        [self.startImageUrlArr addObject:imageUrl];
                        [self repayListStr];
                        
                    }else{
                        NSString *imageUrl = [NSString stringWithFormat:@"%@%@", @"http://img.niuduz.com/", dic[@"url"]];
                        [self.startImageUrlArr addObject:imageUrl];
                        
                        if (_startImageUrlArr.count == _startImageArr.count - 1){
                            [self repayListStr];
                        }
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
                NSString *imageKey = [NSString stringWithFormat:@"%@/image%d.jpg",[NSDate getNowDateString],i];
                [uy uploadImage:_startImageArr[i] savekey:imageKey];
            });
        }
        
    }
}

@end
