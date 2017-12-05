//
//  LZSingleton.h
//  Bravo
//
//  Created by LeoZ on 2017/5/3.
//  Copyright © 2017年 SSG. All rights reserved.
//

#ifndef LZSingleton_h
#define LZSingleton_h


#define LZSingletonH(name) + (instancetype)shared##name;

#define LZSingletonM(name) \
static id instance_ = nil;\
+ (instancetype)shared##name{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
instance_ = [[self alloc] init];\
});\
return instance_;\
}\
+ (instancetype)allocWithZone:(struct _NSZone *)zone{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
instance_ = [super allocWithZone:zone];\
});\
return instance_;\
}\
- (id)copyWithZone:(NSZone *)zone{\
return instance_;\
}

#endif /** LZSingleton_h */
