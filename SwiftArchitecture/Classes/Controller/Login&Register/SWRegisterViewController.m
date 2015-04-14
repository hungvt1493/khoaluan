//
//  SWRegisterViewController.m
//  KhoaLuan2015
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Hung VT. All rights reserved.
//

#import "SWRegisterViewController.h"
#import "KLRegisterTableViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define CONTENT_VIEW_Y 20
#define Register_Arr @[@"Ảnh đại diện",@"Email\n(Tên đăng nhập)",@"Tên",@"Giới tính",@"Ngày sinh",@"Mã sinh viên",@"Khoa",@"Giới thiệu bản thân",@"Mật khẩu",@"Nhắc lại mật khẩu"]
#define Edit_Arr @[@"Ảnh đại diện",@"Tên",@"Giới tính",@"Ngày sinh",@"Mã sinh viên",@"Khoa",@"Giới thiệu bản thân"]
#define ChangePass_Arr @[@"Mật khẩu cũ",@"Mật khẩu mới",@"Nhắc lại mật khẩu"]

#define RegAvatar 0
#define RegEmail 1
#define RegName 2
#define RegGender 3
#define RegBirthday 4
#define RegStudent_id 5
#define RegFaculty 6
#define RegAboutMe 7
#define RegPassword 8
#define RegRePassword 9

#define EditAvatar 0
#define EditName 1
#define EditGender 2
#define EditBirthday 3
#define EditStudent_id 4
#define EditFaculty 5
#define EditAboutMe 6

#define ChangeOldPassword 0
#define ChangePassword 1
#define ChangeRePassword 2

@interface SWRegisterViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>
{
    UIButton *maleButton;
    UIButton *femaleButton;
    UITextField *registerTextField;
    UIImagePickerController *imagePicker;
    NSString *avatarImageStr;
}

@property (strong, nonatomic) NSArray *registerArray;
@property (weak, nonatomic) IBOutlet UITableView *registerTableView;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIView *datePickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)hiddenDatePickerButtonTapped:(id)sender;
- (IBAction)completedDateButtonTapped:(id)sender;
- (IBAction)registerButtonTapped:(id)sender;

@end

