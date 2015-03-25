//
//  FriendsViewController.m
//  SimpleWeather
//
//  Created by Mac on 3/4/15.
//  Copyright (c) 2015 HungVT. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendTableViewCell.h"
#import "MyPageViewController.h"

@interface FriendsViewController ()  <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation FriendsViewController {
    NSArray *_friendArr;
    NSMutableArray *_searchArr;
    BOOL _isSearch;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setBackButtonWithImage:back_bar_button title:Back_Bar_Title highlightedImage:nil target:self action:@selector(backBarButtonTapped)];
    
    self.title = Friend_Title;
    _tbFriend.delegate = self;
    _tbFriend.dataSource = self;
    
    _isSearch = NO;
    _searchBar.delegate = self;
    _searchArr = [[NSMutableArray alloc] initWithCapacity:10];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[SWUtil appDelegate] hideTabbar:YES];
    [self initData];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[SWUtil appDelegate] hideTabbar:NO];
}

- (void)initData {
    /*
     state = 1; Dang cho accpet cho nguoi gui loi moi ket ban
     state = 2; Dang cho accpet cho nguoi nhan loi moi ket ban
     state = 3; Da la ban be
     */
    [[SWUtil sharedUtil] showLoadingView];
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, uGetFriend];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSDictionary *parameters = @{kUserId: _userId};
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            _friendArr = (NSArray*)responseObject;
        }
        else if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)responseObject;
            int code = [[dict objectForKey:kCode] intValue];
            if (code == 3) {
                [SWUtil showConfirmAlertWithMessage:[dict objectForKey:kMessage] delegate:nil];
                _friendArr = nil;
            }
        }
        [_tbFriend reloadData];
        [[SWUtil sharedUtil] hideLoadingView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SWUtil showConfirmAlert:@"Lỗi!" message:[error localizedDescription] delegate:nil];
        [[SWUtil sharedUtil] hideLoadingView];
    }];
}

- (void)backBarButtonTapped {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didBackToUserPage)]) {
        [self.delegate didBackToUserPage];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isSearch) {
        return _searchArr.count;
    }
    return _friendArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"FriendTableViewCell";
    FriendTableViewCell *cell = (FriendTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"FriendTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    cell.imgCheck.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_isSearch) {
        [cell setDateForCell:[_searchArr objectAtIndex:indexPath.row]];
    } else {
        NSDictionary *dict = [_friendArr objectAtIndex:indexPath.row];
        [cell setDateForCell:dict];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *fUserId = @"";
    NSDictionary *fDict;
    if (_isSearch) {
        fUserId = [[_searchArr objectAtIndex:indexPath.row] objectForKey:@"friend_id"];
        fDict = [_searchArr objectAtIndex:indexPath.row];
    } else {
        fUserId = [[_friendArr objectAtIndex:indexPath.row] objectForKey:@"friend_id"];
        fDict = [_friendArr objectAtIndex:indexPath.row];
    }
    
    MyPageViewController *userPageVC = [[MyPageViewController alloc] init];
    userPageVC.myPageType = UserPage;
    userPageVC.userId = fUserId;
    userPageVC.userDict = fDict;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kHideBackButtonInUserPage];
    [self.navigationController pushViewController:userPageVC animated:YES];
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
        [_tbFriend reloadData];
    } else {
        NSString *text = searchText;
        text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

        if (text.length > 0) {
            _isSearch = YES;
            [_searchArr removeAllObjects];
            for (int i = 0; i < _friendArr.count; i++) {
                NSDictionary *dict = [_friendArr objectAtIndex:i];
                NSString *name = [dict objectForKey:@"name"];
                name = [name lowercaseString];
                name = [SWUtil changeToUnsign:name];

                if (([name rangeOfString:text].location != NSNotFound)) {
                    [_searchArr addObject:dict];

                }
            }
            
            [_tbFriend reloadData];
        }
    }
}

@end
