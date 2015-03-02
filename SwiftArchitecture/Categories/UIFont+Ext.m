//
//  UIFont+Ext.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved
//

#import "UIFont+Ext.h"

@implementation UIFont (Ext)

+ (void)printAllSystemFonts {

    printf("--------------------------------------------------------------------\n");
    NSArray *familyNames = [UIFont familyNames];
    for( NSString *familyName in familyNames ){
        printf( "Family: %s \n", [familyName UTF8String] );
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        for( NSString *fontName in fontNames ){
            printf( "\tFont: %s \n", [fontName UTF8String] );
        }
    }
    printf("--------------------------------------------------------------------\n");
}

+ (UIFont *)fontHelveticaNeue_Light:(CGFloat)fontSize {
    
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize];
}

+ (UIFont *)fontHelveticaNeue_UltraLight:(CGFloat)fontSize {
    
    return [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:fontSize];
}

+ (UIFont *)fontHelveticaNeue_Medium:(CGFloat)fontSize {
    
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:fontSize];
}

+ (UIFont *)fontHelveticaWithSize:(CGFloat)fontSize {
    
    return [UIFont fontWithName:@"Helvetica" size:fontSize];
}

+ (UIFont *)fontHelveticaBoldObliqueWithSize:(CGFloat)fontSize {
    
    return [UIFont fontWithName:@"Helvetica-BoldOblique" size:fontSize];
}

+ (UIFont *)fontHelveticaBoldWithSize:(CGFloat)fontSize {
    
    return [UIFont fontWithName:@"Helvetica-Bold" size:fontSize];
}

+ (UIFont *)fontHelveticaObliqueWithSize:(CGFloat)fontSize {
    
    return [UIFont fontWithName:@"Helvetica-Oblique" size:fontSize];
}

@end
