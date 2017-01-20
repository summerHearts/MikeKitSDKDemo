//
//  SMKUserInfo.h
//  MikeKitLib
//
//  Created by Kenvin on 17/1/20.
//  Copyright © 2017年 上海方创金融信息服务股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMKUser.h"
@interface SMKUserInfo : NSObject

@property (nonatomic,copy) NSString *name;

+(SMKUserInfo *)getUseInfoByUser:(SMKUser *)user;

@end
