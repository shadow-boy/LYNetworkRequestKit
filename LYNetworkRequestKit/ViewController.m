//
//  ViewController.m
//  LYNetworkRequestKit
//
//  Created by CPX on 2018/10/26.
//  Copyright © 2018 LYCoder. All rights reserved.
//

#import "ViewController.h"
#import "ExamSubRequest.h"
#import "LYProgressHUD.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
  
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    for (NSInteger index = 0;index<1000;index++){
//        [[ExamSubRequest shareInstance] requestGetJsonOperationWithParam:nil action:@"action"
//                                                             showLoadHud:YES
//                                                            cancelEnable:YES
//                                                          normalResponse:^(NSInteger status, id  _Nonnull data) {
//                                                              NSLog(@"%@",[NSThread currentThread]);
//        } exceptionResponse:^(NSError * _Nonnull error) {
//            NSLog(@"%@",[NSThread currentThread]);
//
//        }];
//    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        LYProgressHUD * hud  =  [LYProgressHUD showWithCancelEnable:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud hide];
        });
    });
 
    
    
}

@end
