//
//  KLEventInformationTableViewCell.h
//  KhoaLuan2015
//
//  Created by Mac on 3/24/15.
//  Copyright (c) 2015 Hung Vuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLEventInformationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblEventTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblEventTime;
@property (weak, nonatomic) IBOutlet UILabel *lblRateBad;
@property (weak, nonatomic) IBOutlet UILabel *lblRateFine;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberRateGood;
@property (weak, nonatomic) IBOutlet UIImageView *imgBad;
@property (weak, nonatomic) IBOutlet UIImageView *imgFine;
@property (weak, nonatomic) IBOutlet UIImageView *imgGood;
@property (weak, nonatomic) IBOutlet UIImageView *imgRateChecked;

- (void)setData:(NSDictionary*)dict;
@end
