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

    hud.backgroundColor = [UIColor blackColor];
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
    [UIView animateWithDuration:0.2 animations:^{
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
    [UIView animateWithDuration:0.2 animations:^{
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
