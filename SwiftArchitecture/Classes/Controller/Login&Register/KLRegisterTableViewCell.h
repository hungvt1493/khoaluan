//
//  KLRegisterTableViewCell.h
//  KhoaLuan2015
//
//  Created by Mac on 3/11/15.
//  Copyright (c) 2015 Hung Vuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLRegisterTableViewCell : UITableViewCell 
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextField *tfInput;
@property (weak, nonatomic) IBOutlet UITextView *tvInput;

- (void)setHeightForCell:(NSInteger)height;
@end
