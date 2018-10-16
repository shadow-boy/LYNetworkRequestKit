//
//  NetworkRequest.h
//  NetworkRequest
//
//  Created by CPX on 2018/10/11.
//  Copyright © 2018 CPX. All rights reserved.
//


//服务器返回类型数据结构需要类似于
//{
//    "errorcode": 0,
//    "errormessage": "",
//    "content": null
//}


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface NetworkRequest : NSObject
/**
 域名名称

 @return e.g:"https://", "http://"
 */
+(NSString *)baseURL;
/**
 域名前缀

 @return e.g:"www.baidu.com"
 */
+(NSString *)baseURL_Prefix;

#pragma mark -----下面4个方法是。。分别返回。。服务器返回的1、业务数据key。。2、状态码key。。。3、状态消息key。。。4、正常的状态码

/**
  服务器返回的业务数据key

 @return <#return value description#>
 */
+(NSString *)kDataKey;

/**
 返回业务状态码字段

 @return <#return value description#>
 */
+(NSString *)kStatusCodeKey;

/**
 返回提示消息字段

 @return <#return value description#>
 */
+(NSString *)kMsgKey;

/**
返回成功的业务状态码

 @return <#return value description#>
 */
+(NSInteger)kSuccessStatusCode;

/**
请求超时设置

 @return <#return value description#>
 */
+(NSInteger)timeOutInterval;
#pragma mark -----end

/**
 设置请求头。

 @return e.g:@[@"Authorization":@"token_string"]
 */
+(NSDictionary *)httpRequestHeader;


/**
 取消某个请求

 @param action <#action description#>
 */
+ (void)cancelRequestWithAction:(NSString *)action;
#pragma mark -----下面分别为请求方法。分别
/**
 *  依次为 GET POST DELETE PUT
 *
 *  @param param             参数 NSDictionary
 *  @param action            接口方法名
 *  @param normalResponse    常规block
 *  @param exceptionResponse 异常block
 *
 */
+ (void)requestGetJsonOperationWithParam:(NSDictionary *)param
                                  action:(NSString *)action
                             showLoadHud:(BOOL)showHud
                            cancelEnable:(BOOL)cancelEnable
                          normalResponse:(void(^)(NSInteger status, id data))normalResponse
                       exceptionResponse:(void(^)(NSError *error))exceptionResponse;

+ (void)requestPostJsonOperationWithParam:(NSDictionary *)param
                                   action:(NSString *)action
                              showLoadHud:(BOOL)showHud
                             cancelEnable:(BOOL)cancelEnable
                           normalResponse:(void(^)(NSInteger status, id data))normalResponse
                        exceptionResponse:(void(^)(NSError *error))exceptionResponse;

+ (void)requestDeleteJsonOperationWithParam:(NSDictionary *)param
                                     action:(NSString *)action
                                showLoadHud:(BOOL)showHud
                               cancelEnable:(BOOL)cancelEnable
                             normalResponse:(void(^)(NSInteger status, id data))normalResponse
                          exceptionResponse:(void(^)(NSError *error))exceptionResponse;

+ (void)requestPutJsonOperationWithParam:(NSDictionary *)param
                                  action:(NSString *)action
                             showLoadHud:(BOOL)showHud
                            cancelEnable:(BOOL)cancelEnable
                          normalResponse:(void(^)(NSInteger status, id data))normalResponse
                       exceptionResponse:(void(^)(NSError *error))exceptionResponse;


+ (void)requestPatchJsonOperationWithParam:(NSDictionary *)param
                                    action:(NSString *)action
                               showLoadHud:(BOOL)showHud
                              cancelEnable:(BOOL)cancelEnable
                            normalResponse:(void(^)(NSInteger status, id data))normalResponse
                         exceptionResponse:(void(^)(NSError *error))exceptionResponse;


#pragma mark ------ 返回为model对象的接口

+ (void)requestGetJsonModelWithParam:(NSDictionary *)param
                              action:(NSString *)action
                         showLoadHud:(BOOL)showHud
                        cancelEnable:(BOOL)cancelEnable
                          modelClass:(Class)modelClass
                      normalResponse:(void(^)(NSInteger status, id data, NSObject *model))normalResponse
                   exceptionResponse:(void(^)(NSError *error))exceptionResponse;

+ (void)requestGetJsonArrayWithParam:(NSDictionary *)param
                              action:(NSString *)action
                         showLoadHud:(BOOL)showHud
                        cancelEnable:(BOOL)cancelEnable
                          modelClass:(Class)modelClass
                      normalResponse:(void(^)(NSInteger status, id data, NSMutableArray *array))normalResponse
                   exceptionResponse:(void(^)(NSError *error))exceptionResponse;



+ (void)requestPostJsonModelWithParam:(NSDictionary *)param
                               action:(NSString *)action
                          showLoadHud:(BOOL)showHud
                         cancelEnable:(BOOL)cancelEnable
                           modelClass:(Class)modelClass
                       normalResponse:(void(^)(NSInteger status, id data, NSObject *model))normalResponse
                    exceptionResponse:(void(^)(NSError *error))exceptionResponse;

+ (void)requestPostJsonArrayWithParam:(NSDictionary *)param
                               action:(NSString *)action
                          showLoadHud:(BOOL)showHud
                         cancelEnable:(BOOL)cancelEnable
                           modelClass:(Class)modelClass
                       normalResponse:(void(^)(NSInteger status, id data, NSMutableArray *array))normalResponse
                    exceptionResponse:(void(^)(NSError *error))exceptionResponse;



@end

NS_ASSUME_NONNULL_END
