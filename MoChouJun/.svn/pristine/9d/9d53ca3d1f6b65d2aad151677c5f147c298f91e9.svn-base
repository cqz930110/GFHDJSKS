#import "HomeViewController.h"
#import "CircleTableViewCell.h"
#import "ProjectTableViewCell.h"
#import "ProjectCrowedCollectionViewCell.h"
#import "PSBarButtonItem.h"
#import <MWPhotoBrowser.h>
#import "BaseNavigationController.h"
#import "ReflectUtil.h"
#import "Project.h"
#import "User.h"
#import "OpinionFeedbackViewController.h"
#import "WeiProjectDetailsViewController.h"
#import "MessageScrollView.h"
#import "FriendDetailViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "VersionUtil.h"
#import "ProjectDAO.h"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
@property (strong, nonatomic) IBOutlet UIView *headerTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *projectCorwedCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (nonatomic,strong) NSArray *bestNewProjects;
@property (nonatomic,strong) NSArray *followerProjects;

@property (weak, nonatomic) IBOutlet UILabel *messageCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *noCircelMessageLabel;

@property (weak, nonatomic) MessageScrollView *messageScrollView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableViewInfo];
    [self setupHeaderRefresh:_homeTableView];
    [self setupCircelMessage];
    [self setupVersionUpdate];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setNaviInfo];
    if (!_bestNewProjects)
    {
        _bestNewProjects = [ProjectDAO projectsAllNewest];
        if (_bestNewProjects.count)
        {
            [_projectCorwedCollectionView reloadData];
        }
        
        _followerProjects = [ProjectDAO projectsAllHome];
        if (_followerProjects.count)
        {
            [_homeTableView reloadData];
        }
        
        [self requestHomeDataSource];
    }
}

#pragma mark - Setter
- (void)setConversations:(NSArray *)conversations
{
    NSMutableArray *groupMessages = [NSMutableArray arrayWithCapacity:_conversations.count];
    
    NSArray *groupList = [[EaseMob sharedInstance].chatManager groupList];
    NSMutableArray *projectGroupIds = [NSMutableArray arrayWithCapacity:groupList.count];
    for (EMGroup *group  in groupList)
    {
        if (![group.groupSubject isEqualToString:@"好友交流群"])
        {
            [projectGroupIds addObject:group.groupId];
        }
    }
    
    for (EMConversation *conversation  in conversations)
    {
        if (conversation.conversationType == eConversationTypeGroupChat)
        {
            for (NSString *groupId in projectGroupIds)
            {
                if ([groupId isEqualToString:conversation.chatter])
                {
                    NSString *latestMessageTitle = @"";
                    EMMessage *lastMessage = [conversation latestMessage];
                    if (lastMessage) {
                        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
                        switch (messageBody.messageBodyType) {
                            case eMessageBodyType_Image:{
                                latestMessageTitle = @"发了一张图片";
                            } break;
                            case eMessageBodyType_Text:{
                                // 表情映射。
                                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                                latestMessageTitle = didReceiveText;
                            } break;
                            case eMessageBodyType_Voice:{
                                latestMessageTitle = @"发了一个音频";
                            } break;
                            case eMessageBodyType_Location: {
                                latestMessageTitle =@"发了一个位置";
                            } break;
                            case eMessageBodyType_Video: {
                                latestMessageTitle = @"发了一个视频";
                            } break;
                            case eMessageBodyType_File: {
                                latestMessageTitle = @"发了一个文件";
                            } break;
                            default: {
                            } break;
                        }
                    }
                    
                    if (latestMessageTitle.length != 0)
                    {
                        [groupMessages addObject:latestMessageTitle];
                    }
                }
            }
        }
    }
    
    _conversations = groupMessages;
    if (_conversations.count == 0)
    {
        _messageScrollView.hidden = YES;
        _messageCountLabel.hidden = YES;
        _noCircelMessageLabel.hidden = NO;
        _noCircelMessageLabel.text = @"没有项目信息，快去支持项目吧！";
    }
    else if (_conversations.count ==1 )
    {
        _messageScrollView.hidden = YES;
        _messageCountLabel.hidden = NO;
        _messageCountLabel.text = @"1";
        _noCircelMessageLabel.hidden = NO;
        _noCircelMessageLabel.text = _conversations[0];
    }
    else
    {
        _messageCountLabel.text = [NSString stringWithFormat:@"%zd",_conversations.count];
        _messageScrollView.messages = _conversations;
        _noCircelMessageLabel.hidden = YES;
        _messageScrollView.hidden = NO;
        _messageCountLabel.hidden = NO;
        _noCircelMessageLabel.text = @"没有项目信息，快去支持项目吧！";
    }
}

