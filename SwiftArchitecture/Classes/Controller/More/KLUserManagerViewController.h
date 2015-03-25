//
//  KLUserManagerViewController.h
//  KhoaLuan2015
//
//  Created by Mac on 3/25/15.
//  Copyright (c) 2015 Hung Vuong. All rights reserved.
//

#import "SWBaseViewController.h"

typedef enum {
    Choose = 0,
    EditUser
}RightBarButtonType;

@interface KLUserManagerViewController : SWBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tbUserManager;

@end
