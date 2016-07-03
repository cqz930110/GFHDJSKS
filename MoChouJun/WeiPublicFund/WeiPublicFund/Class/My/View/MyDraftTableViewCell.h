//
//  MyDraftTableViewCell.h
//  WeiPublicFund
//
//  Created by liuyong on 16/6/20.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDraftTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *myDraftTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *myDraftDateLab;
@property (weak, nonatomic) IBOutlet UILabel *myDraftContentLab;
@property (weak, nonatomic) IBOutlet UIButton *myDraftEditBtn;
@property (weak, nonatomic) IBOutlet UIButton *myDraftDeleteBtn;

@property (nonatomic,copy)NSDictionary *myDraftDic;
@end
