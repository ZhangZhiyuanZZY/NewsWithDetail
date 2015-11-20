//
//  ZYNewsDetail.m
//  详情页面
//
//  Created by 章芝源 on 15/11/20.
//  Copyright © 2015年 ZZY. All rights reserved.
//

#import "ZYNewsDetail.h"
#import "ZYNewsDetailling.h"
@implementation ZYNewsDetail
// 实现
+ (NSDictionary *)objectClassInArray
{
    return @{@"img" : [ZYNewsDetailling class]};
}
@end
