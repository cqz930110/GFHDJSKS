//
//  NetWorkingUtil.m
//  AFNetworkingTest
//
//  Created by book on 14-9-1.
//  Copyright (c) 2014年 persen. All rights reserved.
//

#import "NetWorkingUtil.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "UIImageView+WebCache.h"
#import "ReflectUtil.h"
#import "IOSmd5.h"
#import "User.h"

@interface NetWorkingUtil ()
{
    int  _requstSessionKeyStatus; //是否请求sessionKey结束  0:未请求 1:请求中  2：请求完毕
    NSString *_mainURL;
}
@end

//单例实现
@implementation NetWorkingUtil
static NetWorkingUtil *instance = nil;

static int netWorkState = 1;
static NSString *appKey = @"~!N@D#Z*";
static NSString *token;
static AFHTTPRequestOperationManager *manager;
+ (NetWorkingUtil *)netWorkingUtil {
    if (!instance) {
        manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        instance = [[super allocWithZone:NULL] init];
        // 设置超时时间
        manager.requestSerializer.timeoutInterval = 10.f;
        [NetWorkingUtil reach];
    }
    return instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self netWorkingUtil];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)init {
    if (IsLoadBundle)
    {
        _mainURL = @"http://www.mochoujun.com/Api/";//@"http://www.mochoujun.com/n/Api/"
    }
    else
    {
        _mainURL = @"http://192.168.1.220:8092/Api/";//    http://192.168.1.220:8092/Api/
    }
    if (instance) {
        return instance;
    }
    self = [super init];
    return self;
}

/**
 要使用常规的AFN网络访问
 
 1. AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 
 所有的网络请求,均有manager发起
 
 2. 需要注意的是,默认提交请求的数据是二进制的,返回格式是JSON
 
 1> 如果提交数据是JSON的,需要将请求格式设置为AFJSONRequestSerializer
 2> 如果返回格式不是JSON的,
 
 3. 请求格式
 
 AFHTTPRequestSerializer            二进制格式
 AFJSONRequestSerializer            JSON
 AFPropertyListRequestSerializer    PList(是一种特殊的XML,解析起来相对容易)
 
 4. 返回格式
 
 AFHTTPResponseSerializer           二进制格式
 AFJSONResponseSerializer           JSON
 AFXMLParserResponseSerializer      XML,只能返回XMLParser,还需要自己通过代理方法解析
 AFXMLDocumentResponseSerializer (Mac OS X)
 AFPropertyListResponseSerializer   PList
 AFImageResponseSerializer          Image
 AFCompoundResponseSerializer       组合
 */

#pragma mark - 演练
#pragma mark - 检测网络连接
+ (void)reach
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络,不花钱
     */
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        NSLog(@"state..%d",status);
        netWorkState = status;
//        NSLog(@"state..%d",netWorkState);

    }];
}

/**
 mark by persen
 
 输入参数：
 name：方法名
 parameters:请求参数
 type 1:单列，返回字典结构 2:多列，返回数组结构，数组里面的每一个元素都是字典
 
 输出：void (^)(NSDictionary *dic 真正的结果值
 ,int status  -1:网络异常 0:失败 1;成功，并有结查值，2;成功，但无结果值 3:stateCode＝“01”，执行失败
 ,NSString *msg 信息)
 */

-(void) request4MethodName:(NSString *)name parameters:(NSDictionary *)parameters result:(void (^)(id objs,int  status,NSString *msg)) result type:(int) type convertClassName:(NSString *)calssName key:(NSString *)key{
    //说明是第一次请求
    [self request4MethodNameWithSessionKey:name parameters:parameters result:result type:type convertClassName:calssName key:key];
//    if (IsStrEmpty(token)) {
//        [self getToken:name parameters:parameters result:result type:type convertClassName:calssName isCustomInterface:isCustom];
//        
//    }
}

