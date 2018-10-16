//
//  LYProgressHUD.h
//  LYNetworkRequestKit
//
//  Created by CPX on 2018/10/12.
//  Copyright © 2018 CPX. All rights reserved.
//

#import <UIKit/UIKit.h>




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
