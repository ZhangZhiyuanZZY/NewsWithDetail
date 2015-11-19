//
//  ZYHeadlineViewController.m
//  详情页面
//
//  Created by 章芝源 on 15/11/19.
//  Copyright © 2015年 ZZY. All rights reserved.
//

#import "ZYHeadlineViewController.h"
#import "ZYHeadline.h"
#import "MJExtension.h"
#import "ZYHTTPManager.h"
//MARK:   不懂
#import "UIImageView+WebCache.h"  ?????????????????
@interface ZYHeadlineViewController ()
///
@property(nonatomic, strong)NSArray *headlines;

@end

@implementation ZYHeadlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"头条新闻";
    self.tableView.rowHeight = 70;
    
    //1. 加载网上的数据&
    [[ZYHTTPManager manager]GET:@"http://c.m.163.com/nc/article/headline/T1348647853363/0-140.html" parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSArray *array = responseObject[@"T1348647853363"];
        self.headlines = [ZYHeadline objectArrayWithKeyValuesArray:array];
        NSLog(@"%@", array);
        
//        [responseObject writeToFile:@"/Users/apple/Desktop/look.plist" atomically:YES];
        
        ///刷新表格
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败-- %@", error);
    }];
    

}


#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.headlines.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYHeadline *headline = self.headlines[indexPath.row];
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headline" forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headline"];
    cell.textLabel.text = headline.title;
    cell.detailTextLabel.text = headline.digest;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:headline.imgsrc] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    return cell;
}




@end