-(void) request4MethodNameWithSessionKey:(NSString *)name parameters:(NSDictionary *)parameters result:(void (^)(id objs,int  status,NSString *msg)) result type:(int) type convertClassName:(NSString *)calssName  key:(NSString *)key{
    
    if (netWorkState == AFNetworkReachabilityStatusNotReachable)
    {
        result(nil,-1,@"网管去哪了，你又不是城管，来管下网络好么");
        return;
    }
    
    // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情
    NSString *postURL =  [[NSMutableString stringWithString:_mainURL] stringByAppendingFormat:@"%@",name];
    // 处理
    NSDictionary *parma = [self md5ParameterDicWithDic:parameters];
    [manager POST:postURL parameters:parma success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *resultMsg;
        int statusInt;

        NSDictionary *obj = [resultStr objectFromJSONString];
        
        if (obj==nil) {
            NSLog(@"结果为空!");
            statusInt = -1;
            resultMsg = @"请求失败，请检查网络环境!";
            result(nil,statusInt,resultMsg);
            return;
        }
        
        resultMsg = [obj valueForKey:@"Massage"];
        NSInteger stateCode = [[obj valueForKey:@"Code"] integerValue];
        id resultArray = [obj valueForKey:@"Data"];
        
        if ([resultArray isKindOfClass:[NSString class]] && IsStrEmpty(resultArray)) {
            if(200 == stateCode || 503 == stateCode){
                statusInt = 2;
            }
            else {
                statusInt = 0;
            }
            result(nil,statusInt,resultMsg);
            return;
        }
        
        if(resultArray==nil || resultArray==[NSNull null]) {
            if(200 == stateCode || 503 == stateCode)
                statusInt = 2;
            else {
                statusInt = 0;
            }

            result(nil,statusInt,resultMsg);
            return ;
        }
        
        if(200 == stateCode || 503 == stateCode) {
            if ([resultArray isKindOfClass:[NSNumber class]]) {
                //                resultObj = resultArray;
                statusInt = 1;
            } else if ([resultArray isKindOfClass:[NSString class]]) {
                //                resultObj = resultArray;
                statusInt = 1;
            } else if ([resultArray isKindOfClass:[NSDictionary class]]) {
                //                resultObj = IsNilOrNull(key)?resultArray:[resultArray objectForKey:key];
                statusInt = 1;
            }else {
                if ([resultArray count] >0)
                    statusInt = 1;
                else
                    statusInt = 2;
            }
            
        }
        else
        {
            statusInt = 0;
        }
        
        //获取 token 和 userid
        if (statusInt == 1&& NotNilAndNull(resultArray) && ([name isEqualToString:@"Auth/Login"] || [name isEqualToString:@"Auth/ThirdAuth"]))
        {
            token = [resultArray valueForKey:@"Token"];
//            _userID = [[resultArray valueForKey:@"Id"] stringValue];
        }
        
        id resultObj;
        
        if(type==1)
        {
            if ([resultArray isKindOfClass:[NSNumber class]])
            {
                resultObj = resultArray;
            }else if ([resultArray isKindOfClass:[NSString class]])
                resultObj = resultArray;
            else if ([resultArray isKindOfClass:[NSDictionary class]]) {
               // NSLog(@"111sss");
                if (key)
                {
                   resultObj = calssName==nil?[resultArray valueForKey:key]:[ReflectUtil reflectDataWithClassName:calssName otherObject:[resultArray valueForKey:key] isList:NO];
                }
                else
                {
                    resultObj = calssName==nil?resultArray:[ReflectUtil reflectDataWithClassName:calssName otherObject:resultArray isList:NO];
                }
                
            }
            else
            {
                id value = IsNilOrNull(key)?[resultArray firstObject]:[[resultArray firstObject] valueForKey:key];
                resultObj=calssName==nil?value:[ReflectUtil reflectDataWithClassName:calssName otherObject:value isList:NO];
            }
        }
        else
        {
            id value = IsNilOrNull(key)?resultArray:[resultArray  valueForKey:key];
            
            resultObj=calssName==nil?value:[ReflectUtil reflectDataWithClassName:calssName otherObject:value isList:YES];
        }   
        
        result(resultObj,statusInt,resultMsg);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        result(nil,-1,@"网管去哪了，你又不是城管，来管下网络好么");
    }];
}

/**
 mark by persen
 描述：通用接品单列查询，返回字典结构
 输入参数：
 name：方法名
 parameters:请求参数
 
 输出：void (^)(NSDictionary *dic 真正的结果值
 ,int status  -1:网络异常 0:失败 1;成功，并有结查值，2;成功，但无结果值
 ,NSString *msg 信息)
 */

-(void) requestDic4MethodName:(NSString *)name parameters:(NSDictionary *)parameters result:(void (^)(NSDictionary *dic,int  status,NSString *msg))result{
    [self request4MethodName:name parameters:parameters result:result type:1 convertClassName:nil key:nil];
}

