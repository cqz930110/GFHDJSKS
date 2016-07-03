//
//  SetMoreViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/4.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "SetMoreViewController.h"
#import "AccountSetTableViewCell.h"
#import "AbountWeViewController.h"
#import "CommonProblemViewController.h"
#import "OpinionFeedbackViewController.h"
#import "MessagePushTableViewCell.h"
#import "MessageSetViewController.h"
#import "MMAlertView.h"
#import "MMPopupItem.h"
#import "ApplyViewController.h"
#import "User.h"
@interface SetMoreViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *setMoreTableView;
@property (strong, nonatomic) IBOutlet UIView *setTableFooterView;
@property (nonatomic,strong)NSString *phoneStr;
@property (nonatomic,strong)UIWebView *phoneWebView;
@property (nonatomic,strong)UISwitch *switchBtn;
@end

@implementation SetMoreViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更多";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    [self backBarItem];
    
    [self setTableViewInfo];
    
    [self getPhoneData];
}

- (void)getPhoneData
{
    [self.httpUtil requestDic4MethodName:@"SysConfig/ServicePhone" parameters:nil result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2)
        {
            _phoneStr = [dic objectForKey:@"ServicePhone"];
            if (_phoneStr.length == 0)
            {
                _phoneStr = @"4000097882";
            }
        }
        else
        {
            [MBProgressHUD showError:msg toView:self.view];
        }
        [_setMoreTableView reloadData];
    }];
}

- (void)setTableViewInfo
{
    _setMoreTableView.tableFooterView = _setTableFooterView;
    [_setMoreTableView registerNib:[UINib nibWithNibName:@"AccountSetTableViewCell" bundle:nil] forCellReuseIdentifier:@"AccountSetTableViewCell"];
    [_setMoreTableView registerNib:[UINib nibWithNibName:@"MessagePushTableViewCell" bundle:nil] forCellReuseIdentifier:@"MessagePushTableViewCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"AccountSetTableViewCell";
    AccountSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[AccountSetTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.accountNameLab.text = @"关于我们";
    }else if (indexPath.row == 1){
        cell.accountNameLab.text = @"常见问题";
    }else if (indexPath.row == 2){
        cell.accountNameLab.text = @"意见反馈";
    }
//    else if (indexPath.row == 3){
//        cell.accountNameLab.text = @"聊天消息设置";
//    }
//    else if (indexPath.row == 4){
//        static NSString *cellID = @"cell";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(15, 14, 100, 21)];
//        labelName.font = [UIFont systemFontOfSize:15.0f];
//        labelName.text = @"消息推送";
//        labelName.textColor = [UIColor colorWithHexString:@"#464646"];
//        [cell addSubview:labelName];
//        _switchBtn = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 70, 11, 15, 10)];
//        [_switchBtn setOn:YES];
//        [cell addSubview:_switchBtn];
//        [_switchBtn addTarget:self action:@selector(settingAPNSWith:) forControlEvents:UIControlEventValueChanged];
//        return cell;
//    }
    else if (indexPath.row == 3){
        static NSString *cellID = @"MessagePushTableViewCell";
        MessagePushTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[MessagePushTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.phoneLab.text = _phoneStr;
        return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        AbountWeViewController *abountWeVC = [[AbountWeViewController alloc] init];
        [self.navigationController pushViewController:abountWeVC animated:YES];
    }else if (indexPath.row == 1){
        CommonProblemViewController *commonProblemVC = [[CommonProblemViewController alloc] init];
        [self.navigationController pushViewController:commonProblemVC animated:YES];
    }else if (indexPath.row == 2){
        OpinionFeedbackViewController *opinionFeedbackVC = [[OpinionFeedbackViewController alloc] init];
        [self.navigationController pushViewController:opinionFeedbackVC animated:YES];
    }
//    else if (indexPath.row == 3)
//    {
//        BOOL isOpenNpti = NO;
//        if (IS_IOS8_LATE)
//        {
//            UIUserNotificationSettings *notiSetting = [[UIApplication sharedApplication] currentUserNotificationSettings];
//            if (notiSetting.types != UIUserNotificationTypeNone)
//            {
//                isOpenNpti = YES;
//            }
//        }
//        else
//        {
//           UIRemoteNotificationType notiType = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
//            if (notiType != UIRemoteNotificationTypeNone)
//            {
//                isOpenNpti = YES;
//            }
//        }
//        
//        if (isOpenNpti)
//        {
//            MessageSetViewController *messageSetVC = [[MessageSetViewController alloc] init];
//            [self.navigationController pushViewController:messageSetVC animated:YES];
//        }
//        else
//        {
//            MMAlertViewConfig *config = [MMAlertViewConfig globalConfig];
//            config.splitColor = NaviColor;
//            config.itemHighlightColor = [UIColor blackColor];
//            NSArray *items = @[MMItemMake(@"好的", MMItemTypeHighlight, nil)];
//
//            MMAlertView *alertView = [[MMAlertView alloc]initWithTitle:@"提示" detail:@"请在iPhone的“设置－通知”选项中进行修改" items:items];
//            alertView.attachedView = self.view;
//            [alertView show];
//        }
//        
//    }
    else if (indexPath.row == 3){
        _phoneWebView = [[UIWebView alloc] init];
        NSString*string = [NSString stringWithFormat:@"%@",_phoneStr];
        NSString *telStr = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSLog(@"==%@",telStr);
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",telStr]];
        [_phoneWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
        [self.view addSubview:_phoneWebView];
    }
}

#pragma mark - Action
- (void)settingAPNSWith:(UISwitch*)sender
{
    NSInteger noDisturbingStart = -1;
    NSInteger noDisturbingEnd = -1;
    EMPushNotificationNoDisturbStatus noDisturbingStatus = ePushNotificationNoDisturbStatusClose;
    if (sender.isOn)
    {
        EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
        options.noDisturbStatus = noDisturbingStatus;
        options.noDisturbingStartH = noDisturbingStart;
        options.noDisturbingEndH = noDisturbingEnd;
        
        [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:options];
    }
    else
    {
        
    }
}

#pragma mark - Action
- (IBAction)outLoggin:(UIButton *)sender
{
    [MBProgressHUD showStatus:@"陛下，您要抛弃臣妾了么" toView:self.view];
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        
        if (error && error.errorCode != EMErrorServerNotLogin)
        {
            [MBProgressHUD dismissHUDForView:self.view withError:@"网络异常，请重试"];
            NSString *message = [NSString stringWithFormat:@"error.des = %@ error.errorCode = %zd userInfo = %@",error.description,error.errorCode,info.description];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"测试时错误提示" message:message delegate:nil cancelButtonTitle:@"截图" otherButtonTitles:nil, nil];
            [alertView show];
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view];
            // 清理数据
            [[User shareUser] deleteUesr];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:nil];
        }
    } onQueue:nil];
}

@end
