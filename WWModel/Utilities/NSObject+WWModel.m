//
//  NSObject+WWModel.m
//  WWModel
//
//  Created by 邬维 on 2016/12/8.
//  Copyright © 2016年 kook. All rights reserved.
//

#import "NSObject+WWModel.h"
#import <objc/runtime.h>
#import "WWReflection.h"

@implementation NSObject (WWModel)

//简单的转换
+ (instancetype)modelWithDict:(NSDictionary *)dict{
    id model = [[self alloc] init];
    unsigned int count = 0;
    
    Ivar *ivars = class_copyIvarList(self, &count);
    for (int i = 0 ; i < count; i++) {
        Ivar ivar = ivars[i];
        
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        
        ivarName = [ivarName substringFromIndex:1];
        id value = dict[ivarName];
        //nil值 会有崩溃
        [model setValue:value forKeyPath:ivarName];
    }
    
    return model;
}

//优化的字典转模型
+ (instancetype)ww_objectWithDictionary:(NSDictionary *)dictionary {
    id object = [[self alloc] init];
    
    NSArray *objectProperties = [self objectProperties];
    NSDictionary *propertyTypes = [self propertyTypes];
    for (NSString *key in dictionary.allKeys) {
        if ([objectProperties containsObject:key]) {
            id value = [dictionary objectForKey:key];
            WWPropertyType propertyType = [[propertyTypes objectForKey:key] unsignedIntegerValue];
            //如果是属性关联的对象就 递归
            if (propertyType == WWPropertyTypeRelationship) {
                NSAssert([value isKindOfClass:[NSDictionary class]], @"");
                Class propertyClass = [[self propertyClasses] objectForKey:key];
                value = [propertyClass ww_objectWithDictionary:value];
            }
            [object setValue:value forKey:key];
        }
    }
    
    return object;
}

//获取属性列表
+ (NSArray *)objectProperties {
    static const void * const kPropertyKey = &kPropertyKey;
    //runtime关联对象 减少性能开销
    NSMutableArray *properties = objc_getAssociatedObject(self, kPropertyKey);

    if (!properties) {
        properties = [NSMutableArray array];
        unsigned int count;
        //获取属性列表
        objc_property_t *propertyList = class_copyPropertyList([self class], &count);
        for (unsigned int i=0; i<count; i++) {
            const char *propertyName = property_getName(propertyList[i]); //获取属性名
            NSLog(@"property---->%@", [NSString stringWithUTF8String:propertyName]);
            
            [properties addObject:[NSString stringWithUTF8String:propertyName]];
        }
        objc_setAssociatedObject(self, kPropertyKey, properties, OBJC_ASSOCIATION_COPY);
    }
    return properties;
}

//属性类型
+ (NSDictionary *)propertyTypes {
    static const void * const kPropertyTypesKey = &kPropertyTypesKey;
    //runtime关联对象
    NSDictionary *result = objc_getAssociatedObject(self, kPropertyTypesKey);
    if (!result) {
        NSArray *properties = [self objectProperties];
        result = [[NSMutableDictionary alloc] initWithCapacity:properties.count];
        for (NSString *property in properties) {
            WWPropertyType type = [self propertyTypeOfClass:self propertyName:property];
            [(NSMutableDictionary *)result setObject:@(type) forKey:property];
        }
        objc_setAssociatedObject(self, kPropertyTypesKey, result, OBJC_ASSOCIATION_COPY);
    }
    return result;
}

+ (NSDictionary *)propertyClasses {
    static const void * const kPropertyClassesKey = &kPropertyClassesKey;
    NSDictionary *result = objc_getAssociatedObject(self, kPropertyClassesKey);
    if (!result) {
        result = [[NSMutableDictionary alloc] init];
        NSDictionary *propertyTypes = [self propertyTypes];
        for (NSString *property in propertyTypes.allKeys) {
            WWPropertyType type = [[propertyTypes objectForKey:property] unsignedIntegerValue];
            if (type == WWPropertyTypeRelationship) {
                NSString *className = [WWReflection ww_propertyTypeOfClass:self propertyName:property];
                Class propertyClass = NSClassFromString(className);
                [(NSMutableDictionary *)result setObject:propertyClass forKey:property];
            }
        }
        objc_setAssociatedObject(self, kPropertyClassesKey, result, OBJC_ASSOCIATION_COPY);
    }
    return result;
}

//自定义属性类型
+ (WWPropertyType)propertyTypeOfClass:(Class)classType propertyName:(NSString *)propertyName {
    
    //属性的原始类型
    NSString *type = [WWReflection ww_propertyTypeOfClass:classType propertyName:propertyName];
    if ([@"int" isEqualToString:type] ||
        [@"unsigned" isEqualToString:type] ||
        [@"short" isEqualToString:type] ||
        [@"long" isEqualToString:type] ||
        [@"unsigned long" isEqualToString:type] ||
        [@"long long" isEqualToString:type] ||
        [@"unsigned long long" isEqualToString:type] ||
        [@"char" isEqualToString:type]) {
        return WWPropertyTypeInteger;
    } else if ([@"float" isEqualToString:type] ||
               [@"double" isEqualToString:type]) {
        return WWPropertyTypeFloat;
    } else if ([@"NSString" isEqualToString:type] ||
               [@"NSMutableString" isEqualToString:type]) {
        return WWPropertyTypeString;
    } else if ([@"bool" isEqualToString:type]) {
        return WWPropertyTypeBoolean;
    } else if ([@"NSDate" isEqualToString:type]) {
        return WWPropertyTypeDate;
    } else if ([@"NSData" isEqualToString:type] ||
               [@"NSMutableData" isEqualToString:type]) {
        return WWPropertyTypeData;
    } else if ([@"NSArray" isEqualToString:type] ||
               [@"NSMutableArray" isEqualToString:type]) {
        return WWPropertyTypeArray;
    }
    else {
        Class propertyClass = NSClassFromString(type);
        //这里只是简单的判断 最好是继承自己的基类
        if ([propertyClass isSubclassOfClass:[NSObject class]]) {
            return WWPropertyTypeRelationship;
        }
        return WWPropertyTypeUndefined;
    }
}


//字典转字符串
+ (NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

//字符串转字典
+ (NSDictionary *)ww_dictionaryWithJSON:(id)json{
    if (!json || json == (id)kCFNull) {
        return nil;
    }
    NSDictionary *dic = nil;
    NSData *data = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dic = json;
    }else if ([json isKindOfClass:[NSString class]]) {
        data = [(NSString *)json dataUsingEncoding:NSUTF8StringEncoding];
    }else if ([json isKindOfClass:[NSData class]]) {
        data = json;
    }
    if (data) {
        dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            dic = nil;
        }
    }
    return dic;
}

@end
