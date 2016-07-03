//
//  ReturnDetailTableViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/2.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "ReturnDetailTableViewCell.h"
#import "SupportProjectCollectionViewCell.h"
#import "ReturnDetailsObj.h"


@interface ReturnDetailTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)NSArray *returnImage;
@end

@implementation ReturnDetailTableViewCell

- (void)awakeFromNib {
    
    _returnDetailView.hidden = YES;
    _returnDetailCollectionView.delegate = self;
    _returnDetailCollectionView.dataSource = self;
    [_returnDetailCollectionView registerNib:[UINib nibWithNibName:@"SupportProjectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SupportProjectCollectionViewCell"];
}

- (void)setReturnDetailsObj:(ReturnDetailsObj *)returnDetailsObj
{
    _returnDetailsObj = returnDetailsObj;
    _returnDetailNameTextField.text = _returnDetailsObj.SupportAmount;
    _returnDetailNameTextField.userInteractionEnabled = NO;
    _returnContentLab.text = _returnDetailsObj.Description;
    if (![_returnDetailsObj.images isKindOfClass:[NSString class]]) {
        _returnImage = _returnDetailsObj.images;
        [_returnDetailCollectionView reloadData];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _returnImage.count-1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SupportProjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SupportProjectCollectionViewCell" forIndexPath:indexPath];
    cell.supportProjectImageView.image = _returnImage[indexPath.row];
    if (_returnImage.count > 3) {
        [cell.moreImageBtn setTitle:[NSString stringWithFormat:@" %lu",_returnImage.count-1] forState:UIControlStateNormal];
        cell.moreImageBtn.hidden = NO;
    }else{
        cell.moreImageBtn.hidden = YES;
    }
    [cell sizeToFit];
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
