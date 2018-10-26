//
//  NSURLSessionTask+Extension.h
//  LYNetworkRequestKit
//
//  Created by CPX on 2018/10/26.
//  Copyright © 2018 CPX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLSessionTask (Extension)
/* 保存当前请求对象是否需要更新本地缓存 */
@property (nonatomic,assign)BOOL refreshCache;
@end

NS_ASSUME_NONNULL_END
