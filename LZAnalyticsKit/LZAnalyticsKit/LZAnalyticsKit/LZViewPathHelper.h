//
//  LZViewPathHelper.h
//  Bravo
//
//  Created by LeoZ on 2017/11/9.
//  Copyright © 2017年 SSG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSGBaseRequest.h"


@interface AnalyticsUploadHelperRequest : SSGBaseRequest
@property (nonatomic, copy) NSString *behaveInfo;
@end

@interface LZViewPathHelper : NSObject

/*
 获取指定View的唯一路径标识
*/
+ (NSString *)lz_getViewPathIdentifier:(UIView *)view;

/*
根据view获取current VC
*/
+ (UIViewController *)lz_getCurrentViewController:(id)view;


/**
 获取当前窗口的最前置控制器
 */
+ (UIViewController *)lz_getWindowTopViewController;
@end