/**
 mark by persen
 描述：通用接品单列查询，返回指定对象结构
 输入参数：
 name：方法名
 parameters:请求参数
 className：指定对象类名
 
 输出：void (^)(id obj 指定对象的结果值
 ,int status  -1:网络异常 0:失败 1;成功，并有结查值，2;成功，但无结果值
 ,NSString *msg 信息)
 */
-(void) requestObj4MethodName:(NSString *)name parameters:(NSDictionary *)parameters result:(void (^)(id obj,int  status,NSString *msg)) result convertClassName:(NSString *)className key:(NSString *)key{
    [self request4MethodName:name parameters:parameters result:result type:1 convertClassName:className key:key];
}


/**
 mark by persen
 描述：通用接品多列查询，返回数组－－>指定对象结构
 输入参数：
 name：方法名
 parameters:请求参数
 className：指定对象类名
 
 输出：void (^)(NSArray *arr 真正的结果值
 ,int status  -1:网络异常 0:失败 1;成功，并有结查值，2;成功，但无结果值
 ,NSString *msg 信息)
 */
-(void) requestArr4MethodName:(NSString *)name parameters:(NSDictionary *)parameters result:(void (^)(NSArray *arr,int  status,NSString *msg)) result convertClassName:(NSString *)className key:(NSString *)key{
    [self request4MethodName:name parameters:parameters result:result type:2 convertClassName:className key:key];
}

//-(void) getImage
//{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFImageResponseSerializer serializer];
////    UIImageView *imageView;
////#warning todo - URL 需要更改 URL获取Image
////    [imageView sd_setImageWithURL:[NSURL URLWithString:nil]];
//}

/**
 mark by persen
 描述：通用接品单列查询，返回字典结构
 输入参数：
 name：方法名
 controllerName : 所属控制器
 parameters:请求参数
 
 输出：void (^)(NSDictionary *dic 真正的结果值
 ,int status  -1:网络异常 0:失败 1;成功，并有结查值，2;成功，但无结果值
 ,NSString *msg 信息)
 */

//-(void) customRequestDic4MethodName:(NSString *)name controller:(NSString *)controllerName parameters:(NSDictionary *)parameters result:(void (^)(NSDictionary *dic,int  status,NSString *msg)) result {
//    [self customRequest4MethodName:name controller:controllerName parameters:parameters result:result type:1 convertClassName:nil];
//}


/**
 mark by persen
 描述：通用接品多列查询，返回数组－－>指定对象结构
 输入参数：
 name：方法名
 controllerName : 所属控制器
 parameters:请求参数
 className：指定对象类名
 
 输出：void (^)(NSArray *arr 真正的结果值
 ,int status  -1:网络异常 0:失败 1;成功，并有结查值，2;成功，但无结果值
 ,NSString *msg 信息)
 */
//-(void) customRequestArr4MethodName:(NSString *)name controller:controllerName parameters:(NSDictionary *)parameters result:(void (^)(NSArray *arr,int  status,NSString *msg)) result convertClassName:(NSString *)className
//{
//    [self customRequest4MethodName:name controller:controllerName parameters:parameters result:result type:2 convertClassName:className];
//}

/**
 mark by persen
 描述：自定义接口查询
 输入参数：
 name：方法名
 controllerName : 所属控制器
 parameters:请求参数
 type 1:单列，返回字典结构 2:多列，返回数组结构，数组里面的每一个元素都是字典
 
 type 1:单列，返回字典结构 2:多列，返回数组结构，数组里面的每一个元素都是字典
 输出：void (^)(NSDictionary *dic 真正的结果值
 ,int status  -1:网络异常 0:失败 1;成功，并有结查值，2;成功，但无结果值
 ,NSString *msg 信息)
 */
//-(void) customRequest4MethodName:(NSString *)name controller:(NSString *)controllerName parameters:(NSDictionary *)parameters result:(void (^)(id objs,int status,NSString *msg)) result type:(int) type convertClassName:(NSString *)calssName {
//    [self request4MethodName:[NSString stringWithFormat:@"ci/%@.do?%@",controllerName,name]parameters:parameters result:result type:type convertClassName:calssName isCustomInterface:YES];
//    
//}
/**
 自定义接口
 mark by persen
 描述：通用接品单列查询，返回图片的二进制数据
 输入参数：
 name：方法名
 controllerName : 所属控制器
 parameters:请求参数
 
 输出：void (^)(NSData *imageData 真正的结果值
 ,int status  -1:网络异常 0:失败 1;成功，并有结查值，2;成功，但无结果值
 ,NSString *msg 信息)
 */
