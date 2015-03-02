//
//  UILabel+Ext.h
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved
//

#import <UIKit/UIKit.h>
typedef enum VerticalAlignment {
    
    VerticalAlignmentTop,
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;


@interface UILabel (Ext)
{

}
@property (nonatomic, assign)VerticalAlignment verticalAlignment;

@end
