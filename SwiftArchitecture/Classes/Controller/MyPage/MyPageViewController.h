//
//  MyPageViewController.h
//  SimpleWeather
//
//  Created by Mac on 3/2/15.
//  Copyright (c) 2015 HungVT. All rights reserved.
//

#import "SWBaseViewController.h"

@interface MyPageViewController : SWBaseViewController
@property (assign, nonatomic) MyPageType myPageType;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSDictionary *userDict;
@end
