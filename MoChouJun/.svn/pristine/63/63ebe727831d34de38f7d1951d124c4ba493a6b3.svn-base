//
//  AllCommentsViewController.m
//  TipCtrl
//
//  Created by liuyong on 15/11/27.
//  Copyright © 2015年 hesong. All rights reserved.
//

#import "AllCommentsViewController.h"
#import "CommentsTableViewCell.h"
#import "CommentReturnedCell.h"
#import "CommentsObj.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "EaseTextView.h"
#import "User.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"
#import "NSString+Adding.h"
#import "FriendDetailViewController.h"
@interface AllCommentsViewController ()<UITableViewDelegate,UITableViewDataSource,CommentsTableViewCellDelegate,CommentReturnedCellDelegate,UITextViewDelegate>
{
    int _pageIndex;
    int _refreshNum;
}
@property (assign, nonatomic) BOOL isRefreshEnd;
@property (weak, nonatomic) IBOutlet UITableView *allCommentsTableView;

@property (weak, nonatomic) IBOutlet UIView *replyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyViewHeightConstraint;
@property (weak, nonatomic) IBOutlet EaseTextView *replyTextView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (nonatomic, readonly) CGFloat inputViewMaxHeight;
@property (nonatomic, readonly) CGFloat inputViewMinHeight;
@property (nonatomic, readonly) CGFloat previousTextViewContentHeight;

@property (strong, nonatomic) CommentsObj *replyComment;
@end

@implementation AllCommentsViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"全部评论";
    [self setupAllProperty];
    [self setupReplyTextView];
    [self backBarItem];
    [self setTableViewInfo];
    [self setupFooterRefresh:_allCommentsTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyBoardAction:) name:UIKeyboardWillHideNotification object:nil];
    
    _replyView.hidden = YES;
}

#pragma mark - KeyBoard
- (void)hideKeyBoardAction:(NSNotification *)noti
{
    _replyView.hidden = YES;
}

- (void)setWeiPublicId:(NSInteger)weiPublicId
{
    _weiPublicId = weiPublicId;
    [MBProgressHUD showStatus:nil toView:self.view];
    [self requestAllComment];
}

#pragma mark - Actions
- (IBAction)commintAction:(UIButton *)sender
{
    if ([_replyTextView isFirstResponder])
    {
        [_replyTextView resignFirstResponder];
        _replyView.hidden = YES;
    }
    else
    {
        [_replyTextView becomeFirstResponder];
    }
}

- (void)gotoLogin
{
    LoginViewController * login = [[LoginViewController alloc] init];
    BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:login];
    [self presentViewController:navi animated:YES completion:nil];
}

#pragma mark - Request
- (void)requestAllComment
{
    [self.httpUtil requestArr4MethodName:@"Comment/Get" parameters:@{@"CrowdFundId":@(_weiPublicId),@"PageIndex":@(_pageIndex),@"PageSize":@(_refreshNum)} result:^(NSArray *arr, int status, NSString *msg)
     {
         [_allCommentsTableView.mj_footer endRefreshing];
         self.isRefreshEnd = arr.count<_refreshNum;

         if (status == 1)
         {
             [MBProgressHUD dismissHUDForView:self.view];
             [self.dataList addObjectsFromArray:arr];
             [_allCommentsTableView reloadData];
         }
         else
         {
             [MBProgressHUD dismissHUDForView:self.view withError:msg];
         }
         
         if (_dataList.count == 0)
         {
             self.hideNoMsg = NO;
         }
         else
         {
             self.hideNoMsg = YES;
         }
     } convertClassName:@"CommentsObj" key:@"DataSet"];
}

