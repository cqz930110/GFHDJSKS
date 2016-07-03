//
//  ProjectReturnTableViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 16/4/7.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "ProjectReturnTableViewCell.h"
#import "ProjectReturnCollectionViewCell.h"
#import "NSString+Adding.h"
#import <MWPhotoBrowser.h>
#import "BaseNavigationController.h"
#import "ProjectReturnViewController.h"
@interface ProjectReturnTableViewCell ()
@property (weak, nonatomic) IBOutlet UICollectionView *returnCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *returnLayout;
@property (nonatomic,strong)NSArray *images;
@end

@implementation ProjectReturnTableViewCell

- (void)awakeFromNib {

    _moreBtn.hidden = YES;
}

- (void)setAllReturnDic:(NSDictionary *)allReturnDic
{
    _editBtn.hidden = YES;
    _deleteBtn.hidden = YES;
    _allReturnDic = allReturnDic;
    
    NSMutableAttributedString * atriText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %.2f",[[_allReturnDic objectForKey:@"SupportAmount"] floatValue]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor redColor]}];
    [atriText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(1, atriText.length - 4)];
    _returnAmountLab.attributedText = atriText;
    
    NSArray *imageArr = [[_allReturnDic objectForKey:@"Images"] componentsSeparatedByString:@","];
    [_returnImageView sd_setImageWithURL:[NSURL URLWithString:imageArr[0]] placeholderImage:nil];
    
    [self setRepayPeriod:[NSString stringWithFormat:@"众筹承诺：众筹成功%@天内发货",[_allReturnDic objectForKey:@"RepayDays"]]];
    
    [self setLabStyle:[NSString stringWithFormat:@"回报介绍：%@",[_allReturnDic objectForKey:@"Description"]]];
    
    if ([[_allReturnDic objectForKey:@"MaxNumber"] intValue] == 0) {
        _returnPeopleLab.text = @"数量不限";
    }else{
        _returnPeopleLab.text = [NSString stringWithFormat:@"仅剩%d份",[[_allReturnDic objectForKey:@"MaxNumber"] intValue] - [[_allReturnDic objectForKey:@"SupportCount"] intValue]];
    }
}

- (void)setProjectReturnDic:(NSDictionary *)projectReturnDic
{
    _projectReturnDic = projectReturnDic;

    NSMutableAttributedString * atriText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %.2f",[[_projectReturnDic objectForKey:@"SupportAmount"] floatValue]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor redColor]}];
    [atriText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(1, atriText.length - 4)];
    _returnAmountLab.attributedText = atriText;

    if ([[_projectReturnDic objectForKey:@"maxNumber"] integerValue] == 0) {
        _returnPeopleLab.text = @"数量不限";
        
    }else{
        _returnPeopleLab.text = [NSString stringWithFormat:@"仅剩%@份",[_projectReturnDic objectForKey:@"maxNumber"]];
    }

    [self setRepayPeriod:[NSString stringWithFormat:@"众筹承诺：众筹成功%@天内发货",[_projectReturnDic objectForKey:@"repayDays"]]];
    
    if ([[_projectReturnDic objectForKey:@"ImgList"] isKindOfClass:[NSString class]]) {
        [_returnImageView sd_setImageWithURL:[NSURL URLWithString:[_projectReturnDic objectForKey:@"ImgList"]] placeholderImage:nil];
    }else{
        _returnImageView.image = [[_projectReturnDic objectForKey:@"ImgList"] objectAtIndex:0];
    }
    
    
//    _returnContentLab.text = [NSString stringWithFormat:@"回报介绍：%@",[_projectReturnDic objectForKey:@"Description"]];
    
//    [_returnCollectionView reloadData];
    
    [self setLabStyle:[NSString stringWithFormat:@"回报介绍：%@",[_projectReturnDic objectForKey:@"Description"]]];
}

- (void)setRepayPeriod:(NSString *)periodStr
{
    _returnPeriodLab.text = periodStr;
    NSMutableAttributedString *borrowStr = [[NSMutableAttributedString alloc]initWithString:_returnPeriodLab.text];
    [borrowStr beginEditing];
    [borrowStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#6E6E6E"] range:NSMakeRange(0, 9)];
    [borrowStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#6E6E6E"] range:NSMakeRange(_returnPeriodLab.text.length - 3, 3)];
    _returnPeriodLab.attributedText = borrowStr;
}

- (void)setLabStyle:(NSString *)returnContentStr
{
    if (SCREEN_WIDTH == 320) {

        if (returnContentStr.length > 48) {

            _returnContentLab.text = [[returnContentStr substringToIndex:35] stringByAppendingString:@"..."];
            
            _moreBtn.hidden = NO;
        }else{
            _returnContentLab.text = returnContentStr;
            _moreBtn.hidden = YES;
        }
    }else if (SCREEN_WIDTH == 375){
        if (returnContentStr.length > 60) {
            
            _returnContentLab.text = [[returnContentStr substringToIndex:45] stringByAppendingString:@"..."];
            
            _moreBtn.hidden = NO;
        }else{
            _returnContentLab.text = returnContentStr;
            _moreBtn.hidden = YES;
        }
    }else{
        _returnContentLab.text = returnContentStr;
        _moreBtn.hidden = YES;
    }

}

//   编辑
- (IBAction)editAction:(id)sender {
    
    [self.delegates projectReturnTableViewCellEditProjectReturn:self];
}

//   删除
- (IBAction)deleteAction
{
    [self.delegates projectReturnTableViewCellDeleteProjectReturn:self];
}

//  更多
- (IBAction)moreBtnAction:(id)sender {
    [self.delegates projectReturnTableViewCellMoreProjectReturn:self];
}

//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return _images.count;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    ProjectReturnCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProjectReturnCollectionViewCell" forIndexPath:indexPath];
//    
//    cell.projectReturnImageView.image = [_images objectAtIndex:indexPath.row];
//    return cell;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    // 查看图片 //删除功能
//    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
//    
//    // Set options
//    browser.displayActionButton = NO;
//    browser.displayNavArrows = YES;
//    browser.displaySelectionButtons = NO;
//    browser.zoomPhotosToFill = YES;
//    browser.enableGrid = NO;
//    browser.startOnGrid = NO;
//    browser.autoPlayOnAppear = NO;
//    [browser setCurrentPhotoIndex:indexPath.row];
//    
//    // Manipulate
//    [browser showNextPhotoAnimated:YES];
//    [browser showPreviousPhotoAnimated:YES];
//    // Present
//    BaseNavigationController *nc = [[BaseNavigationController alloc] initWithRootViewController:browser];
//    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    UIViewController *vc =  (UIViewController *)self.delegates;
//    [vc presentViewController:nc animated:YES completion:nil];
//}
//
//#pragma mark - MWPhotoBrowserDelegate
//- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
//{
//    return self.images.count;
//}
//
//- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
//{
//    MWPhoto *photo = [MWPhoto photoWithImage:_images[index]];
//    return photo;
//}
//
//- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index
//{
//    MWPhoto *photo = [MWPhoto photoWithImage:_images[index]];
//    return photo;
//}
//
//- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser
//{
//    [photoBrowser dismissViewControllerAnimated:YES completion:nil];
//}

@end
