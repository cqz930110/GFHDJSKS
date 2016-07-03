//
//  ReturnDetailsViewController.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/2.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "ReturnDetailsViewController.h"
#import "AddReturnViewController.h"
#import "ReflectUtil.h"
#import "TestTableViewCell.h"
#import "NoMsgView.h"
#import "SupportReturn.h"

@interface ReturnDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,ZFTableViewCellDelegate,TestTableViewCellDelegate,AddReturnViewControllerDelegate>
{
    NSMutableArray *_detailArr;
}
@property (weak, nonatomic) IBOutlet UITableView *returnDetailsTableView;

@property (nonatomic,assign)CGFloat height;

@property (strong, nonatomic) NSMutableDictionary *offscreenCell;
@property (strong, nonatomic) NSMutableArray *projectReturns;
@property (weak, nonatomic) NSDictionary *currentEditReturnDic;
@end

@implementation ReturnDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"回报详情";
    [self setTableViewInfo];
    [self setNaviInfo];
}

- (void)setNaviInfo
{
    [self setupBarButtomItemWithTitle:@"添加" target:self action:@selector(addReturn) leftOrRight:NO];
    [self backBarItem];
}

- (void)setTableViewInfo
{
    _returnDetailsTableView.tableFooterView = [UIView new];
} 

#pragma mark - Actions
- (void)addReturn
{
    AddReturnViewController *addReturnVC = [[AddReturnViewController alloc] init];
    addReturnVC.delegate = self;
    [self.navigationController pushViewController:addReturnVC animated:YES];
}

#pragma mark - Setter & Getter
- (NSMutableArray *)projectReturns
{
    if (!_projectReturns) {
        _projectReturns = [NSMutableArray array];
    }
    return _projectReturns;
}

- (NSMutableArray *)detailArr
{
    if (!_detailArr)
    {
        _detailArr = [NSMutableArray array];
    }
    return _detailArr;
}

- (void)setDetailArr:(NSMutableArray *)detailArr
{
    _detailArr = detailArr;
    if (_detailArr.count > 0)
    {
        
        [self.projectReturns addObjectsFromArray:[ReflectUtil reflectDataWithClassName:@"SupportReturn" otherObject:_detailArr isList:YES]];
        [_returnDetailsTableView reloadData];
    }
}

#pragma mark - TestTableViewCellDelegate
- (void)testTableViewCellOpenStateChanged:(TestTableViewCell *)cell
{
    [_returnDetailsTableView reloadData];
}

#pragma mark - AddReturnViewControllerDelegate
- (void)addReturnSavedReturnUserInfo:(NSDictionary *)userInfo isEdit:(BOOL)isEdit
{
    if (isEdit)
    {
        NSUInteger index = [_detailArr indexOfObject:_currentEditReturnDic];
        [_projectReturns removeObjectAtIndex:index];
        [_projectReturns addObject:[ReflectUtil reflectDataWithClassName:@"SupportReturn" otherObject:userInfo]];
        
        [_detailArr removeObject:_currentEditReturnDic];
        [_detailArr addObject:userInfo];
    }
    else
    {
        [self.detailArr addObject:userInfo];
        [self.projectReturns addObject:[ReflectUtil reflectDataWithClassName:@"SupportReturn" otherObject:userInfo]];
    }
    
    [_returnDetailsTableView reloadData];
}

//#pragma mark - UITableDataSource and UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SupportReturn *support = _projectReturns[indexPath.row];
    return [support returnContentHeight];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _projectReturns.count;;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identity = @"FDFeedCell";
    TestTableViewCell* cell = (TestTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identity];
    if (!cell){
        cell = [[TestTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:identity
                                              delegate:self
                                           inTableView:tableView
                                          withRowHight:44
                                 withRightButtonTitles:@[@"编辑",@"删除"]
                                 withRightButtonColors:@[[UIColor colorWithHexString:@"#AAAAAA"],[UIColor colorWithHexString:@"#ff3b30"]]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.openDelegate = self;
    }
    cell.openDelegate = self;
    SupportReturn *returnDetailObj = [_projectReturns objectAtIndex:indexPath.row];
    cell.nameLabel.text = [NSString stringWithFormat:@"回报%ld",(long)indexPath.row + 1];
    cell.returnDetailsObj = returnDetailObj;
    return cell;
}

#pragma mark - ZFTableViewCellDelegate
-(void)buttonTouchedOnCell:(ZFTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath atButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0)
    {
        AddReturnViewController *addReturnVC = [[AddReturnViewController alloc] init];
        addReturnVC.delegate = self;
        addReturnVC.editReturnDic = [_detailArr objectAtIndex:indexPath.row];
        _currentEditReturnDic = addReturnVC.editReturnDic;
        [self.navigationController pushViewController:addReturnVC animated:YES];
    }
    else if (buttonIndex == 1)
    {
        [_detailArr removeObjectAtIndex:indexPath.row];
        [_projectReturns removeObjectAtIndex:indexPath.row];

        [_returnDetailsTableView reloadData];
    }
}

@end
