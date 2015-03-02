//
//  NewsView.m
//  SimpleWeather
//
//  Created by Mac on 3/2/15.
//  Copyright (c) 2015 HungVT. All rights reserved.
//

#import "NewsContentView.h"

@implementation NewsContentView

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
        
        //UITapGestureRecognizer *tapGestureViewController = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOptionGrid)];
        //[self addGestureRecognizer:tapGestureViewController];
        
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _btnLike.layer.borderWidth = 0;
    _btnLike.layer.cornerRadius = 5;
    
    _btnMessage.layer.cornerRadius = 5;
    _btnMessage.layer.borderWidth = 1;
    _btnMessage.layer.borderColor = [UIColor blackColor].CGColor;
    
    _btnShowMore.layer.cornerRadius = 5;
    _btnShowMore.layer.borderWidth = 1;
    _btnShowMore.layer.borderColor = [UIColor blackColor].CGColor;
}

@end
