//
//  ShareView.m
//  WeiPublicFund
//
//  Created by liuyong on 15/12/16.
//  Copyright © 2015年 www.niuduz.com. All rights reserved.
//

#import "ShareView.h"
#import "NetWorkingUtil.h"

@interface ShareView ()
{
    NetWorkingUtil *netUtil;
}
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *threeShareButtons;

@end
@implementation ShareView
- (void)awakeFromNib
{
//    NSArray *threeInstallType = [ShareUtil showInstalledThreeButtons];
//    if (threeInstallType.count == 3)
//    {
//        UIButton *qqButton = _threeShareButtons[0];
//        UIButton *qqZoneButton = _threeShareButtons[1];
//        UIButton *weiFriendButton = _threeShareButtons[2];
//        UIButton *weiTimeLineButton = _threeShareButtons[3];
//        UIButton *sinaButton = _threeShareButtons[4];
//        qqButton.hidden = NO;
//        qqZoneButton.hidden = NO;
//        weiFriendButton.hidden = NO;
//        weiTimeLineButton.hidden = NO;
//        sinaButton.hidden = NO;
//    }
//    else if (threeInstallType.count == 2)
//    {
//        UIButton *button1 = _threeShareButtons[0];
//        UIButton *button2 = _threeShareButtons[1];
//        UIButton *button3 = _threeShareButtons[2];
//        UIButton *button4 = _threeShareButtons[3];
//        if ([ShareUtil hideButtonWithThreeType:UMShareToQQ])
//        {
//            button1.hidden = NO;
//            // 微信好友
//            [button1 setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
//            [button1 setTitle:@"微信好友" forState:UIControlStateNormal];
//            button1.tag = 2;
//            
//            button2.hidden = NO;
//            [button2 setImage:[UIImage imageNamed:@"朋友圈"] forState:UIControlStateNormal];
//            [button2 setTitle:@"朋友圈" forState:UIControlStateNormal];
//            button2.tag = 3;
//            
//            //新浪
//            button3.hidden = NO;
//            [button3 setImage:[UIImage imageNamed:@"新浪"] forState:UIControlStateNormal];
//            [button3 setTitle:@"新浪微博" forState:UIControlStateNormal];
//            button3.tag = 4;
//        }
//        else if ([ShareUtil hideButtonWithThreeType:UMShareToSina])
//        {
//            // 没有新郎
//            button1.hidden = NO;
//            button2.hidden = NO;
//            button3.hidden = NO;
//            button4.hidden = NO;
//        }
//        else
//        {
//            // 没有微信
//            button1.hidden = NO;
//            button2.hidden = NO;
//            
//            //新浪
//            button3.hidden = NO;
//            [button3 setImage:[UIImage imageNamed:@"新浪"] forState:UIControlStateNormal];
//            [button3 setTitle:@"新浪微博" forState:UIControlStateNormal];
//            button3.tag = 4;
//        }
//        
//    }
//    else
//    {
//        UIButton *button1 = _threeShareButtons[0];
//        UIButton *button2 = _threeShareButtons[1];
//        
//        if (![ShareUtil hideButtonWithThreeType:UMShareToSina])
//        {
//            // 新浪
//            button1.hidden = NO;
//            [button1 setImage:[UIImage imageNamed:@"新浪"] forState:UIControlStateNormal];
//            [button1 setTitle:@"新浪微博" forState:UIControlStateNormal];
//            button1.tag = 4;
//        }
//        else if (![ShareUtil hideButtonWithThreeType:UMShareToWechatSession])
//        {
//            //微信
//            button1.hidden = NO;
//            // 微信好友
//            [button1 setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
//            [button1 setTitle:@"微信好友" forState:UIControlStateNormal];
//            button1.tag = 2;
//            
//            button2.hidden = NO;
//            [button2 setImage:[UIImage imageNamed:@"朋友圈"] forState:UIControlStateNormal];
//            [button2 setTitle:@"朋友圈" forState:UIControlStateNormal];
//            button2.tag = 3;
//        }
//        else
//        {
//            // QQ
//            button1.hidden = NO;
//            button2.hidden = NO;
//        }
//    }
    netUtil = [NetWorkingUtil netWorkingUtil];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapGesture:)];
    [_grayView addGestureRecognizer:singleTap];
}

- (IBAction)shareAction:(UIButton *)sender
{
    [self hideAction:nil];
    switch (sender.tag)
    {
        case 0:
            [self.delegate clikeShareType:UMShareToQQ];
            break;
        case 1:
            [self.delegate clikeShareType:UMShareToQzone];
            break;
        case 2:
            [self.delegate clikeShareType:UMShareToWechatSession];
            break;
        case 3:
            [self.delegate clikeShareType:UMShareToWechatTimeline];
            break;
        case 4:
            [self.delegate clikeShareType:UMShareToSina];
            break;
    }
}
//   复制链接
- (IBAction)copyLianJieClick:(id)sender {
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    
    NSString *string = [NSString stringWithFormat:@"http://www.mochoujun.com/app#/crowdfund/%ld",(long)_projectId];
    
    [pab setString:string];
    
    if (pab == nil) {
        [MBProgressHUD showSuccess:@"复制链接失败" toView:nil];
    }else{
        [MBProgressHUD showSuccess:@"复制链接成功" toView:nil];
    }
}
//   收藏
- (IBAction)collectBtnClick:(id)sender {
    [MBProgressHUD showStatus:nil toView:self];
    [netUtil requestDic4MethodName:@"Favorite/Add" parameters:@{@"CrowdFundId":@(_projectId)} result:^(NSDictionary *dic, int status, NSString *msg) {
        if (status == 1 || status == 2) {
            [MBProgressHUD dismissHUDForView:self];
            [MBProgressHUD showMessag:@"收藏成功" toView:self];
        }else{
            [MBProgressHUD dismissHUDForView:self];
            [MBProgressHUD dismissHUDForView:self withError:msg];
        }
    }];
}

//   刷新
- (IBAction)reloadBtnClick:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateDetailDataSource" object:nil];
    self.hidden = YES;
}

//   举报
- (IBAction)juBaoBtnClick:(id)sender {
    self.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SkipComplainVC" object:nil];
}

- (IBAction)hideAction:(UIButton *)sender
{
    self.hidden = YES;
}

- (void)singleTapGesture:(UITapGestureRecognizer *)recognizer
{
    self.hidden = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end