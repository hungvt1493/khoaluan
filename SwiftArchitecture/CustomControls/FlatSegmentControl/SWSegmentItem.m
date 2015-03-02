//
//  SWSegmentItem.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWSegmentItem.h"


@implementation SWSegmentItem
@synthesize stateNomarl = _stateNomarl;
@synthesize stateSelected  = _stateSelected;

-(id)initWithNormalImage:(UIImage*)anormal selectedImage:(UIImage*)ahover frame:(CGRect)aframe {
    
    self =  [super initWithFrame:aframe];
    {
        _stateNomarl = [[UIImageView alloc] initWithImage:anormal];
        [_stateNomarl setContentMode:UIViewContentModeScaleAspectFit];
        _stateSelected = [[UIImageView alloc] initWithImage:ahover];
        [_stateSelected setContentMode:UIViewContentModeScaleAspectFit];
        
        [self addSubview:_stateNomarl];
        [self addSubview:_stateSelected];
        
        self.selected = NO;
    }
	return self;
}

-(id)initWithNormalImage:(UIImage *)anormal selectedImage:(UIImage *)ahover startPoint:(CGPoint)apoint {
    
    CGRect rect = CGRectMake(apoint.x, apoint.y, anormal.size.width, anormal.size.height);
	return [self initWithNormalImage:anormal selectedImage:ahover frame:rect];
}

#pragma mark -
#pragma mark OverWrite for default select action and state property

- (void)setSelected:(BOOL)value
{
	[super setSelected:value];
    
	_stateNomarl.hidden = value;
	_stateSelected.hidden = !value;
}

- (void)dealloc
{
    _stateNomarl = nil;
    _stateSelected = nil;
}

@end