#pragma mark - Request
- (void)requestHomeDataSource
{
    [self.httpUtil requestDic4MethodName:@"Home/Index" parameters:nil result:^(NSDictionary *dic, int status, NSString *msg)
     {
         [self.homeTableView.mj_header endRefreshing];
         
         if (status == 1 || status == 2) {
             // 最新项目 Id Images
             _bestNewProjects = [ReflectUtil reflectDataWithClassName:@"Project" otherObject:[dic valueForKey:@"newestData"] isList:YES];
             [_projectCorwedCollectionView reloadData];
             [ProjectDAO addNewestProejcts:_bestNewProjects];
             // 关注人相关众筹信息
             if (![[dic valueForKey:@"friendCrowdFunds"] isKindOfClass:[NSString class]])
             {
                 _followerProjects = [ReflectUtil reflectDataWithClassName:@"Project" otherObject:[[dic valueForKey:@"friendCrowdFunds"] valueForKey:@"DataSet"] isList:YES];
                 [_homeTableView reloadData];
                 [ProjectDAO addHomeProejcts:_followerProjects];
             }
             
             // 一个BOOL 值，并没有卵用
             [dic valueForKey:@"isRecommended"];
         }
         else
         {
             [MBProgressHUD showError:msg toView:self.view];
         }
     }];
}

#pragma mark - Set Up
- (void)setupVersionUpdate
{
    [VersionUtil updateVersion:^(BOOL update, BOOL isMandatory) {
        if (update)
        {
            if (isMandatory)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"发现新版本!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"立即更新", nil];
                [alertView show];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"发现新版本!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"立即更新",@"取消", nil];
                [alertView show];
            }
            
        }
    }];
}

- (void)setupCircelMessage
{
    
    NSArray *messages;// = [self groupMessages];
    if (messages.count == 0) {
        messages = [NSArray arrayWithObjects:@"没有项目信息，快去支持项目吧！", @"没有项目信息，快去支持项目吧！",@"没有项目信息，快去支持项目吧！",nil];
    }
    
    MessageScrollView *messageScrollView = [[MessageScrollView alloc] initWithFrame:CGRectMake(70, 113, SCREEN_WIDTH - 70, 30) withMessages:messages];
    [_headerTableView addSubview:messageScrollView];
    self.messageScrollView = messageScrollView;
    _messageCountLabel.text = [NSString stringWithFormat:@"%zd",messages.count];
    _messageCountLabel.layer.cornerRadius = _messageCountLabel.width * 0.5;
    _messageCountLabel.layer.masksToBounds = YES;
    _homeTableView.tableHeaderView = _headerTableView;
    _messageScrollView.hidden = YES;
    _messageCountLabel.hidden = YES;
}

- (void)setNaviInfo
{
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    User *user = [User shareUser];
    NSString *imageUrl;
    if ([User isLogin] && user.avatar)
    {
        imageUrl = user.avatar;
    }
    
    self.tabBarController.navigationItem.leftBarButtonItem = [PSBarButtonItem itemWithImageUrl:imageUrl defaluleImageName:@"home_默认" target:self action:@selector(headImageAction)];
    self.tabBarController.navigationItem.rightBarButtonItem = [PSBarButtonItem itemWithImageName:@"commentImage" highLightImageName:nil selectedImageName:nil target:self action:@selector(commentImageClick)];
}

