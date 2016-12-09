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
#import <objc/runtime.h>
#import "Employee.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    
        SEL simpleness_Sel = @selector(simpleness_jsonToModle);
        SEL complex_Sel = @selector(complex_dicToObject);
        //两个方法的Method
        Method simpleMethod = class_getInstanceMethod([self class], simpleness_Sel);
        Method complexMethod = class_getInstanceMethod([self class], complex_Sel);
        
        //首先动态添加方法，实现是被交换的方法，返回值表示添加成功还是失败
        BOOL isAdd = class_addMethod([self class], simpleness_Sel, method_getImplementation(complexMethod), method_getTypeEncoding(complexMethod));
        if (isAdd) {
            //如果成功，说明类中不存在这个方法的实现
            //将被交换方法的实现替换到这个并不存在的实现
            class_replaceMethod([self class], simpleness_Sel, method_getImplementation(simpleMethod), method_getTypeEncoding(simpleMethod));
        }else{
            //否则，交换两个方法的实现
            method_exchangeImplementations(simpleMethod, complexMethod);
        }
        
    });
    
    
    //方法交换后 这里实际调的是complex_dicToObject 的实现
    [self simpleness_jsonToModle];
    
//    [self complex_dicToObject];
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

//优化后的转换
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
