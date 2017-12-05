//
//  UIGestureRecognizer+LZAnalytics.m
//  Bravo
//
//  Created by LeoZ on 2017/11/9.
//  Copyright © 2017年 SSG. All rights reserved.
//

#import "UIGestureRecognizer+LZAnalytics.h"
#import "LZAnalyticsKit.h"
#import <objc/runtime.h>

@implementation UIGestureRecognizer (LZAnalytics)

+ (void)load
{
    Method initOriginalMethod = class_getInstanceMethod([self class], @selector(initWithTarget:action:));
    Method initSwizzledMethod = class_getInstanceMethod([self class], @selector(lz_initWithTarget:action:));
    method_exchangeImplementations(initOriginalMethod, initSwizzledMethod);
}

- (instancetype)lz_initWithTarget:(id)target action:(SEL)action{
    UIGestureRecognizer *gesture = [self lz_initWithTarget:target action:action];
    [[LZAnalyticsAOP sharedInstance] lz_analyticsUIGestureAction:gesture];
    return gesture;
}


@end
