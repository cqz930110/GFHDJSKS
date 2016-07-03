//
//  NetWorkingUtil.h
//  AFNetworkingTest
//
//  Created by book on 14-9-1.
//  Copyright (c) 2014年 persen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFHTTPRequestOperation;
@class InfoMsg;
@interface NetWorkingUtil : NSObject
//@property(copy,nonatomic)NSString *userID;
+ (NetWorkingUtil *)netWorkingUtil;

/**
 *  传入请求参数
 *
 *  @param pamar 请求参数
 *
 *  @return 请求的URL
 */

- (NSDictionary *)md5ParameterDicWithDic:(NSDictionary *)pamar;

- (NSString *)mainURL;
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
-(void) requestDic4MethodName:(NSString *)name parameters:(NSDictionary *)parameters result:(void (^)(NSDictionary *dic,int  status,NSString *msg))result;

/**
 mark by persen
 描述：通用接品单列查询，返回字典结构或者指定对象结构，如果不想把字典转化成对象，className=nil;
 输入参数：
 name：方法名
 parameters:请求参数
 className：指定对象类名 如果想字典结构，className=nil;
 输出：void (^)(id obj 指定对象的结果值
 ,int status  -1:网络异常 0:失败 1;成功，并有结查值，2;成功，但无结果值
 ,NSString *msg 信息)
 */
-(void) requestObj4MethodName:(NSString *)name parameters:(NSDictionary *)parameters result:(void (^)(id obj,int  status,NSString *msg)) result convertClassName:(NSString *)className key:(NSString *)key;


/**
 mark by persen
 描述：通用接品多列查询，返回数组－－>指定对象结构 如果想返回数组－－>字典结构，className=nil;
 输入参数：
 name：方法名
 parameters:请求参数
 className：指定对象类名 如果想返回数组－－>字典结构，className=nil;
 
 输出：void (^)(NSArray *arr 真正的结果值
 ,int status  -1:网络异常 0:失败 1;成功，并有结查值，2;成功，但无结果值
 ,NSString *msg 信息)
 */
-(void) requestArr4MethodName:(NSString *)name parameters:(NSDictionary *)parameters result:(void (^)(NSArray *arr,int  status,NSString *msg)) result convertClassName:(NSString *)className key:(NSString *)key;

/**
 mark by persen
 描述：加载网络图片资源
 输入参数：
 imageView：需要加载的图片view
 imageUrl : 图片地址
 */

+ (void)setImage:(UIImageView*)imageView url:(NSString*)imageUrl defaultIconName:(NSString*)defaultIconName;

+ (void)reach;

- (AFHTTPRequestOperation*)requestImageMethodName:(NSString *)name parameters:(NSDictionary *)parameters images :(NSArray *)images result:(void (^)(id obj,int  status,NSString *msg)) result;

- (AFHTTPRequestOperation*)requestDataMethodName:(NSString *)name parameters:(NSDictionary *)parameters datas:(NSArray *)datas result:(void (^)(id obj,int  status,NSString *msg)) result;

@end
