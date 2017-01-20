//
//  SMKUserInfo.m
//  MikeKitLib
//
//  Created by Kenvin on 17/1/20.
//  Copyright © 2017年 上海方创金融信息服务股份有限公司. All rights reserved.
//

#import "SMKUserInfo.h"

@implementation SMKUserInfo

+(SMKUserInfo *)getUseInfoByUser:(SMKUser *)user{
    SMKUserInfo *userInfo = [[SMKUserInfo alloc]init];
    userInfo.name = @"佐毅";
    return userInfo;
}

@end
