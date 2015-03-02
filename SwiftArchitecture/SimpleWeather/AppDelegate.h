//
//  AppDelegate.h
//  SimpleWeather
//
//  Created by Nguyen Thu Ly on 11/11/13.
//  Copyright (c) 2013 Nguyen Thu Ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWUtil.h"
#import "SWMultiSelectContactViewController.h"
#import "SWAwesomeTableViewController.h"
#import "SWTabbarController.h"
#import "SWLoginViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) SWTabbarController *tabbarController;
@property (nonatomic, strong) SWLoginViewController *loginViewController;

- (void)initTabbar;
- (void)hideTabbar:(BOOL)hide;
- (void)logoutFunction;

@end
