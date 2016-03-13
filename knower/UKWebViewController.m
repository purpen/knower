//
//  UKWebViewController.m
//  knower
//
//  Created by xiaoyi on 16/3/13.
//  Copyright © 2016年 urknow. All rights reserved.
//

#import "UKWebViewController.h"
#import "SVProgressHUD.h"

@interface UKWebViewController () <UIWebViewDelegate> {
    
}

@end

@implementation UKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 自定义返回按钮
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    // 发起请求
    NSURL *url = [NSURL URLWithString:_urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

- (void)goBack {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UIWebViewDelegate

// 加载出错时执行方法
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:[error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"确定", nil];
    [alert show];
}

// 开始加载时执行方法
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD showInfoWithStatus:@"认真加载中..."];
}

// 加载完成时执行方法
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
    
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
