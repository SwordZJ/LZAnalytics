//
//  UICollectionView+LZAnalytics.m
//  Bravo
//
//  Created by LeoZ on 2017/11/9.
//  Copyright © 2017年 SSG. All rights reserved.
//

#import "UICollectionView+LZAnalytics.h"
#import "LZAnalyticsKit.h"
#import "LZViewPathHelper.h"
#import <objc/runtime.h>


@implementation UICollectionView (LZAnalytics)
+ (void)load
{
    Method delegateOriginalMethod = class_getInstanceMethod([self class], @selector(setDelegate:));
    Method delegateSwizzledMethod = class_getInstanceMethod([self class], @selector(lz_setDelegate:));
    
    method_exchangeImplementations(delegateOriginalMethod, delegateSwizzledMethod);
}

- (void)lz_setDelegate:(id<UITableViewDelegate>)delegate
{
    [self lz_setDelegate:delegate];
    
    // select method
    SEL originalSelector = @selector(collectionView:didSelectItemAtIndexPath:);
    SEL swizzleSelector = @selector(lz_collectionView:didSelectItemAtIndexPath:);
    Method swizzleMethod = class_getInstanceMethod([self class], swizzleSelector);
    
    BOOL didAddMethod = class_addMethod([delegate class], swizzleSelector,method_getImplementation(swizzleMethod),method_getTypeEncoding(swizzleMethod));
    if (didAddMethod) {
        Method didSelectOriginalMethod = class_getInstanceMethod([delegate class], swizzleSelector);
        Method didSelectSwizzledMethod = class_getInstanceMethod([delegate class], originalSelector);
        method_exchangeImplementations(didSelectOriginalMethod, didSelectSwizzledMethod);
    }
    
    // will display method
    SEL originalDisplaySelector = @selector(collectionView:willDisplayCell:forItemAtIndexPath:);
    SEL swizzleDisplaySelector = @selector(lz_collectionView:willDisplayCell:forItemAtIndexPath:);
    Method swizzleDisplayMethod = class_getInstanceMethod([self class], swizzleDisplaySelector);
    
    BOOL didAddDisplayMethod = class_addMethod([delegate class], swizzleDisplaySelector, method_getImplementation(swizzleDisplayMethod), method_getTypeEncoding(swizzleDisplayMethod));
    if (didAddDisplayMethod) {
        Method willDisplayOriginMethod = class_getInstanceMethod([delegate class], swizzleDisplaySelector);
        Method willDisplaySwizzleMethod = class_getInstanceMethod([delegate class], originalDisplaySelector);
        
        method_exchangeImplementations(willDisplayOriginMethod, willDisplaySwizzleMethod);
    }
}


- (void)lz_collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self lz_collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    [[LZAnalyticsAOP sharedInstance] lz_analyticsSource:collectionView target:collectionView.delegate actionType:@"onClick" forIndexPath:indexPath];
}


- (void)lz_collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    [self lz_collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
    [[LZAnalyticsAOP sharedInstance] lz_analyticsSource:collectionView target:collectionView.delegate actionType:@"onResume" forIndexPath:indexPath];
}


// 获取指定cell的唯一路径
- (NSString *)getViewIdentity:(NSIndexPath *)idxPath
{
    NSString *idxPathString = nil;
    idxPathString = [NSString stringWithFormat:@"%@-%@", @(idxPath.section), @(idxPath.row)];
    
    NSMutableString *identifierString = [[NSMutableString alloc] init];
    
    if (NSStringFromClass([[LZViewPathHelper lz_getCurrentViewController:self] class]).length > 0) {
        [identifierString appendFormat:@"#currentVc_%@",NSStringFromClass([[LZViewPathHelper lz_getCurrentViewController:self] class])];
    }
    
    if (NSStringFromClass([self.delegate class])) {
        [identifierString appendString:[NSString stringWithFormat:@"#delegate_%@",NSStringFromClass([self.delegate class])]];
    }
    
    if (NSStringFromClass([self class])) {
        [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([self class])]];
    }
    
    if (idxPathString) {
        [identifierString appendString:[NSString stringWithFormat:@"#%@",idxPathString]];
    }
    
    UICollectionViewCell *collectionCell = [self cellForItemAtIndexPath:idxPath];
    if (collectionCell) {
        [identifierString appendFormat:@"#%@",NSStringFromClass([collectionCell class])];
    }
    
    return identifierString;
}

@end
