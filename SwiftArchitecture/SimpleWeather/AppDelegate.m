//
//  SWAppDelegate.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "AppDelegate.h"
#import "SWLoginViewController.h"
#import "SWDressTimeViewController.h"
#import "SWWardrobeViewController.h"
#import "SWListLogViewController.h"
#import "SWSettingViewController.h"

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
                                                                                                     textColor:[UIColor colorWithHex:Green_Color alpha:1.0]
                                                                                                   shadowColor:[UIColor colorWithHex:Green_Color alpha:1.0]];
    
    self.window.rootViewController = rootNavigation;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)initTabbar {
    
    NSString *navBgName = (SYSTEM_VERSION >= 7) ? @"nav_ios7" : @"navbar_bg";
    UIImage *navbgImage = [UIImage resizableImage:[UIImage imageNamed:navBgName]];
    
    //Init Classes
    SWDressTimeViewController *dressTimeVC = [[SWDressTimeViewController alloc] init];
    SWWardrobeViewController *wardrobeVC = [[SWWardrobeViewController alloc] init];
    SWListLogViewController *logVC = [[SWListLogViewController alloc] init];
    SWSettingViewController *settingVC = [[SWSettingViewController alloc] init];
    
    //Init Navigations
    
    SWNavigationViewController *dressTimeNavi = [[SWNavigationViewController alloc] initWithRootViewController:dressTimeVC background:navbgImage font:[UIFont fontHelveticaNeue_Medium:18] textColor:[UIColor colorWithHex:Green_Color alpha:1.0] shadowColor:[UIColor clearColor]];
    SWNavigationViewController *wardrobeNavi = [[SWNavigationViewController alloc] initWithRootViewController:wardrobeVC background:navbgImage font:[UIFont fontHelveticaNeue_Medium:18] textColor:[UIColor colorWithHex:Green_Color alpha:1.0] shadowColor:[UIColor clearColor]];
    SWNavigationViewController *logNavi = [[SWNavigationViewController alloc] initWithRootViewController:logVC background:navbgImage font:[UIFont fontHelveticaNeue_Medium:18] textColor:[UIColor colorWithHex:Green_Color alpha:1.0] shadowColor:[UIColor clearColor]];
    SWNavigationViewController *settingNavi = [[SWNavigationViewController alloc] initWithRootViewController:settingVC background:navbgImage font:[UIFont fontHelveticaNeue_Medium:18] textColor:[UIColor colorWithHex:Green_Color alpha:1.0] shadowColor:[UIColor clearColor]];
    
    //Init tabbar
    NSArray *imagesNormal = @[Dress_Time_Off,Wardrobe_Off,Log_Off, Setting_Off];
    NSArray *imagesSelected = @[Dress_Time_On,Wardrobe_On,Log_On, Setting_On];
    NSArray *title = @[Dress_Time_Title, Wardrobe_Title, Log_Title, Setting_Title];
    UIColor *backgroundColor = [UIColor colorWithHex:White_Color alpha:1];
    
    self.tabbarController = [[SWTabbarController alloc] initWithNomarlImages:imagesNormal selectImages:imagesSelected backGround:backgroundColor title:title];
    self.tabbarController.viewControllers = @[dressTimeNavi,wardrobeNavi,logNavi,settingNavi];
    [self.tabbarController hoverAtIndex:0];
    self.window.rootViewController = nil;
    self.window.rootViewController = self.tabbarController;
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
    
    SWLoginViewController *controller = [[SWLoginViewController alloc] init];
    SWNavigationViewController *rootNavigation = [[SWNavigationViewController alloc]initWithRootViewController:controller
                                                                                                    background:navBg
                                                                                                          font:font
                                                                                                     textColor:[UIColor colorWithHex:Green_Color alpha:1.0]
                                                                                                   shadowColor:[UIColor colorWithHex:Green_Color alpha:1.0]];
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
