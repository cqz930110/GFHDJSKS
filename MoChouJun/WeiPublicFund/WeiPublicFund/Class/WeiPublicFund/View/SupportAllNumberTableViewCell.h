//
//  SupportAllNumberTableViewCell.h
//  WeiPublicFund
//
//  Created by liuyong on 16/6/7.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SupportReturn;
@class SupportAllNumberTableViewCell;
@protocol SupportAllNumberTableViewCellDelegate <NSObject>

- (void)changeBtnClick:(SupportReturn *)supportReturn returnType:(NSInteger)type returnCell:(SupportAllNumberTableViewCell *)cell;

@end

@interface SupportAllNumberTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *showLab;
@property (weak, nonatomic) IBOutlet UITextField *supportAmountTextField;
@property (weak, nonatomic) IBOutlet UILabel *supportAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *supleNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property (weak, nonatomic) IBOutlet UITextField *supportCommentTextField;

@property (weak, nonatomic) id<SupportAllNumberTableViewCellDelegate> delegate;
@property (nonatomic,copy)SupportReturn *supportReturn;
@property (nonatomic,assign)BOOL showType;
@end
