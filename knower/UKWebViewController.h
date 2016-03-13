//
//  UKWebViewController.h
//  knower
//
//  Created by xiaoyi on 16/3/13.
//  Copyright © 2016年 urknow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UKWebViewController : UIViewController

@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end
