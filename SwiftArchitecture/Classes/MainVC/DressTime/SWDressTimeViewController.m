//
//  SWDressTimeViewController.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWDressTimeViewController.h"
#import "SWWeatherView.h"
#import "SWWardrobeDetailViewController.h"
#import "WXManager.h"

@interface SWDressTimeViewController () <UIScrollViewDelegate>{
    SWWeatherView *weatherGrid;
}
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIView *chooseView;
@property (weak, nonatomic) IBOutlet UIButton *jeanButton;
@property (weak, nonatomic) IBOutlet UIButton *skirtButton;
@property (weak, nonatomic) IBOutlet UIButton *shoeButton;
@property (strong, nonatomic) IBOutlet UIScrollView *weatherScrollView;
@property (nonatomic, strong) NSDateFormatter *hourlyFormatter;


- (IBAction)skirtButton:(id)sender;
- (IBAction)jeanButton:(id)sender;
- (IBAction)shoeButton:(id)sender;
- (IBAction)suggestButton:(id)sender;
- (IBAction)chooseAgainButton:(id)sender;
- (IBAction)AcceptButton:(id)sender;

@end

@implementation SWDressTimeViewController {
    NSMutableArray *weatherArr;
    NSMutableArray *timeArr;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[SWUtil appDelegate] hideTabbar:NO];
    [[SWUtil sharedUtil] showLoadingView];
    
    _hourlyFormatter = [[NSDateFormatter alloc] init];
    _hourlyFormatter.dateFormat = @"h a";
    
    [self currentDateTime];
    
    [[RACObserve([WXManager sharedManager], currentCondition)
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(WXCondition *newCondition) {
         float temp = newCondition.temperature.floatValue-273.15;
         if (temp >= 0) {
             self.temperatureLabel.text = [NSString stringWithFormat:@"%.0f°C",newCondition.temperature.floatValue-273.15];
         } else {
             self.temperatureLabel.text = @"";
         }
         
         self.descriptionLabel.text = [newCondition.condition capitalizedString];
         self.cityLabel.text = [newCondition.locationName capitalizedString];
         
         NSString *imageStringCurrent = [NSString stringWithFormat:@"%@",[newCondition imageName]];
         self.weatherLabel.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",imageStringCurrent, Gray_Weather]];
     }];
    
    [[RACObserve([WXManager sharedManager], hourlyForecast)
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(NSArray *newForecast) {
         [self initScroll];
         [[SWUtil sharedUtil] hideLoadingView];
     }];
    
    [[WXManager sharedManager] findCurrentLocation];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [[SWUtil sharedUtil] showLoadingView];

//    [self initData];
//    [self initScroll];
    
}

- (void)initUI{
    self.title = DressTime_Title;
    self.weatherScrollView.delegate = self;
    self.weatherScrollView.hidden = NO;
    
    self.chooseView.hidden = YES;
    self.chooseView.alpha = 0;
    
    [self currentDateTime];
}

- (void)currentDateTime{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    self.dateTimeLabel.text = [SWUtil convertDate:date toStringFormat:Date_Format];
    self.currentTimeLabel.text = [SWUtil convertDate:date toStringFormat:Time_Format];
}

- (void)initScroll {
    
    for (UIView *subview in self.weatherScrollView.subviews) {
        [subview removeFromSuperview];
    }
    
    int xPos = 0;
    
    for (int i =0; i < [[WXManager sharedManager].hourlyForecast count]; i++) {
        WXCondition *weather = [WXManager sharedManager].hourlyForecast[i];
        
        SWWeatherView *weatherView = [[SWWeatherView alloc] initWithFrame:CGRectZero];
        weatherView.delegate = self;
        
        NSString *temperature = @"";
        float temp = weather.temperature.floatValue - 273.15;
        if (temp >= 0) {
            temperature = [NSString stringWithFormat:@"%.0f°",weather.temperature.floatValue - 273.15];
        }
        
        NSString *time = [self.hourlyFormatter stringFromDate:weather.date];;
        weatherView.temperatureLabel.text = temperature;
        weatherView.timeLabel.text = time;
        weatherView.imageString = [NSString stringWithFormat:@"%@",[weather imageName]];
        weatherView.weatherImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",[weather imageName],Gray_Weather]];
        
        CGRect frame = [weatherView frame];
        frame.origin.x = xPos;
        xPos += frame.size.width;
        [weatherView setFrame:frame];
        [self.weatherScrollView addSubview:weatherView];
    }
    
    CGSize contentSize = [self.weatherScrollView contentSize];
    contentSize.width = xPos;
    [self.weatherScrollView setContentSize:contentSize];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
}

#pragma mark - WeatherViewDelegate

- (void)didSelect:(id)grid{
    for (UIView *view in [self.weatherScrollView subviews]) {
        if ([view isKindOfClass:[SWWeatherView class]]) {
            SWWeatherView *optionGrid = (SWWeatherView *)view;
            if ([grid isEqual:optionGrid]) {
                [optionGrid setGridSelected:YES];
                
            } else {
                [optionGrid setGridSelected:NO];
            }
        }
    }
}

#pragma mark - Action

- (IBAction)skirtButton:(id)sender {
    SWWardrobeDetailViewController *wardrobeVC = [[SWWardrobeDetailViewController alloc] initWithNibName:@"SWWardrobeDetailViewController" bundle:nil];
    [self.navigationController pushViewController:wardrobeVC animated:YES];
    
}

- (IBAction)jeanButton:(id)sender {
    SWWardrobeDetailViewController *wardrobeVC = [[SWWardrobeDetailViewController alloc] initWithNibName:@"SWWardrobeDetailViewController" bundle:nil];
    [self.navigationController pushViewController:wardrobeVC animated:YES];
}

- (IBAction)shoeButton:(id)sender {
    SWWardrobeDetailViewController *wardrobeVC = [[SWWardrobeDetailViewController alloc] initWithNibName:@"SWWardrobeDetailViewController" bundle:nil];
    [self.navigationController pushViewController:wardrobeVC animated:YES];
}

- (IBAction)suggestButton:(id)sender {
    if (self.chooseView.hidden) {
        
        self.chooseView.hidden = NO;
        [UIView animateWithDuration:.3 animations:^{
            
            self.chooseView.alpha = 1;
        } completion:^(BOOL finished) {}];
    }
    else {
        
        [UIView animateWithDuration:.3 animations:^{
            
            self.chooseView.alpha = 0;
        } completion:^(BOOL finished) {
            
            self.chooseView.hidden = YES;
        }];
    }

}

- (IBAction)chooseAgainButton:(id)sender {
}

- (IBAction)AcceptButton:(id)sender {
    [UIView animateWithDuration:.3 animations:^{
        
        self.chooseView.alpha = 0;
    } completion:^(BOOL finished) {
        
        self.chooseView.hidden = YES;
    }];
}

- (void)configureHourlyCell:(UITableViewCell *)cell weather:(WXCondition *)weather {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    cell.textLabel.text = [self.hourlyFormatter stringFromDate:weather.date];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f°",weather.temperature.floatValue];
    cell.imageView.image = [UIImage imageNamed:[weather imageName]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
}
@end
