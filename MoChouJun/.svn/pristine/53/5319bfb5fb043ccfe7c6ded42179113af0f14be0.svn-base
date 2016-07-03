//
//  SupportReturn.m
//  WeiPublicFund
//
//  Created by zhoupushan on 16/3/15.
//  Copyright © 2016年 www.niuduz.com. All rights reserved.
//

#import "SupportReturn.h"
#import "NSString+Adding.h"
#import "ReflectUtil.h"

@implementation SupportReturn
static CGFloat const contentMargin = 10.0;
- (void)setImages:(NSString *)images
{
    _images = images;
    if ([_images isKindOfClass:[NSString class]] && _images.length != 0)
    {
        _imageArr = [_images componentsSeparatedByString:@","];
    }else if ([_images isKindOfClass:[NSArray class]]){
        _imageArr = (NSArray *)_images;
    }
}

- (CGFloat)returnContentHeight
{
    if (_returnContentHeight <= 0.0)
    {
        CGFloat height = 43 + 55;

        height += [self textHeight];
        
        height += contentMargin;
        if (_imageArr.count)
        {
            height += 60;
            height += contentMargin;
        }
        height += 5;
        _returnContentHeight = height;
        
    }
    return _openState?_returnContentHeight:43;
}

- (CGFloat)contentHeight
{
    if (_contentHeight <= 0.0)
    {
        CGFloat height = 40.0;
        height += [self textHeight];
        if (_imageArr.count)
        {
            height += 65.0;
            height += 22.0;// 空隙
        }
        
        if (_repayDays != 0)
        {
            height += 12.0;
            height += 11.0;
        }
        height += 12.0;
        _contentHeight = height;
    }
    return _contentHeight;
}

- (void)setDescription:(NSString *)Description
{
    _Description = [NSString stringWithFormat:@"回报介绍：%@",Description];
}

- (CGFloat)textHeight
{
    if (_textHeight <= 0.0)
    {
        _textHeight = [_Description sizeWithFont:[UIFont systemFontOfSize:13] constrainedSize:CGSizeMake(229, 47)].height;
    }
    return _textHeight;
}


- (void)setRepayId:(NSInteger)repayId
{
    _Id = repayId;
}

- (NSInteger)repayId
{
    return _Id;
}

- (void)setList:(NSArray *)list
{
    _list = [ReflectUtil reflectDataWithClassName:@"SupportedProject" otherObject:list isList:YES];
}
@end
