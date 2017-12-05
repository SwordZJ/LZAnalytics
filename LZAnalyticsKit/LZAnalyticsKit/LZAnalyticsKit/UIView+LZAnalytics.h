//
//  UIView+LZAnalytics.h
//  Bravo
//
//  Created by LeoZ on 2017/11/9.
//  Copyright © 2017年 SSG. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AnalyticsUploadData : NSObject

/* 对象名（唯一id） */
@property (nonatomic, copy) NSString *objectId;

/* 事件类型 */
@property (nonatomic, copy) NSString *type;

/* targetId */
@property (nonatomic, copy) NSString *targetId;

/* 时间 */
@property (nonatomic, copy) NSString *time;

/*
 5.other：
 此字段预留，目前feed流的滑动要传，传递对应的feedType
 */
@property (nonatomic, copy) NSString *other;


- (instancetype)initWithTargetId:(NSString *)targetId;

+ (instancetype)analyticsUploadDataWithTargetId:(NSString *)targetId other:(NSString *)other;

@end



@interface UIView (LZAnalytics)

- (UIViewController *)lz_viewController;

//viewID
@property (copy,nonatomic) NSString *lz_AnalyticsViewID;

//AutoTrack 时，是否忽略该 View
@property (nonatomic,assign) BOOL lz_AnalyticsIgnoreView;

//AutoTrack 时，View 的扩展属性
@property (strong,nonatomic) AnalyticsUploadData* lz_AnalyticsViewProperties;


@end
