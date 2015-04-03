//
//  MyPageHeaderView.m
//  SimpleWeather
//
//  Created by Mac on 3/2/15.
//  Copyright (c) 2015 HungVT. All rights reserved.
//

#import "MyPageHeaderView.h"
#import "KLPostNewsViewController.h"
#import "KLMyProfileViewController.h"

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
    if (_myPageType == MyPage) {
        CGPoint point = _btnImage.center;
        point.x = self.center.x;
        _btnImage.center = point;
        
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
        
        NSString *imgTimelinePath = EMPTY_IF_NULL_OR_NIL([[NSUserDefaults standardUserDefaults] objectForKey:kTimelineImage]);
        if (imgTimelinePath.length > 0) {
            NSString *imageLink = [NSString stringWithFormat:@"%@%@", URL_IMG_BASE, imgTimelinePath];
            [self.imgBackground sd_setImageWithURL:[NSURL URLWithString:imageLink]
                                  placeholderImage:[UIImage imageNamed:@"images.jpeg"]
                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                             if (image) {
                                                 
                                             } else {
                                                 
                                             }
                                         }];
        }
        
        _lblName.text = EMPTY_IF_NULL_OR_NIL([[NSUserDefaults standardUserDefaults] objectForKey:kName]);
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
    } else {
        NSString *imgAvatarPath = EMPTY_IF_NULL_OR_NIL([_userDict objectForKey:kAvatar]);
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
        
        NSString *imgTimelinePath = EMPTY_IF_NULL_OR_NIL([_userDict objectForKey:kTimelineImage]);
        if (imgTimelinePath.length > 0) {
            NSString *imageLink = [NSString stringWithFormat:@"%@%@", URL_IMG_BASE, imgTimelinePath];
            [self.imgBackground sd_setImageWithURL:[NSURL URLWithString:imageLink]
                                  placeholderImage:[UIImage imageNamed:@"images.jpeg"]
                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                             if (image) {
                                                 
                                             } else {
                                                 
                                             }
                                         }];
        }
        
        _lblName.text = EMPTY_IF_NULL_OR_NIL([_userDict objectForKey:kName]);
        [_lblName sizeToFit];
        
        CGRect lblNameFrame = _lblName.frame;
        lblNameFrame.origin.x = (SCREEN_WIDTH_PORTRAIT - lblNameFrame.size.width)/2;
        _lblName.frame = lblNameFrame;
        
        CGRect imgGenderFrame = _imgGender.frame;
        imgGenderFrame.origin.x = lblNameFrame.origin.x + lblNameFrame.size.width + 5;
        _imgGender.frame = imgGenderFrame;
        _imgGender.hidden = NO;
        [self bringSubviewToFront:_imgGender];
        
        int gender = [[_userDict objectForKey:kGender] intValue];
        if (gender == 0) {
            _imgGender.image = [UIImage imageNamed:female];
        } else {
            _imgGender.image = [UIImage imageNamed:male];
        }
        
        int birthdayInt = [[_userDict objectForKey:kBirthDay] intValue];
        
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
    }
    
    BOOL hideBackButton = [[NSUserDefaults standardUserDefaults] boolForKey:kHideBackButtonInUserPage];
    if (hideBackButton) {
        _btnBack.hidden = YES;
    } else {
        _btnBack.hidden = NO;
        _btnBack.layer.cornerRadius = _btnBack.bounds.size.width/2;
        _btnBack.clipsToBounds = YES;
    }
    
    self.backgroundColor = [UIColor colorWithHex:@"E3E3E3" alpha:1];
    
    _btnWriteNewPost.layer.borderWidth = 0;
    _btnWriteNewPost.layer.cornerRadius = 5;
    
    _imgAvatar.layer.cornerRadius = _imgAvatar.bounds.size.width / 2.0;
    _imgAvatar.layer.borderWidth = 1;
    _imgAvatar.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _imgAvatar.clipsToBounds = YES;
    
    _avatarBgView.layer.borderColor = [UIColor whiteColor].CGColor;
    _avatarBgView.layer.borderWidth = 1;
    _avatarBgView.layer.cornerRadius = _avatarBgView.bounds.size.width / 2.0;
}

