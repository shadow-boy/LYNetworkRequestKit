//
//  SubRequest.m
//  NetworkRequest
//
//  Created by CPX on 2018/10/11.
//  Copyright © 2018 CPX. All rights reserved.
//

#import "ExamSubRequest.h"

@interface ExamSubRequest()

@end

@implementation ExamSubRequest
- (NSString *)baseURL{
    NSLog(@"%s",__func__);
    
    return @"119.28.116.175:8120/";//test
    
}
-(NSString *)baseURL_Prefix{
    return @"http://";
}
-(NSString *)kMsgKey{
    return @"msg";
}
- (NSString *)kDataKey{
    return @"data";
}
- (NSString *)kStatusCodeKey{
    return @"code";
}
-(NSDictionary*)httpRequestHeader{
    return @{@"uuid":@"0100000034"};
}

-(BOOL)loadCacheFirst
{
    return YES;
}
- (BOOL)refreshCache{
    return YES;
}
-(NSInteger)timeOutInterval{
    return 5;
}
- (BOOL)showErrorMsg{
    NSLog(@"%s",__func__);

    return YES;
}
- (void)requestGetJsonOperationWithParam:(NSDictionary *)param
                                  action:(NSString *)action
                          normalResponse:(void(^)(NSInteger status, id data))normalResponse
                       exceptionResponse:(void(^)(NSError *error))exceptionResponse{
    
  [  self requestGetJsonOperationWithParam:param  action:action
                               showLoadHud:YES
                              cancelEnable:YES
                            normalResponse:normalResponse exceptionResponse:exceptionResponse];
    
    
}


- (void)requestPostJsonOperationWithParam:(NSDictionary *)param
                                   action:(NSString *)action
                           normalResponse:(void(^)(NSInteger status, id data))normalResponse
                        exceptionResponse:(void(^)(NSError *error))exceptionResponse
{
    [  self requestPostJsonOperationWithParam:param  action:action
                                 showLoadHud:YES
                                cancelEnable:YES
                              normalResponse:normalResponse exceptionResponse:exceptionResponse];
    
}



@end
