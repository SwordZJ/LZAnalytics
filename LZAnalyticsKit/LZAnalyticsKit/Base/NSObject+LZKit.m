//
//  NSObject+LZKit.m
//  LZAnalyticsKit
//
//  Created by LeoZ on 2017/12/5.
//  Copyright © 2017年 LZAnalytics. All rights reserved.
//

#import "NSObject+LZKit.h"
#import "SSGCommonFileUtils.h"
#import <AVFoundation/AVFoundation.h>
#import <CommonCrypto/CommonDigest.h>

@implementation NSObject (LZKit)

@end


@implementation NSString (LZKit)

+ (NSString *)strUTF8Encoding:(NSString *)str
{
    /**! ios9适配的话 打开第一个 */
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 9.0)
    {
        return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    }
    else
    {
        return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
}
- (NSString *) MD5Hash {
    
    CC_MD5_CTX md5;
    CC_MD5_Init (&md5);
    CC_MD5_Update (&md5, [self UTF8String], (CC_LONG)[self length]);
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final (digest, &md5);
    NSString *s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0],  digest[1],
                   digest[2],  digest[3],
                   digest[4],  digest[5],
                   digest[6],  digest[7],
                   digest[8],  digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    
    return s;
    
}


@end


@implementation UIImage (LZKit)
+ (UIImage *)getThumbnailImageFromVideo:(NSURL *)movieURL atTime:(NSTimeInterval)time isMiddle:(BOOL)isMiddle {
    AVURLAsset *asset;
    if (movieURL && [SSGCommonFileUtils isFileExists:[movieURL path]]) {
        asset = [[AVURLAsset alloc] initWithURL:movieURL options:nil] ;
    }
    else {
        return nil;
    }
    
    AVAssetImageGenerator *assetImageGenerator         = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode                   = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef                       = NULL;
    NSError *thumbnailImageGenerationError             = nil;
    
    CMTime movieDuration                               = asset.duration;
    
    if (isMiddle){
        float middleSecond                             = CMTimeGetSeconds(movieDuration) / 2.f;
        thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMakeWithSeconds(middleSecond, 30) actualTime:NULL error:&thumbnailImageGenerationError];
    }
    else{
        CGFloat movieLength = CMTimeGetSeconds(movieDuration);
        if (time > movieLength) {
            time = movieLength;
        }
        thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(time, 30) actualTime:NULL error:&thumbnailImageGenerationError];
    }
    
    if (!thumbnailImageRef){
    }
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    
    return thumbnailImage;
}

- (UIImage *)imageScaledToSize:(CGSize)newSize {
    
    CGSize actSize = self.size;
    float scale = actSize.width/actSize.height;
    
    if (scale < 1) {
        newSize.height = newSize.width/scale;
    } else {
        newSize.width = newSize.height*scale;
    }
    
    
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end

