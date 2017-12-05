//
//  SSGCommonFileUtils.h
//  Bravo
//
//  Created by 小二 on 2017/6/7.
//  Copyright © 2017年 SSG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSGCommonFileUtils : NSObject

/**Some FilePaths
 */
+ (NSString *)documentsDirectory;
+ (NSString *)cachesDirectory;

/**
 *  File Operation
 */

/**
 *  创建文件所在的目录
 *
 *  @param path 文件的绝对路径
 *
 *  @return 是否创建成功
 */
+ (BOOL)createDirForPath:(NSString *)path;

/**
 *  创建目录
 *
 *  @param dirPath 目录绝对路径
 *
 *  @return 是否创建成功
 */
+ (BOOL)createDirWithDirPath:(NSString *)dirPath;

/**
 *  删除文件
 *
 *  @param path 文件所在的绝对路径
 *
 *  @return 是否删除成功
 */
+ (BOOL)deleteFileWithFullPath:(NSString *)path;

/**
 *  指定路径的文件是否存在
 *
 *  @param filePath 文件的绝对路径
 *
 *  @return 是否存在
 */
+ (BOOL)isFileExists:(NSString *)filePath;

/**
 *  文件在当前document路径下是否存在
 *
 *  @param path 全路径为 document 拼接path
 *
 *  @return 存在为yes 不存在为no
 */
+ (BOOL)isFileExistsAtDocumentPath:(NSString *)path;

/**
 *  在文件的末尾追加文本内容
 *
 *  @param content  文本内容
 *  @param filePath 文件绝对路径，比如保证该文件是存在的，返回会返回NO
 *
 *  @return 是否追加成功
 */
+ (BOOL)appendContent:(NSString *)content toFilePath:(NSString *)filePath;


/**FileUtils In UserDefault
 */
+ (BOOL)writeObject:(id)object toUserDefaultWithKey:(NSString*)key;
+ (id)readObjectFromUserDefaultWithKey:(NSString*)key;
+ (BOOL)deleteObjectFromUserDefaultWithKey:(NSString*)key;

/**FileUtils In CachesPath
 */
+ (void)writeObject:(id)object toCachesPath:(NSString*)path;
+ (id)readObjectFromCachesPath:(NSString*)path;
+ (BOOL)deleteFileFromCachesPath:(NSString *)path;

/**FileUtils In DocumentPath
 */
+ (void)writeObject:(id)object toDocumentPath:(NSString *)path;
+ (id)readObjectFromDocumentPath:(NSString *)path;
+ (BOOL)deleteFileFromDocumentPath:(NSString *)path;

//使用写文件的方式保存data
+ (BOOL)writeObjAsFile:(id)obj toDocumentPath:(NSString *)path;

//拷贝文件
+ (BOOL)copyFileFromSourcePath:(NSString *)sourcePath toPath:(NSString *)destPath;

@end
