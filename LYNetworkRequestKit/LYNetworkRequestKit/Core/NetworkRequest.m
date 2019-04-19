//
//  NetworkRequest.m
//  NetworkRequest
//
//  Created by CPX on 2018/10/11.
//  Copyright © 2018 CPX. All rights reserved.
//

#import "NetworkRequest.h"
#import "LYProgressHUD.h"
#import "YYModel.h"
#import "LYCache.h"
#import "NSURLSessionTask+Extension.h"

@implementation NetworkRequest
static AFNetworkReachabilityManager * _reachAbility;

+ (void)initialize {
    _reachAbility = [AFNetworkReachabilityManager sharedManager];
    [_reachAbility startMonitoring];
    [_reachAbility setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable){
            [SVProgressHUD ly_delayShowInfoWithStatus:@"NetWork disconnected" delay:3 completion:nil];
        }
    }];
    
}
+ (instancetype)shareInstance{
    static NetworkRequest * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
}

#pragma mark ------ request config begin
- (NSString *)baseURL{
    return @"www.baddu.com";
}
- (NSString *)baseURL_Prefix{
    return @"http://";
}
-(NSString * )baseURL_Full{
    return [NSString stringWithFormat:@"%@%@",self.baseURL_Prefix,self.baseURL];
}
- (NSDictionary *)httpRequestHeader{
    return nil;
}
-(NSString *)kDataKey{
    return @"content";
}
-(NSString *)kStatusCodeKey{
    return @"errorcode";
}
-(NSString *)kMsgKey{
    return @"errormessage";
}
- (NSInteger)kSuccessStatusCode{
    return 0;
}
- (NSInteger)timeOutInterval{
    return 10;
}
- (NSInteger)cacheTime{
    return 60 * 10;
}
- (NSInteger)cacheNoNetworkTime{
    return 60 * 60 * 24 * 10;
}
-(BOOL)showErrorMsg{
    return YES;
}
- (NSArray<NSNumber *> *)monitorHttpCodesWhenErrorHappen{
    return @[];
}

#pragma mark ------ request config begin



#pragma mark ---------- 网络请求方法实现

#pragma mark ---- GET
- (void)requestGetJsonOperationWithParam:(NSDictionary *)param
                                  action:(NSString *)action
                             showLoadHud:(BOOL)showHud
                            cancelEnable:(BOOL)cancelEnable
                          normalResponse:(void(^)(NSInteger status, id data))normalResponse
                       exceptionResponse:(void(^)(NSError *error))exceptionResponse {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",self.baseURL_Full,action];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableString * keyUrl = [NSMutableString stringWithString:urlString];
    if ([self constructParametersToString:param]){
        [keyUrl appendString:[self constructParametersToString:param]];
    }

    LYCacheDataModel * model = [LYCache httpCacheForURL:keyUrl];
    BOOL refreshCache = self.refreshCache;//是否刷新缓存
    BOOL cacheFirst = self.loadCacheFirst;//是否加载cache优先
    if (_reachAbility.reachable){//网络可用状态
        
        if ((model.time.integerValue - self.cacheTime) < LYCacheDataModel.currentTimeInterval.integerValue){// 缓存超过默认时间
            refreshCache = YES;
            cacheFirst = NO;
        }
        if (cacheFirst){
            if (model){//当前url有缓存、
               //处理本地缓存
                [self handleDataBodyWithData:model.httpData
                              normalResponse:normalResponse
                           exceptionResponse:exceptionResponse];
            }
            else{
                //从网络加载
                [self getJsonOperationWithParam:param
                                         action:action
                                    showLoadHud:showHud
                                   cancelEnable:cancelEnable
                                   refreshCache:refreshCache
                                 normalResponse:normalResponse
                              exceptionResponse:exceptionResponse];
            }
        }
        else{
            //从网络加载
            [self getJsonOperationWithParam:param
                                     action:action
                                showLoadHud:showHud
                               cancelEnable:cancelEnable
                               refreshCache:refreshCache
                             normalResponse:normalResponse
                          exceptionResponse:exceptionResponse];
            
        }

     
        
    }
    else{//网络不可用状态 默认从本地加载 加载不到走网络请求。。然后回调http error
        
        if ((model.time.integerValue - self.cacheNoNetworkTime) < LYCacheDataModel.currentTimeInterval.integerValue){// 缓存超过默认时间
            refreshCache = YES;
        }
        
        if (model){//当前url有缓存、
            //处理本地缓存
            [self handleDataBodyWithData:model.httpData
                          normalResponse:normalResponse
                       exceptionResponse:exceptionResponse];
        }
        else{
            //从网络加载
            [self getJsonOperationWithParam:param
                                     action:action
                                showLoadHud:showHud
                               cancelEnable:cancelEnable
                               refreshCache:refreshCache
                             normalResponse:normalResponse
                          exceptionResponse:exceptionResponse];
        }
        
    }
    

}

