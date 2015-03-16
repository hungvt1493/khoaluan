//
//  KLPostNewsViewController.h
//  KhoaLuan2015
//
//  Created by Mac on 3/13/15.
//  Copyright (c) 2015 Hung Vuong. All rights reserved.
//

#import "SWBaseViewController.h"

@interface KLPostNewsViewController : SWBaseViewController

@property (assign, nonatomic) PageType pageType;
@property (assign, nonatomic) PostType postType;
@property (weak, nonatomic) IBOutlet UIView *viewChoosePostType;
@property (weak, nonatomic) IBOutlet UITextView *tvContent;
@property (weak, nonatomic) IBOutlet UIView *datePickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UITextField *tfEventTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPostType;
@property (weak, nonatomic) IBOutlet UIButton *btnChoosePostType;
@property (weak, nonatomic) IBOutlet UIView *viewEventOption;
@property (assign, nonatomic) NSInteger newsId;
@property (strong, nonatomic) NSString *contentStr;
@property (strong, nonatomic) NSString *eventTitleStr;
@property (strong, nonatomic) NSString *timeStr;

- (void)setType:(PostType)type ;
@end
