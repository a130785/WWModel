//
//  WWReflection.h
//  WWModel
//
//  Created by 邬维 on 2016/12/9.
//  Copyright © 2016年 kook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWReflection : NSObject

+ (NSString *)ww_propertyTypeOfClass:(Class)classType propertyName:(NSString *)propertyName;

@end
