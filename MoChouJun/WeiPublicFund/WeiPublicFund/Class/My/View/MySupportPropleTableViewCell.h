//
//  MySupportPropleTableViewCell.h
//  WeiPublicFund
//
//  Created by liuyong on 15/12/8.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MySupportPropleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UIButton *mySupportBtn;
@property (nonatomic,assign)BOOL selectOk;
@end
