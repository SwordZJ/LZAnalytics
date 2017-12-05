//
//  LZBaseRequestTool.m
//  LZAPPFoundationBaseProject
//
//  Created by LeoZ on 2017/4/19.
//  Copyright © 2017年 LeoZ. All rights reserved.
//

#import "LZBaseRequestTool.h"
#import <MJExtension/MJExtension.h>
#import "NSObject+LZKit.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

// 请求失败超时时间
static const NSTimeInterval kLZBaseRequestTimeoutInterval = 10;

static NSInteger kLZBaseRequestRertyCount = 3;


@implementation LZBaseRequestTool

- (void)handleErrorCode:(NSInteger)resultCode{

}


+ (NSString *)baseURL{
    return nil;
}

+ (NSDictionary *)commenQueryParams{
    return nil;
}

+ (Class)modelClassUsing_mtl_JSONDictionaryTransformerForDATA {
    return nil;
}

+ (Class)modelClassUsing_mtl_JSONArrayTransformerForDATA{
    return nil;
}

+ (Class)dataClass{
    Class cls = [self.class modelClassUsing_mtl_JSONDictionaryTransformerForDATA];
    if (cls != nil) {
        return cls;
    }
    
    cls = [self.class modelClassUsing_mtl_JSONArrayTransformerForDATA];
    if (cls != nil) {
        return cls;
    }
    
    return nil;
}

+ (AFHTTPSessionManager*)sharedManager {
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:self.class.baseURL]];
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy.validatesDomainName = NO;
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"accept"];
        [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"APP-TYPE"];
        [manager.requestSerializer setValue:@"V3" forHTTPHeaderField:@"API-VERSION"];
        [manager.requestSerializer setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"] forHTTPHeaderField:@"APP-VERSION"];
        manager.requestSerializer.timeoutInterval = kLZBaseRequestTimeoutInterval;
        manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",@"multipart/form-data", nil];
        
    });
    return manager;
}

- (NSURLSessionDataTask *)getRequestSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    AFHTTPSessionManager *manager = self.class.sharedManager;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:self.class.commenQueryParams];
    [params addEntriesFromDictionary:self.uniqueQueryParams];
    NSURLSessionDataTask *task = [self getRequestWithManager:manager parameters:params Success:success failure:failure tryingOut:1];
    return task;
}

- (NSURLSessionDataTask*)getRequestWithManager:(AFHTTPSessionManager*)manager parameters:(NSDictionary*)dictionary Success:(void (^)(id responseObject))success failure:(void (^)(NSError *))failure tryingOut:(NSInteger)tryout {
    
    NSURLSessionDataTask *taskData = [manager GET:self.pathURI parameters:dictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#ifndef __OPTIMIZE__
        __block NSMutableArray *urlArray = [NSMutableArray array];
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [urlArray addObject:[NSString stringWithFormat:@"%@=%@",key,obj]];
        }];
        NSString *url = [urlArray componentsJoinedByString:@"&"];
        __unused NSString *wholeURL = [NSString stringWithFormat:@"%@%@?%@",self.class.baseURL, self.pathURI,url];
        if (urlArray.count > 0) {
           // NSLog(@"requestWholeURL:%@%@?%@",self.class.baseURL, self.pathURI,url);
        }
#endif
        [self onRequestSuccess:task response:responseObject withCallbackSuccess:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (tryout <= kLZBaseRequestRertyCount) {
            [self getRequestWithManager:manager parameters:dictionary Success:success failure:failure tryingOut:tryout+1];
            return;
        }
        failure(error);
        
#ifndef __OPTIMIZE__
        __block NSMutableArray *urlArray = [NSMutableArray array];
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [urlArray addObject:[NSString stringWithFormat:@"%@=%@",key,obj]];
        }];
        NSString *url = [urlArray componentsJoinedByString:@"&"];
        if (urlArray.count > 0) {
          //  NSLog(@"requestWholeURL:%@%@?%@",self.class.baseURL, self.pathURI,url);
        }
        //        NSLog(@"requestURI:%@%@", self.class.baseURL, self.pathURI);
        //        NSLog(@"requestParams:%@", dictionary);
        NSLog(@"errorMessage:%@", error);
#endif
    }];
    return taskData;
}

