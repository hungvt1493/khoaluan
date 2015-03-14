//
//  PullToRefreshView.m
//  Grant Paul (chpwn)
//
//  (based on EGORefreshTableHeaderView)
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//
// The MIT License (MIT)
// Copyright © 2012 Sonny Parlin, http://sonnyparlin.com
//
// //  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "PullToRefreshView.h"
#import <AudioToolbox/AudioToolbox.h>

#define FLIP_ANIMATION_DURATION 0.18f
#define ARROW_DOWN          @"arrow_refresh_down"
#define ARROW_UP            @"arrow_refresh_up"
#define STATUS_LABEL        @"Làm mới"
#define LAST_UPDATE_LABEL   @"最后更新：%@"

@interface PullToRefreshView (Private)

@property (nonatomic, assign) PullToRefreshViewState state;

@end

@implementation PullToRefreshView
@synthesize delegate, scrollView, startingContentInset;

- (void)showActivity:(BOOL)shouldShow animated:(BOOL)animated {
    if (shouldShow) [activityView startAnimating];
    else [activityView stopAnimating];
    
    [UIView animateWithDuration:(animated ? 0.1f : 0.0) animations:^{
        arrowImage.opacity = (shouldShow ? 0.0 : 1.0);
    }];
}

- (void)setImageFlipped:(BOOL)flipped {
    [UIView animateWithDuration:0.1f animations:^{
        arrowImage.transform = (flipped ? CATransform3DMakeRotation(M_PI * 2, 0.0f, 0.0f, 1.0f) : CATransform3DMakeRotation(M_PI, 0.0f, 0.0f, 1.0f));
    }];
}

- (id)initWithScrollView:(UIScrollView *)scroll {
    CGRect frame = CGRectMake(0.0f, 0.0f - scroll.bounds.size.height, scroll.bounds.size.width, scroll.bounds.size.height);
    
    if ((self = [super initWithFrame:frame])) {
        scrollView = scroll;
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
        self.startingContentInset = scrollView.contentInset;
        
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:197.0/255.0 green:197.0/255.0 blue:200.0/255.0 alpha:1.0];
        
		lastUpdatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		lastUpdatedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        if (IS_IPAD()) {
            lastUpdatedLabel.font = [UIFont systemFontOfSize:19.0f];
        }else{
            lastUpdatedLabel.font = [UIFont systemFontOfSize:15.0f];
        }
        lastUpdatedLabel.textColor = [UIColor blackColor];
		lastUpdatedLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		lastUpdatedLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		lastUpdatedLabel.backgroundColor = [UIColor clearColor];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
		lastUpdatedLabel.textAlignment = NSTextAlignmentCenter;
#else
		lastUpdatedLabel.textAlignment = UITextAlignmentCenter;
#endif
		[self addSubview:lastUpdatedLabel];
        
		statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 40.0f, self.frame.size.width, 20.0f)];
		statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        if (IS_IPAD()) {
            statusLabel.font = [UIFont boldSystemFontOfSize:19.0f];
        }else{
            statusLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        }
		statusLabel.textColor = [UIColor blackColor];
		statusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		statusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		statusLabel.backgroundColor = [UIColor clearColor];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
		statusLabel.textAlignment = NSTextAlignmentCenter;
#else
		statusLabel.textAlignment = UITextAlignmentCenter;
#endif
		[self addSubview:statusLabel];
        
		arrowImage = [[CALayer alloc] init];
        if (IS_IPAD()) {
            arrowImage.frame = CGRectMake(50.0f, frame.size.height - 60.0f, 30.0f, 60.0f);
        }
        else{
            arrowImage.frame = CGRectMake(20.0f, frame.size.height - 50.0f, 20.0f, 40.0f);
        }
		arrowImage.contentsGravity = kCAGravityResizeAspect;
		arrowImage.contents = (id) [UIImage imageNamed:ARROW_DOWN].CGImage;
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			arrowImage.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
        
		[self.layer addSublayer:arrowImage];
        
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		activityView.frame = CGRectMake(10.0f, frame.size.height - 40.0f, 20.0f, 20.0f);
		[self addSubview:activityView];
		
        self.enabled = YES;
		[self setState:PullToRefreshViewStateNormal];
    }
    
    return self;
}