//get request root method
- (void)getJsonOperationWithParam:(NSDictionary *)param
                                  action:(NSString *)action
                             showLoadHud:(BOOL)showHud
                            cancelEnable:(BOOL)cancelEnable
                            refreshCache:(BOOL)refreshCache
                          normalResponse:(void(^)(NSInteger status, id data))normalResponse
                       exceptionResponse:(void(^)(NSError *error))exceptionResponse{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",self.baseURL_Full,action];
    NSMutableString * keyUrl = [NSMutableString stringWithString:urlString];
    if ([self constructParametersToString:param]){
        [keyUrl appendString:[self constructParametersToString:param]];
    }
    AFHTTPSessionManager *manager = [self requestStaticOperationManager];
    manager.requestSerializer.timeoutInterval = self.timeOutInterval;
    LYProgressHUD * hud = nil;
    if (showHud){
        hud = [LYProgressHUD showWithCancelEnable:cancelEnable];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    NSURLSessionDataTask * task = [manager GET:urlString parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        [hud hide];
        
        NSError *error = nil;
        id dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        
        if (error) {
            exceptionResponse(error);
            return ;
        }
        if (task.refreshCache){//保存缓存
            LYCacheDataModel * cache = [[LYCacheDataModel alloc]init];
            cache.httpData = dic;
            cache.time = [LYCacheDataModel currentTimeInterval];
            cache.url = keyUrl;
            [LYCache setHttpCache:cache URL:keyUrl];
        }
        [self handleDataBodyWithData:dic normalResponse:normalResponse exceptionResponse:exceptionResponse];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        exceptionResponse(error);
        
        [self handleResponseErrorWithTast:task];
        
        
    } ];
   
    task.refreshCache = refreshCache;
    if (hud){
        hud.cancelHudBlock = ^(LYProgressHUD * _Nonnull hud) {
            [task cancel];
        };
    }
    
}




