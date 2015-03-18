//
//  SWLoginViewController.m
//  KhoaLuan2015
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Hung VT. All rights reserved.
//

#import "SWLoginViewController.h"
#import "SWRegisterViewController.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import "KeychainItemWrapper.h"
#import <Security/Security.h>

@interface SWLoginViewController ()
- (IBAction)loginButtonTapped:(id)sender;
- (IBAction)forgotPasswordButtonTapped:(id)sender;

- (IBAction)registerButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnForgotPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet UIImageView *imgAutoLogin;

- (IBAction)btnAutoLoginTapped:(id)sender;
@end

@implementation SWLoginViewController {
    BOOL _isAutoLoginChecked;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self initData];
    
    [self.emailTextField addTarget:self
                                 action:@selector(disableLoginbutton)
                       forControlEvents:UIControlEventEditingChanged];
    [self.passWordTextField addTarget:self
                                 action:@selector(disableLoginbutton)
                       forControlEvents:UIControlEventEditingChanged];
    
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:kKeyChain accessGroup:nil];

    NSString *password = [keychainItem objectForKey:(__bridge id)kSecValueData];
    NSString *username = [keychainItem objectForKey:(__bridge id)kSecAttrAccount];
    
    if (username.length > 0 && ![username isEqual:[NSNull null]]) {
        if (password.length > 0 && ![password isEqual:[NSNull null]]) {
            self.emailTextField.text = username;
            self.passWordTextField.text = password;
            _isAutoLoginChecked = YES;
            [_imgAutoLogin setImage:[UIImage imageNamed:checked]];
            [self loginButtonTapped:nil];
        }
    }
    
    [self disableLoginbutton];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (void)initUI{
    self.title = Login_Title;
    
    _btnLogin.layer.borderColor = [[UIColor colorWithHex:Blue_Color alpha:1.0] CGColor];
    _btnLogin.layer.borderWidth = 1.0;
    _btnLogin.layer.cornerRadius = 5.0;
    
    _btnForgotPassword.layer.borderColor = [[UIColor colorWithHex:Blue_Color alpha:1.0] CGColor];
    _btnForgotPassword.layer.borderWidth = 1.0;
    _btnForgotPassword.layer.cornerRadius = 5.0;
    
    _btnRegister.layer.borderColor = [[UIColor colorWithHex:Blue_Color alpha:1.0] CGColor];
    _btnRegister.layer.borderWidth = 1.0;
    _btnRegister.layer.cornerRadius = 5.0;
    
    [self.emailTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
}

- (void)initData{
    
}

- (IBAction)loginButtonTapped:(id)sender {
    [[SWUtil sharedUtil] showLoadingView];
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityRef address = SCNetworkReachabilityCreateWithName(NULL, "www.google.com" );
    Boolean success = SCNetworkReachabilityGetFlags(address, &flags);
    CFRelease(address);
    
    bool canReachOnExistingConnection =     success
    && !(flags & kSCNetworkReachabilityFlagsConnectionRequired)
    && (flags & kSCNetworkReachabilityFlagsReachable);
    
    if( canReachOnExistingConnection ) {
        NSLog(@"Network available");
        
        NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, uLogin];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        NSDictionary *parameters = @{@"username": self.emailTextField.text,
                                     @"password": self.passWordTextField.text};

        [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(_isAutoLoginChecked == NO)
            {
                KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:kKeyChain accessGroup:nil];
                [keychainItem resetKeychainItem];
            }
            else
            {
                KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:kKeyChain accessGroup:nil];
//                NSString *password = [keychainItem objectForKey:(__bridge id)kSecValueData];
//                NSString *username = [keychainItem objectForKey:(__bridge id)kSecAttrAccount];
                
//                if (username.length == 0 || [username isEqualToString:@""]) {
//                    if (password.length == 0 || [password isEqualToString:@""]) {
                        [keychainItem setObject:self.passWordTextField.text forKey:(__bridge id)kSecValueData];
                        [keychainItem setObject:self.emailTextField.text forKey:(__bridge id)kSecAttrAccount];
//                    }
//                }
            }
            
            NSDictionary *userDict = (NSDictionary*)responseObject;
            
            NSString *avatarUrl = EMPTY_IF_NULL_OR_NIL([userDict objectForKey:kAvatar]);
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            if (avatarUrl.length > 0) {
                [userDefault setObject:avatarUrl forKey:kAvatar];
            }
            
            [userDefault setObject:[userDict objectForKey:kUserId] forKey:kUserId];
            [userDefault setObject:[userDict objectForKey:kIsAdmin] forKey:kIsAdmin];
            [userDefault setObject:[userDict objectForKey:kUserName] forKey:kUserName];
            [userDefault setObject:EMPTY_IF_NULL_OR_NIL([userDict objectForKey:kStudentId]) forKey:kStudentId];
            [userDefault setInteger:[[userDict objectForKey:kBirthDay] integerValue] forKey:kBirthDay];
            [userDefault setObject:EMPTY_IF_NULL_OR_NIL([userDict objectForKey:kFaculty]) forKey:kFaculty];
            [userDefault setObject:[userDict objectForKey:kName] forKey:kName];
            [userDefault setObject:EMPTY_IF_NULL_OR_NIL([userDict objectForKey:kTimelineImage]) forKey:kTimelineImage];
            [userDefault setObject:[userDict objectForKey:kGender] forKey:kGender];
            [userDefault setObject:EMPTY_IF_NULL_OR_NIL([userDict objectForKey:kAboutMe]) forKey:kAboutMe];
            [userDefault setObject:EMPTY_IF_NULL_OR_NIL([userDict objectForKey:kEmail]) forKey:kEmail];

            [[SWUtil appDelegate] initTabbar];

            NSLog(@"LOGIN JSON: %@", responseObject);
            [[SWUtil sharedUtil] hideLoadingView];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [SWUtil showConfirmAlert:@"Lỗi!" message:@"Tên đăng nhập hoặc mật khẩu không đúng" delegate:nil];
            [[SWUtil sharedUtil] hideLoadingView];
        }];
    } else {
        NSLog(@"Network not available");
        [SWUtil showConfirmAlert:@"Lỗi!" message:@"Yêu cầu kết nối mạng để đăng nhập" delegate:nil];
        [[SWUtil sharedUtil] hideLoadingView];
    }
}

