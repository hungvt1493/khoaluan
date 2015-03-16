//
//  KLPostNewsViewController.m
//  KhoaLuan2015
//
//  Created by Mac on 3/13/15.
//  Copyright (c) 2015 Hung Vuong. All rights reserved.
//

#import "KLPostNewsViewController.h"

@interface KLPostNewsViewController ()
@property (strong, nonatomic)NSDate *selectedDate;

- (IBAction)btnChooseDateTapped:(id)sender;
- (IBAction)hiddenDatePickerButtonTapped:(id)sender;
- (IBAction)completedDateButtonTapped:(id)sender;
- (IBAction)btnStatusPostTapped:(id)sender;
- (IBAction)btnEventPostTapped:(id)sender;
- (IBAction)btnChoosePostTypeTapped:(id)sender;

@end

@implementation KLPostNewsViewController {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _viewChoosePostType.hidden = YES;
    self.datePickerView.hidden = YES;
    [_tvContent becomeFirstResponder];
    [self setBackButtonWithImage:back_bar_button title:Back_Bar_Title highlightedImage:nil target:self action:@selector(backBarButtonTapped)];
    
    if (_pageType == add) {
        [self setRightButtonWithImage:nil title:Post_News_Title highlightedImage:nil target:self action:@selector(btnPostNewsTapped)];
    } else if (_pageType == edit) {
        [self setRightButtonWithImage:nil title:Edit_News_Title highlightedImage:nil target:self action:@selector(btnEditNewsTapped)];
    }
    
    if (_postType == status) {
        self.title = Update_Status_Title;
        self.lblPostType.text = @"Trạng thái";
    } else {
        self.title = Create_Event_Title;
        self.lblPostType.text = @"Sự kiện";
    }
    
    [[SWUtil appDelegate] hideTabbar:YES];
    
    BOOL isAdmin = [[NSUserDefaults standardUserDefaults] valueForKey:kIsAdmin];
    _btnChoosePostType.enabled = isAdmin;
    
    [self setType:_postType];
    _tvContent.text = _contentStr;
    _lblTime.text = _timeStr;
    _tfEventTitle.text = _eventTitleStr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[SWUtil appDelegate] hideTabbar:NO];
}

- (void)backBarButtonTapped {
    if (_tvContent.text.length > 0) {
        [SWUtil showConfirmAlert:Post_Status_Are_You_Sure_Warning_Title message:Post_Status_Are_You_Sure_Warning_Message cancelButton:@"Đóng" otherButton:@"Xác nhận" tag:111 delegate:self];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)btnPostNewsTapped {
    if (_postType == event) {
        if (_tfEventTitle.text.length == 0) {
            [SWUtil showConfirmAlertWithMessage:Post_Event_No_Title_Error delegate:nil];
            return;
        }
        if (_lblTime.text.length == 0) {
            [SWUtil showConfirmAlertWithMessage:Post_Event_No_Time_Error delegate:nil];
            return;
        }
    }
    
    if (_tvContent.text.length == 0) {
        [SWUtil showConfirmAlertWithMessage:Post_Status_No_Content_Error delegate:nil];
        return;
    }
    
    [self.view endEditing:YES];
    
    [[SWUtil sharedUtil] showLoadingView];
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, nPostNews];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
    NSDictionary *parameters = @{@"content"             : NULL_IF_NIL(_tvContent.text),
                                 @"user_id"             : userId,
                                 @"number_of_image"     : [NSNumber numberWithInteger:0],
                                 @"news_event_title"    : NULL_IF_NIL(_tfEventTitle.text),
                                 @"type"                : [NSNumber numberWithInteger:_postType],
                                 @"event_time"          : ((_postType == event) ? [SWUtil convertDateToNumber:_selectedDate] : [NSNumber numberWithInteger:0])};
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = (NSDictionary*)responseObject;
         [[SWUtil sharedUtil] hideLoadingView];
        [[SWUtil sharedUtil] showLoadingViewWithTitle:Post_News_Success_Title];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDidPostNews];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDidPostMyPage];
        
        [self performSelector:@selector(postSuccessAction) withObject:nil afterDelay:1.0 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        
        NSLog(@"POST NEWS JSON: %@", dict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SWUtil showConfirmAlert:@"Lỗi!" message:[error localizedDescription] delegate:nil];
        [[SWUtil sharedUtil] hideLoadingView];
    }];
}

- (void)btnEditNewsTapped {
    if (_postType == event) {
        if (_tfEventTitle.text.length == 0) {
            [SWUtil showConfirmAlertWithMessage:Post_Event_No_Title_Error delegate:nil];
            return;
        }
        if (_lblTime.text.length == 0) {
            [SWUtil showConfirmAlertWithMessage:Post_Event_No_Time_Error delegate:nil];
            return;
        }
    }
    
    if (_tvContent.text.length == 0) {
        [SWUtil showConfirmAlertWithMessage:Post_Status_No_Content_Error delegate:nil];
        return;
    }
    
    [self.view endEditing:YES];
    
    [[SWUtil sharedUtil] showLoadingView];
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, nEditNews];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
    NSDictionary *parameters = @{kNewsId                : [NSNumber numberWithInteger:_newsId],
                                 @"content"             : NULL_IF_NIL(_tvContent.text),
                                 @"user_id"             : userId,
                                 @"number_of_image"     : [NSNumber numberWithInteger:0],
                                 @"news_event_title"    : NULL_IF_NIL(_tfEventTitle.text),
                                 @"type"                : [NSNumber numberWithInteger:_postType],
                                 @"event_time"          : ((_postType == event) ? [SWUtil convertDateToNumber:_selectedDate] : [NSNumber numberWithInteger:0])};
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [[SWUtil sharedUtil] hideLoadingView];
        [[SWUtil sharedUtil] showLoadingViewWithTitle:Edit_News_Success_Title];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDidPostNews];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDidPostMyPage];
        
        [self performSelector:@selector(postSuccessAction) withObject:nil afterDelay:1.0 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        
        NSLog(@"Edit News Id: %d success", (int)_newsId);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SWUtil showConfirmAlert:@"Lỗi!" message:[error localizedDescription] delegate:nil];
        [[SWUtil sharedUtil] hideLoadingView];
        NSLog(@"Edit News Id: %d faild", (int)_newsId);
    }];
}

- (void)postSuccessAction {
    [self.navigationController popViewControllerAnimated:YES];
    [[SWUtil sharedUtil] hideLoadingView];
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
    NSDate *_currentDate = [NSDate date];
    NSDate *_chosenDate = [self.datePicker date];
    if ([_currentDate timeIntervalSince1970] > [_chosenDate timeIntervalSince1970]) {
        [SWUtil showConfirmAlertWithMessage:Date_Warning_Title delegate:nil];
    } else {
        [_tvContent becomeFirstResponder];
        [UIView animateWithDuration:.3 animations:^{
            
            self.datePickerView.alpha = 0;
        } completion:^(BOOL finished) {
            
            self.datePickerView.hidden = YES;
        }];
        
        NSString *_dateString;
        
        NSDateFormatter *_dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:FULL_DATE_FORMAT];
        _dateString = [_dateFormatter stringFromDate:_chosenDate];
        _selectedDate = _chosenDate;
        self.lblTime.text = _dateString;
    }
    
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
