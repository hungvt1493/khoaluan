//
//  KLImageViewInPostContent.m
//  KhoaLuan2015
//
//  Created by Mac on 3/22/15.
//  Copyright (c) 2015 Hung Vuong. All rights reserved.
//

#import "KLImageViewInPostContent.h"

@implementation KLImageViewInPostContent

- (id)initWithFrame:(CGRect)frame
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    if (array == nil || [array count] == 0)
        return nil;
    frame = [[array objectAtIndex:0] frame];
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addSubview:[array objectAtIndex:0]];
    }
    return self;
}

- (IBAction)btnDeleteTapped:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDeleteImageAtIndex:)]) {
        [self.delegate  didDeleteImageAtIndex:_index];
    }
}
@end
