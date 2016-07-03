//
//  WeiSupportTableViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/25.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "WeiSupportTableViewCell.h"
#import "WeiSupportIconCollectionViewCell.h"
#import "ProjectProgressView.h"
#import "NetWorkingUtil.h"
#import "ProjectDetailsObj.h"
#import "WeiProjectDetailsViewController.h"
#import <UIButton+WebCache.h>

@interface WeiSupportTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *weiSupportCollection;

@property (weak, nonatomic) IBOutlet UILabel *startPeopleNameLab;
@property (weak, nonatomic) IBOutlet ProjectProgressView *startProgressView;
@property (weak, nonatomic) IBOutlet UILabel *goalAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *surplusDayLab;
@property (weak, nonatomic) IBOutlet UILabel *supportNumberLab;
@property (weak, nonatomic) IBOutlet UIButton *startPeopleBtn;
@property (weak, nonatomic) IBOutlet UIImageView *projectSuccessImageView;

@end
@implementation WeiSupportTableViewCell

- (void)awakeFromNib
{
    _weiSupportCollection.delegate = self;
    _weiSupportCollection.dataSource = self;
    _startPeopleBtn.layer.cornerRadius = 25.0f;
    _startPeopleBtn.layer.masksToBounds = YES;
    [_weiSupportCollection registerNib:[UINib nibWithNibName:@"WeiSupportIconCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"WeiSupportIconCollectionViewCell"];
}

- (void)setProjectDetails:(ProjectDetailsObj *)projectDetails
{
    _projectDetails = projectDetails;
    [_startPeopleBtn sd_setImageWithURL:[NSURL URLWithString:_projectDetails.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"start_默认"]];
    _startPeopleNameLab.text = _projectDetails.nickName;
   
    NSString *targetAmountStr = [NSString stringWithFormat:@"%.2f",_projectDetails.targetAmount];
    NSString *xiaoshudian = [targetAmountStr substringFromIndex:targetAmountStr.length - 2];
    if ([xiaoshudian intValue] % 100 == 0) {
        targetAmountStr = [targetAmountStr substringToIndex:targetAmountStr.length - 3];
    }
    
    NSString *raisedAmountStr = [NSString stringWithFormat:@"%.2f",_projectDetails.raisedAmount];
    NSString *xiaoshudian1 = [raisedAmountStr substringFromIndex:raisedAmountStr.length - 2];
    if ([xiaoshudian1 intValue] % 100 == 0) {
        raisedAmountStr = [raisedAmountStr substringToIndex:raisedAmountStr.length - 3];
    }
    
    NSMutableAttributedString *atstring = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"目标%@元",targetAmountStr] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#6E6E6E"]}];
    [atstring appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" 已筹%@元",raisedAmountStr] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#6E6E6E"]}]];
    _goalAmountLab.attributedText = atstring;
    
    _startProgressView.isShowProgressText = YES;
    if (_startProgressView.progressValue) {
        _startProgressView.animation = YES;
    }
    
    _startProgressView.progressValue = _projectDetails.raisedAmount / _projectDetails.targetAmount * 100;
 
    if(_projectDetails.statusId == 3)
    {
        _surplusDayLab.text = @" ";
    }
    else
    {
        if (_projectDetails) {
            _surplusDayLab.text = [NSString stringWithFormat:@"%@",_projectDetails.showStatus];
        }else{
            _surplusDayLab.text = @" ";
        }
    }
    
    if(_projectDetails.statusId == 3){
        _projectSuccessImageView.hidden = NO;
    }else{
        _projectSuccessImageView.hidden = YES;
    }
    _supportNumberLab.text = [NSString stringWithFormat:@"%ld",(long)_projectDetails.supportedCount];
    if (_projectDetails.supportedCount == 0)
    {
        _weiSupportCollection.hidden = YES;
    }else
    {
        _weiSupportCollection.hidden = NO;
    }
}

- (void)setSupportMutableArr:(NSMutableArray *)supportMutableArr
{
    _supportMutableArr = supportMutableArr;
    [_weiSupportCollection reloadData];
}

- (IBAction)avatarBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(weiSupportTableViewCell:supportProject:)])
    {
        [self.delegate weiSupportTableViewCell:self supportProject:_projectDetails];
    }
}

- (NSUInteger)numberItemsCount
{
    NSUInteger count = (NSUInteger)(SCREEN_WIDTH - 41 + 5)/30;
    if (_supportMutableArr.count <= count)
    {
        count = _supportMutableArr.count;
    }
    return count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self numberItemsCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WeiSupportIconCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WeiSupportIconCollectionViewCell" forIndexPath:indexPath];
    [cell sizeToFit];
    
    NSDictionary *dict = _supportMutableArr[indexPath.row];
    CGFloat items = [self numberItemsCount];
    if (_supportMutableArr.count > items && indexPath.row == items - 1)
    {
        cell.supportImageView.image = [UIImage imageNamed:@"more-people"];
    }
    else
    {
        [NetWorkingUtil setImage:cell.supportImageView url:[dict objectForKey:@"UserAvatar"] defaultIconName:@"comment_默认"];
    }
    
    return cell;
}
@end
