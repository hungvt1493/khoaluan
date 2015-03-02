//
//  SWMultiSelectContactViewController.h
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface SWMultiSelectContactViewController : UIViewController
{
    IBOutlet UIView *_contentView;
    IBOutlet UITextView *_selectedText;
    IBOutlet UITableView *_contactTable;
    IBOutlet UITextField *_searchText;
    IBOutlet UILabel *_numberSelected;
    UIBarButtonItem *shareBtn;
    
    //Var
    NSUInteger _selectedCount;
    BOOL isSearching;
    BOOL _keyboardReadyShow;
}
@property(nonatomic,strong) NSMutableArray *listContact;
@property(nonatomic,strong) NSMutableArray *filteredListContact;
@property(nonatomic,strong) NSMutableArray *selectedContact;
@end
