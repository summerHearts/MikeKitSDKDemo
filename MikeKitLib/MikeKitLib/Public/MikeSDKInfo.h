//
//  MikeSDKInfo.h
//  MikeKitLib
//
//  Created by Kenvin on 17/1/13.
//  Copyright © 2017年 上海方创金融信息服务股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/*! SDK版本号，用于展示  SDK 的版本信息 */
#define SDK_VERSION @"1.0.0"

/*! SDK 构建ID 每次构建都会增加 */

#define SDK_BUILD  1000

@interface MikeSDKInfo : NSObject
/**
 *  DocumentDirectory
 *
 *  @return DocumentDirectory目录
 */
+ (NSString *)getDocumentDirectory;

/**
 *  LibraryDirectory
 *
 *  @return LibraryDirectory目录
 */
+ (NSString *)getLibraryDirectory;

/**
 *  CacheDirectory
 *
 *  @return CacheDirectory目录
 */
+ (NSString *)getCacheDirectory;

@end
