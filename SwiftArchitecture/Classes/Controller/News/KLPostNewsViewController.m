//
//  KLPostNewsViewController.m
//  KhoaLuan2015
//
//  Created by Mac on 3/13/15.
//  Copyright (c) 2015 Hung Vuong. All rights reserved.
//

#import "KLPostNewsViewController.h"
#import "KLImageViewInPostContent.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SNAlbumTVC.h"
#import "SNImagePickerNC.h"
#import "AFURLSessionManager.h"

@interface KLPostNewsViewController () <SNImagePickerDelegate, KLImageViewInPostContentDelegate, UIScrollViewDelegate>
@property (strong, nonatomic)NSDate *selectedDate;
@property (weak, nonatomic) IBOutlet UIView *viewType;

- (IBAction)btnChooseDateTapped:(id)sender;
- (IBAction)hiddenDatePickerButtonTapped:(id)sender;
- (IBAction)completedDateButtonTapped:(id)sender;
- (IBAction)btnStatusPostTapped:(id)sender;
- (IBAction)btnEventPostTapped:(id)sender;
- (IBAction)btnChoosePostTypeTapped:(id)sender;

@end

@implementation KLPostNewsViewController {
    UIView *inputAccView;
    UIButton *btnCamera;
    SNImagePickerNC *imagePickerNavigationController;
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
    
    BOOL isAdmin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsAdmin];
    _btnChoosePostType.enabled = isAdmin;
    
    [self setType:_postType];
    _tvContent.text = _contentStr;
    _lblTime.text = _timeStr;
    _tfEventTitle.text = _eventTitleStr;
    _imgScrollView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[SWUtil appDelegate] hideTabbar:YES];
    if (_imgArr.count > 0) {
        [self initScrollUI];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[SWUtil appDelegate] hideTabbar:NO];
}

- (void)removeNavigationBarAnimation {
    self.navigationController.scrollNavigationBar.scrollView = nil;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect frame = self.tvContent.frame;
    if (_imgArr.count == 0) {
        if (_postType == status) {
            frame.size.height = SCREEN_HEIGHT_PORTRAIT - HEIGHT_STATUSBAR - HEIGHT_NAVBAR - _viewType.bounds.size.height - keyboardRect.size.height;
        } else {
            frame.size.height = SCREEN_HEIGHT_PORTRAIT - HEIGHT_STATUSBAR - HEIGHT_NAVBAR - _viewType.bounds.size.height - _viewEventOption.bounds.size.height - keyboardRect.size.height;
        }
    } else {
        frame.size.height = 80;
    }
    self.tvContent.frame = frame;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGRect frame = self.tvContent.frame;
    if (_imgArr.count == 0) {
        if (_postType == status) {
            frame.size.height = SCREEN_HEIGHT_PORTRAIT - HEIGHT_STATUSBAR - HEIGHT_NAVBAR - _viewType.bounds.size.height;
        } else {
            frame.size.height = SCREEN_HEIGHT_PORTRAIT - HEIGHT_STATUSBAR - HEIGHT_NAVBAR - _viewType.bounds.size.height - _viewEventOption.bounds.size.height;
        }
    } else {
        frame.size.height = 80;
    }
    
    self.tvContent.frame = frame;
}

-(UIView *)inputAccessoryView{
    if (!inputAccView) {
        inputAccView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH_PORTRAIT, 40.0)];
        [inputAccView setBackgroundColor:UIColorFromRGB(0xf7f8f6)];
        [inputAccView setAlpha: 1.0f];
        
        
        
        btnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCamera setFrame:CGRectMake(0, 0.0f, 60.0f, 40.0f)];
        [btnCamera setImage:[UIImage imageNamed:@"Screenshot-grey"] forState:UIControlStateNormal];
        [btnCamera addTarget:self action:@selector(choosePhotoFromLibrary) forControlEvents:UIControlEventTouchUpInside];
        
        [inputAccView addSubview:btnCamera];
        
    }
    
    return inputAccView;
}

- (void)choosePhotoFromLibrary
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SNPicker" bundle:nil];
    imagePickerNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"ImagePickerNC"];
    [imagePickerNavigationController setModalPresentationStyle:UIModalPresentationFullScreen];
    imagePickerNavigationController.imagePickerDelegate = self;
    imagePickerNavigationController.pickerType = kPickerTypePhoto;
    [self.navigationController presentViewController:imagePickerNavigationController animated:YES completion:^{ }];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SNImageDelegate
