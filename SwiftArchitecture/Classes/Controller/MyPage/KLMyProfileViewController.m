//
//  KLMyProfileViewController.m
//  KhoaLuan2015
//
//  Created by Mac on 3/17/15.
//  Copyright (c) 2015 Hung Vuong. All rights reserved.
//

#import "KLMyProfileViewController.h"
#import "SWRegisterViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface KLMyProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UIButton *btnChangeTimeLine;
@property (weak, nonatomic) IBOutlet UIImageView *imgFile;

- (IBAction)btnChangePasswordTapped:(id)sender;
- (IBAction)btnEditInfoTapped:(id)sender;
@end

@implementation KLMyProfileViewController {
    UIImagePickerController *imagePicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[SWUtil sharedUtil] hideLoadingView];
    [[SWUtil appDelegate] hideTabbar:NO];
    [self initUI];
}

- (void)initUI {
    _toolView.hidden = YES;
    
    BOOL hideBackButton = [[NSUserDefaults standardUserDefaults] boolForKey:kHideBackButtonInUserPage];
    if (hideBackButton) {
        _btnSetting.hidden = NO;
        _btnChangeTimeLine.hidden = NO;
        _imgFile.hidden = NO;
    } else {
        _btnSetting.hidden = YES;
        _btnChangeTimeLine.hidden = YES;
        _imgFile.hidden = YES;
    }
    
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
    
    NSString *nameStr = EMPTY_IF_NULL_OR_NIL([_userDict objectForKey:kName]);
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
    
    NSString *aboutMe = EMPTY_IF_NULL_OR_NIL([_userDict objectForKey:kAboutMe]);
    _tvAboutMe.text = aboutMe;
    
    NSString *birthdayStr = [SWUtil convert:birthdayInt toDateStringWithFormat:DATE_FORMAT];
    _lblBirthday.text = birthdayStr;
    
    NSString *studentCode = EMPTY_IF_NULL_OR_NIL([_userDict objectForKey:kStudentId]);
    if (studentCode) {
        _lblStudentCode.text = studentCode;
    }
    
    NSString *faculty = EMPTY_IF_NULL_OR_NIL([_userDict objectForKey:kFaculty]);
    if (faculty) {
        _lblFaculty.text = faculty;
    }
}

- (IBAction)btnBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSettingTapped:(id)sender {
    if (_toolView.hidden) {
        [self showView:_toolView];
    } else {
        [self hiddenView:_toolView];
    }
}
- (IBAction)btnChangeTimelineImageTapped:(id)sender {
    [self choosePhotoFromLibrary];
}
- (IBAction)btnChangeAvatarTapped:(id)sender {
    
}
- (IBAction)btnChangePasswordTapped:(id)sender {
    [self hiddenView:_toolView];
    SWRegisterViewController *registerVC = [[SWRegisterViewController alloc] initWithNibName:@"SWRegisterViewController" bundle:nil];
    registerVC.typeUser = change_password;
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (IBAction)btnEditInfoTapped:(id)sender {
    [self hiddenView:_toolView];
    SWRegisterViewController *registerVC = [[SWRegisterViewController alloc] initWithNibName:@"SWRegisterViewController" bundle:nil];
    registerVC.typeUser = edit_info;
    
    registerVC.birthdayString = _lblBirthday.text;
    NSNumber *birthdayInt = [_userDict objectForKey:kBirthDay];
    registerVC.birthday = birthdayInt;
    registerVC.avatarImage = _imgAvatar.image;
    registerVC.didPickImage = YES;
    int gender = [[_userDict objectForKey:kGender] intValue];
    registerVC.gender = gender;
    registerVC.faculty = _lblFaculty.text;
    registerVC.studentId = _lblStudentCode.text;
    
    NSString *email = EMPTY_IF_NULL_OR_NIL([_userDict objectForKey:kEmail]);
    registerVC.email = email;
    registerVC.userName = email;
    registerVC.aboutMe = _tvAboutMe.text;
    
    registerVC.name = _lblName.text;
    
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)choosePhotoFromLibrary
{
    if (!imagePicker) {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    // define the block to call when we get the asset based on the url (below)
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
    {
        ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
//        NSLog(@"[imageRep filename] : %@", [imageRep filename]);
        
        [[SWUtil sharedUtil] showLoadingView];
        NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, uUpdateTimelineImage];
        
        NSString *userId = [_userDict objectForKey:kUserId];
        NSDictionary *parameters = @{@"user_id"  : userId};
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
        NSData *imageData = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerEditedImage], 1);
        
        AFHTTPRequestOperation *op = [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //do not put image inside parameters dictionary as I did, but append it!
            [formData appendPartWithFileData:imageData name:@"timeline_image" fileName:[imageRep filename] mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.imgBackground.image = [info objectForKey:UIImagePickerControllerEditedImage];
            
            //NSDictionary *userDict = (NSDictionary*)responseObject;
            //[[NSUserDefaults standardUserDefaults] setObject:EMPTY_IF_NULL_OR_NIL([userDict objectForKey:kTimelineImage]) forKey:kTimelineImage];
            [[SWUtil sharedUtil] hideLoadingView];
            NSLog(@"upload succes");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //[SWUtil showConfirmAlertWithMessage:@"Lỗi!" delegate:nil];
            [[SWUtil sharedUtil] hideLoadingView];
        }];
        
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.imgBackground.image = [info objectForKey:UIImagePickerControllerEditedImage];
            
            NSDictionary *dict = (NSDictionary*)responseObject;
            NSInteger userId = [[dict objectForKey:kUserId] integerValue];
            
            NSInteger myUserId = [[NSUserDefaults standardUserDefaults] integerForKey:kUserId];
            if (myUserId == userId) {
                [[NSUserDefaults standardUserDefaults] setObject:EMPTY_IF_NULL_OR_NIL([dict objectForKey:kTimelineImage]) forKey:kTimelineImage];
            }
            
            [[SWUtil sharedUtil] hideLoadingView];
            NSLog(@"upload succes");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SWUtil showConfirmAlertWithMessage:[error localizedDescription] delegate:nil];
            [[SWUtil sharedUtil] hideLoadingView];
            NSLog(@"upload failed");
        }];
        
        [op setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                            long long totalBytesWritten,
                                            long long totalBytesExpectedToWrite) {
            //NSLog(@"Wrote %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
            float progress = ((float)totalBytesWritten) / totalBytesExpectedToWrite * 100;
            [[SWUtil sharedUtil] showLoadingViewWithTitle:[NSString stringWithFormat:@"Tải lên %.2f%%", progress]];
            
            if (progress == 100.00) {
                [[SWUtil sharedUtil] hideLoadingView];
            }
        }];
        [op start];
    };
    
    // get the asset library and fetch the asset based on the ref url (pass in block above)
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:refURL resultBlock:resultblock failureBlock:nil];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)showView:(UIView*)view{
    
    [view setAlpha:0.0f];
    view.hidden = NO;
    
    [UIView animateWithDuration:0.6f animations:^{
        
        [view setAlpha:1];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hiddenView:(UIView*)view {
    
    [view setAlpha:1];
    
    [UIView animateWithDuration:0.6f animations:^{
        
        [view setAlpha:0.0f];
    } completion:^(BOOL finished) {
        
        view.hidden = YES;
    }];
}
@end
