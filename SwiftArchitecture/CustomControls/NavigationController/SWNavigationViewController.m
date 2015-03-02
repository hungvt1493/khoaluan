//
//  SWNavigationViewController.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWNavigationViewController.h"

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
