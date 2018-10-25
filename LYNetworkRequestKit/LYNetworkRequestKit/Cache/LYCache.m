//
//  LYCache.m
//  LYNetworkRequestKit
//
//  Created by CPX on 2018/10/23.
//  Copyright © 2018 CPX. All rights reserved.
//

#import "LYCache.h"
#import "YYCache.h"
#import "YYModel.h"
static NSString *const NetworkResponseCache = @"NetworkResponseCache";


@implementation LYCache
static YYCache *_dataCache;

+ (void)initialize {
    _dataCache = [YYCache cacheWithName:NetworkResponseCache];
}


+ (void)setHttpCache:(LYCacheDataModel *)httpData URL:(NSString *)URL{
    
    NSString *cacheKey = URL;
    NSDictionary *dict = [httpData yy_modelToJSONObject];
    //异步缓存,不会阻塞主线程
    [_dataCache setObject:dict forKey:cacheKey withBlock:nil];
}

+ (LYCacheDataModel * )httpCacheForURL:(NSString *)URL{
    NSString *cacheKey = URL;
    id json =  [_dataCache objectForKey:cacheKey];
    LYCacheDataModel * model = [LYCacheDataModel yy_modelWithJSON:json];
    return model;
}


+ (NSInteger)getAllHttpCacheSize {
    return [_dataCache.diskCache totalCost];
}
+ (void)removeAllHttpCache {
    [_dataCache.diskCache removeAllObjects];
}





@end



@implementation LYCacheDataModel

+ (NSString *)currentTimeInterval{
    NSString * timestampString = [NSString stringWithFormat:@"%ld",time(NULL)];
    
    return timestampString;
}

@end


