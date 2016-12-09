//
//  Employee.m
//  GYDataCenter
//
//  Created by 邬维 on 2016/12/9.
//  Copyright © 2016年 kook. All rights reserved.
//

#import "Employee.h"
#import "Department.h"

@implementation Employee


- (instancetype)initWithId:(NSInteger)employeeId
                      name:(NSString *)name
               dateOfBirth:(NSDate *)dateOfBirth
                department:(Department *)department {
    self = [super init];
    if (!self) return nil;
    
    _employeeId = employeeId;
    _name = [name copy];
    _dateOfBirth = dateOfBirth;
    [self setValue:department forKey:@"department"];
    
    return self;
}


@end