- (void)imagePicker:(SNImagePickerNC *)imagePicker didFinishPickingWithMediaInfo:(NSMutableArray *)info
{
    if (!_imgArr) {
        _imgArr = [[NSMutableArray alloc] initWithCapacity:10];
    }
    if (!_imgNameArr) {
        _imgNameArr = [[NSMutableArray alloc] initWithCapacity:10];
    }
    
    for (int i = 0; i < info.count; i++) {
        ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
        [assetLibrary assetForURL:[info objectAtIndex:i]
                      resultBlock:^(ALAsset *imageAsset) {
                          ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
                          UIImage *image = [UIImage imageWithCGImage:[imageAsset aspectRatioThumbnail]];
                          NSString *imageName = [imageRep filename];
                          if (![_imgArr containsObject:image]) {
                              [_imgArr addObject:image];
                          }
                          if (![_imgNameArr containsObject:imageName]) {
                              [_imgNameArr addObject:imageName];
                          }
                          if (i == info.count-1) {
                              [self initScrollUI];
                          }
                      } failureBlock:^(NSError *error) {     }];
        
    }
    
}

- (void)imagePickerDidCancel:(SNImagePickerNC *)imagePicker
{
    [_tvContent becomeFirstResponder];
}

- (void)initScrollUI {
    for (KLImageViewInPostContent *subview in _imgScrollView.subviews) {
        [subview removeFromSuperview];
    }
    if (_imgArr.count > 0) {
        [_tvContent resignFirstResponder];
        _imgScrollView.hidden = NO;
        
        CGRect frame = _tvContent.frame;
        frame.size.height = 80;
        _tvContent.frame = frame;
        
        CGRect scrollFrame = _imgScrollView.frame;
        scrollFrame.origin.y = frame.origin.y + frame.size.height;
        scrollFrame.size.height = self.view.bounds.size.height - frame.origin.y - frame.size.height - 3;
        _imgScrollView.frame = scrollFrame;
        
        int yPos = 0;
        
        for (int i = 0; i < _imgArr.count; i++) {
            
            KLImageViewInPostContent *itemView = [[KLImageViewInPostContent alloc] initWithFrame:CGRectZero];
            itemView.index = i;
            itemView.imgView.image = [_imgArr objectAtIndex:i];
            CGRect frame = [itemView frame];
            frame.origin.y = yPos;
            yPos += frame.size.height;
            frame.size.width = SCREEN_WIDTH_PORTRAIT;
            [itemView setFrame:frame];
            
            [_imgScrollView addSubview:itemView];
            itemView.delegate = self;
        }
        _imgScrollView.delegate = self;
        CGSize contentSize = [_imgScrollView contentSize];
        contentSize.height= yPos+ 10;
        [_imgScrollView setContentSize:contentSize];
    } else {
        [_tvContent becomeFirstResponder];
        _imgScrollView.hidden = YES;
    }
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - KLImageViewInPostContentDelegate
- (void)didDeleteImageAtIndex:(NSInteger)index {
    [_imgArr removeObjectAtIndex:index];
    [_imgNameArr removeObjectAtIndex:index];
    [self initScrollUI];
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
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
    NSDictionary *parameters = @{@"content"             : NULL_IF_NIL(_tvContent.text),
                                 @"user_id"             : userId,
                                 @"news_event_title"    : NULL_IF_NIL(_tfEventTitle.text),
                                 @"type"                : [NSNumber numberWithInteger:_postType],
                                 @"event_time"          : ((_postType == event) ? [SWUtil convertDateToNumber:_selectedDate] : [NSNumber numberWithInteger:0])};
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    
    AFHTTPRequestOperation *op = [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int i = 0; i<_imgArr.count; i++) {
            NSData *imageData = UIImageJPEGRepresentation([_imgArr objectAtIndex:i], 1);
            [formData appendPartWithFileData:imageData name:@"images[]" fileName:[_imgNameArr objectAtIndex:i] mimeType:@"image/jpeg"];
        }
    }
    success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    [op start];
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
    
    if (_postType == notifi) {
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
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
    NSDictionary *parameters = @{kNewsId                : [NSNumber numberWithInteger:_newsId],
                                 @"content"             : NULL_IF_NIL(_tvContent.text),
                                 @"user_id"             : userId,
                                 @"number_of_image"     : [NSNumber numberWithInteger:0],
                                 @"news_event_title"    : NULL_IF_NIL(_tfEventTitle.text),
                                 @"type"                : [NSNumber numberWithInteger:_postType],
                                 @"event_time"          : ((_postType == event) ? [SWUtil convertDateToNumber:_selectedDate] : [NSNumber numberWithInteger:0])};
    
    AFHTTPRequestOperation *op = [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int i = 0; i<_imgArr.count; i++) {
            NSData *imageData = UIImageJPEGRepresentation([_imgArr objectAtIndex:i], 1);
            [formData appendPartWithFileData:imageData name:@"images[]" fileName:[_imgNameArr objectAtIndex:i] mimeType:@"image/jpeg"];
        }
    }
    success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    [op start];
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
    _tfEventTitle.placeholder = @"Tên sự kiện";
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

- (IBAction)btnNotiTapped:(id)sender {
    _postType = notifi;
    self.title = Create_Noti_Title;
    _tfEventTitle.placeholder = @"Thông báo";
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
        case notifi:
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
