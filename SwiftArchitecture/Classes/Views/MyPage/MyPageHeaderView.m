//
//  MyPageHeaderView.m
//  SimpleWeather
//
//  Created by Mac on 3/2/15.
//  Copyright (c) 2015 HungVT. All rights reserved.
//

#import "MyPageHeaderView.h"
#import "FriendsViewController.h"
#import "KLPostNewsViewController.h"

@implementation MyPageHeaderView

- (void)awakeFromNib {
    // Initialization code
    [self initUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)initUI {
    self.backgroundColor = [UIColor colorWithHex:@"E3E3E3" alpha:1];
    
    _btnSetting.layer.borderWidth = 0;
    _btnSetting.layer.cornerRadius = _btnSetting.bounds.size.width / 2.0;
    
    _btnWriteNewPost.layer.borderWidth = 0;
    _btnWriteNewPost.layer.cornerRadius = 5;
    
    _imgAvatar.layer.cornerRadius = _imgAvatar.bounds.size.width / 2.0;
    _imgAvatar.layer.borderWidth = 1;
    _imgAvatar.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _imgAvatar.clipsToBounds = YES;
    
    _avatarBgView.layer.borderColor = [UIColor whiteColor].CGColor;
    _avatarBgView.layer.borderWidth = 1;
    _avatarBgView.layer.cornerRadius = _avatarBgView.bounds.size.width / 2.0;
    
    NSString *imgAvatarPath = [[NSUserDefaults standardUserDefaults] objectForKey:kAvatar];
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
    
    NSString *imgTimelinePath = [[NSUserDefaults standardUserDefaults] objectForKey:kTimelineImage];
    if (imgTimelinePath.length > 0) {
        NSString *imageLink = [NSString stringWithFormat:@"%@%@", URL_IMG_BASE, imgTimelinePath];
        [self.imgBackground sd_setImageWithURL:[NSURL URLWithString:imageLink]
                          placeholderImage:[UIImage imageNamed:@"images.jpg"]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     if (image) {
                                         
                                     } else {
                                         
                                     }
                                 }];
    }
    
    NSString *nameStr = [[NSUserDefaults standardUserDefaults] objectForKey:kName];
    _lblName.text = nameStr;
    [_lblName sizeToFit];
    
    CGRect lblNameFrame = _lblName.frame;
    lblNameFrame.origin.x = (SCREEN_WIDTH_PORTRAIT - lblNameFrame.size.width)/2;
    _lblName.frame = lblNameFrame;
    
    CGRect imgGenderFrame = _imgGender.frame;
    imgGenderFrame.origin.x = lblNameFrame.origin.x + lblNameFrame.size.width + 5;
    _imgGender.frame = imgGenderFrame;
    _imgGender.hidden = NO;
    [self bringSubviewToFront:_imgGender];
    
    int gender = [[[NSUserDefaults standardUserDefaults] objectForKey:kGender] intValue];
    if (gender == 0) {
        _imgGender.image = [UIImage imageNamed:female];
    } else {
        _imgGender.image = [UIImage imageNamed:male];
    }
    
    int birthdayInt = [[[NSUserDefaults standardUserDefaults] objectForKey:kBirthDay] intValue];
    
    NSDate* birthday = [SWUtil convertNumberToDate:birthdayInt];
    
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:birthday
                                       toDate:now
                                       options:0];
    NSInteger age = [ageComponents year];
    _lblAge.text = [NSString stringWithFormat:@"%d", (int)age];
}

- (IBAction)btnFriendTapped:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushToViewControllerUseDelegete:)]) {
        FriendsViewController *friendVC = [[FriendsViewController alloc] init];
        [self.delegate pushToViewControllerUseDelegete:friendVC];
    }
}

- (IBAction)btnPostNewsTapped:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushToViewControllerUseDelegete:)]) {
        KLPostNewsViewController *postNewsVC = [[KLPostNewsViewController alloc] init];
        [postNewsVC setType:status];
        postNewsVC.pageType = add;
        [self.delegate pushToViewControllerUseDelegete:postNewsVC];
    }
}
@end
