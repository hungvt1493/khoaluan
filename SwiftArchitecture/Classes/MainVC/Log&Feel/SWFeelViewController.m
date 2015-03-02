//
//  SWFeelViewController.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWFeelViewController.h"
#import "SWUtil.h"
#import "StarRatingControl.h"
#import "SWListLogViewController.h"

#define Message_Alert_Feel @"Cảm ơn đánh giá của bạn!"
#define OK_Button @"OK"

@interface SWFeelViewController (){
    StarRatingControl *skirtRating;
    StarRatingControl *jeanRating;
    StarRatingControl *shoeRating;
}
@property (weak, nonatomic) IBOutlet UITextField *feelTextField;

- (IBAction)sendButtonTapped:(id)sender;

@end

@implementation SWFeelViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self initData];
}

- (void)initUI{
    self.title = Feel_Title;
    [self setBackButtonWithImage:Back_Button highlightedImage:nil target:self action:@selector(backButtonTapped:)];
    self.feelTextField.layer.masksToBounds = YES;
    self.feelTextField.layer.cornerRadius = 5.0;
    self.feelTextField.layer.borderWidth = 1.0;
    self.feelTextField.layer.borderColor = [[UIColor colorWithHex:Gray_Color alpha:1.0] CGColor];
    
    //Init Rating View
   
    skirtRating = [[StarRatingControl alloc] initWithLocation:CGPointMake(130, 175)
                                                                      emptyColor:[UIColor colorWithHex:Red_Color alpha:1.0]
                                                                      solidColor:[UIColor colorWithHex:Red_Color alpha:1.0]
                                                                   initialRating:2
                                                                    andMaxRating:5];
    
    jeanRating = [[StarRatingControl alloc] initWithLocation:CGPointMake(130, 223)
                                                                     emptyColor:[UIColor colorWithHex:Red_Color alpha:1.0]
                                                                     solidColor:[UIColor colorWithHex:Red_Color alpha:1.0]
                                                                           initialRating:2
                                                                            andMaxRating:5];
    shoeRating = [[StarRatingControl alloc] initWithLocation:CGPointMake(130, 271)
                                                                     emptyColor:[UIColor colorWithHex:Red_Color alpha:1.0]
                                                                     solidColor:[UIColor colorWithHex:Red_Color alpha:1.0]
                                                                           initialRating:2
                                                                            andMaxRating:5];
    [self.view addSubview:skirtRating];
    [self.view addSubview:jeanRating];
    [self.view addSubview:shoeRating];
}

- (void)initData{
    
}

- (void)backButtonTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendButtonTapped:(id)sender {
    [SWUtil showConfirmAlert:nil message:Message_Alert_Feel cancelButton:OK_Button otherButton:nil tag:0 delegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[SWUtil appDelegate] hideTabbar:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *keyboardInfo = [notification userInfo];
    CGSize keyboardSize = [[keyboardInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
        [UIView animateWithDuration:.3 animations:^{
            self.view.frame = CGRectMake(0, self.view.frame.origin.y - keyboardSize.height, self.view.bounds.size.width, self.view.bounds.size.height);
        }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary *keyboardInfo = [notification userInfo];
    CGSize keyboardSize = [[keyboardInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
        [UIView animateWithDuration:.3 animations:^{
            self.view.frame = CGRectMake(0, self.view.frame.origin.y + keyboardSize.height, self.view.bounds.size.width, self.view.bounds.size.height);
        }];
}

#pragma mark - TextField

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 0) {
        
        if (buttonIndex == 0) {
            NSArray *viewControllers = [self.navigationController viewControllers];
            for (UIViewController *controller in viewControllers) {
                if ([controller isKindOfClass:[SWListLogViewController class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
                    break;
                }
            }
        }
    }
}


@end
