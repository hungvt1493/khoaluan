//
//  SWBaseViewController.h
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWBaseViewController : UIViewController

- (void)initUI;

- (void)initData;

- (void)setBackButtonWithImage:(NSString*)imageButtonName
              highlightedImage:(NSString*)highlightedImageButtonName
                        target:(id)target action:(SEL)action;

- (void)setRightButtonWithImage:(NSString*)imageButtonName
               highlightedImage:(NSString*)highlightedImageButtonName
                         target:(id)target action:(SEL)action;
@end
