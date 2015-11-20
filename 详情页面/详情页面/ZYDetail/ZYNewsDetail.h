//
//  ZYNewsDetail.h
//  详情页面
//
//  Created by 章芝源 on 15/11/20.
//  Copyright © 2015年 ZZY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYNewsDetail : NSObject
/** 新闻标题 */
@property (nonatomic, copy) NSString *title;
/** 发布时间 */
@property (nonatomic, copy) NSString *ptime;
/** 新闻内容 */
@property (nonatomic, copy) NSString *body;
/** 新闻详情配图 (希望这个数组中以后存放的都是新闻详情的配图模型) */
@property (nonatomic, strong) NSArray *img;
/** 新闻url */
@property (nonatomic , copy) NSString *url;
/** 新闻url */
@property (nonatomic , copy) NSString *url_3w;
/** 新闻id */
@property (nonatomic , copy) NSString *dobcid;
@end
