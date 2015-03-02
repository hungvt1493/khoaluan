//
//  UIButton+Ext.h
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved

#import "UIButton+Ext.h"

@implementation UIButton (Ext)

+ (UIButton *)setButtonWithFrame:(CGRect)buttonFrame
                 normalImageName:(NSString *)normalImageName
              highlightImageName:(NSString *)highlightImageName
                          target:(id)target
                          action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = buttonFrame;
    [button setBackgroundImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

@end
