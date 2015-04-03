//
//  FriendTableViewCell.m
//  SimpleWeather
//
//  Created by Mac on 3/4/15.
//  Copyright (c) 2015 HungVT. All rights reserved.
//

#import "FriendTableViewCell.h"

@implementation FriendTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _onlineView.layer.borderColor = [UIColor whiteColor].CGColor;
    _onlineView.layer.borderWidth = 3;
    _onlineView.layer.cornerRadius = _onlineView.bounds.size.width / 2.0;
    _onlineView.clipsToBounds = YES;
}

- (void)setOnline:(BOOL)flag {
    _onlineView.hidden = !flag;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDateForCell:(NSDictionary*)dict {
    
    int isOnline = [[dict objectForKey:kisOnline] intValue];
    if (isOnline == 1) {
        [self setOnline:YES];
    } else {
        [self setOnline:NO];
    }
    
    int isAdmin = [[dict objectForKey:kIsAdmin] intValue];
    if (isAdmin == 0) {
        _imgAdmin.hidden = YES;
    } else {
        _imgAdmin.hidden = NO;
    }
    
    int gender = [[[NSUserDefaults standardUserDefaults] objectForKey:kGender] intValue];
    if (gender == 0) {
        _imgGender.image = [UIImage imageNamed:female_blue];
    } else {
        _imgGender.image = [UIImage imageNamed:male_blue];
    }
    
    _lblName.text = EMPTY_IF_NULL_OR_NIL([dict objectForKey:kName]);
    
    int birthdayInt = [[dict objectForKey:kBirthDay] intValue];
    
    NSDate* birthday = [SWUtil convertNumberToDate:birthdayInt];
    
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:birthday
                                       toDate:now
                                       options:0];
    NSInteger age = [ageComponents year];
    if (birthday == 0) {
        _lblAge.text = @"";
    } else {
        _lblAge.text = [NSString stringWithFormat:@"%d", (int)age];
    }

    _lblAboutMe.text = EMPTY_IF_NULL_OR_NIL([dict objectForKey:kAboutMe]);
    
    NSString *imgAvatarPath = EMPTY_IF_NULL_OR_NIL([dict objectForKey:kAvatar]);
    if (imgAvatarPath.length > 0) {
        NSString *imageLink = [NSString stringWithFormat:@"%@%@", URL_IMG_BASE, imgAvatarPath];
        [self.imgAvatar sd_setImageWithURL:[NSURL URLWithString:imageLink]
                          placeholderImage:[UIImage imageNamed:@"default-avatar"]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     if (image) {
                                         
                                     } else {
                                         
                                     }
                                 }];
    }
}
@end
