//
//  NSObject+LZKit.h
//  LZAnalyticsKit
//
//  Created by LeoZ on 2017/12/5.
//  Copyright © 2017年 LZAnalytics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (LZKit)

@end


@interface NSString (LZKit)
- (NSString *) MD5Hash;
+ (NSString *)strUTF8Encoding:(NSString *)str;
@end

@interface UIImage (LZKit)
+ (UIImage *)getThumbnailImageFromVideo:(NSURL *)movieURL atTime:(NSTimeInterval)time isMiddle:(BOOL)isMiddle;
- (UIImage *)imageScaledToSize:(CGSize)newSize;
@end
