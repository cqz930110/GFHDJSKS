//
//  TabBarController.h
//  PublicFundraising
//
//  Created by Apple on 15/10/9.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarController : UITabBarController<UITabBarControllerDelegate, UITabBarDelegate>
{
    EMConnectionState _connectionState;
}
@property (nonatomic,copy)NSString *type;
- (void)jumpToChatList;

- (void)setupUntreatedApplyCount;
- (void)setupUnreadMessageCount;

- (void)networkChanged:(EMConnectionState)connectionState;

- (void)didReceiveLocalNotification:(UILocalNotification *)notification;
@property (nonatomic,assign)BOOL ok;
@end
