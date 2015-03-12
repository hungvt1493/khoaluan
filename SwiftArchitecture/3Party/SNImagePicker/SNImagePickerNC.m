//
//  SNImagePickerNC.m
//  SNImagePicker
//
//  Created by Narek Safaryan on 2/23/14.
//  Copyright (c) 2014 X-TECH creative studio. All rights reserved.
//

#import "SNImagePickerNC.h"

@interface SNImagePickerNC ()

@end

@implementation SNImagePickerNC

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
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8) {
        [[UINavigationBar appearance] setHidden:NO];
        [[UINavigationBar appearance] setTranslucent:NO];
        [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
        
    } else {
        [self.navigationController.navigationBar setHidden:NO];
        [self.navigationController.navigationBar setTranslucent:NO];
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navi_bg.png"] forBarMetrics:UIBarMetricsDefault];
    }
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navi_bg.png"] forBarMetrics:UIBarMetricsDefault];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
