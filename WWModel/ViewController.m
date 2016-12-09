//
//  ViewController.m
//  WWModel
//
//  Created by 邬维 on 2016/12/8.
//  Copyright © 2016年 kook. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+WWModel.h"
#import "Department.h"
#import "Employee.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self simpleness_jsonToModle];
    
    [self complex_dicToObject];
}


//简单的转换
- (void)simpleness_jsonToModle{
    
    Department *dp = [[Department alloc] init];
    NSDictionary *dict = @{
                           @"employeeId" : @2,
                           @"name" : @"Emp2",
                           @"department" : dp
                           };
    
    
    Employee *el = [Employee modelWithDict:dict];
    NSLog(@"%@",el.name);
}

- (void)complex_dicToObject{
    
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
    NSLog(@"%@ , dpID = %ld",el.name , (long)dp.departmentId);
    
}
@end