#pragma mark ---- POST
- (void )requestPostJsonOperationWithParam:(NSDictionary *)param
                                    action:(NSString *)action
                               showLoadHud:(BOOL)showHud
                              cancelEnable:(BOOL)cancelEnable
                            normalResponse:(void(^)(NSInteger status, id data))normalResponse
                         exceptionResponse:(void(^)(NSError *error))exceptionResponse {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",self.baseURL_Full,action];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *manager = [self requestStaticOperationManager];
    manager.requestSerializer.timeoutInterval = self.timeOutInterval;

    LYProgressHUD * hud = nil;
    if (showHud){
        hud = [LYProgressHUD showWithCancelEnable:cancelEnable];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
   NSURLSessionDataTask * task = [manager POST:urlString parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        [hud hide];
        
        NSError *error = nil;
        id dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        
        if (error) {
            exceptionResponse(error);
            return ;
        }
        [self handleDataBodyWithData:dic normalResponse:normalResponse exceptionResponse:exceptionResponse];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        exceptionResponse(error);
        [self handleResponseErrorWithTast:task];

        
    } ];
    if (hud){
        hud.cancelHudBlock = ^(LYProgressHUD * _Nonnull hud) {
            [task cancel];
        };
    }
  
}
#pragma mark ---- DELETE
- (void)requestDeleteJsonOperationWithParam:(NSDictionary *)param
                                     action:(NSString *)action
                                showLoadHud:(BOOL)showHud
                               cancelEnable:(BOOL)cancelEnable
                             normalResponse:(void(^)(NSInteger status, id data))normalResponse
                          exceptionResponse:(void(^)(NSError *error))exceptionResponse {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",self.baseURL_Full,action];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *manager = [self requestStaticOperationManager];
    manager.requestSerializer.timeoutInterval = self.timeOutInterval;

    LYProgressHUD * hud = nil;
    if (showHud){
        hud = [LYProgressHUD showWithCancelEnable:cancelEnable];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURLSessionDataTask * task = [manager DELETE:urlString parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        [hud hide];
        
        NSError *error = nil;
        id dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        
        if (error) {
            exceptionResponse(error);
            return ;
        }
        [self handleDataBodyWithData:dic normalResponse:normalResponse exceptionResponse:exceptionResponse];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        exceptionResponse(error);
        [self handleResponseErrorWithTast:task];

    }];
    if (hud){
        hud.cancelHudBlock = ^(LYProgressHUD * _Nonnull hud) {
            [task cancel];
        };
    }
    
    
    
}
#pragma mark ---- PUT
- (void)requestPutJsonOperationWithParam:(NSDictionary *)param
                                  action:(NSString *)action
                             showLoadHud:(BOOL)showHud
                            cancelEnable:(BOOL)cancelEnable
                          normalResponse:(void(^)(NSInteger status, id data))normalResponse
                       exceptionResponse:(void(^)(NSError *error))exceptionResponse {
  
    NSString *urlString = [NSString stringWithFormat:@"%@%@",self.baseURL_Full,action];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *manager = [self requestStaticOperationManager];
    manager.requestSerializer.timeoutInterval = self.timeOutInterval;

    LYProgressHUD * hud = nil;
    if (showHud){
        hud = [LYProgressHUD showWithCancelEnable:cancelEnable];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLSessionDataTask * task = [manager PUT:urlString parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        [hud hide];
        
        NSError *error = nil;
        id dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        
        if (error) {
            exceptionResponse(error);
            return ;
        }
        [self handleDataBodyWithData:dic normalResponse:normalResponse exceptionResponse:exceptionResponse];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        exceptionResponse(error);
        [self handleResponseErrorWithTast:task];

    }];
    if (hud){
        hud.cancelHudBlock = ^(LYProgressHUD * _Nonnull hud) {
            [task cancel];
        };
    }
    
}

#pragma mark ---- PATCH
- (void)requestPatchJsonOperationWithParam:(NSDictionary *)param
                                    action:(NSString *)action
                               showLoadHud:(BOOL)showHud
                              cancelEnable:(BOOL)cancelEnable
                            normalResponse:(void(^)(NSInteger status, id data))normalResponse
                         exceptionResponse:(void(^)(NSError *error))exceptionResponse {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",self.baseURL_Full,action];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *manager = [self requestStaticOperationManager];
    manager.requestSerializer.timeoutInterval = self.timeOutInterval;

    LYProgressHUD * hud = nil;
    if (showHud){
        hud = [LYProgressHUD showWithCancelEnable:cancelEnable];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLSessionDataTask * task = [manager PATCH:urlString parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        [hud hide];
        
        NSError *error = nil;
        id dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        
        if (error) {
            exceptionResponse(error);
            return ;
        }
        [self handleDataBodyWithData:dic normalResponse:normalResponse exceptionResponse:exceptionResponse];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        exceptionResponse(error);
    }];
    if (hud){
        hud.cancelHudBlock = ^(LYProgressHUD * _Nonnull hud) {
            [task cancel];
        };
    }
    
    
}


#pragma mark ------ 返回为model对象的接口

- (void)requestGetJsonModelWithParam:(NSDictionary *)param
                              action:(NSString *)action
                         showLoadHud:(BOOL)showHud
                        cancelEnable:(BOOL)cancelEnable
                          modelClass:(Class)modelClass
                      normalResponse:(void(^)(NSInteger status, id data, NSObject *model))normalResponse
                   exceptionResponse:(void(^)(NSError *error))exceptionResponse{
    
    [self requestGetJsonOperationWithParam:param action:action showLoadHud:showHud cancelEnable:cancelEnable
                            normalResponse:^(NSInteger status, id  _Nonnull data) {
                                
                                if (data){
                                    if ([data isKindOfClass:[NSDictionary class]]) {
                                        normalResponse(status, data, [modelClass yy_modelWithDictionary:data]);
                                    }
                                }
                                else{
                                    normalResponse(status, data,nil);
                                    
                                }
        
    } exceptionResponse:^(NSError * _Nonnull error) {
        exceptionResponse(error);
    }];
}