- (void)configureAddFriendButton:(int)status {

    switch (status) {
        case 3:
        {
            [_btnAddFriend setImage:[UIImage imageNamed:@"Remove User Filled"] forState:UIControlStateNormal];
            _btnWriteNewPost.hidden = YES;
            _btnAddFriend.hidden = NO;
            _btnReject.hidden = YES;
            _btnAccept.hidden = YES;
            _btnImage.frame = CGRectMake(_btnUserInfor.bounds.size.width, 0, _btnImage.bounds.size.width, _btnImage.bounds.size.height);
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, 222);
            
            _friendState = RemoveFriend;
        }
            break;
        case 2:
        {
            _friendState = AcceptOrReject;
            _btnWriteNewPost.hidden = YES;
            _btnReject.hidden = NO;
            _btnAccept.hidden = NO;
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, 292);
            
            _btnAddFriend.hidden = YES;
            
            CGPoint point = _btnImage.center;
            point.x = self.center.x;
            _btnImage.center = point;
            
//            CGRect imgBtnFrame = _btnImage.frame;
//            imgBtnFrame.origin.x = (self.bounds.size.width - imgBtnFrame.size.width)/2;
//            _btnImage.frame = imgBtnFrame;

        }
            break;
        case 1:
        {
            _friendState = WaitConfirm;
            _btnWriteNewPost.hidden = YES;
            _btnAddFriend.hidden = NO;
            
            _btnImage.frame = CGRectMake(_btnUserInfor.bounds.size.width, 0, _btnImage.bounds.size.width, _btnImage.bounds.size.height);
            [_btnAddFriend setImage:[UIImage imageNamed:@"Add User Filled-Blue"] forState:UIControlStateNormal];
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, 222);
        }
            break;
        case 0:
        {
            _btnReject.hidden = YES;
            _btnAccept.hidden = YES;
            if (_myPageType == MyPage) {
                _btnWriteNewPost.hidden = NO;
                _btnAddFriend.hidden = YES;
                
                CGPoint point = _btnImage.center;
                point.x = self.center.x;
                _btnImage.center = point;
            } else {
                _friendState = AddFriend;
                [_btnAddFriend setImage:[UIImage imageNamed:@"Add User Filled"] forState:UIControlStateNormal];
                _btnWriteNewPost.hidden = YES;
                
                _btnAddFriend.hidden = NO;
                _btnImage.frame = CGRectMake(_btnUserInfor.bounds.size.width, 0, _btnImage.bounds.size.width, _btnImage.bounds.size.height);
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, 222);
            }
            
        }
            break;
        default:
            break;
    }
}

- (IBAction)btnAddFriendTapped:(id)sender {
    switch (_friendState) {
        case AddFriend:
        {
            [[SWUtil sharedUtil] showLoadingView];
            
            NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, uAddFriend];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
            
            NSString *myId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
            NSDictionary *parameters = @{@"user_id": myId,
                                         @"friend_id": _fUserId};
            
            [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *userDict = (NSDictionary*)responseObject;
                [self configureAddFriendButton:1];
                
                NSString *content = @" đã gửi lời mời kết bạn";
                [SWUtil postNotification:content forUser:_fUserId type:1];

                NSLog(@"Add friend JSON: %@", userDict);
                [[SWUtil sharedUtil] hideLoadingView];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                [SWUtil showConfirmAlert:@"Lỗi!" message:[error localizedDescription] delegate:nil];
                [[SWUtil sharedUtil] hideLoadingView];
            }];
        }
            break;
        case RemoveFriend:
        {
            [[SWUtil sharedUtil] showLoadingView];
            
            NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, uDeleteFriend];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
            
            NSString *myId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
            NSDictionary *parameters = @{@"user_id": myId,
                                         @"friend_id": _fUserId};
            
            [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *userDict = (NSDictionary*)responseObject;
                [self configureAddFriendButton:0];
                NSString *content = @" đã từ chối lời mời kết bạn";
                [SWUtil postNotification:content forUser:_fUserId type:0];
                NSLog(@"Reg JSON: %@", userDict);
                [[SWUtil sharedUtil] hideLoadingView];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                [SWUtil showConfirmAlert:@"Lỗi!" message:[error localizedDescription] delegate:nil];
                [[SWUtil sharedUtil] hideLoadingView];
            }];

        }
        default:
            break;
    }
}

