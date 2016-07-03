//
//  FriendDetailViewController.m
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/3.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "FriendDetailViewController.h"
#import "FirendDetailCell.h"
#import "ComplaintViewController.h"
#import "PSBuddy.h"
#import "ChatViewController.h"
#import "ApplyViewController.h"
#import "InvitationManager.h"
#import "ReflectUtil.h"
#import "User.h"
#import "FriendSettingViewController.h"
#import "NSString+Adding.h"
#import "BaseNavigationController.h"
#import "Project.h"
#import "WeiProjectDetailsViewController.h"
#import "PSChat.h"
#import "ChatBuddyDAO.h"
#import "BaseDataViewController.h"
#import "NSString+Adding.h"

#define kRefreshNum 5
@interface FriendDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *sectionHeaderView;
@property (strong, nonatomic) IBOutlet UIView *bottomActionView;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIView *bottomSplitLineView;
@property (weak, nonatomic) IBOutlet UIImageView *showRealNameImageView;

//数据显示
@property (weak, nonatomic) IBOutlet UILabel *nameLabel2;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contantLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UIView *certificationView;//判断是否是实名 隐藏
@property (weak, nonatomic) IBOutlet UIButton *editSelfBtn;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLab;
@property (assign, nonatomic) BOOL hiddenBottom;
@property (weak, nonatomic) IBOutlet UIButton *allBottomBtn;

@property (strong ,nonatomic)NSMutableArray *projects;

@property (assign, nonatomic) BOOL isRefreshEnd;
@property (assign, nonatomic) int refreshIndex;
@property (assign, nonatomic) NSInteger friendStatus;

@property (assign,nonatomic) NSInteger supportedCount;
@end

@implementation FriendDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupAllProperty];
    [self setupNavi];
    [self setupTableView];
    [self setupRefreshWithTableView:self.tableView];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self requestFriendDetailWithUserId:_username];
}

#pragma mark - Refresh
- (void)headerRefreshloadData
{
    _refreshIndex = 1;
    self.refershState = RefershStateDown;
    [self requestFriendOpenProject];
}

- (void)footerRefreshloadData
{
    self.refershState = RefershStateUp;
    _refreshIndex++;
    if (!_isRefreshEnd)
    {
        [self requestFriendOpenProject];
    }
}

