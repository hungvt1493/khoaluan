//
//  SWMultiSelectContactViewController.m
//  SwiftArchitecture
//
//  Created by Mac on 1/20/15.
//  Copyright (c) 2015 Nguyen Thu Ly. All rights reserved.
//

#import "SWMultiSelectContactViewController.h"
#import "SWContact.h"
#define TITLE_HEIGHT 64

@interface SWMultiSelectContactViewController ()

@end

@implementation SWMultiSelectContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    for (NSArray *contact in _listContact) {
        
        for (SWContact *contactObj in contact) {
            
            contactObj.isSelected = NO;
        }
    }
    _selectedCount = 0;
    [_selectedContact  removeAllObjects];
    [self updateUI];
    
    isSearching = NO;
    [_contactTable reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [_searchText resignFirstResponder];
}

- (void)keyboardDidShow:(NSNotification *)notifi {
    
    if (!_keyboardReadyShow) {
        
        CGRect rect = _contactTable.frame;
        rect.size.height = rect.size.height - 216;
        [UIView animateWithDuration:0.3 animations:^{
            
            _contactTable.frame = rect;
        }];
        _keyboardReadyShow = YES;
    }
}

- (void)keyboardWillHide:(NSNotification *)notifi {
    
    if (_keyboardReadyShow) {
        
        CGRect rect = _contactTable.frame;
        rect.size.height = rect.size.height + 216;
        [UIView animateWithDuration:0.3 animations:^{
            
            _contactTable.frame = rect;
        }];
        _keyboardReadyShow = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Select contacts";
    // Do any additional setup after loading the view.
    
    //Create UI--
    _contentView.frame = CGRectMake(0, -TITLE_HEIGHT,SCREEN_WIDTH_PORTRAIT , _contentView.bounds.size.height);
    [self.view addSubview:_contentView];
    
    shareBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(sharePressed:)];
    [shareBtn setTintColor:[UIColor whiteColor]];
    [self.navigationItem setRightBarButtonItem:nil];
    
    [_searchText addTarget:self action:@selector(filterContentForSearchText:) forControlEvents:UIControlEventEditingChanged];
    
    //Cretate DataSource--
    _selectedContact = [[NSMutableArray alloc]initWithCapacity:0];
    _filteredListContact = [[NSMutableArray alloc]initWithCapacity:0];
    [self createDataSource];
    
    [_searchText setKeyboardAppearance:UIKeyboardAppearanceDark];
}

- (void)sharePressed:(id)sender {}

#pragma mark -- Query Data

- (void)createDataSource {
    
    /*
     * Setup data sample here, replace with your data when using in your project.
     */

    NSString *pathPlist = [[NSBundle mainBundle] pathForResource:@"ContactSample" ofType:@".plist"];
    NSArray *contacts = [NSArray arrayWithContentsOfFile:pathPlist];
    NSMutableArray *dataTems = [[NSMutableArray alloc]init];
    for (NSString *contactName in contacts) {
        
        SWContact *contact = [[SWContact alloc]init];
        contact.fullName = contactName;
        contact.isSelected = NO;
        
        [dataTems addObject:contact];
    }
    
    _listContact = [self sectionForDataSource:dataTems];
    [_contactTable reloadData];
}

/*
 * This method will be split datasource from |Array| to Dictionary
 */
- (NSMutableArray *)sectionForDataSource:(NSMutableArray *)inputArray {
    
    NSMutableArray *result = [[NSMutableArray alloc]initWithCapacity:0];
    
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    
    // Thanks Steph-Fongo!
    SEL sorter = ABPersonGetSortOrdering() == kABPersonSortByFirstName ? NSSelectorFromString(@"sorterFirstName") : NSSelectorFromString(@"sorterLastName");
    
    for (SWContact *contact in inputArray) {
        
        NSInteger sect = [theCollation sectionForObject:contact collationStringSelector:sorter];
        contact.sectionNumber = sect;
    }
    
    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i <= highSection; i++) {
        
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    for (SWContact *contact in inputArray) {
        
        if (contact.fullName == nil)
            continue;
        [(NSMutableArray *)[sectionArrays objectAtIndex:contact.sectionNumber] addObject:contact];
    }
    
    for (NSMutableArray *sectionArray in sectionArrays) {
        
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:sorter];
        [result addObject:sortedSection];
    }
    
    return result;
}

#pragma mark -
#pragma mark ContentFiltering

- (void)filterContentForSearchText:(UITextField*)searchText
{
    if (searchText.text.length == 0) {
        
        isSearching = NO;
    }
    else{
        
        isSearching = YES;
        [_filteredListContact removeAllObjects];
        
        for (NSArray *section in _listContact) {
            
            for (SWContact *contact in section) {
                
                NSRange result = [contact.fullName rangeOfString:searchText.text options:NSCaseInsensitiveSearch];
                if (result.location != NSNotFound)
                {
                    [_filteredListContact addObject:contact];
                }
            }
        }
    }
    
    [_contactTable reloadData];
}