- (IBAction)forgotPasswordButtonTapped:(id)sender {
}

- (IBAction)registerButtonTapped:(id)sender {
    SWRegisterViewController *registerVC = [[SWRegisterViewController alloc] initWithNibName:@"SWRegisterViewController" bundle:nil];
    registerVC.typeUser = register_new;
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGRect frame = self.contentView.frame;
    frame.origin.y = 0;
    self.contentView.frame = frame;
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disableLoginbutton) name:UITextFieldTextDidChangeNotification object:nil];
    
    //[self.emailTextField becomeFirstResponder];
    [self disableLoginbutton];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect frame = self.contentView.frame;
    frame.origin.y = -70;
    self.contentView.frame = frame;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGRect frame = self.contentView.frame;
    frame.origin.y = 0;
    self.contentView.frame = frame;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self disableLoginbutton];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    [self disableLoginbutton];
}

- (void)disableLoginbutton {
    if (self.emailTextField.text.length == 0 || self.passWordTextField.text.length == 0) {
        self.btnLogin.enabled = NO;
    } else {
        self.btnLogin.enabled = YES;
    }
}

- (IBAction)btnAutoLoginTapped:(id)sender {
    if (_isAutoLoginChecked) {
        [_imgAutoLogin setImage:[UIImage imageNamed:unchecked]];
    } else {
        [_imgAutoLogin setImage:[UIImage imageNamed:checked]];
    }
    _isAutoLoginChecked = !_isAutoLoginChecked;
}
@end
