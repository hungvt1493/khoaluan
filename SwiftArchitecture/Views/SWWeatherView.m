//
//  SWWeatherView.m
//  SwiftArchitecture
//
//  Created by Mac on 1/30/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWWeatherView.h"

@implementation SWWeatherView

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
        
        UITapGestureRecognizer *tapGestureViewController = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOptionGrid)];
        [self addGestureRecognizer:tapGestureViewController];
    }
    return self;
}

- (void)didTapOptionGrid
{
    if (self.delegate) {
        [self.delegate didSelect:self];
    }
}

- (void)setGridSelected:(BOOL)selected{
    if (selected) {
        self.timeLabel.textColor = [UIColor colorWithHex:Red_Color alpha:1.0];
        self.temperatureLabel.textColor = [UIColor colorWithHex:Red_Color alpha:1.0];
        self.weatherImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",self.imageString,Red_Weather]];

    }
    else{
        self.timeLabel.textColor = [UIColor colorWithHex:Gray_Color alpha:1.0];
        self.temperatureLabel.textColor = [UIColor colorWithHex:Gray_Color alpha:1.0];
        self.weatherImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",self.imageString,Gray_Weather]];

    }
}
@end
