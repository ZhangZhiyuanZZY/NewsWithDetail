//
//  ZYHTTPManager.m
//  详情页面
//
//  Created by 章芝源 on 15/11/19.
//  Copyright © 2015年 ZZY. All rights reserved.
//

#import "ZYHTTPManager.h"

@implementation ZYHTTPManager

///重写manager方法添加, json解析支持的格式
+ (instancetype)manager
{
    ZYHTTPManager *manager = [super manager];
    
    NSMutableSet *nsSet = [NSMutableSet set];
    
    nsSet.set = manager.responseSerializer.acceptableContentTypes;
    
    [nsSet addObject:@"text/html"];
    
    manager.responseSerializer.acceptableContentTypes = nsSet;
    
    return  manager;
    
}



@end
