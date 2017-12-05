//
//  LZUploadCacheHandler.m
//  Bravo
//
//  Created by LeoZ on 2017/11/9.
//  Copyright © 2017年 SSG. All rights reserved.
//

#import "LZUploadCacheHandler.h"
#import "LZViewPathHelper.h"
#import "UIView+LZAnalytics.h"
#import <MJExtension/MJExtension.h>

#define kSSGUserHandlerPathUploadKey @"kSSGUserHandlerPathUploadKey"
#define WEAKSELF __weak typeof(self) weakSelf = self;
#define STRONGSELF __strong typeof(weakSelf) strongSelf = weakSelf;

@interface LZUploadCacheHandler ()
/*  */
@property (nonatomic, assign) LZUploadCacheHandlerUploadOption option;

/*  */
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation LZUploadCacheHandler
LZSingletonM(Handler)

- (void)addBehaveInfoWithIdentifier:(NSString *)objectId type:(NSString *)type targetId:(NSString *)targetId other:(NSString *)other{
    
    NSLog(@"触发事件类型:%@ 事件ID:%@",type,objectId);
    
    AnalyticsUploadData *behaveInfo = [AnalyticsUploadData new];
    behaveInfo.objectId = objectId;
    behaveInfo.type = type;
    behaveInfo.targetId = targetId;
    behaveInfo.time = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970] * 1000];
    behaveInfo.other = other;
    NSMutableArray *behaveDataShowArray = [[[NSUserDefaults standardUserDefaults] objectForKey:kSSGUserHandlerPathUploadKey] mutableCopy];
    if (behaveDataShowArray == nil) {
        behaveDataShowArray = [NSMutableArray array];
    }
    
    @synchronized(behaveDataShowArray){
        [behaveDataShowArray addObject:[behaveInfo mj_JSONString]];
        [[NSUserDefaults standardUserDefaults] setObject:behaveDataShowArray forKey:kSSGUserHandlerPathUploadKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (_option == LZUploadCacheHandlerUploadOptionLimitCount) {
            [self startCountAnalytics];
        }
    }
}


- (void)clearCache{
    NSMutableArray *behaveDataShowArray = [[[NSUserDefaults standardUserDefaults] objectForKey:kSSGUserHandlerPathUploadKey] mutableCopy];
    if (behaveDataShowArray.count > 0) {
        @synchronized(behaveDataShowArray){
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kSSGUserHandlerPathUploadKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (void)uploadUserHandlerPathDataWithOption:(LZUploadCacheHandlerUploadOption)option{
    _option = option;
    switch (option) {
        case LZUploadCacheHandlerUploadOptionFromNowOn:
        {
            [self uploadToServer];
        }
            break;
        case LZUploadCacheHandlerUploadOptionLimitTime:
        {
            [self startTimerAnalytics];
        }
            break;
        case LZUploadCacheHandlerUploadOptionLimitCount:
        {
            [self startCountAnalytics];
        }
            break;
        default:
            break;
    }
}


- (void)startTimerAnalytics{
    NSMutableArray *behaveDataShowArray = [[[NSUserDefaults standardUserDefaults] objectForKey:kSSGUserHandlerPathUploadKey] mutableCopy];
    WEAKSELF
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:60 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (behaveDataShowArray.count > 0) {
            [weakSelf uploadToServer];
        }
    }];
    [self.timer fire];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)startCountAnalytics{
    NSMutableArray *behaveDataShowArray = [[[NSUserDefaults standardUserDefaults] objectForKey:kSSGUserHandlerPathUploadKey] mutableCopy];
    if (behaveDataShowArray.count >= 100) {
        [self uploadToServer];
    }
}

- (void)uploadToServer{
    NSMutableArray *behaveDataShowArray = [[[NSUserDefaults standardUserDefaults] objectForKey:kSSGUserHandlerPathUploadKey] mutableCopy];
    if (behaveDataShowArray.count == 0) {
        return;
    }
    
    WEAKSELF;
    AnalyticsUploadHelperRequest *request = [AnalyticsUploadHelperRequest new];
    request.behaveInfo = [behaveDataShowArray componentsJoinedByString:@","];
    [request postRequestSuccess:^(id responseObject) {
        [weakSelf clearCache];
    }];
}


@end








