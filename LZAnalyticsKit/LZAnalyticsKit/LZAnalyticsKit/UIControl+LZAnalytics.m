//
//  UIControl+LZAnalytics.m
//  Bravo
//
//  Created by LeoZ on 2017/11/9.
//  Copyright © 2017年 SSG. All rights reserved.
//

#import "UIControl+LZAnalytics.h"
#import "LZAnalyticsKit.h"
#import <objc/runtime.h>

@implementation UIControl (LZAnalytics)

+ (void)load
{
    Method initOriginalMethod = class_getInstanceMethod([self class], @selector(sendAction:to:forEvent:));
    Method initSwizzledMethod = class_getInstanceMethod([self class], @selector(lz_sendAction:to:forEvent:));
    method_exchangeImplementations(initOriginalMethod, initSwizzledMethod);
}

- (void)lz_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    // 交换事件
    [self lz_sendAction:action to:target forEvent:event];
    
    // 添加事件到上报队列
    [[LZAnalyticsAOP sharedInstance] lz_analyticsSource:self action:action target:target event:event];
}


@end
