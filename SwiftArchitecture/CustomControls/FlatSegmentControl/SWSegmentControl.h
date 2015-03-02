//
//  SWSegmentControl.h
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWSegmentItem.h"
@class SWSegmentControl;

@protocol SWSegmentControlDelegate <NSObject>

@optional

- (void)swSegmentControl:(SWSegmentControl *)swControl clickAtIndex:(NSInteger )index onCurrentIndex:(BOOL)currentIndex;

@end

@interface SWSegmentControl : UIView
{

}
@property (nonatomic,strong) NSMutableArray *cells;
@property (nonatomic,strong) UIImageView *backgroundImageView;
@property (nonatomic,assign) NSInteger selectedIndex;
@property (nonatomic,assign) id<SWSegmentControlDelegate> delegate;

@end
