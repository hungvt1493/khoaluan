//
//  FriendTableViewCell.h
//  SimpleWeather
//
//  Created by Mac on 3/4/15.
//  Copyright (c) 2015 HungVT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UIView *onlineView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAge;
@property (weak, nonatomic) IBOutlet UILabel *lblAboutMe;
@property (weak, nonatomic) IBOutlet UIImageView *imgGender;

- (void)setOnline:(BOOL)flag;
- (void)setDateForCell:(NSDictionary*)dict;
@end
