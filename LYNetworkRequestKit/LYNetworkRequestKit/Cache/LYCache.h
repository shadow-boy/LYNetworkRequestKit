//
//  LYCache.h
//  LYNetworkRequestKit
//
//  Created by CPX on 2018/10/23.
//  Copyright © 2018 CPX. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LYCacheDataModel;
NS_ASSUME_NONNULL_BEGIN


/**
 YYCache 缓存封装 内部使用sqlite3
 author:王连友
 */
@interface LYCache : NSObject


/**
 存储数据 异步缓存,不会阻塞主线程

 @param httpData LYCacheDataModel instance
 @param URL get fullurl
 */
+ (void)setHttpCache:(LYCacheDataModel * )httpData URL:(NSString *)URL;


/**
 获取缓存数据

 @param URL get fullurl
 @return LYCacheDataModel instance
 */
+ (LYCacheDataModel* )httpCacheForURL:(NSString *)URL;

@end

NS_ASSUME_NONNULL_END



/**
 缓存数据模型封装
 author:王连友
 */
@interface LYCacheDataModel : NSObject

@property (nonatomic,strong)NSString * url;/**<数据库主键/primary key*/
@property (nonatomic,strong)NSDictionary * httpData;/**<数据库缓存的数据*/
@property (nonatomic,strong)NSString * time;/**<当前条数据的最新时间 */


+(NSString *)currentTimeInterval;

@end
