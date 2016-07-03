//
//  TestTableViewCell.h
//  ZFTableViewCell
//
//  Created by 任子丰 on 15/11/13.
//  Copyright (c) 2015年 任子丰. All rights reserved.
//

#import "ZFTableViewCell.h"
@class TestTableViewCell;
@class SupportReturn;
@protocol TestTableViewCellDelegate <ZFTableViewCellDelegate>
- (void)testTableViewCellOpenStateChanged:(TestTableViewCell *)cell;
@end
@interface TestTableViewCell : ZFTableViewCell
@property (nonatomic,strong) UILabel* nameLabel;
@property (nonatomic,strong)SupportReturn *returnDetailsObj;
@property (weak, nonatomic) id<TestTableViewCellDelegate> openDelegate;
@end
