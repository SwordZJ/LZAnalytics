//
//  LZAnalyticsKit.m
//  Bravo
//
//  Created by LeoZ on 2017/11/7.
//  Copyright © 2017年 SSG. All rights reserved.
//

#import "LZAnalyticsKit.h"
#import "LZViewPathHelper.h"
#import "LZUploadCacheHandler.h"
#import "UIViewController+LZAnalytics.h"
#import "UIView+LZAnalytics.h"

@implementation LZAnalyticsAOP
+ (instancetype)sharedInstance
{
    static LZAnalyticsAOP *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc]init];
    });
    
    return _sharedInstance;
}

//viewController_UIControl_action_target
- (void)lz_analyticsSource:(UIControl *)source action:(SEL)action target:(id)target event:(UIEvent *)event
{
    NSMutableString *identifierString = [[NSMutableString alloc] init];
    
    if([LZViewPathHelper lz_getCurrentViewController:source]){
        [identifierString appendFormat:@"#currentVc_%@",NSStringFromClass([[LZViewPathHelper lz_getCurrentViewController:source] class])];
    }

    [identifierString appendString:[NSString stringWithFormat:@"#%@",[LZViewPathHelper lz_getViewPathIdentifier:source]]];
    
//    [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([target class])]];
//
//    [identifierString appendString:[NSString stringWithFormat:@"#%@#%@[%zd]",NSStringFromClass([source.superview class]),NSStringFromClass([source class]),[source.superview.subviews indexOfObject:source]]];
//
//    [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromSelector(action)]];
    
    if (source.lz_AnalyticsViewProperties) { // 若是有targetid相关
        [[LZUploadCacheHandler sharedHandler] addBehaveInfoWithIdentifier:[source.lz_AnalyticsViewProperties.objectId length] == 0 ? identifierString : source.lz_AnalyticsViewProperties.objectId type:@"onClick" targetId:source.lz_AnalyticsViewProperties.targetId other:source.lz_AnalyticsViewProperties.other];
    }else{
        [[LZUploadCacheHandler sharedHandler] addBehaveInfoWithIdentifier:identifierString type:@"onClick" targetId:@"" other:@""];
    }
}


- (void)lz_analyticsSource:(id)source target:(id)target actionType:(NSString *)actionType forIndexPath:(NSIndexPath *)idxPath{
    NSString *idxPathString = nil;
    UITableViewCell *tableCell = nil;
    UICollectionViewCell *collectionCell = nil;
    if ([source isKindOfClass:[UITableView class]]) {
        tableCell = [(UITableView *)source cellForRowAtIndexPath:idxPath];
        idxPathString = [NSString stringWithFormat:@"%@-%@", @(idxPath.section), @(idxPath.row)];
    }else{
        collectionCell = [(UICollectionView *)source cellForItemAtIndexPath:idxPath];
        idxPathString = [NSString stringWithFormat:@"%@-%@", @(idxPath.section), @(idxPath.row)];
    }
    
    NSMutableString *identifierString = [[NSMutableString alloc] init];
    
    //    [identifierString appendFormat:@"topVc_%@",NSStringFromClass([[LZViewPathHelper lz_getWindowTopViewController] class])];
    
    if (NSStringFromClass([[LZViewPathHelper lz_getCurrentViewController:source] class]).length > 0) {
        [identifierString appendFormat:@"#currentVc_%@",NSStringFromClass([[LZViewPathHelper lz_getCurrentViewController:source] class])];
    }
    
    //    [identifierString appendString:[NSString stringWithFormat:@"#%@",[LZViewPathHelper lz_getViewPathIdentifier:source]]];
    
    if (NSStringFromClass([target class])) {
        [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([target class])]];
    }
    
    
    if (NSStringFromClass([source class])) {
        [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([source class])]];
    }
    
    if (idxPathString) {
        [identifierString appendString:[NSString stringWithFormat:@"#%@",idxPathString]];
    }
    
    if (tableCell) {
        [identifierString appendFormat:@"#%@",NSStringFromClass([tableCell class])];
    }
    
    if (collectionCell) {
        [identifierString appendFormat:@"#%@",NSStringFromClass([collectionCell class])];
    }

    [[LZUploadCacheHandler sharedHandler] addBehaveInfoWithIdentifier:identifierString type:actionType targetId:@"" other:@""];
}




