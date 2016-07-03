//
//  AddGroupNoticeViewController.m
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/4.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "AddGroupNoticeViewController.h"
#import "GroupNotice.h"
#import "IQTextView.h"
#import "SendCMDMessageUtil.h"
#import "User.h"

@interface AddGroupNoticeViewController ()<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *groupTitleTextField;
@property (weak, nonatomic) IBOutlet IQTextView *contentTextView;

@end

@implementation AddGroupNoticeViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self backBarItem];
    [self setNavi];
    [self setTextView];
//    _groupTitleTextField.text = _notice.title;
//    _contentTextView.text  = _notice.content;
    
    _contentTextView.text = _noticeStr;
}

- (void)setTextView
{
    _contentTextView.placeholder = @"公告内容，300个字内！";
}

- (void)setNavi
{
    self.title = @"群公告";
    
    if ([_type isEqual:@"群主"]) {
        [self setupBarButtomItemWithTitle:@"保存" target:self action:@selector(sendGroupNoticeAction) leftOrRight:NO];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if(textView.text.length > 300)
    {
        textView.text = [textView.text substringToIndex:301];
    }
}

#pragma mark - UITextViewDelegate
- (void)sendGroupNoticeAction
{
    //给出限制
//    if (IsStrEmpty(_groupTitleTextField.text))
//    {
//        [MBProgressHUD showMessag:@"标题不能忘记哦"  toView:self.view];
//        return;
//    }
    
    if (IsStrEmpty(_contentTextView.text) || [_contentTextView.text isEqualToString:@"填写群公告"])
    {
        [MBProgressHUD showMessag:@"什么也没有写啊"  toView:self.view];
        return;
    }
    
//    NSString *mothodName;
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    if (self.notice)
//    {
//        mothodName = @"GroupNote/Edit";
//        [param setValue:[NSString stringWithFormat:@"%ld",_notice.Id] forKey:@"Id"];
//        [param setValue:_groupTitleTextField.text forKey:@"Title"];
//        [param setValue:_contentTextView.text forKey:@"Content"];
//    }
//    else
//    {
//        mothodName = @"GroupNote/Add";
//        [param setValue:_groupId forKey:@"GroupId"];
//        [param setValue:_groupTitleTextField.text forKey:@"Title"];
//        [param setValue:_contentTextView.text forKey:@"Content"];
//    }
    
    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"Group/EditNotice" parameters:@{@"GroupId":_groupId,@"Notice":_contentTextView.text} result:^(NSDictionary *dic, int status, NSString *msg)
    {
        if (status == 1 || status == 2)
        {
            [MBProgressHUD dismissHUDForView:self.view withSuccess:@"缤果"];
            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:1.5];
            if (!IsStrEmpty(_noticeStr)) {
                EMMessage *message = [SendCMDMessageUtil sendGroupNoticeMessageGroupId:_groupId message:[NSString stringWithFormat:@"%@ 修改了群公告",[User shareUser].userName]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"insertCallMessage" object:message];
            }else{
                EMMessage *message = [SendCMDMessageUtil sendGroupNoticeMessageGroupId:_groupId message:[NSString stringWithFormat:@"%@ 添加了群公告",[User shareUser].userName]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"insertCallMessage" object:message];
            }
            if ([self.delegate respondsToSelector:@selector(changeGroupNotice:)]) {
                [self.delegate changeGroupNotice:_contentTextView.text];
            }
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
    }];
}
@end
