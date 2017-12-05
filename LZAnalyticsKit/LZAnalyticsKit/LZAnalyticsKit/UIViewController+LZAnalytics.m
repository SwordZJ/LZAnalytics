//
//  UIViewController+LZAnalytics.m
//  Bravo
//
//  Created by LeoZ on 2017/11/9.
//  Copyright © 2017年 SSG. All rights reserved.
//

#import "UIViewController+LZAnalytics.h"
#import "LZAnalyticsKit.h"
#import <objc/runtime.h>
#import "UIView+LZAnalytics.h"

@implementation UIViewController (LZAnalytics)


- (void)setLz_AnalyticsViewControllerID:(NSString *)lz_AnalyticsViewControllerID{
    objc_setAssociatedObject(self, @selector(lz_AnalyticsViewControllerID), lz_AnalyticsViewControllerID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)lz_AnalyticsViewControllerID{
    return objc_getAssociatedObject(self,_cmd);
}

- (void)setLz_AnalyticsIgnoreViewController:(BOOL)lz_AnalyticsIgnoreViewController{
    objc_setAssociatedObject(self, @selector(lz_AnalyticsIgnoreViewController),@(lz_AnalyticsIgnoreViewController), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)lz_AnalyticsIgnoreViewController{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}


- (AnalyticsUploadData *)lz_AnalyticsViewControllerProperties {
    AnalyticsUploadData *lz_AnalyticData = objc_getAssociatedObject(self, _cmd);
    if (!lz_AnalyticData) {
        lz_AnalyticData = [[AnalyticsUploadData alloc] init];
    }
    return lz_AnalyticData;
}

- (void)setLz_AnalyticsViewControllerProperties:(AnalyticsUploadData *)lz_AnalyticsViewControllerProperties
{
    objc_setAssociatedObject(self, @selector(lz_AnalyticsViewControllerProperties), lz_AnalyticsViewControllerProperties, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}




+ (void)load
{
//    Method viewDidLoadOriginalMethod = class_getInstanceMethod([self class], @selector(viewDidLoad));
//    Method viewDidLoadSwizzledMethod = class_getInstanceMethod([self class], @selector(lz_viewDidLoad));
//
//    method_exchangeImplementations(viewDidLoadOriginalMethod, viewDidLoadSwizzledMethod);

    Method viewWillAppearOriginalMethod = class_getInstanceMethod([self class], @selector(viewWillAppear:));
    Method viewWillAppearSwizzledMethod = class_getInstanceMethod([self class], @selector(lz_viewWillAppear:));

    method_exchangeImplementations(viewWillAppearOriginalMethod, viewWillAppearSwizzledMethod);

//    Method viewDidAppearOriginalMethod = class_getInstanceMethod([self class], @selector(viewDidAppear:));
//    Method viewDidAppearSwizzledMethod = class_getInstanceMethod([self class], @selector(lz_viewDidAppear:));
//
//    method_exchangeImplementations(viewDidAppearOriginalMethod, viewDidAppearSwizzledMethod);
//
    Method viewDidDisAppearOriginalMethod = class_getInstanceMethod([self class], @selector(viewWillDisappear:));
    Method viewDidDisAppearSwizzledMethod = class_getInstanceMethod([self class], @selector(lz_viewWillDisappear:));
    
    method_exchangeImplementations(viewDidDisAppearOriginalMethod, viewDidDisAppearSwizzledMethod);
    

    
}

//- (void)lz_viewDidLoad
//{
//    [self lz_viewDidLoad];
//    [[LZAnalyticsAOP sharedInstance] lz_analyticsViewController:self actionSel:@selector(viewDidLoad)];
//}

- (void)lz_viewWillAppear:(BOOL)animated
{
    [self lz_viewWillAppear:animated];
    [[LZAnalyticsAOP sharedInstance] lz_analyticsViewController:self actionSel:@selector(viewWillAppear:) show:YES];
    
//    [[LZUploadCacheHandler sharedHandler] uploadUserHandlerPathDataWithOption:LZUploadCacheHandlerUploadOptionFromNowOn];
}

//- (void)lz_viewDidAppear:(BOOL)animated
//{
//    [self lz_viewDidAppear:animated];
//    [[LZAnalyticsAOP sharedInstance] lz_analyticsViewController:self actionSel:@selector(viewDidAppear:)];
//}


- (void)lz_viewWillDisappear:(BOOL)animated{
    [self lz_viewWillDisappear:animated];
    [[LZAnalyticsAOP sharedInstance] lz_analyticsViewController:self actionSel:@selector(viewDidDisappear:) show:NO];
    
}

@end