-(void) customRequestImage4MethodName:(NSString *)name controller:(NSString *)controllerName parameters:(NSDictionary *)parameters result:(void (^)(NSData *imageDate)) result
{
    
    // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情
    NSString *postURL =  [[NSMutableString stringWithString:_mainURL] stringByAppendingFormat:@"ci/%@.do?%@&sessionkey=%@",controllerName,name,token];
    [manager POST:postURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSString *resultStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *data = responseObject;
        result(data);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        NSLog(@"%@", error);
        result(nil);
        
    }];
}

-(void) customNoCiRequestImage4MethodName:(NSString *)name controller:(NSString *)controllerName parameters:(NSDictionary *)parameters result:(void (^)(NSData *imageDate)) result
{
    
    // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情
    NSString *postURL =  [[NSMutableString stringWithString:_mainURL] stringByAppendingFormat:@"%@.do?%@&sessionkey=%@",controllerName,name,token];
    [manager POST:postURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSString *resultStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *data = responseObject;
        result(data);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        NSLog(@"%@", error);
        result(nil);
        
    }];
}

/**
 mark by persen
 描述：加载网络图片资源
 输入参数：
 imageView：需要加载的图片view
 imageUrl : 图片地址
 */

+ (void)setImage:(UIImageView*)imageView url:(NSString*)imageUrl defaultIconName:(NSString*)defaultIconName {
    //  NSLog(@"url:%@",imageUrl);
    UIImage *defaultImage;
    if (defaultIconName)
    {
        defaultImage = [UIImage imageNamed:defaultIconName];
    }

    if(defaultImage)
    {
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:defaultImage options:SDWebImageLowPriority|SDWebImageRetryFailed];
    }
    else
    {
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:SDWebImageLowPriority|SDWebImageRetryFailed];
    }
}

/**
 mark persen
 描述：只获取结果返回id结构
 输入参数：
 name：方法名
 controllerName : 所属控制器
 parameters:请求参数
 */
//- (void) customRequestObj4MethodName:(NSString *)name controller:(NSString *)controllerName parameters:(NSDictionary *)parameters result:(void (^)(id obj, int status, NSString *msg)) result convertClassName:(NSString *)calssName
//{
//    
//    [self customRequest4MethodName:name controller:controllerName parameters:parameters result:result type:1 convertClassName:calssName];
//

