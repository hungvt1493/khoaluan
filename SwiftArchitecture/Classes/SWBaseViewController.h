//
//  SWBaseViewController.h
//  SwiftArchitecture
//
//  Created by luan pham on 6/21/14.
//  Copyright (c) 2014 luan pham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWBaseViewController : UIViewController
{
    
}

- (void)setBackButtonWithImage:(NSString*)imageButtonName
              highlightedImage:(NSString*)highlightedImageButtonName
                        target:(id)target action:(SEL)action;

- (void)setRightButtonWithImage:(NSString*)imageButtonName
               highlightedImage:(NSString*)highlightedImageButtonName
                         target:(id)target action:(SEL)action;
@end
