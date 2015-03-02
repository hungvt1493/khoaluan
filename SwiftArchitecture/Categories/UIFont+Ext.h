//
//  UIFont+Ext.h
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved
//

#import <UIKit/UIKit.h>

@interface UIFont (Ext)
{
    
}

+ (void)printAllSystemFonts;
+ (UIFont *)fontHelveticaWithSize:(CGFloat)fontSize;
+ (UIFont *)fontHelveticaNeue_Light:(CGFloat)fontSize;
+ (UIFont *)fontHelveticaNeue_UltraLight:(CGFloat)fontSize;
+ (UIFont *)fontHelveticaNeue_Medium:(CGFloat)fontSize;
+ (UIFont *)fontHelveticaBoldObliqueWithSize:(CGFloat)fontSize;
+ (UIFont *)fontHelveticaBoldWithSize:(CGFloat)fontSize;
+ (UIFont *)fontHelveticaObliqueWithSize:(CGFloat)fontSize;

@end