- (IBAction)btnBackTapped:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(popViewControllerUseDelegate)]) {
        [self.delegate popViewControllerUseDelegate];
    }
}

- (IBAction)btnAcceptTapped:(id)sender {
    [[SWUtil sharedUtil] showLoadingView];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, uAcceptFriend];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    NSString *myId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
       NSDictionary *parameters = @{@"user_id": myId,
                                    @"friend_id": _fUserId};
   
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *userDict = (NSDictionary*)responseObject;
        [self configureAddFriendButton:3];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didAcceptOrRejectUser)]) {
            [self.delegate didAcceptOrRejectUser];
        }
        NSString *content = @" đã chấp nhận lời mời kết bạn";
        [SWUtil postNotification:content forUser:_fUserId type:0];
        
        NSLog(@"Reg JSON: %@", userDict);
        [[SWUtil sharedUtil] hideLoadingView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SWUtil showConfirmAlert:@"Lỗi!" message:[error localizedDescription] delegate:nil];
        [[SWUtil sharedUtil] hideLoadingView];
    }];
}

- (IBAction)btnRejectTapped:(id)sender {
    [[SWUtil sharedUtil] showLoadingView];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, uDeleteFriend];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    NSString *myId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
    NSDictionary *parameters = @{@"user_id": myId,
                                 @"friend_id": _fUserId};
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *userDict = (NSDictionary*)responseObject;
        [self configureAddFriendButton:0];
        NSLog(@"Reg JSON: %@", userDict);
        if (self.delegate && [self.delegate respondsToSelector:@selector(didAcceptOrRejectUser)]) {
            [self.delegate didAcceptOrRejectUser];
        }
        [[SWUtil sharedUtil] hideLoadingView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SWUtil showConfirmAlert:@"Lỗi!" message:[error localizedDescription] delegate:nil];
        [[SWUtil sharedUtil] hideLoadingView];
    }];
}

- (IBAction)btnFriendTapped:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushToViewControllerUseDelegete:withAnimation:)]) {
        FriendsViewController *friendVC = [[FriendsViewController alloc] init];
        friendVC.delegate = self;
        friendVC.userId = _fUserId;
        [self.delegate pushToViewControllerUseDelegete:friendVC withAnimation:YES];
    }
}

- (void)didBackToUserPage {
//    self.btnBack.hidden = YES;
    [_btnBack removeFromSuperview];
}

- (IBAction)btnPostNewsTapped:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushToViewControllerUseDelegete:withAnimation:)]) {
        KLPostNewsViewController *postNewsVC = [[KLPostNewsViewController alloc] init];
        [postNewsVC setType:status];
        postNewsVC.pageType = add;
        [self.delegate pushToViewControllerUseDelegete:postNewsVC withAnimation:YES];
    }
}

- (IBAction)btnShowInfoTapped:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushToViewControllerUseDelegete:withAnimation:)]) {
        KLMyProfileViewController *myProfileVC = [[KLMyProfileViewController alloc] init];
        
        if (!_userDict) {
            _userDict = [SWUtil getUserInfo];
        }
        myProfileVC.userDict =_userDict;
        [self.delegate pushToViewControllerUseDelegete:myProfileVC withAnimation:YES];
    }
}

@end