- (void)lz_analyticsAlercctAction:(UIAlertAction *)action{
    NSMutableString *identifierString = [[NSMutableString alloc] init];
    
    [identifierString appendFormat:@"topVc_%@",NSStringFromClass([[LZViewPathHelper lz_getWindowTopViewController] class])];

    if (NSStringFromClass([action class])) {
        [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([action class])]];
    }

    switch (action.style) {
        case UIAlertActionStyleDefault:
            [identifierString appendString:@"#UIAlertActionStyleDefault"];
            break;
        case UIAlertActionStyleCancel:
            [identifierString appendString:@"#UIAlertActionStyleCancel"];
            break;
        case UIAlertActionStyleDestructive:
            [identifierString appendString:@"#UIAlertActionStyleDestructive"];
            break;
        default:
            break;
    }

    if (action.title.length > 0) {
        [identifierString appendString:[NSString stringWithFormat:@"#%@",action.title]];
    }

    [identifierString appendString:[NSString stringWithFormat:@"#AlertActionClick"]];
    
    [[LZUploadCacheHandler sharedHandler] addBehaveInfoWithIdentifier:identifierString type:@"onClick" targetId:@"" other:@""];
}

- (void)lz_analyticsUIGestureAction:(UIGestureRecognizer *)gestureRecgnizer{
    
    // 暂时只处理tapgesture 事件
    if (![gestureRecgnizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return;
    }
    
    NSMutableString *identifierString = [[NSMutableString alloc] init];
    
//    [identifierString appendFormat:@"topVc_%@",NSStringFromClass([[LZViewPathHelper lz_getWindowTopViewController] class])];

    if(NSStringFromClass([[LZViewPathHelper lz_getCurrentViewController:gestureRecgnizer.view] class]).length){
        [identifierString appendFormat:@"#currentVc_%@",NSStringFromClass([[LZViewPathHelper lz_getCurrentViewController:gestureRecgnizer.view]  class])];
    }
    
    if (NSStringFromClass([gestureRecgnizer.view class]).length > 0) {
        [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([gestureRecgnizer.view class])]];
    }
    
    if(NSStringFromClass([gestureRecgnizer.view.superview class]).length){
        [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([gestureRecgnizer.view.superview class])]];
    }
    
    if (NSStringFromClass([gestureRecgnizer.view class]).length > 0) {
        [identifierString appendString:[NSString stringWithFormat:@"#%@[%zd]",NSStringFromClass([gestureRecgnizer.view class]),[gestureRecgnizer.view.superview.subviews indexOfObject:gestureRecgnizer.view]]];
    }
    
    [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([gestureRecgnizer class])]];
    
    if (gestureRecgnizer.view.lz_AnalyticsViewProperties) { // 若是有targetid相关
        [[LZUploadCacheHandler sharedHandler] addBehaveInfoWithIdentifier:[gestureRecgnizer.view.lz_AnalyticsViewProperties.objectId length] == 0 ? identifierString : gestureRecgnizer.view.lz_AnalyticsViewProperties.objectId type:@"onClick" targetId:gestureRecgnizer.view.lz_AnalyticsViewProperties.targetId other:gestureRecgnizer.view.lz_AnalyticsViewProperties.other];
    }else{
        [[LZUploadCacheHandler sharedHandler] addBehaveInfoWithIdentifier:identifierString type:@"onClick" targetId:@"" other:@""];
    }
}


- (void)lz_analyticsViewController:(UIViewController *)vc actionSel:(SEL)selector show:(BOOL)show{
    
    if ([vc isKindOfClass:NSClassFromString(@"UICompatibilityInputViewController")]) { // 键盘控制器
        return;
    }
    
    if ([vc isKindOfClass:NSClassFromString(@"UIRemoteInputViewController")]) { // 键盘控制器
        return;
    }
    
    if ([vc isKindOfClass:NSClassFromString(@"UIInputWindowController")]) { // 键盘控制器
        return;
    }
    
    
    NSMutableString *identifierString = [[NSMutableString alloc] init];
    
//    [identifierString appendFormat:@"topVc_%@",NSStringFromClass([[LZViewPathHelper lz_getWindowTopViewController] class])];
    
    [identifierString appendFormat:@"#currentVc_%@",NSStringFromClass([vc class])];
    
    [identifierString appendFormat:@"#%@",NSStringFromClass([vc class])];
    
    [identifierString appendFormat:@"#%@",NSStringFromSelector(selector)];
//
    [identifierString appendFormat:@"#%@",show ? @"show" : @"dismiss"];
    
    [[LZUploadCacheHandler sharedHandler] addBehaveInfoWithIdentifier:identifierString type:show ? @"onResume" : @"onPause" targetId:vc.lz_AnalyticsViewControllerProperties.targetId.length > 0 ? vc.lz_AnalyticsViewControllerProperties.targetId : @"" other:@""];
}


@end





