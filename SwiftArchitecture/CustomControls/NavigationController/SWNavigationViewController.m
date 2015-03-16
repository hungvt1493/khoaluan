//
//  SWNavigationViewController.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 HungVT. All rights reserved.
//

#import "SWNavigationViewController.h"
#import "GTScrollNavigationBar.h"

@interface SWNavigationViewController ()

@end

@implementation SWNavigationViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
                      background:(UIImage *)background
                            font:(UIFont *)font
                       textColor:(UIColor *)textColor
                     shadowColor:(UIColor *)shadowColor {
    
    if (self = [super initWithRootViewController:rootViewController]) {
        
        if([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
            
            [self.navigationBar setBarStyle:UIBarStyleBlackOpaque];
            //iOS 5 new UINavigationBar custom background
            [self.navigationBar setBackgroundImage:background forBarMetrics: UIBarMetricsDefault];
            
            if (SYSTEM_VERSION >= 8) {
                [[UINavigationBar appearance] setTranslucent:NO];
                [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHex:Blue_Color alpha:1]];
                [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
                [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
            } else {
                [self.navigationController.navigationBar setTranslucent:NO];
                self.navigationBar.barTintColor = [UIColor colorWithHex:Blue_Color alpha:1];
                self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
                [self.navigationController.navigationBar
                 setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
            }
            
            NSShadow *shadow = [NSShadow new];
            [shadow setShadowColor: [UIColor clearColor]];
            [shadow setShadowOffset: CGSizeMake(1, -1.0f)];
            NSDictionary *settings;
            if (SYSTEM_VERSION <7) {
                
                settings = @{
                             UITextAttributeFont                 :  font,
                             UITextAttributeTextColor            :  [UIColor whiteColor],
                             UITextAttributeTextShadowColor      :  [UIColor clearColor],
                             UITextAttributeTextShadowOffset     :  [NSValue valueWithUIOffset:UIOffsetMake(1,-1)],
                             };
            }
            else{
                
                settings = @{
                             NSFontAttributeName                 :  font,
                             NSForegroundColorAttributeName      :  textColor,
                             NSShadowAttributeName               :  shadow,
                             };
            }
            
            [[UINavigationBar appearance] setTitleTextAttributes:settings];
            [self.navigationBar setTitleVerticalPositionAdjustment:2.0f forBarMetrics:UIBarMetricsDefault];
            [self.navigationBar setBarStyle:UIBarStyleDefault];
        
        }
        
        [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
        //set back button arrow color
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    }
    return self;
}

- (id)initWithRootViewControllerAndGTScroll:(UIViewController *)rootViewController
                                 background:(UIImage *)background
                                       font:(UIFont *)font
                                  textColor:(UIColor *)textColor
                                shadowColor:(UIColor *)shadowColor {
    self = [[UINavigationController alloc] initWithNavigationBarClass:[GTScrollNavigationBar class] toolbarClass:nil];
    [self setViewControllers:@[rootViewController] animated:NO];
    
    if (SYSTEM_VERSION >= 8) {
        [[UINavigationBar appearance] setTranslucent:NO];
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHex:Blue_Color alpha:1]];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    } else {
        [self.navigationController.navigationBar setTranslucent:NO];
        self.navigationBar.barTintColor = [UIColor colorWithHex:Blue_Color alpha:1];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar
         setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    }
    
    if([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        
        [self.navigationBar setBarStyle:UIBarStyleBlackOpaque];
        //iOS 5 new UINavigationBar custom background
        [self.navigationBar setBackgroundImage:background forBarMetrics: UIBarMetricsDefault];
        
        
        NSShadow *shadow = [NSShadow new];
        [shadow setShadowColor: [UIColor clearColor]];
        [shadow setShadowOffset: CGSizeMake(1, -1.0f)];
        NSDictionary *settings;
        if (SYSTEM_VERSION <7) {

            settings = @{
                         UITextAttributeFont                 :  font,
                         UITextAttributeTextColor            :  textColor,
                         UITextAttributeTextShadowColor      :  [UIColor clearColor],
                         UITextAttributeTextShadowOffset     :  [NSValue valueWithUIOffset:UIOffsetMake(1,-1)],
                         };
        }
        else{

            settings = @{
                         NSFontAttributeName                 :  font,
                         NSForegroundColorAttributeName      :  textColor,
                         NSShadowAttributeName               :  shadow,
                         };
        }
        
        [[UINavigationBar appearance] setTitleTextAttributes:settings];
        [self.navigationBar setTitleVerticalPositionAdjustment:2.0f forBarMetrics:UIBarMetricsDefault];
        [self.navigationBar setBarStyle:UIBarStyleDefault];
        
        [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
        //set back button arrow color
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        
    }
    
    return self;
}

- (void)changeStyle:(UIImage *)background
               font:(UIFont*) font
          textColor:(UIColor *)textColor
       shadowColor :(UIColor *)shadowColor {
    
    [self.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    //iOS 5 new UINavigationBar custom background
    [self.navigationBar setBackgroundImage:background forBarMetrics: UIBarMetricsDefault];
    
    
    NSShadow *shadow = [NSShadow new];
    [shadow setShadowColor: [UIColor clearColor]];
    [shadow setShadowOffset: CGSizeMake(1, -1.0f)];
    NSDictionary *settings;
    if (SYSTEM_VERSION <7) {
        
        settings = @{
                     UITextAttributeFont                 :  font,
                     UITextAttributeTextColor            :  textColor,
                     UITextAttributeTextShadowColor      :  [UIColor clearColor],
                     UITextAttributeTextShadowOffset     :  [NSValue valueWithUIOffset:UIOffsetMake(1,-1)],
                     };
    }
    else{

        settings = @{
                     NSFontAttributeName                 :  font,
                     NSForegroundColorAttributeName      :  textColor,
                     NSShadowAttributeName               :  shadow,
                     };
    }
    
    [[UINavigationBar appearance] setTitleTextAttributes:settings];
    [self.navigationBar setTitleVerticalPositionAdjustment:2.0f forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setBarStyle:UIBarStyleDefault];

}

@end