- (void)requestGetJsonArrayWithParam:(NSDictionary *)param
                              action:(NSString *)action
                         showLoadHud:(BOOL)showHud
                        cancelEnable:(BOOL)cancelEnable
                          modelClass:(Class)modelClass
                      normalResponse:(void(^)(NSInteger status, id data, NSMutableArray *array))normalResponse
                   exceptionResponse:(void(^)(NSError *error))exceptionResponse{
    
    [self requestGetJsonOperationWithParam:param action:action showLoadHud:showHud cancelEnable:cancelEnable
                            normalResponse:^(NSInteger status, id  _Nonnull data) {
                                
                                if ([data isKindOfClass:[NSArray class]]) {
                                    NSMutableArray *returnArr = [NSMutableArray array];
                                    
                                    if (modelClass == [NSString class]) {
                                        for (id dic in data) {
                                            [returnArr addObject:dic];
                                        }
                                        normalResponse(status, data, returnArr);
                                    } else {
                                        for (id dic in data) {
                                            
                                            [returnArr addObject:[modelClass yy_modelWithDictionary:dic]];
                                        }
                                        normalResponse(status, data, returnArr);
                                    }
                                    
                                } else {
                                    normalResponse(status, data, [@[] mutableCopy]);
                                }
                                
                                
                            } exceptionResponse:^(NSError * _Nonnull error) {
                                exceptionResponse(error);
                            }];
    
}



- (void)requestPostJsonModelWithParam:(NSDictionary *)param
                               action:(NSString *)action
                          showLoadHud:(BOOL)showHud
                         cancelEnable:(BOOL)cancelEnable
                           modelClass:(Class)modelClass
                       normalResponse:(void(^)(NSInteger status, id data, NSObject *model))normalResponse
                    exceptionResponse:(void(^)(NSError *error))exceptionResponse{
    
    [self requestPostJsonOperationWithParam:param action:action showLoadHud:showHud cancelEnable:cancelEnable
                            normalResponse:^(NSInteger status, id  _Nonnull data) {
                                
                                if (data){
                                    if ([data isKindOfClass:[NSDictionary class]]) {
                                        normalResponse(status, data, [modelClass yy_modelWithDictionary:data]);
                                    }
                                }
                                else{
                                    normalResponse(status, data,nil);
                                    
                                }
                                
                            } exceptionResponse:^(NSError * _Nonnull error) {
                                exceptionResponse(error);
                            }];
    
}

- (void)requestPostJsonArrayWithParam:(NSDictionary *)param
                               action:(NSString *)action
                          showLoadHud:(BOOL)showHud
                         cancelEnable:(BOOL)cancelEnable
                           modelClass:(Class)modelClass
                       normalResponse:(void(^)(NSInteger status, id data, NSMutableArray *array))normalResponse
                    exceptionResponse:(void(^)(NSError *error))exceptionResponse{
 
    [self requestPostJsonOperationWithParam:param action:action showLoadHud:showHud cancelEnable:cancelEnable
                            normalResponse:^(NSInteger status, id  _Nonnull data) {
                                
                                if ([data isKindOfClass:[NSArray class]]) {
                                    NSMutableArray *returnArr = [NSMutableArray array];
                                    
                                    if (modelClass == [NSString class]) {
                                        for (id dic in data) {
                                            [returnArr addObject:dic];
                                        }
                                        normalResponse(status, data, returnArr);
                                    } else {
                                        for (id dic in data) {
                                            
                                            [returnArr addObject:[modelClass yy_modelWithDictionary:dic]];
                                        }
                                        normalResponse(status, data, returnArr);
                                    }
                                    
                                } else {
                                    normalResponse(status, data, [@[] mutableCopy]);
                                }
                                
                                
                            } exceptionResponse:^(NSError * _Nonnull error) {
                                exceptionResponse(error);
                            }];
    
}




