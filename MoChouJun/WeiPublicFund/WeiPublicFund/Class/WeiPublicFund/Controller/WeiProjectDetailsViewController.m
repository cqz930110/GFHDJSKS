//
//  WeiProjectDetailsViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/25.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "WeiProjectDetailsViewController.h"
#import "WNXScrollHeadView.h"
#import "WeiSupportTableViewCell.h"
#import "CommentReturnedCell.h"
#import "ProjectDetailsObj.h"
#import "User.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ShareView.h"
#import "PSGroup.h"
#import "ReflectUtil.h"
#import "ChatViewController.h"
#import "SupportPeopleViewController.h"
#import "GoSupportViewController.h"
#import "FriendDetailViewController.h"
#import "EaseTextView.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "CommentsObj.h"
#import "CommentsTableViewCell.h"
#import "EMVoiceMessageBody.h"
#import "BaseNavigationController.h"
#import "LoginViewController.h"
#import "NSString+Adding.h"
#import "ProjectContentCell.h"
#import "SupportReturn.h"
#import "SupportProjectTableViewCell.h"
#import "ProjectReturnHeaderView.h"
#import "SupportMethodViewController.h"
#import "ProjectDetailFootView.h"
#import "AllCommentsViewController.h"
#import "ProjectHtmlContentCell.h"
#import "NoReturnSupportTableViewCell.h"
#import "HeadTitleTableViewCell.h"
#import "RaiseFundsTableViewCell.h"
#import "AllRaiseTableViewCell.h"
#import "RaiseFundsViewController.h"
#import "SupportAllMethodViewController.h"
#import "AddProjectReturnViewController.h"
#import "AddProjectDetailsViewController.h"
#import "MoreReturnContentViewController.h"
#import "ComplaintViewController.h"
#import "McjHomeViewController.h"
#import "AppDelegate.h"
#import "TabBarController.h"
#import "ProjectDetailsWebViewController.h"

@implementation SupportReturnMamager

@end

//顶部scrollHeadView 的高度,先给写死
static const CGFloat ScrollHeadViewHeight = 250;
static const CGFloat kInputViewMaxHeight = 150;
static const CGFloat kInputViewMinHeight = 34;
static NSString *const projectHtmlContentCell = @"ProjectHtmlContentCell";
static NSString *const projectContentCellIden = @"ProjectContentCell";
static NSString *const commentReturnedCellIden = @"CommentReturnedCell";
static NSString *const commentCellIden = @"CommentsTableViewCell";
static NSString *const weiSupportCellIden = @"WeiSupportTableViewCell";
static NSString *const supportProjectIden = @"SupportProjectTableViewCell";
static NSString *const noReturnSupport = @"NoReturnSupportTableViewCell";
static NSString *const headerTitle = @"HeadTitleTableViewCell";
static NSString *const raiseFunds = @"RaiseFundsTableViewCell";
static NSString *const allRaise = @"AllRaiseTableViewCell";
@interface WeiProjectDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,CommentsTableViewCellDelegate,CommentReturnedCellDelegate,AVAudioPlayerDelegate,UIAlertViewDelegate,ShareViewDelegate,ProjectContentCellDelegate,ProjectReturnHeaderViewDelegate,SupportProjectTableViewCellDelegate,UIWebViewDelegate>
/** 记录scrollView上次偏移的Y距离 */
@property (nonatomic, assign) CGFloat                    scrollY;
/** 记录scrollView上次偏移X的距离 */
@property (nonatomic, assign) CGFloat                    scrollX;
/** 用来装顶部的scrollView用的View */
@property (nonatomic, strong) UIView                     *topView;
/** 顶部的图片scrollView */
@property (nonatomic, strong) WNXScrollHeadView          *topScrollView;
/** 返回按钮 */
@property (nonatomic, strong) UIButton                   *backBtn;
/** 分享按钮 */
@property (nonatomic, strong) UIButton                   *sharedBtn;
/** 信息tableView */
@property (nonatomic, strong) UITableView                *infoTableView;
/** 导航条的背景view */
@property (nonatomic, strong) UIView                     *naviView;
/** 导航条上的title */
@property (nonatomic, strong)UILabel *titleLab;

//@property (nonatomic,strong)UIButton *addSupportBtn;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)UIView *replyView;
@property (nonatomic,strong)EaseTextView *replyTextView;
@property (nonatomic,strong)UIButton *replyCancelButton;

@property (nonatomic,strong)ShareView *shareView;

@property (strong, nonatomic) ProjectDetailFootView *footView;

@property (nonatomic, strong) ProjectDetailsObj *projectDetails;// 项目详情数据

// 数据源
@property (nonatomic, strong) NSMutableArray *comments;// 评论数据
@property (nonatomic,strong)NSMutableArray *supportsMutableArr;
@property (nonatomic,strong)NSMutableArray *raiseFundArr;

@property (nonatomic,assign)int repayCount;
@property (nonatomic ,strong) PSGroup *group;

@property (assign, nonatomic) BOOL isCanVoluntary;// 是否无偿回报或无回报
@property (strong, nonatomic) SupportReturnMamager *supportReturnmanager;// 回报列表管理
@property (strong, nonatomic) SupportReturn *freeReturn;// 无偿回报

@property (strong, nonatomic) CommentsObj *replyComment;

@property (nonatomic, readonly) CGFloat previousTextViewContentHeight;

//@property (strong, nonatomic) UIWebView *webView;
//@property (assign, nonatomic) CGFloat webContentHeight;

@property (nonatomic,strong)UIButton *supportBtn;

@property (nonatomic,strong)NSDictionary *defaultAddressDic;

@property (nonatomic,strong)NSString *htmlDescriptionStr;
@end

@implementation WeiProjectDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupInit];
    [self initUI];
    _raiseFundArr = [NSMutableArray array];
    if (_showType != DetailShowTypeReview)
    {
        [MBProgressHUD showStatus:nil toView:self.view];
        [self requestProjectDetailData];
        [self getRaiseFundDate];
        [self getProjectReturnDetailData];
        [self getCommentListData];
    }
    else
    {
        self.infoTableView.mj_footer.hidden = YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDataSource) name:@"UpdateDetailDataSource" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(skipComplainVC) name:@"SkipComplainVC" object:nil];
    
//     @[][0];
}

- (void)skipComplainVC
{
    ComplaintViewController *complainVC = [ComplaintViewController new];
    complainVC.complaintType = @"2";
    complainVC.username = [NSString stringWithFormat:@"%ld",(long)_projectDetails.Id];
    [self.navigationController pushViewController:complainVC animated:YES];
}

