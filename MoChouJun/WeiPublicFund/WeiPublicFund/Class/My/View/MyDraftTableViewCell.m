//
//  MyDraftTableViewCell.m
//  WeiPublicFund
//
//  Created by liuyong on 16/6/20.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "MyDraftTableViewCell.h"

@implementation MyDraftTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setMyDraftDic:(NSDictionary *)myDraftDic
{
    _myDraftDic = myDraftDic;
    
    _myDraftTitleLab.text = IsStrEmpty([_myDraftDic objectForKey:@"Name"])?@"还未填写项目标题":[_myDraftDic objectForKey:@"Name"];
    _myDraftDateLab.text = [_myDraftDic objectForKey:@"ShowStatus"];
    _myDraftContentLab.text = IsStrEmpty([_myDraftDic objectForKey:@"Content"])?@"还未填写项目详情":[_myDraftDic objectForKey:@"Content"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
