//
//  MyPageHeaderView.h
//  SimpleWeather
//
//  Created by Mac on 3/2/15.
//  Copyright (c) 2015 HungVT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyPageHeaderViewDelegate <NSObject>
@optional
- (void)pushToViewControllerUseDelegete:(UIViewController *)viewController;
@end

@interface MyPageHeaderView : UITableViewCell
@property (nonatomic, weak) id <MyPageHeaderViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic) IBOutlet UIButton *btnSetting;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAge;
@property (weak, nonatomic) IBOutlet UIButton *btnWriteNewPost;
@property (weak, nonatomic) IBOutlet UIView *avatarBgView;
@property (weak, nonatomic) IBOutlet UIView *avatarContentBgView;
@property (weak, nonatomic) IBOutlet UIImageView *imgGender;

- (IBAction)btnFriendTapped:(id)sender;
- (IBAction)btnPostNewsTapped:(id)sender;
@end
