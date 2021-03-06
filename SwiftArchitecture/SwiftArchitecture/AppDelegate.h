//
//  SWAppDelegate.h
//  KhoaLuan2015
//
//  Created by Hung Vuong on 6/19/14.
//  Copyright (c) 2014 Hung Vuong. All rights reserved.
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
@property (nonatomic, strong) NSTimer *getFileTimer;

- (void)setBadgeValue:(NSInteger)value;
- (void)initTabbar;
- (void)hideTabbar:(BOOL)hide;
- (void)logoutFunction;
@end
