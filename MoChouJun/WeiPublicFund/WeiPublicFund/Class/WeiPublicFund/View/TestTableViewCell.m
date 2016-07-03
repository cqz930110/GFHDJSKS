//
//  TestTableViewCell.m
//  ZFTableViewCell
//
//  Created by 任子丰 on 15/11/13.
//  Copyright (c) 2015年 任子丰. All rights reserved.
//

#import "TestTableViewCell.h"
#import "SupportProjectCollectionViewCell.h"
#import "ReturnDetailsObj.h"
#import <MWPhotoBrowser.h>
#import "BaseNavigationController.h"
#import "SupportReturn.h"
#import "NSString+Adding.h"
static CGFloat const kMargin = 10.f;
@interface TestTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate,MWPhotoBrowserDelegate>
@property (nonatomic,strong) UIImageView *returnImageView;

@property (nonatomic,strong) UIImageView *moreImageView;
@property (nonatomic,strong) UIButton *openStateButton;

@property (nonatomic,strong) UIView *contentReturnView;
@property (nonatomic,strong) UILabel *titleLabel1;
@property (nonatomic,strong) UILabel *titleLabel2;
@property (nonatomic,strong) UIView *lineView1;
@property (nonatomic,strong) UIView *lineView2;
@property (nonatomic,strong) UILabel *supportAmountLabel;
@property (nonatomic,strong) UILabel *descLabel;
//  回报内容
@property (nonatomic,strong)UICollectionView *returnCollectView;
@end

@implementation TestTableViewCell
- (UIImageView *)returnImageView
{
    if (!_returnImageView)
    {
        _returnImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 3, 15)];
        _returnImageView.image = [UIImage imageNamed:@"矩形"];
    }
    return _returnImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(31, 12, 200, 21)];
        _nameLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _nameLabel.font = [UIFont systemFontOfSize:15.0f];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#6E6E6E"];
    }
    return _nameLabel;
}

- (UIImageView *)moreImageView
{
    if (!_moreImageView)
    {
        _moreImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 30, 13, 15, 20)];
        _moreImageView.image = [UIImage imageNamed:@"arrow"];
        _moreImageView.contentMode = UIViewContentModeCenter;
    }
    return _moreImageView;
}

- (UIButton *)openStateButton
{
    if (!_openStateButton)
    {
        _openStateButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _openStateButton.frame = CGRectMake(0, 0, SCREEN_WIDTH,42);
        [_openStateButton addTarget:self action:@selector(openStateAction) forControlEvents:UIControlEventTouchUpInside];
//        _openStateButton.backgroundColor = [UIColor cl];
    }
    return _openStateButton;
}

- (UIView *)contentReturnView
{
    if (!_contentReturnView)
    {
        _contentReturnView = [[UIView alloc]initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 146)];
        _contentReturnView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
        [_contentReturnView addSubview:self.titleLabel1];
        [_contentReturnView addSubview:self.supportAmountLabel];
        [_contentReturnView addSubview:self.lineView1];
        [_contentReturnView addSubview:self.titleLabel2];
        [_contentReturnView addSubview:self.returnCollectView];
        [_contentReturnView addSubview:self.descLabel];
    }
    return _contentReturnView;
}

- (UILabel *)descLabel
{
    if (!_descLabel)
    {
        //  回报内容
        _descLabel = [[UILabel alloc]initWithFrame:CGRectMake(88, 55, SCREEN_WIDTH - 100, 30)];
        _descLabel.font = [UIFont systemFontOfSize:13.0f];
        _descLabel.textColor = [UIColor colorWithHexString:@"#C0C0C0"];
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}

- (UICollectionView *)returnCollectView
{
    if (!_returnCollectView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(60, 60);
        _returnCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(90, 78, 200, 60) collectionViewLayout:layout];
        _returnCollectView.delegate = self;
        _returnCollectView.dataSource = self;
        _returnCollectView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
        [_returnCollectView registerNib:[UINib nibWithNibName:@"SupportProjectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SupportProjectCollectionViewCell"];
    }
    return _returnCollectView;
}

- (UILabel *)titleLabel2
{
    if (!_titleLabel2)
    {
        _titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 53, 62, 21)];
        _titleLabel2.text = @"回报介绍";
        _titleLabel2.font = [UIFont systemFontOfSize:14.0f];
        _titleLabel2.textColor = [UIColor colorWithHexString:@"#C0C0C0"];
    }
    return _titleLabel2;
}

- (UIView *)lineView1
{
    if (!_lineView1)
    {
        _lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 1)];
        _lineView1.backgroundColor = [UIColor colorWithHexString:@"#EAEAEA"];
    }
    return _lineView1;
}

