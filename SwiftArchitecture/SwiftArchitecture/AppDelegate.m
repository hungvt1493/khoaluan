//
//  SWAppDelegate.m
//  KhoaLuan2015
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 HungVT. All rights reserved.
//

#import "AppDelegate.h"
#import "SWNavigationViewController.h"
#import "NotificationsViewController.h"
#import "NewsViewController.h"
#import "MyPageViewController.h"
#import "MoreViewController.h"
#import "KLEventsViewController.h"
#import "KeychainItemWrapper.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UIImage *ios7Bg = [UIImage resizableImage:[UIImage imageNamed:@"nav_ios7"]];
    UIImage *iosBg = [UIImage resizableImage:[UIImage imageNamed:@"navbar_bg"]];
    UIImage *navBg = (SYSTEM_VERSION >= 7)?ios7Bg:iosBg;
    UIFont *font = [UIFont fontHelveticaNeue_Medium:18];
    
    SWLoginViewController *controller = [[SWLoginViewController alloc] init];
    SWNavigationViewController *rootNavigation = [[SWNavigationViewController alloc]initWithRootViewController:controller
                                                                                                    background:navBg
                                                                                                          font:font
                                                                                                     textColor:[UIColor colorWithHex:Blue_Color alpha:1]
                                                                                                   shadowColor:[UIColor clearColor]];
    
    self.window.rootViewController = rootNavigation;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)initTabbar {
    
    NSString *navBgName = @"";//(SYSTEM_VERSION >= 7) ? @"nav_ios7" : @"navbar_bg";
    UIImage *navbgImage = [UIImage resizableImage:[UIImage imageNamed:navBgName]];
    
    //Init Classes
    KLEventsViewController *hnueNewsVC = [[KLEventsViewController alloc] init];
    NewsViewController *newsVC = [[NewsViewController alloc] init];
    MyPageViewController *myPageVC = [[MyPageViewController alloc] init];
    NotificationsViewController *notiVC = [[NotificationsViewController alloc] init];
    MoreViewController *moreVC = [[MoreViewController alloc] init];
    
    //Init Navigations
    
    //SWNavigationViewController *hnueNewsNavi = [[SWNavigationViewController alloc] initWithRootViewController:hnueNewsVC background:navbgImage font:[UIFont fontHelveticaNeue_Medium:18] textColor:[UIColor colorWithHex:Blue_Color alpha:1.0] shadowColor:[UIColor clearColor]];
    
    SWNavigationViewController *hnueNewsNavi = [[SWNavigationViewController alloc] initWithRootViewControllerAndGTScroll:hnueNewsVC background:navbgImage font:[UIFont fontHelveticaNeue_Medium:18] textColor:[UIColor whiteColor] shadowColor:[UIColor clearColor]];
    SWNavigationViewController *newsNavi = [[SWNavigationViewController alloc] initWithRootViewControllerAndGTScroll:newsVC background:navbgImage font:[UIFont fontHelveticaNeue_Medium:18] textColor:[UIColor whiteColor] shadowColor:[UIColor clearColor]];
    //SWNavigationViewController *newsNavi = [[SWNavigationViewController alloc] initWithRootViewController:newsVC background:navbgImage font:[UIFont fontHelveticaNeue_Medium:18] textColor:[UIColor colorWithHex:Blue_Color alpha:1.0] shadowColor:[UIColor clearColor]];
    SWNavigationViewController *myPageNavi = [[SWNavigationViewController alloc] initWithRootViewController:myPageVC background:navbgImage font:[UIFont fontHelveticaNeue_Medium:18] textColor:[UIColor whiteColor] shadowColor:[UIColor clearColor]];
    SWNavigationViewController *notiNavi = [[SWNavigationViewController alloc] initWithRootViewController:notiVC background:navbgImage font:[UIFont fontHelveticaNeue_Medium:18] textColor:[UIColor whiteColor] shadowColor:[UIColor clearColor]];
    SWNavigationViewController *moreNavi = [[SWNavigationViewController alloc] initWithRootViewController:moreVC background:navbgImage font:[UIFont fontHelveticaNeue_Medium:18] textColor:[UIColor whiteColor] shadowColor:[UIColor clearColor]];
    
    //Init tabbar
    NSArray *imagesNormal = @[hnue_news,news,home,noti,more];
    NSArray *imagesSelected = @[hnue_news_act,news_act,home_act,noti_act,more_act];
    NSArray *title = @[@"HNUE News",@"Tin mới",@"Cá nhân",@"Thông báo",@"Thêm"];
    UIColor *backgroundColor = [UIColor colorWithHex:Nav_Bg_Color alpha:1];
    
    self.tabbarController = [[SWTabbarController alloc] initWithNomarlImages:imagesNormal selectImages:imagesSelected backGround:backgroundColor title:title];
    self.tabbarController.viewControllers = @[hnueNewsNavi,newsNavi,myPageNavi,notiNavi,moreNavi];

    self.window.rootViewController = nil;
    self.window.rootViewController = self.tabbarController;
    [self.tabbarController hoverAtIndex:0];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

- (void)hideTabbar:(BOOL)hide{
    [self.tabbarController hideTabbar:hide];
}

- (void)logoutFunction{
    UIImage *ios7Bg = [UIImage resizableImage:[UIImage imageNamed:@"nav_ios7"]];
    UIImage *iosBg = [UIImage resizableImage:[UIImage imageNamed:@"navbar_bg"]];
    UIImage *navBg = (SYSTEM_VERSION >= 7)?ios7Bg:iosBg;
    UIFont *font = [UIFont fontHelveticaNeue_Medium:18];
    UIWindow *window = self.window;
    [window setRootViewController:nil];

    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:kKeyChain accessGroup:nil];
    [keychainItem resetKeychainItem];
    
    SWLoginViewController *controller = [[SWLoginViewController alloc] init];
    SWNavigationViewController *rootNavigation = [[SWNavigationViewController alloc]initWithRootViewController:controller
                                                                                                    background:navBg
                                                                                                          font:font
                                                                                                     textColor:[UIColor colorWithHex:Blue_Color alpha:1.0]
                                                                                                   shadowColor:[UIColor colorWithHex:Blue_Color alpha:1.0]];
    self.window.rootViewController = rootNavigation;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
