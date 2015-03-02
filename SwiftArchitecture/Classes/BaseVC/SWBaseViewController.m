//
//  SWBaseViewController.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWBaseViewController.h"

@interface SWBaseViewController ()

@end

@implementation SWBaseViewController

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
    // Do any additional setup after loading the view.
}

- (void)initUI{
}

- (void)initData{
    
}

- (void)setBackButtonWithImage:(NSString*)imageButtonName
              highlightedImage:(NSString*)highlightedImageButtonName
                        target:(id)target action:(SEL)action {
    
    UIImage *temBack = [UIImage imageNamed:imageButtonName];
    UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tmpButton setBackgroundImage:[UIImage imageNamed:imageButtonName] forState:UIControlStateNormal];
    [tmpButton setBackgroundImage:[UIImage imageNamed:highlightedImageButtonName] forState:UIControlStateHighlighted];
    [tmpButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    tmpButton.frame = CGRectMake(0, 0, temBack.size.width, temBack.size.height);
    
    [tmpButton setShowsTouchWhenHighlighted:YES];
    
    if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7) {
        UIBarButtonItem *spacingAdjust = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [spacingAdjust setWidth:-10];
        
        [self.navigationItem setLeftBarButtonItems:@[spacingAdjust,[[UIBarButtonItem alloc] initWithCustomView:tmpButton]]];
    }
    else {
        
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:tmpButton]];
    }
    
}

- (void)setRightButtonWithImage:(NSString*)imageButtonName
               highlightedImage:(NSString*)highlightedImageButtonName
                         target:(id)target action:(SEL)action {
    
    UIImage *temEdit = [UIImage imageNamed:imageButtonName];
    UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tmpButton setBackgroundImage:[UIImage imageNamed:imageButtonName] forState:UIControlStateNormal];
    [tmpButton setBackgroundImage:[UIImage imageNamed:highlightedImageButtonName] forState:UIControlStateHighlighted];
    [tmpButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    tmpButton.frame = CGRectMake(0, 0, temEdit.size.width, temEdit.size.height);
    [tmpButton setShowsTouchWhenHighlighted:YES];
    
    if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7) {
        UIBarButtonItem *spacingAdjust = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [spacingAdjust setWidth:-10];
        
        [self.navigationItem setRightBarButtonItems:@[spacingAdjust,[[UIBarButtonItem alloc] initWithCustomView:tmpButton]]];
    }
    else {
        
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:tmpButton]];
    }}

@end
