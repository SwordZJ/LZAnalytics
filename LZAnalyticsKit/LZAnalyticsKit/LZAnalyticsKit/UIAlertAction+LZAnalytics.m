//
//  UIAlertAction+LZAnalytics.m
//  Bravo
//
//  Created by LeoZ on 2017/11/9.
//  Copyright © 2017年 SSG. All rights reserved.
//

#import "UIAlertAction+LZAnalytics.h"
#import "LZAnalyticsKit.h"
#import <objc/runtime.h>

@implementation UIAlertAction (LZAnalytics)

+ (void)load
{
        Method originalMethod = class_getClassMethod([self class], @selector(actionWithTitle:style:handler:));
        Method swizzledMethod = class_getClassMethod([self class], @selector(lz_actionWithTitle:style:handler:));
        method_exchangeImplementations(originalMethod, swizzledMethod);
}

+ (instancetype)lz_actionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style handler:(void (^ __nullable)(UIAlertAction *action))handler
{
    UIAlertAction *alertAction = [[self class] lz_actionWithTitle:title style:style handler:handler];
    [[LZAnalyticsAOP sharedInstance] lz_analyticsAlercctAction:alertAction];
    return alertAction;
}


@end
