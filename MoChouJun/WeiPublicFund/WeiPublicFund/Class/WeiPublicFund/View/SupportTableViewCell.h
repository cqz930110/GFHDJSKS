//
//  SupportTableViewCell.h
//  WeiPublicFund
//
//  Created by liuyong on 15/12/1.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SupportTableViewCell : UITableViewCell
{
    NSMutableArray *_images;
}
@property (weak, nonatomic) IBOutlet UILabel *supportCountLab;
@property (weak, nonatomic) IBOutlet UICollectionView *iconCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *noSupportLab;

@property (nonatomic,strong)NSMutableArray *images;
@end
