//
//  KLMyProfileViewController.m
//  KhoaLuan2015
//
//  Created by Mac on 3/17/15.
//  Copyright (c) 2015 Hung Vuong. All rights reserved.
//

#import "KLMyProfileViewController.h"

@interface KLMyProfileViewController ()

@end

@implementation KLMyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}

- (void)initUI {
    for (UIView *view in _imgIcons) {
        UIImageView *imageView = (UIImageView*)view;
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeCenter;
        imageView.layer.borderColor = [UIColor colorWithHex:Blue_Color alpha:1].CGColor;
        imageView.layer.borderWidth = 2;
        imageView.layer.cornerRadius = imageView.bounds.size.width/2;

    }
    
    _btnBack.layer.cornerRadius = _btnBack.bounds.size.width/2;
    _btnBack.clipsToBounds = YES;
    
    _btnSetting.layer.cornerRadius = _btnSetting.bounds.size.width/2;
    _btnSetting.clipsToBounds = YES;
    
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
    [self.view bringSubviewToFront:_imgGender];
    
    int gender = [[[NSUserDefaults standardUserDefaults] objectForKey:kGender] intValue];
    if (gender == 0) {
        _imgGender.image = [UIImage imageNamed:female];
    } else {
        _imgGender.image = [UIImage imageNamed:male];
    }
    
    int birthdayInt = (int)[[NSUserDefaults standardUserDefaults] integerForKey:kBirthDay];
    
    NSDate* birthday = [SWUtil convertNumberToDate:birthdayInt];
    
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:birthday
                                       toDate:now
                                       options:0];
    NSInteger age = [ageComponents year];
    _lblAge.text = [NSString stringWithFormat:@"%d", (int)age];
    
    NSString *aboutMe = [[NSUserDefaults standardUserDefaults] objectForKey:kAboutMe];
    _lblAboutMe.text = aboutMe;
    
    NSString *birthdayStr = [SWUtil convert:birthdayInt toDateStringWithFormat:DATE_FORMAT];
    _lblBirthday.text = birthdayStr;
    
    NSString *studentCode = [[NSUserDefaults standardUserDefaults] objectForKey:kStudentId];
    if (studentCode) {
        _lblStudentCode.text = studentCode;
    }
    
    NSString *faculty = [[NSUserDefaults standardUserDefaults] objectForKey:kFaculty];
    if (faculty) {
        _lblFaculty.text = faculty;
    }
}

- (IBAction)btnBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSettingTapped:(id)sender {
}
- (IBAction)btnChangeTimelineImageTapped:(id)sender {
    
}
- (IBAction)btnChangeAvatarTapped:(id)sender {
    
}
@end