- (void)onRequestSuccess:(NSURLSessionDataTask*)task response:(id) responseObject withCallbackSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *))failure{
    NSError *error = nil;
    if (responseObject) {
        LZBaseRequestTool *request = nil;
        request = [self.class mj_objectWithKeyValues:responseObject];
        if (request) {
            self.result = request.result;
            self.msg = request.msg;
            if ([request.data isKindOfClass:[NSArray class]]) {
                self.data = [[self.class dataClass] mj_objectArrayWithKeyValuesArray:(NSArray *)request.data];
            }else if([request.data isKindOfClass:[NSDictionary class]]){
                self.data = [[self.class dataClass] mj_objectWithKeyValues:request.data];
            }else{
                self.data = request.data;
            }
            // 此处需要处理异常抛出的情况
            [self handleErrorCode:request.result];
            
           // NSLog(@"responseObject:%@", [responseObject mj_JSONObject]);
            
            success([responseObject mj_JSONObject]);
            return;
        }
    }
    else {
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString(@"JSON解析失败", @""),
                                   NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:NSLocalizedString(@"%@ %@:解析结果为空", @""), NSStringFromClass(self.class), self.pathURI]
                                   };
        error = [NSError errorWithDomain:@"LZBaseRequestParseErrorDomain" code:1 userInfo:userInfo];
        failure(error);
    }

}

- (NSURLSessionDataTask *)postRequestSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *))failure{
    AFHTTPSessionManager *manager = self.class.sharedManager;
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary addEntriesFromDictionary:[self.class commenQueryParams]];
    [dictionary addEntriesFromDictionary:self.uniqueQueryParams];
    NSURLSessionDataTask *taskData = [self postRequestWithManager:manager parameters:dictionary Success:success failure:failure tryingOut:1];
    return taskData;
}



- (NSURLSessionDataTask*)postRequestWithManager:(AFHTTPSessionManager*)manager parameters:(NSDictionary*)dictionary Success:(void (^)(id responseObject))success failure:(void (^)(NSError *))failure tryingOut:(NSInteger)tryout {
    NSURLSessionDataTask *taskData = [manager POST:self.pathURI parameters:dictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#ifndef __OPTIMIZE__
        __block NSMutableArray *urlArray = [NSMutableArray array];
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [urlArray addObject:[NSString stringWithFormat:@"%@=%@",key,obj]];
        }];
        NSString *url = [urlArray componentsJoinedByString:@"&"];
        NSString *wholeUrl = [NSString stringWithFormat:@"%@%@?%@",self.class.baseURL, self.pathURI,url];
        if (urlArray.count > 0) {
          //  NSLog(@"requestWholeURL:%@",wholeUrl);
        }
       // NSLog(@"responseObject:%@", responseObject);
#endif
        [self onRequestSuccess:task response:responseObject withCallbackSuccess:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (tryout < kLZBaseRequestRertyCount) {
            [self postRequestWithManager:manager parameters:dictionary Success:success failure:failure tryingOut:tryout+1];
            return;
        }
        if (failure) {
            failure(error);
        }
    }];
    return taskData;
}

/***
 *  Delete 请求
 */
- (NSURLSessionDataTask*)deleteRequestSuccess:(void (^)(id responseObject))success
                                      failure:(void (^)(NSError *error))failure{

    AFHTTPSessionManager *manager = self.class.sharedManager;
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary addEntriesFromDictionary:[self.class commenQueryParams]];
    [dictionary addEntriesFromDictionary:self.uniqueQueryParams];
    NSURLSessionDataTask *taskData = [self deleteRequestWithManager:manager parameters:dictionary Success:success failure:failure tryingOut:1];
    return taskData;
}


- (NSURLSessionDataTask*)deleteRequestWithManager:(AFHTTPSessionManager*)manager parameters:(NSDictionary*)dictionary Success:(void (^)(id responseObject))success failure:(void (^)(NSError *))failure tryingOut:(NSInteger)tryout {
    NSURLSessionDataTask *taskData = [manager DELETE:self.pathURI parameters:dictionary success:^(NSURLSessionDataTask *task, id responseObject) {
#ifndef __OPTIMIZE__
        __block NSMutableArray *urlArray = [NSMutableArray array];
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [urlArray addObject:[NSString stringWithFormat:@"%@=%@",key,obj]];
        }];
        NSString *url = [urlArray componentsJoinedByString:@"&"];
        if (urlArray.count > 0) {
          //  NSLog(@"requestWholeURL:%@%@?%@",self.class.baseURL, self.pathURI,url);
        }
       // NSLog(@"responseObject:%@", responseObject);
#endif
        [self onRequestSuccess:task response:responseObject withCallbackSuccess:success failure:failure];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (tryout < kLZBaseRequestRertyCount) {
            [self deleteRequestWithManager:manager parameters:dictionary Success:success failure:failure tryingOut:tryout+1];
            return;
        }
        failure(error);
    }];
    return taskData;
}


/***
 *  PUT 请求
 */
- (NSURLSessionDataTask*)putRequestSuccess:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure{
    AFHTTPSessionManager *manager = self.class.sharedManager;
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary addEntriesFromDictionary:[self.class commenQueryParams]];
    [dictionary addEntriesFromDictionary:self.uniqueQueryParams];
    NSURLSessionDataTask *taskData = [self putRequestWithManager:manager parameters:dictionary Success:success failure:failure tryingOut:1];
    return taskData;
}