- (void)setTableViewInfo
{
    _homeTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [_homeTableView registerNib:[UINib nibWithNibName:@"CircleTableViewCell" bundle:nil] forCellReuseIdentifier:@"CircleTableViewCell"];
    [_homeTableView registerNib:[UINib nibWithNibName:@"ProjectTableViewCell" bundle:nil] forCellReuseIdentifier:@"ProjectTableViewCell"];
    
    _layout.itemSize = CGSizeMake((SCREEN_WIDTH - 35)/3, 64);
    [_projectCorwedCollectionView registerNib:[UINib nibWithNibName:@"ProjectCrowedCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ProjectCrowedCollectionViewCell"];
}

#pragma mark - Override
- (void)headerRefreshloadData
{
    [self requestHomeDataSource];
}

#pragma mark - Action
- (void)headImageAction
{
    
    if ([User isLogin])
    {
        // 好友详情
        FriendDetailViewController *vc = [[FriendDetailViewController alloc]init];
        User *userInfo = [User shareUser];
        vc.username = userInfo.userName;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        // 登录
        LoginViewController * login = [[LoginViewController alloc] init];
        BaseNavigationController *navi = [[BaseNavigationController alloc]initWithRootViewController:login];
        [self presentViewController:navi animated:YES completion:nil];
    }
}

- (IBAction)circelAction:(UIButton *)sender
{
    if (self.conversations.count != 0)
    {
        _messageCountLabel.hidden = YES;
        [self.tabBarController setSelectedIndex:2];
    }
}

- (void)commentImageClick
{
    OpinionFeedbackViewController *opinionFeedBackVC = [[OpinionFeedbackViewController alloc] init];
    [self.navigationController pushViewController:opinionFeedBackVC animated:YES];
}

- (IBAction)crowdfundingClick:(id)sender {
//    NSLog(@"Crowdfunding");
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        https://itunes.apple.com/cn/app/mo-chou-jun/id1075796881?l=en&mt=8
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/mo-chou-jun/id1075796881?l=en&mt=8"]];
    }
}

#pragma mark - UITableViewDelegate & UITableViewDateSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _followerProjects.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ProjectTableViewCell";
    ProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[ProjectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.userIconBtn.tag = indexPath.section;
    cell.project = _followerProjects[indexPath.section];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiProjectDetailsViewController *projectDetailsVC = [[WeiProjectDetailsViewController alloc]init];
    Project *projects =  _followerProjects[indexPath.section];
    projectDetailsVC.projectId = projects.Id;
    [self.navigationController pushViewController:projectDetailsVC animated:YES];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _bestNewProjects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectCrowedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProjectCrowedCollectionViewCell" forIndexPath:indexPath];
    cell.project = _bestNewProjects[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WeiProjectDetailsViewController *projectDetailsVC = [[WeiProjectDetailsViewController alloc]init];
    Project *projects =  _bestNewProjects[indexPath.row];
    projectDetailsVC.projectId = projects.Id;
    [self.navigationController pushViewController:projectDetailsVC animated:YES];
    
}

- (void)projectTableViewCell:(ProjectTableViewCell *)cell supportProject:(id)project
{
    if ([User isLogin])
    {
        FriendDetailViewController *friendDetailsVC = [[FriendDetailViewController alloc]init];
        Project *projects = _followerProjects[cell.userIconBtn.tag];
        friendDetailsVC.username = projects.userName;
        [self.navigationController pushViewController:friendDetailsVC animated:YES];
    }
    else
    {
        LoginViewController * login = [[LoginViewController alloc] init];
        BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:login];
        [self presentViewController:navi animated:YES completion:nil];
    }
}

@end

