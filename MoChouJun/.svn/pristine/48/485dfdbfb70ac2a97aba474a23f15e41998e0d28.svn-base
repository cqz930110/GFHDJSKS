//
//  SupportTableViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/1.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "SupportTableViewCell.h"
#import "IconImageCollectionViewCell.h"
#import "NetWorkingUtil.h"

@interface SupportTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation SupportTableViewCell

- (void)awakeFromNib {
    _iconCollectionView.delegate = self;
    _iconCollectionView.dataSource = self;
    [_iconCollectionView registerNib:[UINib nibWithNibName:@"IconImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"IconImageCollectionViewCell"];
}

- (void)setImages:(NSMutableArray *)images
{
    _images = images;
    [_iconCollectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IconImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IconImageCollectionViewCell" forIndexPath:indexPath];
    [cell sizeToFit];
    NSDictionary *dict = _images[indexPath.row];
    [NetWorkingUtil setImage:cell.iconImageView url:[dict objectForKey:@"UserAvatar"] defaultIconName:nil];
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
