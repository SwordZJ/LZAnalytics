//
//  UITableView+LZAnalytics.m
//  Bravo
//
//  Created by LeoZ on 2017/11/9.
//  Copyright © 2017年 SSG. All rights reserved.
//

#import "UIView+LZAnalytics.h"
#import "UITableView+LZAnalytics.h"
#import "LZAnalyticsKit.h"
#import "LZViewPathHelper.h"
#import <objc/runtime.h>

@implementation UITableView (LZAnalytics)


+ (void)load
{
        Method delegateOriginalMethod = class_getInstanceMethod([self class], @selector(setDelegate:));
        Method delegateSwizzledMethod = class_getInstanceMethod([self class], @selector(lz_setDelegate:));
    
        method_exchangeImplementations(delegateOriginalMethod, delegateSwizzledMethod);
}

- (void)lz_setDelegate:(id<UITableViewDelegate>)delegate
{
    [self lz_setDelegate:delegate];
    
    SEL originalSelector = @selector(tableView:didSelectRowAtIndexPath:);
    SEL swizzleSelector = @selector(lz_tableView:didSelectRowIndexPath:);
    Method swizzleMethod = class_getInstanceMethod([self class], swizzleSelector);
    
    BOOL didAddMethod = class_addMethod([delegate class], swizzleSelector,method_getImplementation(swizzleMethod),method_getTypeEncoding(swizzleMethod));
    if (didAddMethod) {
        Method didSelectOriginalMethod = class_getInstanceMethod([delegate class], swizzleSelector);
        Method didSelectSwizzledMethod = class_getInstanceMethod([delegate class], originalSelector);
        method_exchangeImplementations(didSelectOriginalMethod, didSelectSwizzledMethod);
    }
    
    // will display method
    SEL originalDisplaySelector = @selector(tableView:willDisplayCell:forRowAtIndexPath:);
    SEL swizzleDisplaySelector = @selector(lz_tableView:willDisplayCell:forRowAtIndexPath:);
    Method swizzleDisplayMethod = class_getInstanceMethod([self class], swizzleDisplaySelector);
    
    BOOL didAddDisplayMethod = class_addMethod([delegate class], swizzleDisplaySelector, method_getImplementation(swizzleDisplayMethod), method_getTypeEncoding(swizzleDisplayMethod));
    if (didAddDisplayMethod) {
        Method willDisplayOriginMethod = class_getInstanceMethod([delegate class], swizzleDisplaySelector);
        Method willDisplaySwizzleMethod = class_getInstanceMethod([delegate class], originalDisplaySelector);
        
        method_exchangeImplementations(willDisplayOriginMethod, willDisplaySwizzleMethod);
    }

}


- (void)lz_tableView:(UITableView *)tableView didSelectRowIndexPath:(NSIndexPath *)indexPath{
    [self lz_tableView:tableView didSelectRowIndexPath:indexPath];
    [[LZAnalyticsAOP sharedInstance] lz_analyticsSource:tableView target:tableView.delegate actionType:@"onClick" forIndexPath:indexPath];
}

- (void)lz_tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self lz_tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    [[LZAnalyticsAOP sharedInstance] lz_analyticsSource:tableView target:tableView.delegate actionType:@"onResume" forIndexPath:indexPath];
}



- (NSString *)getViewIdentity:(NSIndexPath *)idxPath{
    NSString *idxPathString = nil;
    idxPathString = [NSString stringWithFormat:@"%@-%@", @(idxPath.section), @(idxPath.row)];
    
    NSMutableString *identifierString = [[NSMutableString alloc] init];
    
    if (NSStringFromClass([[LZViewPathHelper lz_getCurrentViewController:self] class]).length > 0) {
        [identifierString appendFormat:@"#currentVc_%@",NSStringFromClass([[LZViewPathHelper lz_getCurrentViewController:self] class])];
    }
    
    if (NSStringFromClass([self.delegate class])) {
        [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([self.delegate class])]];
    }
    
    if (NSStringFromClass([self class])) {
        [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([self class])]];
    }
    
    if (idxPathString) {
        [identifierString appendString:[NSString stringWithFormat:@"#%@",idxPathString]];
    }
    
    UITableViewCell *tableCell = [self cellForRowAtIndexPath:idxPath];
    if (tableCell) {
        [identifierString appendFormat:@"#%@",NSStringFromClass([tableCell class])];
    }
    
    return identifierString;
}


@end
