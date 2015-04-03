//
//  KLMyProfileViewController.h
//  KhoaLuan2015
//
//  Created by Mac on 3/17/15.
//  Copyright (c) 2015 Hung Vuong. All rights reserved.
//

#import "SWBaseViewController.h"

@interface KLMyProfileViewController : SWBaseViewController
@property (weak, nonatomic) IBOutlet UITextView *tvAboutMe;
@property (weak, nonatomic) IBOutlet UILabel *lblBirthday;
@property (weak, nonatomic) IBOutlet UILabel *lblStudentCode;
@property (weak, nonatomic) IBOutlet UILabel *lblFaculty;

@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAge;
@property (weak, nonatomic) IBOutlet UIView *avatarBgView;
@property (weak, nonatomic) IBOutlet UIImageView *imgGender;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imgIcons;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnSetting;
@property (strong, nonatomic) NSDictionary *userDict;

- (IBAction)btnBackTapped:(id)sender;
- (IBAction)btnSettingTapped:(id)sender;
- (IBAction)btnChangeTimelineImageTapped:(id)sender;
- (IBAction)btnChangeAvatarTapped:(id)sender;
@end