- (NSURLSessionDataTask*)putRequestWithManager:(AFHTTPSessionManager*)manager parameters:(NSDictionary*)dictionary Success:(void (^)(id responseObject))success failure:(void (^)(NSError *))failure tryingOut:(NSInteger)tryout {
    NSURLSessionDataTask *taskData = [manager PUT:self.pathURI parameters:dictionary success:^(NSURLSessionDataTask *task, id responseObject) {
#ifndef __OPTIMIZE__
        __block NSMutableArray *urlArray = [NSMutableArray array];
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [urlArray addObject:[NSString stringWithFormat:@"%@=%@",key,obj]];
        }];
        NSString *url = [urlArray componentsJoinedByString:@"&"];
        if (urlArray.count > 0) {
          //  NSLog(@"requestWholeURL:%@%@?%@",self.class.baseURL, self.pathURI,url);
        }
      //  NSLog(@"responseObject:%@", responseObject);
#endif
        [self onRequestSuccess:task response:responseObject withCallbackSuccess:success failure:failure];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (tryout < kLZBaseRequestRertyCount) {
            [self putRequestWithManager:manager parameters:dictionary Success:success failure:failure tryingOut:tryout+1];
            return;
        }
        failure(error);
    }];
    return taskData;
}


#pragma mark - UploadImage

+ (void)uploadWithImageData:(NSData *)imageData
                  uploadUrl:(NSString *)url
                 serverType:(NSString *)serverType
                     params:(NSDictionary *)param
               successBlock:(void(^)(id responseObject))successBlock
                    failure:(void(^)(NSError *error))failureBlock{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    //创建请求
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"accept"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",@"multipart/form-data", nil];
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:serverType fileName:fileName mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}


+ (void)uploadWithImageDataArray:(NSArray *)imageArray
                       uploadUrl:(NSString *)url
                          params:(NSDictionary *)params
                      serverType:(NSString *)serverType
                    successBlock:(void (^)(id))successBlock
                         failure:(void (^)(NSError *))failureBlock
                   progressBlock:(void (^)(int64_t, int64_t))progress{
    
    if (url == nil)
    {
        return;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@", str];
    
    /**! 检查地址中是否有中文 */
    NSString *URLString = [NSURL URLWithString:url] ? url : [NSString strUTF8Encoding:url];
    
    [self.class.sharedManager POST:URLString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            /**! image的压缩方法 */
            UIImage *resizedImage;
            /**! 此处是使用原生系统相册 */
            if([obj isKindOfClass:[ALAsset class]])
            {
                // 用ALAsset获取Asset URL  转化为image
                ALAssetRepresentation *assetRep = [obj defaultRepresentation];
                
                CGImageRef imgRef = [assetRep fullResolutionImage];
                resizedImage = [UIImage imageWithCGImage:imgRef
                                                   scale:1.0
                                             orientation:(UIImageOrientation)assetRep.orientation];
                
                NSLog(@"1111-----size : %@",NSStringFromCGSize(resizedImage.size));
                resizedImage = [resizedImage imageScaledToSize:resizedImage.size];
                NSLog(@"2222-----size : %@",NSStringFromCGSize(resizedImage.size));
            }
            else
            {
                /**! 此处是使用其他第三方相册，可以自由定制压缩方法 */
                resizedImage = obj;
            }
            
            /**! 此处压缩方法是jpeg格式是原图大小的0.8倍，要调整大小的话，就在这里调整就行了还是原图等比压缩 */
            NSData *imgData = UIImageJPEGRepresentation(resizedImage, 0.8);
            
            /**! 拼接data */
            if (imgData != nil)
            {
                
                [formData appendPartWithFileData:imgData
                                            name: serverType
                                        fileName:[NSString stringWithFormat:@"%@%ld.jpg",fileName,(long)idx]
                                        mimeType:@"image/jpeg"];
                
            }
            
        }];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传图片成功 = %@",responseObject);
        if (successBlock)
        {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock)
        {
            failureBlock(error);
        }
    }];
}

#pragma mark - UploadVideo

+ (void)uploadVideoWithFilePath:(NSURL *)filePathURL
                    uploadFilePath:(NSString *)uploadFilePath
                      successBlock:(void (^)(id))successBlock
                        failure:(void (^)(NSError *))failureBlock{
    [self compressVideo:filePathURL success:^(NSString *outfilePath) {
        UIImage *image = [UIImage getThumbnailImageFromVideo:[NSURL fileURLWithPath:outfilePath] atTime:1.f isMiddle:YES];
        [self uploadWithImageDataArray:@[image] uploadUrl:uploadFilePath params:nil serverType:@"files" successBlock:^(id responseObject) {
            NSString *imageOnlinePath = responseObject[@"data"];
            [self uploadFileWithFilePath:[NSURL fileURLWithPath:outfilePath] uploadURL:uploadFilePath params:nil serverType:@"files" successBlock:^(id responseObject) {
                NSString *videoOnlinePath = responseObject[@"data"];
                NSDictionary *dataDictionary = @{@"imageOnlinePath":imageOnlinePath,@"videoOnlinePath":videoOnlinePath};
                successBlock(dataDictionary);
            } failure:failureBlock];
        } failure:failureBlock progressBlock:nil];
    }];
}


