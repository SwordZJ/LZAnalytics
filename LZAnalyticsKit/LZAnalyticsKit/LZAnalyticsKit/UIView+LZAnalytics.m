//
//  UIView+LZAnalytics.m
//  Bravo
//
//  Created by LeoZ on 2017/11/9.
//  Copyright © 2017年 SSG. All rights reserved.
//

#import "UIView+LZAnalytics.h"
#import "LZAnalyticsKit.h"
#import <objc/runtime.h>

@implementation AnalyticsUploadData
- (instancetype)initWithTargetId:(NSString *)targetId{
    if (self = [super init]) {
        self.targetId = targetId;
    }
    return self;
}

+ (instancetype)analyticsUploadDataWithTargetId:(NSString *)targetId other:(NSString *)other{
    AnalyticsUploadData *uploadData = [[self alloc] initWithTargetId:targetId];
    uploadData.other = other;
    return uploadData;
}


@end


@implementation UIView (LZAnalytics)


+ (void)load
{
    Method initOriginalMethod = class_getInstanceMethod([self class], @selector(addGestureRecognizer:));
    Method initSwizzledMethod = class_getInstanceMethod([self class], @selector(lz_addGestureRecognizer:));
    method_exchangeImplementations(initOriginalMethod, initSwizzledMethod);
}


-(void)lz_addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer{
    [self lz_addGestureRecognizer:gestureRecognizer];
    [gestureRecognizer addTarget:self action:@selector(lz_handleGesture:)];
}

// 此处处理需要上报的事件
-(void)lz_handleGesture:(UIGestureRecognizer*)gestureRecognizer{
    [[LZAnalyticsAOP sharedInstance] lz_analyticsUIGestureAction:gestureRecognizer];
}



- (UIViewController *)lz_viewController{
    return nil;
};

- (void)setLz_AnalyticsViewID:(NSString *)lz_AnalyticsViewID{
    objc_setAssociatedObject(self, @selector(lz_AnalyticsViewID), lz_AnalyticsViewID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)lz_AnalyticsViewID{
    return objc_getAssociatedObject(self,_cmd);
}

- (void)setLz_AnalyticsIgnoreView:(BOOL)lz_AnalyticsIgnoreView{
    objc_setAssociatedObject(self, @selector(lz_AnalyticsIgnoreView),@(lz_AnalyticsIgnoreView), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)lz_AnalyticsIgnoreView{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}


- (AnalyticsUploadData *)lz_AnalyticsViewProperties {
    AnalyticsUploadData *lz_AnalyticsViewProperties = objc_getAssociatedObject(self, _cmd);
    if (!lz_AnalyticsViewProperties) {
        lz_AnalyticsViewProperties = [[AnalyticsUploadData alloc] init];
    }
    return lz_AnalyticsViewProperties;
}

- (void)setLz_AnalyticsViewProperties:(AnalyticsUploadData *)lz_AnalyticsViewProperties
{
    objc_setAssociatedObject(self, @selector(lz_AnalyticsViewProperties), lz_AnalyticsViewProperties, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