- (AFHTTPRequestOperation*)requestDataMethodName:(NSString *)name parameters:(NSDictionary *)parameters datas:(NSArray *)datas result:(void (^)(id obj,int  status,NSString *msg)) result
{
    NSString *postURL =  [[NSMutableString stringWithString:_mainURL] stringByAppendingFormat:@"%@",name];
    
    if (datas.count == 0) {
        NSLog(@"上传内容没有包含数据");
        //        return nil;
    }
    NSDictionary *parma = [self md5ParameterDicWithDic:parameters];
    AFHTTPRequestOperation *operation = [manager POST:postURL parameters:parma constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
                                         
                                         
                                         {
                                             if (datas.count != 0)
                                             {
                                                 int i = 0;
                                                 //根据当前系统时间生成图片名称
                                                 NSDate *date = [NSDate date];
                                                 NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                                                 [formatter setDateFormat:@"yyyy年MM月dd日"];
                                                 NSString *dateString = [formatter stringFromDate:date];
                                                 
                                                 for (id data in datas)
                                                 {
                                                     NSString *fileName;
                                                     NSData *filedata;
                                                     NSString *mineType;
                                                     if ([data isKindOfClass:[UIImage class]])
                                                     {
                                                         fileName = [NSString stringWithFormat:@"%@%d.png",dateString,i];
                                                         filedata = UIImageJPEGRepresentation(data, 0.5);
                                                         mineType = @"image/jpg/png/jpeg";
                                                     }
                                                     else
                                                     {
                                                         fileName = [NSString stringWithFormat:@"%@%d.amr",dateString,i];
                                                         filedata = data;
                                                         mineType = @"amr/audio/m4a/wav/mp3";
                                                     }
                                                     [formData appendPartWithFileData:filedata name:@"datas" fileName:fileName mimeType:mineType];
                                                 }
                                             }
                                         } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
                                         {
                                             NSString *resultStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                             NSString *resultMsg;
                                             int statusInt;
                                             //        resultStr
                                             NSDictionary *obj = [resultStr objectFromJSONString];
                                             //NSLog(@"obj:%@", obj);
                                             
                                             if (obj==nil) {
                                                 NSLog(@"结果为空!");
                                                 statusInt = -1;
                                                 resultMsg = @"请求失败，请检查网络环境!";
                                                 result(nil,statusInt,resultMsg);
                                                 return;
                                             }
                                             
                                             resultMsg = [obj valueForKey:@"Massage"];
                                             NSInteger stateCode = [[obj valueForKey:@"Code"] integerValue];
                                             id resultArray = [obj valueForKey:@"Data"];
                                             if(resultArray==nil || resultArray==[NSNull null]) {
                                                 if(200 == stateCode)
                                                     statusInt = 2;
                                                 else {
                                                     statusInt = 0;
                                                 }
                                                 
                                                 result(nil,statusInt,resultMsg);
                                                 return ;
                                             }
                                             
                                             if(200 == stateCode) {
                                                 if ([resultArray isKindOfClass:[NSNumber class]]) {
                                                     //                resultObj = resultArray;
                                                     statusInt = 1;
                                                 } else if ([resultArray isKindOfClass:[NSString class]]) {
                                                     //                resultObj = resultArray;
                                                     statusInt = 1;
                                                 } else if ([resultArray isKindOfClass:[NSDictionary class]]) {
                                                     //                resultObj = IsNilOrNull(key)?resultArray:[resultArray objectForKey:key];
                                                     statusInt = 1;
                                                 }else {
                                                     if ([resultArray count] >0)
                                                         statusInt = 1;
                                                     else
                                                         statusInt = 2;
                                                 }
                                                 
                                             }
                                             else
                                             {
                                                 statusInt = 0;
                                             }
                                             
                                             
                                             id resultObj;
                                             
                                             
                                             if ([resultArray isKindOfClass:[NSNumber class]])
                                             {
                                                 resultObj = resultArray;
                                             }else if ([resultArray isKindOfClass:[NSString class]])
                                                 resultObj = resultArray;
                                             else if ([resultArray isKindOfClass:[NSDictionary class]]) {
                                                 resultObj = resultArray;
                                             }
                                             else
                                             {
                                                 id value = [resultArray firstObject];
                                                 resultObj=value;
                                             }
                                             result(resultObj,statusInt,resultMsg);
                                             
                                         } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                                             result(nil,-1,@"服务器忙,请稍后访问！");
                                         }];
    
    return operation;

}

- (AFHTTPRequestOperation*)requestImageMethodName:(NSString *)name parameters:(NSDictionary *)parameters images :(NSArray *)images result:(void (^)(id obj,int  status,NSString *msg)) result
{
    NSString *postURL =  [[NSMutableString stringWithString:_mainURL] stringByAppendingFormat:@"%@",name];
    
    if (images.count == 0) {
        NSLog(@"上传内容没有包含图片");
//        return nil;
    }
    for (int i = 0; i < images.count; i++)
    {
        
        if (![images[i] isKindOfClass:[UIImage class]]) {
            NSLog(@"images中第%d个元素不是UIImage对象",i+1);
            return nil;
        }
    }
    NSDictionary *parma = [self md5ParameterDicWithDic:parameters];
    AFHTTPRequestOperation *operation = [manager POST:postURL parameters:parma constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
        
    
                                         {
                                             if (images.count != 0)
                                             {
                                                 int i = 0;
                                                 //根据当前系统时间生成图片名称
                                                 NSDate *date = [NSDate date];
                                                 NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                                                 [formatter setDateFormat:@"yyyy年MM月dd日"];
                                                 NSString *dateString = [formatter stringFromDate:date];
                                                 
                                                 for (UIImage *image in images) {
                                                     NSString *fileName = [NSString stringWithFormat:@"%@%d.png",dateString,i];
                                                     NSData *imageData;
                                                     
                                                     imageData = UIImageJPEGRepresentation(image, 0.5);
                                                     [formData appendPartWithFileData:imageData name:@"images" fileName:fileName mimeType:@"image/jpg/png/jpeg"];
                                                 }
                                             }
                                         } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
                                         {
                                             NSString *resultStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                             NSString *resultMsg;
                                             int statusInt;
                                             //        resultStr
                                             NSDictionary *obj = [resultStr objectFromJSONString];
                                             //NSLog(@"obj:%@", obj);
                                             
                                             if (obj==nil) {
                                                 NSLog(@"结果为空!");
                                                 statusInt = -1;
                                                 resultMsg = @"请求失败，请检查网络环境!";
                                                 result(nil,statusInt,resultMsg);
                                                 return;
                                             }
                                             
                                             resultMsg = [obj valueForKey:@"Massage"];
                                             NSInteger stateCode = [[obj valueForKey:@"Code"] integerValue];
                                             id resultArray = [obj valueForKey:@"Data"];
                                             if(resultArray==nil || resultArray==[NSNull null]) {
                                                 if(200 == stateCode)
                                                     statusInt = 2;
                                                 else {
                                                     statusInt = 0;
                                                 }
                                                 
                                                 result(nil,statusInt,resultMsg);
                                                 return ;
                                             }
                                             
                                             if(200 == stateCode) {
                                                 if ([resultArray isKindOfClass:[NSNumber class]]) {
                                                     //                resultObj = resultArray;
                                                     statusInt = 1;
                                                 } else if ([resultArray isKindOfClass:[NSString class]]) {
                                                     //                resultObj = resultArray;
                                                     statusInt = 1;
                                                 } else if ([resultArray isKindOfClass:[NSDictionary class]]) {
                                                     //                resultObj = IsNilOrNull(key)?resultArray:[resultArray objectForKey:key];
                                                     statusInt = 1;
                                                 }else {
                                                     if ([resultArray count] >0)
                                                         statusInt = 1;
                                                     else
                                                         statusInt = 2;
                                                 }
                                                 
                                             }
                                             else
                                             {
                                                 statusInt = 0;
                                             }
                                             
                                             
                                             id resultObj;
                                             
                                             
                                             if ([resultArray isKindOfClass:[NSNumber class]])
                                             {
                                                 resultObj = resultArray;
                                             }else if ([resultArray isKindOfClass:[NSString class]])
                                                 resultObj = resultArray;
                                             else if ([resultArray isKindOfClass:[NSDictionary class]]) {
                                                 resultObj = resultArray;
                                             }
                                             else
                                             {
                                                 id value = [resultArray firstObject];
                                                 resultObj=value;
                                             }
                                             result(resultObj,statusInt,resultMsg);
                                             
                                         } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                                             result(nil,-1,@"网管去哪了，你又不是城管，来管下网络好么");
                                         }];
    
    return operation;
}

