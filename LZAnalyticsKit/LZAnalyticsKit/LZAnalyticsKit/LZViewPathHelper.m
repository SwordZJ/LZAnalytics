//
//  LZViewPathHelper.m
//  Bravo
//
//  Created by LeoZ on 2017/11/9.
//  Copyright © 2017年 SSG. All rights reserved.



#import "LZViewPathHelper.h"



@implementation AnalyticsUploadHelperRequest
- (NSString *)pathURI{
    return @"";
}

- (NSDictionary *)uniqueQueryParams{
    return @{
             @"behaveInfo"    : self.behaveInfo,
             };
}

@end


@implementation LZViewPathHelper

+ (NSString *)lz_getViewPathIdentifier:(UIView *)view{
    // 获取UIView
    UIView *currentView = nil;
    if ([view isKindOfClass:[UIViewController class]]) {
        currentView = ((UIViewController *)view).view;
    } else if ([view isKindOfClass:[UIView class]]) {
        currentView = view;
    }
    
    if (nil == view) {
        return @"";
    }
    
    NSMutableString *itemId = [[NSMutableString alloc] init];
    itemId = [self _getXpath:currentView result:itemId];
    return itemId;

}

// 获取xpath Assist
+ (NSMutableString *)_getXpath:(UIView *)view result:(NSMutableString *)result {
    
    if (nil == view.superview) {
        [result appendFormat:@"%@", NSStringFromClass([view class])];
    } else {
        UIView *superView = view.superview;
        NSInteger index = [superView.subviews indexOfObject:view];
        result = [self _getXpath:view.superview result:result];
        NSMutableString *currentViewDesc = [[NSMutableString alloc] initWithString:NSStringFromClass([view class])];
        [result appendFormat:@"#%@[%ld]", currentViewDesc, (long)index];
    }
    
    return result;
}

// 根据view获取current VC
+ (UIViewController *)lz_getCurrentViewController:(id)view {
    
    if ([view isKindOfClass:[UIView class]]) {
        UIResponder *responder = view;
        while ((responder = [responder nextResponder]))
            if ([responder isKindOfClass: [UIViewController class]])
                return (UIViewController *)responder;
    } else {
        return view;
    }
    
    
    
    return nil;
}

// 获取当前窗口最前的控制器
+ (UIViewController *)lz_getWindowTopViewController{
    UIViewController *rootVc = [[UIApplication sharedApplication].windows firstObject].rootViewController;
    if ([rootVc isKindOfClass:[UINavigationController class]]) {
        return [(UINavigationController *)rootVc topViewController];
    }else if ([rootVc isKindOfClass:[UITabBarController class]]){
        UIViewController *selectVc = [(UITabBarController *)rootVc selectedViewController];
        if ([selectVc isKindOfClass:[UINavigationController class]]){
            return [(UINavigationController *)selectVc topViewController];
        }else{
            return selectVc;
        }
    }else{
        return rootVc;
    }
    return nil;
}





@end