@implementation SWRegisterViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[SWUtil appDelegate] hideTabbar:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    switch (self.typeUser) {
        case register_new:
        {
            if (SYSTEM_VERSION >= 8) {
                [[UINavigationBar appearance] setTranslucent:NO];
                [[UINavigationBar appearance] setTintColor:[UIColor colorWithHex:Blue_Color alpha:1]];
                [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHex:Blue_Color alpha:1]}];
            } else {
                [self.navigationController.navigationBar setTranslucent:NO];
                self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:Blue_Color alpha:1];
                [self.navigationController.navigationBar
                 setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHex:Blue_Color alpha:1]}];
            }
        }
            break;
        default:
        {
            if (SYSTEM_VERSION >= 8) {
                [[UINavigationBar appearance] setTranslucent:NO];
                [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
                [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
            } else {
                [self.navigationController.navigationBar setTranslucent:NO];
                self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
                [self.navigationController.navigationBar
                 setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
            }
        }
            break;
    }
    
    [self initData];
    [self initUI];
}

- (void)initUI {
    self.navigationController.navigationBarHidden = NO;
    self.datePickerView.hidden = YES;
    self.datePickerView.alpha = 0;
    
    switch (self.typeUser) {
        case register_new:
        {
            [self setBackButtonWithImage:back_bar_button_blue highlightedImage:nil target:self action:@selector(backButtonTapped:)];
            self.title = Register_Title;
            [self.registerButton setTitle:Register_Title forState:UIControlStateNormal];
            _gender = 1;
            _didPickImage = NO;
        }
            break;
        case edit_info:
        {
            [self setBackButtonWithImage:back_bar_button highlightedImage:nil target:self action:@selector(backButtonTapped:)];
            self.title = InforUser_Title;
            [self.registerButton setTitle:Complete_Button forState:UIControlStateNormal];
        }
            break;
        case change_password:
        {
            [self setBackButtonWithImage:back_bar_button highlightedImage:nil target:self action:@selector(backButtonTapped:)];
            self.title = Change_Password_Title;
            [self.registerButton setTitle:Complete_Button forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (void)initData{
    switch (self.typeUser) {
        case register_new:
            self.registerArray = Register_Arr;
            break;
        case edit_info:
            self.registerArray = Edit_Arr;
            break;
        case change_password:
            self.registerArray = ChangePass_Arr;
            break;
        default:
            break;
    }
}

- (void)backButtonTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)hiddenDatePickerButtonTapped:(id)sender {
    
    [UIView animateWithDuration:.3 animations:^{
        
        self.datePickerView.alpha = 0;
    } completion:^(BOOL finished) {
        
        self.datePickerView.hidden = YES;
    }];
}

- (IBAction)completedDateButtonTapped:(id)sender {
    
    [UIView animateWithDuration:.3 animations:^{
        
        self.datePickerView.alpha = 0;
    } completion:^(BOOL finished) {
        
        self.datePickerView.hidden = YES;
    }];
    
    NSString *_dateString;
    NSDate *_chosenDate = [self.datePicker date];
    NSDateFormatter *_dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:DATE_FORMAT];
    _dateString = [_dateFormatter stringFromDate:_chosenDate];
    
    _birthdayString = _dateString;
    NSIndexPath *indexPath;
    switch (self.typeUser) {
        case register_new:
            indexPath = [NSIndexPath indexPathForRow:RegBirthday inSection:0];
            break;
        case edit_info:
            indexPath = [NSIndexPath indexPathForRow:EditBirthday inSection:0];
            break;
        default:
            break;
    }
    
    
    _birthday = [SWUtil convertDateToNumber:_chosenDate];
    
    [self.registerTableView beginUpdates];
    [self.registerTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.registerTableView endUpdates];
}

- (IBAction)registerButtonTapped:(id)sender {
    NSString *errorMessage = [self validateForm];
    if (errorMessage) {
        [[[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        return;
    }
    
    [[SWUtil sharedUtil] showLoadingView];
    NSDictionary *parameters;
    switch (self.typeUser) {
        case change_password:
        {
            [[SWUtil sharedUtil] showLoadingView];
            NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, uUpdatePassword];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
            NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
            NSDictionary *parameters = @{@"old_password"        : NULL_IF_NIL(_oldPassword),
                                         @"password"            : NULL_IF_NIL(_password),
                                         @"user_id"             : userId};
            
            [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *dict = (NSDictionary*)responseObject;
                [[SWUtil sharedUtil] hideLoadingView];
                NSInteger code = [[dict objectForKey:@"code"] integerValue];
                if (code == 0) {
                    [SWUtil showConfirmAlert:@"Lỗi!" message:[dict objectForKey:@"message"] delegate:nil];
                }
                
                if (code == 1) {
                    [SWUtil showConfirmAlertWithMessage:@"Thành công" delegate:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
                if (code == 3) {
                    NSString *mesage = [dict objectForKey:@"message"];
                    [SWUtil showConfirmAlertWithMessage:mesage delegate:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }

                NSLog(@"POST NEWS JSON: %@", dict);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                [SWUtil showConfirmAlert:@"Lỗi!" message:[error localizedDescription] delegate:nil];
                [[SWUtil sharedUtil] hideLoadingView];
            }];
        }
            break;
            
        default:
        {
            NSString *url = @"";
            if (self.typeUser == register_new) {
                url = [NSString stringWithFormat:@"%@%@", URL_BASE, uReg];
            } else {
                url = [NSString stringWithFormat:@"%@%@", URL_BASE, uUpdate];
            }
            
            if (_avatarImage && avatarImageStr) {
                if (self.typeUser == register_new) {
                    parameters = @{@"username": _email,
                                   @"password": _password,
                                   @"email"   : _email,
                                   @"name"    : _name,
                                   @"birthday": NULL_IF_NIL(_birthday),
                                   @"gender"  : [NSNumber numberWithInteger:_gender],
                                   @"faculty" : NULL_IF_NIL(_faculty),
                                   @"student_id" : NULL_IF_NIL(_studentId),
                                   @"about_me" : NULL_IF_NIL(_aboutMe)};
                } else if (self.typeUser == edit_info) {
                    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
                    parameters = @{@"user_id"    : userId,
                                   @"name"    : _name,
                                   @"birthday": NULL_IF_NIL(_birthday),
                                   @"gender"  : [NSNumber numberWithInteger:_gender],
                                   @"faculty" : NULL_IF_NIL(_faculty),
                                   @"student_id" : NULL_IF_NIL(_studentId),
                                   @"about_me" : NULL_IF_NIL(_aboutMe)};
                }
                
                AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
                
                NSData *imageData = UIImageJPEGRepresentation(_avatarImage, 0.5);
                
                AFHTTPRequestOperation *op = [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

                    [formData appendPartWithFileData:imageData name:@"avatar" fileName:avatarImageStr mimeType:@"image/jpeg"];
                } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *userDict = (NSDictionary*)responseObject;
                    
                    NSInteger code = [[userDict objectForKey:@"code"] integerValue];
                    if (code == 0 && userDict.count <= 2) {
                        [self performSelector:@selector(popViewController) withObject:nil afterDelay:1.0 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
                    } else {
                        [SWUtil saveUserInfo:userDict];
                        //                        [SWUtil showConfirmAlertWithMessage:@"Thành công" delegate:nil];
                        [[SWUtil sharedUtil] showLoadingViewWithTitle:@"Thành công"];
                        [self performSelector:@selector(popViewController) withObject:nil afterDelay:1.0 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
                    }

                    
                    NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                    [SWUtil showConfirmAlert:[error localizedDescription] message:[error localizedDescription] delegate:nil];
                    [[SWUtil sharedUtil] hideLoadingView];
                }];
                [op start];
                
            } else {
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
                manager.requestSerializer = [AFJSONRequestSerializer serializer];
                if (self.typeUser == register_new) {
                    parameters = @{@"username": _email,
                                   @"password": _password,
                                   @"email"   : _email,
                                   @"name"    : _name,
                                   @"birthday": NULL_IF_NIL(_birthday),
                                   @"gender"  : [NSNumber numberWithInteger:_gender],
                                   @"faculty" : NULL_IF_NIL(_faculty),
                                   @"student_id" : NULL_IF_NIL(_studentId),
                                   @"about_me" : NULL_IF_NIL(_aboutMe)};
                } else if (self.typeUser == edit_info) {
                    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
                    parameters = @{@"user_id"    : userId,
                                   @"name"    : _name,
                                   @"birthday": NULL_IF_NIL(_birthday),
                                   @"gender"  : [NSNumber numberWithInteger:_gender],
                                   @"faculty" : NULL_IF_NIL(_faculty),
                                   @"student_id" : NULL_IF_NIL(_studentId),
                                   @"about_me" : NULL_IF_NIL(_aboutMe)};
                }
                
                [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *userDict = (NSDictionary*)responseObject;
                    
                    NSInteger code = [[userDict objectForKey:@"code"] integerValue];
                    if (code == 0 && userDict.count <= 2) {
                        [self performSelector:@selector(popViewController) withObject:nil afterDelay:1.0 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
                    } else {
                        [SWUtil saveUserInfo:userDict];                        
//                        [SWUtil showConfirmAlertWithMessage:@"Thành công" delegate:nil];
                        [[SWUtil sharedUtil] showLoadingViewWithTitle:@"Thành công"];
                       [self performSelector:@selector(popViewController) withObject:nil afterDelay:1.0 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
                    }
                    
                    NSLog(@"Reg JSON: %@", userDict);
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                    [SWUtil showConfirmAlert:[error localizedDescription] message:[error localizedDescription] delegate:nil];
                    [[SWUtil sharedUtil] hideLoadingView];
                }];
                
            }

        }
            break;
    }
}

- (void)popViewController {
     [self.navigationController popViewControllerAnimated:YES];
    [[SWUtil sharedUtil] hideLoadingView];
}

- (void)maleButtonTapped:(id)sender{
    [self setButton:femaleButton andBackground:Button_bg andTitleColor:Black_Color];
    [self setButton:maleButton andBackground:Blue_Color andTitleColor:White_Color];
    
    _gender = 1;
}

- (void)femaleButtonTapped:(id)sender{
    [self setButton:maleButton andBackground:Button_bg andTitleColor:Black_Color];
    [self setButton:femaleButton andBackground:Blue_Color andTitleColor:White_Color];
    _gender = 0;
}

- (void)setButton:(UIButton *)button andBackground:(NSString *)bg andTitleColor:(NSString *)title{
    [button setTitleColor:[UIColor colorWithHex:title alpha:1.0] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithHex:bg alpha:1.0]];
}

- (BOOL)isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (BOOL)isValidTelephoneNumber:(NSString *)phoneNumber{
    NSString *phoneRegex = @"^((\\+)|(0))[0-9]{6,14}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phoneNumber];
}

- (BOOL)isValidPassword:(NSString *)passWord {
    return (passWord.length >= 6);
}

- (BOOL)isValidName:(NSString *)nameStr {
    
    if (nameStr.length == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (NSString *)validateForm {
    NSString *errorMessage;
    NSString *passWord;
    
    for (int i = 0; i < self.registerArray.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        KLRegisterTableViewCell *cell = (KLRegisterTableViewCell*)[self.registerTableView cellForRowAtIndexPath:indexPath];
        
        for (UIView *subview in cell.contentView.subviews) {
            if ([subview isKindOfClass:[UITextField class]]) {
                UITextField *tf = (UITextField*)subview;
                NSString *text = tf.text;
                switch (self.typeUser) {
                    case register_new:
                    {
                        switch (tf.tag) {
                            case RegName:
                            {
                                if (![self isValidName:text]) {
                                    errorMessage = Name_Message;
                                }
                            }
                                break;
                                
                            case RegEmail:
                            {
                                if (text.length > 0) {
                                    if (![self isValidEmail:text ]) {
                                        errorMessage = Email_Message;
                                    }
                                } else {
                                    errorMessage = Email_Require_Message;
                                }
                                
                            }
                                break;
                            case RegPassword:
                            {
                                passWord = text;
                                if (![self isValidPassword:text]) {
                                    errorMessage = Password_Message;
                                }
                            }
                                break;
                            case RegRePassword:
                            {
                                if (![text isEqualToString:passWord]) {
                                    errorMessage = Re_Password_Message;
                                }
                            }
                                break;
                            default:
                                break;
                        }
                        
                    }
                        break;
                    case edit_info:
                    {
                        if (tf.tag == EditName) {
                            if (![self isValidName:text]) {
                                errorMessage = Name_Message;
                            }
                        }
                    }
                        break;
                    case change_password:
                        {
                            switch (tf.tag) {
                                case ChangeOldPassword:
                                {
                                    if (![self isValidName:text]) {
                                        errorMessage = Old_Password_Message;
                                    }
                                }
                                    break;
                                case ChangePassword:
                                {
                                    passWord = text;
                                    if (![self isValidPassword:text]) {
                                        errorMessage = Password_Message;
                                    }
                                }
                                    break;
                                case ChangeRePassword:
                                {
                                    if (![text isEqualToString:passWord]) {
                                        errorMessage = Re_Password_Message;
                                    }
                                }
                                    break;
                                default:
                                    break;
                            }
                        }
                            break;
                    default:
                        break;
                }
                break;
            }
            
            if (errorMessage.length > 0) {
                return errorMessage;
            }
        }
    }
    
    
    return errorMessage;
}

#pragma mark - TableView

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.registerArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell-Index%ld",(long)indexPath.row];
    switch (self.typeUser) {
        case register_new:
        {
            if (indexPath.row == RegAvatar) {
                UITableViewCell *cellDefault = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cellDefault) {
                    
                    cellDefault = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cellDefault.textLabel.text = [self.registerArray objectAtIndex:indexPath.row];
                    cellDefault.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                if (_didPickImage) {
                    cellDefault.imageView.image = _avatarImage;
                } else {
                    cellDefault.imageView.image = [UIImage imageNamed:@"default-avatar"];
                }
                cellDefault.separatorInset = UIEdgeInsetsZero;
                return cellDefault;
            } else {
                KLRegisterTableViewCell *cell = (KLRegisterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell) {
                    [tableView registerNib:[UINib nibWithNibName:@"KLRegisterTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
                    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                }
                
                switch (indexPath.row) {
                        
                    case RegEmail:
                    {
                        cell.lblTitle.font = [UIFont systemFontOfSize:15];
                        cell.tfInput.text = _email;
                    }
                        break;
                    case RegName:
                    {
                        cell.tfInput.text = _name;
                    }
                        break;
                    case RegGender:
                    {
                        cell.tfInput.enabled = NO;
                        cell.tfInput.hidden = YES;
                        maleButton = [UIButton buttonWithType:UIButtonTypeSystem];
                        [maleButton addTarget:self
                                       action:@selector(maleButtonTapped:)
                             forControlEvents:UIControlEventTouchUpInside];
                        [maleButton setTitle:@"Nam" forState:UIControlStateNormal];
                        maleButton.layer.masksToBounds = YES;
                        maleButton.layer.cornerRadius = 5.0;
                        [self setButton:maleButton andBackground:@"EAEAEA" andTitleColor:@"000000"];
                        maleButton.frame = CGRectMake(120.0, 6, 80, 30.0);
                        [cell addSubview:maleButton];
                        
                        femaleButton = [UIButton buttonWithType:UIButtonTypeSystem];
                        [femaleButton addTarget:self
                                         action:@selector(femaleButtonTapped:)
                               forControlEvents:UIControlEventTouchUpInside];
                        [femaleButton setTitle:@"Nữ" forState:UIControlStateNormal];
                        femaleButton.layer.masksToBounds = YES;
                        femaleButton.layer.cornerRadius = 5.0;
                        [self setButton:femaleButton andBackground:@"EAEAEA" andTitleColor:@"000000"];
                        femaleButton.frame = CGRectMake(210.0, 6, 80, 30.0);
                        [cell addSubview:femaleButton];
                        
                        if (_gender == 0) {
                            [self femaleButtonTapped:nil];
                        } else {
                            [self maleButtonTapped:nil];
                        }
                        
                    }
                        break;
                    case RegBirthday:
                    {
                        cell.tfInput.enabled = NO;
                        cell.tfInput.hidden = YES;
                        UILabel *birthdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 7, 160, 30)];
                        birthdayLabel.text = _birthdayString;
                        birthdayLabel.textAlignment = NSTextAlignmentRight;
                        cell.accessoryView = birthdayLabel;
                    }
                        break;
                    case RegAboutMe:
                    {
                        //            cell.lblTitle.font = [UIFont systemFontOfSize:15];
                        cell.tvInput.hidden = NO;
                        cell.tfInput.hidden = YES;
                        cell.tvInput.layer.borderColor = [UIColor blackColor].CGColor;
                        cell.tvInput.layer.borderWidth = 1;
                        cell.tvInput.delegate = self;
                        [cell setHeightForCell:80];
                        cell.tfInput.text = _aboutMe;
                        cell.tvInput.text = _aboutMe;
                    }
                        break;
                    case RegPassword:
                    {
                        cell.tfInput.secureTextEntry = YES;
                        cell.tfInput.text = _password;
                    }
                    case RegRePassword:
                    {
                        cell.lblTitle.font = [UIFont systemFontOfSize:14];
                        cell.tfInput.secureTextEntry = YES;
                        cell.tfInput.text = _repassword;
                    }
                        break;
                    case RegStudent_id:
                    {
                        cell.tfInput.text = _studentId;
                    }
                        break;
                    case RegFaculty:
                    {
                        cell.tfInput.text = _faculty;
                    }
                        break;
                    default:
                        break;
                }
                
                cell.lblTitle.text = [self.registerArray objectAtIndex:indexPath.row];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.tfInput.delegate = self;
                cell.tfInput.tag = indexPath.row;
                
                [cell.tfInput addTarget:self
                                 action:@selector(textFieldDidChange:)
                       forControlEvents:UIControlEventEditingChanged];
                
                return cell;
            }

        }
            break;
        case edit_info:
        {
            if (indexPath.row == EditAvatar) {
                UITableViewCell *cellDefault = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cellDefault) {
                    
                    cellDefault = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cellDefault.textLabel.text = [self.registerArray objectAtIndex:indexPath.row];
                    cellDefault.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                if (_didPickImage) {
                    cellDefault.imageView.image = _avatarImage;
                } else {
                    cellDefault.imageView.image = [UIImage imageNamed:@"default-avatar"];
                }
                cellDefault.separatorInset = UIEdgeInsetsZero;
                return cellDefault;
            } else {
                KLRegisterTableViewCell *cell = (KLRegisterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell) {
                    [tableView registerNib:[UINib nibWithNibName:@"KLRegisterTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
                    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                }
                
                switch (indexPath.row) {
                    case EditName:
                    {
                        cell.tfInput.text = _name;
                    }
                        break;
                    case EditGender:
                    {
                        cell.tfInput.enabled = NO;
                        cell.tfInput.hidden = YES;
                        maleButton = [UIButton buttonWithType:UIButtonTypeSystem];
                        [maleButton addTarget:self
                                       action:@selector(maleButtonTapped:)
                             forControlEvents:UIControlEventTouchUpInside];
                        [maleButton setTitle:@"Nam" forState:UIControlStateNormal];
                        maleButton.layer.masksToBounds = YES;
                        maleButton.layer.cornerRadius = 5.0;
                        [self setButton:maleButton andBackground:@"EAEAEA" andTitleColor:@"000000"];
                        maleButton.frame = CGRectMake(120.0, 6, 80, 30.0);
                        [cell addSubview:maleButton];
                        
                        femaleButton = [UIButton buttonWithType:UIButtonTypeSystem];
                        [femaleButton addTarget:self
                                         action:@selector(femaleButtonTapped:)
                               forControlEvents:UIControlEventTouchUpInside];
                        [femaleButton setTitle:@"Nữ" forState:UIControlStateNormal];
                        femaleButton.layer.masksToBounds = YES;
                        femaleButton.layer.cornerRadius = 5.0;
                        [self setButton:femaleButton andBackground:@"EAEAEA" andTitleColor:@"000000"];
                        femaleButton.frame = CGRectMake(210.0, 6, 80, 30.0);
                        [cell addSubview:femaleButton];
                        
                        if (_gender == 0) {
                            [self femaleButtonTapped:nil];
                        } else {
                            [self maleButtonTapped:nil];
                        }
                        
                    }
                        break;
                    case EditBirthday:
                    {
                        cell.tfInput.enabled = NO;
                        cell.tfInput.hidden = YES;
                        UILabel *birthdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 7, 160, 30)];
                        birthdayLabel.text = _birthdayString;
                        birthdayLabel.textAlignment = NSTextAlignmentRight;
                        cell.accessoryView = birthdayLabel;
                    }
                        break;
                    case EditAboutMe:
                    {
                        //            cell.lblTitle.font = [UIFont systemFontOfSize:15];
                        cell.tvInput.hidden = NO;
                        cell.tfInput.hidden = YES;
                        cell.tvInput.layer.borderColor = [UIColor blackColor].CGColor;
                        cell.tvInput.layer.borderWidth = 1;
                        cell.tvInput.delegate = self;
                        [cell setHeightForCell:80];
                        cell.tfInput.text = _aboutMe;
                        cell.tvInput.text = _aboutMe;
                    }
                        break;
                    case EditStudent_id:
                    {
                        cell.tfInput.text = _studentId;
                    }
                        break;
                    case EditFaculty:
                    {
                        cell.tfInput.text = _faculty;
                    }
                        break;
                    default:
                        break;
                }
                
                cell.lblTitle.text = [self.registerArray objectAtIndex:indexPath.row];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.tfInput.delegate = self;
                cell.tfInput.tag = indexPath.row;
                
                [cell.tfInput addTarget:self
                                 action:@selector(textFieldDidChange:)
                       forControlEvents:UIControlEventEditingChanged];
                
                return cell;
            }
        }
            break;
        case change_password:
        {
            KLRegisterTableViewCell *cell = (KLRegisterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                [tableView registerNib:[UINib nibWithNibName:@"KLRegisterTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            }
            
            switch (indexPath.row) {
                case ChangeOldPassword:
                {
                    cell.tfInput.secureTextEntry = YES;
                    cell.tfInput.text = _oldPassword;
                }
                case ChangePassword:
                {
                    cell.tfInput.secureTextEntry = YES;
                    cell.tfInput.text = _password;
                }
                case ChangeRePassword:
                {
                    cell.lblTitle.font = [UIFont systemFontOfSize:14];
                    cell.tfInput.secureTextEntry = YES;
                    cell.tfInput.text = _repassword;
                }
                    break;

                default:
                    break;
            }
            
            cell.lblTitle.text = [self.registerArray objectAtIndex:indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.tfInput.delegate = self;
            cell.tfInput.tag = indexPath.row;
            
            [cell.tfInput addTarget:self
                             action:@selector(textFieldDidChange:)
                   forControlEvents:UIControlEventEditingChanged];
            
            return cell;

        }
            break;
        default:
            return nil;
            break;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.typeUser) {
        case register_new:
        {
            if (indexPath.row == RegAvatar) {
                [self choosePhotoFromLibrary];
            }
            
            if (indexPath.row == RegBirthday) {
                if (self.datePickerView.hidden) {
                    [self.view endEditing:YES];
                    self.datePickerView.hidden = NO;
                    [UIView animateWithDuration:.3 animations:^{
                        
                        self.datePickerView.alpha = 1;
                    } completion:^(BOOL finished) {}];
                }
                else {
                    
                    [UIView animateWithDuration:.3 animations:^{
                        
                        self.datePickerView.alpha = 0;
                    } completion:^(BOOL finished) {
                        
                        self.datePickerView.hidden = YES;
                    }];
                }
            } else {
                [self.view endEditing:YES];
            }
        }
            break;
        case edit_info:
            {
                if (indexPath.row == EditAvatar) {
                    [self choosePhotoFromLibrary];
                }
                if (indexPath.row == EditBirthday) {
                    if (self.datePickerView.hidden) {
                        [self.view endEditing:YES];
                        self.datePickerView.hidden = NO;
                        [UIView animateWithDuration:.3 animations:^{
                            
                            self.datePickerView.alpha = 1;
                        } completion:^(BOOL finished) {}];
                    }
                    else {
                        
                        [UIView animateWithDuration:.3 animations:^{
                            
                            self.datePickerView.alpha = 0;
                        } completion:^(BOOL finished) {
                            
                            self.datePickerView.hidden = YES;
                        }];
                    }
                } else {
                    [self.view endEditing:YES];
                }
            }
                break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.typeUser) {
        case register_new:
        {
            if (indexPath.row == RegAvatar) {
                return 80;
            }
            
            if (indexPath.row == RegAboutMe) {
                return 80;
            }
        }
            break;
        case edit_info:
        {
            if (indexPath.row == EditAvatar) {
                return 80;
            }
            
            if (indexPath.row == EditAboutMe) {
                return 80;
            }
        }
            break;
        default:
            return 44;
            break;
    }
    
    return 44;
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
    _avatarImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    // define the block to call when we get the asset based on the url (below)
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
    {
        ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
        NSLog(@"[imageRep filename] : %@", [imageRep filename]);
        avatarImageStr = [imageRep filename];
    };
    
    // get the asset library and fetch the asset based on the ref url (pass in block above)
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:refURL resultBlock:resultblock failureBlock:nil];
    
    // Only do this if our screen did not get unloaded.
    if ([self isViewLoaded]) {
        if (_avatarImage) {
            _didPickImage = YES;
            [self.registerTableView reloadData];
        }
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TextField

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    self.registerTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0);
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.datePickerView.hidden = YES;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:textField.tag inSection:0];
    
    self.registerTableView.contentInset =  UIEdgeInsetsMake(0, 0, 190, 0);
    [self.registerTableView scrollToRowAtIndexPath:indexPath
                                  atScrollPosition:UITableViewScrollPositionBottom
                                          animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:textField.tag inSection:0];
    KLRegisterTableViewCell *cell = (KLRegisterTableViewCell*)[self.registerTableView cellForRowAtIndexPath:indexPath];
    
    switch (self.typeUser) {
        case register_new:
        {
            switch (textField.tag) {
                case RegEmail:
                    _userName = cell.tfInput.text;
                    _email = cell.tfInput.text;
                    break;
                case RegName:
                    _name = cell.tfInput.text;
                    break;
                case RegStudent_id:
                    _studentId = cell.tfInput.text;
                    break;
                case RegFaculty:
                    _faculty = cell.tfInput.text;
                    break;
                case RegAboutMe:
                    _aboutMe = cell.tfInput.text;
                    break;
                case RegPassword:
                    _password = cell.tfInput.text;
                    break;
                case RegRePassword:
                    _repassword = cell.tfInput.text;
                    break;
                default:
                    break;
            }

        }
            break;
        case edit_info:
        {
            switch (textField.tag) {
                case EditName:
                    _name = cell.tfInput.text;
                    break;
                case EditStudent_id:
                    _studentId = cell.tfInput.text;
                    break;
                case EditFaculty:
                    _faculty = cell.tfInput.text;
                    break;
                case EditAboutMe:
                    _aboutMe = cell.tfInput.text;
                    break;
                default:
                    break;
            }
            
        }
            break;
        case change_password:
        {
            switch (textField.tag) {
                case ChangeOldPassword:
                    _oldPassword = cell.tfInput.text;
                    break;
                case ChangePassword:
                    _password = cell.tfInput.text;
                    break;
                case ChangeRePassword:
                    _repassword = cell.tfInput.text;
                    break;
                default:
                    break;
            }
            
        }
            break;
        default:
            break;
    }
    
}

- (void)textFieldDidChange:(UITextField*)textField {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:textField.tag inSection:0];
    KLRegisterTableViewCell *cell = (KLRegisterTableViewCell*)[self.registerTableView cellForRowAtIndexPath:indexPath];
    switch (self.typeUser) {
        case register_new:
        {
            switch (textField.tag) {
                case RegEmail:
                    _userName = cell.tfInput.text;
                    _email = cell.tfInput.text;
                    break;
                case RegName:
                    _name = cell.tfInput.text;
                    break;
                case RegStudent_id:
                    _studentId = cell.tfInput.text;
                    break;
                case RegFaculty:
                    _faculty = cell.tfInput.text;
                    break;
                case RegAboutMe:
                    _aboutMe = cell.tfInput.text;
                    break;
                case RegPassword:
                    _password = cell.tfInput.text;
                    break;
                case RegRePassword:
                    _repassword = cell.tfInput.text;
                    break;
                default:
                    break;
            }
            
        }
            break;
        case edit_info:
        {
            switch (textField.tag) {
                case EditName:
                    _name = cell.tfInput.text;
                    break;
                case EditStudent_id:
                    _studentId = cell.tfInput.text;
                    break;
                case EditFaculty:
                    _faculty = cell.tfInput.text;
                    break;
                case EditAboutMe:
                    _aboutMe = cell.tfInput.text;
                    break;
                default:
                    break;
            }
            
        }
            break;
        case change_password:
        {
            switch (textField.tag) {
                case ChangeOldPassword:
                    _oldPassword = cell.tfInput.text;
                    break;
                case ChangePassword:
                    _password = cell.tfInput.text;
                    break;
                case ChangeRePassword:
                    _repassword = cell.tfInput.text;
                    break;
                default:
                    break;
            }
            
        }
            break;
        default:
            break;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    _aboutMe = textView.text;
}

- (void)textViewDidChange:(UITextView *)textView {
    _aboutMe = textView.text;
}

- (void)keyboardWillShow:(NSNotification *)notifi {
    
}

- (void)keyboardWillHide:(NSNotification *)notifi {
    self.registerTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0);
}
@end
