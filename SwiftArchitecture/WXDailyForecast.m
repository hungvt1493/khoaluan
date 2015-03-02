//
//  WXDailyForecast.m
//  SimpleWeather
//
//  Created by Nguyen Thu Ly on 11/11/13.
//  Copyright (c) 2013 Nguyen Thu Ly. All rights reserved.
//

#import "WXDailyForecast.h"

@implementation WXDailyForecast

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *paths = [[super JSONKeyPathsByPropertyKey] mutableCopy];
    paths[@"tempHigh"] = @"temp.max";
    paths[@"tempLow"] = @"temp.min";
    return paths;
}

@end
