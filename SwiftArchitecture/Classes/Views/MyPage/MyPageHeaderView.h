//
//  MyPageHeaderView.h
//  SimpleWeather
//
//  Created by Mac on 3/2/15.
//  Copyright (c) 2015 HungVT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    AddFriend = 0,
    WaitConfirm,
    AcceptOrReject,
    RemoveFriend
} FriendState;

@protocol MyPageHeaderViewDelegate <NSObject>
@optional
- (void)pushToViewControllerUseDelegete:(UIViewController *)viewController withAnimation:(BOOL)animation;
- (void)popViewControllerUseDelegate;
- (void)didAcceptOrRejectUser;
@end

@interface MyPageHeaderView : UITableViewCell
@property (nonatomic, weak) id <MyPageHeaderViewDelegate> delegate;
@property (assign, nonatomic) MyPageType myPageType;
@property (assign, nonatomic) FriendState friendState;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAge;
@property (weak, nonatomic) IBOutlet UIButton *btnWriteNewPost;
@property (weak, nonatomic) IBOutlet UIView *avatarBgView;
@property (weak, nonatomic) IBOutlet UIImageView *imgGender;
@property (weak, nonatomic) IBOutlet UIButton *btnAddFriend;
@property (weak, nonatomic) IBOutlet UIButton *btnImage;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) NSString *fUserId;
@property (weak, nonatomic) IBOutlet UIButton *btnUserInfor;
@property (weak, nonatomic) IBOutlet UIButton *btnReject;
@property (weak, nonatomic) IBOutlet UIButton *btnAccept;

- (IBAction)btnFriendTapped:(id)sender;
- (IBAction)btnPostNewsTapped:(id)sender;
- (IBAction)btnShowInfoTapped:(id)sender;
- (IBAction)btnRejectTapped:(id)sender;
- (void)initUI;
- (IBAction)btnBackTapped:(id)sender;
- (IBAction)btnAcceptTapped:(id)sender;
- (void)configureAddFriendButton:(int)status;
- (IBAction)btnAddFriendTapped:(id)sender;
@end
