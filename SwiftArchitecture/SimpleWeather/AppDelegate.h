//
//  AppDelegate.h
//  SimpleWeather
//
//  Created by HungVT on 11/11/13.
//  Copyright (c) 2013 HungVT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWUtil.h"
#import "SWMultiSelectContactViewController.h"
#import "SWAwesomeTableViewController.h"
#import "SWTabbarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) SWTabbarController *tabbarController;

- (void)initTabbar;
- (void)hideTabbar:(BOOL)hide;
- (void)logoutFunction;

@end