- (void)updateDataSource
{
    
    [self requestProjectDetailData];
    [self getProjectReturnDetailData];
    [self getRaiseFundDate];
    [self getCommentListData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)setupInit
{
//    [self backBarItem];
    [self setupBarButtomItemWithImageName:@"nav_back_normal" highLightImageName:nil selectedImageName:nil target:self action:@selector(backButtonClick:) leftOrRight:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyBoardAction:) name:UIKeyboardWillHideNotification object:nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.refershState = RefershStateDown;
    _previousTextViewContentHeight = [self _getTextViewContentH:_replyTextView];
    _repayCount = 0;
    _isCanVoluntary = NO;
    
}

- (void)initUI
{
    if (!_infoTableView)
    {
        [self.view addSubview:self.infoTableView];
        [self.view addSubview:self.bottomView];
        [self.view addSubview:self.replyView];
    }
}

#pragma mark - Action
- (void)projectDetailOpenStateChanged
{
    if (_projectDetails.htmlDescription.length <= 0) return;
    _projectDetails.open = !_projectDetails.open;
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    [_infoTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

#warning TODO - BUG
- (IBAction)gotoAllComment
{
    AllCommentsViewController *vc = [[AllCommentsViewController alloc] init];
    vc.weiPublicId = _projectDetails.Id;
    vc.canReply = [[User shareUser].Id intValue] == _projectDetails.userId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backButtonClick:(UIButton *)sender
{
    if ([_type isEqual:@"发布"]) {
        
        //BaseNavigationController *navigationController;
        //AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //appDelegate.mainController.selectedIndex = 3;
        //appDelegate.mainController.navigationItem.title = @"个人中心";
        //appDelegate.mainController.ok = NO;
        //navigationController = [[BaseNavigationController alloc] initWithRootViewController:appDelegate.mainController];
        //appDelegate.window.rootViewController =navigationController;
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate.mainController setSelectedIndex:3];
        appDelegate.mainController.navigationItem.title = @"个人中心";
        appDelegate.mainController.ok = NO;
        [self.navigationController popToViewController:appDelegate.mainController animated:YES];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)cancelReplyAction
{
    [_replyTextView resignFirstResponder];
    _replyTextView.text = @"";
}

//   加入群组
- (void)addGroupBtnClick
{
    if (_showType == DetailShowTypeReal)
    {
        if (![User isLogin])
        {
            [self gotoLogin];
            return;
        }
        [self requestJoinGroupChat];
    }
    else
    {
        [MBProgressHUD showMessag:@"发起项目成功后就可以结识更多志同道合小伙伴哦" toView:self.view];
    }
}
//   单个支持
- (void)gotoSupportReturnIndexPath:(NSIndexPath *)indexPath
{
    if (_supportReturnmanager.supportReturns.count)
    {
        // 项目状态
        if (_projectDetails.statusId != 0) return;
//        {
//            if (_showType == DetailShowTypeReview) return;
//            [MBProgressHUD showMessag:@"此项目已不参与支持！" toView:self.view];
//            return;
//        };
        
        // 自己的项目
        if (_projectDetails.userId == [[User shareUser].Id integerValue])
        {
            [MBProgressHUD showMessag:@"不能支持自己发布的项目！" toView:self.view];
            return;
        }
        
        if (![User isLogin])
        {
            [self gotoLogin];
            return;
        }
        
        SupportReturn *support = [_supportReturnmanager.supportReturns objectAtIndex:indexPath.row];
        
        SupportMethodViewController *vc = [[SupportMethodViewController alloc] init];
        vc.support = support;
        vc.addressDic = _defaultAddressDic;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//    支持所有
- (void)supportBtnClick:(UIButton *)sender
{
    if (_supportReturnmanager.supportReturns.count)
    {
        // 项目状态
        if (_projectDetails.statusId != 0){
            [MBProgressHUD showMessag:@"该项目已结束，无法支持" toView:self.view];
            return;
        }
        //        {
        //            if (_showType == DetailShowTypeReview) return;
        //            [MBProgressHUD showMessag:@"此项目已不参与支持！" toView:self.view];
        //            return;
        //        };
        
        // 自己的项目
        if (_projectDetails.userId == [[User shareUser].Id integerValue])
        {
            [MBProgressHUD showMessag:@"不能支持自己发布的项目！" toView:self.view];
            return;
        }
        
        if (![User isLogin])
        {
            [self gotoLogin];
            return;
        }
        
        SupportAllMethodViewController *vc = [[SupportAllMethodViewController alloc] init];
        vc.supportArr = _supportReturnmanager.supportReturns;
        vc.canReturn = _isCanVoluntary;
        vc.crowdFundId = _projectDetails.Id;
        vc.addressDic = _defaultAddressDic;
        if (_freeReturn.Id)
        {
            vc.repayId = _freeReturn.Id;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }else if (_isCanVoluntary || _supportReturnmanager.supportReturns.count == 0){
        
        [self freeSupportAction];
    }
}

- (void)freeSupportAction
{
    if (_showType == DetailShowTypeReview)
    {
        return;
    }

    // 项目状态
    if (_projectDetails.statusId != 0)
    {
//        [MBProgressHUD showMessag:@"此项目已经不参与支持！" toView:self.view];
        return;
    };
    
    // 自己的项目
    if (_projectDetails.userId == [[User shareUser].Id integerValue])
    {
        [MBProgressHUD showMessag:@"不能支持自己发布的项目！" toView:self.view];
        return;
    }
    
    if (![User isLogin])
    {
        [self gotoLogin];
        return;
    }
    
    GoSupportViewController *goSupportVC = [[GoSupportViewController alloc] init];
    goSupportVC.crowdFundId = _projectDetails.Id;
    if (_freeReturn.Id)
    {
        goSupportVC.repayId = _freeReturn.Id;
    }
    [self.navigationController pushViewController:goSupportVC animated:YES];
}

//  发表评论
- (void)addCommentBtnClick
{
    if (_showType == DetailShowTypeReal)
    {
        if (![User isLogin])
        {
            [self gotoLogin];
            return;
        }
        
        _replyComment = nil;
        
        [_replyTextView becomeFirstResponder];
        _bottomView.hidden = YES;
        _replyView.hidden = NO;
    }
    else
    {
        [MBProgressHUD showMessag:@"发布项目后，可以收到大家的谏言哦" toView:self.view];
    }
}

//  点击分享
- (void)sharedBtnClick
{
//    if (![User isLogin])
//    {
//        [self gotoLogin];
//        return;
//    }
    if (!_shareView.superview)
    {
        _shareView =  [[[NSBundle mainBundle] loadNibNamed:@"ShareView" owner:self options:nil] firstObject];
        [_shareView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _shareView.delegate = self;
        _shareView.projectId = _projectId;
        [self.view addSubview:_shareView];
        return;
    }
    _shareView.hidden = !_shareView.hidden;
}

#pragma mark - KeyBoard
- (void)hideKeyBoardAction:(NSNotification *)noti
{
    _bottomView.hidden = NO;
    _replyView.hidden = YES;
}

#pragma mark - Request
- (void)requestJoinGroupChat
{
    [self.httpUtil requestDic4MethodName:@"Group/JoinChat" parameters:@{@"CrowdFundId":@(_projectId)} result:^(NSDictionary *dic, int status, NSString *msg)
     {
         if (status == 1 || status == 2)
         {
             NSString *groupId = _group.easemobGroupId;
             ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:groupId
                                                                                         conversationType:eConversationTypeGroupChat];
             chatController.group = _group;
             chatController.title = _group.groupName;
             [self.navigationController pushViewController:chatController animated:YES];
         }
         else
         {
             [MBProgressHUD showMessag:msg toView:self.view];
         }
     }];
}

//  请求项目筹款动态
- (void)getRaiseFundDate
{
//    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"CrowdFund/FundDynamic" parameters:@{@"CrowdFundId":@(_projectId),@"PageIndex":@(1),@"PageSize":@(5)} result:^(NSDictionary *dic, int status, NSString *msg) {
//        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1 || status == 2) {
            _raiseFundArr = [[dic objectForKey:@"DynamicList"] objectForKey:@"DataSet"];
//            [MBProgressHUD dismissHUDForView:self.view];
        }else{
            [MBProgressHUD dismissHUDForView:self.view withError:@"又跑哪里玩去了，等阿么找找/(ㄒoㄒ)/~~"];
        }
        [_infoTableView reloadData];
    }];
}

//  请求评论列表
- (void)getCommentListData
{
//    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"Comment/Get" parameters:@{@"CrowdFundId":@(_projectId)} result:^(NSDictionary *dic, int status, NSString *msg) {
//        [MBProgressHUD dismissHUDForView:self.view];
        if ( status == 1 || status == 2) {
            // 评论
            NSArray *comments = [ReflectUtil reflectDataWithClassName:@"CommentsObj" otherObject:[dic objectForKey:@"DataSet"] isList:YES];
            [self.comments removeAllObjects];
            [self.comments addObjectsFromArray:comments];
            
            if (self.comments.count > 3)
            {
                // 添加看看全部评论按钮
                _infoTableView.tableFooterView = self.footView;
            }
            [_infoTableView reloadData];
//            [MBProgressHUD dismissHUDForView:self.view];
        }else{
            [MBProgressHUD dismissHUDForView:self.view];
            [MBProgressHUD dismissHUDForView:self.view withError:@"又跑哪里玩去了，等阿么找找/(ㄒoㄒ)/~~"];
        }
    }];
}

//  请求回报详情
- (void)getProjectReturnDetailData
{
//    [MBProgressHUD showStatus:nil toView:self.view];
    [self.httpUtil requestDic4MethodName:@"Repay/Get" parameters:@{@"CrowdFundId":@(_projectId)} result:^(NSDictionary *dic, int status, NSString *msg) {
//        [MBProgressHUD dismissHUDForView:self.view];
        if ( status == 1 || status == 2) {
            // 是否无偿回报
            NSDictionary *customerRepayDic = [dic objectForKey:@"customerRepay"];
            if (customerRepayDic.allKeys.count)
            {
                _freeReturn = [ReflectUtil reflectDataWithClassName:@"SupportReturn" otherObject:customerRepayDic];
                _isCanVoluntary = YES;
            }
            
            // 回报列表
            NSArray *supportReturns = [ReflectUtil reflectDataWithClassName:@"SupportReturn" otherObject:[dic objectForKey:@"DataSet"]  isList:YES];
            
            if(supportReturns.count)
            {
                _supportReturnmanager = [[SupportReturnMamager alloc] init];
                _supportReturnmanager.supportReturns = supportReturns;
                _supportReturnmanager.isOpen = YES;
            }
            [_infoTableView reloadData];
//            [MBProgressHUD dismissHUDForView:self.view];
        }else{
            [MBProgressHUD dismissHUDForView:self.view];
            [MBProgressHUD dismissHUDForView:self.view withError:@"又跑哪里玩去了，等阿么找找/(ㄒoㄒ)/~~"];
        }
    }];
}

//  请求项目详情
- (void)requestProjectDetailData
{
    [self.httpUtil requestDic4MethodName:@"CrowdFund/Details" parameters:@{@"Id":@(_projectId)} result:^(NSDictionary *dic, int status, NSString *msg)
    {
//        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1 || status == 2)
        {
            self.projectDetails = [ReflectUtil reflectDataWithClassName:@"ProjectDetailsObj" otherObject:[dic objectForKey:@"crowdView"]];
            _supportsMutableArr = [[dic objectForKey:@"supports"] isKindOfClass:[NSArray class]]?[dic objectForKey:@"supports"]:nil;
            _defaultAddressDic = [dic objectForKey:@"DefaultAddress"];
            _group = [ReflectUtil reflectDataWithClassName:@"PSGroup" otherObject:[dic objectForKey:@"group"]];
//            // 评论
//            NSArray *comments = [ReflectUtil reflectDataWithClassName:@"CommentsObj" otherObject:[dic objectForKey:@"commentList"] isList:YES];
//            [self.comments removeAllObjects];
//            [self.comments addObjectsFromArray:comments];
//            
//            if (self.comments.count > 3)
//            {
//                // 添加看看全部评论按钮
//                _infoTableView.tableFooterView = self.footView;
//            }
            
//            // 是否无偿回报
//            NSDictionary *customerRepayDic = [[dic objectForKey:@"repaysList"] valueForKey:@"customerRepay"];
//            if (customerRepayDic.allKeys.count)
//            {
//               _freeReturn = [ReflectUtil reflectDataWithClassName:@"SupportReturn" otherObject:customerRepayDic];
//                _isCanVoluntary = YES;
//            }
//            
//            if (!self.projectDetails.isExistRepayWay)
//            {
//                _isCanVoluntary = YES;
//            }
            
//            // 回报列表
//            NSArray *supportReturns = [ReflectUtil reflectDataWithClassName:@"SupportReturn" otherObject:[[dic objectForKey:@"repaysList"] valueForKey:@"repayList"] isList:YES];
//            
//            if(supportReturns.count)
//            {
//                _supportReturnmanager = [[SupportReturnMamager alloc] init];
//                _supportReturnmanager.supportReturns = supportReturns;
//                _supportReturnmanager.isOpen = YES;
//            }
//
//            if (_projectDetails.htmlDescription.length > 0)
//            {
//                [self.webView loadHTMLString:[NSString stringWithFormat:@"<html><head> <style> img { width: %.fpx ;height: auto } </style> </head><body> %@ </body></html>",[UIScreen mainScreen].bounds.size.width,_projectDetails.htmlDescription] baseURL:nil];
//            }
//            else
//            {
                [_infoTableView reloadData];
                [MBProgressHUD dismissHUDForView:self.view];
//            }
            
        }else
        {
            [MBProgressHUD dismissHUDForView:self.view];
            [MBProgressHUD dismissHUDForView:self.view withError:@"又跑哪里玩去了，等阿么找找/(ㄒoㄒ)/~~"];
        }
        
        if (_projectDetails.userId == [[User shareUser].Id integerValue] || _showType == DetailShowTypeReview)
        {
            [_supportBtn setBackgroundColor:[UIColor colorWithHexString:@"#DDDDDD"]];
        }else{
            [_supportBtn setBackgroundColor:[UIColor colorWithHexString:@"#FBB652"]];
        }
        
        [self addNavi];
    }];
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
    NSString *relpyText = [NSString encodeString:_replyTextView.text];
    [self.httpUtil requestDic4MethodName:@"Comment/Reply" parameters:@{@"Id":@(_replyComment.Id),@"ReplyMsg":relpyText } result:^(NSDictionary *dic, int status, NSString *msg)
     {
         if (status == 1 || status == 2)
         {
             //输入后 给模型赋值 记录模型
             _replyComment.replyMsg = relpyText;
             _replyComment.replyNickname = _projectDetails.nickName;
             _replyComment.modifyDate = @"刚刚";
             NSInteger index = [_comments indexOfObject:_replyComment];
             NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:6];
             [_infoTableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
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
    NSString *commentText = [NSString encodeString:_replyTextView.text];
    [self.httpUtil requestDic4MethodName:@"Comment/Post" parameters:@{@"CrowdFundId":@(_projectId),@"CommentMsg":commentText} result:^(NSDictionary *dic, int status, NSString *msg)
     {
        if (status == 1 || status == 2)
        {
            NSArray *comments = [dic valueForKey:@"DataSet"];
            CommentsObj *comment = [ReflectUtil reflectDataWithClassName:@"CommentsObj" otherObject:[comments firstObject]];
            
            if (_comments.count == 3)
            {
                 [_comments removeLastObject];
            }
            
            [self.comments insertObject:comment atIndex:0];
            
            if(!_comments && _comments.count > 3)
            {
                _infoTableView.tableFooterView = self.footView;
            }
            if (_comments.count == 1) {
                [_infoTableView reloadData];
            }else{
                [_infoTableView reloadSections:[NSIndexSet indexSetWithIndex:6] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
        else
        {
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
    
    _replyTextView.text = @"";
}

#pragma mark - ShareViewDelegate
- (void)clikeShareType:(NSString *)shareType
{
    NSString *sharePushUrl = [NSString stringWithFormat:@"http://www.mochoujun.com/app#/crowdfund/%d",_projectId];
    NSArray *array = [_projectDetails.images componentsSeparatedByString:@","];
    NSString *title = [NSString stringWithFormat:@"%@-陌筹君",_projectDetails.name];

    [ShareUtil postShareWithShareType:shareType title:title content:@"www.mochoujun.com/app" urlResource:array[0] clickPushUrl:sharePushUrl presentedController:self completion:^(UMSocialResponseEntity *response) {
        if (response.responseCode == UMSResponseCodeSuccess)
        {
            [MBProgressHUD showSuccess:@"你成功把阿么推出江湖啦" toView:nil];
        }
        else
        {
            [MBProgressHUD showError:@"没有把阿么推荐出去哦" toView:nil];
        }
        
    }];
}

//#pragma mark - UIWebViewDelegate
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    //调整字号
//    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'";
//    [webView stringByEvaluatingJavaScriptFromString:str];
//
//    _webContentHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement?document.documentElement.offsetHeight:document.body.offsetHeight"] floatValue];
//    _webView.height = _webContentHeight;
//    [_infoTableView reloadData];
//    [MBProgressHUD dismissHUDForView:self.view];
//}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    switch (section) {
        case 0:
            rows = 1;
            break;
        case 1:
            rows = 1;
            break;
        case 2:
//            if (_isCanVoluntary)
//            {
//                rows = 1;
//            }
            if (_supportReturnmanager || _supportReturnmanager.supportReturns.count > 0 )
            {
                rows = 1;
            }
            break;
        case 3:
            if (_supportReturnmanager.supportReturns.count)
            {
                if (!_supportReturnmanager.isOpen) {
                    rows = 1;
                }else{
                    rows = _supportReturnmanager.supportReturns.count;
                }
            }
            break;
        case 4:
            if (_raiseFundArr.count) {
                if (_raiseFundArr.count > 3) {
                    rows = 5;
                }else{
                    rows = _raiseFundArr.count + 1;
                }
            }
            break;
        case 5:
            if (_comments.count)
            {
                rows = 1;
            }
            break;
        case 6:
            if (_comments.count)
            {
                if (_comments.count >= 3) {
                    rows = 3;
                }else{
                    rows = _comments.count;
                }
            }
            break;
    }
    
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
//        if (_projectDetails.htmlDescription.length > 0)
//        {
//            NSLog(@"%d",_projectDetails.open);
//            CGFloat basicHeight = _webView.frame.origin.y;
//            return _projectDetails.open?_webContentHeight + basicHeight:basicHeight;
//        }
//        else
//        {
        NSLog(@"------%f",_projectDetails.currentCellHeight);
            return  _projectDetails.currentCellHeight;//#warning TODO - 改动
//        }
    }
    else if (indexPath.section == 1)
    {
        return 117;
    }
    else if (indexPath.section == 2)
    {
        if (!_supportReturnmanager || _supportReturnmanager.supportReturns.count == 0 )
        {
            return 0.000001;
        }
        return _isCanVoluntary?80:35;
    }
    else if (indexPath.section == 3)
    {
        if (!_supportReturnmanager || _supportReturnmanager.supportReturns.count == 0 )
        {
            return 0.000001;
        }
//        SupportReturn *support = [_supportReturnmanager.supportReturns objectAtIndex:indexPath.row];
//        return [support contentHeight];
        return 120;
    }else if (indexPath.section == 4){
        if (_raiseFundArr.count) {
            if (indexPath.row == 0) {
                return 35;
            }
            if (_raiseFundArr.count > 3) {
                if (indexPath.row == 4){
                    return 50;
                }
            }
            return 75;
        }
        return 0.000001;
    }
    else if (indexPath.section == 5)
    {
        if (_comments.count) {
            return 35;
        }
        return 0.000001;
    }else if (indexPath.section == 6){
        CommentsObj *data = [_comments objectAtIndex:indexPath.row];
        NSString *_id = !IsStrEmpty(data.replyMsg)?commentReturnedCellIden:commentCellIden;
        return [tableView fd_heightForCellWithIdentifier:_id cacheByIndexPath:indexPath configuration:^(UITableViewCell *cell)
                {
                    [cell performSelector:@selector(setData:) withObject:data];
                }];
    }
    else
    {
        return 0 ;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat headerH = 0.000001;
    switch (section)
    {
        case 0:
            
            break;
        case 1:
            headerH = 14.0;
            break;
        case 2:
//            if (_isCanVoluntary)
//            {
//                headerH = 14.0;
//            }
            if (_supportReturnmanager.supportReturns.count)
            {
               headerH = 14.0;
            }
            
            break;
        case 3:
            if (_supportReturnmanager.supportReturns.count)
            {
//                if (_isCanVoluntary)
//                {
//                    headerH = 1.0;
//                }else{
//                    headerH = 14.0;
//                }
                headerH = 1.0;
            }
            break;
        case 4:
            if (_raiseFundArr.count) {
                headerH = 14.0;
            }
            break;
        case 5:
            if (_comments.count)
            {
                headerH = 14.0;
            }
            break;
        case 6:
            if (_comments.count)
            {
                headerH = 1.0;
            }
            break;
    }
    return headerH;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
//    if (_projectDetails.htmlDescription.length > 0 && section == 0)
//    {
//        UIButton *button = [self openStateBuddon];
//        return button;
//    }
//    else
    if (section == 3 && _supportReturnmanager.supportReturns.count > 1)
    {
        ProjectReturnHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"ProjectReturnHeaderView" owner:nil options:nil] lastObject];
        headerView.supportReturnManager = _supportReturnmanager;
        headerView.delegate = self;
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if (_projectDetails.htmlDescription.length > 0 && section == 0)
//    {
//        return 32.0;
//    }
//    else
    if (section == 3 && _supportReturnmanager.supportReturns.count > 1)
    {
        return 44.0;
    }
    return 0.00001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
//        if (_projectDetails.htmlDescription.length > 0)
//        {
//            ProjectHtmlContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WebCell"];
//            if (!cell)
//            {
//                cell = [tableView dequeueReusableCellWithIdentifier:projectHtmlContentCell forIndexPath:indexPath];
//                cell.clipsToBounds = YES;
//                cell.projectDetail = _projectDetails;
//                [cell addSubview:_webView];
//            }
//            return cell;
//        }
//        else
//        {
            ProjectContentCell *cell = [tableView dequeueReusableCellWithIdentifier:projectContentCellIden forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (_projectDetails.userId == [[User shareUser].Id integerValue]){
                cell.addProjectDetailsBtn.hidden = NO;
            }else{
                cell.addProjectDetailsBtn.hidden = YES;
            }
            if (_projectDetails.statusId != 0) {
                cell.addProjectDetailsBtn.hidden = YES;
            }
            [cell.addProjectDetailsBtn addTarget:self action:@selector(addProjectDetailsBtnClick) forControlEvents:UIControlEventTouchUpInside];
            cell.projectDetail = _projectDetails;
            cell.delegate = self;
            return cell;
//        }
    }
    else if (indexPath.section == 1)
    {
        WeiSupportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:weiSupportCellIden forIndexPath:indexPath] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.projectDetails = _projectDetails;
        cell.supportMutableArr = _supportsMutableArr;
        return cell;
    }
    else if (indexPath.section == 2)
    {
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FreeReturnCell"];
//        if (!cell)
//        {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FreeReturnCell"];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.textLabel.text = @"无需回报友情支持";
//            cell.textLabel.textColor =RGB(88, 88, 88);
//            cell.textLabel.font = [UIFont systemFontOfSize:15];
//            
//            UIButton *suportButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            suportButton.frame = CGRectMake(SCREEN_WIDTH - 74 - 7, 60 * 0.5 - 24 * 0.5, 74, 24);
//            suportButton.titleLabel.font = [UIFont systemFontOfSize:13];
//            [suportButton setTitle:@"立即支持" forState:UIControlStateNormal];
//            [suportButton setTitle:@"立即支持" forState:UIControlStateSelected];
//            [suportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [suportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//            
//            suportButton.userInteractionEnabled = NO;
//            [suportButton setBackgroundImage:[UIImage imageNamed:@"loginBack"] forState:UIControlStateNormal];
//            [suportButton setBackgroundImage:[UIImage imageNamed:@"login_black"] forState:UIControlStateDisabled];
//            [cell.contentView addSubview:suportButton];
//            
//            if (_projectDetails.statusId != 0 )
//            {
//                suportButton.enabled = NO;
//            }
//
//        }
        NoReturnSupportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noReturnSupport forIndexPath:indexPath] ;
        cell.clipsToBounds = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!_isCanVoluntary)
        {
            cell.noReturnSupportLab.hidden = YES;
            cell.noReturnPeopleLab.hidden = YES;
            cell.goSupportBtn.hidden = YES;
            
        }else{
            cell.noReturnSupportLab.hidden = NO;
            cell.noReturnPeopleLab.hidden = NO;
            cell.goSupportBtn.hidden = NO;
            [cell.goSupportBtn setImage:[UIImage imageNamed:@"go_support"] forState:UIControlStateNormal];
        }
        if (_projectDetails.userId == [[User shareUser].Id integerValue]){
            cell.noReturnPeopleLab.hidden = YES;
            cell.goSupportBtn.hidden = YES;
            cell.addReturnBtn.hidden = NO;
            
        }else{
            cell.noReturnPeopleLab.hidden = NO;
            cell.goSupportBtn.hidden = NO;
            cell.addReturnBtn.hidden = YES;
            [cell.goSupportBtn setImage:[UIImage imageNamed:@"go_support"] forState:UIControlStateNormal];
        }
        if (_projectDetails.statusId != 0) {
            cell.noReturnPeopleLab.hidden = YES;
            cell.goSupportBtn.hidden = YES;
            cell.addReturnBtn.hidden = NO;
        }
        [cell.addReturnBtn addTarget:self action:@selector(addReturnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [cell.goSupportBtn addTarget:self action:@selector(goReturnSupport:) forControlEvents:UIControlEventTouchUpInside];
        if (_projectDetails.statusId != 0 )
        {
            
            [cell.goSupportBtn setImage:[UIImage imageNamed:@"nogo_support"] forState:UIControlStateNormal];
        }
        return cell;
    }
    else if (indexPath.section == 3)
    {
        SupportReturn *support = [_supportReturnmanager.supportReturns objectAtIndex:indexPath.row];
        SupportProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:supportProjectIden forIndexPath:indexPath];
        cell.clipsToBounds = YES;
        cell.cellStyle = SupportProjectCellStyleReturn;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.support = support;
        cell.projectStates = _projectDetails.statusId;
        cell.projectUerId = _projectDetails.userId;
        [cell.moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.moreBtn.tag = indexPath.row;
        return cell;
    }else if (indexPath.section == 4){
        if (indexPath.row == 0) {
            HeadTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:headerTitle forIndexPath:indexPath];
            cell.clipsToBounds = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.headerTitleLab.text = @"筹款动态";
            return cell;
        }else if (indexPath.row == 4){
            AllRaiseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:allRaise forIndexPath:indexPath];
            cell.clipsToBounds = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.allRaiseBtn addTarget:self action:@selector(allRaiseBtnClick) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }else{
            RaiseFundsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:raiseFunds forIndexPath:indexPath];
            cell.clipsToBounds = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.raiseFundUserIconBtn addTarget:self action:@selector(raiseFundUserIconBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.raiseFundUserIconBtn.tag = indexPath.row - 1;
            cell.raiseFundDic = _raiseFundArr[indexPath.row - 1];
            
            
            return cell;
        }
        return nil;
    }
    else if(indexPath.section == 5)
    {
        HeadTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:headerTitle forIndexPath:indexPath];
        cell.clipsToBounds = YES;
        cell.headerLineView.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 6){
        CommentsObj *data = [_comments objectAtIndex:indexPath.row];
        NSString *_id = nil;
        if (!IsStrEmpty(data.replyMsg))
        {
            _id = commentReturnedCellIden;
        }
        else
        {
            _id = commentCellIden;
        }
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_id forIndexPath:indexPath];
        if ([cell isKindOfClass:[CommentsTableViewCell class]])
        {
            CommentsTableViewCell *commentsCell = (CommentsTableViewCell *)cell;
            commentsCell.canReply = [[User shareUser].Id intValue] == _projectDetails.userId;
            commentsCell.delegate = self;
        }
        else if ([cell isKindOfClass:[CommentReturnedCell class]])
        {
            CommentReturnedCell *commentReturnCell = (CommentReturnedCell *)cell;
            commentReturnCell.delegate = self;
        }
        [cell performSelector:@selector(setData:) withObject:data];
        
        return cell;
    }
    else
    {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return;
    }
    if (![_replyTextView isFirstResponder] && indexPath.section == 1 && _supportsMutableArr.count != 0 && _showType != DetailShowTypeReview )
    {
        SupportPeopleViewController *supportPeopleVC = [[SupportPeopleViewController alloc] init];
        supportPeopleVC.projectId = _projectDetails.Id;
        [self.navigationController pushViewController:supportPeopleVC animated:YES];
        return;
    }
    
    switch (indexPath.section)
    {
        case 3:
//            [self gotoSupportReturnIndexPath:indexPath];
            break;
        case 4:
            break;
        case 5:
            break;
        case 6:
            break;
    }
}

- (void)supportProjectCellReturnPeople:(SupportProjectTableViewCell *)cell
{
    NSIndexPath *indexPath = [_infoTableView indexPathForCell:cell];
    [self gotoSupportReturnIndexPath:indexPath];
}

//   添加项目详情
- (void)addProjectDetailsBtnClick
{
    AddProjectDetailsViewController *addProjectDetailsVC = [AddProjectDetailsViewController new];
    addProjectDetailsVC.projectId = _projectId;
    addProjectDetailsVC.titleStr = _projectDetails.name;
    addProjectDetailsVC.projectImageArr = [_projectDetails.images componentsSeparatedByString:@","];
    addProjectDetailsVC.projectContentStr = _projectDetails.content;
    addProjectDetailsVC.uploadCount = [_projectDetails.images componentsSeparatedByString:@","].count;
    [self.navigationController pushViewController:addProjectDetailsVC animated:YES];
}
//   查看全部筹款动态
- (void)allRaiseBtnClick
{
    RaiseFundsViewController *raiseFundsVC = [RaiseFundsViewController new];
    raiseFundsVC.projectId = _projectId;
    [self.navigationController pushViewController:raiseFundsVC animated:YES];
}
//  筹款动态的头像跳转
- (void)raiseFundUserIconBtnClick:(UIButton *)sender
{
    if ([User isLogin])
    {
        FriendDetailViewController *friendDetailsVC = [[FriendDetailViewController alloc] init];
        NSDictionary *dic = _raiseFundArr[sender.tag];
        friendDetailsVC.username = [dic objectForKey:@"UserName"];
        [self.navigationController pushViewController:friendDetailsVC animated:YES];
    }else{
        [self gotoLogin];
    }
}
//   更多跳转
- (void)moreBtnClick:(UIButton *)sender
{
    MoreReturnContentViewController *moreReturnVC = [MoreReturnContentViewController new];
    SupportReturn *support = [_supportReturnmanager.supportReturns objectAtIndex:sender.tag];
    moreReturnVC.returnContentStr = support.Description;
    [self.navigationController pushViewController:moreReturnVC animated:YES];
}

//   三期添加回报按钮
- (void)addReturnEvent:(UIButton *)sender
{
    AddProjectReturnViewController *addProjectReturnVC = [AddProjectReturnViewController new];
    addProjectReturnVC.addType = @"AddReturn";
    addProjectReturnVC.crowdFundId = _projectId;
    addProjectReturnVC.titleStr = _projectDetails.name;
    addProjectReturnVC.projectImageArr = [_projectDetails.images componentsSeparatedByString:@","];
    [self.navigationController pushViewController:addProjectReturnVC animated:YES];
}

//  友情支持按钮点击
- (void)goReturnSupport:(UIButton *)sender
{
    if (_isCanVoluntary)
    {
        [self freeSupportAction];
    }
}

#pragma mark - UIScrollViewDelegate
//  设置头部偏移
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.infoTableView)
    {
        //记录出上一次滑动的距离，因为是在tableView的contentInset中偏移的ScrollHeadViewHeight，所以都得加回来
        CGFloat offsetY = scrollView.contentOffset.y;
        CGFloat seleOffsetY = offsetY - self.scrollY;
        self.scrollY = offsetY;
        
        //修改顶部的scrollHeadView位置 并且通知scrollHeadView内的控件也修改位置
        CGRect headRect =  self.topView.frame;
        headRect.origin.y = headRect.origin.y - seleOffsetY;
        self.topView.frame = headRect;
  
        //根据偏移量算出alpha的值,渐隐,当偏移量大于-180开始计算消失的值
        CGFloat startF = -180;
        //初始的偏移量Y值为 顶部俩个控件的高度
        CGFloat initY =  ScrollHeadViewHeight;
        //缺少的那一段渐变Y值
        CGFloat lackY = initY + startF;
        //自定义导航条高度
        CGFloat naviH = 64;
        
        //渐隐alpha值
        CGFloat alphaScaleShow = (offsetY + initY - lackY) /  (initY - naviH - lackY) ;
        
        if (alphaScaleShow >= 0.98)
        {
            //显示导航条
            [self.backBtn setImage:[UIImage imageNamed:@"nav_back_normal"] forState:UIControlStateNormal];
            
            [self.sharedBtn setImage:[UIImage imageNamed:@"circel_more"] forState:UIControlStateNormal];
            [UIView animateWithDuration:0.04 animations:^{
                self.naviView.alpha = 1;
                self.titleLab.hidden = NO;
            }];
        }
        else
        {
            [self.sharedBtn setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
            [self.backBtn setImage:[UIImage imageNamed:@"backagain"] forState:UIControlStateNormal];
            self.naviView.alpha = 0;
            self.titleLab.hidden = YES;
        }
        
        CGFloat offsetValue = -offsetY - ScrollHeadViewHeight;
        CGFloat scaleTopView = 1 + offsetValue/ScrollHeadViewHeight;
        scaleTopView = offsetValue > 0.0 ? scaleTopView : 1;
        CGAffineTransform transform = CGAffineTransformMakeScale(scaleTopView, scaleTopView );
        CGFloat ty = (scaleTopView - 1) * ScrollHeadViewHeight;
        self.topView.transform = CGAffineTransformTranslate(transform, 0,- ty*0.4);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - ProjectReturnHeaderViewDelegate
- (void)projectReturnCellOpenStateChanged:(ProjectReturnHeaderView *)headerView
{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:3];
    [_infoTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - ProjectContentCellDelegate
- (void)projectContentCellOpenStateChanged:(ProjectContentCell *)cell
{
    ProjectDetailsWebViewController *projectDetailsWebVC = [ProjectDetailsWebViewController new];
    projectDetailsWebVC.images = [_projectDetails.images componentsSeparatedByString:@","];
    if (_projectDetails.htmlDescription.length > 0) {
        projectDetailsWebVC.dataStr = _projectDetails.htmlDescription;
    }else{
        
        projectDetailsWebVC.dataStr = [NSString stringWithFormat:@"%@\n%@",_projectDetails.content,_projectDetails.addHtmlDescription];
//        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
//        [_infoTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [self.navigationController pushViewController:projectDetailsWebVC animated:YES];
}

#pragma mark - UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"])
    {
        if (_replyComment)
        {
            [self requestReplyCommment];
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
        if (_replyComment){
            _replyTextView.placeHolder = [NSString stringWithFormat:@"回复:%@",_replyComment.commentNickname];
        }else{
            _replyTextView.placeHolder = @"我来说两句...";
        }
        
    }
    [self _willShowInputTextViewToHeight:[self _getTextViewContentH:textView]];
}

- (CGFloat)_getTextViewContentH:(UITextView *)textView
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    }
    else
    {
        return textView.contentSize.height;
    }
}

- (void)_willShowInputTextViewToHeight:(CGFloat)toHeight
{
    if (toHeight < kInputViewMinHeight)
    {
        toHeight = kInputViewMinHeight;
    }
    
    if (toHeight > kInputViewMaxHeight)
    {
        toHeight = kInputViewMaxHeight;
    }
    
    if (toHeight != _previousTextViewContentHeight)
    {
        CGFloat changeHeight = toHeight - _previousTextViewContentHeight;
        _replyView.height += changeHeight;
        _previousTextViewContentHeight = toHeight;
    }
}

#pragma mark CommentsTableViewCellDelegate
- (void)commentsTableViewCellReply:(CommentsTableViewCell *)cell replyModel:(CommentsObj *)model
{
    _replyView.hidden = NO;
    [self.replyTextView performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.3];
    _replyComment = model;
    _replyTextView.placeHolder = [NSString stringWithFormat:@"回复:%@",_replyComment.commentNickname];
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

#pragma mark - WeiSupportTableViewCellDelegate
//  发起者头像点击跳转
- (void)weiSupportTableViewCell:(WeiSupportTableViewCell *)cell supportProject:(id)project
{
    if (_showType == DetailShowTypeReal)
    {
        if ([User isLogin])
        {
            if (!IsStrEmpty(_projectDetails.userName)) {
                FriendDetailViewController *friendDetailsVC = [[FriendDetailViewController alloc] init];
                friendDetailsVC.username = _projectDetails.userName;
                [self.navigationController pushViewController:friendDetailsVC animated:YES];
            }
        }
        else
        {
            [self gotoLogin];
        }
    }
}

#pragma mark - Setter & Getter
//- (UIWebView *)webView
//{
//    if (!_webView)
//    {
//        CGFloat y = [ProjectHtmlContentCell basicHeightWithProjectDetail:_projectDetails];
//        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, 0)];
//        _webView.delegate = self;
//        _webView.scrollView.scrollEnabled = NO;
//    }
//    return _webView;
//}

- (UIButton *)openStateBuddon
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0,SCREEN_WIDTH,32);
    NSString *title = _projectDetails.open?@"收起详情":@"查看详情";
    NSString *imageName = _projectDetails.open?@"收起":@"arrow";
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor colorWithHexString:@"#7F7F7F"] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 50);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 110, 0, 0);
    [button addTarget:self action:@selector(projectDetailOpenStateChanged) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    lineView.frame = CGRectMake(0, 0, SCREEN_WIDTH,1);
    [button addSubview:lineView];
    return button;
}

- (ProjectDetailFootView *)footView
{
    if (!_footView)
    {
        _footView = [[[NSBundle mainBundle] loadNibNamed:@"ProjectDetailFootView" owner:self options:nil] lastObject];
        _footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    }
    return _footView;
}

- (UITableView *)infoTableView
{
    if (!_infoTableView)
    {
        _infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50) style:UITableViewStyleGrouped];
        _infoTableView.delegate = self;
        _infoTableView.dataSource = self;
        
        _infoTableView.contentInset = UIEdgeInsetsMake(ScrollHeadViewHeight, 0, 0, 0);
        _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_infoTableView registerNib:[UINib nibWithNibName:commentCellIden bundle:nil] forCellReuseIdentifier:commentCellIden];
        [_infoTableView registerNib:[UINib nibWithNibName:commentReturnedCellIden bundle:nil] forCellReuseIdentifier:commentReturnedCellIden];
        [_infoTableView registerNib:[UINib nibWithNibName:weiSupportCellIden bundle:nil] forCellReuseIdentifier:weiSupportCellIden];
        [_infoTableView registerNib:[UINib nibWithNibName:projectContentCellIden bundle:nil] forCellReuseIdentifier:projectContentCellIden];
        [_infoTableView registerNib:[UINib nibWithNibName:supportProjectIden bundle:nil] forCellReuseIdentifier:supportProjectIden];
        [_infoTableView registerNib:[UINib nibWithNibName:projectHtmlContentCell bundle:nil] forCellReuseIdentifier:projectHtmlContentCell];
        [_infoTableView registerNib:[UINib nibWithNibName:noReturnSupport bundle:nil] forCellReuseIdentifier:noReturnSupport];
        [_infoTableView registerNib:[UINib nibWithNibName:headerTitle bundle:nil] forCellReuseIdentifier:headerTitle];
        [_infoTableView registerNib:[UINib nibWithNibName:raiseFunds bundle:nil] forCellReuseIdentifier:raiseFunds];
        [_infoTableView registerNib:[UINib nibWithNibName:allRaise bundle:nil] forCellReuseIdentifier:allRaise];
        _infoTableView.estimatedRowHeight = 90;
    }
    return _infoTableView;
}

