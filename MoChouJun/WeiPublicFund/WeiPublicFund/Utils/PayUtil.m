//
//  PayUtil.m
//  WaiMai
//
//  Created by vi_chen on 15-2-14.
//  Copyright (c) 2015年 yunna. All rights reserved.
//

#import "PayUtil.h"
@interface PayUtil(){
 void(^_completionBlock)(BOOL);
}
@end
@implementation PayUtil

#pragma mark 单例模式
static PayUtil *instance = nil;

+ (PayUtil *)payUtil {
    if (!instance) {
        instance = [[super allocWithZone:NULL] init];
    }
    return instance;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self payUtil];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)init {
    if (instance) {
        return instance;
    }
    self = [super init];
    return self;
}

-(void)payWithType:(BankPayType)payType viewController:(UIViewController*)viewController param:(id)param completion:(void (^)(BOOL isSuccess))completion {
   // NSLog(@"aaaaa..");
    _completionBlock = completion;
    if (payType == BankPayTypeAliPay) {
        NSLog(@"param:%@\n",param);
        //支付宝
//        [[AlipaySDK defaultService] payOrder:param fromScheme:@"apaykfshop" callback:^(NSDictionary *resultDic) {
//            NSLog(@"reslut = %@",resultDic);
//            if ([resultDic[@"resultStatus"]isEqualToString:@"9000"]) {
//                NSLog(@"ok..");
//                [self payResult:YES];
//                //  [self payMoneyWithUserMoney:0 pay:money];
//            }else{
//                [self payResult:NO];
//               // [SVProgressHUD showErrorWithStatus:@"支付失败~"];
//            }
//        }];

    }else if (payType == BankPayTypeWeixinPay) {
        NSLog(@"微信支付");
        //WMAlipay
        if (![WXApi isWXAppInstalled]) {
            [self payResult:NO];
            [MBProgressHUD showMessag:@"请先安装微信〜" toView:nil];
            return;
        }
        if (![param isKindOfClass:[param class]]) {
            [self payResult:NO];
            return;
        }
        NSDictionary *dic = (NSDictionary*)param;
        //微信支付
        //调起微信支付
        PayReq* req = [[PayReq alloc] init];
        NSLog(@"%@",dic);
        req.partnerId   = dic[@"partnerid"];
        req.prepayId    = dic[@"prepayid"];
        req.nonceStr    = dic[@"noncestr"];
        req.timeStamp   = [dic[@"timestamp"] intValue];
        req.package     = dic[@"package"];
        req.sign        = dic[@"sign"];
        [WXApi sendReq:req];
//        NSLog(@"\nappId:%@\npartnerId:%@\nprepayId:%@\nnonceStr:%@\ntimeStamp:%d\npackage:%@\nsign:%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,(unsigned int)req.timeStamp,req.package,req.sign);
//       NSLog([WXApi sendReq:req]?@"success":@"error");
    }
//    else if (payType == BankPayTypeLianLianPay)
//    {
//        //1 创建一个订单
//        LLPaySdk *llPay = [LLPaySdk sharedSdk];
//        llPay.sdkDelegate = self;
//        [llPay presentVerifyPaySdkInViewController:viewController withTraderInfo:param];
//        
//    }
}

#pragma mark - UPPayPluginDelegate方法
-(void)UPPayPluginResult:(NSString*)result
{
    NSLog(@"result=%@",result);
    if ([result  isEqual:@"success"]) {
        NSLog(@"银联支付成功..");
        [self payResult:YES];
    } else {
        [self payResult:NO];
   }
    
}

-(void)payResult:(BOOL)isSuccess {
        _completionBlock(isSuccess);
}

#pragma mark - 微信请求回调returnKey
-(void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]])
    {
         PayResp *payresp = (PayResp *)resp;
        NSLog(@"%@",payresp.returnKey);
        if (resp.errCode != 0)
        {
            [self payResult:NO];
        }
        else
        {
            [self payResult:YES];
        }
    }
}

#pragma mark - LLPaySDK
//
//- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary*)dic
//{
//    NSString *msg = @"支付异常";
//    switch (resultCode) {
//        case kLLPayResultSuccess:
//        {
//            msg = @"支持成功，感激涕零";
//            
//            NSString* result_pay = dic[@"result_pay"];
//            if ([result_pay isEqualToString:@"SUCCESS"])
//            {
//                //
//                //NSString *payBackAgreeNo = dic[@"agreementno"];
//                // TODO: 协议号
//                [self payResult:YES];
//            }
//            else if ([result_pay isEqualToString:@"PROCESSING"])
//            {
//                msg = @"支付单处理中";
//                [self payResult:YES];
//            }
//            else if ([result_pay isEqualToString:@"FAILURE"])
//            {
//                msg = @"支付单失败";
//                [self payResult:NO];
//            }
//            else if ([result_pay isEqualToString:@"REFUND"])
//            {
//                msg = @"支付单已退款";
//                [self payResult:NO];
//            }
//        }
//            break;
//        case kLLPayResultFail:
//        {
//            msg = @"支付没成功哦，求继续支持";
//            [self payResult:NO];
//        }
//            break;
//        case kLLPayResultCancel:
//        {
//            msg = @"支付取消";
//            [self payResult:NO];
//        }
//            break;
//        case kLLPayResultInitError:
//        {
//            msg = @"sdk初始化异常";
//            [self payResult:NO];
//        }
//            break;
//        case kLLPayResultInitParamError:
//        {
//            msg = dic[@"ret_msg"];
//            [self payResult:NO];
//        }
//            break;
//        default:
//            break;
//    }
//}

@end
