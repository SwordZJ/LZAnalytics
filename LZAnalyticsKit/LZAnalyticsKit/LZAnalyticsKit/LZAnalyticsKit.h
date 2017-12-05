//
//  LZAnalyticsKit.h
//  Bravo
//
//  Created by LeoZ on 2017/11/7.
//  Copyright © 2017年 SSG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZAnalyticsAOP : NSObject
@property (weak, nonatomic) id delegate;
@property (copy, nonatomic) void (^analyticsIdentifierBlock)(NSString *identifier);

+ (instancetype)sharedInstance;

//viewController_UIControl_action_target
- (void)lz_analyticsSource:(UIControl *)source action:(SEL)action target:(id)target event:(UIEvent *)event;

// tableView or collectionView select action
- (void)lz_analyticsSource:(id)source target:(id)target actionType:(NSString *)actionType forIndexPath:(NSIndexPath *)idxPath;

// alert
- (void)lz_analyticsAlercctAction:(UIAlertAction *)action;

// gesture
- (void)lz_analyticsUIGestureAction:(UIGestureRecognizer *)gestureRecgnizer;

// vc
- (void)lz_analyticsViewController:(UIViewController *)vc actionSel:(SEL)selector show:(BOOL)show;

@end




