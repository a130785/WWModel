//
//  NSObject+WWModel.h
//  WWModel
//
//  Created by 邬维 on 2016/12/8.
//  Copyright © 2016年 kook. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WWPropertyType) {
    WWPropertyTypeUndefined,
    WWPropertyTypeInteger,
    WWPropertyTypeFloat,
    WWPropertyTypeString,
    WWPropertyTypeBoolean,
    WWPropertyTypeDate,
    WWPropertyTypeData,
    WWPropertyTypeArray,
    WWPropertyTypeRelationship
};

@interface NSObject (WWModel)

//简单的 字典转模型
+ (instancetype)modelWithDict:(NSDictionary *)dict;

//字符串转字典
+ (NSDictionary *)ww_dictionaryWithJSON:(id)json;

//字典转字符串
+ (NSString*)DataTOjsonString:(id)object;

//优化的 字典转模型
+ (instancetype)ww_objectWithDictionary:(NSDictionary *)dictionary;

@end
