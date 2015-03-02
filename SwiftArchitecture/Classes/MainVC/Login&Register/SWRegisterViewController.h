//
//  SWRegisterViewController.h
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWBaseViewController.h"

@interface SWRegisterViewController : SWBaseViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (assign, nonatomic) UserType typeUser;
@end