#pragma Reload UI when user select or deselect a contact.
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [_searchText resignFirstResponder];
    _searchText.text = @"";
    isSearching = NO;
    [_contactTable reloadData];
    
    return YES;
}

- (void)updateUI {
    
    _numberSelected.text = [NSString stringWithFormat:@"%lu/%lu",(unsigned long)_selectedCount,(unsigned long)[_listContact count]];
    
    NSString *names = @"";
    for (SWContact *contact in self.selectedContact) {
        
        names = [names stringByAppendingString:[NSString stringWithFormat:@"%@,",contact.fullName]];
    }
    if (names.length) {
        
        _selectedText.text = [names substringToIndex:names.length - 1];
    }
    else {
        
        _selectedText.text = names;
    }
    
    //Update frame for TableView
    
    if (_selectedCount == 0) {
        
        CGRect tableFrame = CGRectMake(0, 105, SCREEN_WIDTH_PORTRAIT, _contentView.bounds.size.height - 105);
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _contentView.frame = CGRectMake(0, -TITLE_HEIGHT, SCREEN_WIDTH_PORTRAIT, _contentView.bounds.size.height);
            _contactTable.frame = tableFrame;
        }];
        [self.navigationItem setRightBarButtonItem:nil];
    }
    else {
        
        CGRect tableFrame = CGRectMake(0, 105, SCREEN_WIDTH_PORTRAIT, _contentView.bounds.size.height - 105 - TITLE_HEIGHT);
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH_PORTRAIT, _contentView.bounds.size.height);
            _contactTable.frame = tableFrame;
        }];
        
        [self.navigationItem setRightBarButtonItem:shareBtn];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (isSearching == YES) {
        
        return nil;
    } else {
        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:
                [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (isSearching == YES) {
        
        return 1;
	} else {
        
        return [_listContact count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (isSearching == YES) {
        
        return nil;
    } else {
        
        return [[_listContact objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (isSearching == YES) {
     
        return 0;
    }
    return [[_listContact objectAtIndex:section] count] ? tableView.sectionHeaderHeight : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (isSearching == YES) {
        
        return [_filteredListContact count];
    } else {
        
        return [[_listContact objectAtIndex:section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCustomCellID = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCustomCellID];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *imgiew = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        imgiew.image = [UIImage imageNamed:@"swift_contact_icon"];
        [cell setAccessoryView:imgiew];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectButton setFrame:CGRectMake(10.0,8, 28, 28)];
        [selectButton setBackgroundImage:[UIImage imageNamed:@"icon_unselect.png"] forState:UIControlStateNormal];
        [selectButton setBackgroundImage:[UIImage imageNamed:@"icon_selected.png"] forState:UIControlStateSelected];
        selectButton.tag = 10;
        [cell addSubview:selectButton];
        
        UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(50,7, 200, 30)];
        lblName.backgroundColor = [UIColor clearColor];
        lblName.font = [UIFont systemFontOfSize:16];
        lblName.tag = 20;
        [cell addSubview:lblName];
	}
    
	SWContact *contact = nil;
	if (isSearching == YES) {
        
        contact = (SWContact *)[_filteredListContact objectAtIndex:indexPath.row];
    }
	else {
        
        contact = (SWContact *)[[_listContact objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    
    //Setting image for check button.
    UIButton *checkBtn = (UIButton *)[cell viewWithTag:10];
    [checkBtn setSelected:contact.isSelected];
    [checkBtn setUserInteractionEnabled:NO];
    
    UILabel *lblName = (UILabel *)[cell viewWithTag:20];
    if ([[contact.fullName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
        lblName.text = contact.fullName;
    } else {
        
        lblName.text = @"No Name";
    }
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SWContact *contact = nil;
	if (isSearching == YES) {
        
        contact = (SWContact *)[_filteredListContact objectAtIndex:indexPath.row];
    }
	else {
        
        contact = (SWContact *)[[_listContact objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    
    if (contact.isSelected) {
        
        contact.isSelected = NO;
        _selectedCount = _selectedCount - 1;
        [self.selectedContact removeObject:contact];
    }
    else {
        
        if (_selectedCount >= 10) {
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You can't select over 10 contacts" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            
            return;
        }
        else {
            
            contact.isSelected = YES;
            _selectedCount = _selectedCount + 1;
            [self.selectedContact addObject:contact];
        }
    }
    _searchText.text = @"";
    isSearching = NO;
    [_contactTable reloadData];
    [_contactTable deselectRowAtIndexPath:indexPath animated:YES];
    
    [_searchText resignFirstResponder];
    
    [self updateUI];
}


@end
