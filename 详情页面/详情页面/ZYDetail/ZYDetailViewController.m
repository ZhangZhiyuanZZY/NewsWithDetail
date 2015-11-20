//
//  ZYDetailViewController.m
//  详情页面
//
//  Created by 章芝源 on 15/11/20.
//  Copyright © 2015年 ZZY. All rights reserved.
//

#import "ZYDetailViewController.h"
#import "ZYNewsDetail.h"
#import "ZYHTTPManager.h"
#import "MJExtension.h"
#import "ZYNewsDetailling.h"
#import "ZYHeadline.h"
@interface ZYDetailViewController ()
///网页
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property(nonatomic, strong)NSArray *newsDetails;

@property(nonatomic, strong)ZYNewsDetail *newsDetail;

@end

@implementation ZYDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ///
    self.title = @"新闻详情";
    
    ///这个属性控制是不是自动适配scrollView 的内边距
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    ///这个路径是操作屏幕显示的路径
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.detail.url]]];
    
    ///这个路径准备是适配, 所有的手机屏幕的大小,  不会超出屏幕的大小刚好合适, 但是仍然会有最小面的广告
    ////我们需要自定义
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.detail.url_3w]]];
    
    // 地址: http://c.m.163.com/nc/article/{docid}/full.html
    NSString *url = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/full.html", self.headline.docid];
    [[ZYHTTPManager manager]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
//        [responseObject writeToFile:@"/users/apple/desktop/test1.plist" atomically:YES];
        self.newsDetail = [ZYNewsDetail objectWithKeyValues:responseObject[self.headline.docid]];
        [self showDetailNews];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"链接错误%@", error);
    }];
    
}

///显示详情页面
- (void)showDetailNews
{
//    [self.webView loadHTMLString:self.detail.body baseURL:nil];
    //出现的问题 : 文字内容显示出来了,但是图片没有显示.
    
    NSMutableString *html = [NSMutableString string];
    
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">",[[NSBundle mainBundle] URLForResource:@"ZYNewsDetail.css" withExtension:nil]];
    [html appendString:@"<head>"];
    [html appendString:@"<body>"];
    //将图片插入对象的body中
    [html appendString:[self setupBody]];
    [html appendString:@"<body>"];
    
    [html appendString:@"<html>"];
    
    [self.webView loadHTMLString:html baseURL:nil];
}

///设置html  页面 body数据
- (NSString *)setupBody
{
    NSMutableString *body = [NSMutableString string];
    //拼接标题
    [body appendFormat:@"<div class=\"title\">%@</div>", self.newsDetail.title];
    //拼接时间
    [body appendFormat:@"<div class=\"time\">%@</div>", self.newsDetail.ptime];
    //拼接图片
    // 拼接图片  img.ref ==  <!--IMG#0-->  <!--IMG#0--> --> <img src=img.src>
    // <!--IMG#0-->这玩样代表了一张图片
    [body appendString:self.newsDetail.body];
    //遍历数组, 拿到图片模型
    for (ZYNewsDetailling *img in self.newsDetail.img) {
        NSMutableString *imgHtml = [NSMutableString string];
        [imgHtml appendString:@"<div class=\"img-parent\">"];
        [imgHtml appendFormat:@"<img src=\"%@\">",img.src];
        
        [imgHtml appendString:@"</div>"];
        
        ///将代码中所有的注释, 都替换成imghtml
        ///NSCaseInsensitiveSearch 这个参数意思是不区分大小写
        ///range:NSMakeRange(0, body.length) 替换范围是0到body.length  的长度
        [body replaceOccurrencesOfString:img.ref withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];        
    }
    return body;
}


@end