#pragma mark -
#pragma mark Setters

- (void)setEnabled:(BOOL)enabled
{
	if (enabled == _enabled)
		return;
	
	_enabled = enabled;
	[UIView animateWithDuration:0.25
                     animations:
	 ^{
		 self.alpha = enabled ? 1 : 0;
	 }];
}

- (void)refreshLastUpdatedDate {
    NSDate *date = [NSDate date];
    
	if ([delegate respondsToSelector:@selector(pullToRefreshViewLastUpdated:)])
		date = [delegate pullToRefreshViewLastUpdated:self];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSString *dateString = [SWUtil convertDate:date toStringFormat:PULL_DOWN_DATE];
    NSString *str1 = [dateString stringByReplacingOccurrencesOfString:@"am"
                                                           withString:@"AM"];
    NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@"pm"
                                                     withString:@"PM"];
    
    NSString *dateTime = str2;// [Util convertDate:date toStringFormat:PULL_DOWN_DATE];
    lastUpdatedLabel.text = @"";//[NSString stringWithFormat:LAST_UPDATE_LABEL, dateTime];
}

- (void)setState:(PullToRefreshViewState)state_ {
    state = state_;
    
	switch (state) {
		case PullToRefreshViewStateReady:
			statusLabel.text = STATUS_LABEL ;
			[self showActivity:NO animated:NO];
            [self setImageFlipped:YES];
            scrollView.contentInset = self.startingContentInset;
            break;
            
		case PullToRefreshViewStateNormal:
			statusLabel.text = STATUS_LABEL;
			[self showActivity:NO animated:NO];
            [self setImageFlipped:NO];
			[self refreshLastUpdatedDate];
            scrollView.contentInset = self.startingContentInset;
			break;
            
		case PullToRefreshViewStateLoading:
			statusLabel.text = STATUS_LABEL;
			[self showActivity:YES animated:YES];
            [self setImageFlipped:NO];
            scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
            
			break;
            
		default:
			break;
	}
}

#pragma mark -
#pragma mark UIScrollView

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"] && self.isEnabled) {
        if (scrollView.isDragging) {
            if (state == PullToRefreshViewStateReady) {
                if (scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f) {
                    [self setState:PullToRefreshViewStateNormal];
                }
            } else if (state == PullToRefreshViewStateNormal) {
                if (scrollView.contentOffset.y < -65.0f) {
                    [self playSound:@"psst1" withExt:@"wav"];
                    [self setState:PullToRefreshViewStateReady];
                }
            } else if (state == PullToRefreshViewStateLoading) {
                if (scrollView.contentOffset.y >= 0) {
                    scrollView.contentInset = self.startingContentInset;
                } else {
                    scrollView.contentInset = UIEdgeInsetsMake(MIN(-scrollView.contentOffset.y, 60.0f), 0, 0, 0);
                }
            }
        } else {
            if (state == PullToRefreshViewStateReady) {
                [UIView animateWithDuration:0.2f animations:^{
                    [self setState:PullToRefreshViewStateLoading];
                }];
                
                if ([delegate respondsToSelector:@selector(pullToRefreshViewShouldRefresh:)]) {
                    
                    [delegate pullToRefreshViewShouldRefresh:self];
                }
            }
        }
        self.frame = CGRectMake(scrollView.contentOffset.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    }
}

- (void)finishedLoading {
    if (state == PullToRefreshViewStateLoading) {
        [self playSound:@"pop" withExt:@"wav"];
        [UIView animateWithDuration:0.3f animations:^{
            [self setState:PullToRefreshViewStateNormal];
        }];
        
        [UIView animateWithDuration:0.3f animations:^{
            [self setState:PullToRefreshViewStateNormal];
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
}

-(void) playSound:(NSString *)fName withExt:(NSString *) ext
{
    SystemSoundID completeSound;
    NSURL *audioPath = [[NSBundle mainBundle] URLForResource:fName withExtension:ext];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)audioPath, &completeSound);
    AudioServicesPlaySystemSound (completeSound);
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	[scrollView removeObserver:self forKeyPath:@"contentOffset"];
	scrollView = nil;
}

@end