- (void)requestReplyCommment
{
    if (_replyTextView.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入回复内容！" toView:self.view];
        return;
    }
    [_replyTextView resignFirstResponder];
    _replyView.height =  50;
    _replyView.hidden = YES;
   
    _replyTextView.placeHolder = @"我来说两句...";
    NSLog(@"%@",_replyTextView.text);
    NSString *relpyText = [NSString encodeString:_replyTextView.text];
    [self.httpUtil requestDic4MethodName:@"Comment/Reply" parameters:@{@"Id":@(_replyComment.Id),@"ReplyMsg":relpyText } result:^(NSDictionary *dic, int status, NSString *msg)
     {
         if (status == 1 || status == 2)
         {
             //输入后 给模型赋值 记录模型
             _replyComment.replyMsg = relpyText;
             _replyComment.replyNickname = [User shareUser].nickName;
             _replyComment.modifyDate = @"刚刚";
             NSInteger index = [_dataList indexOfObject:_replyComment];
             NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
             [_allCommentsTableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
         }
         else
         {
             [MBProgressHUD showError:msg toView:self.view];
         }
         _replyComment = nil;
     }];
    
     _replyTextView.text = @"";
}

- (void)requestCommentProject
{
    if (_replyTextView.text.length == 0)
    {
        [MBProgressHUD showError:@"把你想说的话都写上吧" toView:self.view];
        return;
    }
    
    [_replyTextView resignFirstResponder];
    _replyView.height =  50;
    _replyTextView.placeHolder = @"我来说两句...";
    
     NSString *commentText = [NSString encodeString:_replyTextView.text];
    [self.httpUtil requestDic4MethodName:@"Comment/Post" parameters:@{@"CrowdFundId":@(_weiPublicId),@"CommentMsg":commentText} result:^(NSDictionary *dic, int status, NSString *msg)
     {
         if (status == 1 || status == 2)
         {
             User *user = [User shareUser];
             CommentsObj *comment = [[CommentsObj alloc] init];
             comment.commentMsg = commentText;
             comment.commentNickname = user.nickName;
             comment.createDate = @"刚刚";
             [_dataList insertObject:comment atIndex:0];
             [_allCommentsTableView reloadData];
         }
         else
         {
             [MBProgressHUD showError:msg toView:self.view];
         }
     }];
    _replyTextView.text = @"";
}

#pragma mark - Override
- (void)footerRefreshloadData
{
    self.refershState = RefershStateUp;
    _pageIndex++;
    if (!_isRefreshEnd)
    {
        [self requestAllComment];
    }
}

#pragma mark - Setter
- (NSMutableArray *)dataList
{
    if (!_dataList)
    {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (void)setIsRefreshEnd:(BOOL)isRefreshEnd
{
    _isRefreshEnd = isRefreshEnd;
    
    if (_isRefreshEnd)
    {
        [_allCommentsTableView.mj_footer endRefreshingWithNoMoreData];
    }
    else
    {
        [_allCommentsTableView.mj_footer resetNoMoreData];
    }
}

#pragma mark - Private
- (void)setupReplyTextView
{
    _replyTextView.layer.cornerRadius = 3.0;
    _replyTextView.placeHolder = @"我来说两句...";
    _replyTextView.placeHolderTextColor = AlertTextColor;
}

- (void)setupAllProperty
{
    self.refershState = RefershStateDown;
    _refreshNum = 10;
    _pageIndex = 1;
    _isRefreshEnd = NO;
    _inputViewMinHeight = 34;
    _inputViewMaxHeight = 150;
    _previousTextViewContentHeight = [self _getTextViewContentH:_replyTextView];
}

- (void)setTableViewInfo
{
    _allCommentsTableView.estimatedRowHeight = 90;
    [_allCommentsTableView registerNib:[UINib nibWithNibName:@"CommentsTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommentsTableViewCell"];
    [_allCommentsTableView registerNib:[UINib nibWithNibName:@"CommentReturnedCell" bundle:nil] forCellReuseIdentifier:@"CommentReturnedCell"];
    _allCommentsTableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *_id = nil;
    
    CommentsObj *data = [_dataList objectAtIndex:indexPath.row];
    
    if (!IsStrEmpty(data.replyMsg))
    {
        _id = @"CommentReturnedCell";
        
    }
    else
    {
        _id = @"CommentsTableViewCell";
    }
    CGFloat height = [tableView fd_heightForCellWithIdentifier:_id cacheByIndexPath:indexPath configuration:^(UITableViewCell *cell)
     {
         [cell performSelector:@selector(setData:) withObject:data];
     }];
    return height;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentsObj *data = [_dataList objectAtIndex:indexPath.row];
    NSString *_id = nil;
    if (!IsStrEmpty(data.replyMsg))
    {
        _id = @"CommentReturnedCell";
    }
    else
    {
        _id = @"CommentsTableViewCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_id forIndexPath:indexPath];
    if ([cell isKindOfClass:[CommentsTableViewCell class]])
    {
        CommentsTableViewCell *commentsCell = (CommentsTableViewCell *)cell;
        commentsCell.canReply = _canReply;
        commentsCell.delegate = self;
    }
    [cell performSelector:@selector(setData:) withObject:data];
    
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    _replyView.hidden = YES;
}

#pragma amrk - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (![User isLogin])
    {
        [self gotoLogin];
        return NO;
    }
    [_commentButton setTitle:@"取消" forState:UIControlStateNormal];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    
    _replyTextView.placeHolder = @"我来说两句...";
    [_commentButton setTitle:@"回复" forState:UIControlStateNormal];
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"])
    {
        if (_replyComment)
        {
            [self requestReplyCommment];
            return NO;
        }
        else
        {
            [self requestCommentProject];
        }
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 140) {
        _replyTextView.text = [_replyTextView.text substringToIndex:140];
        return;
    }
    if (textView.text.length > 0) {
        _replyTextView.placeHolder = nil;
    }else{
        _replyTextView.placeHolder = [NSString stringWithFormat:@"回复:%@",_replyComment.commentNickname];
    }
    
    [self _willShowInputTextViewToHeight:[self _getTextViewContentH:textView]];
}

- (CGFloat)_getTextViewContentH:(UITextView *)textView
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

- (void)_willShowInputTextViewToHeight:(CGFloat)toHeight
{
    if (toHeight < self.inputViewMinHeight) {
        toHeight = self.inputViewMinHeight;
    }
    if (toHeight > self.inputViewMaxHeight) {
        toHeight = self.inputViewMaxHeight;
    }
    
    if (toHeight == _previousTextViewContentHeight)
    {
        return;
    }
    else{
        CGFloat changeHeight = toHeight - _previousTextViewContentHeight;
        _replyViewHeightConstraint.constant += changeHeight;
        _previousTextViewContentHeight = toHeight;
    }
}

#pragma mark CommentsTableViewCellDelegate
- (void)commentsTableViewCellReply:(CommentsTableViewCell *)cell replyModel:(CommentsObj *)model
{
    [self.replyTextView performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.3];
    _replyComment = model;
    _replyView.hidden = NO;
    self.replyTextView.placeHolder = [NSString stringWithFormat:@"回复:%@",_replyComment.commentNickname];
}

- (void)commentsTableViewCellClikeIcon:(CommentsTableViewCell *)cell replyModel:(CommentsObj *)model
{
    if ([User isLogin])
    {
        FriendDetailViewController *friendDetailsVC = [[FriendDetailViewController alloc] init];
        friendDetailsVC.username = model.commentUserName;
        [self.navigationController pushViewController:friendDetailsVC animated:YES];
    }
    else
    {
        [self gotoLogin];
    }
    
}

#pragma mark -  CommentReturnedCellDelegate
- (void)commentReturnedCellClikeIcon:(CommentReturnedCell *)cell comment:(CommentsObj *)comment
{
    if ([User isLogin])
    {
        FriendDetailViewController *friendDetailsVC = [[FriendDetailViewController alloc] init];
        friendDetailsVC.username = comment.commentUserName;
        [self.navigationController pushViewController:friendDetailsVC animated:YES];
    }
    else
    {
        [self gotoLogin];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
