//
//  ViewController.m
//  MikeKitSDKDemo
//
//  Created by Kenvin on 17/1/13.
//  Copyright © 2017年 上海方创金融信息服务股份有限公司. All rights reserved.
//

#import "ViewController.h"
#import <MikeKitFramework/MikeSDKInfo.h>
#import <MikeKitFramework/SDKConstants.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", [MikeSDKInfo getDocumentDirectory]);
//    NSLog(@"%@", [MikeSDKInfo getCacheDirectory]);
    NSLog(@"%@", [MikeSDKInfo getLibraryDirectory]);
    
    SMKUserInfo *userInfo = [SMKUserInfo getUseInfoByUser:nil];
    NSLog(@">>>  name is %@",userInfo.name);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
