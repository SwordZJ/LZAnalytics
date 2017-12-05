//
//  SSGBaseRequest.h
//  Bravo
//
//  Created by LeoZ on 2017/5/3.
//  Copyright © 2017年 SSG. All rights reserved.
//

#import "LZBaseRequestTool.h"

#define kSSGLoginSessionInvalidNoti     @"kSSGLoginSessionInvalidNoti"
#define kSSGLoginSessionIllegalNoti     @"kSSGLoginSessionIllegalNoti"

@interface SSGBaseRequest : LZBaseRequestTool

+ (NSString *)h5BaseUrl;

- (BOOL)isSuccess;


/***
 *  Get 请求
 */
- (NSURLSessionDataTask*)getRequestSuccess:(void (^)(id responseObject))success;
/***
 *  Post 请求
 */
- (NSURLSessionDataTask*)postRequestSuccess:(void (^)(id responseObject))success;

/***
 *  Delete 请求
 */
- (NSURLSessionDataTask*)deleteRequestSuccess:(void (^)(id responseObject))success;

/***
 *  Put 请求
 */
- (NSURLSessionDataTask*)putRequestSuccess:(void (^)(id responseObject))success;

#pragma mark -

- (NSURLSessionDataTask*)getRequestSuccess:(void (^)(id responseObject))success fail:(void (^)(id responseObject))fail networkFail:(void(^)(void))networkFail;

- (NSURLSessionDataTask*)postRequestSuccess:(void (^)(id responseObject))success fail:(void (^)(id responseObject))fail networkFail:(void(^)(void))networkFail;

- (NSURLSessionDataTask*)deleteRequestSuccess:(void (^)(id responseObject))success fail:(void (^)(id responseObject))fail networkFail:(void(^)(void))networkFail;

- (NSURLSessionDataTask*)putRequestSuccess:(void (^)(id responseObject))success fail:(void (^)(id responseObject))fail networkFail:(void(^)(void))networkFail;

@end
