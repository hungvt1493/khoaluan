//
//  SWSegmentControl.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWSegmentControl.h"

@implementation SWSegmentControl
@synthesize selectedIndex = _selectedIndex;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _selectedIndex = 0;
        _cells = [[NSMutableArray alloc]init];
        self.backgroundColor = [UIColor clearColor];
		_backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
		[self addSubview:_backgroundImageView];
    }
    return self;
}

- (void)setupDynamicImagesName:(NSArray*)images selectedImagesName:(NSArray*)selectedImages {
    
    NSAssert([images count] == [selectedImages count], @"two arrays should have same items count");
    
    int x = 0;
	for (int i = 0; i < [images count]; i++) {
        
        UIImage *currentImg = [UIImage imageNamed:[images objectAtIndex:i]];
		CGPoint origin = CGPointMake(x, 0);
        
		SWSegmentItem* cell = [[SWSegmentItem alloc] initWithNormalImage:[images objectAtIndex:i] selectedImage:[selectedImages objectAtIndex:i] startPoint:origin];
		[self addCell:cell];
		
		if (i == 0) {
			
			[cell setSelected:YES];
		}
        
        x = x + currentImg.size.width;
	}
}

- (void)addCells:(NSArray*)cells {
    
	for (SWSegmentItem *cell in cells) {
        
		[self addCell:cell];
	}
}

- (NSInteger)selectedIndex {
    
	return _selectedIndex;
}

- (void)setSelectedIndex:(NSInteger)value {
    
	NSInteger previousIndex = _selectedIndex;
	_selectedIndex = value;
	
	if (previousIndex != _selectedIndex) {
		if(previousIndex != -1) {
		
            ((SWSegmentItem *)[_cells objectAtIndex:previousIndex]).selected = NO;
        }
        ((SWSegmentItem*)[_cells objectAtIndex:_selectedIndex]).selected = YES;
        
        [self onCellClicked:(SWSegmentItem *)[_cells objectAtIndex:_selectedIndex]];
	}
}

#pragma mark -
#pragma mark private

- (void)addCell:(SWSegmentItem *)cell {
    
	[cell addTarget:self action:@selector(onCellClicked:) forControlEvents:UIControlEventTouchUpInside];
	[_cells addObject:cell];
	[self addSubview:cell];
}

- (void)onCellClicked:(SWSegmentItem *)cell {
    
	NSInteger index = [_cells indexOfObject:cell];
	NSAssert(index != NSNotFound , @"error on the cell click!");
	NSInteger previousIndex = _selectedIndex;
	self.selectedIndex = index;
    
    if ([self.delegate respondsToSelector:@selector(swSegmentControl:clickAtIndex:onCurrentIndex:)]) {
        
        [self.delegate swSegmentControl:self clickAtIndex:self.selectedIndex onCurrentIndex:self.selectedIndex == previousIndex];
	}
}

@end
