//
//  KLPostNewsViewController.m
//  KhoaLuan2015
//
//  Created by Mac on 3/13/15.
//  Copyright (c) 2015 Hung Vuong. All rights reserved.
//

#import "KLPostNewsViewController.h"

@interface KLPostNewsViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewChoosePostType;
@property (weak, nonatomic) IBOutlet UITextView *tvContent;
@property (weak, nonatomic) IBOutlet UIView *datePickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UITextField *tfEventTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPostType;
@property (weak, nonatomic) IBOutlet UIButton *btnChoosePostType;
@property (weak, nonatomic) IBOutlet UIView *viewEventOption;

- (IBAction)btnChooseDateTapped:(id)sender;
- (IBAction)hiddenDatePickerButtonTapped:(id)sender;
- (IBAction)completedDateButtonTapped:(id)sender;
- (IBAction)btnStatusPostTapped:(id)sender;
- (IBAction)btnEventPostTapped:(id)sender;
- (IBAction)btnChoosePostTypeTapped:(id)sender;

@end

@implementation KLPostNewsViewController {
    PostType _postType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _viewChoosePostType.hidden = YES;
    self.title = Update_Status_Title;
    self.datePickerView.hidden = YES;
    [_tvContent becomeFirstResponder];
    [self setBackButtonWithImage:back_bar_button title:Back_Bar_Title highlightedImage:nil target:self action:@selector(backBarButtonTapped)];
    [self setRightButtonWithImage:nil title:Post_News_Title highlightedImage:nil target:self action:@selector(btnPostNewsTapped)];
    
    [[SWUtil appDelegate] hideTabbar:YES];
    
    _postType = status;
    [self setType:_postType];
    
    BOOL isAdmin = [[NSUserDefaults standardUserDefaults] valueForKey:kIsAdmin];
    _btnChoosePostType.enabled = isAdmin;
}

- (void)backBarButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnPostNewsTapped {
    if (_postType == event) {
        if (_tfEventTitle.text.length == 0) {
            [SWUtil showConfirmAlertWithMessage:Post_Event_No_Title_Error delegate:nil];
        }
        if (_lblTime.text.length == 0) {
            [SWUtil showConfirmAlertWithMessage:Post_Event_No_Time_Error delegate:nil];
        }
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[SWUtil appDelegate] hideTabbar:NO];
}

- (IBAction)btnChooseDateTapped:(id)sender {

    if (self.datePickerView.hidden) {
        [self.view endEditing:YES];
        self.datePickerView.hidden = NO;
        [UIView animateWithDuration:.3 animations:^{
            
            self.datePickerView.alpha = 1;
        } completion:^(BOOL finished) {}];
    }
}

- (IBAction)hiddenDatePickerButtonTapped:(id)sender {
    [_tvContent becomeFirstResponder];
    [UIView animateWithDuration:.3 animations:^{
        
        self.datePickerView.alpha = 0;
    } completion:^(BOOL finished) {
        
        self.datePickerView.hidden = YES;
    }];
}

- (IBAction)completedDateButtonTapped:(id)sender {
    [_tvContent becomeFirstResponder];
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
    
    self.lblTime.text = _dateString;
}

- (IBAction)btnStatusPostTapped:(id)sender {
    _postType = status;
    self.title = Update_Status_Title;
    UIButton *button = (UIButton*)sender;
    self.lblPostType.text = button.titleLabel.text;
    
    [_viewChoosePostType setFrame:CGRectMake(_viewChoosePostType.frame.origin.x, 41, _viewChoosePostType.frame.size.width, _viewChoosePostType.frame.size.height)];
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         [_viewChoosePostType setFrame:CGRectMake(_viewChoosePostType.frame.origin.x, 41 - _viewChoosePostType.frame.size.height, _viewChoosePostType.frame.size.width, _viewChoosePostType.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         _viewChoosePostType.hidden = YES;
                     }];
    [self setType:_postType];
}

- (IBAction)btnEventPostTapped:(id)sender {
    _postType = event;
    self.title = Create_Event_Title;
    UIButton *button = (UIButton*)sender;
    self.lblPostType.text = button.titleLabel.text;
    
    [_viewChoosePostType setFrame:CGRectMake(_viewChoosePostType.frame.origin.x, 41, _viewChoosePostType.frame.size.width, _viewChoosePostType.frame.size.height)];
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         [_viewChoosePostType setFrame:CGRectMake(_viewChoosePostType.frame.origin.x, 41 - _viewChoosePostType.frame.size.height, _viewChoosePostType.frame.size.width, _viewChoosePostType.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         _viewChoosePostType.hidden = YES;
                     }];
    [self setType:_postType];
}

- (IBAction)btnChoosePostTypeTapped:(id)sender {
    if (_viewChoosePostType.hidden) {
        [_viewChoosePostType setFrame:CGRectMake(_viewChoosePostType.frame.origin.x, 41 - _viewChoosePostType.frame.size.height, _viewChoosePostType.frame.size.width, _viewChoosePostType.frame.size.height)];
        _viewChoosePostType.hidden = NO;
        [UIView animateWithDuration:0.3f
                         animations:^{
                             [_viewChoosePostType setFrame:CGRectMake(_viewChoosePostType.frame.origin.x, 41, _viewChoosePostType.frame.size.width, _viewChoosePostType.frame.size.height)];
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        
    } else{
        [_viewChoosePostType setFrame:CGRectMake(_viewChoosePostType.frame.origin.x, 41, _viewChoosePostType.frame.size.width, _viewChoosePostType.frame.size.height)];
        
        [UIView animateWithDuration:0.3f
                         animations:^{
                             
                             [_viewChoosePostType setFrame:CGRectMake(_viewChoosePostType.frame.origin.x, 41 - _viewChoosePostType.frame.size.height, _viewChoosePostType.frame.size.width, _viewChoosePostType.frame.size.height)];
                         }
                         completion:^(BOOL finished) {
                             _viewChoosePostType.hidden = YES;
                         }];
    }

}

- (void)setType:(PostType)type {
    switch (type) {
        case status:
        {
            _viewEventOption.hidden = YES;
            CGRect tvFrame = _tvContent.frame;
            tvFrame.origin.y = _viewEventOption.frame.origin.y;
            _tvContent.frame = tvFrame;
        }
            break;
        case event:
        {
            _viewEventOption.hidden = NO;
            CGRect tvFrame = _tvContent.frame;
            tvFrame.origin.y = _viewEventOption.frame.origin.y + _viewEventOption.frame.size.height + 2;
            _tvContent.frame = tvFrame;
        }
            break;
        default:
            break;
    }
}
@end
