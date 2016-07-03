//
//  ProjectReturnViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 16/4/7.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "ProjectReturnViewController.h"
#import "ProjectReturnTableViewCell.h"
#import "NSString+Adding.h"
#import "AddProjectReturnViewController.h"
#import "MoreReturnContentViewController.h"

@interface ProjectReturnViewController ()<UITableViewDataSource,UITableViewDelegate,AddProjectReturnViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *projectReturnTableView;
@property (weak, nonatomic) IBOutlet UIButton *addReturnBtn;
@property (weak, nonatomic) NSDictionary *currentEditReturnDic;
//@property (nonatomic,strong)NSMutableArray *returnDetailsArr;
@property (nonatomic,strong)NSIndexPath *deleteIndexPath;
@end

@implementation ProjectReturnViewController

- (void)setDetailArr:(NSMutableArray *)detailArr
{
    _detailArr = detailArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"回报列表";

    [self setInfo];
    
    _currentEditReturnDic = [NSDictionary dictionary];
    
    if (_detailArr.count == 0) {
        _addReturnBtn.hidden = NO;
    }else{
        _addReturnBtn.hidden = YES;
        [self setNaviInfo];
    }
}

- (void)setInfo
{
    [self setBarLeftButtonItem];
    
    [_projectReturnTableView registerNib:[UINib nibWithNibName:@"ProjectReturnTableViewCell" bundle:nil] forCellReuseIdentifier:@"ProjectReturnTableViewCell"];
}

- (void)setBarLeftButtonItem
{
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, 0, 44, 44);
//    [button setImage:[UIImage imageNamed:@"choukuanSet"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    [self setupBarButtomItemWithImageName:@"choukuanSet" highLightImageName:nil selectedImageName:nil target:self action:@selector(backBtnClick) leftOrRight:YES];
}

- (void)setNaviInfo
{
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50+40, 44);
    [button setImage:[UIImage imageNamed:@"addProject"] forState:UIControlStateNormal];
    [button setTitle:@" 添加回报" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(startProjectClick) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

- (void)startProjectClick
{
    AddProjectReturnViewController *addProjectVC = [AddProjectReturnViewController new];
    addProjectVC.delegate = self;
    addProjectVC.type = @"Add";
    [self.navigationController pushViewController:addProjectVC animated:YES];
}

- (void)backBtnClick
{
    if ([self.delegate respondsToSelector:@selector(returnSavedReturnUserInfo:)]) {
        [self.delegate returnSavedReturnUserInfo:_detailArr];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addBtnClick:(id)sender {
    AddProjectReturnViewController *addProjectVC = [AddProjectReturnViewController new];
    addProjectVC.delegate = self;
    [self.navigationController pushViewController:addProjectVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _detailArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 157;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ProjectReturnTableViewCell";
    ProjectReturnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[ProjectReturnTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.projectReturnDic = [_detailArr objectAtIndex:indexPath.section];
    cell.delegates = self;
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    AddProjectReturnViewController *addReturnVC = [AddProjectReturnViewController new];
//    addReturnVC.delegate = self;
//    addReturnVC.editReturnDic = [_detailArr objectAtIndex:indexPath.section];
//    _currentEditReturnDic = [_detailArr objectAtIndex:indexPath.section];
//    [self.navigationController pushViewController:addReturnVC animated:YES];
//}

#pragma mark - AddReturnViewControllerDelegate
- (void)addReturnSavedReturnUserInfo:(NSDictionary *)userInfo isEdit:(BOOL)isEdit
{
    [self setNaviInfo];
    
    if (userInfo) {
        _addReturnBtn.hidden = YES;
    }else{
        _addReturnBtn.hidden = NO;
    }
    if (isEdit)
    {
        [_detailArr removeObject:_currentEditReturnDic];
        [_detailArr addObject:userInfo];
    }
    else
    {
        [_detailArr addObject:userInfo];
    }
    
//    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"SupportAmount" ascending:YES]];
//    [_detailArr sortUsingDescriptors:sortDescriptors];
    
    [_detailArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSNumber *index1 = [obj1 valueForKey:@"SupportAmount"];
        NSNumber *index2 = [obj2 valueForKey:@"SupportAmount"];
        return [index1 compare:index2];
    }];
    
    [_projectReturnTableView reloadData];
}

- (void)projectReturnTableViewCellEditProjectReturn:(ProjectReturnTableViewCell *)cell
{
    NSIndexPath *indexPath = [_projectReturnTableView indexPathForCell:cell];
    AddProjectReturnViewController *addReturnVC = [AddProjectReturnViewController new];
    addReturnVC.delegate = self;
    addReturnVC.editReturnDic = [_detailArr objectAtIndex:indexPath.section];
    _currentEditReturnDic = [_detailArr objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:addReturnVC animated:YES];
}

- (void)projectReturnTableViewCellDeleteProjectReturn:(ProjectReturnTableViewCell *)cell
{
    _deleteIndexPath = [_projectReturnTableView indexPathForCell:cell];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确定要删除该回报吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [_detailArr removeObjectAtIndex:_deleteIndexPath.section];
        [_projectReturnTableView beginUpdates];
        [_projectReturnTableView deleteSections:[NSIndexSet indexSetWithIndex:_deleteIndexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        [_projectReturnTableView endUpdates];
        
        if (_detailArr.count == 0) {
            _addReturnBtn.hidden = NO;
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
}

- (void)projectReturnTableViewCellMoreProjectReturn:(ProjectReturnTableViewCell *)cell
{
    NSIndexPath *indexPath = [_projectReturnTableView indexPathForCell:cell];
    MoreReturnContentViewController *moreReturnContentVC = [MoreReturnContentViewController new];
    moreReturnContentVC.returnContentStr = [[_detailArr objectAtIndex:indexPath.section] objectForKey:@"Description"];
    [self.navigationController pushViewController:moreReturnContentVC animated:YES];
}

@end
