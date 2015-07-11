//
//  IMWebViewController.m
//  Impressionism
//
//  Created by Brad on 5/19/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import "IMWebViewController.h"

@interface IMWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation IMWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title = NSLocalizedString(@"Gallery", nil);
  NSString *urlString = [[self.url absoluteString] stringByReplacingOccurrencesOfString:@"impressionist://" withString:@"http://impressionist.theappguy.guru/"];
  if ([urlString rangeOfString:@"?"].length > 0) {
    urlString = [urlString stringByAppendingString:@"&inapp=1"];
  }
  else {
    urlString = [urlString stringByAppendingString:@"?inapp=1"];
  }
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissModalViewControllerAnimated:)];
    
  [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
  self.activityIndicator.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  self.activityIndicator.hidden = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  self.activityIndicator.hidden = YES;
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ALERT", nil) message:NSLocalizedString(@"AN_ERROR_OCCURED", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
  [alert show];
}
@end
