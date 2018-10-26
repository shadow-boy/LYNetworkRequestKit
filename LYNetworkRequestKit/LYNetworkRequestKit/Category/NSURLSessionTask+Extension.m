//
//  NSURLSessionTask+Extension.m
//  LYNetworkRequestKit
//
//  Created by CPX on 2018/10/26.
//  Copyright © 2018 CPX. All rights reserved.
//

#import "NSURLSessionTask+Extension.h"
#import <objc/runtime.h>
@implementation NSURLSessionTask (Extension)

static const char refreshKey;
-(BOOL)refreshCache{
    NSNumber *t = objc_getAssociatedObject(self, &refreshKey);
    
    return t.boolValue;
}
- (void)setRefreshCache:(BOOL)refreshCache{
    NSNumber *t = @(refreshCache);
    objc_setAssociatedObject(self, &refreshKey, t, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
