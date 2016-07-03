//
//  SupportMethodTwoTableViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/17.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "SupportMethodTwoTableViewCell.h"
#import "SupportProjectCollectionViewCell.h"
#import "NetWorkingUtil.h"
#import "SupportReturn.h"

@interface SupportMethodTwoTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *supportMethodCollection;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@end

@implementation SupportMethodTwoTableViewCell
static CGFloat const kContentMargin = 10.f;
- (void)awakeFromNib
{
    _supportMethodCollection.delegate = self;
    _supportMethodCollection.dataSource = self;
    [_supportMethodCollection registerNib:[UINib nibWithNibName:@"SupportProjectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SupportProjectCollectionViewCell"];
}

- (void)setModel:(SupportReturn *)model {
    _model = model;
    _descLabel.text = _model.Description;
    if (_model.imageArr.count)
    {
        [_supportMethodCollection reloadData];
    }
    [self updateViewFrame];
}

- (void)updateViewFrame
{
    CGFloat height = kContentMargin;
    height += _model.textHeight;
    height += 10.0;
    _descLabel.height = [_model contentHeight];
    if (_model.imageArr.count)
    {
        _supportMethodCollection.top = height;
        _supportMethodCollection.hidden = NO;
        height += 60;
        height += 10.0;
    }
    else
    {
        _supportMethodCollection.hidden = YES;
    }
}

- (NSUInteger)numberRowCount
{
    NSUInteger count = (NSUInteger)(SCREEN_WIDTH - 10.0 * 2 + 10.0)/(60 + 10.0);
    if (_model.imageArr.count <= count)
    {
        return _model.imageArr.count;
    }
    else
    {
        return  count;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self numberRowCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SupportProjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SupportProjectCollectionViewCell" forIndexPath:indexPath];
    [NetWorkingUtil setImage:cell.supportProjectImageView url:_model.imageArr[indexPath.row] defaultIconName:nil];
    cell.moreImageBtn.hidden = YES;
    return cell;
}

@end