#pragma mark ----- private methods
// 数据处理通用方法
-(void)handleDataBodyWithData:(NSDictionary *)dic
               normalResponse:(void(^)(NSInteger status, id data))normalResponse
            exceptionResponse:(void(^)(NSError *error))exceptionResponse {
    
    NSInteger   kSuccessCode   = self.kSuccessStatusCode;
    NSString  * kErrowMsgKey   = self.kMsgKey;
    NSString  * kErrorCodeKey  = self.kStatusCodeKey;
    NSString  * kDataKey       = self.kDataKey;
    
    if([dic isKindOfClass:[NSDictionary class]]){
       
        if ([self isnull:dic[kDataKey]]){
            normalResponse([dic[kErrorCodeKey] integerValue],nil);
        }
        else{
            normalResponse([dic[kErrorCodeKey] integerValue],dic[kDataKey]);
        }
        
        if ([dic[kErrorCodeKey] integerValue] != kSuccessCode){//修改此处的显示bug、、必须在回调之后再显示系统错误hud、不然错误一闪而过
            if (dic[kErrowMsgKey]){
                if (self.showErrorMsg){//判断是否需要显示错误信息
                    if ([dic[kErrowMsgKey] isKindOfClass:[NSString class]]){
                        [SVProgressHUD showErrorWithStatus:dic[kErrowMsgKey]];
                        
                    }
                }
                
            }
        }
        
        
    }
    
}


//全局过滤null
-(BOOL)isnull:(NSObject *)object{
    if ([object isEqual:[NSNull null]] ||
        ( [object isKindOfClass:[NSString class]] && [(NSString *)(object) isEqualToString:@"<null>"])){
        return YES;
    }
    return NO;
}

/**
  获取唯一的一个afmanager

 @return <#return value description#>
 */
- (AFHTTPSessionManager *)requestStaticOperationManager {
    static AFHTTPSessionManager *manager  =  nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager =  [AFHTTPSessionManager manager];
        [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                             @"text/json",
                                                             @"text/javascript",
                                                             @"text/html",
                                                             @"text/plain",
                                                             nil];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [manager.requestSerializer setTimeoutInterval:self.timeOutInterval];
    });
    
    
    NSDictionary * header = self.httpRequestHeader;

    if(header){
        NSArray  * keys = header.allKeys;
        for (NSString * key in keys) {
            [manager.requestSerializer setValue:header[key] forHTTPHeaderField:key];
        }
    }
    
    
    return manager;
}
//cancel a request operartion
- (void)cancelRequestWithAction:(NSString *)action {
    AFHTTPSessionManager *manager = [self requestStaticOperationManager];
    [manager.session getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> * _Nonnull dataTasks, NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks) {
        for (NSURLSessionTask *task in dataTasks) {
            if ([task.currentRequest.URL.absoluteString containsString:action]) {
                [task cancel];
            }
        }
    }];
}
//cancel all request operartion
- (void)cancelAllRequest {
    AFHTTPSessionManager *manager = [self requestStaticOperationManager];
    [manager.session getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> * _Nonnull dataTasks, NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks) {
        for (NSURLSessionTask *task in dataTasks) {
            [task cancel];
        }
    }];
}

//把get请求的参数拼接为字符串
- (NSString *)constructParametersToString:(id)parameters{
    if (parameters)
    {
        if([parameters isKindOfClass:[NSDictionary class]])
        {
            NSMutableString  * resultString = [NSMutableString string];
            NSArray * keyArray = [parameters allKeys];
            NSMutableArray * sortedArr = [[NSMutableArray alloc]
                                          initWithArray:[keyArray sortedArrayUsingSelector:@selector(compare:)]];
            
            [sortedArr enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
                [resultString appendString:[NSString stringWithFormat:@"%@=%@",key,parameters[key]]];
                
            }];
            
            if(resultString.length != 0 && resultString){
                return [NSString stringWithFormat:@"?%@",resultString];
            }
            
            
            
            
        }
    }
    return nil;
}

//处理http 错误信息 回调到外层业务层
-(void)handleResponseErrorWithTast:(NSURLSessionDataTask * )task{
    NSURLResponse * respose  = [task response];
    NSHTTPURLResponse * res = (NSHTTPURLResponse * )respose;
    NSInteger httpStatusCode = [res statusCode];
    NSLog(@"task.currentRequest.URL.absoluteString ----- %@",task.currentRequest.URL.absoluteString);
    
    if (!self.monitorHttpCodesWhenErrorHappen){
        return;
    }
    
    [self.monitorHttpCodesWhenErrorHappen enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if (obj.integerValue == httpStatusCode){
            [[NSNotificationCenter defaultCenter] postNotificationName:k_http_errorCode_observe_noti_name object:task];
        }
        
        
    }];
    

    
}




@end
