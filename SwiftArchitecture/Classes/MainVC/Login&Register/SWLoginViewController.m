//
//  SWLoginViewController.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWLoginViewController.h"
#import "SWRegisterViewController.h"
#import "SWDressTimeViewController.h"

@interface SWLoginViewController ()
- (IBAction)loginButtonTapped:(id)sender;

- (IBAction)registerButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UIView *loginView;

@end

@implementation SWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self initData];
}

- (void)initUI{
    self.title = Login_Title;

    self.loginView.layer.borderWidth = 1.0;
    self.loginView.layer.borderColor = [[UIColor colorWithHex:Gray_Color alpha:1.0] CGColor];
    self.loginView.layer.masksToBounds = YES;
    self.loginView.layer.cornerRadius = 5.0;
    
    [self.emailTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
}

- (void)initData{
    
}

- (IBAction)loginButtonTapped:(id)sender {
    [[SWUtil appDelegate] initTabbar];
}

- (IBAction)registerButtonTapped:(id)sender {
    SWRegisterViewController *registerVC = [[SWRegisterViewController alloc] initWithNibName:@"SWRegisterViewController" bundle:nil];
    registerVC.typeUser = register_new;
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
//    float Y;
//    if (SCREEN_HEIGHT_PORTRAIT <= 480) {
//        Y = 5;
//    } else if (SCREEN_HEIGHT_PORTRAIT < 568) {
//        Y = 100;
//    } else {
//        Y = 50;
//    }
//    
//    [UIView animateWithDuration:.3 animations:^{
//        self.contentView.frame = CGRectMake(0, Y, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
//    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
//    [UIView animateWithDuration:.3 animations:^{
//        self.contentView.frame = CGRectMake(0, CONTENT_VIEW_Y, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
//    }];
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
        self.loginButton.enabled = NO;
    } else {
        self.loginButton.enabled = YES;
    }
    
    //TODO: remove
    self.loginButton.enabled = YES;
}

@end