#pragma mark - Action
- (void)rightNaviItemAction
{
    if (_hiddenBottom){  //   自己
        BaseDataViewController *baseDataVC = [BaseDataViewController new];
        [self.navigationController pushViewController:baseDataVC animated:YES];
    }else{   //   好友
        FriendSettingViewController *vc = [[FriendSettingViewController alloc]init];
        vc.friendId = [NSString stringWithFormat:@"%ld",_buddy.userId];
        vc.username = _buddy.userName;
        vc.friendYesOrNo = _friendStatus;
        vc.notes = _buddy.notes;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Private
- (void)setupAllProperty
{
    _isRefreshEnd = NO;
    _refreshIndex = 1;
    self.refershState = RefershStateDown;
    _headerImage.layer.cornerRadius = _headerImage.width * 0.5;
    _headerImage.layer.masksToBounds = YES;
}

- (void)setupNavi
{
    [self backBarItem];
}

- (void)setupTableView
{
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView registerNib:[UINib nibWithNibName:@"FirendDetailCell" bundle:nil] forCellReuseIdentifier:@"FirendDetailCell"];
}

#pragma mark - Setter
- (void)setIsRefreshEnd:(BOOL)isRefreshEnd
{
    _isRefreshEnd = isRefreshEnd;
    
    if (_isRefreshEnd)
    {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }
    else
    {
        [_tableView.mj_footer resetNoMoreData];
    }
}

- (NSMutableArray *)projects
{
    if (!_projects)
    {
        _projects = [NSMutableArray array];
    }
    return _projects;
}

- (void)setSearchMobile:(NSString *)searchMobile
{
    _searchMobile = searchMobile;
    // 请求联系人进入详情
    [MBProgressHUD showStatus:nil toView:self.view];
    [self requestFriendApply];
}

- (void)setUsername:(NSString *)username
{
    _username = username;
    [MBProgressHUD showStatus:nil toView:self.view];
    // 通过username
    [self requestFriendDetailWithUserId:_username];
}

- (void)setFriendDetailType:(FriendDetailType)friendDetailType
{
    _friendDetailType = friendDetailType;
    //new_addFriend chat_icon 添加
    if (!_friendDetailType && _supportedCount > 0)
    {
        _allBottomBtn.hidden = YES;
        _leftButton.hidden = NO;
        _rightButton.hidden = NO;
        _bottomSplitLineView.hidden = NO;
        [_allBottomBtn setTitle:@"" forState:UIControlStateNormal];
    }else if (!_friendDetailType && _supportedCount == 0){
        
        [_allBottomBtn setTitle:@"添加好友" forState:UIControlStateNormal];
        _allBottomBtn.hidden = NO;
        _leftButton.hidden = YES;
        _rightButton.hidden = YES;
        _bottomSplitLineView.hidden = YES;
    }
    else
    {
        [_allBottomBtn setTitle:@"发消息" forState:UIControlStateNormal];
        _allBottomBtn.hidden = NO;
        _leftButton.hidden = YES;
        _rightButton.hidden = YES;
        _bottomSplitLineView.hidden = YES;
    }
}

#pragma mark - Request
- (void)requestFriendOpenProject
{
    [self.httpUtil requestArr4MethodName:@"CrowdFund/UserCreatedList" parameters:@{@"UserName":_username,@"PageIndex":@(_refreshIndex),@"PageSize":@(kRefreshNum)} result:^(NSArray *arr, int status, NSString *msg) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        
        self.isRefreshEnd = arr.count<kRefreshNum;
        
        if (status == 1)
        {
            [MBProgressHUD dismissHUDForView:self.view];
            if (self.refershState == RefershStateDown)
            {
                [self.projects removeAllObjects];
            }
            [self.projects addObjectsFromArray:arr];
            [_tableView reloadData];
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
    } convertClassName:@"Project" key:@"DataSet"];
}

- (void)requestFriendApply
{
    [self.httpUtil requestDic4MethodName:@"FriendApply/Search" parameters:@{@"Condition":_searchMobile} result:^(NSDictionary *dic, int status, NSString *msg) {
        
        if (status == 1)
        {
           [MBProgressHUD dismissHUDForView:self.view];
            NSString *userID = [NSString stringWithFormat:@"%@", [dic objectForKey:@"UserName"]];
            self.username = userID;
            [self requestFriendDetailWithUserId:_username];
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
    }];
}

- (void)setBuddy:(PSBuddy *)buddy
{
    _buddy = buddy;
    NSString *username = [User shareUser].userName;
    self.hiddenBottom = [_buddy.userName isEqualToString:username];
    self.username = buddy.userName;
}

- (void)setHiddenBottom:(BOOL)hiddenBottom
{
    _hiddenBottom = hiddenBottom;
    if (_hiddenBottom)
    {
        self.title = @"个人详情";
        
        [self setupBarButtomItemWithTitle:@"编辑" target:self action:@selector(rightNaviItemAction) leftOrRight:NO];
    }
    else
    {
        if (_friendStatus == 1) {
            self.title = @"好友详情";
        }else{
            self.title = @"详细资料";
        }
        
        [self.view addSubview:_bottomActionView];
         _bottomActionView.width = SCREEN_WIDTH;
        _bottomActionView.top = SCREEN_HEIGHT - 64 - 44;
        
        [self setupBarButtomItemWithImageName:@"circel_more" highLightImageName:nil selectedImageName:nil target:self action:@selector(rightNaviItemAction) leftOrRight:NO];
    }
}

- (void)requestFriendDetailWithUserId:(NSString *)userID
{   
    [self.httpUtil requestDic4MethodName:@"Friend/View" parameters:@{@"UserName":userID} result:^(NSDictionary *dic, int status, NSString *msg)
    {
        NSLog(@"-----%@",dic);
        NSString *my = [User shareUser].userName;
        self.hiddenBottom = [_username isEqualToString:my];
        if (status == 1)
        {
            _friendStatus = [[dic objectForKey:@"IsFriend"] integerValue];
            _supportedCount = [[dic objectForKey:@"SupportedCount"] integerValue];
            self.friendDetailType = _friendStatus;
            NSDictionary *userDic = [dic objectForKey:@"User"];
            
            NSDictionary *detailDic = [dic objectForKey:@"Details"];
            
            NSString *nickNameStr = [userDic objectForKey:@"NickName"];
            NSString *notesStr = [userDic objectForKey:@"Notes"];
            _nickNameLab.text = IsStrEmpty(nickNameStr)?@"无":nickNameStr;
            NSString *userNameStr = [userDic objectForKey:@"UserName"];
            _nameLabel2.text = IsStrEmpty(notesStr)?(IsStrEmpty(nickNameStr)?userNameStr:nickNameStr):notesStr;
            NSString *occupation = [detailDic valueForKey:@"Occupation"];
            _jobLabel.text = IsStrEmpty(occupation)?@"无":occupation;
            
            NSString *school = [detailDic valueForKey:@"School"];
            _schoolLabel.text = IsStrEmpty(school)?@"无":school;
            
            NSString *company = [detailDic valueForKey:@"Company"];
            _companyLabel.text = IsStrEmpty(company)?@"无":company;
            
            _buddy =  [ReflectUtil reflectDataWithClassName:@"PSBuddy" otherObject:userDic];
            
            _buddy.userId = [[userDic valueForKey:@"Id"] integerValue];
            NSString *imageUrl = [userDic objectForKey:@"Avatar"];
            if (imageUrl)
            {
                [NetWorkingUtil setImage:_headerImage url:imageUrl defaultIconName:@"home_默认"];
            }
            _nameLabel.text =  _buddy.reviewName;// name
            NSString *realNameStr = [userDic objectForKey:@"RealName"];
            if (!IsStrEmpty(realNameStr)) {
                CGFloat weith = [_nameLabel2.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedSize:CGSizeMake(SCREEN_WIDTH - 50, 20)].width;
                _showRealNameImageView.frame = CGRectMake(SCREEN_WIDTH * 0.5 + weith * 0.5 + 10, 0, 38, 20);
                _showRealNameImageView.hidden = NO;
            }else{
                _showRealNameImageView.hidden = YES;
            }
//            _nameLabel2.text = _buddy.reviewName;// name
            CGRect rect = _nameLabel.frame;
            rect.size.width = [_buddy.reviewName sizeWithFont:[UIFont systemFontOfSize:15] constrainedSize:CGSizeMake(230, 20)].width;
            _nameLabel.frame = rect;
            _contantLabel.text = _buddy.signature;//个性签敏
            _certificationView.hidden = IsStrEmpty(_buddy.realName);
            if (!_certificationView.hidden)
            {
                _certificationView.left = CGRectGetMaxX(_nameLabel.frame);
            }
            
            [MBProgressHUD dismissHUDForView:self.view];
            //请求列表
            [self requestFriendOpenProject];
            
            // 更新数据库
            PSChat *chat =  [ReflectUtil reflectDataWithClassName:@"PSChat" otherObject:userDic];
            chat.showName = _buddy.reviewName;
            chat.showType = _friendStatus;
            [ChatBuddyDAO updateChatBuddy:chat];
        }
        else
        {
            [MBProgressHUD dismissHUDForView:self.view withError:msg];
        }
    }];
}

#pragma mark - Action
- (IBAction)leftAction:(UIButton *)sender {
    
    //   发消息
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    if (loginUsername && loginUsername.length > 0) {
        if ([loginUsername isEqualToString:_buddy.userName]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能和自己聊天" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alertView show];
            
            return;
        }
    }
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:_buddy.userName conversationType:eConversationTypeChat];
    chatController.title = _buddy.reviewName;
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    
    BOOL isContaintChat = NO;;
    for (UIViewController *viewController in array)
    {
        if ([viewController isKindOfClass:[ChatViewController class]])
        {
            isContaintChat = YES;
            break;
        }
    }
    
    if (isContaintChat)
    {
        BaseNavigationController *navi = (BaseNavigationController *)self.navigationController;
        [self.navigationController popToRootViewControllerAnimated:NO];
        self.tabBarController.selectedIndex = 2;
        
        [navi pushViewController:chatController animated:YES];
    }
    else
    {
        [self.navigationController pushViewController:chatController animated:YES];
    }
    
}
- (IBAction)allBottomBtnClick:(id)sender {
    if (!_friendDetailType && _supportedCount == 0){
        //不是好友 加好友
        // 判断是不是本人
        User *user = [User shareUser];
        if ([user.userName isEqualToString:_buddy.userName])
        {
            NSLog(@"不能添加自己为好友");
        }
        
        //好友判断
        if (_friendStatus == 1)
        {
            [MBProgressHUD showMessag:@"对方已经是好友" toView:self.view];
            return;
        }
        
        //判断是否已发来申请
        NSArray *applyArray = [[ApplyViewController shareController] dataSource];
        if (applyArray && [applyArray count] > 0)
        {
            for (ApplyEntity *entity in applyArray)
            {
                ApplyStyle style = [entity.style intValue];
                BOOL isGroup = style == ApplyStyleFriend ? NO : YES;
                if (isGroup)
                {
                    continue;
                }
                
                if ([entity.applicantUsername isEqualToString:_buddy.userName] && [entity.applyState integerValue] == ApplyStateAcceptApplying) {
                    NSString *str = [NSString stringWithFormat:@"%@已经给你发来了申请", _buddy.userName];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                    [alertView show];
                    return;
                }
            }
        }
        
        // 发送添加好友的请求
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定添加该好友吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView show];
    }else{
        //   发消息
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
        if (loginUsername && loginUsername.length > 0) {
            if ([loginUsername isEqualToString:_buddy.userName]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能和自己聊天" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alertView show];
                
                return;
            }
        }
        
        ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:_buddy.userName conversationType:eConversationTypeChat];
        chatController.title = _buddy.reviewName;
        
        NSMutableArray *array = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
        
        BOOL isContaintChat = NO;;
        for (UIViewController *viewController in array)
        {
            if ([viewController isKindOfClass:[ChatViewController class]])
            {
                isContaintChat = YES;
                break;
            }
        }
        
        if (isContaintChat)
        {
            BaseNavigationController *navi = (BaseNavigationController *)self.navigationController;
            [self.navigationController popToRootViewControllerAnimated:NO];
            self.tabBarController.selectedIndex = 2;
            
            [navi pushViewController:chatController animated:YES];
        }
        else
        {
            [self.navigationController pushViewController:chatController animated:YES];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // 发送添加好友的请求
        [MBProgressHUD showStatus:nil toView:self.view];
        [self.httpUtil requestDic4MethodName:@"FriendApply/Apply" parameters:@{@"UserName":_username} result:^(NSDictionary *dic, int status, NSString *msg)
         {
             if (status == 1 || status == 2)
             {
                 EMError *error;
                 NSLog(@"%@",_buddy.userName);
                 [[EaseMob sharedInstance].chatManager addBuddy:_buddy.userName message:@"添加你为好友" error:&error];
                 if (error)
                 {
                     [MBProgressHUD dismissHUDForView:self.view withError:@"发送申请失败，请重新操作"];
                 }
                 else
                 {
                     [MBProgressHUD dismissHUDForView:self.view withSuccess:@"申请已发出，请耐心等待对方回应"];
                     [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:[NSNumber numberWithBool:YES] afterDelay:1.5];
                 }
             }
             else
             {
                 [MBProgressHUD dismissHUDForView:self.view withError:msg];
             }
             
         }];
    }
}

