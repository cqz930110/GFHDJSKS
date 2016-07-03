//
//  MessageSetViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/11.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "MessageSetViewController.h"
#import "User.h"
@interface MessageSetViewController ()<UIAlertViewDelegate>
{
    EMPushNotificationDisplayStyle _pushDisplayStyle;
    EMPushNotificationNoDisturbStatus _noDisturbingStatus;
    NSInteger _noDisturbingStart;
    NSInteger _noDisturbingEnd;
    NSString *_nickName;
}
@property (weak, nonatomic) IBOutlet UIImageView *openImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UIImageView *closeImageView;
@property (weak, nonatomic) IBOutlet UISwitch *msgShowSwitch;

@end

@implementation MessageSetViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"消息推送设置";
    [self setNaviInfo];
    [self refreshPushOptions];
    [_msgShowSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
}

- (void)setNaviInfo
{
    [self backBarItem];
    [self setupBarButtomItemWithTitle:@"保存" target:self action:@selector(saveClick) leftOrRight:NO];
}

#pragma mark - Actions
-(void)switchAction:(UISwitch *)sender
{
    if (sender.isOn) {
//#warning 此处设置详情显示时的昵称，比如_nickName = @"环信";
        User *user = [User shareUser];
        _nickName = user.nickName;
        _pushDisplayStyle = ePushNotificationDisplayStyle_messageSummary;
    }
    else{
        _pushDisplayStyle = ePushNotificationDisplayStyle_simpleBanner;
    }
}

- (void)saveClick
{
    BOOL isUpdate = NO;
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    if (_pushDisplayStyle != options.displayStyle) {
        options.displayStyle = _pushDisplayStyle;
        isUpdate = YES;
    }
    
    if (_nickName && _nickName.length > 0 && ![_nickName isEqualToString:options.nickname])
    {
        options.nickname = _nickName;
        isUpdate = YES;
    }
    
    
    if (options.noDisturbingStartH != _noDisturbingStart || options.noDisturbingEndH != _noDisturbingEnd){
        isUpdate = YES;
        options.noDisturbStatus = _noDisturbingStatus;
        options.noDisturbingStartH = _noDisturbingStart;
        options.noDisturbingEndH = _noDisturbingEnd;
    }
    
    if (isUpdate)
    {
        [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:options];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)delayMethod{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)openBtnClick:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"此设置会导致全天都处于免打扰模式，不会在收到推送消息，是否继续？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是" , nil];
    [alertView show];
}

- (IBAction)selectTimeBtnClick:(id)sender
{
    _noDisturbingStart = 22;
    _noDisturbingEnd = 7;
    _noDisturbingStatus = ePushNotificationNoDisturbStatusCustom;

    _openImageView.image = [UIImage imageNamed:@""];
    _selectImageView.image = [UIImage imageNamed:@"seclct"];
    _closeImageView.image = [UIImage imageNamed:@""];
}

- (IBAction)closeBtnClick:(id)sender {
    
    _noDisturbingStart = -1;
    _noDisturbingEnd = -1;
    _noDisturbingStatus = ePushNotificationNoDisturbStatusClose;
    
    _openImageView.image = [UIImage imageNamed:@""];
    _selectImageView.image = [UIImage imageNamed:@""];
    _closeImageView.image = [UIImage imageNamed:@"seclct"];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex)
    {
        _noDisturbingStart = 0;
        _noDisturbingEnd = 24;
        _noDisturbingStatus = ePushNotificationNoDisturbStatusDay;
        
        _openImageView.image = [UIImage imageNamed:@"seclct"];
        _selectImageView.image = [UIImage imageNamed:@""];
        _closeImageView.image = [UIImage imageNamed:@""];
    }
}

#pragma mark - EaseMobRequest
- (void)refreshPushOptions
{

    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    _nickName = options.nickname;
    _pushDisplayStyle = options.displayStyle;
    _noDisturbingStatus = options.noDisturbStatus;
    if (_noDisturbingStatus != ePushNotificationNoDisturbStatusClose) {
        _noDisturbingStart = options.noDisturbingStartH;
        _noDisturbingEnd = options.noDisturbingEndH;
    }
    else
    {
        _noDisturbingStart = -1;
        _noDisturbingEnd = -1;
    }
    
    BOOL isDisplayOn = _pushDisplayStyle == ePushNotificationDisplayStyle_simpleBanner ? NO : YES;
    [self.msgShowSwitch setOn:isDisplayOn animated:YES];
    
    _openImageView.image = [UIImage imageNamed:@"seclct"];
    _selectImageView.image = [UIImage imageNamed:@""];
    _closeImageView.image = [UIImage imageNamed:@""];
    switch (_noDisturbingStatus)
    {
        case ePushNotificationNoDisturbStatusDay:
            _openImageView.image = [UIImage imageNamed:@"seclct"];
            _selectImageView.image = [UIImage imageNamed:@""];
            _closeImageView.image = [UIImage imageNamed:@""];
            break;
        case ePushNotificationNoDisturbStatusCustom:
            _openImageView.image = [UIImage imageNamed:@""];
            _selectImageView.image = [UIImage imageNamed:@"seclct"];
            _closeImageView.image = [UIImage imageNamed:@""];
            break;
        case ePushNotificationNoDisturbStatusClose:
            _openImageView.image = [UIImage imageNamed:@""];
            _selectImageView.image = [UIImage imageNamed:@""];
            _closeImageView.image = [UIImage imageNamed:@"seclct"];
            break;
    }
}

@end
