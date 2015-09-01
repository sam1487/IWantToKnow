//
//  ViewController.h
//  IW2K
//
//  Created by Samir Hasan on 12/2/13.
//  Copyright (c) 2013 Samir Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIWebViewDelegate> {
    NSMutableArray *history;
    UIBarButtonItem *backButton;
    NSString *homeUrl;
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;

@property (strong, nonatomic) IBOutlet UIWebView *webView;

- (void)loadUrl:(NSString*)url recordUrl:(BOOL)newVisit;

@end