- (IBAction)complaint:(UIButton *)sender
{
    //   添加好友
    
    //不是好友 加好友
    // 判断是不是本人
    User *user = [User shareUser];
    if ([user.userName isEqualToString:_buddy.userName])
    {
        NSLog(@"不能添加自己为好友");
    }
    
    //好友判断
    if (_friendStatus == 1)
    {
        [MBProgressHUD showMessag:@"对方已经是好友" toView:self.view];
        return;
    }
    
    //判断是否已发来申请
    NSArray *applyArray = [[ApplyViewController shareController] dataSource];
    if (applyArray && [applyArray count] > 0)
    {
        for (ApplyEntity *entity in applyArray)
        {
            ApplyStyle style = [entity.style intValue];
            BOOL isGroup = style == ApplyStyleFriend ? NO : YES;
            if (isGroup)
            {
                continue;
            }
            
            if ([entity.applicantUsername isEqualToString:_buddy.userName] && [entity.applyState integerValue] == ApplyStateAcceptApplying) {
                NSString *str = [NSString stringWithFormat:@"%@已经给你发来了申请", _buddy.userName];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alertView show];
                return;
            }
        }
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定添加该好友吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
    
    
//    // 举报
//    ComplaintViewController *vc = [[ComplaintViewController alloc]init];
//    // 改成UserName
//    vc.username = _username;
//    vc.complaintType = @"1";
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.projects.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FirendDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FirendDetailCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.project = _projects[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  185;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 30;
    }
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.sectionHeaderView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Project *project = _projects[indexPath.section];
    WeiProjectDetailsViewController *vc = [[WeiProjectDetailsViewController alloc]init];
    vc.projectId = project.Id;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