+ (void)uploadFileWithFilePath:(NSURL *)filePathURL
                      uploadURL:(NSString *)url
                         params:(NSDictionary *)param
                     serverType:(NSString *)serverType
                   successBlock:(void(^)(id responseObject))successBlock
                        failure:(void(^)(NSError*))failureBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",@"multipart/form-data", nil];
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileURL:filePathURL name:serverType fileName:filePathURL.absoluteString mimeType:@"application/octet-stream" error:nil];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}


+ (void)uploadVideoWithFilePath:(NSString *)filePath
                     videoCover:(NSString *)videoCover
                      uploadURL:(NSString *)url
                         params:(NSDictionary *)param
                     serverType:(NSString *)serverType
                   successBlock:(void (^)(id))successBlock
                        failure:(void (^)(NSError *))failureBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"accept"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",@"multipart/form-data", nil];
    NSMutableDictionary *newParam;
    if (param) {
        newParam = [NSMutableDictionary dictionaryWithDictionary:param];
    }else{
        newParam = [NSMutableDictionary dictionary];
    }
    [newParam setObject:videoCover forKey:@"videoCover"];
    [manager POST:url parameters:newParam constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSURL *filePathURL2 = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@", filePath]];
        [formData appendPartWithFileURL:filePathURL2 name:serverType fileName:filePath mimeType:@"application/octet-stream" error:nil];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

+ (void)compressVideo:(NSURL *)filePathURL success:(void(^)(NSString *outfilePath))success{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:filePathURL  options:nil];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    NSString *videoWritePath = [NSString stringWithFormat:@"output-%@.mp4",[formatter stringFromDate:[NSDate date]]];
    NSString *foldPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/MyPlaceCompressVideo"];
    BOOL isFoldExist;
    if (![[NSFileManager defaultManager] fileExistsAtPath:foldPath isDirectory:&isFoldExist]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:foldPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    NSString *outfilePath = [foldPath stringByAppendingFormat:@"/%@", videoWritePath];
    
    AVAssetExportSession *avAssetExport = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    
    avAssetExport.outputURL = [NSURL fileURLWithPath:outfilePath];
    avAssetExport.outputFileType =  AVFileTypeMPEG4;
    [avAssetExport exportAsynchronouslyWithCompletionHandler:^{
        if ([avAssetExport status] == AVAssetExportSessionStatusCompleted) {
            success(outfilePath);
        }else{
            NSLog(@"转码失败");
        }
    }];
}

#pragma mark - Download

+ (void)downloadMyPlaceVideo:(NSString *)path progress:(DownloadProgressBlock)downloadProgressBlock complete:(DownloadSuccessBlock)complete{
    [self downloadFile:path suffix:@".mp4" foldPath:@"DownloadVideo" progress:downloadProgressBlock complete:complete];
}

+ (void)downloadVoice:(NSString *)path progress:(DownloadProgressBlock)downloadProgressBlock complete:(DownloadSuccessBlock)complete{
    [self downloadFile:path suffix:@".caf" foldPath:@"DownloadVoice" progress:downloadProgressBlock complete:complete];
}

+ (void)downloadFile:(NSString *)path suffix:(NSString *)suffix foldPath:(NSString *)foldPath progress:(DownloadProgressBlock)downloadProgressBlock complete:(DownloadSuccessBlock)complete{
    NSString *fileName = [NSString stringWithFormat:@"%@%@",[path MD5Hash],suffix];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *foldTotalPath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,foldPath];
     BOOL isDir;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if (![fileManager fileExistsAtPath:foldTotalPath isDirectory:&isDir]) {
        [fileManager createDirectoryAtPath:foldTotalPath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    NSString *totalPath = [NSString stringWithFormat:@"%@/%@",foldTotalPath,fileName];
    [self downloadFile:path savePath:totalPath progress:downloadProgressBlock complete:complete];
}

+ (void)downloadFile:(NSString *)path savePath:(NSString *)savePath progress:(DownloadProgressBlock)downloadProgressBlock complete:(DownloadSuccessBlock)complete{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (downloadProgressBlock) {
            downloadProgressBlock(downloadProgress);
        }
        NSLog(@"%f",downloadProgress.completedUnitCount * 1.f * 100/ downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:savePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            
        }else{
            complete(filePath);
        }
    }];
    
    //开始启动任务
    [task resume];
}

@end
