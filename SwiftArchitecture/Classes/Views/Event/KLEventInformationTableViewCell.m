//
//  KLEventInformationTableViewCell.m
//  KhoaLuan2015
//
//  Created by Mac on 3/24/15.
//  Copyright (c) 2015 Hung Vuong. All rights reserved.
//

#import "KLEventInformationTableViewCell.h"

@implementation KLEventInformationTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _imgRateChecked.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSDictionary*)dict {
    NSString *eventTitle = [dict objectForKey:@"news_event_title"];
    _lblEventTitle.text = eventTitle;
    
    if ([dict objectForKey:@"event_time"] != [NSNull null]) {
        int eventTime = [[dict objectForKey:@"event_time"] intValue];
        NSString *eventTimeStr = [SWUtil convert:eventTime toDateStringWithFormat:FULL_DATE_FORMAT];
        _lblEventTime.text = eventTimeStr;
    }
    
    int bad = [[[dict objectForKey:@"rate"] objectForKey:@"status 1"] intValue];
    _lblRateBad.text = [NSString stringWithFormat:@"%d", bad];
    
     int fine = [[[dict objectForKey:@"rate"] objectForKey:@"status 2"] intValue];
    _lblRateFine.text = [NSString stringWithFormat:@"%d", fine];
    
    int good = [[[dict objectForKey:@"rate"] objectForKey:@"status 3"] intValue];
    _lblNumberRateGood.text = [NSString stringWithFormat:@"%d", good];
    
    int total = bad+fine+good;
    _lblTotal.text = [NSString stringWithFormat:@"%d", total];
    
    NSArray *didRate = [[dict objectForKey:@"rate"] objectForKey:@"did_rate"];
    if (didRate.count > 0) {
        NSDictionary *didRateDict = [didRate objectAtIndex:0];
        int status = [[didRateDict objectForKey:@"status"] intValue];
        _imgRateChecked.hidden = NO;
        switch (status) {
            case Bad:
                _imgRateChecked.frame = _imgBad.frame;
                break;
            case Fine:
                _imgRateChecked.frame = _imgFine.frame;
                break;
            case Good:
                _imgRateChecked.frame = _imgGood.frame;
                break;
            default:
                break;
        }
    }
}
@end