#pragma mark - util
- (NSString *)mainURL
{
    return _mainURL;
}

- (NSDictionary *)md5ParameterDicWithDic:(NSDictionary *)pamar
{
    // 对传的参数进行处理
    NSMutableDictionary * dic = pamar?[NSMutableDictionary dictionaryWithDictionary:pamar]:[NSMutableDictionary dictionary];
    // token
    if (token)
    {
        [dic setObject:token forKey:@"Token"];
    }
    
    User *userInfo = [User shareUser];
    if (userInfo.Id.integerValue)
    {
        [dic setObject:userInfo.Id forKey:@"UserId"];
    }
    
    [dic setObject:@"2" forKey:@"Platform"];
    
    // 排序
    NSArray *keys = [self sortKeys:[dic allKeys]];
    
    // 生成加密参数
    NSMutableString *valueStr = [NSMutableString string];
    for (NSString *key in keys)
    {
        id obj = [dic objectForKey:key];
        NSString *str;
        if ([obj isKindOfClass:[NSString class]])// 字符串
        {
            str = (NSString *)obj;
        }
        else if ([obj isKindOfClass:[NSNumber class]]) // number
        {
            str = [obj stringValue];
        }
        if (str)
        {
            [valueStr appendFormat:@"%@|",str];
        }
    }
    [valueStr appendString:appKey];
    [dic setObject:[IOSmd5 md5:valueStr] forKey:@"Sign"];
    return dic;
}

- (NSArray *)sortKeys:(NSArray *)keys
{
    keys = [keys sortedArrayUsingComparator:^NSComparisonResult(NSString*  _Nonnull obj1, NSString*  _Nonnull obj2)
            {
                NSComparisonResult result =  [obj1 compare:obj2 options:NSLiteralSearch];
                return result == NSOrderedDescending;
            }];
    return keys;
}

+(void)startMultiPartUploadTaskWithURL:(NSString *)url
                           imagesArray:(NSArray *)images
                     parameterOfimages:(NSString *)parameter
                        parametersDict:(NSDictionary *)parameters
                      compressionRatio:(float)ratio
                          succeedBlock:(void(^)(id operation, id responseObject))succeedBlock
                           failedBlock:(void(^)(id operation, NSError *error))failedBlock
                   uploadProgressBlock:(void(^)(float uploadPercent,long long totalBytesWritten,long long totalBytesExpectedToWrite))uploadProgressBlock
{
    
}

@end