- (void)setProjectDetails:(ProjectDetailsObj *)projectDetails
{
    _projectDetails = projectDetails;
    
    //将控制器添加给self
    if (!_topScrollView)
    {
        [self initUI];
        
        NSArray *images;
        if (_projectDetails.Id == 0)// 预览
        {
            images = _projectDetails.reviewImages;
        }
        else
        {
            images = [_projectDetails.images componentsSeparatedByString:@","];
        }
        
        // 添加 topScrollView
        _topScrollView = [WNXScrollHeadView scrollHeadViewWithImages:images];
        _topScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _topScrollView.delegates = self;
        [_topScrollView setFrame:CGRectMake(0, 0, self.view.frame.size.width, ScrollHeadViewHeight)];
        if (_topView == nil) {
            _topView = [[UIView alloc] initWithFrame:self.topScrollView.bounds];
            _topView.backgroundColor = [UIColor redColor];
            [_topView addSubview:self.topScrollView];
            _topView.clipsToBounds = YES;
            [self.view addSubview:_topView];
        }
    }
    
    // 先后顺序
    if (_projectDetails.Id == 0)
    {
        // 添加Navi
        [self addNavi];
        [self.infoTableView reloadData];
    }
}

- (UIView *)replyView
{
    if (!_replyView)
    {
        _replyView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
        _replyView.backgroundColor = [UIColor whiteColor];
        
//        UIImageView *commentImage =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//        commentImage.contentMode = UIViewContentModeCenter;
//        commentImage.image = [UIImage imageNamed:@"comment-project"];
//        [_replyView addSubview:commentImage];
        [_replyView addSubview:self.replyTextView];
        [_replyView addSubview:self.replyCancelButton];
        _replyView.hidden = YES;
    }
    return _replyView;
}

