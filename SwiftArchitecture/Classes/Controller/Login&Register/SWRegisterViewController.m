//
//  SWRegisterViewController.m
//  KhoaLuan2015
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWRegisterViewController.h"
#import "KLRegisterTableViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define DATE_FORMAT @"dd/MM/yyyy"

#define CONTENT_VIEW_Y 20
#define Register_Arr @[@"Ảnh đại diện",@"Email\n(Tên đăng nhập)",@"Tên",@"Giới tính",@"Ngày sinh",@"Mã sinh viên",@"Khoa",@"Mật khẩu",@"Nhắc lại mật khẩu"]
#define Avatar 0
#define Email 1
#define Name 2
#define Gender 3
#define Birthday 4
#define Student_id 5
#define Faculty 6
#define Password 7
#define Re_Password 8

@interface SWRegisterViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIButton *maleButton;
    UIButton *femaleButton;
    UITextField *registerTextField;
    NSString *birthdayString;
    UIImagePickerController *imagePicker;
    UIImage *avatarImage;
    BOOL didPickImage;
    
    NSString *userName;
    NSString *password;
    NSString *repassword;
    NSString *email;
    NSString *name;
    NSNumber *birthday;
    NSInteger gender;
    NSString *faculty;
    NSString *studentId;
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
    [self initUI];
    [self initData];
    didPickImage = NO;
}

- (void)initUI{
    
    self.datePickerView.hidden = YES;
    self.datePickerView.alpha = 0;
    
    [self setBackButtonWithImage:back_bar_button highlightedImage:nil target:self action:@selector(backButtonTapped:)];
    switch (self.typeUser) {
        case register_new:
        {
            self.title = Register_Title;
            [self.registerButton setTitle:Register_Title forState:UIControlStateNormal];
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
    
    birthdayString = _dateString;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:Birthday inSection:0];
    
    birthday = [SWUtil convertDateToNumber:_chosenDate];
    
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
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, uReg];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"username": email,
                                 @"password": password,
                                 @"email"   : email,
                                 @"name"    : name,
                                 @"birthday": NULL_IF_NIL(birthday),
                                 @"gender"  : [NSNumber numberWithInteger:gender],
                                 @"faculty" : NULL_IF_NIL(faculty),
                                 @"student_id" : NULL_IF_NIL(studentId),
                                 @"avatar" : NULL_IF_NIL(avatarImage)};

    
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = (NSDictionary*)responseObject;
        
        NSInteger code = [[dict objectForKey:@"code"] integerValue];
        if (code > 1) {
            [SWUtil showConfirmAlert:@"Lỗi!" message:[dict objectForKey:@"message"] delegate:nil];
        }
        
        if (code == 1) {
            [SWUtil showConfirmAlertWithMessage:@"Đăng ký thành công" delegate:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        NSLog(@"Reg JSON: %@", dict);
        [[SWUtil sharedUtil] hideLoadingView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SWUtil showConfirmAlert:@"Lỗi!" message:[error localizedDescription] delegate:nil];
        [[SWUtil sharedUtil] hideLoadingView];
    }];
}

- (void)maleButtonTapped:(id)sender{
    [self setButton:femaleButton andBackground:Button_bg andTitleColor:Black_Color];
    [self setButton:maleButton andBackground:Button_bg_Selected andTitleColor:White_Color];
    
    gender = 1;
}

- (void)femaleButtonTapped:(id)sender{
    [self setButton:maleButton andBackground:Button_bg andTitleColor:Black_Color];
    [self setButton:femaleButton andBackground:Button_bg_Selected andTitleColor:White_Color];
    gender = 0;
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
                switch (tf.tag) {
                    case Name:
                    {
                        if (![self isValidName:text]) {
                            errorMessage = Name_Message;
                        }
                    }
                        break;

                    case Email:
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
                    case Password:
                    {
                        passWord = text;
                        if (![self isValidPassword:text]) {
                            errorMessage = Password_Message;
                        }
                    }
                        break;
                    case Re_Password:
                    {
                        if (![text isEqualToString:passWord]) {
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
    return self.registerArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell-Index%ld",(long)indexPath.row];
    UITableViewCell *cellDefault = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cellDefault) {
    
        cellDefault = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cellDefault.textLabel.text = [self.registerArray objectAtIndex:indexPath.row];
        cellDefault.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    KLRegisterTableViewCell *cell = (KLRegisterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KLRegisterTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    switch (indexPath.row) {
        case Avatar:
        {
            if (didPickImage) {
                cellDefault.imageView.image = avatarImage;
            } else {
                cellDefault.imageView.image = [UIImage imageNamed:@"default-avatar"];
            }
            cellDefault.separatorInset = UIEdgeInsetsZero;
            return cellDefault;
        }
        case Email:
        {
            cell.lblTitle.font = [UIFont systemFontOfSize:15];
            cell.tfInput.text = email;
        }
            break;
        case Name:
        {
            cell.tfInput.text = name;
        }
            break;

        case Gender:
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
            
            [self maleButtonTapped:nil];
        }
            break;
        case Birthday:
        {
            cell.tfInput.enabled = NO;
            cell.tfInput.hidden = YES;
            UILabel *birthdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 7, 160, 30)];
            birthdayLabel.text = birthdayString;
            birthdayLabel.textAlignment = NSTextAlignmentRight;
            cell.accessoryView = birthdayLabel;
        }
            break;
        case Password:
        {
            cell.tfInput.secureTextEntry = YES;
            cell.tfInput.text = password;
        }
        case Re_Password:
        {
            cell.lblTitle.font = [UIFont systemFontOfSize:15];
            cell.tfInput.secureTextEntry = YES;
            cell.tfInput.text = repassword;
        }
            break;
            
        default:
            break;
    }
    
    cell.lblTitle.text = [self.registerArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tfInput.delegate = self;
    cell.tfInput.tag = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == Avatar) {
        [self choosePhotoFromLibrary];
    }
    if (indexPath.row == Birthday) {
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80;
    }
    return 44;
}

- (void)choosePhotoFromLibrary
{
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    avatarImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    // define the block to call when we get the asset based on the url (below)
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
    {
        ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
        NSLog(@"[imageRep filename] : %@", [imageRep filename]);
    };
    
    // get the asset library and fetch the asset based on the ref url (pass in block above)
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:refURL resultBlock:resultblock failureBlock:nil];
    
    // Only do this if our screen did not get unloaded.
    if ([self isViewLoaded]) {
        if (avatarImage) {
            didPickImage = YES;
            [self.registerTableView reloadData];
        }
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    imagePicker = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    imagePicker = nil;
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
    switch (textField.tag) {
        case Email:
            userName = cell.tfInput.text;
            email = cell.tfInput.text;
            break;
        case Name:
            name = cell.tfInput.text;
            break;
        case Birthday:
            name = cell.tfInput.text;
            break;
        case Student_id:
            studentId = cell.tfInput.text;
            break;
        case Faculty:
            faculty = cell.tfInput.text;
            break;
        case Password:
            password = cell.tfInput.text;
            break;
        case Re_Password:
            repassword = cell.tfInput.text;
            break;
        default:
            break;
    }
}

- (void)keyboardWillShow:(NSNotification *)notifi {
    
}

- (void)keyboardWillHide:(NSNotification *)notifi {
    self.registerTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0);
}
@end
