//
//  LYProgressHUD.m
//  LYNetworkRequestKit
//
//  Created by CPX on 2018/10/12.
//  Copyright © 2018 CPX. All rights reserved.
//

#import "LYProgressHUD.h"

static NSString * const kHiddenAllHudNotificationName = @"kHiddenAllHudNotificationName";

@interface LYProgressHUD()
@property (nonatomic,strong)UIActivityIndicatorView * indicator;
@end

@implementation LYProgressHUD

+(LYProgressHUD* )show{
  
    LYProgressHUD* hud =  [[LYProgressHUD alloc] initWithFrame:[UIScreen mainScreen].bounds];
    hud.cancel_enable = NO;
    hud.userInteractionEnabled = hud.cancel_enable;
    
    LYHUDConfig * config = [LYHUDConfig globalConfig];
    hud.backgroundColor = config.hudBgColor;
    
    hud.alpha = 0;
    [hud showAnimation];

    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    return hud;
    
}
+ (LYProgressHUD *)showWithCancelEnable:(BOOL)enble{
    
    LYProgressHUD  * hud = [self show];
    hud.cancel_enable = enble;
    hud.userInteractionEnabled = enble;
    return hud;
}

-(void)showAnimation{
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0.3;

    } completion:^(BOOL finished) {
        [self.indicator startAnimating];
    }];
}

//通用隐藏方法
-(void)hide{
    [self hideAnimation];
    [self.indicator stopAnimating];
    
}
-(void)hideAnimation{
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self.indicator startAnimating];
        [self removeFromSuperview];

    }];
    
}
- (void)hideAllHud{
    [[NSNotificationCenter defaultCenter] postNotificationName:kHiddenAllHudNotificationName object:nil];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
-(void)setupView{
    self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicator.center = self.center;
    self.indicator.color = [UIColor lightGrayColor];
    [self addSubview:self.indicator];
    self.indicator.hidesWhenStopped = YES;
    self.userInteractionEnabled =  YES;
    UITapGestureRecognizer  *  cancel_tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewTapEvent:)];
    [self addGestureRecognizer:cancel_tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hide) name:kHiddenAllHudNotificationName object:nil];


}
-(void)maskViewTapEvent:(UITapGestureRecognizer * )sender{
    if (sender.state == UIGestureRecognizerStateEnded){
        if (self.cancelHudBlock){
            self.cancelHudBlock(self);
        }
        [self  hide];
    }
}





@end


@implementation LYHUDConfig


+ (LYHUDConfig *)globalConfig{
    static LYHUDConfig *config;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        config = [LYHUDConfig new];
        
    });
    
    return config;
}
- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.hudBgColor = [UIColor clearColor];
    }
    
    return self;
}



@end






double const kHUDMinDismissTimeInterval = 2.0;

static double const kHUDDelayShowTimeInterval = 2.0;

@implementation SVProgressHUD (LYSVHUDHelper)

+ (void)ly_dismissWithDelay:(NSTimeInterval)delay completion:(LYSVProgressHUDShowCompletion)completion {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (completion) {
            completion();
        }
    });
}

+ (void)ly_showInfoWithStatus:(NSString *)status
                   completion:(LYSVProgressHUDShowCompletion)completion {
    [self showInfoWithStatus:status];
    
    [self ly_dismissWithDelay:kHUDMinDismissTimeInterval completion:completion];
}

+ (void)ly_showSuccessWithStatus:(NSString *)status
                      completion:(LYSVProgressHUDShowCompletion)completion {
    [self showSuccessWithStatus:status];
    
    [self ly_dismissWithDelay:kHUDMinDismissTimeInterval completion:completion];
}

+(void)ly_showErrorWithStatus:(NSString *)status
                   completion:(LYSVProgressHUDShowCompletion)completion {
    [self showErrorWithStatus:status];
    
    [self ly_dismissWithDelay:kHUDMinDismissTimeInterval completion:completion];
}

+ (void)ly_showTextWithStatus:(NSString *)status
                   completion:(LYSVProgressHUDShowCompletion)completion {
    [self showImage:nil status:status];
    
    [self ly_dismissWithDelay:kHUDMinDismissTimeInterval completion:completion];
}

#pragma mark - 延迟显示
+ (void)ly_delayShowSuccessWithStatus:(NSString *)status
                           completion:(LYSVProgressHUDShowCompletion)completion {
    [self ly_delayShowSuccessWithStatus:status delay:kHUDDelayShowTimeInterval completion:completion];
}

+ (void)ly_delayShowSuccessWithStatus:(NSString *)status
                                delay:(NSTimeInterval)delay
                           completion:(LYSVProgressHUDShowCompletion)completion {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self ly_showSuccessWithStatus:status completion:completion];
    });
}

+ (void)ly_delayShowErrorWithStatus:(NSString *)status
                         completion:(LYSVProgressHUDShowCompletion)completion {
    [self ly_delayShowErrorWithStatus:status delay:kHUDDelayShowTimeInterval completion:completion];
}

+ (void)ly_delayShowErrorWithStatus:(NSString *)status
                              delay:(NSTimeInterval)delay
                         completion:(LYSVProgressHUDShowCompletion)completion {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self ly_showErrorWithStatus:status completion:completion];
    });
}

+ (void)ly_delayShowInfoWithStatus:(NSString *)status
                        completion:(LYSVProgressHUDShowCompletion)completion {
    [self ly_delayShowInfoWithStatus:status delay:kHUDDelayShowTimeInterval completion:completion];
}

+ (void)ly_delayShowInfoWithStatus:(NSString *)status
                             delay:(NSTimeInterval)delay
                        completion:(LYSVProgressHUDShowCompletion)completion {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self ly_showErrorWithStatus:status completion:completion];
    });
}

+ (void)ly_delayShowTextWithStatus:(NSString *)status
                        completion:(LYSVProgressHUDShowCompletion)completion {
    [self ly_delayShowTextWithStatus:status delay:kHUDDelayShowTimeInterval completion:completion];
}

+ (void)ly_delayShowTextWithStatus:(NSString *)status
                             delay:(NSTimeInterval)delay
                        completion:(LYSVProgressHUDShowCompletion)completion {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self ly_showTextWithStatus:status completion:completion];
    });
}

@end
