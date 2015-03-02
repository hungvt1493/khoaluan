//
//  SWSegmentItem.h
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWSegmentItem : UIControl
{
    
}

@property (nonatomic,strong)UIImageView *stateNomarl;
@property (nonatomic,strong)UIImageView *stateSelected;

-(id)initWithNormalImage:(UIImage*)anormal selectedImage:(UIImage*)ahover frame:(CGRect)aframe;
-(id)initWithNormalImage:(UIImage *)anormal selectedImage:(UIImage *)ahover startPoint:(CGPoint)apoint;

@end
