# LYNetworkRequestKit
# * 王连友独立设计开发的网络请求框架、支持对网络请求hud 的显示、支持点击hud背景取消某个网络请求的操作、支持http get请求缓存

### 1、基础使用方法：
```
[[ExamSubRequest shareInstance] requestGetJsonOperationWithParam:nil action:@"getDataList" showLoadHud:YES cancelEnable:YES normalResponse:^(NSInteger status, id  _Nonnull data) {
		//成功回调
    } exceptionResponse:^(NSError * _Nonnull error) {
    	//失败回调
    }];

```
### 2、针对单个请求设置网络请求设置、
```
ExamSubRequest * request1 =  [ExamSubRequest shareInstance];
    request1.loadCacheFirst = YES;//允许优先从缓存加载
    request1.refreshCache = YES;//允许刷新当前缓存
    [request1 requestGetJsonOperationWithParam:nil action:@"getDataList"
                                   showLoadHud:YES cancelEnable:YES
                                normalResponse:^(NSInteger status, id  _Nonnull data) {
        
    } exceptionResponse:^(NSError * _Nonnull error) {
        
    }];

```

### 3、对某个请求类设置全局请求设置、
```
//允许优先从缓存加载
-(BOOL)loadCacheFirst
{
    return YES;
}
//允许刷新当前缓存
- (BOOL)refreshCache{
    return YES;
}
```

-----


**下面方法允许直接网络请求数据解析成对应model返回数据给逻辑层**


-  get返回一个model
```
-(void)requestGetJsonModelWithParam:(NSDictionary *)param
                              action:(NSString *)action
                         showLoadHud:(BOOL)showHud
                        cancelEnable:(BOOL)cancelEnable
                          modelClass:(Class)modelClass
                      normalResponse:(void(^)(NSInteger status, id data, NSObject *model))normalResponse
                   exceptionResponse:(void(^)(NSError *error))exceptionResponse;
```

- get返回model数组
```
-(void)requestGetJsonArrayWithParam:(NSDictionary *)param
                              action:(NSString *)action
                         showLoadHud:(BOOL)showHud
                        cancelEnable:(BOOL)cancelEnable
                          modelClass:(Class)modelClass
                      normalResponse:(void(^)(NSInteger status, id data, NSMutableArray *array))normalResponse
                   exceptionResponse:(void(^)(NSError *error))exceptionResponse;
```



- post返回一个model 
```
--(void)requestPostJsonModelWithParam:(NSDictionary *)param
                               action:(NSString *)action
                          showLoadHud:(BOOL)showHud
                         cancelEnable:(BOOL)cancelEnable
                           modelClass:(Class)modelClass
                       normalResponse:(void(^)(NSInteger status, id data, NSObject *model))normalResponse
                    exceptionResponse:(void(^)(NSError *error))exceptionResponse;
```

-  post返回model 数组
```
-(void)requestPostJsonArrayWithParam:(NSDictionary *)param
                               action:(NSString *)action
                          showLoadHud:(BOOL)showHud
                         cancelEnable:(BOOL)cancelEnable
                           modelClass:(Class)modelClass
                       normalResponse:(void(^)(NSInteger status, id data, NSMutableArray *array))normalResponse
                    exceptionResponse:(void(^)(NSError *error))exceptionResponse;
```

# 使用方法
`pod 'LYNetworkRequestKit'`
`pod install`


# *TODOLIST*
1. 编写swift版本
2. 继续优化代码使用方法等


# CHANLOG 
- 设置有效超时时间。。修复之前超时时间无效的问题



