//
//  SWBaseViewController.m
//  SwiftArchitecture
//
//  Created by luan pham on 6/21/14.
//  Copyright (c) 2014 luan pham. All rights reserved.
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
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:tmpButton]];
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
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:tmpButton]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
