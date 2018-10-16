//
//  SubRequest.m
//  NetworkRequest
//
//  Created by CPX on 2018/10/11.
//  Copyright © 2018 CPX. All rights reserved.
//

#import "SubRequest.h"

@implementation SubRequest
+ (NSString *)baseURL{
    return @"sandbox.catchadoll.com:8888/v1/";
}
+(NSString *)baseURL_Prefix{
    return @"http://";
}
+(NSString *)kMsgKey{
    return @"errormessage";
}
+ (NSString *)kDataKey{
    return @"content";
}
+ (NSString *)kStatusCodeKey{
    return @"errorcode";
}
+(NSDictionary*)httpRequestHeader{
    return @{@"Authorization":[NSString stringWithFormat:@"Bearer %@",@"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NDU2MjI1OTAsImlhdCI6MTUzOTU3NDU5MCwiaWQiOjEyODY1fQ.nOzF41IOJGEF2ZCnpM_kdlqNJJ_iODyktDJohN55LJI"]};
}


@end