- (UIButton *)replyCancelButton
{
    if (!_replyCancelButton)
    {
        _replyCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_replyCancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_replyCancelButton setBackgroundImage:[UIImage imageNamed:@"loginBack"] forState:UIControlStateNormal];
        _replyCancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _replyCancelButton.frame = CGRectOffset(CGRectMake(0, 8, 53, 30), CGRectGetMaxX(_replyTextView.frame) + 10, 2);
        [_replyCancelButton addTarget:self action:@selector(cancelReplyAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _replyCancelButton;
}

- (EaseTextView *)replyTextView
{
    if (!_replyTextView)
    {
        _replyTextView = [[EaseTextView alloc]initWithFrame:CGRectMake(15, 8, SCREEN_WIDTH - 73 - 15, 34)];
        _replyTextView.font = [UIFont systemFontOfSize:14.0f];
        _replyTextView.textColor = [UIColor colorWithHexString:@"#555555"];
        _replyTextView.delegate = self;
        _replyTextView.layer.cornerRadius = 3.0;
        _replyTextView.returnKeyType = UIReturnKeySend;
        _replyTextView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
        _replyTextView.placeHolder = @"我来说两句...";
        _replyTextView.placeHolderTextColor = AlertTextColor;
    }
    return _replyTextView;
}

- (UIView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
        
        CGFloat buttonWidth = (SCREEN_WIDTH - 1) * 0.5 * 0.5;
        UIButton *addGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addGroupBtn.frame = CGRectMake(0, 1,buttonWidth , 49);
        [addGroupBtn setBackgroundColor:[UIColor whiteColor]];
        [addGroupBtn addTarget:self action:@selector(addGroupBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [addGroupBtn setTitle:@"项目群组" forState:UIControlStateNormal];
        [addGroupBtn setImage:[UIImage imageNamed:@"projectQun"] forState:UIControlStateNormal];
//        [addGroupBtn setTitleColor:[UIColor colorWithHexString:@"#6E6E6E"] forState:UIControlStateNormal];
//        addGroupBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
//        addGroupBtn.imageEdgeInsets = UIEdgeInsetsMake(-17, 30, 0, 0);
//        addGroupBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, -17, 0);
        [_bottomView addSubview:addGroupBtn];
        
        UIButton *addCommentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addCommentBtn.frame = CGRectMake(buttonWidth+1, 1, buttonWidth-1, 49);
        [addCommentBtn addTarget:self action:@selector(addCommentBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [addCommentBtn setBackgroundColor:[UIColor whiteColor]];
//        [addCommentBtn setTitle:@"评论" forState:UIControlStateNormal];
        [addCommentBtn setImage:[UIImage imageNamed:@"pen"] forState:UIControlStateNormal];
//        [addCommentBtn setTitleColor:[UIColor colorWithHexString:@"#6E6E6E"] forState:UIControlStateNormal];
//        addCommentBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
//        addCommentBtn.imageEdgeInsets = UIEdgeInsetsMake(-17, 30, 0, 0);
//        addCommentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, -17, 0);
        [_bottomView addSubview:addCommentBtn];
        
        _supportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _supportBtn.frame = CGRectMake(SCREEN_WIDTH - 2 * buttonWidth, 0, SCREEN_WIDTH * 0.5, 50);
        [_supportBtn addTarget:self action:@selector(supportBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_supportBtn setBackgroundColor:[UIColor colorWithHexString:@"#FBB652"]];
        [_supportBtn setTitle:@"我要支持" forState:UIControlStateNormal];
        _supportBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _supportBtn.tintColor = [UIColor whiteColor];
        [_bottomView addSubview:_supportBtn];
    }
    return _bottomView;
}

- (NSMutableArray *)comments
{
    if (!_comments)
    {
        _comments = [NSMutableArray array];
    }
    return _comments;
}

- (NSDictionary *)defaultAddressDic
{
    if (!_defaultAddressDic) {
        _defaultAddressDic = [NSDictionary dictionary];
    }
    return _defaultAddressDic;
}

//   添加山寨导航条
- (void)addNavi
{
    //初始化山寨导航条
    if (self.naviView == nil) {
        self.naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
        self.naviView.backgroundColor = [UIColor colorWithHexString:@"#FBFD4E"];
        self.naviView.alpha = 0.0;
        [self.view addSubview:self.naviView];
        
        self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backBtn.frame = CGRectMake(10, 20, 40, 40);
        [self.backBtn addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.backBtn setImage:[UIImage imageNamed:@"backagain"] forState:UIControlStateNormal];
//        self.backBtn.contentMode = UIViewContentModeCenter;
        [self.view addSubview:self.backBtn];
        
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 70, 33, 140, 15)];
        if (_projectDetails.name.length <= 9) {
            self.titleLab.text = _projectDetails.name;
        }else{
            self.titleLab.text = [_projectDetails.name substringToIndex:9];
        }
        self.titleLab.hidden = YES;
        [self.view addSubview:self.titleLab];
    }
    
    //分享按钮
    if (_showType == DetailShowTypeReal && [ShareUtil showInstalledThreeButtons].count && self.sharedBtn == nil)
    {
        self.sharedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sharedBtn.frame = CGRectMake(self.view.frame.size.width - 51, 20, 40, 40);
        [self.sharedBtn setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
        [self.sharedBtn addTarget:self action:@selector(sharedBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.sharedBtn];
    }
}

- (void)gotoLogin
{
    LoginViewController * login = [[LoginViewController alloc] init];
    BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:login];
    [self presentViewController:navi animated:YES completion:nil];
}

#pragma mark -  预览
- (void)reviewProjectDetail:(ProjectDetailsObj *)projectDetails supportReturns:(NSArray *)supportReturns
{
    self.showType = DetailShowTypeReview;
    self.projectDetails = projectDetails;
    if(supportReturns.count)
    {
        _supportReturnmanager = [[SupportReturnMamager alloc] init];
        _supportReturnmanager.supportReturns = supportReturns;
        _supportReturnmanager.isOpen = YES;
    }
    else
    {
        _isCanVoluntary = YES;
    }
    [_infoTableView reloadData];
}


@end
