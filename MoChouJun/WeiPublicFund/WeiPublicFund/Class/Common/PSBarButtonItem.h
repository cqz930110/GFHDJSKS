//
//  PSBarButtonItem.h
//  PublicFundraising
//
//  Created by Apple on 15/10/9.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSBarButtonItem : UIBarButtonItem

typedef NS_ENUM(NSInteger, PSNavItemStyle) {
    
    PSNavItemStyleBack, //返回
    PSNavItemStyleDone
};

+ (instancetype)itemWithTitle:(NSString *)title
                        barStyle:(PSNavItemStyle)style
                       target:(id)target
                       action:(SEL)action;
+ (instancetype)itemWithImageName:(NSString *)normalImageName highLightImageName:(NSString *)highImageName selectedImageName:(NSString *)selectedImageName target:(id)target action:(SEL)action;

+ (instancetype)itemWithImageUrl:(NSString *)imageUrl defaluleImageName:(NSString *)defaultImageName target:(id)target action:(SEL)action;
@end
