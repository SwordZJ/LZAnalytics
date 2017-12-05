//
//  UIViewController+LZAnalytics.h
//  Bravo
//
//  Created by LeoZ on 2017/11/9.
//  Copyright © 2017年 SSG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+LZAnalytics.h"
@interface UIViewController (LZAnalytics)
//viewID
@property (copy,nonatomic) NSString *lz_AnalyticsViewControllerID;

//AutoTrack 时，是否忽略该 View
@property (nonatomic,assign) BOOL lz_AnalyticsIgnoreViewController;

//AutoTrack 时，View 的扩展属性
@property (strong,nonatomic) AnalyticsUploadData* lz_AnalyticsViewControllerProperties;

@end
