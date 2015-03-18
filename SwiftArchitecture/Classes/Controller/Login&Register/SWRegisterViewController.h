//
//  SWRegisterViewController.h
//  KhoaLuan2015
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Hung VT. All rights reserved.
//

#import "SWBaseViewController.h"

@interface SWRegisterViewController : SWBaseViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (assign, nonatomic) UserType typeUser;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *repassword;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *birthdayString;
@property (assign, nonatomic) NSInteger gender;
@property (strong, nonatomic) NSString *faculty;
@property (strong, nonatomic) NSString *studentId;
@property (strong, nonatomic) NSString *aboutMe;
@property (strong, nonatomic) UIImage *avatarImage;
@property (strong, nonatomic) NSNumber *birthday;
@property (assign, nonatomic) BOOL didPickImage;
@property (strong, nonatomic) NSString *oldPassword;
@end
