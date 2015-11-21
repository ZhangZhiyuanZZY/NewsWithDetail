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
#import "UIImageView+WebCache.h"
@interface ZYDetailViewController ()<UIWebViewDelegate>
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
    self.webView.delegate = self;
    
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
    
    ///这里只是加载网页, 并不是发送请求
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
        
        //拿到图片的尺寸
        NSArray *pixel = [img.pixel componentsSeparatedByString:@"*"];
        int width = [[pixel firstObject]intValue];
        int height = [[pixel lastObject]intValue];
        int maxWidth = [UIScreen mainScreen].bounds.size.width *0.8;
        
        //h / w = H/ W
        int destHeight = height/ width * maxWidth;
        
        
        ///onload是页面加载完毕才会执行, 防止用户在网页还没有加载好的时候, 就去点击
        NSString *onload = @"this.onclick = function() { "
        "window.location.href = 'zy:saveImageToAlbum:&' + this.src"
        "};";
    
        [imgHtml appendFormat:@"<img onload=\"%@\" width=\"%d\" height =\"%d\"  src=\"%@\">", onload, maxWidth, destHeight,img.src];
        
        [imgHtml appendString:@"</div>"];
        
        ///将代码中所有的注释, 都替换成imghtml
        ///NSCaseInsensitiveSearch 这个参数意思是不区分大小写
        ///range:NSMakeRange(0, body.length) 替换范围是0到body.length  的长度
        [body replaceOccurrencesOfString:img.ref withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];        
    }
    return body;
}

// 方法 & src
// oc  & frist  last
///保存图片到手机相册
//imgSrc图片路径
- (void)saveImageToAlbum:(NSString *)imgSrc
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"是否保存到相册" preferredStyle:UIAlertControllerStyleActionSheet];
    
    //action代表按钮对象
    /*Apply a style that indicates the action might change or delete data.
     Available in iOS 8.0 and later.
     */
    [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        //保存到相册
//        //方法一:使用sdw网上下载
//        [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:imgSrc] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
//        }];
        //方法二:从web缓存中加载
        NSURLCache *cache = [NSURLCache sharedURLCache];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imgSrc]];
        NSCachedURLResponse *response = [cache cachedResponseForRequest:request];
        NSData *data = response.data;
        UIImage *imageFromCache = [UIImage imageWithData:data];
        UIImageWriteToSavedPhotosAlbum(imageFromCache, nil, nil, nil);
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    //弹出提示框
    [self presentViewController:alert animated:YES completion:nil];
    
 }


#pragma mark - webviewdelegate
//这里只是要, 拦截下请求去执行保存图片的代码, 而不是真的要去发送请求, 所以判断url的值, 什么时候url有值, 当我们点击图片的时候, 才有值,
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    NSRange range = [url rangeOfString:@"zy:"];
    if (range.length > 0) {
        NSUInteger index = range.location + range.length;
        NSString *string = [url substringFromIndex:index];
        NSArray *array = [string componentsSeparatedByString:@"&"];
        NSString *mehodName = array.firstObject;
        
        //参数是图片路径可能是nil nil的话, 数组元素只有一个, 先判断数组中是不是有两个元素
        NSString *param = nil;
        if (array.count > 1) {
            param = array.lastObject;
        }
        
       
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        //把字符串, 转化成selector
        SEL methodSel = NSSelectorFromString(mehodName);
//        if ([self respondsToSelector:methodSel]) {
//            [self performSelector:methodSel withObject:param];
//
//        }
        [self performSelector:methodSel withObject:param];

#pragma clang diagnostic pop
        
        return NO;
    }
    
        return YES;
}



@end
