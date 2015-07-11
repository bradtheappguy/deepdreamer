//
//  IMAboutViewController.m
//  Impressionism
//
//  Created by Brad on 4/24/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//

#import "IMAboutViewController.h"

@interface IMAboutViewController ()

@end

@implementation IMAboutViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor blueColor];
  self.title = NSLocalizedString(@"About", nil);
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonPressed:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Buttons

-(void)doneButtonPressed:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
