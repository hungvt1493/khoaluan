//
//  SWNavigationViewController.h
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWNavigationViewController : UINavigationController
{

}

- (id)initWithRootViewController:(UIViewController *)rootViewController
                      background:(UIImage *)background
                            font:(UIFont *)font
                       textColor:(UIColor *)textColor
                     shadowColor:(UIColor *)shadowColor;

//Use this method to change |background image|,|font|.. for UINavigationBar
- (void)changeStyle:(UIImage *)background
               font:(UIFont*) font
          textColor:(UIColor *)textColor
       shadowColor :(UIColor *)shadowColor;
@end
