//
//  SWRegisterViewController.h
//  KhoaLuan2015
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Hung VT. All rights reserved.
//

#import "SWBaseViewController.h"

@interface SWRegisterViewController : SWBaseViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (assign, nonatomic) UserType typeUser;
@end
