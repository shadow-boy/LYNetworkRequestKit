//
//  LYNetworkRequestKitTests.m
//  LYNetworkRequestKitTests
//
//  Created by CPX on 2018/10/11.
//  Copyright © 2018 CPX. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ExamSubRequest.h"


@interface LYNetworkRequestKitTests : XCTestCase

@end

@implementation LYNetworkRequestKitTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [[ExamSubRequest shareInstance] requestGetJsonOperationWithParam:nil action:@"getDataList" showLoadHud:YES cancelEnable:YES normalResponse:^(NSInteger status, id  _Nonnull data) {
        
    } exceptionResponse:^(NSError * _Nonnull error) {
        
    }];
    
    ExamSubRequest * request1 =  [ExamSubRequest shareInstance];
    request1.loadCacheFirst = YES;
    request1.refreshCache = YES;
    [request1 requestGetJsonOperationWithParam:nil action:@"getDataList"
                                   showLoadHud:YES cancelEnable:YES
                                normalResponse:^(NSInteger status, id  _Nonnull data) {
        
    } exceptionResponse:^(NSError * _Nonnull error) {
        
    }];
    
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
