//
//  KLUserManagerViewController.m
//  KhoaLuan2015
//
//  Created by Mac on 3/25/15.
//  Copyright (c) 2015 Hung Vuong. All rights reserved.
//

#import "KLUserManagerViewController.h"
#import "FriendTableViewCell.h"
#import "MyPageViewController.h"
#import "IBActionSheet.h"

@interface KLUserManagerViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, IBActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation KLUserManagerViewController{
    NSArray *_userArr;
    NSMutableArray *_searchArr;
    BOOL _isSearch;
    
    RightBarButtonType _rightBarButtonType;
    
    NSMutableArray *_selectedUser;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _tbUserManager.delegate = self;
    _tbUserManager.dataSource = self;
    _selectedUser = [[NSMutableArray alloc] initWithCapacity:10];
    _isSearch = NO;
    _searchBar.delegate = self;
    _searchArr = [[NSMutableArray alloc] initWithCapacity:10];
    
    [self setBackButtonWithImage:back_bar_button title:Back_Bar_Title highlightedImage:nil target:self action:@selector(backBarButtonTapped)];
    
    [self setRightBarButtonType:Choose];
}

- (void)backBarButtonTapped {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[SWUtil appDelegate] hideTabbar:YES];
    [self initData];
    self.navigationController.navigationBarHidden = NO;
    
    [self initData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[SWUtil appDelegate] hideTabbar:NO];
}

- (void)setRightBarButtonType:(RightBarButtonType)type {
    _rightBarButtonType = type;
    switch (type) {
        case Choose:
        {
            [self setRightButtonWithImage:nil title:@"Chọn" highlightedImage:nil target:self action:@selector(chooseUserMode)];
        }
            break;
        case EditUser:
        {
            [self setRightButtonWithImage:nil title:@"Sửa" highlightedImage:nil target:self action:@selector(editUserMode)];
        }
            break;
        default:
            break;
    }
}

- (void)chooseUserMode {
    [self setRightBarButtonType:EditUser];
}

- (void)editUserMode {
    if (_selectedUser.count > 0) {
        IBActionSheet *actionSheet = [[IBActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Đóng"
                                                   destructiveButtonTitle:nil
                                                   otherButtonTitlesArray:@[@"Chuyển thành tài khoản Admin", @"Chuyển thành tài khoản thường"]];
        [actionSheet showInView:self.view];
    } else {
        [SWUtil showConfirmAlert:@"Bạn chưa chọn tài khoản nào" message:nil delegate:nil];
    }
}

-(void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [[SWUtil appDelegate] hideTabbar:NO];
    int isAdmin = 0;
    switch (buttonIndex) {
        case 0: // Admin
        {
            isAdmin = 1;
        }
            break;
        case 1: // User
        {
            isAdmin = 0;
        }
            break;
        default:
            break;
    }
    
    [[SWUtil sharedUtil] showLoadingView];
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, uUpdateIsAdmin];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *usersIdStr = @"";
    for (int i = 0; i< _selectedUser.count; i++) {
        NSString *str = [_selectedUser objectAtIndex:i];
        usersIdStr = [usersIdStr stringByAppendingString:str];
        
        if (i < _selectedUser.count-1) {
            usersIdStr = [usersIdStr stringByAppendingString:@","];
        }
    }
    
    NSDictionary *parameters = @{@"is_admin"        : [NSNumber numberWithInt:isAdmin],
                                 @"users_id"             : usersIdStr};
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = (NSDictionary*)responseObject;
        [[SWUtil sharedUtil] hideLoadingView];
        NSInteger code = [[dict objectForKey:@"code"] integerValue];
        if (code == 0) {
            [SWUtil showConfirmAlert:@"Lỗi!" message:[dict objectForKey:@"message"] delegate:nil];
        }
        
        if (code == 1) {
            [SWUtil showConfirmAlertWithMessage:@"Thành công" delegate:nil];
            [_selectedUser removeAllObjects];
            [self initData];
            [self setRightBarButtonType:Choose];
        }
        
        NSLog(@"POST NEWS JSON: %@", dict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SWUtil showConfirmAlert:@"Lỗi!" message:[error localizedDescription] delegate:nil];
        [[SWUtil sharedUtil] hideLoadingView];
    }];
}

- (void)initData {
    [[SWUtil sharedUtil] showLoadingView];
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, uGetAllUser];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
    NSDictionary *parameters = @{kUserId: userId};
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            _userArr = (NSArray*)responseObject;
        }
        else if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)responseObject;
            int code = [[dict objectForKey:kCode] intValue];
            if (code == 3) {
                [SWUtil showConfirmAlertWithMessage:[dict objectForKey:kMessage] delegate:nil];
                _userArr = nil;
            }
        }
        [_tbUserManager reloadData];
        [[SWUtil sharedUtil] hideLoadingView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SWUtil showConfirmAlert:@"Lỗi!" message:[error localizedDescription] delegate:nil];
        [[SWUtil sharedUtil] hideLoadingView];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isSearch) {
        return _searchArr.count;
    }
    return _userArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"FriendTableViewCell";
    FriendTableViewCell *cell = (FriendTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"FriendTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict;
    if (_isSearch) {
        dict = [_searchArr objectAtIndex:indexPath.row];
        
    } else {
        dict = [_userArr objectAtIndex:indexPath.row];
    }
    [cell setDateForCell:dict];
    cell.userId = [dict objectForKey:kUserId];
    
    if ([_selectedUser containsObject:cell.userId]) {
        cell.imgCheck.hidden = NO;
    } else {
        cell.imgCheck.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_rightBarButtonType == EditUser) {
        FriendTableViewCell *cell = (FriendTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        if ([_selectedUser containsObject:cell.userId]) {
            [_selectedUser removeObject:cell.userId];
        } else {
            [_selectedUser addObject:cell.userId];
        }
        
        [tableView beginUpdates];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [tableView endUpdates];
        
    } else {
        NSString *fUserId = @"";
        NSDictionary *fDict;
        if (_isSearch) {
            fUserId = [[_searchArr objectAtIndex:indexPath.row] objectForKey:@"friend_id"];
            fDict = [_searchArr objectAtIndex:indexPath.row];
        } else {
            fUserId = [[_userArr objectAtIndex:indexPath.row] objectForKey:@"friend_id"];
            fDict = [_userArr objectAtIndex:indexPath.row];
        }
        
        MyPageViewController *userPageVC = [[MyPageViewController alloc] init];
        userPageVC.myPageType = UserPage;
        userPageVC.userId = fUserId;
        userPageVC.userDict = fDict;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kHideBackButtonInUserPage];
        [self.navigationController pushViewController:userPageVC animated:YES];

    }
    
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - SearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        _isSearch = NO;
        [_tbUserManager reloadData];
    } else {
        NSString *text = searchText;
        text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if (text.length > 0) {
            _isSearch = YES;
            [_searchArr removeAllObjects];
            for (int i = 0; i < _userArr.count; i++) {
                NSDictionary *dict = [_userArr objectAtIndex:i];
                NSString *name = [dict objectForKey:@"name"];
                name = [name lowercaseString];
                name = [SWUtil changeToUnsign:name];
                
                if (([name rangeOfString:text].location != NSNotFound)) {
                    [_searchArr addObject:dict];
                    
                }
            }
            
            [_tbUserManager reloadData];
        }
    }
}

@end