- (UILabel *)titleLabel1
{
    if (!_titleLabel1)
    {
        _titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 11, 62, 21)];
        _titleLabel1.text = @"支持金额";
        _titleLabel1.font = [UIFont systemFontOfSize:14.0f];
        _titleLabel1.textColor = [UIColor colorWithHexString:@"#C0C0C0"];
    }
    return _titleLabel1;
}

- (UILabel *)supportAmountLabel
{
    if (!_supportAmountLabel)
    {
        _supportAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(88, 6, SCREEN_WIDTH - 100, 30)];
        _supportAmountLabel.font = [UIFont systemFontOfSize:14.0f];
        _supportAmountLabel.textColor = [UIColor colorWithHexString:@"#C0C0C0"];
    }
    return _supportAmountLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                     delegate:(id<ZFTableViewCellDelegate>)delegate
                  inTableView:(UITableView *)tableView
                 withRowHight:(CGFloat)rowHeight
        withRightButtonTitles:(NSArray *)rightButtonTitles
        withRightButtonColors:(NSArray *)rightButtonColors
{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier
                       delegate:delegate
                    inTableView:tableView
                   withRowHight:rowHeight
          withRightButtonTitles:rightButtonTitles
          withRightButtonColors:rightButtonColors];
    
    if (self)
    {
        self.clipsToBounds = YES;
        [self.cellContentView addSubview:self.returnImageView];
        [self.cellContentView addSubview:self.nameLabel];
        [self.cellContentView addSubview:self.moreImageView];
        [self.cellContentView addSubview:self.openStateButton];
        [self.contentView addSubview:self.contentReturnView];
    }
    
    return self;
}

#pragma mark - Actions
- (void)openStateAction
{
    _returnDetailsObj.openState = !_returnDetailsObj.openState;
    if ([self.openDelegate respondsToSelector:@selector(testTableViewCellOpenStateChanged:)])
    {
        [self.openDelegate testTableViewCellOpenStateChanged:self];
    }
}

- (void)setReturnDetailsObj:(SupportReturn *)returnDetailsObj
{
    _returnDetailsObj = returnDetailsObj;
    _supportAmountLabel.text = [NSString stringWithFormat:@"%.2f",_returnDetailsObj.supportAmount];
    _descLabel.text = _returnDetailsObj.Description;
    [_returnCollectView reloadData];
    [self updateContentFrame];
    
    if (_returnDetailsObj.openState)
    {
        _contentReturnView.hidden = NO;
        _moreImageView.image = [UIImage imageNamed:@"more-up"];
    }
    else
    {
        _contentReturnView.hidden = YES;
        _moreImageView.image = [UIImage imageNamed:@"arrow"];
    }
}

- (void)updateContentFrame
{
    CGFloat height = 43 + 55;
    _descLabel.height = [_returnDetailsObj textHeight];
    height += [_returnDetailsObj textHeight];
    height += kMargin;
    if (_returnDetailsObj.imageArr.count)
    {
        _returnCollectView.top = height - 43;
        height += 60;
        height += kMargin;
    }
    height += 5;
    _contentReturnView.height = height - 43;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _returnDetailsObj.imageArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SupportProjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SupportProjectCollectionViewCell" forIndexPath:indexPath];
    cell.supportProjectImageView.image = _returnDetailsObj.imageArr[indexPath.row];
    if (_returnDetailsObj.imageArr.count > 3 && indexPath.row == 2)
    {
        [cell.moreImageBtn setTitle:[NSString stringWithFormat:@" %lu",_returnDetailsObj.imageArr.count] forState:UIControlStateNormal];
        cell.moreImageBtn.hidden = NO;
    }
    else
    {
        cell.moreImageBtn.hidden = YES;
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 查看图片 //删除功能
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    // Set options
    browser.displayActionButton = NO;
    browser.displayNavArrows = YES;
    browser.displaySelectionButtons = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.autoPlayOnAppear = NO;
    [browser setCurrentPhotoIndex:indexPath.row];
    // Manipulate
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    
    // Present
    BaseNavigationController *nc = [[BaseNavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UIViewController *vc =  (UIViewController *)self.delegate;
    [vc presentViewController:nc animated:NO completion:nil];
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{

    return _returnDetailsObj.imageArr.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    MWPhoto *photo = [MWPhoto photoWithImage:_returnDetailsObj.imageArr[index]];
    
    return photo;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index
{
    MWPhoto *photo = [MWPhoto photoWithImage:_returnDetailsObj.imageArr[index]];

    return photo;
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser
{
    [photoBrowser dismissViewControllerAnimated:NO completion:nil];
}
@end
