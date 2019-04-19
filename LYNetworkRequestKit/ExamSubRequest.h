//
//  SubRequest.h
//  NetworkRequest
//
//  Created by CPX on 2018/10/11.
//  Copyright © 2018 CPX. All rights reserved.
//

#import "BaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExamSubRequest : BaseApi

- (void)requestGetJsonOperationWithParam:(NSDictionary *)param
                                  action:(NSString *)action
                          normalResponse:(void(^)(NSInteger status, id data))normalResponse
                       exceptionResponse:(void(^)(NSError *error))exceptionResponse;

- (void)requestPostJsonOperationWithParam:(NSDictionary *)param
                                  action:(NSString *)action
                          normalResponse:(void(^)(NSInteger status, id data))normalResponse
                       exceptionResponse:(void(^)(NSError *error))exceptionResponse;

@end

NS_ASSUME_NONNULL_END
