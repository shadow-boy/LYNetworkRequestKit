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
static NSInteger kCacheNetworkTime = 10 * 60;
static NSInteger kCacheNoNetworkTime = 60 * 60 * 24 * 10;
NS_ASSUME_NONNULL_BEGIN


@interface NetworkRequest : NSObject


/* 域名名称  return e.g:"https://", "http://"*/
@property (nonatomic,strong)NSString * baseURL;
/* 域名前缀 return e.g:"www.baidu.com" */
@property (nonatomic,strong)NSString * baseURL_Prefix;
/* 服务器返回的业务数据key e.g "content" "data" */
@property (nonatomic,strong)NSString * kDataKey;
/* 返回业务状态码字段 */
@property (nonatomic,strong)NSString * kStatusCodeKey;
/* 返回提示消息字段*/
@property (nonatomic,strong)NSString * kMsgKey;
/* 返回成功的业务状态码 */
@property (nonatomic,assign)NSInteger  kSuccessStatusCode;
/* 请求超时设置 默认10s */
@property (nonatomic,assign)NSInteger  timeOutInterval;

/* 设置请求头 return e.g:@[@"Authorization":@"token_string"] */
@property (nonatomic,strong)NSDictionary * httpRequestHeader;

#pragma mark ---- 缓存相关
/* 有网络情况下缓存时间 默认10分钟 */
@property (nonatomic,assign)NSInteger cacheTime;

/* 无网络情况下缓存时间 默认10天 */
@property (nonatomic,assign)NSInteger cacheNoNetworkTime;

/*从缓存优先加载数据、默认NO  可以使用set方法复赋值 方法和getter方法返回值 */
@property (nonatomic,assign)BOOL loadCacheFirst;

/*刷新缓存信息、默认NO  可以使用set方法复赋值 方法和getter方法返回值*/
@property (nonatomic,assign)BOOL refreshCache;

/**
  share 类单例方法

 @return <#return value description#>
 */
+(instancetype)shareInstance;



/**
 取消某个请求

 @param action <#action description#>
 */
- (void)cancelRequestWithAction:(NSString *)action;
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
- (void)requestGetJsonOperationWithParam:(NSDictionary *)param
                                  action:(NSString *)action
                             showLoadHud:(BOOL)showHud
                            cancelEnable:(BOOL)cancelEnable
                          normalResponse:(void(^)(NSInteger status, id data))normalResponse
                       exceptionResponse:(void(^)(NSError *error))exceptionResponse;

- (void)requestPostJsonOperationWithParam:(NSDictionary *)param
                                   action:(NSString *)action
                              showLoadHud:(BOOL)showHud
                             cancelEnable:(BOOL)cancelEnable
                           normalResponse:(void(^)(NSInteger status, id data))normalResponse
                        exceptionResponse:(void(^)(NSError *error))exceptionResponse;

- (void)requestDeleteJsonOperationWithParam:(NSDictionary *)param
                                     action:(NSString *)action
                                showLoadHud:(BOOL)showHud
                               cancelEnable:(BOOL)cancelEnable
                             normalResponse:(void(^)(NSInteger status, id data))normalResponse
                          exceptionResponse:(void(^)(NSError *error))exceptionResponse;

- (void)requestPutJsonOperationWithParam:(NSDictionary *)param
                                  action:(NSString *)action
                             showLoadHud:(BOOL)showHud
                            cancelEnable:(BOOL)cancelEnable
                          normalResponse:(void(^)(NSInteger status, id data))normalResponse
                       exceptionResponse:(void(^)(NSError *error))exceptionResponse;


- (void)requestPatchJsonOperationWithParam:(NSDictionary *)param
                                    action:(NSString *)action
                               showLoadHud:(BOOL)showHud
                              cancelEnable:(BOOL)cancelEnable
                            normalResponse:(void(^)(NSInteger status, id data))normalResponse
                         exceptionResponse:(void(^)(NSError *error))exceptionResponse;


#pragma mark ------ 返回为model对象的接口

- (void)requestGetJsonModelWithParam:(NSDictionary *)param
                              action:(NSString *)action
                         showLoadHud:(BOOL)showHud
                        cancelEnable:(BOOL)cancelEnable
                          modelClass:(Class)modelClass
                      normalResponse:(void(^)(NSInteger status, id data, NSObject *model))normalResponse
                   exceptionResponse:(void(^)(NSError *error))exceptionResponse;

- (void)requestGetJsonArrayWithParam:(NSDictionary *)param
                              action:(NSString *)action
                         showLoadHud:(BOOL)showHud
                        cancelEnable:(BOOL)cancelEnable
                          modelClass:(Class)modelClass
                      normalResponse:(void(^)(NSInteger status, id data, NSMutableArray *array))normalResponse
                   exceptionResponse:(void(^)(NSError *error))exceptionResponse;



- (void)requestPostJsonModelWithParam:(NSDictionary *)param
                               action:(NSString *)action
                          showLoadHud:(BOOL)showHud
                         cancelEnable:(BOOL)cancelEnable
                           modelClass:(Class)modelClass
                       normalResponse:(void(^)(NSInteger status, id data, NSObject *model))normalResponse
                    exceptionResponse:(void(^)(NSError *error))exceptionResponse;

- (void)requestPostJsonArrayWithParam:(NSDictionary *)param
                               action:(NSString *)action
                          showLoadHud:(BOOL)showHud
                         cancelEnable:(BOOL)cancelEnable
                           modelClass:(Class)modelClass
                       normalResponse:(void(^)(NSInteger status, id data, NSMutableArray *array))normalResponse
                    exceptionResponse:(void(^)(NSError *error))exceptionResponse;



@end

NS_ASSUME_NONNULL_END
