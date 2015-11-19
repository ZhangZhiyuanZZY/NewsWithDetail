//
//  ZYHeadline.h
//  详情页面
//
//  Created by 章芝源 on 15/11/19.
//  Copyright © 2015年 ZZY. All rights reserved.
//

#import <Foundation/Foundation.h>

///头条的模型
@interface ZYHeadline : NSObject
/** 新闻标题 */
@property (nonatomic , copy) NSString *title;
/** 新闻摘要 */
@property (nonatomic , copy) NSString *digest;
/** 图片 *///图片的网络路径
@property (nonatomic , copy) NSString *imgsrc;
/** 新闻url */
@property (nonatomic , copy) NSString *url;
/** 新闻url */
@property (nonatomic , copy) NSString *url_3w;
/** 新闻id */
@property (nonatomic , copy) NSString *docid;

@end
