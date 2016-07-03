//
//  ChangeGroupNameViewController.m
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/26.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "ChangeGroupNameViewController.h"

@interface ChangeGroupNameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *markNameTextField;
@end

@implementation ChangeGroupNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"名称";
    [self backBarItem];
    [self setupBarButtomItemWithTitle:@"保存" target:self action:@selector(changeMarkName) leftOrRight:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _markNameTextField.text = _groupName;
    [_markNameTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)changeMarkName
{
    if (IsStrEmpty(_markNameTextField.text))
    {
        [MBProgressHUD showMessag:@"这个群还缺个霸气的名字"  toView:self.view];
        return;
    }
    
    [self.httpUtil requestDic4MethodName:@"Group/EditGroupName" parameters:@{@"GroupId":_groupId,@"GroupName":_markNameTextField.text} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2)
        {
            [MBProgressHUD showSuccess:@"缤果" toView:nil];
            [self.delegate changeGroupName:_markNameTextField.text];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [MBProgressHUD showSuccess:@"修改成功" toView:self.view];
        }
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
