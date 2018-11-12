//
//  LYProgressHUD.h
//  LYNetworkRequestKit
//
//  Created by CPX on 2018/10/12.
//  Copyright © 2018 CPX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"

#define kKeyWindow [UIApplication sharedApplication].keyWindow





NS_ASSUME_NONNULL_BEGIN

@interface LYProgressHUD : UIView

@property (nonatomic,assign)BOOL cancel_enable;/**<是否可以取消hud*/
/**
 隐藏完毕的回调
 */
@property (nonatomic,copy) void(^hideAnimationCompletion)(LYProgressHUD * hud);


/**
 取消hud的回调
 */
@property (nonatomic,copy) void(^cancelHudBlock)(LYProgressHUD * hud);


/**
 显示转圈

 @return 返回整个灰色蒙版view 默认不可以取消
 */
+(LYProgressHUD* )show;



/**
 是否可以取消的hud显示

 @param enble 是否可以取消 
 @return <#return value description#>
 */
+(LYProgressHUD* )showWithCancelEnable:(BOOL)enble;



/**
 隐藏
 */
-(void)hide;


/**
 隐藏所有hud
 */
-(void)hideAllHud;


@end

NS_ASSUME_NONNULL_END


/**
 hud 全局配置项、暂时参数较少
 */
@interface LYHUDConfig : NSObject

+ (LYHUDConfig*) globalConfig;

@property (nonatomic,strong)UIColor * hudBgColor;/**<hud全局背景色*/

@end



extern double const kHUDMinDismissTimeInterval;

typedef void(^LYSVProgressHUDShowCompletion)(void);

@interface SVProgressHUD (LYSVHUDHelper)

+ (void)ly_showInfoWithStatus:(NSString *)status
                   completion:(LYSVProgressHUDShowCompletion)completion;

+ (void)ly_showSuccessWithStatus:(NSString *)status
                      completion:(LYSVProgressHUDShowCompletion)completion;

+ (void)ly_showErrorWithStatus:(NSString *)status
                    completion:(LYSVProgressHUDShowCompletion)completion;

+ (void)ly_showTextWithStatus:(NSString *)status
                   completion:(LYSVProgressHUDShowCompletion)completion;



/**
 延迟显示成功， 内部默认2.0s
 
 @param status status description
 @param completion completion description
 */
+ (void)ly_delayShowSuccessWithStatus:(NSString *)status
                           completion:(LYSVProgressHUDShowCompletion)completion;
/**
 延迟显示成功
 
 @param status status description
 @param completion completion description
 */
+ (void)ly_delayShowSuccessWithStatus:(NSString *)status
                                delay:(NSTimeInterval)delay
                           completion:(LYSVProgressHUDShowCompletion)completion;

+ (void)ly_delayShowErrorWithStatus:(NSString *)status
                         completion:(LYSVProgressHUDShowCompletion)completion;

+ (void)ly_delayShowErrorWithStatus:(NSString *)status
                              delay:(NSTimeInterval)delay
                         completion:(LYSVProgressHUDShowCompletion)completion;

+ (void)ly_delayShowInfoWithStatus:(NSString *)status
                        completion:(LYSVProgressHUDShowCompletion)completion;

+ (void)ly_delayShowInfoWithStatus:(NSString *)status
                             delay:(NSTimeInterval)delay
                        completion:(LYSVProgressHUDShowCompletion)completion;

+ (void)ly_delayShowTextWithStatus:(NSString *)status
                        completion:(LYSVProgressHUDShowCompletion)completion;

+ (void)ly_delayShowTextWithStatus:(NSString *)status
                             delay:(NSTimeInterval)delay
                        completion:(LYSVProgressHUDShowCompletion)completion;


@end

