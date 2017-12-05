//
//  SSGBaseRequest.m
//  Bravo
//
//  Created by LeoZ on 2017/5/3.
//  Copyright © 2017年 SSG. All rights reserved.
//

#import "SSGBaseRequest.h"


#define kSSGBaseRequestTestURL @""
#define kSSGBaseRequestURL     @""

#define kSSGH5BaseRequestTestURL     @""
#define kSSGH5BaseRequestURL         @""




@implementation SSGBaseRequest

+ (NSString *)h5BaseUrl
{
#ifndef __OPTIMIZE__
    return kSSGH5BaseRequestTestURL;  // 测试环境
#else
    return kSSGH5BaseRequestURL; // 正式环境
#endif

}

+ (NSString *)baseURL{
#ifndef __OPTIMIZE__
    return kSSGBaseRequestTestURL;  // 测试环境
#else
    return kSSGBaseRequestURL; // 正式环境
#endif
}

- (BOOL)isSuccess{
    return self.result == 0;
}


/***
 统一处理errorcode的逻辑

 @param resultCode 返回的是0的时候 表示请求成功 数据返回正常
                   返回的是>0的时候，表示服务器请求有误 ，此时处理errormsg
                   返回的是-1的时候，表示登录状态失效，需要处理重新登录的情况
                   返回的是-2的时候，表示违规账号被强制踢下线
 */
- (void)handleErrorCode:(NSInteger)resultCode{
    if (resultCode == 0) {
        
    }else if (resultCode > 0){
        
    }else if (resultCode == -1){ // 失效
        [[NSNotificationCenter defaultCenter] postNotificationName:kSSGLoginSessionInvalidNoti object:nil];
    }else if (resultCode == -2){ // 违规
        [[NSNotificationCenter defaultCenter] postNotificationName:kSSGLoginSessionIllegalNoti object:nil];
    }
}


/***
 *  Get 请求
 */
- (NSURLSessionDataTask*)getRequestSuccess:(void (^)(id responseObject))success{
    return [self getRequestSuccess:^(id responseString) {
        if (self.isSuccess) {
            if (success) {
                success(responseString);
            }
        }else{
//            [DemonAlertHelper showAlertWithTitle:@"" content:self.msg dissmissDuration:1.2 type:AlertViewTypeNone];
        }
    } failure:^(NSError *error) {
//        [DemonAlertHelper showAlertWithTitle:@"" content:@"网络开小差了~" dissmissDuration:1.2 type:AlertViewTypeNone];
    }];
}

/***
 *  Post 请求
 */
- (NSURLSessionDataTask*)postRequestSuccess:(void (^)(id responseObject))success{
    return [self postRequestSuccess:^(id responseString) {
        if (self.isSuccess) {
            if (success) {
                success(responseString);
            }
        }else{
//            [DemonAlertHelper showAlertWithTitle:@"" content:self.msg dissmissDuration:1.2 type:AlertViewTypeNone];
        }
    } failure:^(NSError *error) {
//        [DemonAlertHelper showAlertWithTitle:@"" content:@"网络开小差了~" dissmissDuration:1.2 type:AlertViewTypeNone];
    }];
}

/***
 *  Delete 请求
 */
- (NSURLSessionDataTask*)deleteRequestSuccess:(void (^)(id responseObject))success{
    return [self deleteRequestSuccess:^(id responseString) {
        if (self.isSuccess) {
            if (success) {
                success(responseString);
            }
        }else{
//            [DemonAlertHelper showAlertWithTitle:@"" content:self.msg dissmissDuration:1.2 type:AlertViewTypeNone];
            
        }
    } failure:^(NSError *error) {
//        [DemonAlertHelper showAlertWithTitle:@"" content:@"网络开小差了~" dissmissDuration:1.2 type:AlertViewTypeNone];
    }];
}



/***
 *  Put 请求
 */
- (NSURLSessionDataTask*)putRequestSuccess:(void (^)(id responseObject))success{
    return [self putRequestSuccess:^(id responseString) {
        if (self.isSuccess) {
            if (success) {
                success(responseString);
            }
        }else{
//            [DemonAlertHelper showAlertWithTitle:@"" content:self.msg dissmissDuration:1.2 type:AlertViewTypeNone];
        }
    } failure:^(NSError *error) {
//        [DemonAlertHelper showAlertWithTitle:@"" content:@"网络开小差了~" dissmissDuration:1.2 type:AlertViewTypeNone];
        
    }];
}

#pragma mark - 

- (NSURLSessionDataTask*)getRequestSuccess:(void (^)(id responseObject))success fail:(void (^)(id responseObject))fail networkFail:(void(^)(void))networkFail{
    return [self getRequestSuccess:^(id responseString) {
        if (self.isSuccess) {
            if (success) {
                success(responseString);
            }
        }else{
            if (fail) {
                fail(responseString);
            }
        }
    } failure:^(NSError *error) {
        if (networkFail) {
            networkFail();
        }
    }];
}

- (NSURLSessionDataTask*)postRequestSuccess:(void (^)(id responseObject))success fail:(void (^)(id responseObject))fail networkFail:(void(^)(void))networkFail{
    return [self postRequestSuccess:^(id responseString) {
        if (self.isSuccess) {
            if (success) {
                success(responseString);
            }
        }else{
            if (fail) {
                fail(responseString);
            }
        }
    } failure:^(NSError *error) {
        if (networkFail) {
            networkFail();
        }
    }];
}

- (NSURLSessionDataTask*)deleteRequestSuccess:(void (^)(id responseObject))success fail:(void (^)(id responseObject))fail networkFail:(void(^)(void))networkFail{
    return [self deleteRequestSuccess:^(id responseString) {
        if (self.isSuccess) {
            if (success) {
                success(responseString);
            }
        }else{
            if (fail) {
                fail(responseString);
            }
        }
    } failure:^(NSError *error) {
        if (networkFail) {
            networkFail();
        }
    }];
}

- (NSURLSessionDataTask*)putRequestSuccess:(void (^)(id responseObject))success fail:(void (^)(id responseObject))fail networkFail:(void(^)(void))networkFail{
    return [self putRequestSuccess:^(id responseString) {
        if (self.isSuccess) {
            if (success) {
                success(responseString);
            }
        }else{
            if (fail) {
                fail(responseString);
            }
        }
    } failure:^(NSError *error) {
        if (networkFail) {
            networkFail();
        }
    }];
}


@end
