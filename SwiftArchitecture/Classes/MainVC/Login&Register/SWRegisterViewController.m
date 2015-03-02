//
//  SWRegisterViewController.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWRegisterViewController.h"

#define CONTENT_VIEW_Y 20
#define Register_Arr @[@"Họ",@"Tên",@"Giới tính",@"Năm sinh",@"Chiều cao",@"Cân nặng",@"Số điện thoại",@"Email",@"Mật khẩu",@"Nhắc lại mật khẩu"]
#define First_Name 0
#define Last_Name 1
#define Gender 2
#define Birthday 3
#define Height 4
#define Weight 5
#define Telephone 6
#define Email 7
#define Password 8
#define Re_Password 9

@interface SWRegisterViewController ()
{
    UIButton *maleButton;
    UIButton *femaleButton;
    UITextField *registerTextField;
}
@property (strong, nonatomic) NSArray *registerArray;
@property (weak, nonatomic) IBOutlet UITableView *registerTableView;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

- (IBAction)registerButtonTapped:(id)sender;

@end

@implementation SWRegisterViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[SWUtil appDelegate] hideTabbar:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self initData];
}

- (void)initUI{
    [self setBackButtonWithImage:Back_Button highlightedImage:nil target:self action:@selector(backButtonTapped:)];
    switch (self.typeUser) {
        case register_new:
        {
            self.title = Register_Title;
            [self.registerButton setTitle:Register_Button forState:UIControlStateNormal];
        }
            break;
        case edit_infor:
        {
            self.title = InforUser_Title;
            [self setRightButtonWithImage:Edit highlightedImage:nil target:self action:@selector(editButtonTapped:)];
            self.registerTableView.userInteractionEnabled = NO;
            [self.registerButton setTitle:Complete_Button forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (void)initData{
    self.registerArray = Register_Arr;
}

- (void)backButtonTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editButtonTapped:(id)sender{
    self.registerTableView.userInteractionEnabled = YES;
}

- (IBAction)registerButtonTapped:(id)sender {
    NSString *errorMessage = [self validateForm];
    if (errorMessage) {
        [[[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        return;
    }
}

- (void)maleButtonTapped:(id)sender{
    [self setButton:femaleButton andBackground:Button_bg andTitleColor:Black_Color];
    [self setButton:maleButton andBackground:Button_bg_Selected andTitleColor:White_Color];
}

- (void)femaleButtonTapped:(id)sender{
    [self setButton:maleButton andBackground:Button_bg andTitleColor:Black_Color];
    [self setButton:femaleButton andBackground:Button_bg_Selected andTitleColor:White_Color];
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
    return (passWord.length >= 5);
}

- (BOOL)isValidName:(NSString *)name {
    
    if (name.length == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (NSString *)validateForm {
    NSString *errorMessage;
    NSString *passWord;
    
    for (int i = 0; i < 10; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = (UITableViewCell*)[self.registerTableView cellForRowAtIndexPath:indexPath];
        
        for (UIView *subview in cell.subviews) {
            if ([subview isKindOfClass:[UITextField class]]) {
                UITextField *tf = (UITextField*)subview;
                NSString *text = tf.text;
                switch (tf.tag) {
                    case First_Name:
                    {
                        if (![self isValidName:text]) {
                            errorMessage = First_Name_Message;
                        }
                    }
                        break;
                    case Last_Name:
                    {
                        if (![self isValidName:text]) {
                            errorMessage = Last_Name_Message;
                        }
                    }
                        break;
                    case Height:
                    {
                        if (![self isValidName:text]) {
                            errorMessage = Height_Message;
                        }
                    }
                        break;
                    case Weight:
                    {
                        if (![self isValidName:text]) {
                            errorMessage = Weight_Message;
                        }
                    }
                        break;
                    case Telephone:
                    {
                        if (![self isValidTelephoneNumber:text]) {
                            errorMessage = Telephone_Message;
                        }
                    }
                        break;
                    case Email:
                    {
                        if (![self isValidEmail:text ]) {
                            errorMessage = Email_Message;
                        }
                    }
                        break;
                    case Password:
                    {
                        passWord = registerTextField.text;
                        if (![self isValidPassword:text]) {
                            errorMessage = Password_Message;
                        }
                    }
                        break;
                    case Re_Password:
                    {
                        if (![registerTextField.text isEqualToString:passWord]) {
                            errorMessage = Re_Password_Message;
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell-Index%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    switch (indexPath.row) {
        case First_Name:
        case Last_Name:
        case Telephone:
        case Email:
        {
            registerTextField = [[UITextField alloc] initWithFrame:CGRectMake(50 , 3, 220, 30)];
            registerTextField.tag = indexPath.row;
            [cell addSubview:registerTextField];
            registerTextField.borderStyle = UITextBorderStyleNone;
            registerTextField.textAlignment = NSTextAlignmentRight;
            registerTextField.contentVerticalAlignment = UIControlContentHorizontalAlignmentRight;
            registerTextField.delegate = self;
        }
            break;
            
        case Height:
        case Weight:
        {
            registerTextField = [[UITextField alloc] initWithFrame:CGRectMake(50 , 3, 220, 30)];
            registerTextField.tag = indexPath.row;
            [cell addSubview:registerTextField];
            registerTextField.borderStyle = UITextBorderStyleNone;
            registerTextField.textAlignment = NSTextAlignmentRight;
            registerTextField.contentVerticalAlignment = UIControlContentHorizontalAlignmentRight;
            registerTextField.delegate = self;
        }
            break;
        case Gender:
        {
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
        }
            break;
        case Birthday:
            
            break;
        case Password:
        case Re_Password:
        {
            registerTextField = [[UITextField alloc] initWithFrame:CGRectMake(160 , 3, 130, 30)];
            registerTextField.tag = indexPath.row;
            [cell addSubview:registerTextField];
            registerTextField.borderStyle = UITextBorderStyleNone;
            registerTextField.contentVerticalAlignment = UIControlContentHorizontalAlignmentRight;
            registerTextField.textAlignment = NSTextAlignmentRight;
            registerTextField.secureTextEntry = YES;
            registerTextField.delegate = self;

        }
            break;
            
        default:
            break;
    }
    cell.textLabel.text = [self.registerArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
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
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:textField.tag inSection:0];
    self.registerTableView.contentInset =  UIEdgeInsetsMake(0, 0, 250, 0);
    [self.registerTableView scrollToRowAtIndexPath:indexPath
                                                           atScrollPosition:UITableViewScrollPositionTop
                                                                   animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.registerTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0);
}
@end
