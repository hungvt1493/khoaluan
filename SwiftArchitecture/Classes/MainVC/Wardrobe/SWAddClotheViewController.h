//
//  SWAddClotheViewController.h
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWBaseViewController.h"

@interface SWAddClotheViewController : SWBaseViewController<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, assign) TableViewType typeTableView;
@property (nonatomic, assign) TypeCategory typeCategory;

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@end
