//
//  Common.h
//  ScrollViewAndTableView
//
//  Created by fantasy on 16/5/16.
//  Copyright © 2016年 fantasy. All rights reserved.
//

#ifndef Common_h
#define Common_h

//height and width
#define kHeaderViewHeight    175
#define kMenuViewHeight      40
#define kNavigationHeight    64
#define kScrollViewOriginY   (kHeaderViewHeight + kNavigationHeight - kNavigationHeight)
#define kScreenHeight        [UIScreen mainScreen].bounds.size.height
#define kScreenWidth         [UIScreen mainScreen].bounds.size.width

//随机色
#define RandomColor RGBcolor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#define RGBcolor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define HEXRGBCOLOR(h) RGBcolor(((h>>16)&0xFF), ((h>>8)&0xFF), (h&0xFF))


//解决循环引用
#define weakify(va) \
autoreleasepool {} \
__weak __typeof__(va) metamacro_concat(va, _weak_) = (va);
#define strongify(va) \
try {} @finally {} \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong __typeof__(va) va = metamacro_concat(va, _weak_);\
_Pragma("clang diagnostic pop")
#define metamacro_concat(A, B) A ## B

//import
#import "UIView+WKFFrame.h"


#endif /* Common_h */
