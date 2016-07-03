/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "AddFriendViewController.h"

#import "ApplyViewController.h"
#import "AddFriendCell.h"
#import "SearchFriendViewController.h"
#import "ContactOptionView.h"
#import "PhoneContactsViewController.h"
#import "APAddressBook.h"
#import "MMAlertView.h"
#import "MMPopupItem.h"
@interface AddFriendViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UITextField *textField;

//@property (strong, nonatomic) UITableView *tableView;
@end

@implementation AddFriendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self backBarItem];
    self.hideBottomBar = YES;
    self.title = @"添加好友";
    [self.view addSubview:self.headerView];
    ContactOptionView *contactOptionView = [[[NSBundle mainBundle] loadNibNamed:@"ContactOptionView" owner:self options:nil] lastObject];
    contactOptionView.delegate = self;
    contactOptionView.frame = CGRectMake(0, CGRectGetMaxY(_headerView.frame)+15, SCREEN_WIDTH, 44);
    [self.view addSubview:contactOptionView];
    // Do any additional setup after loading the view.
//    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
//    {
//        [self setEdgesForExtendedLayout:UIRectEdgeNone];
//    }
    
//    self.view.backgroundColor = [UIColor whiteColor];

    
//    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
//    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
//    [searchButton setTitleColor:[UIColor colorWithRed:32 / 255.0 green:134 / 255.0 blue:158 / 255.0 alpha:1.0] forState:UIControlStateNormal];
//    [searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    [searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:searchButton]];
}

#pragma mark - getter
- (UITextField *)textField
{
    if (_textField == nil) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width, 44)];
        UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        leftView.image = [UIImage imageNamed:@"search"];
        _textField.leftView = leftView;
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.font = [UIFont systemFontOfSize:15.0];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.placeholder = @"  陌筹君昵称/手机号码";
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
    }
    
    return _textField;
}

- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 44)];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        [_headerView addSubview:self.textField];
    }
    
    return _headerView;
}
#pragma mark -  ContactOptionViewDelegate
- (void)gotoPhoneContact
{
    //判断有没有授权
    switch([APAddressBook access])
    {
        case APAddressBookAccessUnknown:// 提示他访问
        {
            MMAlertViewConfig *config = [MMAlertViewConfig globalConfig];
            config.splitColor = NaviColor;
            config.itemHighlightColor = [UIColor blackColor];
            NSArray *items = @[MMItemMake(@"好的", MMItemTypeHighlight, nil)];
            
            MMAlertView *alertView = [[MMAlertView alloc]initWithTitle:@"提示" detail:@"请在iPhone的“设置－隐私－通讯录”选项中，允许访问你的通讯录" items:items];
            alertView.attachedView = self.view;
            [alertView show];
            
        }
            break;
            
        case APAddressBookAccessGranted:// 可以访问
        {
            PhoneContactsViewController *vc = [[PhoneContactsViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case APAddressBookAccessDenied:// 不能访问
        {
            MMAlertViewConfig *config = [MMAlertViewConfig globalConfig];
            config.splitColor = NaviColor;
            config.itemHighlightColor = [UIColor blackColor];
            NSArray *items = @[MMItemMake(@"好的", MMItemTypeHighlight, nil)];
            
            MMAlertView *alertView = [[MMAlertView alloc]initWithTitle:@"提示" detail:@"请在iPhone的“设置－隐私－通讯录”选项中，允许访问你的通讯录" items:items];
            alertView.attachedView = self.view;
            [alertView show];
        }
            break;
    }
   
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    SearchFriendViewController *vc = [[SearchFriendViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
    [textField resignFirstResponder];
    return YES;
}

@end
