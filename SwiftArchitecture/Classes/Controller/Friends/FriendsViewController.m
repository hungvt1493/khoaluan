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

@interface FriendsViewController ()  <UITableViewDataSource, UITableViewDelegate>

@end

@implementation FriendsViewController {
    NSArray *_friendArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setBackButtonWithImage:back_bar_button title:Back_Bar_Title highlightedImage:nil target:self action:@selector(backBarButtonTapped)];
    
    self.title = Friend_Title;
    _tbFriend.delegate = self;
    _tbFriend.dataSource = self;
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _friendArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"FriendTableViewCell";
    FriendTableViewCell *cell = (FriendTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"FriendTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setDateForCell:[_friendArr objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *newsUserId = [[_friendArr objectAtIndex:indexPath.row] objectForKey:@"user_id"];
    MyPageViewController *userPageVC = [[MyPageViewController alloc] init];
    userPageVC.myPageType = UserPage;
    userPageVC.userId = newsUserId;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kHideBackButtonInUserPage];
    [self.navigationController pushViewController:userPageVC animated:YES];
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

@end
