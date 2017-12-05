//
//  LZBaseRequestTool.h
//  LZAPPFoundationBaseProject
//
//  Created by LeoZ on 2017/4/19.
//  Copyright © 2017年 LeoZ. All rights reserved.
//  请求基类

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^DownloadSuccessBlock)(NSURL *fileUrl) ;
typedef void (^DownloadProgressBlock)(NSProgress *downloadProgress);

@interface LZBaseRequestTool : NSObject
/*** 业务模块地址 */
@property (nonatomic, strong) NSString *pathURI;

/*** 具体业务参数 */
@property (nonatomic, strong) NSDictionary *uniqueQueryParams;

// result
/**
 result : 0 代表请求成功
 -1 : 未登录状态
 >0 : 错误消息提示
 
 */
@property (nonatomic, assign) NSInteger result;     ///< result code
@property (nonatomic, copy) NSString *msg;          ///< error message
@property (nonatomic, strong) id<NSObject> data;    ///< data


// 错误码特殊处理 留给工程集成类 含本项目业务处理
- (void)handleErrorCode:(NSInteger)resultCode;



/***
 基础服务器地址
 */
+ (NSString *)baseURL;

/***
 基础共用请求参数 (此处可以带登录态 若是使用cookie 可忽略此方法)
 */
+ (NSDictionary *)commenQueryParams;



/***
 指定DATA返回的类型
 */

// 服务器返回的是键值对 实现以下方法 并且覆盖父类data实现
+ (Class)modelClassUsing_mtl_JSONDictionaryTransformerForDATA;

// 服务器返回的是数组  实现以下方法 指定数组内的model class
+ (Class)modelClassUsing_mtl_JSONArrayTransformerForDATA;

/***
 *  子类共用 manager
 *  可在此对manager进行设置
 *  @return shared manager of all sub requestclasses
 */
+ (AFHTTPSessionManager*)sharedManager;

/***
 *  Get 请求
 */
- (NSURLSessionDataTask*)getRequestSuccess:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure;
/***
 *  Post 请求
 */
- (NSURLSessionDataTask*)postRequestSuccess:(void (^)(id responseObject))success
                                    failure:(void (^)(NSError *error))failure;

/***
 *  Delete 请求
 */
- (NSURLSessionDataTask*)deleteRequestSuccess:(void (^)(id responseObject))success
                                    failure:(void (^)(NSError *error))failure;


/***
 *  PUT 请求
 */
- (NSURLSessionDataTask*)putRequestSuccess:(void (^)(id responseObject))success
                                      failure:(void (^)(NSError *error))failure;


/***
 *  图片和视频上传请求
 */
/***
 上传单图
 
 @param imageData 图片
 @param url 上传地址
 @param serverType 服务器上传字段对应字符串
 @param successBlock 上传成功后的回调
 @param failureBlock 上传失败的回调
 */
+ (void)uploadWithImageData:(NSData *)imageData
                  uploadUrl:(NSString *)url
                 serverType:(NSString *)serverType
                     params:(NSDictionary *)param
               successBlock:(void(^)(id responseObject))successBlock
                    failure:(void(^)(NSError *error))failureBlock;

/***
 上传多图
 
 @param imageArray 图片数组
 @param url 上传地址
 @param params 参数
 @param fileName 文件名称
 @param successBlock 上传成功后的回调
 @param failureBlock 上传失败的回调
 #param progressBlock 进度
 */
+ (void)uploadWithImageDataArray:(NSArray *)imageArray
                       uploadUrl:(NSString *)url
                          params:(NSDictionary *)params
                        serverType:(NSString *)serverType
                    successBlock:(void(^)(id responseObject))successBlock
                         failure:(void(^)(NSError *error))failureBlock
                   progressBlock:(void(^)(int64_t bytesProgress,int64_t totalBytesProgress))progress;

//+ (void)uploadFileWithFilePath:(NSURL *)filePathURL
//                      uploadURL:(NSString *)url
//                         params:(NSDictionary *)param
//                     serverType:(NSString *)serverType
//                   successBlock:(void(^)(id responseObject))successBlock
//                        failure:(void(^)(NSError*))failureBlock;
//
//+ (void)uploadVideoWithFilePath:(NSURL *)filePathURL
//                 uploadFilePath:(NSString *)uploadFilePath
//                   successBlock:(void (^)(id))successBlock
//                        failure:(void (^)(NSError *))failureBlock;
//
//+ (void)downloadMyPlaceVideo:(NSString *)path
//                    progress:(DownloadProgressBlock)downloadProgressBlock
//                    complete:(DownloadSuccessBlock)complete;
//
//+ (void)downloadVoice:(NSString *)path
//             progress:(DownloadProgressBlock)downloadProgressBlock
//             complete:(DownloadSuccessBlock)complete;

@end
