//
//  UIButton+Ext.h
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved


#import <UIKit/UIKit.h>

@interface UIButton (Ext)

+ (UIButton *)setButtonWithFrame:(CGRect)buttonFrame
                 normalImageName:(NSString *)normalImageName
              highlightImageName:(NSString *)highlightImageName
                          target:(id)target
                          action:(SEL)action;

@end
