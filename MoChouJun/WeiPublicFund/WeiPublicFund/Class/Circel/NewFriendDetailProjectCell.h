//
//  FriendDetailProjectCell.h
//  WeiPublicFund
//
//  Created by zhoupushan on 15/12/2.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewFriendDetailProjectCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
- (void)setimageUrl:(NSString *)imageUrl;
- (void)setUserName:(NSString *)userNameStr;
@end
