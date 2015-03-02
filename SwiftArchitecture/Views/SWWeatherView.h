//
//  SWWeatherView.h
//  SwiftArchitecture
//
//  Created by Mac on 1/30/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SWWeatherViewDelegate<NSObject>
- (void)didSelect:(id)grid;
@end

@interface SWWeatherView : UIView
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) id <SWWeatherViewDelegate> delegate;
@property (nonatomic, strong) NSString *imageString;

- (void)setGridSelected:(BOOL)selected;
@end
