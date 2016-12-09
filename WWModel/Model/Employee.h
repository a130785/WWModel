//
//  Employee.h
//  GYDataCenter
//
//  Created by 邬维 on 2016/12/9.
//  Copyright © 2016年 kook. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Department;

@interface Employee : NSObject

@property (nonatomic, readonly, assign) NSInteger employeeId;
@property (nonatomic, readonly, strong) NSString *name;
@property (nonatomic, readonly, strong) NSDate *dateOfBirth;

@property (nonatomic, readonly, strong) Department *department;

- (instancetype)initWithId:(NSInteger)employeeId
                      name:(NSString *)name
               dateOfBirth:(NSDate *)dateOfBirth
                department:(Department *)department;

@end
