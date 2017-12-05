//
//  LZUploadCacheHandler.h
//  Bravo
//
//  Created by LeoZ on 2017/11/9.
//  Copyright © 2017年 SSG. All rights reserved.
//  数据上报内存管理

#import <Foundation/Foundation.h>
#import "LZSingleton.h"

typedef enum : NSUInteger {
    LZUploadCacheHandlerUploadOptionFromNowOn = 0, // 即时
    LZUploadCacheHandlerUploadOptionLimitTime, // 1分钟传一次
    LZUploadCacheHandlerUploadOptionLimitCount, // 100条传一次
} LZUploadCacheHandlerUploadOption;


@interface LZUploadCacheHandler : NSObject
LZSingletonH(Handler)

/*
 添加新的行为tag
*/
- (void)addBehaveInfoWithIdentifier:(NSString *)objectId type:(NSString *)type targetId:(NSString *)targetId other:(NSString *)other;

/**
 处理上报
 */
- (void)uploadUserHandlerPathDataWithOption:(LZUploadCacheHandlerUploadOption)option;

@end
