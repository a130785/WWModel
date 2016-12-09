//
//  WWModelTests.m
//  WWModelTests
//
//  Created by 邬维 on 2016/12/8.
//  Copyright © 2016年 kook. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Department.h"
#import "Employee.h"
#import "NSObject+WWModel.h"

@interface WWModelTests : XCTestCase

@end

@implementation WWModelTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSDictionary *dic = @{
                          @"employeeId" : @1,
                          @"name" : @"Emp1",
                          @"dateOfBirth" : [NSDate date],
                          @"department" : @{
                                  @"departmentId" : @1,
                                  @"intProperty" : @(-1),
                                  @"unsignedProperty" : @22,
                                  @"shortProperty" : @(-333),
                                  @"longProperty" : @(-4444),
                                  @"unsignedLongProperty" : @55555,
                                  @"longLongProperty" : @(-666666),
                                  @"unsignedLongLongProperty" : @7777777,
                                  @"boolProperty" : @(true),
                                  @"floatProperty" : @1.1,
                                  @"doubleProperty" : @(-1.1),
                                  @"charProperty" : @('a'),
                                  @"BOOLProperty" : @NO,
                                  @"stringProperty" : @"abc",
                                  @"mutableStringProperty" : @"def",
                                  @"arrayProperty" : @[ @1, @2, @3 ]
                                  }
                          };
    Employee *el = [Employee ww_objectWithDictionary:dic];
    Department *dp = el.department;
    XCTAssert(dp,@"关联失败");
    NSLog(@"%@ , dpID = %ld",el.name , (long)dp.departmentId);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
